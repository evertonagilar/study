//
// Created by evertonagilar on 05/01/23.
//

#include "agl_parser.h"
#include "agl_lexer.h"
#include <stdio.h>


void program(scanner_t *scanner) {
    agl_lexer_next_token(scanner);
    while (scanner->token > 0){
        printf("token is: %c\n", scanner->token);
        agl_lexer_next_token(scanner);
    }
}

void agl_parser_create_ast(agl_module_t *module) {
    scanner_t *scanner = agl_lexer_create(module);
    program(scanner);
    agl_lexer_free(scanner);
}


