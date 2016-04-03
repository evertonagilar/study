homem(alexandre).
homem(gustavo).
homem(jurandir).
homem(idalino).
homem(enio).
homem(joao).
homem(zeno).

mulher(sissa).
mulher(tina).
mulher(regina).
mulher(rosalia).
mulher(catarina).
mulher(lurdes).
mulher(gabriela).

marido_esposa(jurandir, regina).
marido_esposa(joao, tina).
marido_esposa(idalino, rosa).
marido_esposa(zeno, catarina).

pai(jurandir, alexandre).
pai(jurandir, gustavo).
pai(jurandir, sissa).
pai(jurandir, tina).
pai(joao, gabriela).
pai(joao, guilherme).
pai(zeno, jurandir).
pai(PAI,F) :- marido_esposa(PAI,ESPOSA), mae(ESPOSA,F).


mae(rosalia, regina).
mae(MAE,F):- marido_esposa(Marido, MAE), pai(Marido,F).

avo(A,N) :- pai(A,F), pai(F,N).
avo(A,N) :- pai(A,F), mae(F,N).
avo(A,N) :- mae(A,F), pai(F,N).
avo(A,N) :- mae(A,F), mae(F,N).

irmao(IA, IB) :- pai(P,IA), pai(P,IB), (IA\=IB).
irmao(IA, IB) :- mae(M,IA), mae(M,IB).





