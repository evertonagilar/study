module Funcoes where 

import Data.Char 

soma a b = a + b

inc = soma 1 

somatorio [] = 0
somatorio (x:xs) = x + somatorio xs

prod [] = 1
prod (x:xs) = x * prod xs

duplo [] = 0
duplo (x:xs) = (x * 2) : duplo xs

duploSmall x = if x < 100 then x * 2
	       else x


sum' [] = 0
sum' (x:xs) = x + sum xs

conta [] = 0
conta (x:xs) = 1 + conta xs


ordena [] = []
ordena (x:xs) = ordena menores ++ [x] ++ ordena maiores
		where 
			menores = [a | a <- xs, a < x]
			maiores = [a | a <- xs, a > x]


duplica x = x `mul` x
     	    where mul a b = a * b


produto [] = 1
produto (x:xs) = x * produto xs

desordena (x:xs) = reverse (ordena menores ++ [x] ++ ordena maiores)
		   where 
			menores = [a | a <- xs, a <= x]
			maiores = [a | a <- xs, a > x]


n = a `div` length xs
	where
		a = 10
		xs = [1, 2, 3, 4, 5]


ultimo [x] = x
ultimo (x:xs) = ultimo xs

init2 [x] = []
init2 (x:xs) = remove ult_elem lista
               where
                      ult_elem = ultimo xs
                      lista = x:xs			
                      remove a b = [k | k <- b, k /= a]



-- Função split
-- Objetivo: quebra uma string em uma lista de palavras por um delimitador
-- Obs.: Poderia ser utilizado a função de outro package como Data.Text
-- Fonte: Internet
split :: String -> Char -> [String]
split [] delim = [""]
split (c:cs) delim
   | c == delim = "" : rest
   | otherwise = (c : head rest) : tail rest
   where
       rest = split cs delim


-- Função strong do exercício
-- Objetivo: password strenght checker
-- Ex.:  strong "Password12345"   => True
strong :: String -> Bool
strong senha = 
	if elem True (map (isNumber) senha) &&
	   length senha >= 10 &&
	   (filter (isUpper) senha) /= [] &&
	   (filter (isLower) senha) /= []						
	then
		 True 
	else 
		False
	






