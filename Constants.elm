module Constants where

import Dict
import String

import Utils (..)

-- Constants --
tileSize : Int
tileSize = 70

gridSize : Int
gridSize = 8

graphicsNames = map (String.append "graphics/Base pack/Tiles/") 
                    ["empty.png",
                     "sandCenter.png",
                     "grassLeft.png",
                     "grassMid.png",
                     "grassRight.png",
                     "box.png"]
graphicsTiles = zip [0..(length graphicsNames - 1)] graphicsNames 
                |> Dict.fromList

viewSize = gridSize * tileSize

gridOffset : Int
gridOffset = -viewSize // 2 + tileSize // 2

gridOffsetMove obj = moveInt (gridOffset, gridOffset) obj
