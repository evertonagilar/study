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


#include <string.h>
#include <ctype.h>
#include "agl_scanner.h"


agl_scanner_t *agl_scanner_create(agl_source_file_t *sourceFile) {
    agl_scanner_t *scanner = malloc(sizeof(agl_scanner_t));
    scanner->src = sourceFile->stream;
    scanner->lookahead = scanner->src;
    scanner->line = 1;
    scanner->symbolTable = agl_scanner_symbol_table_create();
    return scanner;
}

void agl_scanner_free(agl_scanner_t *scanner) {
    agl_scanner_symbol_table_free(scanner->symbolTable);
    free(scanner);
}

agl_token_t * agl_scanner_next_token(agl_scanner_t *scanner) {
    int ch, hash;
    agl_token_t *token = agl_token_new();
    while (ch = *scanner->lookahead) {
        char *last_lookahead = scanner->lookahead++;
        hash = ch;
        if (isalnum(ch)) {
            while (isalnum(*scanner->lookahead)) {
                hash = hash * 100 + *scanner->lookahead;
                scanner->lookahead++;
            }
            token->symbol = agl_scanner_symbol_table_get_or_push(scanner->symbolTable, last_lookahead,
                                                                 scanner->lookahead - last_lookahead, scIdentifier, tkIdentifier);
            token->type = token->symbol->tokenType;
            break;
        }else if (isblank(ch)) {
            while (isblank(*scanner->lookahead)) {
                scanner->lookahead++;
            }
        }else if (ch == '\r'){
            ++scanner->line;
        }else if (ch == '.'){
            token->type = tkDot;
            break;
        }else if (ch == ';'){
            token->type = tkSemicolon;
            break;
        }else if (ch == '+'){
            token->type = tkPlus;
            break;
        }else if (ch == '-'){
            token->type = tkPlus;
            break;
        }else if (ch == '*'){
            token->type = tkMul;
            break;
        }else if (ch == '{'){
            token->type = tkOpenP;
            break;
        }else if (ch == '}'){
            token->type = tkCloseP;
            break;
        }else if (ch == '='){
            if (*scanner->lookahead == '='){
                token->type = tkAssign;
            }else{
                token->type = tkEqual;
            }
            break;
        }else if (ch == '/'){
            if (*scanner->lookahead == '/'){
                while (ch = scanner->lookahead && ch != '\n'){
                    scanner->lookahead++;
                }
            }else{
                token->type = tkDiv;
                break;
            }
        }
    }
    token->line = scanner->line;
    token->hash = hash;
    return token;
}

