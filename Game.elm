module Game where

import Array
import CommonDisplay
import Constants (..)
import Graphics.Input as Input
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
                yIndexTop = (floor alien.y + h) // tileSize
            in
                if (isObstacle world <| toIndex xIndexLeft  yIndex) ||
                   (isObstacle world <| toIndex xIndexRight yIndex) ||
                   (isObstacle world <| toIndex xIndexLeft  yIndexTop) ||
                   (isObstacle world <| toIndex xIndexRight yIndexTop)
                then
                    { alien | vx <- 0.0 }
                else
                    { alien | x <- nextX }

        handleVertical alien =
            let xIndexLeft  = (floor (alien.x - w / 2)) // tileSize
                xIndexRight = (floor (alien.x + w / 2)) // tileSize
                yIndex = (floor alien.y) // tileSize
                yIndexNext = (floor nextY) // tileSize
                yIndexNextTop = (floor nextY + h) // tileSize
            in
                if | (alien.vy /= 0.0) &&
                     ((isObstacle world (toIndex xIndexLeft  yIndexNext)) ||
                      (isObstacle world (toIndex xIndexRight yIndexNext)))
                     -- Floor
                     -> { alien | vy <- 0.0,
                                  y  <- toFloat (yIndex * tileSize) }
                   | (alien.vy /= 0.0) &&
                     ((isObstacle world (toIndex xIndexLeft  yIndexNextTop)) ||
                      (isObstacle world (toIndex xIndexRight yIndexNextTop)))
                     -- Ceiling
                     -- Need a slightly negative initial velocity to prevent
                     -- the player from holding the up button and levitating.
                     -> { alien | vy <- -0.1 }
                   | otherwise -> { alien | y <- nextY }

    in
        alien
        |> handleHorizontal
        |> handleVertical


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
        foldr below empty
            [Input.button buttonClick.handle GoToEditor "Go To Editor",
             spacer 30 30,
             CommonDisplay.renderFromForms (worldForms ++ character)
            ]
