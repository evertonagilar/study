#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "calc.tab.h"
#include "calc_ast.h"


ast *new_expr_ast(int node_type, ast *l, ast *r){
	expr_ast *result = malloc(sizeof(expr_ast));
	result->node_type = node_type;
	result->l = l;
	result->r = r;
	return (ast*) result;
}

ast *new_term_ast(int node_type, int value){ 
	term_ast *result = malloc(sizeof(term_ast));
	result->node_type = node_type;
	result->value = value;
	return (ast*) result;
}

int eval_add(ast *node){
	expr_ast *expr = (expr_ast*)node;
	return eval(expr->l) + eval(expr->r);
}

int eval_minus(ast *node){
	expr_ast *expr = (expr_ast*)node;
	return eval(expr->l) - eval(expr->r);
}

int eval_mult(ast *node){
	expr_ast *expr = (expr_ast*)node;
	return eval(expr->l) * eval(expr->r);
}

int eval_div(ast *node){
	expr_ast *expr = (expr_ast*)node;
	return eval(expr->l) / eval(expr->r);
}

int eval_number(ast *node){
	term_ast *num = (term_ast*)node;
	return num->value;
}



int eval(ast *node){
	int result;
	switch(node->node_type){
		case '+': 
			result = eval_add(node);
			break;
		case '-': 
			result = eval_minus(node);
			break;
		case '*': 
			result = eval_mult(node);
			break;
		case '/': 
			result = eval_div(node);
			break;
		case NUMBER:
			result = eval_number(node);
			break;
	}
	return result;
}

/*int main(){
	printf("teste expressao\n");
	
	ast *val5 = new_term_ast(NUMBER, 12);
	ast *val12 = new_term_ast(NUMBER, 12);
	ast *val2 = new_term_ast(NUMBER, 2);
	ast *expr = new_expr_ast('-', val5, new_expr_ast('/', val12, val2));
	int result = eval(expr);
	printf("Result: %d\n", result);
	
}
*/
