module Expression where

-- Aluno: Everton de Vargas Agilar
-- Disciplina: Construção de Software
-- Professor: Rodrigo Bonifacio de Almeida


-- Questão 1


data Expr = Const Int | Plus Expr Expr | Mult Expr Expr deriving (Show)



-- (a) Escreva uma expressao (exp1 :: Expr) que representa o valor


-- expr1 = (1 + 2)*(3 + 4)
expr1 = (Mult (Plus (Const 1) (Const 2)) (Plus (Const 3) (Const 4)))



-- (b) Escreva uma funcao eval :: Expr -> Int que computa o resultado da
-- avaliacao de uma expressao qualquer do tipo Exp. Para o exemplo do item
-- (a), o resultado da avaliacao seria 21. 


eval :: Expr -> Int
eval (Const n) = n
eval (Plus e1 e2) = eval e1 + eval e2
eval (Mult e1 e2) = eval e1 * eval e2



-- Teste da questão executado no ghci
-- :l Expression
-- eval expr1
-- 21




