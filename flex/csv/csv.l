%option noyywrap

%{
	#include "csv.tab.h"
%}


%%


[a-zA-Z0-9_ ]*	{ yylval = yytext; return FIELD;  }
;				{ return SEPARATOR; }
\n				{ puts("\\n pressionado"); return NEW_LINE; }
\r				{ puts("\\r pressionado"); return NEW_LINE; }
\0				{ printf("ops!"); return FIM; }
.				{ printf("Mystery character %s\n", yytext); return NOP; }



%%


