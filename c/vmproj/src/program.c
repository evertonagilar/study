//
// Created by evertonagilar on 04/01/23.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "program.h"

program_t *loadProgramStructure(char *programFileName) {
    program_t *program = malloc(sizeof(program_t));
    program->module = loadModule(programFileName);
    return program;
}

void *freeProgramStructure(program_t *program) {
    free(program->module);
    free(program);
}

