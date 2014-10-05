module Game where

import CommonDisplay
import Constants (..)
import Model (..)
import Utils (..)

-- Update --

physics dt alien = { alien | x <- alien.x + alien.vx * dt,
                             y <- alien.y + alien.vy * dt }

walk {x} alien = { alien | vx <- toFloat x,
                           dir <- if | x < 0 -> Left
                                     | x > 0 -> Right
                                     | otherwise -> alien.dir }

jump {y} alien = if alien.vy == 0.0 then
                    { alien | vy <- 6.0 }
                 else
                    alien

gravity dt alien = { alien | vy <- alien.vy - dt / 4 }

stepGame : Update -> Game -> Game
stepGame input game =
    case input of
        GameDelta (dt, keys) ->
            let newAlien = game.alien |> gravity dt
                           |> jump keys |> walk keys |> physics dt
            in { game | alien <- newAlien }
        _ -> game


-- Display --

alienProperty alien =
    if | alien.vy /= 0.0 -> ("p1_jump.png", (67, 94))
       | otherwise       -> ("p1_front.png", (66, 92))

alienImage alien =
    let folder = "graphics/Base pack/Player/"
        (filename, (w, h)) = alienProperty alien
        path = folder ++ filename
    in
        image w h path
        |> toForm
        |> move (alien.x - (toFloat w) / 2,
                 alien.y + (toFloat (h - tileSize)) / 2)
        |> gridOffsetMove

renderGameView game world =
    let worldForms = CommonDisplay.tilesForWorld world
        character  = [alienImage game.alien]
    in
        CommonDisplay.renderFromForms (worldForms ++ character)
