//
// Created by evertonagilar on 29/05/22.
//

#ifndef VMPROJ_TYPES_H
#define VMPROJ_TYPES_H

typedef struct {
    int opcode;
    int arg1;
} Instrucao;

// instructions
enum {
    LEA, IMM, JMP, CALL, JZ, JNZ, ENT, ADJ, LEV, LI, LC, SI, SC, PUSH,
    OR, XOR, AND, EQ, NE, LT, GT, LE, GE, SHL, SHR, ADD, SUB, MUL, DIV, MOD,
    OPEN, READ, CLOS, PRTF, MALC, MSET, MCMP, EXIT
};


#endif //VMPROJ_TYPES_H
