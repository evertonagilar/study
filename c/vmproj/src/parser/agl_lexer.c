//
// Created by evertonagilar on 05/01/23.
//

#include "agl_lexer.h"
#include "../utils/agl_file_utils.h"
#include <string.h>
#include <ctype.h>
#include "agl_token.h"

agl_scanner_t *agl_lexer_create(const agl_module_t *module) {
    agl_scanner_t *scanner = malloc(sizeof(agl_scanner_t));
    scanner->src = malloc(module->size + 1);
    scanner->lookahead = scanner->src;
    scanner->line = 1;
    size_t bytesRead = agl_readFileAll(module->filename, scanner->src, module->size);
    scanner->src[bytesRead] = 0; // adiciona EOF
    scanner->symbolTable = agl_symbol_table_create();
    return scanner;
}

void agl_lexer_free(agl_scanner_t *scanner) {
    free(scanner->src);
    agl_symbol_table_free(scanner->symbolTable);
    free(scanner);
}

agl_token_t * agl_lexer_next_token(agl_scanner_t *scanner) {
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
            token->identifier = agl_symbol_table_get(scanner->symbolTable, last_lookahead, scanner->lookahead - last_lookahead);
            token->type = tkIdentifier;
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

