//
// Created by evertonagilar on 05/01/23.
//

#include "agl_lexer.h"
#include "../utils/agl_file_utils.h"
#include <string.h>
#include <ctype.h>

static agl_token_t *agl_lexer_new_token() {
    agl_token_t *token = malloc(sizeof(agl_token_t));
    return token;
}

scanner_t *agl_lexer_create(agl_module_t *module) {
    scanner_t *scanner = malloc(sizeof(scanner_t));
    scanner->src = malloc(module->size + 1);
    scanner->lookahead = scanner->src;
    scanner->token = NULL;
    scanner->line = 1;
    size_t bytesRead = agl_readFileAll(module->filename, scanner->src, module->size);
    scanner->src[bytesRead] = 0; // adiciona EOF
    scanner->symbolTable = agl_symbol_table_create();
    return scanner;
}

void agl_lexer_free(scanner_t *scanner) {
    free(scanner->src);
    agl_symbol_table_free(scanner->symbolTable);
    free(scanner);
}

void agl_lexer_next_token(scanner_t *scanner) {
    int ch;
    while (ch = *scanner->lookahead) {
        char *last_lookahead = scanner->lookahead++;
        int hash = ch;
        agl_token_t *token = agl_lexer_new_token();
        if (isalnum(ch)) {
            while (isalnum(*scanner->lookahead)) {
                hash = hash * 100 + *scanner->lookahead;
                scanner->lookahead++;
            }
            agl_identifier_t *id = agl_symbol_table_get(scanner->symbolTable, last_lookahead, scanner->lookahead - last_lookahead);
            token->value = id;
            token->hash = hash;
            scanner->token = token;
            return;
        }else if (isblank(ch) || ch == '\r') {
            while (isblank(*scanner->lookahead) || *scanner->lookahead == '\r') {
                scanner->lookahead++;
            }
        }else if (ch == '\r'){
            ++scanner->line;
        }else if (ch == '.'){
            agl_identifier_t *id = agl_symbol_table_get(scanner->symbolTable, last_lookahead, scanner->lookahead - last_lookahead);
            token->value = id;
            token->hash = hash;
            scanner->token = token;
            return;
        }else if (ch == ';'){
            agl_identifier_t *id = agl_symbol_table_get(scanner->symbolTable, last_lookahead, scanner->lookahead - last_lookahead);
            token->value = id;
            token->hash = hash;
            scanner->token = token;
            return;
        }else if (ch == '+'){
            agl_identifier_t *id = agl_symbol_table_get(scanner->symbolTable, last_lookahead, scanner->lookahead - last_lookahead);
            token->value = id;
            token->hash = hash;
            scanner->token = token;
            return;
        }else if (ch == '/'){
            if (*scanner->lookahead == '/'){
                while (ch = scanner->lookahead && ch != '\n'){
                    scanner->lookahead++;
                }
            }
        }
    }
    scanner->token = NULL;
    return;
}

