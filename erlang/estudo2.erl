-module(estudo2).
-compile(export_all).

% funcao mapa
% uso: estudo2:mapa(fun(X) -> io:format("Valor ~p.~n", [X]) end, [1,2,3,4,5]).
mapa(Funcao, [H|T]) -> [Funcao(H)| mapa(Funcao, T)];
mapa(Funcao, [])    -> [].




% funcao para_cada
% uso:  estudo2:para_cada(fun(X) -> io:format("Valor ~p.~n", [X]) end, [1, 2, 3, 4, 5]).
para_cada(Funcao, [H|T]) -> 
	Funcao(H),
	para_cada(Funcao, T);

para_cada(Funcao, []) -> 
	ok.


% funcao imprime_arquivo
% uso:  estudo2:list_to_file("teste.txt", lists:seq(1, 10)).  
list_to_file(File, Lista) ->
	{ok, Stream} = file:open(File, write),
	para_cada(fun(Str) -> io:format(Stream, "~p~n", [Str]) end, Lista),
	file:close(Stream).


% funcao fatorial
% aqui importa a ordem da declaração
fatorial(0) -> 1;
fatorial(N) -> 
	io:format("~p~n", [N]),
	N * fatorial(N-1).
 


% funcao fatorial2 com tail recursion
fatorial2(N) -> fatorial2(N, 1).

fatorial2(0, Acc) -> Acc;
fatorial2(N, Acc) when N > 0 -> 
	io:format("~p~n", [N]),
	fatorial2(N-1, N * Acc).


% funcao insere
insere(Item, Lista) -> [Item|Lista].

% funcao final
insere_final(Item, Lista) -> Lista ++ Item.


% funcao inverter
inverter([]) -> [];
inverter([H|T]) -> inverter(T) ++ [H].





 
	

