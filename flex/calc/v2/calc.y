%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "calc_ast.h"

char *yylex();
int yyerror(char *s);
 
%}

%union {
	char *str;
	int d;
}

%token	<d> NUMBER
%token	EOL
%token  OP
%token  CP

%type <d> expr factor term

%%

grammar: /* nothing */
	| grammar expr EOL	{ printf("Result: %d\n", eval($2)); }
	;


expr: factor
	| expr '+' factor			{ $$ = new_expr_ast('+', $1, $3); }
	| expr '-' factor			{ $$ = new_expr_ast('-', $1, $3); }


factor: term
	  |	factor '*' term			{ $$ = new_expr_ast('*', $1, $3); }
	  |	factor '/' term			{ $$ = new_expr_ast('/', $1, $3); }
	  ;


term: NUMBER					{ $$ = new_term_ast(NUMBER, $1); }
    ;
    

%%


int main(int argc, char **argv){
	while (yyparse()){
	
	};

}

int yyerror(char *s){
	fprintf(stderr, "Error: %s\n", s);
}
