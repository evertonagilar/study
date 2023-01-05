//
// Created by evertonagilar on 29/05/22.
//

#ifndef VMPROJ_AGL_FILE_UTILS_H
#define VMPROJ_AGL_FILE_UTILS_H

#include <stdio.h>
#include "../vm/agl_vm_types.h"

void printInstrucao(long op, const long *pc, int cycle);
FILE *agl_openFileName(const char *filename, const char *modes);
size_t agl_getFileSize(FILE *fd);
size_t agl_getFileSizeByFileName(const char *filename);
void agl_writeFileAll(const char *filename, void *buf, size_t size);
size_t agl_readFileAll(const char *filename, void *buf, size_t size);



#endif //VMPROJ_AGL_FILE_UTILS_H
