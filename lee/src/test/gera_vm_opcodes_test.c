/*
 * %CopyrightBegin%
 *
 * Copyright Everton de Vargas Agilar 2022. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * %CopyrightEnd%
 */

#include <stdio.h>
#include <stdlib.h>
#include "gera_vm_opcodes_test.h"
#include "../lee_defs.h"
#include "../utils/lee_file_utils.h"

void geraByteCodeValorNaPilhaTest(const char *filename) {
    long src[4];
    src[0] = IMM;
    src[1] = 10;
    src[2] = PUSH;
    src[3] = EXIT;
    FILE *fd = lee_openFileName(filename, "w");
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
    FILE *fd = lee_openFileName(filename, "w");
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
    *b = (long) text;       // salva o endereço em b
    *text++ = IMM;          // Carrega valor 25 em ax
    *text++ = 25;
    *text++ = PUSH;         // Coloca na pilha
    *text++ = EXIT;         // return 25
    lee_writeFileAll(filename, src, filesize);
}

void geraByteCodeIfElseTest(const char *filename) {
    const long filesize = 100 * sizeof(long);
    long *text, *src;
    long *label_else, *label_exit;
    text = src = malloc(filesize);
    *text++ = IMM;              // Carrega 10 em ax
    *text++ = 10;
    *text++ = PUSH;             // Coloca na pilha
    *text++ = IMM;              // Carrega 4 em ax
    *text++ = 4;
    // if (10 > 4)
    *text++ = GT;               // 10 > 4 ?
    *text++ = JZ;               // ax ? pc + 1 : (long *) *pc;
    label_else = text++;        // ponteiro para inicio do else usado pela instrução anterior
    // {
        *text++ = IMM;          // Carrega valor 5 em ax
        *text++ = 5;
        *text++ = PUSH;         // Coloca na pilha
        *text++ = JMP;
        label_exit = text++;    // ponteiro para fim if usado pela instrução anterior
    // } else {
        *label_else = (long) text;     // salva o endereço do else no slot label_else
        *text++ = IMM;          // Carrega valor 10 em ax
        *text++ = 10;
        *text++ = PUSH;         // Coloca na pilha
    // }
    // código após if
    *label_exit = (long) text;
    *text++ = EXIT;             // return 25

    lee_writeFileAll(filename, src, filesize);
}

void criaByteCodeDeExemplo(const char *filename){
    const long filesize = 100 * sizeof(long);
    long *text, *src;
    long *label_function, *label_main;
    text = src = malloc(filesize);

    *text++ = JMP;                  // vai para o main
    label_main = text++;            // ponteiro para o main

    // ****** função soma começa aqui *****
    label_function = text;          // ponteiro para função soma
    // soma(int a, int b){
        *text++ = ENT;              // make new stack frame
        // Carrega argumento a em ax e depois na pilha
        *text++ = LEA;
        *text++ = 1;
        *text++ = LI;
        *text++ = PUSH;

        // Carrega argumento b em ax
        *text++ = LEA;
        *text++ = 2;
        *text++ = LI;

        *text++ = ADD;              // a + b

        *text++ = LEV;               // restore call frame and pc
    // }
    // ****** função main começa aqui *****
    *label_main = (long) text;             // aqui começa o main, salva no ponteiro
    // push argument a
    *text++ = IMM;
    *text++ = 10;
    *text++ = PUSH;
    // push argument b
    *text++ = IMM;
    *text++ = 5;
    *text++ = PUSH;
    // call function
    *text++ = CALL;
    *text++ = (long) label_function;
    // próxima instrução após chamada função
    *text++ = PUSH;
    *text++ = EXIT;             // return 15

    lee_writeFileAll(filename, src, filesize);
}
