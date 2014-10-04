import Array
import Dict
import Mouse
import String

-- Constants --

gridSize : Int
gridSize = 4

graphicsNames = map (String.append "graphics/Base pack/Tiles/") 
                    ["sandCenter.png", "box.png"]
graphicsTiles = zip [0..(length graphicsNames - 1)] graphicsNames 
                |> Dict.fromList

-- Model --

grid = Array.initialize (gridSize * gridSize) (always 0)

rowFromIndex : Int -> Int
rowFromIndex index = index // gridSize

colFromIndex : Int -> Int
colFromIndex index = index % gridSize

-- Update --

step input grid =
    let (x, y) = input
    in Array.set 0 (1 - (Array.getOrFail 0 grid)) grid

-- Display --

{- Bug : We shouldn't need to do explicit conversion to
         floats according to the docs, this seems to be a bug.
   Bug : Operator precedence is wrong. * does not have higher precedence than +
-}
tile : Int -> Int -> Form
tile index val = image 50 50 (Dict.getOrFail val graphicsTiles)
                 |> toForm
                 |> move (50.0 * (toFloat (rowFromIndex index - gridSize // 2)),
                          50.0 * (toFloat (colFromIndex index - gridSize // 2)))
tiles grid = Array.indexedMap tile grid |> Array.toList

renderEditor grid = collage viewSize viewSize (tiles grid)

-- Main --

viewSize = gridSize * 50 * 3 // 2

{- Itch : Figuring out how to do something upon a mouse click is not obvious,
          but quite important. Should make more intuitive or improve docs.
-}
input = sampleOn Mouse.clicks Mouse.position

main : Signal Element
main = renderEditor <~ (foldp step grid input)

{- Bug : I don't think collage should have the origin somewhere in the center.
         There should be more docs about how collage works.
-}
