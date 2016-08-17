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
%token 	GT_OP LT_OP GTE_OP LTE_OP EQ_OP NE_OP

%type <d> expr factor term expr_bool

%%

grammar: /* nothing */
	| grammar expr_bool EOL						{ printf("= %d\n", eval($2)); }
	| grammar expr EOL							{ printf("= %d\n", eval($2)); }
	;


expr_bool: expr
	| expr_bool GT_OP  expr						{ $$ = new_expr_bool_ast(GT_OP, $1, $3); }
	| expr_bool GTE_OP expr						{ $$ = new_expr_bool_ast(GTE_OP, $1, $3); }
	| expr_bool LT_OP  expr						{ $$ = new_expr_bool_ast(LT_OP, $1, $3); }
	| expr_bool LTE_OP expr						{ $$ = new_expr_bool_ast(LTE_OP, $1, $3); }
	| expr_bool EQ_OP  expr						{ $$ = new_expr_bool_ast(EQ_OP, $1, $3); }
	| expr_bool NE_OP  expr						{ $$ = new_expr_bool_ast(NE_OP, $1, $3); }
										


expr: factor
	| expr '+' factor							{ $$ = new_expr_ast('+', $1, $3); }
	| expr '-' factor							{ $$ = new_expr_ast('-', $1, $3); }


factor: term
	  |	factor '*' term							{ $$ = new_expr_ast('*', $1, $3); }
	  |	factor '/' term							{ $$ = new_expr_ast('/', $1, $3); }
	  ;


term: NUMBER									{ $$ = new_term_ast(NUMBER, $1); }
	| '-' NUMBER								{ $$ = new_term_ast(NUMBER, $2 * -1); }
	| '(' expr ')'								{ $$ = $2; }
    ;
    

%%


int main(int argc, char **argv){
	while (yyparse()){
	
	};

}

int yyerror(char *s){
	fprintf(stderr, "Error: %s\n", s);
}
