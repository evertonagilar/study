module Main where

import Data.List
import Data.Char


main :: IO()
main = do
	putStrLn "Hello World!"
	putStrLn "Isso eh Haskell"
	putStrLn "Uau!!!"
	let myname = "everton de vargas agilar"
	texto <- getLine
	putStrLn $ modernize myname





formata_nome :: String -> String
formata_nome nome = do
	let _nome = modernize nome
	_nome




-- Função modernize
-- Primeiro caracter de cada palavra da string em maiúsculo
-- Autor: Everton Agilar
-- Ex: modernize "everton de vargas agilar"   => "Everton de Vargas Agilar"
modernize :: String -> String
modernize(str) = 
	Data.List.intercalate " " palavras
	where
		palavras = [name_case s | s <- words str]



-- Função name_case
-- Objetivo: Primeiro caracter em maiúsculo
-- Autor: Everton Agilar
-- Ex: name_case "everton"    =>  "Everton"
name_case :: String -> String
name_case (x:xs) = [Data.Char.toUpper x] ++ xs


--
