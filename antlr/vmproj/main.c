#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>
#include <memory.h>
#include <stdbool.h>
#include "types.h"
#include "utils.h"
#include "test.h"

char *byteCodeFileName;             // arquivo com os byte code para interpretar
long byteCodeFileSize;               // default size of text/data/stack
long *text;                          // text segment
long *old_text;                      // for dump text segment
long *stack;                        // stack
char *data;                         // data segment
long *pc, *bp, *sp, ax, cycle;      // virtual machine registers
int debug = true;                   // imprimir as instruções enquanto interpreta?

const int stackSize = 1000 * sizeof(long);

void loadByteCode() {
    byteCodeFileSize = getFileSizeByFileName(byteCodeFileName);
    text = malloc(byteCodeFileSize);
    readFileAll(byteCodeFileName, text, byteCodeFileSize);
}

int runByteCode() {
    long op;
    data = calloc(byteCodeFileSize, 1);
    stack = calloc(stackSize, 1);
    pc = text;
    bp = sp = stack + stackSize;     // sp sempre aponta para topo da pilha
    ax = 0;
    cycle = 0;
    while (1) {
        cycle++;
        op = (long) *pc++; // get next operation code

        // imprime a instrução a cada ciclo
        if (debug) {
            printInstrucao(op, pc, cycle);
        }

        // *********** opcodes *************

        switch (op) {
            case IMM:
                // load immediate value to ax
                ax = (long) *pc++;
                break;
            case PUSH:
                // push the value of ax onto the stack
                *--sp = ax;
                break;
            case EXIT:
                printf("exit(%ld)", *sp);
                return *sp;
            case ADD:
                ax = *sp++ + ax;
                break;
            case SUB:
                ax = *sp++ - ax;
                break;
            case MUL:
                ax = *sp++ * ax;
                break;
            case DIV:
                ax = *sp++ / ax;
                break;
            case MOD:
                ax = *sp++ % ax;
                break;
            case OR:
                ax = *sp++ | ax;
                break;
            case XOR:
                ax = *sp++ ^ ax;
                break;
            case AND:
                ax = *sp++ & ax;
                break;
            case EQ:
                ax = *sp++ == ax;
                break;
            case NE:
                ax = *sp++ != ax;
                break;
            case LT:
                ax = *sp++ < ax;
                break;
            case LE:
                ax = *sp++ <= ax;
                break;
            case GT:
                ax = *sp++ > ax;
                break;
            case GE:
                ax = *sp++ >= ax;
                break;
            case SHL:
                ax = *sp++ << ax;
                break;
            case SHR:
                ax = *sp++ >> ax;
                break;
            case JZ:
                // jump if ax is zero
                pc = ax ? pc + 1 : (long *) *pc;
                break;
            case JNZ:
                // jump if ax is not zero
                pc = ax ? (long *) *pc : pc + 1;
                break;
            case JMP:
                pc = (long *) *pc;
                break;
            default:
                printf("Instrução desconhecida: %d\n", op);
                return -1;
        }

        continue;
        if (op == IMM) {
        }
            // load character to ax, address in ax
        else if (op == LC) {
            ax = *(char *) ax;
        }
            // load integer to ax, address in ax
        else if (op == LI) {
            ax = *(int *) ax;
        }
            // save character to address, value in ax, address on stack
        else if (op == SC) {
            ax = *(char *) *sp++ = ax;
        }
            // save integer to address, value in ax, address on stack
        else if (op == SI) {
            *(int *) *sp++ = ax;
        } else if (op == PUSH) {
        } else if (op == JMP) {
            pc = (int *) *pc;
        }                                // jump to the address
        else if (op == JZ) {
            pc = ax ? pc + 1 : (int *) *pc;
        }                   // jump if ax is zero
        else if (op == JNZ) {
            pc = ax ? (int *) *pc : pc + 1;
        }                   // jump if ax is not zero
        else if (op == CALL) {
            *--sp = (int) (pc + 1);
            pc = (int *) *pc;
        }
            // call subroutine
            //else if (op == RET)  {pc = (int *)*sp++;}                              // return from subroutine;
        else if (op == ENT) {
            *--sp = (int) bp;
            bp = sp;
            sp = sp - *pc++;
        }
            // make new stack frame
        else if (op == ADJ) {
            sp = sp + *pc++;
        }                                // add esp, <size>
        else if (op == LEV) {
            sp = bp;
            bp = (int *) *sp++;
            pc = (int *) *sp++;
        }  // restore call frame and PC
        else if (op == LEA) {
            ax = (int) (bp + *pc++);
        }                         // load address for arguments.

        else if (op == OPEN) {
            ax = open((char *) sp[1], sp[0]);
        } else if (op == CLOS) {
            ax = close(*sp);
        } else if (op == READ) {
            ax = read(sp[2], (char *) sp[1], *sp);
        } else if (op == PRTF) {
            long *tmp = sp + pc[1];
            ax = printf((char *) tmp[-1], tmp[-2], tmp[-3], tmp[-4], tmp[-5], tmp[-6]);
        } else if (op == MALC) {
            ax = (int) malloc(*sp);
        } else if (op == MSET) {
            ax = (int) memset((char *) sp[2], sp[1], *sp);
        } else if (op == MCMP) {
            ax = memcmp((char *) sp[2], (char *) sp[1], *sp);
        } else {
            printf("unknown instruction:%d\n", op);
            return -1;
        }
    }
}

int main(int argc, char **argv) {
    printf("Executando máquina virtual (%ld bits)\n", sizeof(long) * 8);

    if (argc < 2) {
        printf("Uso: vmproj file\n");
        return -1;
    }

    byteCodeFileName = argv[1];
    printf("Carregando %s.\n", byteCodeFileName);

    geraByteCodeIfElseTest(byteCodeFileName);
    loadByteCode();
    runByteCode();

    return 0;
}

