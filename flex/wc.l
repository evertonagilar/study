/* Example 1-1. Word count fb1-1.l */
/* just like Unix wc */

%{
	int chars = 0;
	int words = 0;
	int lines = 0;
%}

%%

[a-zA-Z]+
\n
.
{ words++; chars += strlen(yytext); }
{ chars++; lines++; }
{ chars++; }

%%
main(int argc, char **argv)
{
	yylex();
	printf("%8d%8d%8d\n", lines, words, chars);
}
