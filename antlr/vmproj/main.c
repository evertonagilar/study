#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>
#include <memory.h>
#include "types.h"
#include "utils.h"

#define WORKING_DIR "/home/evertonagilar/study/antlr/vmproj/";

int *text;                          // text segment
int *old_text;                      // for dump text segment
int *stack;                         // stack
char *data;                         // data segment
int *pc, *bp, *sp, ax, cycle;       // virtual machine registers
int poolsize;                       // default size of text/data/stack
int debug = 0;                      // imprimir as instruções enquanto interpreta?


void loadByteCode(const char *fileName) {
    int fd = openFileName(fileName, O_RDONLY);
    int count = getFileSize(fd) / sizeof(Instrucao);
    poolsize = sizeof(Instrucao) * count;
    Instrucao *src = malloc(poolsize);
    int bytesRead = read(fd, src, poolsize);
    close(fd);
    printf("Instruções do arquivo:\n");
    for (int i = 0; i < count; i++) {
        Instrucao *instrucao = &src[i];
        printInstrucao(instrucao);
    }
}

void saveTest1() {
    const count = 2;
    const int size = sizeof(Instrucao) * count;
    Instrucao *src = malloc(size);
    src[0].opcode = IMM;
    src[0].arg1 = 10;
    src[1].opcode = PUSH;
    src[1].arg1 = 0;
    const char filename[] = WORKING_DIR "test1.bin";
    int fd = openFileName(filename, O_WRONLY + O_CREAT);
    for (int i = 0; i < count; i++) {
        const void *instrucao = &src[i];
        write(fd, instrucao, sizeof(Instrucao));
    }
    close(fd);
}

void allocateMemory() {
    text = calloc(poolsize, 8);
    data = calloc(poolsize, 8);
    stack = calloc(poolsize, 8);
    ax = 0;
}

int runByteCode() {
    int op, *tmp;
    cycle = 0;
    while (1) {
        cycle++;
        op = *pc++; // get next operation code

        // print debug info
        if (debug) {
            printf("%d> %.4s", cycle,
                   &"LEA ,IMM ,JMP ,CALL,JZ  ,JNZ ,ENT ,ADJ ,LEV ,LI  ,LC  ,SI  ,SC  ,PUSH,"
                    "OR  ,XOR ,AND ,EQ  ,NE  ,LT  ,GT  ,LE  ,GE  ,SHL ,SHR ,ADD ,SUB ,MUL ,DIV ,MOD ,"
                    "OPEN,READ,CLOS,PRTF,MALC,MSET,MCMP,EXIT"[op * 5]);
            if (op <= ADJ)
                printf(" %d\n", *pc);
            else
                printf("\n");
        }
        if (op == IMM) { ax = *pc++; }                                     // load immediate value to ax
        else if (op == LC) { ax = *(char *) ax; }                               // load character to ax, address in ax
        else if (op == LI) { ax = *(int *) ax; }                                // load integer to ax, address in ax
        else if (op ==
                 SC) { ax = *(char *) *sp++ = ax; }                       // save character to address, value in ax, address on stack
        else if (op ==
                 SI) { *(int *) *sp++ = ax; }                             // save integer to address, value in ax, address on stack
        else if (op == PUSH) { *--sp = ax; }                                     // push the value of ax onto the stack
        else if (op == JMP) { pc = (int *) *pc; }                                // jump to the address
        else if (op == JZ) { pc = ax ? pc + 1 : (int *) *pc; }                   // jump if ax is zero
        else if (op == JNZ) { pc = ax ? (int *) *pc : pc + 1; }                   // jump if ax is not zero
        else if (op == CALL) {
            *--sp = (int) (pc + 1);
            pc = (int *) *pc;
        }           // call subroutine
            //else if (op == RET)  {pc = (int *)*sp++;}                              // return from subroutine;
        else if (op == ENT) {
            *--sp = (int) bp;
            bp = sp;
            sp = sp - *pc++;
        }      // make new stack frame
        else if (op == ADJ) { sp = sp + *pc++; }                                // add esp, <size>
        else if (op == LEV) {
            sp = bp;
            bp = (int *) *sp++;
            pc = (int *) *sp++;
        }  // restore call frame and PC
        else if (op == LEA) { ax = (int) (bp + *pc++); }                         // load address for arguments.

        else if (op == OR) ax = *sp++ | ax;
        else if (op == XOR) ax = *sp++ ^ ax;
        else if (op == AND) ax = *sp++ & ax;
        else if (op == EQ) ax = *sp++ == ax;
        else if (op == NE) ax = *sp++ != ax;
        else if (op == LT) ax = *sp++ < ax;
        else if (op == LE) ax = *sp++ <= ax;
        else if (op == GT) ax = *sp++ > ax;
        else if (op == GE) ax = *sp++ >= ax;
        else if (op == SHL) ax = *sp++ << ax;
        else if (op == SHR) ax = *sp++ >> ax;
        else if (op == ADD) ax = *sp++ + ax;
        else if (op == SUB) ax = *sp++ - ax;
        else if (op == MUL) ax = *sp++ * ax;
        else if (op == DIV) ax = *sp++ / ax;
        else if (op == MOD) ax = *sp++ % ax;

        else if (op == EXIT) {
            printf("exit(%d)", *sp);
            return *sp;
        } else if (op == OPEN) { ax = open((char *) sp[1], sp[0]); }
        else if (op == CLOS) { ax = close(*sp); }
        else if (op == READ) { ax = read(sp[2], (char *) sp[1], *sp); }
        else if (op == PRTF) {
            tmp = sp + pc[1];
            ax = printf((char *) tmp[-1], tmp[-2], tmp[-3], tmp[-4], tmp[-5], tmp[-6]);
        } else if (op == MALC) { ax = (int) malloc(*sp); }
        else if (op == MSET) { ax = (int) memset((char *) sp[2], sp[1], *sp); }
        else if (op == MCMP) { ax = memcmp((char *) sp[2], (char *) sp[1], *sp); }
        else {
            printf("unknown instruction:%d\n", op);
            return -1;
        }
    }
}

int main(int argc, char **argv) {
    printf("Executando máquina virtual\n");

    if (argc < 2) {
        printf("Uso: vmproj file\n");
        return -1;
    }

    char *byteCodeFileName = argv[1];
    printf("Carregando %s.\n", byteCodeFileName);

    saveTest1();
    loadByteCode(byteCodeFileName);
    //allocateMemory();
    //runByteCode();


    return 0;
}

