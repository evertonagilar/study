#define MAX_SYMBOL_TABLE 9999

typedef struct{
	char *name;
	int value;
} symbol_t;

symbol_t symbol_table[MAX_SYMBOL_TABLE];


symbol_t *lookup(char *);


