-module(estudo3).
-compile(export_all).
-import(matematica, [sqrt/1, testSqrt/0]).
-include("tipos.hrl").

% Variáveis em maiúscula
% Para compilar: c(estudo3)
% Para sair: q().
% fortemente e dinamicamente tipado


% funcao soma
% uso: estudo3:soma(2, 3).
soma(A, B) -> A + B.


% funcao duplica
% uso:  estudo3:duplica([1,2,3]).
duplica([]) -> [];
duplica([H|T]) -> [(H * 2) | duplica(T)].


% funcao inc
% Dúvida: como fazer igua ao Haskell
inc(X) -> soma(X, 1).


% funcao conta
% uso: estudo3:conta([1,2,3]).
conta([]) -> 0;
conta([_|T]) -> 1 + conta(T).

% funcao ordena
% uso: estudo3:ordena([10,4,8,6,1,0]).
ordena([]) -> [];
ordena([H|T]) -> 
	Menores = [X || X <- T, X < H],
	Maiores = [X || X <- T, X > H],
	ordena(Menores) ++ [H] ++ ordena(Maiores).


% funcao multiplica_valor
multiplica_valor(X) ->
	Multiplica = fun(A, B) -> A * B end,
	Multiplica(X, X).


soma_erro(X) -> X + '1'.

% funcao name_case
name_case(Str) -> 
	Primeiro_caracter = string:substr(Str, 1, 1),
    Restante_string = string:substr(Str, 2),
	string:to_upper(Primeiro_caracter) ++ Restante_string.

% funcao name_case2
name_case2([H|T]) when H >= $a, H =< $z -> 
	[H + ($A - $a) | T];
name_case2(outros) -> outros.


% funcao modernize
modernize([H|T]) -> 
	Tokens = string:tokens([H|T], " "),
	Lista = [name_case(S) || S <- Tokens],
	string:join(Lista, " ").


% funcao igual
% obs.: a ordem aqui é importante
igual(A, A) -> true;
igual(_, _) -> false.


% funcao head
head([]) -> [];
head([H|_]) -> H.


% funcao segundo
segundo([]) -> [];
segundo([_,X|_]) -> X.


% funcao terceiro
terceiro([]) -> [];
terceiro([_,_,X|_]) -> X.


% funcao ultimo
% uso: estudo3:ultimo([1,2,3,4,5,6,12]).
ultimo([X]) -> X;
ultimo([_|T]) -> ultimo(T).


% funcao nano_get_url
nano_get_url(Host) ->
	case gen_tcp:connect(Host,80,[binary, {packet, 0}]) of
		{ok,Socket} -> 
			ok = gen_tcp:send(Socket, "GET / HTTP/1.0\r\n\r\n"),
			receive_data(Socket, []);
		{error,nxdomain} ->
			io:format("Url ~p não encontrada.~n", [Host])
	end.


receive_data(Socket, SoFar) ->
	receive
		{tcp,Socket,Bin} ->
			receive_data(Socket, [Bin|SoFar]);
		{tcp_closed,Socket} ->
			list_to_binary(lists:reverse(SoFar))
	end.


% funcao print_date_time
print_date_time({ Date = {D, M, Y}, Time = {H, Min, S}}) ->
	io:format("Date ~p is ~p/~p/~p~n", [Date, D, M, Y]),
	io:format("Time ~p is ~p:~p:~p~n", [Time, H, Min, S]).
	
print_date_time2(Date) ->
	[ Dia = {__}, _, Mes = {__}, _, Ano = {____}] = Date,
	io:format("Date ~p is ~p/~p/~p~n", [Date, Dia, Mes, Ano]),
	{ Dia, Mes, Ano }.



generate_exception(1) -> a;
generate_exception(2) -> throw(a);
generate_exception(3) -> exit(a);
generate_exception(4) -> {'EXIT', a};
generate_exception(5) -> error(a).


demo1() ->
	[catcher(I) || I <- [1,2,3,4,5]].

catcher(N) ->
	try generate_exception(N) of
		Val -> {N, normal, Val}
	catch
		throw:X -> {N, caught, thrown, X};
		exit:X -> {N, caught, exited, X};
		error:X -> {N, caught, error, X}
	end.




% trabalhando com Binary

% <<"everton">>

% Dados = term_to_binary([1,2,3,4, "everton", 3.14, {tipo, 12}]).
% binary_to_term(Dados).


% chamar código dinamicamente
% passa o módulo, após a função e por último a lista de parâmetros
% apply(erlang, atom_to_list, [hello]).



% chama funcao de outro módulo importado
-spec sqrt2(Val :: non_neg_integer()) -> pos_integer().
sqrt2(Val) -> matematica:testSqrt(Val).

sqrt3(Val) -> sqrt2(Val).


f(X) -> X.

% Match operador
minha_lista([H|T] = Lista) -> { Lista, H, T }.


% flatten 	
flatten(List) -> lists:flatten(List).


