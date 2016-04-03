homem(pedro).
homem(joao).
homem(tiago).
mulher(ana).
mulher(maria).
mulher(susi).
mulher(carla).
casados(pedro, ana).
casados(joao, maria).
pai(pedro, maria).
pai(pedro, susi).
pai(joao, tiago).
pai(joao, carla).

mae(M, F) :- casados(X, M),
	     pai(X, F).	

avo(A, N) :- pai(A, X),
	     pai(X, N).




