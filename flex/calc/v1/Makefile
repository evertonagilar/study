CC=gcc

calc: calc.l calc.y
	bison -d calc.y
	flex calc.l
	$(CC) -o $@	calc.tab.c lex.yy.c -lfl
