-module(funcoes).
-export([fac/1, soma/1, area/1, test_area/0, custo/1, custoCesta/1, sum/1, for/3, mapa/2, max/2, codigo/1, impar_e_par/1]).


fac(0) -> 1;
fac(X) -> X * fac(X-1).

area({retangulo, Width, Height}) -> Width * Height;
area({quadrado, Lado}) -> Lado * Lado.

test_area() ->
	8 = area({retangulo, 2, 4}),
	16 = area({quadrado, 4}),
	teste_ok.


custo(laranja)	->	1.50;
custo(abacate)	->	8.00;
custo(manga)	->	5.00;
custo(pera)		-> 	7.00.

custoCesta([])					-> 0;
custoCesta([{Fruta, Qtd}|T])	->	custo(Fruta) * Qtd + custoCesta(T).

sum([H|T])	->	H + sum(T);
sum([]) 	-> 0.


% Custo = fun(X) -> custo(X) end. 


% [ X || X <- lists:seq(1,100), not(X rem 2 == 0)].


% lists:foldl(fun(X, Y) -> X+Y end, 0, [1,2]).

	
% Carros = [gol, classic, corsa, palio]. 
% IsCarro = fun(X) -> lists:member(X, Carros) end.
% lists:filter(IsCarro, [fusca, gol, palio, classic]). 


% Mult = fun(Times) -> ( fun(X) -> X * Times end ) end.
% Tripe = Mult(3). 
% Tripe(2). 

for(Max, Max, F) 	-> [F(Max)];
for(I, Max, F)		-> [F(I)|for(I+1, Max, F)].


soma([H|T])	-> H + soma(T); 
soma([]) 	-> 0.




% ult([H|T]) when lists:length([H|T]) > 0	->	ult(T);
% ult(X)	->	X.


% lists:map(fun(X) -> X*X end , [1,2,3,4]).
% [ X*X || X <- [1,2,3,4]].

% lists:filter(fun(X) -> X rem 2 == 0 end , [1,2,3,4]).



% Frutas = [{laranja, 2}, {pera, 3}, {melancia, 10}].
% [ {Name, Qtd*2} || {Name, Qtd} <- Frutas ].    


% { F, Q } = { pera, 10 }.  



mapa(F, L)	->	[F(X) || X <- L].
% funcoes:mapa(fun(X) -> X*X end, [1,2,3,4,5]). 

max(X, Y) when X > Y -> X;
max(X, Y)			 -> Y.


% T = {"Everton", "Agilar"}.
% length(tuple_to_list(T)).



codigo(X) ->
	if 
		X >= 50, X < 100 	-> 	2;
		X > 0, X < 50 	 	-> 	1;
		true 				-> 3
	end.


impar_e_par(Lista) ->
	Impar	= [X || X <- Lista, X rem 2 /= 0],
	Par 	= [X || X <- Lista, X rem 2 =:= 0],
	{Impar, Par}.




						




	






