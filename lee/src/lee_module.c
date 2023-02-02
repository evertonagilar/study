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


#include "lee_module.h"
#include "lee_parse_ast.h"
#include "lee_source_file.h"

lee_module_t *lee_module_load(char *fileName) {
    lee_module_t *module = (lee_module_t *) malloc(sizeof(lee_module_t));
    module->sourceFile = lee_source_file_create(fileName);
    //mainModule->text = malloc(mainModule->count);
    module->compiled = false;
    module->parseAST = lee_parse_ast_create(module->sourceFile);
    return module;
}

void lee_module_free(lee_module_t *module){
    lee_parse_ast_free(module->parseAST);
    lee_source_file_free(module->sourceFile);
    free(module);
}


