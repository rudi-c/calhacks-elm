module Main where

import Mouse

import Constants (..)
import Editor (renderEditorView, stepEditor)
import Game (renderGameView, stepGame)
import Model (..)
import Keyboard

-- Update --

step : Update -> State -> State
step input state =
    case input of
       ButtonClick GoToGame   -> { state | playing <- True }
       ButtonClick GoToEditor -> { state | playing <- False }
       _ -> if | state.playing -> let newGame = stepGame input state.editor.world
                                                         state.game
                                  in  { state | game <- newGame }
               | otherwise     -> let newEditor = stepEditor input state.editor
                                  in  { state | editor <- newEditor }


-- Main --

{- Itch : Figuring out how to do something upon a mouse click is not obvious,
          but quite important. Should make more intuitive or improve docs.
-}
mouseClicks = sampleOn Mouse.clicks Mouse.position

mouseTileFolder : (Int, Int) -> (Bool, (Int, Int)) -> (Bool, (Int, Int))
mouseTileFolder newPos (_, oldPos) =
    let newTile = hoveredTile newPos
        oldTile = hoveredTile oldPos
    in
        (newTile /= oldTile && (inGrid newTile), newPos)

mouseTileChanged =
    let invalid = (-1, -1)
        base = (False, invalid)
    in  Mouse.position
        |> keepWhen Mouse.isDown invalid
        |> foldp mouseTileFolder base
        |> keepIf (\ (changed, pos) -> changed) base
        |> lift (\ (changed, pos) -> pos)

mouseInput = merge mouseClicks mouseTileChanged

-- From mario sample
gameInput = let delta = lift (\t -> t/20) (fps 25)
            in  sampleOn delta (lift2 (,) delta Keyboard.arrows)

input = foldr merge (HitTile <~ mouseInput)
                    [(BrushClick <~ brushChooser.signal),
                     (ButtonClick <~ buttonClick.signal),
                     (GameDelta <~ gameInput)]



{- Itch : A typo like state.isPlaying instead of state.playing gives
          a very unhelpful error message.
-}
main : Signal Element
main = let stateSignal = foldp step initialState input
           do state = if state.playing then
                          renderGameView state.game state.editor.world
                      else
                          renderEditorView state.editor
       in
           do <~ stateSignal

{- Bug : I don't think collage should have the origin somewhere in the center.
         There should be more docs about how collage works.
-}

{- Feature request : Easy way to print the type of something.
   Feature request : Search by function type.
   Feature request : Elm library search should not be limited to current
                     subdirectory (although it could prioritize it).
-}