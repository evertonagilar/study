CC=gcc

calc: calc.l calc.y calc_ast.c calc_ast.h
	bison -d calc.y
	flex calc.l
	$(CC) -o $@	calc_ast.c calc.tab.c lex.yy.c -lfl
