%option noyywrap

%{
#include "calc.tab.h"
%}




%%

[0-9]+			{ yylval.d = atoi(yytext); 
				  return NUMBER; }
"+"	|			
"-"	|			
"*"	|			
"/"	|			
"{"	|			
"}"				return yytext[0];

\n				return EOL;

[ \t\r]			{ /* ignore */ }












%%

