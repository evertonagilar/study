//
// Created by evertonagilar on 01/06/22.
//

#ifndef VMPROJ_MODULE_H
#define VMPROJ_MODULE_H

#include <stddef.h>
#include <glib.h>
#include <stdbool.h>

typedef struct {
    char *filename;                 // arquivo com os byte code para interpretar
    size_t size;                    // default size of text/data/stack
    long *text;                     // text segment
    bool compiled;
    GList *imports;
} module_t;


module_t *loadModule(char *fileName);
void freeModule(module_t *module);


#endif //VMPROJ_MODULE_H
