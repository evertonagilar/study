//
// Created by evertonagilar on 11/01/23.
//

#ifndef VMPROJ_AGL_TOKEN_H
#define VMPROJ_AGL_TOKEN_H

#include "agl_symbol_table.h"

typedef enum {
    tkIf,
    tkElse,
    tkWhile,
    tkIdentifier,
    tkDot,
    tkPlus,
    tkMinus,
    tkMul,
    tkDiv,
    tkEqual,
    tkAssign,
    tkOpenP,
    tkCloseP,
    tkSemicolon,
    tkEof
} agl_token_type;

typedef struct {
    int hash;
    agl_identifier_t *identifier;
    agl_token_type type;
    char *value;
} agl_token_t;

agl_token_t *agl_token_new();
void agl_token_free(agl_token_t *token);

#endif //VMPROJ_AGL_TOKEN_H
