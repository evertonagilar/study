module Manha1 where

import Data.Char


my_upper c | c >= 'a', c <= 'z' = chr (ord c - 32)
	   | otherwise = c



my_reverse :: [a] -> [a]
my_reverse [] = []
my_reverse (x:xs) = my_reverse xs ++ [x]


my_fac :: Int -> Int
my_fac x | x > 1 = x * my_fac (x-1)
	 | otherwise = x


data Corpo = Gordo | Magro deriving Eq

corpo = Gordo


my_zip :: [a] -> [b] -> [(a, b)]
my_zip [] [] = []
my_zip _ [] = []
my_zip [] _ = []
my_zip (a:as) (b:bs) = [(a, b)] ++ my_zip as bs


my_cipher :: [Char] -> Int -> [Char]
my_cipher [] _ = []
my_cipher (x:xs) k =  novo_ch : my_cipher xs k
	where novo_ch = chr (ord x + k)
