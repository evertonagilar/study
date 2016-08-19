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

int eval_gt_op(ast *node){
	expr_bool_ast *expr = (expr_bool_ast*)node;
	return eval(expr->l) > eval(expr->r) ? 1 : 0;
}

int eval_gte_op(ast *node){
	expr_bool_ast *expr = (expr_bool_ast*)node;
	return eval(expr->l) >= eval(expr->r) ? 1 : 0;
}

int eval_lt_op(ast *node){
	expr_bool_ast *expr = (expr_bool_ast*)node;
	return eval(expr->l) < eval(expr->r) ? 1 : 0;
}

int eval_lte_op(ast *node){
	expr_bool_ast *expr = (expr_bool_ast*)node;
	return eval(expr->l) <= eval(expr->r) ? 1 : 0;
}

int eval_eq_op(ast *node){
	expr_bool_ast *expr = (expr_bool_ast*)node;
	return eval(expr->l) == eval(expr->r) ? 1 : 0;
}

int eval_ne_op(ast *node){
	expr_bool_ast *expr = (expr_bool_ast*)node;
	return eval(expr->l) != eval(expr->r) ? 1 : 0;
}

	

