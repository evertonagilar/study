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

bool isBeginIdentifierChar(char ch) {
    return (ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z' || ch == '_');
}

bool isIdentifierChar(char ch) {
    return (ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z') || (ch >= '0' && ch <= '9' || ch == '_');
}


lee_token_t *lee_scanner_next_token(lee_scanner_t *scanner) {
    char *last_lookahead = scanner->lookahead;
    lee_token_t *token = lee_token_new();
    int ch;
    while (ch = *scanner->lookahead) {
        last_lookahead = scanner->lookahead++;
        if (isBeginIdentifierChar(ch)) {
            while (isIdentifierChar(*scanner->lookahead)) {
                scanner->lookahead++;
            }
            token->symbol = lee_symbol_table_get_or_push(scanner->symbolTable,
                                                         last_lookahead,
                                                         scanner->lookahead - last_lookahead,
                                                         scIdentifier,
                                                         tkIdentifier);
            break;
        } else if (isdigit(ch)) {
            token->value = 0;
            while (isdigit(*scanner->lookahead)) {
                token->value = (token->value * 10) + *scanner->lookahead - 0;
                scanner->lookahead++;
            }
            token->symbol = lee_symbol_table_get_or_push(scanner->symbolTable,
                                                         last_lookahead,
                                                         scanner->lookahead - last_lookahead,
                                                         scNumber,
                                                         tkNumber);
            break;
        } else if (isblank(ch)) {
            do {
                scanner->lookahead++;
            } while (isblank(*scanner->lookahead));
            last_lookahead = scanner->lookahead;
        } else if (ch == '\n') {
            do{
                scanner->lookahead++;
            }while (*scanner->lookahead == '\n');
            last_lookahead = scanner->lookahead;
        } else if (ch == '\r') {
            ++scanner->line;
            last_lookahead = scanner->lookahead;
        } else if (ch == '+') {
            break;
        } else if (ch == '-') {
            break;
        } else if (ch == '*') {
            break;
            // Separators
        } else if (ch == '(') {
            break;
        } else if (ch == ')') {
            break;
        } else if (ch == '{') {
            break;
        } else if (ch == '}') {
            break;
        } else if (ch == '[') {
            break;
        } else if (ch == ']') {
            break;
        } else if (ch == ';') {
            break;
        } else if (ch == '.') {
            break;
        } else if (ch == '=') {
            if (*scanner->lookahead == '=') {
                scanner->lookahead++;
            }
            break;
        } else if (ch == '/') {
            if (*scanner->lookahead == '/') {
                do {
                    scanner->lookahead++;
                } while (ch = *scanner->lookahead && ch != '\n');
                last_lookahead = scanner->lookahead;
            } else {
                break;
            }
        }
    }
    if (token->symbol == NULL) {
        // Encontrou token?
        if (scanner->lookahead != last_lookahead) {
            token->symbol = lee_symbol_table_get(scanner->symbolTable,
                                                 last_lookahead,
                                                 scanner->lookahead - last_lookahead);
        }else{
            token->symbol = lee_symbol_table_get(scanner->symbolTable,
                                                 "EOF",
                                                 3);

        }
    }
    token->line = scanner->line;
    return token;
}

