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
#include "lee_vm.h"
#include "lee_defs.h"
#include "utils/lee_hash_table.h"
#include "utils/lee_btree.h"
#include "utils/lee_binary_tree.h"
#include "utils/lee_linked_list.h"
#include "test/collection_test.h"

int main(int argc, char **argv) {
    printf("Lee -> The Samurai Programing Language\n");

    if (argc < 2) {
        printf("Usage: lee <file.lee>\n");
        return -1;
    }

    char *programFileName = argv[1];
    lee_vm_t *vm = lee_vm_create(programFileName, true);
    lee_vm_free(vm);

    return 0;
}
