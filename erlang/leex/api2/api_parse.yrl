Nonterminals
	statement
	expr expr_bool
	term
	factor
	.
	
	
Terminals
	add_op mult_op
	assigment_op 
	bool_op
	set_op
	var string integer
	.
	
	
Rootsymbol	statement.

statement -> var assigment_op expr 		: {statement, {'$1', '$2', '$3'}}.
statement -> var assigment_op expr_bool : {statement, {'$1', '$2', '$3'}}.

expr_bool -> expr bool_op expr: {expr_bool, {'$1', '$2', '$3'}}.

expr -> term : {expr, '$1'}.
expr -> expr add_op term : {expr, {'$1', '$2', '$3'}}.

term -> factor : '$1'.
term -> term mult_op factor : {expr, {'$1', '$2', '$3'}}.

factor -> var : '$1'.
factor -> integer : '$1'.
factor -> string : '$1'.


Erlang code.	

unwrap({_, _, V}) -> V.


