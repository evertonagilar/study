homem(everton).
homem(joao).
homem(carlos).
homem(ze).


mulher(maria).
mulher(marta).
mulher(thaise).
mulher('Helena').

mulher_homem(marta, joao).
mulher_homem(thaise, everton).

filho('Helena', thaise).

pai(Homem, Filho) :- mulher_homem(Mulher, Homem), 
		     filho(Filho, Mulher).	

		


