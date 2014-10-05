import Array
import Dict
import Graphics.Input as Input
import Maybe
import Mouse
import String
import Window

-- Utils --

moveInt : (Int, Int) -> Form -> Form 
moveInt (x, y) obj = move (toFloat x, toFloat y) obj

-- Constants --
tileSize : Int
tileSize = 50

gridSize : Int
gridSize = 4

gridOffset : Int
gridOffset = -tileSize * (gridSize // 2)

gridOffsetMove obj = moveInt (gridOffset, gridOffset) obj

graphicsNames = map (String.append "graphics/Base pack/Tiles/") 
                    ["sandCenter.png", 
                     "grassLeft.png",
                     "grassMid.png",
                     "grassRight.png",
                     "box.png"]
graphicsTiles = zip [0..(length graphicsNames - 1)] graphicsNames 
                |> Dict.fromList

viewSize = gridSize * 50 * 3 // 2

-- Model --

{- Itch : Right now, it seems there isn't great ways to handle multiple
          input signals other than merging them and doing case analysis,
          which doesn't scale very well and is tantamount to reimplementing
          an update loop. Are there better solutions? Is Elm planning to
          move in a direction that will make this kind of UI easier to
          develop?
-}
data Update = AnyClick (Int, Int) | BrushClick Int

data Layer = Level1 | Level2

world = { level1 = Array.initialize (gridSize * gridSize) (always 0),
          level2 = Array.initialize (gridSize * gridSize) (always Nothing)
        }

editor = { layer = Level1,
           selectedBrush = 0,
           world = world
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

inGrid x y = 0 <= x && x < gridSize && 0 <= y && y < gridSize

{- Feature request : Should be able to do 
                     { editor.world | something <- something }
-}
stepAnyClick editor (x, y) = 
    let i = toIndex x y
    in if inGrid x y 
        then let newLevel = Array.set i editor.selectedBrush editor.world.level1
                 editorWorld = editor.world
                 newWorld = { editorWorld | level1 <- newLevel }
             in  
                 { editor | world <- newWorld }
        else editor

brushClick editor brushId =
    { editor | selectedBrush <- brushId }


step input editor =
    case input of
        AnyClick (x, y) -> stepAnyClick editor (hoveredTile (x, y))
        BrushClick brushId -> brushClick editor brushId

-- Display --

brushChooser : Input.Input Int
brushChooser = Input.input 0

{- Bug : Repeated parameter names gives unhelpful error message. 
   "Cannot read property 'make' of undefined
    Open the developer console for more details." (nothing in console)
-}
borderRectElement : Int -> Int -> Element
borderRectElement w h = 
    let thinLine = (solid white)
        thickLine = { thinLine | width <- 5.0 }
    in  collage w h [outlined thickLine (rect (toFloat w) (toFloat h))]

wrapBox : Int -> Element -> Element
wrapBox size elem = flow outward [container size size topLeft elem,
                                  borderRectElement size size]

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

tileMaybe : Int -> Maybe Int -> Maybe Form
tileMaybe index val = Maybe.map (\ v -> tile index v) val

tiles {level1, level2} = 
    (Array.indexedMap tile level1 |> Array.toList) ++
    (Array.indexedMap tileMaybe level2 |> Array.toList |> filterMap identity)

renderEditor editor = collage viewSize viewSize (tiles editor.world)

-- Main --

{- Itch : Figuring out how to do something upon a mouse click is not obvious,
          but quite important. Should make more intuitive or improve docs.
-}
mouseInput = sampleOn Mouse.clicks Mouse.position
input = merge (AnyClick <~ mouseInput)
              (BrushClick <~ brushChooser.signal)

main : Signal Element
main = let currentEditor = (foldp step editor input)
       in foldr (lift2 below) (constant empty) 
                [asText <~ input,
                 renderBrushes <~ currentEditor,
                 renderEditor <~ currentEditor]

{- Bug : I don't think collage should have the origin somewhere in the center.
         There should be more docs about how collage works.
-}

{- Feature request : Easy way to print the type of something. 
   Feature request : Search by function type.
-}