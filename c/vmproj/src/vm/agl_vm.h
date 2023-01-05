//
// Created by evertonagilar on 05/01/23.
//

#ifndef VMPROJ_AGL_VM_H
#define VMPROJ_AGL_VM_H

#include "../agl_program.h"
#include "agl_vm_types.h"
#include "../utils/agl_file_utils.h"
#include "../agl_module.h"
#include "../agl_program.h"
#include <stdbool.h>


typedef struct {
    agl_program_t *program;
    bool debug;
} agl_vm_t;

agl_vm_t *agl_vm_create(char *filename, bool debug);
int agl_vm_start(agl_vm_t *vm);
void agl_vm_free(agl_vm_t *vm);

#endif //VMPROJ_AGL_VM_H
