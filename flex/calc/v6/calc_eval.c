/* calc_eval */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "calc_eval.h"
#include "calc.tab.h"
#include "calc_ast.h"
#include "calc_symbol.h"

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

int eval_identifier(ast *node){
	identifier_ast *identifier = (identifier_ast*)node;
	return identifier->value->as_int;
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

int eval_assigment(ast *node){
	assigment_ast *assigment = (assigment_ast*)node;
	identifier_ast *identifier = (identifier_ast*)assigment->l;
	expr_ast *expr = (expr_ast *)assigment->r;
	identifier->value->as_int = eval((ast*)expr);
	return identifier->value->as_int;
}

int eval_ifsmnt(ast *node){
	if_ast *ifsmnt = (if_ast*)node;
	if (eval((ast*)ifsmnt->cond) == 1){
		return eval(ifsmnt->if_flow);
	}else{
		return eval(ifsmnt->else_flow);
	}
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
		case IDENTIFIER:
			result = eval_identifier(node);
			break;
		case GT_OP:
			result = eval_gt_op(node);
			break;
		case GTE_OP:
			result = eval_gte_op(node);
			break;
		case LT_OP:
			result = eval_lt_op(node);
			break;
		case LTE_OP:
			result = eval_lte_op(node);
			break;
		case EQ_OP:
			result = eval_eq_op(node);
			break;
		case NE_OP:
			result = eval_ne_op(node);
			break;
		case '=':
			result = eval_assigment(node);
			break;
		case IF:
			result = eval_ifsmnt(node);
			break;

	}
	return result;
}


