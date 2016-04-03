module Noite1 where

n = a `div` length xs
	where
		a  = 10
		xs = [1, 2, 3, 4, 5]



ultimo :: [a] -> a
ultimo [x] = x
ultimo (x:xs) = ultimo xs



init' :: [a] -> [a]
init' (x:xs) = xs


data Boolean = Nulo | Sim | Nao

sim :: Boolean
sim = Sim

soma :: Int -> Int -> Int
soma x y = x + y


inc = soma 1


elemento :: Eq a => a -> [a] -> Bool
elemento x [] = False
elemento k (x:xs) 
			| k == x = True
			| otherwise = elemento k xs



second xs = head (tail xs)

is_digito :: Char -> Bool
is_digito x | x >= '0', x <= '9' = True
			| otherwise = False


expressao :: [Char] -> Bool
expressao ['H','T','T','P', _] = True
expressao [_] = False

test ("abc":_) = True
test _ = False
















