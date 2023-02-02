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
#include "lee_symbol_table.h"

static const int INITIAL_CAPACITY = 1000;


/*
 * Get a symbol from symbol table or insert it if doesn't exist and return
 *
 */
lee_symbol_t *lee_symbol_table_get_or_push(lee_symbol_table_t *table, char *identifier, int identifier_sz, lee_symbol_class_t symbolClass, lee_token_type_t tokenType) {
    lee_symbol_t *id;
    for (int i = 0; i < table->count; i++){
        id = table->itens + i;
        if (id->name_sz == identifier_sz && strncmp(id->name, identifier, identifier_sz) == 0){
            return id;
        }
    }
    id = lee_symbol_table_push(table, identifier, identifier_sz, symbolClass, tokenType);
    return id;
}

lee_symbol_t *lee_symbol_table_push(lee_symbol_table_t *table, char *identifier, int identifier_sz, lee_symbol_class_t symbolClass, lee_token_type_t tokenType) {
    lee_symbol_t *symbol = table->itens + table->count;
    symbol->name = identifier;
    symbol->name_sz = identifier_sz;
    symbol->hash = table->count++;
    symbol->symbolClass = symbolClass;
    symbol->tokenType = tokenType;
    return symbol;
}

void lee_symbol_table_push_keyword(lee_symbol_table_t *table, lee_symbol_class_t symbolClass, lee_token_type_t tokenType) {
    char *identifier = lee_token_text[tokenType];
    lee_symbol_table_push(table, identifier, 0, symbolClass, tokenType);
}

/*
 * Load symbol table with language keywords
 *
 */
void loadLanguageKeywords(lee_symbol_table_t *table) {
    // Keywords and types
    lee_symbol_table_push_keyword(table, scKeyword, tkAbstract);
    lee_symbol_table_push_keyword(table, scKeyword, tkAssert);
    lee_symbol_table_push_keyword(table, scKeyword, tkBoolean);
    lee_symbol_table_push_keyword(table, scKeyword, tkBreak);
    lee_symbol_table_push_keyword(table, scKeyword, tkByte);
    lee_symbol_table_push_keyword(table, scKeyword, tkCase);
    lee_symbol_table_push_keyword(table, scKeyword, tkCatch);
    lee_symbol_table_push_keyword(table, scType, tkChar);
    lee_symbol_table_push_keyword(table, scKeyword, tkClass);
    lee_symbol_table_push_keyword(table, scKeyword, tkConst);
    lee_symbol_table_push_keyword(table, scKeyword, tkContinue);
    lee_symbol_table_push_keyword(table, scKeyword, tkDefault);
    lee_symbol_table_push_keyword(table, scKeyword, tkDo);
    lee_symbol_table_push_keyword(table, scType, tkDouble);
    lee_symbol_table_push_keyword(table, scKeyword, tkElse);
    lee_symbol_table_push_keyword(table, scKeyword, tkEnum);
    lee_symbol_table_push_keyword(table, scKeyword, tkExports);
    lee_symbol_table_push_keyword(table, scKeyword, tkExtends);
    lee_symbol_table_push_keyword(table, scKeyword, tkFinal);
    lee_symbol_table_push_keyword(table, scKeyword, tkFinally);
    lee_symbol_table_push_keyword(table, scType, tkFloat);
    lee_symbol_table_push_keyword(table, scKeyword, tkFor);
    lee_symbol_table_push_keyword(table, scKeyword, tkIf);
    lee_symbol_table_push_keyword(table, scKeyword, tkGoto);
    lee_symbol_table_push_keyword(table, scKeyword, tkImplements);
    lee_symbol_table_push_keyword(table, scKeyword, tkImport);
    lee_symbol_table_push_keyword(table, scKeyword, tkInstanceOf);
    lee_symbol_table_push_keyword(table, scType, tkInt);
    lee_symbol_table_push_keyword(table, scKeyword, tkInterface);
    lee_symbol_table_push_keyword(table, scType, tkLong);
    lee_symbol_table_push_keyword(table, scKeyword, tkModule);
    lee_symbol_table_push_keyword(table, scKeyword, tkNative);
    lee_symbol_table_push_keyword(table, scKeyword, tkNew);
    lee_symbol_table_push_keyword(table, scKeyword, tkPrivate);
    lee_symbol_table_push_keyword(table, scKeyword, tkProtected);
    lee_symbol_table_push_keyword(table, scKeyword, tkPublic);
    lee_symbol_table_push_keyword(table, scKeyword, tkReturn);
    lee_symbol_table_push_keyword(table, scType, tkShort);
    lee_symbol_table_push_keyword(table, scKeyword, tkStatic);
    lee_symbol_table_push_keyword(table, scKeyword, tkSuper);
    lee_symbol_table_push_keyword(table, scKeyword, tkSwitch);
    lee_symbol_table_push_keyword(table, scKeyword, tkSynchronized);
    lee_symbol_table_push_keyword(table, scKeyword, tkThis);
    lee_symbol_table_push_keyword(table, scKeyword, tkThrow);
    lee_symbol_table_push_keyword(table, scKeyword, tkThrows);
    lee_symbol_table_push_keyword(table, scKeyword, tkTo);
    lee_symbol_table_push_keyword(table, scKeyword, tkTry);
    lee_symbol_table_push_keyword(table, scKeyword, tkVoid);
    lee_symbol_table_push_keyword(table, scKeyword, tkWhile);
    lee_symbol_table_push_keyword(table, scKeyword, tkWith);
    lee_symbol_table_push_keyword(table, scKeyword, tkUnderscore);

    // Literal
    lee_symbol_table_push_keyword(table, scLiteral, tkNull);

    // Separators
    lee_symbol_table_push_keyword(table, scSeparator, tkLParen);
    lee_symbol_table_push_keyword(table, scSeparator, tkRParen);
    lee_symbol_table_push_keyword(table, scSeparator, tkLBrace);
    lee_symbol_table_push_keyword(table, scSeparator, tkRBrace);
    lee_symbol_table_push_keyword(table, scSeparator, tkLBrack);
    lee_symbol_table_push_keyword(table, scSeparator, tkRBrack);
    lee_symbol_table_push_keyword(table, scSeparator, tkSemicolon);
    lee_symbol_table_push_keyword(table, scSeparator, tkComma);
    lee_symbol_table_push_keyword(table, scSeparator, tkDot);

    // Operators
    lee_symbol_table_push_keyword(table, scOperator, tkAssign);
    lee_symbol_table_push_keyword(table, scOperator, tkGT);
    lee_symbol_table_push_keyword(table, scOperator, tkLT);
    lee_symbol_table_push_keyword(table, scOperator, tkBang);
    lee_symbol_table_push_keyword(table, scOperator, tkTilde);
    lee_symbol_table_push_keyword(table, scOperator, tkQuestion);
    lee_symbol_table_push_keyword(table, scOperator, tkColon);
    lee_symbol_table_push_keyword(table, scOperator, tkEqual);
    lee_symbol_table_push_keyword(table, scOperator, tkLE);
    lee_symbol_table_push_keyword(table, scOperator, tkGE);
    lee_symbol_table_push_keyword(table, scOperator, tkNotEqual);
    lee_symbol_table_push_keyword(table, scOperator, tkAnd);
    lee_symbol_table_push_keyword(table, scOperator, tkOr);
    lee_symbol_table_push_keyword(table, scOperator, tkInc);
    lee_symbol_table_push_keyword(table, scOperator, tkDec);
    lee_symbol_table_push_keyword(table, scOperator, tkAdd);
    lee_symbol_table_push_keyword(table, scOperator, tkSub);
    lee_symbol_table_push_keyword(table, scOperator, tkMul);
    lee_symbol_table_push_keyword(table, scOperator, tkMod);
}

lee_symbol_table_t *lee_symbol_table_create() {
    lee_symbol_table_t *table = malloc(sizeof(lee_symbol_table_t));
    table->count = 0;
    table->itens = malloc(sizeof(lee_symbol_t*) * INITIAL_CAPACITY);
    loadLanguageKeywords(table);
    return table;
}

void lee_symbol_table_free(lee_symbol_table_t *table) {
    for (int i = 0; i < table->count; i++){
        lee_symbol_t *id = table->itens + i;
        if (id->tokenType == tkIdentifier) {
            free(id->name);
        }
    }
    free(table->itens);
    free(table);
}
