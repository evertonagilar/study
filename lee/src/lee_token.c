/*
 * %CopyrightBegin%
 *
 * Copyright Everton de Vargas Agilar 2022. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * %CopyrightEnd%
 */


#include "lee_token.h"
#include <stdlib.h>

lee_token_t *lee_token_new() {
    lee_token_t *token = malloc(sizeof(lee_token_t));
    token->symbol = NULL;
    token->type = tkEof;
    token->symbol = NULL;
    return token;
}

void lee_token_free(lee_token_t *token){
    free(token);
}