//
// Created by evertonagilar on 29/05/22.
//

#ifndef VMPROJ_UTILS_H
#define VMPROJ_UTILS_H

#include "types.h"

void printInstrucao(Instrucao *instrucao);
int openFileName(char *fileName, int mode);
int getFileSize(int fd);

#endif //VMPROJ_UTILS_H
