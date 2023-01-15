//
// Created by evertonagilar on 05/01/23.
//

#include "agl_lexer.h"
#include "../utils/agl_file_utils.h"
#include <string.h>
#include <ctype.h>
#include "agl_token.h"

agl_scanner_t *agl_lexer_create(agl_module_t *module) {
    agl_scanner_t *scanner = malloc(sizeof(agl_scanner_t));
    scanner->src = malloc(module->size + 1);
    scanner->lookahead = scanner->src;
    scanner->token = NULL;
    scanner->line = 1;
    size_t bytesRead = agl_readFileAll(module->filename, scanner->src, module->size);
    scanner->src[bytesRead] = 0; // adiciona EOF
    scanner->symbolTable = agl_symbol_table_create();
    scanner->token = agl_token_new();
    return scanner;
}

void agl_lexer_free(agl_scanner_t *scanner) {
    free(scanner->src);
    agl_symbol_table_free(scanner->symbolTable);
    agl_token_free(scanner->token);
    free(scanner);
}

bool agl_lexer_next_token(agl_scanner_t *scanner) {
    int ch;
    agl_token_t *token = scanner->token;
    while (ch = *scanner->lookahead) {
        char *last_lookahead = scanner->lookahead++;
        int hash = ch;
        if (isalnum(ch)) {
            while (isalnum(*scanner->lookahead)) {
                hash = hash * 100 + *scanner->lookahead;
                scanner->lookahead++;
            }
            agl_identifier_t *id = agl_symbol_table_get(scanner->symbolTable, last_lookahead, scanner->lookahead - last_lookahead);
            token->identifier = id;
            token->hash = hash;
            return true;
        }else if (isblank(ch) || ch == '\r') {
            while (isblank(*scanner->lookahead) || *scanner->lookahead == '\r') {
                scanner->lookahead++;
            }
        }else if (ch == '\r'){
            ++scanner->line;
        }else if (ch == '.'){
            token->type = tkDot;
            token->hash = hash;
            return true;
        }else if (ch == ';'){
            token->type = tkSemicolon;
            token->hash = hash;
            return true;
        }else if (ch == '+'){
            token->type = tkPlus;
            token->hash = hash;
            return true;
        }else if (ch == '-'){
            token->type = tkPlus;
            token->hash = hash;
            return true;
        }else if (ch == '*'){
            token->type = tkMul;
            token->hash = hash;
            return true;
        }else if (ch == '{'){
            token->type = tkOpenP;
            token->hash = hash;
            return true;
        }else if (ch == '}'){
            token->type = tkCloseP;
            token->hash = hash;
            return true;
        }else if (ch == '='){
            if (*scanner->lookahead == '='){
                token->type = tkAssign;
            }else{
                token->type = tkEqual;
            }
            token->hash = hash;
            return true;
        }else if (ch == '/'){
            if (*scanner->lookahead == '/'){
                while (ch = scanner->lookahead && ch != '\n'){
                    scanner->lookahead++;
                }
            }else{
                token->type = tkDiv;
                token->hash = hash;
                return true;
            }
        }
    }
    return false;
}

