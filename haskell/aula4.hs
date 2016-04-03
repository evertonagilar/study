module Aula where



main :: IO()
main = do
	putStrLn "Aula 4 de Haskell\n"
	putStrLn "==================================\n"




aula_lambda = 
    so_pares
    where
	numeros = [0..20]
	so_pares = filter (\x -> x `mod` 2 == 0) numeros



-- reverse list
rev [] = []	
rev (x:xs) = rev xs ++ [x]


-- fatorial
fat :: Int -> Int
fat 1 = 1
fat x | x > 1 = x * fat (x-1)



