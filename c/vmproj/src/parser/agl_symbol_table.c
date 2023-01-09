//
// Created by evertonagilar on 06/01/23.
//

#include <stdlib.h>
#include <string.h>
#include "agl_symbol_table.h"

static const int INITIAL_CAPACITY = 100;

agl_symbol_table_t *agl_symbol_table_create() {
    agl_symbol_table_t *t = malloc(sizeof(agl_symbol_table_t));
    t->size = 0;
    t->itens = malloc(sizeof(agl_identifier_t*) * INITIAL_CAPACITY);
    return t;
}

void agl_symbol_table_free(agl_symbol_table_t *table) {
    free(table->itens);
    free(table);
}

void agl_symbol_table_push(agl_symbol_table_t *table, agl_identifier_t *id) {
    agl_identifier_t *item = table->itens + table->size;
    item->type = id->type;
    item->value = strdup(id->value);
    item->hash = id->hash;
    ++table->size;
}

agl_identifier_t *agl_identifier_create() {
    return malloc(sizeof(agl_identifier_t));
}

void agl_identifier_free(agl_identifier_t *id) {
    free(id);
}

agl_identifier_t * agl_symbol_table_get(agl_symbol_table_t *table, char *identifier, int identifier_sz) {
    agl_identifier_t *id;
    for (int i = 0; i < table->size; i++){
        id = table->itens + i;
        if (strncmp(id->value, identifier, identifier_sz) == 0){
            return id;
        }
    }
    id = table->itens + table->size;
    id->value = strndup(identifier, identifier_sz);
    id->hash = table->size++;
    return id;
}
