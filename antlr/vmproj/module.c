//
// Created by evertonagilar on 01/06/22.
//

#include <malloc.h>
#include "module.h"
#include "utils.h"

module_t *loadModule(const char *filename) {
    module_t *module = (module_t *) malloc(sizeof(module_t));
    module->filename = filename;
    module->size = getFileSizeByFileName(filename);
    module->text = malloc(module->size);
    readFileAll(module->filename, module->text, module->size);
    return module;
}

void freeModule(const module_t *module){
    free(module->text);
    free(module);
}


