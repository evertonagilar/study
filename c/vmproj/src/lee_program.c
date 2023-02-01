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
#include "lee_program.h"

lee_program_t *lee_program_load(char *programFileName) {
    lee_program_t *program = malloc(sizeof(lee_program_t));
    program->mainModule = lee_module_load(programFileName);
    return program;
}

void *lee_program_free(lee_program_t *program) {
    lee_module_free(program->mainModule);
    free(program);
}

