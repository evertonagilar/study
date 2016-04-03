-- Resolução capitulo 01
-- Everton de Vargas Agilar


-- 1. Give another possible calculation for the result of double ( double 2)		

my_double :: Int -> Int
my_double x = x * 2

resposta_01 = my_double 2 + my_double 2


 
-- 2. Show that sum [ x ] = x for any number x .

 
my_sum :: [Int] -> Int
my_sum [] = 0
my_sum (x:xs) = x + my_sum xs

-- resposta:
-- my_sum [1,2,3]
--          1 + my_sum[2,3]
--          1 + 2 + my_sum [3]
--          1 + 2 + 3 + my_sum []
--		    1 + 2 + 3 + 0
--		    6		
               
 
 
 
-- 3. Define a function product that produces the product of a list of numbers,
-- and show using your definition that product [2, 3, 4] = 24.

my_product :: [Int] -> Int
my_product [] = 1
my_product (x:xs) = x * my_product xs


-- 4. How should the definition of the function qsort be modified so that it
-- produces a reverse sorted version of a list?

my_sort :: Ord a => [a] -> [a]
my_sort [] = []
my_sort (x:xs) = my_sort maiores ++ [x] ++ my_sort menores
	where
		menores = filter (<=x) xs
		maiores = filter (>x) xs


-- 5. What would be the effect of replacing ≤ by < in the definition of qsort ?
-- Hint: consider the example qsort [2, 2, 3, 1, 1].

my_sort' :: Ord a => [a] -> [a]
my_sort' [] = []
my_sort' (x:xs) = my_sort' maiores ++ [x] ++ my_sort' menores
	where
		menores = filter (<x) xs
		maiores = filter (>x) xs

-- my_sort [2,2,3,1,1]
-- [3,2,2,1,1]


-- my_sort' [2,2,3,1,1]
-- [3,2,1]

-- O efeito é que a lista é ordenada sem os elementos repetidos.


