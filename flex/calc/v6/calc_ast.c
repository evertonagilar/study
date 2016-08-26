#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "calc.tab.h"
#include "calc_ast.h"
#include "calc_symbol.h"

ast *new_assigment_ast(int node_type, ast *l, ast *r){
	assigment_ast *result = malloc(sizeof(assigment_ast));
	result->node_type = node_type;
	result->l = l;
	result->r = r;
	return (ast*) result;
}

ast *new_expr_ast(int node_type, ast *l, ast *r){
	expr_ast *result = malloc(sizeof(expr_ast));
	result->node_type = node_type;
	result->l = l;
	result->r = r;
	return (ast*) result;
}

ast *new_expr_bool_ast(int node_type, ast *l, ast *r){
	expr_bool_ast *result = malloc(sizeof(expr_bool_ast));
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

ast *new_identifier_ast(int node_type, symbol_t *value){
	identifier_ast *result = malloc(sizeof(identifier_ast));
	result->node_type = node_type;
	result->value = value;
	return (ast*) result;
}

ast *new_if_ast(int node_type, ast *cond, ast *if_flow, ast *else_flow){
	if_ast *result = malloc(sizeof(if_ast));
	result->node_type = node_type;
	result->cond = (expr_bool_ast*)cond;
	result->if_flow = if_flow;
	result->else_flow = else_flow;
	return (ast*)result;
}





	

