//
// Created by evertonagilar on 29/05/22.
//

#ifndef VMPROJ_UTILS_H
#define VMPROJ_UTILS_H

#include "types.h"

void printInstrucao(const int op, const int *pc, const int cycle);
FILE *openFileName(char *fileName, const char *modes);
long getFileSize(const FILE *fd);


#endif //VMPROJ_UTILS_H
