/*
 * %CopyrightBegin%
 *
 * Copyright Everton de Vargas Agilar 2022. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * %CopyrightEnd%
 */


#include <stdlib.h>
#include <string.h>
#include "agl_symbol_table.h"

static const int INITIAL_CAPACITY = 100;

agl_symbol_table_t *agl_symbol_table_create() {
    agl_symbol_table_t *t = malloc(sizeof(agl_symbol_table_t));
    t->size = 0;
    t->itens = malloc(sizeof(agl_symbol_t*) * INITIAL_CAPACITY);
    return t;
}

void agl_symbol_table_free(agl_symbol_table_t *table) {
    for (int i = 0; i < table->size; i++){
        agl_symbol_t *id = table->itens + i;
        free(id->value);
    }
    free(table->itens);
    free(table);
}

/*
 * Get a symbol from symbol table or insert it if doesn't exist and return
 *
 */
agl_symbol_t *agl_symbol_table_get(agl_symbol_table_t *table, char *identifier, int identifier_sz) {
    agl_symbol_t *id;
    for (int i = 0; i < table->size; i++){
        id = table->itens + i;
        if (strncmp(id->value, identifier, identifier_sz) == 0){
            return id;
        }
    }
    id = agl_symbol_table_push(table, identifier, identifier_sz, stIdentifier);
    return id;
}

agl_symbol_t *agl_symbol_table_push(agl_symbol_table_t *table, char *identifier, int identifier_sz, enum agl_symbol_type_t type) {
    agl_symbol_t *id = table->itens + table->size;
    id->value = strndup(identifier, identifier_sz);
    id->hash = table->size++;
    id->type = type;
    return id;
}
