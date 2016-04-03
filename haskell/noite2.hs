module Noite2 where

data Arvore = Nulo | No Int Arvore Arvore

insere :: Ord a => a -> [a] -> [a]
insere k [] = [k]
insere k (x:xs) | k <= x = k:(x:xs)
                | otherwise = x:insere k xs
