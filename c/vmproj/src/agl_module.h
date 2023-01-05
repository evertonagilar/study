//
// Created by evertonagilar on 01/06/22.
//

#ifndef VMPROJ_AGL_MODULE_H
#define VMPROJ_AGL_MODULE_H

#include <stddef.h>
#include <glib.h>
#include <stdbool.h>

typedef struct {
    char *filename;                 // arquivo com os byte code para interpretar
    size_t size;                    // default size of text/data/stack
    long *text;                     // text segment
    bool compiled;
    GList *imports;
} agl_module_t;


agl_module_t *agl_module_load(char *fileName);
void agl_module_free(agl_module_t *module);


#endif //VMPROJ_AGL_MODULE_H
