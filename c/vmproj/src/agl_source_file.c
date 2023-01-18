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
#include "agl_source_file.h"

agl_source_file_t *agl_source_file_create(const char *filename) {
    agl_source_file_t *sourceFile = malloc(sizeof(agl_source_file_t));
    sourceFile->filename = strdup(filename);
    sourceFile->size = agl_getFileSizeByFileName(filename);
    return sourceFile;
}

void agl_source_file_free(agl_source_file_t *sourceFile){
    free(sourceFile->filename);
    free(sourceFile);
}