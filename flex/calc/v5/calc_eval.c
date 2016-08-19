/* calc_eval */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "calc.tab.h"
#include "calc_ast.h"
#include "calc_symbol.h"

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

