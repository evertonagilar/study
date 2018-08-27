#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <string.h>
#include <unistd.h>
#include "utils.c"

int token;                 // current token
char *src, *old_src;       // pointer to source code
int poolsize = 256 * 1024; // default size of text/data/stack
int line;                  // line number
int *text,                 // text segment. armazena código
    *old_text,             // for dump text segment
    *stack;                // stack
char *data;                // data segment. armazena variáveis

// virtual machine registers
int *pc, // program counter, stores the next instruction to be run
    *bp, // base pointer, points to some elements on the stack. It is used in function call
    *sp, // stack pointer, points to the top of stack
    ax,  // a general register that we used to store the result of an instruction
    cycle;

// instructions
enum
{
    LEA,  // make function calls
    IMM,  // put immediate <num> into register AX
    JMP,  // unconditionally set the value PC register to <addr>
    CALL, // make function calls
    JZ,   // jump if AX is zero
    JNZ,  // jump if AX is not zero
    ENT,  // make a new calling frame
    ADJ,  // remove arguments from frame
    LEV,  // restore call frame and PC
    LI,   // load a int into AX from a memory address stored in AX
    LC,   // load a char into AX from a memory address stored in AX
    SI,   // store the int in AX into de memory address SP
    SC,   // store the char in AX into de memory address SP
    PUSH, // push the value of AX into stack
    // operators 
    // each operator has two arguments: the first one is stored on the top of the stack while
    // the second is stored in ax
    OR,
    XOR,
    AND,
    EQ,
    NE,
    LT,
    GT,
    LE,
    GE,
    SHL,
    SHR,
    ADD,
    SUB,
    MUL,
    DIV,
    MOD, 
    // intrinsic functions
    OPEN,
    READ,
    CLOS,
    PRTF,
    MALC,
    MSET,
    MCMP,
    EXIT 
};

// lexical analysis
void next()
{
    token = *src++;
    return;
}

// parse expression
void expression(int level)
{
    //
}

// main entrance for parser
void program()
{
    next();
    while (token > 0)
    {
        printf("token is %c\n", token);
        next();
    }
}

// the entrance to virtual machine
int eval()
{
    return 0;
}

int main(int argc, char **argv)
{
    int i;
    FILE *fd;
    char erro_str[100];
    argv++;
    line = 1;
    char *sourceFileName = *argv;

    // open source file
    fd = fopen(sourceFileName, "r");
    if (fd == NULL)
    {
        sprintf(erro_str, "could not open %s", sourceFileName);
        perror(erro_str);
        return -1;
    }

    // get file_size
    fseek(fd, 0, SEEK_END);
    int file_size = ftell(fd);
    rewind(fd);

    // alloc memory to source code
    if (!(src = old_src = malloc(file_size)))
    {
        printf("could not allocate memory for source area.\n");
    }

    // read the source file into src
    if ((i = fread(src, 1, file_size, fd)) < 0)
    {
        sprintf(erro_str, "could not read source file %s.\n", sourceFileName);
        perror(erro_str);
        return EXIT_FAILURE;
    }
    src[i] = 0; // add EOF character
    fclose(fd);

    // allocate memory to virtual machine
    if (!(text = old_text = calloc(poolsize, 1)))
    {
        puts("could not allocate memory for text area.\n");
        return EXIT_FAILURE;
    }
    if (!(data = calloc(poolsize, 1)))
    {
        puts("could not allocate memory for data area.\n");
        return EXIT_FAILURE;
    }
    if (!(stack = calloc(poolsize, 1)))
    {
        puts("could not allocate memory for stack area.\n");
        return EXIT_FAILURE;
    }

    bp = sp = stack + poolsize;
    ax = 0;

    // Simula o cálculo 10 + 20
    i = 0;
    text[i++] = IMM;          // carrega o primeiro valor inteiro imediato para ax
    text[i++] = 10;
    
    text[i++] = PUSH;         // coloca o valor imediato de AX na pilha

    text[i++] = IMM;          // carrega o segundo valor inteiro imediato para ax
    text[i++] = 20;

    text[i++] = ADD;          // ax = 10 + 20  

    text[i++] = PUSH;         // coloca o resultado na pilha

    text[i++] = EXIT;         // sai do programa  

    // next instruction to be run
    pc = text;

    program();
    return eval();
}