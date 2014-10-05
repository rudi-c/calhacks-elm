module Game where

import CommonDisplay
import Model (..)

-- Update --

stepGame : Update -> Game -> Game
stepGame input editor =
    case input of
        _ -> editor


-- Display --

renderGameView game = empty
