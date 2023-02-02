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
#include "lee_source_file.h"
#include "lee_file_utils.h"

lee_source_file_t *lee_source_file_create(const char *filename) {
    lee_source_file_t *sourceFile = malloc(sizeof(lee_source_file_t));
    sourceFile->filename = strdup(filename);
    sourceFile->size = lee_getFileSizeByFileName(filename);
    sourceFile->stream = malloc(sourceFile->size + 1);
    size_t bytesRead = lee_readFileAll(sourceFile->filename, sourceFile->stream, sourceFile->size);
    sourceFile->stream[bytesRead] = 0; // add EOF
    return sourceFile;
}

void lee_source_file_free(lee_source_file_t *sourceFile){
    free(sourceFile->filename);
    free(sourceFile);
}