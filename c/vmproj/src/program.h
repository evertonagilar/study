//
// Created by evertonagilar on 04/01/23.
//

#ifndef VMPROJ_PROGRAM_H
#define VMPROJ_PROGRAM_H

#include <glib.h>
#include <stddef.h>
#include <stdbool.h>
#include "module.h"

typedef struct {
    module_t *module;
} program_t;


program_t *loadProgramStructure(char *programFileName);
void *freeProgramStructure(program_t *program);


#endif //VMPROJ_PROGRAM_H
