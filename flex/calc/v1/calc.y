%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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
	| grammar expr EOL	{ printf("Result: %d\n", $2); }
	;


expr: factor
	| expr '+' factor				{ $$ = $1 + $3; }
	| expr '-' factor				{ $$ = $1 - $3; }


factor: term
	  |	factor '*' term			{ $$ = $1 * $3; }
	  |	factor '/' term			{ $$ = $1 / $3; }
	  ;


term: NUMBER
    ;
    

%%


int main(int argc, char **argv){
	while (yyparse()){
	
	};

}

int yyerror(char *s){
	fprintf(stderr, "Error: %s\n", s);
}
