%{
	enum Token {
		PLUS = 258,
		MINUS = 259,
		MUL = 260,
		DIV = 261,
		ABS = 262,
		NUMBER = 263,
		EOL = 264
	};	

	int token_value;	

%}

/* recognize tokens for the calculator and print them out */
%%

"+"		{ return PLUS; }
"-"		{ return MINUS; }
"*"		{ return MUL; }
"/"		{ return DIV; }
"|"		{ return ABS; }
[0-9]+ 	{ token_value = atoi(yytext);
		  return NUMBER; 
		}
\n		{ return EOL; }
[ \t] 	{ /* ignore spaces */ }
.		{ printf("Mystery character %s\n", yytext); }

%%

int main(int argc, char **argv){
	int token;
	while ((token = yylex())){
		printf("%d", token);
		if (token == NUMBER){
			printf(" = %d\n", token_value);
		}else{
			printf("\n");
		}
	}
}
