module Estudo3 where

-- :load script
-- consultar o tipo: :t 'a'  ou :t [1,2,3] ...
-- estaticamente tipado

-- funcao soma
-- uso: soma 2 3
soma a b = a + b


-- funcao duplica
-- uso:  duplica [1,2,3]
duplica [] = []
duplica (x:xs) = (x*2) : duplica xs

-- funcao inc
inc = soma 1

-- funcao conta
conta [] = 0
conta (x:xs) = 1 + conta xs

-- funcao ordena
ordena [] = []
ordena (x:xs) = ordena menores ++ [x] ++ ordena maiores
		where 
			menores = [a | a <- xs, a < x]
			maiores = [a | a <- xs, a > x]



-- funcao duplica_valor
multiplica_valor x = x `mul` x
	where
       mul a b = a * b


-- funcao ultimo
ultimo :: [Int] -> Int
ultimo [x] = x
ultimo (x:xs) = ultimo xs



