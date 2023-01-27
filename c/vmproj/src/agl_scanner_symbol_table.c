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
#include "agl_scanner_symbol_table.h"

static const int INITIAL_CAPACITY = 100;


/*
 * Get a symbol from symbol table or insert it if doesn't exist and return
 *
 */
agl_symbol_t *agl_scanner_symbol_table_get_or_push(agl_scanner_symbol_table_t *table, char *identifier, int identifier_sz, agl_symbol_class_t symbolClass, agl_token_type_t tokenType) {
    agl_symbol_t *id;
    for (int i = 0; i < table->count; i++){
        id = table->itens + i;
        if (strncmp(id->name, identifier, identifier_sz) == 0){
            return id;
        }
    }
    id = agl_scanner_symbol_table_push(table, identifier, identifier_sz, symbolClass, tokenType);
    return id;
}

agl_symbol_t *agl_scanner_symbol_table_push(agl_scanner_symbol_table_t *table, char *identifier, int identifier_sz, agl_symbol_class_t symbolClass, agl_token_type_t tokenType) {
    agl_symbol_t *id = table->itens + table->count;
    if (symbolClass == scIdentifier) {
        id->name = strndup(identifier, identifier_sz);
    }else{
        id->name = identifier;      // name point to agl_token_text[tokenType] string
    }
    id->hash = table->count++;
    id->symbolClass = symbolClass;
    id->tokenType = tokenType;
    return id;
}

void agl_scanner_symbol_table_push_keyword(agl_scanner_symbol_table_t *table, agl_token_type_t tokenType) {
    char *identifier = agl_token_text[tokenType];
    agl_scanner_symbol_table_push(table, identifier, 0, scKeyword, tokenType);
}

/*
 * Load symbol table with language keywords
 *
 */
void loadLanguageKeywords(agl_scanner_symbol_table_t *table) {
    agl_scanner_symbol_table_push_keyword(table, tkProgram);
    agl_scanner_symbol_table_push_keyword(table, tkChar);
    agl_scanner_symbol_table_push_keyword(table, tkElse);
    agl_scanner_symbol_table_push_keyword(table, tkEnum);
    agl_scanner_symbol_table_push_keyword(table, tkIf);
    agl_scanner_symbol_table_push_keyword(table, tkInt);
    agl_scanner_symbol_table_push_keyword(table, tkReturn);
    agl_scanner_symbol_table_push_keyword(table, tkSizeOf);
    agl_scanner_symbol_table_push_keyword(table, tkWhile);
    agl_scanner_symbol_table_push_keyword(table, tkVoid);
    agl_scanner_symbol_table_push_keyword(table, tkVoid);
    agl_scanner_symbol_table_push_keyword(table, tkInterface);
    agl_scanner_symbol_table_push_keyword(table, tkImplementation);
}

agl_scanner_symbol_table_t *agl_scanner_symbol_table_create() {
    agl_scanner_symbol_table_t *table = malloc(sizeof(agl_scanner_symbol_table_t));
    table->count = 0;
    table->itens = malloc(sizeof(agl_symbol_t*) * INITIAL_CAPACITY);
    loadLanguageKeywords(table);
    return table;
}

void agl_scanner_symbol_table_free(agl_scanner_symbol_table_t *table) {
    for (int i = 0; i < table->count; i++){
        agl_symbol_t *id = table->itens + i;
        if (id->tokenType == tkIdentifier) {
            free(id->name);
        }
    }
    free(table->itens);
    free(table);
}
