module Model where

import Array
import Graphics.Input as Input

import Constants (..)

-- Event Model --

{- Itch : This is a questionable way of having multiple different buttons,
          even if they are semantically related.
-}
data ButtonClickType = GoToGame | GoToEditor
buttonClick : Input.Input ButtonClickType
buttonClick = Input.input GoToGame

{- Itch : Right now, it seems there isn't great ways to handle multiple
          input signals other than merging them and doing case analysis,
          which doesn't scale very well and is tantamount to reimplementing
          an update loop. Are there better solutions? Is Elm planning to
          move in a direction that will make this kind of UI easier to
          develop?
-}
data Update = HitTile (Int, Int) | BrushClick Int | ButtonClick ButtonClickType

brushChooser : Input.Input Int
brushChooser = Input.input 0


-- Model --

data Layer = Level1 | Level2

type World = { level1: Array.Array Int, level2: Array.Array Int }
type Editor = { layer: Layer, selectedBrush: Int, world: World }
type Game = {}
type State = { editor: Editor, game: Game, playing: Bool }

initialWorld : World
initialWorld = { level1 = Array.initialize (gridSize * gridSize) (always 0),
                 level2 = Array.initialize (gridSize * gridSize) (always 0)
               }

initialEditor : Editor
initialEditor = { layer = Level1,
                  selectedBrush = 0,
                  world = initialWorld
                }

initialGame : Game
initialGame = { }

initialState : State
initialState = { editor = initialEditor,
                 game = initialGame,
                 playing = False
               }

-- col == x
colFromIndex : Int -> Int
colFromIndex index = index % gridSize

-- row == y
rowFromIndex : Int -> Int
rowFromIndex index = index // gridSize

toIndex x y = x + y * gridSize
