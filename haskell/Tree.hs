module Tree where

-- Aluno: Everton de Vargas Agilar
-- Disciplina: Construção de Software
-- Professor: Rodrigo Bonifacio de Almeida


-- Questão 2




data Tree a = Leaf | Node a (Tree a) (Tree a) 
	deriving (Show)


-- (a) Implemente uma funcao que calcula o numero de nos presentes em uma
-- arvore, conforme a definicao do nosso tipo Tree. (3 pts).


-- Função: numero_nos
-- Objetivo: calcula o numero de nos presentes em uma arvore
numero_nos :: Num a => Tree t -> a
numero_nos Leaf = 0
numero_nos (Node a esq dir) = (numero_nos esq) + 1 + (numero_nos dir)


-- Teste da questão executado no ghci
-- :l Tree
-- let arv2 = Node 12 (Node 13 Leaf Leaf) (Node 4 Leaf (Node 1 Leaf Leaf))
-- numero_nos arv2
-- 4

 




-- (b) Implemente uma funcao de alta-ordem

-- Função: mapT
-- Objetivo: que aplica uma funcao (f :: a -> b) aos elementos de uma arvore de
-- "as" e retorna uma nova arvore de "bs"

mapT :: (a -> b) -> Tree a -> Tree b
mapT f Leaf = Leaf
mapT f (Node a esq dir) = Node (f a) (mapT f esq) (mapT f dir)




-- Teste da questão executado no ghci
-- :l Tree
-- let arv2 = Node 12 (Node 13 Leaf Leaf) (Node 4 Leaf (Node 1 Leaf Leaf))
-- mapT (+1) arv2
-- Node 13 (Node 14 Leaf Leaf) (Node 5 Leaf (Node 2 Leaf Leaf))

















