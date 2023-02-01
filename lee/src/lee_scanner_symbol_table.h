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


#ifndef VMPROJ_AGL_SCANNER_SYMBOL_TABLE_H
#define VMPROJ_AGL_SCANNER_SYMBOL_TABLE_H

#include "lee_global.h"

lee_scanner_symbol_table_t *lee_scanner_symbol_table_create();
void lee_scanner_symbol_table_free(lee_scanner_symbol_table_t *table);
lee_symbol_t *lee_scanner_symbol_table_get_or_push(lee_scanner_symbol_table_t *table, char *identifier, int identifier_sz, lee_symbol_class_t symbolClass, lee_token_type_t tokenType);
lee_symbol_t *lee_scanner_symbol_table_push(lee_scanner_symbol_table_t *table, char *identifier, int identifier_sz, lee_symbol_class_t symbolClass, lee_token_type_t tokenType);

#endif //VMPROJ_AGL_SCANNER_SYMBOL_TABLE_H
