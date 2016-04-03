-module(estudo).
-compile(export_all).

% soma números
soma(Numero1, Numero2) -> Numero1 + Numero2.

% soma lista
soma_lista([H|T]) -> H + soma_lista(T);
soma_lista([]) -> [].

% obtem o dia da semana
get_dia_semana(Semana) ->
	DiasSemana = [{segunda, 1}, {terca,2}, {quarta, 3}, {quinta, 4}, {sexta, 5}, {sabado, 6}, {domingo, 7}],	
	[Dia|_] = [D || {S,D} <- DiasSemana, S == Semana],
	Dia.

% primeiro elemento lista
primeiro([]) -> [];
primeiro([Primeiro|_]) -> Primeiro.


% segundo elemento lista
segundo([]) -> [];
segundo([_|[Segundo|_]]) -> Segundo.

% retorna true/false se um valor é igual ao outro
igual(Val, Val) -> true;
igual(_,_) -> false.

% fatorial
fatorial(0) -> 1;
fatorial(N) -> N * fatorial(N-1).







