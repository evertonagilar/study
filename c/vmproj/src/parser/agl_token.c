//
// Created by evertonagilar on 11/01/23.
//

#include "agl_token.h"
#include <stdlib.h>

agl_token_t *agl_token_new() {
    agl_token_t *token = malloc(sizeof(agl_token_t));
    token->identifier = NULL;
    token->type = tkEof;
    token->identifier = NULL;
    return token;
}

void agl_token_free(agl_token_t *token){
    if (token->identifier){
        agl_identifier_free(token->identifier);
    }
    free(token);
}