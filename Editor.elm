module Editor where

import Array
import Dict
import Graphics.Input as Input
import Maybe
import Mouse
import String
import Window

import Constants (..)
import Utils (..)

-- Model --

{- Itch : Right now, it seems there isn't great ways to handle multiple
          input signals other than merging them and doing case analysis,
          which doesn't scale very well and is tantamount to reimplementing
          an update loop. Are there better solutions? Is Elm planning to
          move in a direction that will make this kind of UI easier to
          develop?
-}
data Update = HitTile (Int, Int) | BrushClick Int

data Layer = Level1 | Level2

type World = { level1: Array.Array Int, level2: Array.Array Int }
type Editor = { layer: Layer, selectedBrush: Int, world: World }
type Game = {}
type State = { editor: Editor, game: Game, playing: Bool }

initialWorld : World
initialWorld = { level1 = Array.initialize (gridSize * gridSize) (always 0),
                 level2 = Array.initialize (gridSize * gridSize) (always 0)
               }

initialEditor : Editor
initialEditor = { layer = Level1,
                  selectedBrush = 0,
                  world = initialWorld
                }

initialGame : Game
initialGame = { }

initialState : State
initialState = { editor = initialEditor,
                 game = initialGame,
                 playing = False
               }

-- col == x
colFromIndex : Int -> Int
colFromIndex index = index % gridSize

-- row == y
rowFromIndex : Int -> Int
rowFromIndex index = index // gridSize

toIndex x y = x + y * gridSize

-- Update --

hoveredTile (x, y) =
    ((x - (viewSize // 2) - gridOffset + (tileSize // 2)) // tileSize,
     ((viewSize // 2) - y - gridOffset + (tileSize // 2)) // tileSize)

inGrid : (Int, Int) -> Bool
inGrid (x, y) = 0 <= x && x < gridSize && 0 <= y && y < gridSize

{- Feature request : Should be able to do
                     { editor.world | something <- something }
-}
stepAnyClick editor (x, y) =
    let i = toIndex x y
    in if inGrid (x, y)
        then let newLevel = Array.set i editor.selectedBrush editor.world.level1
                 editorWorld = editor.world
                 newWorld = { editorWorld | level1 <- newLevel }
             in
                 { editor | world <- newWorld }
        else editor

brushClick editor brushId =
    { editor | selectedBrush <- brushId }

stepEditor : Update -> Editor -> Editor
stepEditor input editor =
    case input of
        HitTile (x, y) -> stepAnyClick editor (hoveredTile (x, y))
        BrushClick brushId -> brushClick editor brushId

step : Update -> State -> State
step input state = if state.playing then
                       state
                   else { state | editor <- stepEditor input state.editor }

-- Display --

brushChooser : Input.Input Int
brushChooser = Input.input 0

{- Bug : Repeated parameter names gives unhelpful error message.
   "Cannot read property 'make' of undefined
    Open the developer console for more details." (nothing in console)
-}
borderRectElement : Int -> Int -> Color -> Float -> Element
borderRectElement w h color thickness =
    let thinLine = (solid color)
        thickLine = { thinLine | width <- thickness }
    in  collage w h [outlined thickLine (rect (toFloat w) (toFloat h))]

wrapBox : Int -> Element -> Element
wrapBox size elem = flow outward [container size size topLeft elem,
                                  borderRectElement size size black 8.0,
                                  borderRectElement size size white 6.0,
                                  borderRectElement size size black 2.0]

brushesList : Int -> [Element]
brushesList selectedBrush =
    Dict.toList graphicsTiles
    |> map (\ (brushId, brushPath) ->
                (if selectedBrush == brushId then
                     wrapBox tileSize (image tileSize tileSize brushPath)
                 else
                     image tileSize tileSize brushPath)
                |> Input.clickable brushChooser.handle brushId
           )

renderBrushes editor = flow right (brushesList editor.selectedBrush)

{- Bug : We shouldn't need to do explicit conversion to
         floats according to the docs, this seems to be a bug.
   Bug : Operator precedence is wrong. * does not have higher precedence than +
-}
tile : Int -> Int -> Form
tile index val = image tileSize tileSize (Dict.getOrFail val graphicsTiles)
                 |> toForm
                 |> moveInt (tileSize * (colFromIndex index),
                             tileSize * (rowFromIndex index))
                 |> gridOffsetMove

tiles {level1, level2} =
    [square (toFloat viewSize) |> filled lightBlue] ++
    (Array.indexedMap tile level1 |> Array.toList) ++
    (Array.indexedMap tile level2 |> Array.toList)

renderEditor editor = collage viewSize viewSize (tiles editor.world)

-- Main --

{- Itch : Figuring out how to do something upon a mouse click is not obvious,
          but quite important. Should make more intuitive or improve docs.
-}
mouseClicks = sampleOn Mouse.clicks Mouse.position

mouseTileFolder : (Int, Int) -> (Bool, (Int, Int)) -> (Bool, (Int, Int))
mouseTileFolder newPos (_, oldPos) =
    let newTile = hoveredTile newPos
        oldTile = hoveredTile oldPos
    in
        (newTile /= oldTile && (inGrid newTile), newPos)

mouseTileChanged =
    let invalid = (-1, -1)
        base = (False, invalid)
    in  Mouse.position
        |> keepWhen Mouse.isDown invalid
        |> foldp mouseTileFolder base
        |> keepIf (\ (changed, pos) -> changed) base
        |> lift (\ (changed, pos) -> pos)

mouseInput = merge mouseClicks mouseTileChanged
input = merge (HitTile <~ mouseInput)
              (BrushClick <~ brushChooser.signal)

{- Itch : A typo like state.isPlaying instead of state.playing gives
          a very unhelpful error message.
-}
main : Signal Element
main = let stateSignal = foldp step initialState input
           do state = if state.playing then
                          empty
                      else
                          foldr below empty
                                [renderBrushes state.editor,
                                 spacer 50 50,
                                 renderEditor state.editor]
       in
           do <~ stateSignal

{- Bug : I don't think collage should have the origin somewhere in the center.
         There should be more docs about how collage works.
-}

{- Feature request : Easy way to print the type of something.
   Feature request : Search by function type.
   Feature request : Elm library search should not be limited to current
                     subdirectory (although it could prioritize it).
-}