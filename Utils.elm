module Utils where

-- Utils --

moveInt : (Int, Int) -> Form -> Form 
moveInt (x, y) obj = move (toFloat x, toFloat y) obj
