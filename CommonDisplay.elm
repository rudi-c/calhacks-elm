module CommonDisplay where

import Array
import Dict

import Constants (..)
import Model (..)
import Utils (..)

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

tilesForWorld {level1, level2} =
    [square (toFloat viewSize) |> filled lightBlue] ++
    (Array.indexedMap tile level1 |> Array.toList) ++
    (Array.indexedMap tile level2 |> Array.toList)

renderFromForms : [Form] -> Element
renderFromForms forms = collage viewSize viewSize forms
