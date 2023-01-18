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


#ifndef VMPROJ_AGL_FILE_UTILS_H
#define VMPROJ_AGL_FILE_UTILS_H

#include <stdio.h>

void printInstrucao(long op, const long *pc, int cycle);
FILE *agl_openFileName(const char *filename, const char *modes);
size_t agl_getFileSize(FILE *fd);
size_t agl_getFileSizeByFileName(const char *filename);
void agl_writeFileAll(const char *filename, void *buf, size_t size);
size_t agl_readFileAll(const char *filename, void *buf, size_t size);



#endif //VMPROJ_AGL_FILE_UTILS_H
