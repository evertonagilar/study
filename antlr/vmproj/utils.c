//
// Created by evertonagilar on 29/05/22.
//

#include <stdio.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>
#include <stdlib.h>
#include "types.h"

void printInstrucao(Instrucao *instrucao) {
    switch (instrucao->opcode) {
        case IMM:
            printf("\tIMM %d\n", instrucao->arg1);
            break;
        case PUSH:
            printf("\tPUSH\n");
            break;
    }
}

int openFileName(const char *fileName, int mode){
    int fd = open(fileName, O_RDONLY);
    if (fd == -1) {
        printf("Não foi possível abrir arquivo %s. Code: %d", fileName, errno);
        exit(-1);
    }
}


int getFileSize(int fd){
    int current = lseek(fd, 0, SEEK_CUR);
    int size = lseek(fd, 0, SEEK_END);
    lseek(fd, current, SEEK_SET);
    return size;
}
