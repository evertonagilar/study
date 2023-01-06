//
// Created by evertonagilar on 01/06/22.
//

#include "agl.h"
#include <glib/glist.h>

agl_module_t *agl_module_load(char *fileName) {
    agl_module_t *module = (agl_module_t *) malloc(sizeof(agl_module_t));
    module->filename = strdup(fileName);
    module->size = agl_getFileSizeByFileName(fileName);
    module->text = malloc(module->size);
    module->compiled = false;
    module->imports = g_list_alloc();
    agl_parser_create_ast(module);
    return module;
}

void agl_module_free(agl_module_t *module){
    free(module->text);
    g_list_free(module->imports);
    free(module);
}

