//
// Created by evertonagilar on 01/06/22.
//

#include <malloc.h>
#include "module.h"
#include "file_utils.h"
#include <glib/glist.h>

module_t *loadModule(char *fileName) {
    module_t *module = (module_t *) malloc(sizeof(module_t));
    module->filename = strdup(fileName);
    module->size = getFileSizeByFileName(fileName);
    module->text = malloc(module->size);
    module->compiled = false;
    module->imports = g_list_alloc();
    readFileAll(module->filename, module->text, module->size);
    return module;
}

void freeModule(module_t *module){
    free(module->text);
    g_list_free(module->imports);
    free(module);
}


