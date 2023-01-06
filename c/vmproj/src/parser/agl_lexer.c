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
    size_t bytesRead = agl_readFileAll(module->filename, scanner->src, module->size);
    scanner->src[bytesRead] = 0; // adiciona EOF
    return scanner;
}

void agl_lexer_free(scanner_t *scanner) {
    free(scanner->src);
    free(scanner);
}

void agl_lexer_next_token(scanner_t *scanner) {
    int ch;
    while (ch = *scanner->lookahead) {
        char *last_lookahead = scanner->lookahead;
        int hash = ch;
        agl_token_t *token = agl_lexer_new_token();
        if (isalnum(ch)) {
            while (isalnum(*scanner->lookahead)) {
                hash = hash * 100 + *scanner->lookahead;
                scanner->lookahead++;
            }
            token->value = strndup(last_lookahead, scanner->lookahead - last_lookahead);
            token->hash = hash;
            scanner->token = token;
            return;
        }else if (isblank(ch)){
            while (isblank(*scanner->lookahead)){
                scanner->lookahead++;
            }
        }
    }
    scanner->token = NULL;
    return;
}

