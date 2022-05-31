//
// Created by evertonagilar on 30/05/22.
//

#include <stdio.h>
#include <malloc.h>
#include "utils.h"

void saveTest1(const char *filename) {
    long src[4];
    src[0] = IMM;
    src[1] = 10;
    src[2] = PUSH;
    src[3] = EXIT;
    FILE *fd = openFileName(filename, "w");
    fwrite(&src, sizeof(src), 1, fd);
    fclose(fd);
}

void saveTest2(const char *filename) {
    long src[8];
    src[0] = IMM;
    src[1] = 10;
    src[2] = PUSH;
    src[3] = IMM;
    src[4] = 5;
    src[5] = ADD;
    src[6] = PUSH;
    src[7] = EXIT;
    FILE *fd = openFileName(filename, "w");
    fwrite(&src, sizeof(src), 1, fd);
    fclose(fd);
}

void saveTest3(const char *filename) {
    const long filesize = 100 * sizeof(long);
    long *src = malloc(filesize);
    int i = 0;
    long *b;
    src[i++] = IMM;     // Carrega 10 em ax
    src[i++] = 10;
    src[i++] = PUSH;    // Coloca na pilha
    src[i++] = IMM;     // Carrega 4 em ax
    src[i++] = 4;
    src[i++] = EQ;      // 10 == 4 ?
    src[i++] = JZ;      // ax ? pc + 1 : (int *) *pc;
    b = &src[i];        // slot para endereço fim trueStatement
    src[i++] = IMM;     // Carrega valor 50 em ax
    src[i++] = 50;
    src[i++] = PUSH;    // Coloca na pilha
    src[i++] = EXIT;    // return 50
    *b = &src[i];       // salva o endereço em b
    src[i++] = IMM;     // Carrega valor 25 em ax
    src[i++] = 25;
    src[i++] = PUSH;    // Coloca na pilha
    src[i++] = EXIT;    // return 25
    writeFile(filename, src, filesize);
}
