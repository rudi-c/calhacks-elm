module Editor where

import Array
import Dict
import Graphics.Input as Input
import Maybe
import Mouse
import String
import Window

import CommonDisplay
import Constants (..)
import Model (..)
import Utils (..)


-- Update --

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
        _ -> editor


-- Display --

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

renderEditorView editor =
    foldr below empty
          [Input.button buttonClick.handle GoToGame "Go To Game",
           spacer 30 30,
           renderBrushes editor,
           spacer 50 50,
           CommonDisplay.renderEditor editor]

