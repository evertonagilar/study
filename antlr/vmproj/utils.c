//
// Created by evertonagilar on 29/05/22.
//

#include <stdio.h>
#include <fcntl.h>
#include <errno.h>
#include <stdlib.h>
#include "types.h"

void printInstrucao(long op, const long *pc, int cycle) {
    printf("%d> %.4s", cycle,
           &"LEA ,IMM ,JMP ,CALL,JZ  ,JNZ ,ENT ,ADJ ,LEV ,LI  ,LC  ,SI  ,SC  ,PUSH,"
            "OR  ,XOR ,AND ,EQ  ,NE  ,LT  ,GT  ,LE  ,GE  ,SHL ,SHR ,ADD ,SUB ,MUL ,DIV ,MOD ,"
            "OPEN,READ,CLOS,PRTF,MALC,MSET,MCMP,EXIT"[op * 5]);
    if (op <= ADJ)
        printf(" %d\n", *pc);
    else
        printf("\n");
}

FILE *openFileName(const char *filename, const char *modes){
    FILE *fd = fopen(filename, modes);
    if (!fd) {
        printf("Não foi possível abrir arquivo %s. Code: %d", filename, errno);
        exit(-1);
    }
    return fd;
}

size_t getFileSize(FILE *fd){
    size_t current = ftell(fd);
    fseek(fd, 0, SEEK_END);
    size_t result =  ftell(fd);
    fseek(fd, current, SEEK_SET);
    return result;
}

size_t getFileSizeByFileName(const char *filename) {
    FILE *fd = openFileName(filename, "r");
    size_t result = getFileSize(fd);
    fclose(fd);
    return result;
}

void writeFileAll(const char *filename, int *buf, size_t size){
    FILE *fd = openFileName(filename, "w");
    fwrite(buf, size, 1, fd);
    fclose(fd);
}

void readFileAll(const char *filename, void *buf, size_t size){
    const FILE *fd = openFileName(filename, "r");
    fread(buf, size, 1, fd);
    fclose(fd);
}
