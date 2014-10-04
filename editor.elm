import Array
import Mouse

-- Model --

gridSize : Int
gridSize = 4

grid = Array.initialize (gridSize * gridSize) (always 0)

rowFromIndex : Int -> Int
rowFromIndex index = index // gridSize

colFromIndex : Int -> Int
colFromIndex index = index % gridSize

-- Update --

-- Display --

{- Bug : We shouldn't need to do explicit conversion to
         floats according to the docs, this seems to be a bug.
   Bug : Operator precedence is wrong. * does not have higher precedence than +
-}
tile index val = filled red (square 49) 
                 |> move (50.0 * (toFloat (rowFromIndex index - gridSize // 2)),
                          50.0 * (toFloat (colFromIndex index - gridSize // 2)))
tiles = Array.indexedMap tile grid |> Array.toList

-- Main --

viewSize = gridSize * 50 * 3 // 2

main : Element
main = collage viewSize viewSize tiles

{- Bug : I don't think collage should have the origin somewhere in the center.
         There should be more docs about how collage works.
-}
