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
#include "module.h"

module_t *mainModule;               // módulo principal
long *text;                         // text segment
long *old_text;                     // for dump text segment
long *stack;                        // stack
char *data;                         // data segment
long *pc, *bp, *sp, ax, cycle;      // virtual machine registers
int debug = true;                   // imprimir as instruções enquanto interpreta?

const int stackSize = 1000 * sizeof(long);

int startVM() {
    long op;
    data = calloc(mainModule->size, 1);
    stack = calloc(stackSize, 1);
    pc = text = mainModule->text;
    bp = sp = stack + stackSize;     // sp sempre aponta para topo da pilha
    ax = 0;
    cycle = 0;

    printf("Carregando %s.\n", mainModule->filename);
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
            case LC:
                // load character to ax, address in ax
                ax = *(char *) ax;
                break;
            case LI:
                // load integer to ax, address in ax
                ax = *(long *) ax;
                break;
            case SC:
                // save character to address, value in ax, address on stack
                ax = *(char *) *sp++ = ax;
                break;
            case SI:
                // save integer to address, value in ax, address on stack
                *(long *) *sp++ = ax;
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
            case CALL:
                // call subroutine
                *--sp = (long) (pc + 1);
                pc = (long *) *pc;
                break;
//            case RET:
//                // return from subroutine
//                pc = (long *)*sp++;
//                break;
            case ENT:
                // make new stack frame
                *--sp = (long) bp;
                bp = sp;
                sp = sp - *pc++;
                break;
            case ADJ:
                // add esp, <size>
                sp = sp + *pc++;
                break;
            case LEV:
                // restore call frame and pc
                sp = bp;
                bp = (long *) *sp++;
                pc = (long *) *sp++;
                break;
            case LEA:
                // load address for arguments.
                ax = (long) (bp + *pc++);
                break;
            default:
                printf("Instrução desconhecida: %d\n", op);
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

    geraByteCodeFunctionCall(argv[1]);
    mainModule = loadModule(argv[1]);
    startVM();
    freeModule(mainModule);

    return 0;
}
