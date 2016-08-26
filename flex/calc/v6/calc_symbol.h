/* calc_symbol */
#ifndef __CALC_SYMBOL__
#define __CALC_SYMBOL__

#define MAX_SYMBOL_TABLE 9999

typedef struct{
	char *name;
	int as_int;
} symbol_t;

symbol_t symbol_table[MAX_SYMBOL_TABLE];


symbol_t *lookup(char *);


#endif 
