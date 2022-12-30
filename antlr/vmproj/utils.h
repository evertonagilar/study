//
// Created by evertonagilar on 29/05/22.
//

#ifndef VMPROJ_UTILS_H
#define VMPROJ_UTILS_H

#include "types.h"

void printInstrucao(long op, const long *pc, int cycle);
FILE *openFileName(const char *filename, const char *modes);
size_t getFileSize(FILE *fd);
size_t getFileSizeByFileName(const char *filename);
void writeFileAll(const char *filename, int *buf, size_t size);
void readFileAll(const char *filename, void *buf, size_t size);



#endif //VMPROJ_UTILS_H
