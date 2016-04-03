# Makefile for compile calc

CC=gcc

calc:	calc.l calc.y clean
		bison -d calc.y
		flex calc.l
			$(CC) -o $@ calc.tab.c lex.yy.c -lfl
		
clean:
		rm -f calc.tab.h calc.tab.c lex.yy.c calc
