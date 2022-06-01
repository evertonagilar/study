//
// Created by evertonagilar on 30/05/22.
//

#include <stdio.h>
#include <malloc.h>
#include "utils.h"

void geraByteCodeValorNaPilhaTest(const char *filename) {
    long src[4];
    src[0] = IMM;
    src[1] = 10;
    src[2] = PUSH;
    src[3] = EXIT;
    FILE *fd = openFileName(filename, "w");
    fwrite(&src, sizeof(src), 1, fd);
    fclose(fd);
}

void geraByteCodeSomaTest(const char *filename) {
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

void geraByteCodeIfTest(const char *filename) {
    const long filesize = 100 * sizeof(long);
    long *text, *src, *b;
    text = src = malloc(filesize);
    *text++ = IMM;          // Carrega 10 em ax
    *text++ = 10;
    *text++ = PUSH;         // Coloca na pilha
    *text++ = IMM;          // Carrega 4 em ax
    *text++ = 4;
    *text++ = NE;           // 10 != 4 ?
    *text++ = JZ;           // ax ? pc + 1 : (long *) *pc;
    b = text++;             // slot para endereço fim trueStatement
    *text++ = IMM;          // Carrega valor 50 em ax
    *text++ = 50;
    *text++ = PUSH;         // Coloca na pilha
    *text++ = EXIT;         // return 50
    *b =  text;            // salva o endereço em b
    *text++ = IMM;          // Carrega valor 25 em ax
    *text++ = 25;
    *text++ = PUSH;         // Coloca na pilha
    *text++ = EXIT;         // return 25
    writeFileAll(filename, src, filesize);
}