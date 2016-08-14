csv: csv.l csv.y
	bison -d csv.y
	flex csv.l
	cc -o $@ csv.tab.c lex.yy.c -lfl
	 
clean:	
	rm -f csv csv.tab.c csv.tab.h lex.yy.c a.out


