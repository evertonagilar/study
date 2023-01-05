//
// Created by evertonagilar on 04/01/23.
//

#ifndef VMPROJ_AGL_PROGRAM_H
#define VMPROJ_AGL_PROGRAM_H

#include <glib.h>
#include <stddef.h>
#include <stdbool.h>
#include "agl_module.h"

typedef struct {
    agl_module_t *module;
} agl_program_t;


agl_program_t *agl_program_load(char *programFileName);
void *agl_program_free(agl_program_t *program);


#endif //VMPROJ_AGL_PROGRAM_H
