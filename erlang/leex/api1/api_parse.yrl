Nonterminals 
	expr_list 
	expr 
	list 
	element 
	elements
	.

Terminals
	'(' ')' ','
	atom var integer string set 
	union intersection 
	operator
	.

Rootsymbol expr_list.

expr_list -> expr : '$1'.
expr_list -> expr union expr : {union, '$1', '$3'}.
expr_list -> expr intersection expr : {intersection, '$1', '$3'}.
expr_list -> expr_list union expr : {union, '$1', '$3'}.

expr -> var set list : {expr, {var, unwrap('$1')}, memberof, '$3'}.
expr -> var operator element : {expr, {var, unwrap('$1')}, unwrap('$2'), '$3'}.

list -> '(' ')' : nil.
list -> '(' elements ')' : {list,'$2'}.

elements -> element : ['$1'].
elements -> element ',' elements : ['$1'] ++ '$3'.
element -> atom : '$1'.
element -> var : unwrap('$1').
element -> integer : unwrap('$1').
element -> string : unwrap('$1').

Erlang code.

unwrap({_,_,V}) -> V.
