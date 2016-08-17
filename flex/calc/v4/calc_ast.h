typedef struct ast {
	int node_type;
} ast;

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


ast *new_expr_ast(int node_type, ast *l, ast *r);
ast *new_expr_bool_ast(int node_type, ast *l, ast *r);
ast *new_term_ast(int node_type, int value);
int eval(ast *);
	
	
	
