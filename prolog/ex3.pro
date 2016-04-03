conexao(c, fora).
conexao(j, fora).
conexao(a, b).
conexao(a, d).
conexao(c, j).
conexao(d, g).
conexao(e, f).
conexao(e, h).
conexao(g, h).
conexao(g, j).
conexao(h, l).
conexao(i, m).
conexao(j, n).
conexao(a, m).

saida(P) :- conexao(P, fora).
saida(P) :- conexao(P, I),
	    saida(I).

conexao(X, Y) :- conexao(Y, X),
		 X \= Y.
