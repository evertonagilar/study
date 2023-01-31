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
#include "agl_global.h"

int main(int argc, char **argv) {
    printf("Agilar Compiler Runtime(%ld bits)\n", sizeof(long) * 8);

    if (argc < 2) {
        printf("Uso: vmproj file\n");
        return -1;
    }

    char *programFileName = argv[1];
    agl_vm_t *vm = agl_vm_create(programFileName, true);
    agl_vm_free(vm);

    return 0;
}
