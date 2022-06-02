//
// Created by evertonagilar on 01/06/22.
//

#ifndef VMPROJ_MODULE_H
#define VMPROJ_MODULE_H

#include <stddef.h>

typedef struct {
    char *filename;                 // arquivo com os byte code para interpretar
    size_t size;                    // default size of text/data/stack
    long *text;                     // text segment
} module_t;


module_t *loadModule(const char *filename);
void freeModule(const module_t *module);


#endif //VMPROJ_MODULE_H
