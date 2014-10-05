module Game where

import CommonDisplay
import Constants (..)
import Model (..)
import Utils (..)

-- Update --

stepGame : Update -> Game -> Game
stepGame input game =
    case input of
        _ -> game


-- Display --

alienSize alien = (66, 92)

alienPath alien =
    let folder = "graphics/Base pack/Player/"
    in
        folder ++ "p1_front.png"

alienImage alien =
    let (w, h) = alienSize alien
        path   = alienPath alien
    in
        image w h path
        |> toForm
        |> move (alien.x, alien.y + (toFloat (h - tileSize)) / 2)
        |> gridOffsetMove

renderGameView game world =
    let worldForms = CommonDisplay.tilesForWorld world
        character  = [alienImage game.alien]
    in
        CommonDisplay.renderFromForms (worldForms ++ character)
