#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "calc_symbol.h"

int hashsym(char *name){
	int result = 0;
	while (*name){
		result += *name ^ 9;
		++name;
	}
	result = result % MAX_SYMBOL_TABLE;
	return result;
}


symbol_t *lookup(char *name){
	int hash = hashsym(name);
	symbol_t *result = &symbol_table[hash];
	result->name = malloc(strlen(name)+2);
	strcpy(result->name, name);
	return result;
}


/*
int main(){
	symbol_t *var = lookup("valorTotal");
	printf("var is %s com valor %i\n", var->name, var->value);
	
	var = lookup("valorTotal");
	printf("antes %i\n", var->value);
	var->value = 15;
	printf("var is %s com valor %i\n", var->name, var->value);
	
	var = lookup("valorTotal");
	printf("antes %i\n", var->value);
	var->value = 20;
	printf("var is %s com valor %i\n", var->name, var->value);

	var = lookup("valorTotal");
	printf("antes %i\n", var->value);
	var->value = 50;
	printf("var is %s com valor %i\n", var->name, var->value);

	return 0;
}
*/
