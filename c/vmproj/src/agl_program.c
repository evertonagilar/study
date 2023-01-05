//
// Created by evertonagilar on 04/01/23.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "agl_program.h"

agl_program_t *agl_program_load(char *programFileName) {
    agl_program_t *program = malloc(sizeof(agl_program_t));
    program->module = agl_module_load(programFileName);
    return program;
}

void *agl_program_free(agl_program_t *program) {
    agl_module_free(program->module);
    free(program);
}

