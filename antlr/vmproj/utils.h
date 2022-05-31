//
// Created by evertonagilar on 29/05/22.
//

#ifndef VMPROJ_UTILS_H
#define VMPROJ_UTILS_H

#include "types.h"

void printInstrucao(const long op, const long *pc, const int cycle);
FILE *openFileName(char *filename, const char *modes);
long getFileSize(const FILE *fd);
void writeFile(const char *filename, const int *buf, int size);


#endif //VMPROJ_UTILS_H
