#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "calc_ast.h"
#include "calc_symbol.h"
#include "calc_eval.h"
#include "calc.tab.h"

int main(){
	printf("Test expressao\n");
	
	ast *val5 = new_term_ast(NUMBER, 5);
	ast *val10 = new_term_ast(NUMBER, 10);
	ast *val2 = new_term_ast(NUMBER, 2);
	ast *expr = new_expr_ast('+', val5, new_expr_ast('/', val10, val2));
	ast *var1 = new_identifier_ast(IDENTIFIER, lookup("var1"));
	ast *assigment = new_assigment_ast('=', var1, expr); 
	int result = eval(assigment);

	printf("var1 = 5 + 10 / 2  =>  %d\n", result);

	ast *expr2 = new_expr_ast('+', val5, new_identifier_ast(IDENTIFIER, lookup("var1")));	
	int result2 = eval(expr2);
	printf("5 + var1  =>  %d\n", result2);
	
}

