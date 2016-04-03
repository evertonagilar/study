module Noite4 where

import Data.Char

soma :: [Int] -> Int
soma [] 	   = 0
soma (x:xs) = x + sum xs


conta [] = 0
conta (x:xs) = 1 + conta xs


-- função fatorial
fat1 x  | x > 1 = x * fat1 (x-1)
        | otherwise = x

	

fat (0)=1
fat (1)=1
fat (n)= n * fat(n-1)



fat2 x = if x > 1 then x * fat2 (x-1)
         else x



--primeiro [] = []
primeiro (x:xs) = x



ultimo [x] = x
ultimo (x:xs) = ultimo xs

qsort [] = []
qsort (x:xs) = qsort menor ++[x]++qsort maior
                       where 
                             menor =  [a | a<-xs , a<=x]
                             maior = [a | a <-xs, a > x]






senha_forte  senha = 
	if length senha >= 10 &&
	   any isNumber senha &&
	   any isUpper  senha &&
	   any isLower  senha
	then
		 True 
	else 
		False


		
reverso [] = []
reverso [x] = [x]
reverso (x:xs) = reverso xs ++[x]

adiciona n [] = [n]
adiciona n (x:xs) = n : (x:xs)
		


adiciona_ordenado n [] = [n]
adiciona_ordenado n (x:xs) | n <= x = n : (x:xs)
                           | otherwise = x : adiciona_ordenado n xs



elemento_existe n [] = False
elemento_existe n (x:xs) | n==x = True
                         | otherwise = elemento_existe n xs




