//
// Created by evertonagilar on 05/01/23.
//

#ifndef VMPROJ_AGL_LEXER_H
#define VMPROJ_AGL_LEXER_H

#include "../agl_module.h"

typedef struct {
    int hash;
    char *value;
} agl_token_t;

typedef struct {
    char *src;              // pointer to source code string
    char *lookahead;        // pointer to next value
    agl_token_t *token;     // current value
} scanner_t;

scanner_t *agl_lexer_create(agl_module_t *module);
void agl_lexer_free(scanner_t *scanner);
void agl_lexer_next_token(scanner_t *scanner);


#endif //VMPROJ_AGL_LEXER_H
