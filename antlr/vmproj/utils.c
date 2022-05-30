//
// Created by evertonagilar on 29/05/22.
//

#include <stdio.h>
#include <fcntl.h>
#include <errno.h>
#include <stdlib.h>
#include "types.h"

void printInstrucao(const int op, const int *pc, const int cycle) {
    printf("%d> %.4s", cycle,
           &"LEA ,IMM ,JMP ,CALL,JZ  ,JNZ ,ENT ,ADJ ,LEV ,LI  ,LC  ,SI  ,SC  ,PUSH,"
            "OR  ,XOR ,AND ,EQ  ,NE  ,LT  ,GT  ,LE  ,GE  ,SHL ,SHR ,ADD ,SUB ,MUL ,DIV ,MOD ,"
            "OPEN,READ,CLOS,PRTF,MALC,MSET,MCMP,EXIT"[op * 5]);
    if (op <= ADJ)
        printf(" %d\n", *pc);
    else
        printf("\n");
}

FILE *openFileName(const char *fileName, const char *modes){
    FILE *fd = fopen(fileName, modes);
    if (!fd) {
        printf("Não foi possível abrir arquivo %s. Code: %d", fileName, errno);
        exit(-1);
    }
    return fd;
}


long getFileSize(const FILE *fd){
    long current = ftell(fd);
    fseek(fd, 0, SEEK_END);
    long result =  ftell(fd);
    fseek(fd, current, SEEK_SET);
    return result;
}
