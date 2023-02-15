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

#ifndef LEE_STRUTILS_H
#define LEE_STRUTILS_H


#include <stddef.h>
#include <stdbool.h>

/*
 * Arquitetura da string:
 *
 * string   (_next) ->
 *                  string2 (_next) ->
 *                          string3 (_next) ->
 *                                  NULL
 *
 *
 */

typedef struct lee_string_t {
    size_t length;
    char *cstr;
    struct lee_string_t *_next;
    bool _ref;       // se true, é uma referência para string original passado em lee_string_ref
} lee_string_t;


lee_string_t *lee_string_new(char *str);
lee_string_t *lee_string_ref(char *str);
size_t lee_string_length(const lee_string_t *str);
lee_string_t *lee_string_assign(lee_string_t *str);
const char* lee_string_cstr(lee_string_t *str);


#endif //LEE_STRUTILS_H
