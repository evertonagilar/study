%{
#include<stdio.h>
#include<string.h>

char csv_file[100][100];
int field_count = 0;
extern FILE *yyin;
extern char *yylex();

%}


/* tokens */

%token	FIELD
%token	SEPARATOR
%token	NEW_LINE
%token	NOP
%token 	FIM


%%

record: col_set	 						{ 	printf("record is %s\n", $1);
											for (int i = 0; i < field_count; i++){
												printf("Column %i: %s\n", i, csv_file[i]);
											}
											field_count = 0;

										}


col_set:
	   | SEPARATOR col_set				{ strcpy(csv_file[field_count++], "branco"); $$ = $1; }
       | column	NEW_LINE
	   | column	SEPARATOR col_set	

	   ;


column: FIELD							{	
											strcpy(csv_file[field_count++], $1); 
										}

	  ;


%%

int yyerror(char *s){
	fprintf(stderr, "Erro -> %s\n", s);
}

int main(int argc, char **argv){
	printf("argc => %i\n", argc);
	if (argc > 1){
		char *filename = argv[1];
		yyin = fopen(filename, "r");
	}
	yylex();
	while (1) {
		yyparse();
		fclose(yyin);
		yyin = stdin;
		yyrestart(yyin);
	}
}


