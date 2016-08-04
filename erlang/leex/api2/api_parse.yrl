Nonterminals
	expr
	term
	assigment
	.
	
	
Terminals
	'+' '-' '&&' '||' '=' '|='
	union intersection
	var string integer
	.
	
	
Rootsymbol	expr.


expr -> var assigment term : {expr, {var, unwrap('$1')}, '$2', '$3'}.

assigment -> '=' : unwrap('$1').

term -> integer : unwrap('$1').

term -> string : unwrap('$1').


Erlang code.	

unwrap({_, _, V}) -> V.


