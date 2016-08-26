%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "calc_ast.h"
#include "calc_symbol.h"
#include "calc_eval.h"

char *yylex();
int yyerror(char *s);
 
%}

%union {
	char *str;
	struct ast *a;
	int d;
}

%token	<d> NUMBER
%token	<str> IDENTIFIER
%token	EOL
%token  OP
%token  CP
%token 	GT_OP LT_OP GTE_OP LTE_OP EQ_OP NE_OP
%token	IF ELSE

%type <a> statement expr factor term expr_bool assigment
%type <a> identifier
%type <a> if_smnt

%%

grammar: /* nothing */
	| grammar statement								{ printf("%d", eval($2)); }
	;


statement: expr_bool EOL							{ $$ = $1; }
	| 	assigment EOL								{ $$ = $1; }
	| 	if_smnt										{ $$ = $1; }
	;


if_smnt: IF '(' expr_bool ')' '{'
			statement
		 '}' ELSE '{'
			statement
		 '}'										{ $$ = new_if_ast(IF, $3, $6, $10); }
	;


assigment: identifier	'='	expr					{ $$ = new_assigment_ast('=', $1, $3); }
	;
	
expr_bool: expr
	|	expr_bool GT_OP  expr						{ $$ = new_expr_bool_ast(GT_OP, $1, $3); }
	|	expr_bool GTE_OP expr						{ $$ = new_expr_bool_ast(GTE_OP, $1, $3); }
	|	expr_bool LT_OP  expr						{ $$ = new_expr_bool_ast(LT_OP, $1, $3); }
	|	expr_bool LTE_OP expr						{ $$ = new_expr_bool_ast(LTE_OP, $1, $3); }
	|	expr_bool EQ_OP  expr						{ $$ = new_expr_bool_ast(EQ_OP, $1, $3); }
	|	expr_bool NE_OP  expr						{ $$ = new_expr_bool_ast(NE_OP, $1, $3); }
	;
										

expr: factor
	|	expr '+' factor								{ $$ = new_expr_ast('+', $1, $3); }
	| 	expr '-' factor								{ $$ = new_expr_ast('-', $1, $3); }
	;
	

factor: term
	|	factor '*' term								{ $$ = new_expr_ast('*', $1, $3); }
	|	factor '/' term								{ $$ = new_expr_ast('/', $1, $3); }
	;


term: NUMBER										{ $$ = new_term_ast(NUMBER, $1); }
	|	'-' NUMBER									{ $$ = new_term_ast(NUMBER, $2 * -1); }
	| 	identifier									{ $$ = $1; }
	|	'(' expr ')'								{ $$ = $2; }
    ;
    
    
identifier:	IDENTIFIER								{ $$ = new_identifier_ast(IDENTIFIER, lookup($1)); }
	;


%%


int main(int argc, char **argv){
	while (yyparse()){
	
	};

}

int yyerror(char *s){
	fprintf(stderr, "Error: %s\n", s);
}
