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

#include <stdio.h>
#include <fcntl.h>
#include <errno.h>
#include <stdlib.h>
#include "lee_fileutils.h"

FILE *lee_openFileName(const char *filename, const char *modes){
    FILE *fd = fopen(filename, modes);
    if (!fd) {
        printf("Não foi possível abrir arquivo %s. Code: %d", filename, errno);
        exit(-1);
    }
    return fd;
}

size_t lee_getFileSize(FILE *fd){
    size_t current = ftell(fd);
    fseek(fd, 0, SEEK_END);
    size_t result =  ftell(fd);
    fseek(fd, current, SEEK_SET);
    return result;
}

size_t lee_getFileSizeByFileName(const char *filename) {
    FILE *fd = lee_openFileName(filename, "r");
    size_t result = lee_getFileSize(fd);
    fclose(fd);
    return result;
}

void lee_writeFileAll(const char *filename, void *buf, size_t size){
    FILE *fd = lee_openFileName(filename, "w");
    fwrite(buf, size, 1, fd);
    fclose(fd);
}

size_t lee_readFileAll(const char *filename, void *buf, size_t size){
    FILE *fd = lee_openFileName(filename, "r");
    size_t bytesRead = fread(buf, 1, size, fd);
    fclose(fd);
    return bytesRead;
}
