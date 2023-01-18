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


#ifndef VMPROJ_AGL_SYMBOL_TABLE_H
#define VMPROJ_AGL_SYMBOL_TABLE_H

#include "agl_global.h"

agl_identifier_t *agl_identifier_create();
void agl_identifier_free(agl_identifier_t *id);

agl_symbol_table_t *agl_symbol_table_create();
void agl_symbol_table_free(agl_symbol_table_t *table);
void agl_symbol_table_push(agl_symbol_table_t *table, agl_identifier_t *id);
agl_identifier_t * agl_symbol_table_get(agl_symbol_table_t *table, char *identifier, int identifier_sz);


#endif //VMPROJ_AGL_SYMBOL_TABLE_H
