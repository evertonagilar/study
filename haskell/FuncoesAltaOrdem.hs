module FuncoesAltaOrdem where 

import Data.Char 

soma a b = a + b

inc = soma 1 

-- exemplo de casamento de padroes, 
-- manipulacao de listas e funcoes 
-- recursivas


-- Everton: não seria somatorio [] = 0
-- somatorio xs [] = 0
-- somatorio (x:xs) = x + somatorio xs

-- produtorio [] = 1
-- produtorio (x:xs) = x * produtorio xs

somatorio xs = reduce (+) 0 xs
produtorio xs = reduce (*) 1 xs 
-- o reduce eh na verdade a funcao
-- foldr, ja implementada em Haskell. 
-- esse exemplo ilustra a passagem de 
-- funcoes como argumento (op eh uma funcao)
reduce op base [] = base
reduce op base (x:xs) = x `op` (reduce op base xs)

ourMap f [] = []
ourMap f (x:xs) = (f x) : (ourMap f xs)

incrementa = ourMap inc

toAscii = ourMap ord

elemento :: (Eq a) => a -> [a] -> Bool
elemento k [] = False
elemento k (x:xs) = 
 if(k == x) then True
 else elemento k xs

filtro p [] = []
filtro p (x:xs)  
 | p x = x : (filtro p xs)
 | otherwise = filtro p xs

filtro' p xs = [ord(x) | x <- xs, p x, ...]

produtoCartesiano xs ys = [(x, y) | x <-xs , y <- ys]
-- fatorial n
-- | n == 1 -> 1
-- | otherwise -> n * fatorial (n-1)

-- exemplo de criptografia usando o 
-- metodo de deslocamento dos caracteres
-- map (chr . (+3)) (toAscii "Construcao de Software")

-- a funcao f parece nao ser util 
-- fora da definicao da funcao tamanho.
-- entao podemos usar uma expressao lambda
-- na definicao da funcao tamanho. o equivalente 
-- eh: \a b -> 1 + b 
-- f a b = 1 + b
-- tamanho xs = reduce f 0 xs

tamanho = reduce (\a b -> 1 + b) 0

-- tamanho [] = []
-- tamanho (x:xs) = 1 + tamanho xs

-- soma' espera um unico 
-- argumento que eh do tipo 
-- tupla (Num, Num). como espera 
-- um unico argumento, nao podemos 
-- aplicar parcialmente soma'.
soma' (a, b) = a + b

