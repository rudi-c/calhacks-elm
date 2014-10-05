module Game where

import Array
import CommonDisplay
import Constants (..)
import Model (..)
import Utils (..)

alienProperty alien =
    if | alien.vy /= 0.0 -> ("p1_jump.png", (67, 94))
       | otherwise       -> ("p1_front.png", (66, 92))

-- Update --

isObstacle {level1, level2} index =
    case Array.get index level1 of
        Just 0 -> False
        Just x -> True
        Nothing -> True

{- Bug : "--|>" is not registered as a comment, but as a variable.
-}
physics world dt alien =
    let (_, (w, h)) = alienProperty alien
        nextX = alien.x + alien.vx * dt
        nextY = alien.y + alien.vy * dt

        handleHorizontal alien =
            let xIndexLeft  = (floor (nextX - w / 2)) // tileSize
                xIndexRight = (floor (nextX + w / 2)) // tileSize
                yIndex = (floor alien.y) // tileSize
                indexLeft  = toIndex xIndexLeft yIndex
                indexRight = toIndex xIndexRight yIndex
            in
                if (isObstacle world indexLeft) ||
                   (isObstacle world indexRight)
                then
                    { alien | vx <- 0.0 }
                else
                    { alien | x <- nextX }

        handleFloor alien =
            let xIndex = (floor alien.x) // tileSize
                yIndex = (floor alien.y) // tileSize
                yIndexNext = (floor nextY) // tileSize
            in
                if (alien.vy /= 0.0) &&
                   (isObstacle world (toIndex xIndex yIndexNext))
                then
                    { alien | vy <- 0.0,
                              y  <- toFloat (yIndex * tileSize) }
                else
                    { alien | y <- nextY }

    in
        alien
        |> handleHorizontal
        |> handleFloor


walk {x} alien = { alien | vx <- 3.0 * toFloat x,
                           dir <- if | x < 0 -> Left
                                     | x > 0 -> Right
                                     | otherwise -> alien.dir }

jump {y} alien = if y > 0 && alien.vy == 0.0 then
                    { alien | vy <- 8.0 }
                 else
                    alien

gravity dt alien = { alien | vy <- alien.vy - dt / 4 }

stepGame : Update -> World -> Game -> Game
stepGame input world game =
    case input of
        GameDelta (dt, keys) ->
            let newAlien = game.alien |> jump keys |> gravity dt
                           |> walk keys |> physics world dt
            in { game | alien <- newAlien }
        _ -> game


-- Display --


{- Feature request : Function to scale forms in each axis separately,
                     and possibly negatively.
-}
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
