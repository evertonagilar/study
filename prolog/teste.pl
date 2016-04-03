% Fatos %
pai(pessoaA, pessoaB).
pai(pessoaB, pessoaC).
pai(pessoaD, pessoaE).
mae(pessoaA, pessoaD).

% Regras %
avo(X, Y) :- pai(X,Z),pai(Z,Y).
avo(X, Y) :- mae(X,Z),pai(Z,Y).