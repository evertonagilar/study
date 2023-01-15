//
// Created by evertonagilar on 05/01/23.
//

#ifndef VMPROJ_AGL_LEXER_H
#define VMPROJ_AGL_LEXER_H

#include "../agl_module.h"
#include "agl_token.h"

typedef struct {
    char *src;              // pointer to source code string
    char *lookahead;        // pointer to next identifier
    int line;               // line of the token
    agl_token_t *token;     // current identifier
    agl_symbol_table_t *symbolTable;
} agl_scanner_t;

agl_scanner_t *agl_lexer_create(agl_module_t *module);
void agl_lexer_free(agl_scanner_t *scanner);
bool agl_lexer_next_token(agl_scanner_t *scanner);


#endif //VMPROJ_AGL_LEXER_H
