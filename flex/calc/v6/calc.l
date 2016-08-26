%option noyywrap

%{
#include "calc.tab.h"
%}




%%

if							return IF;
else						return ELSE;

[0-9]+						{ yylval.d = atoi(yytext); 
							  return NUMBER; }
				  
[a-zA-Z_][a-zA-Z0-9_]*		{ yylval.str = yytext; 
							  return IDENTIFIER; }

"+"	|			
"-"	|			
"*"	|			
"/"	|			
"("	|			
")"	|
"{"	|
"}" |
"-"	|
"="							return yytext[0];

">"  						return GT_OP;
"<"  						return LT_OP;
">=" 						return GTE_OP;
"<=" 						return LTE_OP;
"==" 						return EQ_OP;
"!=" 						return NE_OP;
"<>" 						return NE_OP;

";"							return EOL;

[ \t\r]						{ /* ignore */ }

.							printf("desconhecido: %c", yytext[0]);











%%

