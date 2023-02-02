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


#include <ctype.h>
#include "lee_scanner.h"
#include "lee_symbol_table.h"
#include "lee_token.h"


lee_scanner_t *lee_scanner_create(lee_source_file_t *sourceFile, lee_symbol_table_t *symbolTable) {
    lee_scanner_t *scanner = malloc(sizeof(lee_scanner_t));
    scanner->src = sourceFile->stream;
    scanner->lookahead = scanner->src;
    scanner->line = 1;
    scanner->symbolTable = symbolTable;
    return scanner;
}

void lee_scanner_free(lee_scanner_t *scanner) {
    free(scanner);
}

lee_token_t * lee_scanner_next_token(lee_scanner_t *scanner) {
    int ch, hash;
    lee_token_t *token = lee_token_new();
    while (ch = *scanner->lookahead) {
        char *last_lookahead = scanner->lookahead++;
        hash = ch;
        if (isalnum(ch)) {
            while (isalnum(*scanner->lookahead)) {
                hash = hash * 100 + *scanner->lookahead;
                scanner->lookahead++;
            }
            token->symbol = lee_symbol_table_get_or_push(scanner->symbolTable, last_lookahead,
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
            token->type = tkAdd;
            break;
        }else if (ch == '-'){
            token->type = tkSub;
            break;
        }else if (ch == '*'){
            token->type = tkMul;
            break;
        }else if (ch == '{'){
            token->type = tkLBrace;
            break;
        }else if (ch == '}'){
            token->type = tkRBrace;
            break;
        }else if (ch == '('){
            token->type = tkLParen;
            break;
        }else if (ch == ')'){
            token->type = tkRParen;
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

