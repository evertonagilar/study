module Manha2 where

data Arvore = SemFolha | Folha Int Arvore Arvore deriving (Show)

minhaArvore = Folha 10 SemFolha (Folha 5 SemFolha SemFolha)


advinha :: Int -> [Char]
advinha x = if x > 10 && x < 30 && (x `mod` 2 == 0) then "Acertou"
			else "Nop"
				
		
advinha' :: Int -> [Char]
advinha' x | x > 10 && x < 30 && (x `mod` 2 == 0) = "Acertou" 
           | otherwise = "Nop"


--my_mapa :: f [a] -> [Bool]
my_mapa f [] = []
my_mapa f (x:xs) = f x : my_mapa f xs

my_filtro f [] = []
my_filtro f (x:xs) | f x = x : my_filtro f xs
				   | otherwise = my_filtro f xs
