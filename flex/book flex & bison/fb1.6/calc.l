%{
#include "calc.tab.h"
%}

%%

"+"			{ return ADD; }
"-"			{ return SUB; }
"*"			{ return MUL; }
"/"			{ return DIV; }
"|"			{ return ABS; }
[0-9]+ 		{ yylval = atoi(yytext); return NUMBER; }
\n			{ return EOL; }
[ \t]	 	{ /* ignore spaces */ }
"\\".*		{ /* ignore comment */ }
"("			{ return OP; }
")"			{ return CP; }
.			{ printf("Mystery character %s\n", yytext); }

%%

