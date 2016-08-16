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

">"  			return GT_OP;
"<"  			return LT_OP;
">=" 			return GTE_OP;
"<=" 			return LTE_OP;
"==" 			return EQ_OP;
"!=" 			return NE_OP;
"<>" 			return NE_OP;

\n				return EOL;

[ \t\r]			{ /* ignore */ }












%%

