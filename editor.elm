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
-}
tile index val = filled red (square 49) 
                 |> move (50.0 * (toFloat (rowFromIndex index)),
                          50.0 * (toFloat (colFromIndex index)))
tiles = Array.indexedMap tile grid |> Array.toList

-- Main --


main : Element
main = collage 300 300 tiles

{- Bug : I don't think collage should have the origin somewhere in the center.
-}
