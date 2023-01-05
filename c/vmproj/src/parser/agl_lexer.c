//
// Created by evertonagilar on 05/01/23.
//

#include "agl_lexer.h"
#include "../utils/agl_file_utils.h"

scanner_t *agl_lexer_create(agl_module_t *module) {
    scanner_t *scanner = malloc(sizeof(scanner_t));
    scanner->src = malloc(module->size + 1);
    scanner->lookahead = scanner->src;
    size_t bytesRead = agl_readFileAll(module->filename, scanner->src, module->size);
    scanner->src[bytesRead] = 0; // adiciona EOF
    return scanner;
}

void agl_lexer_free(scanner_t *scanner){
    free(scanner->src);
    free(scanner);
}

void agl_lexer_next_token(scanner_t *scanner) {
    scanner->token = *scanner->lookahead++;
    return;
}

