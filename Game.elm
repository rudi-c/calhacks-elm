module Game where

import CommonDisplay
import Model (..)

-- Update --

stepGame : Update -> Game -> Game
stepGame input game =
    case input of
        _ -> game


-- Display --

renderGameView game world =
    let worldForms = CommonDisplay.tilesForWorld world
    in
        CommonDisplay.renderFromForms worldForms
