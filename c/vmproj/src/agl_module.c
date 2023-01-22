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


#include "agl_module.h"
#include <glib/glist.h>

agl_module_t *agl_module_load(char *fileName) {
    agl_module_t *module = (agl_module_t *) malloc(sizeof(agl_module_t));
    module->sourceFile = agl_source_file_create(fileName);
    //mainModule->text = malloc(mainModule->count);
    module->compiled = false;
    module->imports = g_list_alloc();
    module->parseAST = agl_parse_ast_create(module->sourceFile);
    return module;
}

void agl_module_free(agl_module_t *module){
    g_list_free(module->imports);
    agl_parse_ast_free(module->parseAST);
    agl_source_file_free(module->sourceFile);
    free(module);
}


