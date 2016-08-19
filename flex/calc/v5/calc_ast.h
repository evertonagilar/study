/* calc_ast */
#ifndef __CALC_AST__
#define __CALC_AST__

#include "calc_symbol.h"

typedef struct ast {
	int node_type;
} ast;

typedef struct assigment_ast {
	int node_type;
	ast *l;
	ast *r;
} assigment_ast;

typedef struct expr_ast {
	int node_type;
	ast *l;
	ast *r;
} expr_ast;
	
typedef struct expr_bool_ast {
	int node_type;
	ast *l;
	ast *r;
} expr_bool_ast;

typedef struct term_ast {
	int node_type;
	int value;
} term_ast;

typedef struct identifier_ast {
	int node_type;
	symbol_t *value;
} identifier_ast;


ast *new_assigment_ast(int node_type, ast *l, ast *r);
ast *new_expr_ast(int node_type, ast *l, ast *r);
ast *new_expr_bool_ast(int node_type, ast *l, ast *r);
ast *new_term_ast(int node_type, int value);
ast *new_identifier_ast(int node_type, symbol_t *value);


	
	
	
#endif
