import Array
import Dict
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
                    ["sandCenter.png", "box.png"]
graphicsTiles = zip [0..(length graphicsNames - 1)] graphicsNames 
                |> Dict.fromList

viewSize = gridSize * 50 * 3 // 2

-- Model --

world = { level1 = Array.initialize (gridSize * gridSize) (always 0),
          level2 = Array.initialize (gridSize * gridSize) (always Nothing)
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

step input world =
    let (x, y) = hoveredTile input
        i      = toIndex x y
    in if inGrid x y then { world | level1 <- Array.set i (1 - (Array.getOrFail i world.level1)) world.level1 }
        else world

-- Display --

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

renderEditor world = collage viewSize viewSize (tiles world)

-- Main --

{- Itch : Figuring out how to do something upon a mouse click is not obvious,
          but quite important. Should make more intuitive or improve docs.
-}
input = sampleOn Mouse.clicks Mouse.position

main : Signal Element
main = lift2 below 
             (asText <~ (hoveredTile <~ input)) 
             (renderEditor <~ (foldp step world input))

{- Bug : I don't think collage should have the origin somewhere in the center.
         There should be more docs about how collage works.
-}

{- Feature request : Easy way to print the type of something. 
   Feature request : Search by function type.
-}