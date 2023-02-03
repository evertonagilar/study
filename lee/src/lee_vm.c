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
#include <stdbool.h>
#include "lee_vm.h"
#include "lee_program.h"

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

lee_vm_t *lee_vm_create(char *filename, bool debug) {
    lee_vm_t *vm = malloc(sizeof(lee_vm_t));
    vm->program = lee_program_load(filename);
    vm->debug = debug;
    return vm;
}

int lee_vm_start(lee_vm_t *vm) {
    long *pc, *bp, *sp, ax, cycle;      // virtual machine registers
    long *text;                         // text segment
    long *old_text;                     // for dump text segment
    long op;
    long *stack;                        // stack
    char *data;                         // pData segment
    //pData = calloc(vm->program->mainModule->sourceFile->count, 1);
    stack = calloc(STACK_MAX_SIZE, 1);
    pc = text = vm->program->mainModule->text;
    bp = sp = stack + STACK_MAX_SIZE;     // sp sempre aponta para topo da pilha
    ax = 0;
    cycle = 0;

    while (1) {
        cycle++;
        op = (long) *pc++; // get lee_scanner_next_token operation code

        // imprime a instrução a cada ciclo
        if (vm->debug) {
            printInstrucao(op, pc, cycle);
        }

        // *********** opcodes *************

        switch (op) {
            case IMM:
                // load immediate symbol to ax
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
                // save character to address, symbol in ax, address on stack
                ax = *(char *) *sp++ = ax;
                break;
            case SI:
                // save integer to address, symbol in ax, address on stack
                *(long *) *sp++ = ax;
                break;
            case PUSH:
                // push the symbol of ax onto the stack
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
                // add esp, <count>
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

void lee_vm_free(lee_vm_t *vm) {
    lee_program_free(vm->program);
    free(vm);
}
