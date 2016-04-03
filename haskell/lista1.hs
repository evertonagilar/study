--
-- Lista 1 - Primeira Lista de Exercícios (aquecimento)
-- Autor: Everton de Vargas Agilar
-- Data: 29/03/2015
--

module Lista1 where

import Data.Char
import Data.List
import System.Locale
import Data.Time
import Data.Time.Format


-- Resolução do problema 01


-- Função modernize
-- Primeiro caracter de cada palavra da string em maiúsculo
-- Autor: Everton Agilar
-- Ex: modernize "everton de vargas agilar"   => "Everton de Vargas Agilar"
modernize :: String -> String
modernize(str) = 
	Data.List.intercalate " " palavras
	where
		palavras = [name_case s | s <- words str]



--modernize' :: [Char] -> Bool -> [Char]
--modernize' (x:xs) espaco_antes
--	| espaco_antes && x /= ' ' = toUpper x : modernize' xs
--	| otherwise = x : modernize' xs (x == ' ')


-- Função name_case
-- Objetivo: Primeiro caracter em maiúsculo
-- Autor: Everton Agilar
-- Ex: name_case "everton"    =>  "Everton"
name_case :: String -> String
name_case (x:xs) = [Data.Char.toUpper x] ++ xs



my_modernize :: String -> String
my_modernize [] = []
my_modernize (x:xs) = (toUpper x):my_modernize_aux xs False



my_modernize_aux :: String -> Bool -> String
my_modernize_aux [] _ = []
my_modernize_aux (x:xs) upper_head | upper_head = (toUpper x):my_modernize_aux xs False
								   | x == ' ' = x:my_modernize_aux xs True
								   | otherwise = x:my_modernize_aux xs False




--
-- Resolução do problema 02
-- 


-- Função showDate
-- Objetivo: exibir data no formato do exercício
-- Autor: Everton Agilar
-- Ex.: showDate (10,12,2013)    =>  "10th December, 2013"
showDate (day, month, year) =
	print $ dt_formatada_com_sufixo
	where	
		date = fromGregorian year month day
		dt_formatada = formatTime defaultTimeLocale "%d#S %B, %Y" date
		sufixo_mes = sufixo_dia_mes day
		dt_formatada_com_sufixo = replace "#S" sufixo_mes dt_formatada



-- Função sufixo_dia_mes
-- Objetivo: Retornar a sigla do dia do mês
-- Obs.: Não tem como obter o sufixo pela função formatTime (pelo menos não encontrei)
-- Autor: Everton Agilar
sufixo_dia_mes n  
	| n `mod`10 == 1 = "st"
	| n `mod`10 == 2 = "nd"
	| n `mod`10 == 3 = "rd"
	| otherwise		 = "th"



-- Função replace
-- Objetivo: substitui uma string por outra
-- Obs.: Está função existe em outros packages como Data.Text
-- Autor: Everton Agilar
replace old new str = rep old new str


-- Função interna rep
-- Fonte: http://stackoverflow.com/questions/14907600/how-to-replace-a-string-with-another-in-haskell
rep a b s@(x:xs) = if isPrefixOf a s

                     -- then, write 'b' and replace jumping 'a' substring
                     then b++rep a b (drop (length a) s)

                     -- then, write 'x' char and try to replace tail string
                     else x:rep a b xs

rep _ _ [] = []





--
-- Resolução do problema 03
-- 


-- Função strong do exercício
-- Objetivo: password strenght checker
-- Ex.:  strong "Password12345"   => True
strong :: String -> Bool
strong senha = 
	if length senha >= 10 &&
	   any isNumber senha &&
	   any isUpper  senha &&
	   any isLower  senha
	then
		 True 
	else 
		False
	



--
-- Resolução do problema 04
-- 

-- Tipo de dado Tree
data Tree = Nulo | No Int Tree Tree

-- Uma árvore de exemplo para testar
arv :: Tree
arv = (No 1
			(No 2
				(No 4 Nulo Nulo) Nulo)
			(No 3
				Nulo Nulo)
	  )


-- Função em_ordem
-- Objetivo: retorna um conjunto dos números da árvore
em_ordem :: Tree -> [Int]
em_ordem Nulo = []
em_ordem (No num esq dir) = (em_ordem esq) ++ [num] ++ (em_ordem dir)




-- Função sumT do exercício
-- Objetivo: somar os elementos da árvore
sumT :: Tree -> Int
sumT arv = sum (em_ordem arv)

data Arvore = Nada | Folha Int Arvore Arvore

let minha_arvore = Nada












