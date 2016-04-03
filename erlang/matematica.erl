-module(matematica).
-compile(export_all).


% funcao sqrt com tratamento de exception
sqrt(X) when X < 0 ->
	%error({exceptionSqrtNumeroNegativo, X});
	{ error, numeroNegativo };

sqrt(X) ->
	{ ok, math:sqrt(X) }.


% como usar exception
% e imprimir stacktrace na tela
testSqrt(X) ->
	try	sqrt(X)
	catch 
		throw:{exceptionSqrtNumeroNegativo, X} -> 
			io:format("Oh, o número ~p é inválido!!!~n", [X]);
		error:{exceptionSqrtNumeroNegativo, X} -> 
			io:format("Oh, o número ~p é inválido!!!~n", [X]),
			erlang:get_stacktrace();
		{error, numeroNegatico } -> 
			io:format("Xiiii, um numero negativo nao se aplica sqrt!~n")
	end.



