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
#include "lee_scanner_symbol_table.h"

static const int INITIAL_CAPACITY = 100;


/*
 * Get a symbol from symbol table or insert it if doesn't exist and return
 *
 */
lee_symbol_t *lee_scanner_symbol_table_get_or_push(lee_scanner_symbol_table_t *table, char *identifier, int identifier_sz, lee_symbol_class_t symbolClass, lee_token_type_t tokenType) {
    lee_symbol_t *id;
    for (int i = 0; i < table->count; i++){
        id = table->itens + i;
        if (strncmp(id->name, identifier, identifier_sz) == 0){
            return id;
        }
    }
    id = lee_scanner_symbol_table_push(table, identifier, identifier_sz, symbolClass, tokenType);
    return id;
}

lee_symbol_t *lee_scanner_symbol_table_push(lee_scanner_symbol_table_t *table, char *identifier, int identifier_sz, lee_symbol_class_t symbolClass, lee_token_type_t tokenType) {
    lee_symbol_t *id = table->itens + table->count;
    if (symbolClass == scIdentifier) {
        id->name = strndup(identifier, identifier_sz);
    }else{
        id->name = identifier;      // name point to lee_token_text[tokenType] string
    }
    id->hash = table->count++;
    id->symbolClass = symbolClass;
    id->tokenType = tokenType;
    return id;
}

void lee_scanner_symbol_table_push_keyword(lee_scanner_symbol_table_t *table, lee_symbol_class_t symbolClass, lee_token_type_t tokenType) {
    char *identifier = lee_token_text[tokenType];
    lee_scanner_symbol_table_push(table, identifier, 0, symbolClass, tokenType);
}

/*
 * Load symbol table with language keywords
 *
 */
void loadLanguageKeywords(lee_scanner_symbol_table_t *table) {
    lee_scanner_symbol_table_push_keyword(table, scKeyword, tkProgram);
    lee_scanner_symbol_table_push_keyword(table, scType, tkChar);
    lee_scanner_symbol_table_push_keyword(table, scKeyword, tkElse);
    lee_scanner_symbol_table_push_keyword(table, scType, tkEnum);
    lee_scanner_symbol_table_push_keyword(table, scKeyword, tkIf);
    lee_scanner_symbol_table_push_keyword(table, scType, tkInt);
    lee_scanner_symbol_table_push_keyword(table, scKeyword, tkReturn);
    lee_scanner_symbol_table_push_keyword(table, scKeyword, tkSizeOf);
    lee_scanner_symbol_table_push_keyword(table, scKeyword, tkWhile);
    lee_scanner_symbol_table_push_keyword(table, scType, tkVoid);
    lee_scanner_symbol_table_push_keyword(table, scKeyword, tkInterface);
    lee_scanner_symbol_table_push_keyword(table, scKeyword, tkImplementation);
}

lee_scanner_symbol_table_t *lee_scanner_symbol_table_create() {
    lee_scanner_symbol_table_t *table = malloc(sizeof(lee_scanner_symbol_table_t));
    table->count = 0;
    table->itens = malloc(sizeof(lee_symbol_t*) * INITIAL_CAPACITY);
    loadLanguageKeywords(table);
    return table;
}

void lee_scanner_symbol_table_free(lee_scanner_symbol_table_t *table) {
    for (int i = 0; i < table->count; i++){
        lee_symbol_t *id = table->itens + i;
        if (id->tokenType == tkIdentifier) {
            free(id->name);
        }
    }
    free(table->itens);
    free(table);
}
