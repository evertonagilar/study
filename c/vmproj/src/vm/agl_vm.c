#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "agl_vm.h"

const int STACK_MAX_SIZE = 1000 * sizeof(long);

void printInstrucao(long op, const long *pc, int cycle) {
    printf("%d> %.4s", cycle,
           &"LEA ,IMM ,JMP ,CALL,JZ  ,JNZ ,ENT ,ADJ ,LEV ,LI  ,LC  ,SI  ,SC  ,PUSH,"
            "OR  ,XOR ,AND ,EQ  ,NE  ,LT  ,GT  ,LE  ,GE  ,SHL ,SHR ,ADD ,SUB ,MUL ,DIV ,MOD ,"
            "OPEN,READ,CLOS,PRTF,MALC,MSET,MCMP,EXIT"[op * 5]);
    if (op <= ADJ)
        printf(" %ld\n", *pc);
    else
        printf("\n");
}

agl_vm_t *agl_vm_create(char *filename, bool debug) {
    agl_vm_t *vm = malloc(sizeof(agl_vm_t));
    vm->program = agl_program_load(filename);
    vm->debug = debug;
    return vm;
}

int agl_vm_start(agl_vm_t *vm) {
    long *pc, *bp, *sp, ax, cycle;      // virtual machine registers
    long *text;                         // text segment
    long *old_text;                     // for dump text segment
    long op;
    long *stack;                        // stack
    char *data;                         // data segment
    data = calloc(vm->program->module->size, 1);
    stack = calloc(STACK_MAX_SIZE, 1);
    pc = text = vm->program->module->text;
    bp = sp = stack + STACK_MAX_SIZE;     // sp sempre aponta para topo da pilha
    ax = 0;
    cycle = 0;

    while (1) {
        cycle++;
        op = (long) *pc++; // get agl_lexer_next_token operation code

        // imprime a instrução a cada ciclo
        if (vm->debug) {
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
                printf("Instrução desconhecida: %ld\n", op);
                return -1;
        }
    }
}

void agl_vm_free(agl_vm_t *vm) {
    agl_program_free(vm->program);
    free(vm);
}
