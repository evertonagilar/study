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


#ifndef VMPROJ_AGL_SCANNER_H
#define VMPROJ_AGL_SCANNER_H

#include "agl_global.h"

agl_scanner_t *agl_scanner_create(agl_source_file_t *sourceFile);
void agl_scanner_free(agl_scanner_t *scanner);
agl_token_t *agl_scanner_next_token(agl_scanner_t *scanner);


#endif //VMPROJ_AGL_SCANNER_H
