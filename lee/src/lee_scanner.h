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


#ifndef LEE_SCANNER_H
#define LEE_SCANNER_H

#include "lee_defs.h"

lee_scanner_t *lee_scanner_create(lee_source_file_t *sourceFile, lee_symbol_table_t *symbolTable);
void lee_scanner_free(lee_scanner_t *scanner);
lee_token_t *lee_scanner_next_token(lee_scanner_t *scanner);


#endif //LEE_SCANNER_H
