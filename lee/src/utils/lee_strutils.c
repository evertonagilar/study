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

#include <stdlib.h>
#include <string.h>
#include "lee_strutils.h"

size_t _strlen(char *str) {
    char *tmp = str;
    while (*tmp != '\0') tmp++;
    return tmp - str;
}

lee_string_t *lee_string_ref(char *str) {
    lee_string_t *result = malloc(sizeof(lee_string_t));
    result->cstr = str;
    result->length = _strlen(str);
    result->_ref = true;
    result->_next = NULL;
    return result;
}

lee_string_t *lee_string_new(char *str) {
    lee_string_t *result = malloc(sizeof(lee_string_t));
    result->cstr = strdup(str);
    result->length = _strlen(str);
    result->_ref = false;
    result->_next = NULL;
    return result;
}

inline size_t lee_string_length(const lee_string_t *str){
    return str->length;
}

const char* lee_string_cstr(lee_string_t *str){
    return str->cstr;
}