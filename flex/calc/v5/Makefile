CC=gcc

calc: calc.l calc.y calc_ast.c calc_ast.h calc_symbol.h calc_symbol.c calc_eval.c calc_eval.h
	bison -d calc.y
	flex calc.l
	$(CC) -o $@	calc_symbol.c calc_ast.c calc.tab.c lex.yy.c calc_eval.c -lfl
	
clean:	
	rm -f calc.tab.h calc.tab.c lex.yy.c calc calc.o calc_ast *.o
