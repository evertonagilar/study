#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <string.h>
#include <unistd.h>
#include "utils.c"

int token;                      // current token
char *src, *old_src;            // pointer to source code
int poolsize;                   // default size of text/data/stack
int line;                       // line number
int *text,                      // text segment. armazena código
    *old_text,                  // for dump text segment
    *stack;                     // stack
char *data;                     // data segment. armazena variáveis

// virtual machine registers
int *pc,    // program counter, stores the next instruction to be run
    *bp,    // base pointer, points to some elements on the stack. It is used in function call
    *sp,    // stack pointer, points to the top of stack
    ax,     // a general register that we used to store the result of an instruction
    cycle;   

// instructions
enum {
    LEA,     // make function calls
    IMM,     // to put immediate <num> into register AX
    JMP,     // unconditionally set the value PC register to <addr>
    CALL,    // make function calls
    JZ,      // jump if AX is zero
    JNZ,     // jump if AX is not zero
    ENT,     // make a new calling frame
    ADJ,     // remove arguments from frame
    LEV,     // restore call frame and PC
    LI,      // load a int into AX from a memory address stored in AX
    LC,      // load a char into AX from a memory address stored in AX
    SI,      // store the int in AX into de memory address SP
    SC,      // store the char in AX into de memory address SP
    PUSH,    // push the value of AX into stack
    OR, XOR, AND, EQ, NE, LT, GT, LE, GE, SHL, SHR, ADD, SUB, MUL, DIV, MOD, // operators
    OPEN,READ,CLOS,PRTF,MALC,MSET,MCMP,EXIT // intrinsic functions
    }









}


// lexical analysis
void next() {
    token = *src++;
    return;
}

// parse expression
void expression(int level){
    //
}

// main entrance for parser
void program(){
    next();
    while (token > 0){
        printf("token is %c\n", token);
        next();
    }
}

// the entrance to virtual machine
int eval(){
    return 0;
}

int main(int argc, char **argv){
    int i;
    FILE *fd;
    char erro_str[100];

    argc--;
    argv++;
    char *sourceFileName = *argv;

    line = 1;

    fd = fopen(sourceFileName, "r");
    if (fd == NULL){
        sprintf(erro_str, "could not open %s", sourceFileName);
        perror(erro_str);
        return -1;
    }

    fseek (fd, 0 , SEEK_END);
    poolsize = ftell(fd);
    rewind (fd);
    if (!(src = old_src = malloc(poolsize))){
        printf("could not allocate memory for source area.\n");
    }

    // read the source file
    if ((i = fread(src, 1, poolsize, fd)) < 0){
        printf("could not read source file %s.\n", sourceFileName);
    }else{
        src[i] = 0; // add EOF character
        fclose(fd);
    }

    program();
    return eval();
    pause();

}