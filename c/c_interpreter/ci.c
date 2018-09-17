#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <string.h>
#include <unistd.h>
#include "utils.c"

#define SYMBOLS_SIZE 256 * 1024 // Tamanho da tabela de símbolos

int token;       // token atual
int token_val;   // valor do token atual quando é número
int *current_id; // identificador atual parseado
int *symbols;    // tabela de símbolos
int *idmain;     // função main

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

// tokens e classes
enum
{
    Num = 128,
    Fun,
    Sys,
    Glo,
    Loc,
    Id,
    Char,
    Else,
    Enum,
    If,
    Int,
    Return,
    Sizeof,
    While,
    Assign,
    Cond,
    Lor,
    Lan,
    Or,
    Xor,
    And,
    Eq,
    Ne,
    Lt,
    Gt,
    Le,
    Ge,
    Shl,
    Shr,
    Add,
    Sub,
    Mul,
    Div,
    Mod,
    Inc,
    Dec,
    Brak
};

// Campos dos identificadores na tabela de símbolos
enum
{
    Token,
    Hash,
    Name,
    Type,
    Class,
    Value,
    BType,
    BClass,
    BValue,
    IDSize
};

// tipos de variáveis e funções
enum
{
    CHAR,
    INT,
    PTR
};

// lexical analysis
void next()
{
    char *last_pos;
    int hash;

    while (token = *src)
    {
        ++src; // já aponta para o próximo carácter no código fonte

        // pula linha em branco
        if (token == '\n')
        {
            ++line;
        }
        // Pular macro pois nosso compilador não suporta
        else if (token == '#')
        {
            while (*src != 0 && *src != '\n'){
                src++;
            }
        }
        // parse identificadores
        else if ((token >= 'a' && token <= 'z') || (token >= 'A' && token <= 'Z') || token == '_')
        {
            // endereço inicial do token
            last_pos = src - 1;    
            hash = token;

            // computa um hash do token para pesquisa na tabela de símbolos
            while ((*src >= 'a' && *src <= 'z') || (*src >= 'A' && *src <= 'Z') || (*src >= 'A' && *src <= 'Z') || (*src == '_'))
            {
                hash = hash * 147 + *src;
                src++;
            }

            // pesquisa na tabela de símbolos com pesquisa linear
            current_id = symbols;
            while (current_id[Token])
            {
                if (current_id[Hash] == hash && !memcmp(current_id[Name], last_pos, src - last_pos)){
                    // identificador encontrado, retorna este
                    token = current_id[Token];
                    return;
                }
                current_id = current_id + IDSize;
            }

            // insere novo identificador na tabela de símbolos
            current_id[Name] = last_pos;
            current_id[Hash] = Hash;
            token = current_id[Token] = Id;
            return;
        }
        // parse números. three kinds: dec(123) hex(0x123) oct(017)
        else if (token >= '0' && token <= '9')
        {
            token_val = token - 0;
            // números decimais
            if (token_val > 0){
                while (*src >= '0' && *src <= '9'){
                    token_val = token_val * 10 + *src++ - '0';
                }
            }else{
                // números hexadecimais
                if (*src == 'x' || *src == 'X'){
                    token = *++src;
                    while ((token >= '0' && token <= '9') || (token >= 'a' && token <= 'f') || (token >= 'A' && token <= 'F')){
                        token_val = token_val * 16 + (token & 15) + (token >= 'A' ? 9 : 0);
                        token = *++src;
                    }
                // números octais
                }else {
                    while (*src >= '0' && *src <= '9'){
                        token_val = token_val * 8 + *src++ - '0';
                    }
                }
            }

            token = Num;
            return;
        }
    }

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
    int op, *tmp;
    while (1)
    {

        // pega a operação a ser executada no registrador pc e já incrementa o pc
        op = *pc++; // get next operation code

        // colocar o valor imediato em ax
        if (op == IMM)
        {
            ax = *pc++;
        } // load immediate value to ax

        // carrega ax com o char que está no endereço armazenado em ax
        else if (op == LC)
        {
            ax = *(char *)ax;
        } // load character to ax, address in ax

        // carrega ax com o int que está no endereço armazenado em ax
        else if (op == LI)
        {
            ax = *(int *)ax;
        } // load integer to ax, address in ax

        // salvar o char que está em ax no topo da pilha
        // sp é incrementado para salvar na entrada atual na pilha
        else if (op == SC)
        {
            ax = *(char *)*sp++ = ax;
        } // save character to address, value in ax, address on stack

        // salvar o int que está em ax no topo da pilha
        // sp é incrementado para salvar na entrada atual na pilha
        else if (op == SI)
        {
            *(int *)*sp++ = ax;
        } // save integer to address, value in ax, address on stack

        // coloca o valor que está em ax na pilha
        else if (op == PUSH)
        {
            *--sp = ax;
        } // push the value of ax onto the stack

        // vai para o endereço que está em pc
        else if (op == JMP)
        {
            pc = (int *)*pc;
        } // jump to the address

        // se ax for zero, vai para o endereço que está em pc
        // senão continua executando pc + 1
        else if (op == JZ)
        {
            pc = ax ? pc + 1 : (int *)*pc;
        } // jump if ax is zero

        // se ax nao for zero, vai para o endereço que está em pc
        // senão continua executando pc + 1
        else if (op == JNZ)
        {
            pc = ax ? (int *)*pc : pc + 1;
        } // jump if ax is not zero

        // vai para a função que está em pc
        // mas antes salva na pilha o próximo
        // endereço que vai executar
        else if (op == CALL)
        {
            *--sp = (int)(pc + 1);
            pc = (int *)*pc;
        } // call subroutine

        //else if (op == RET)  {pc = (int *)*sp++;}                            // return from subroutine;
        else if (op == ENT)
        {
            *--sp = (int)bp;
            bp = sp;
            sp = sp - *pc++;
        } // make new stack frame
        else if (op == ADJ)
        {
            sp = sp + *pc++;
        } // add esp, <size>
        else if (op == LEV)
        {
            sp = bp;
            bp = (int *)*sp++;
            pc = (int *)*sp++;
        } // restore call frame and PC
        else if (op == ENT)
        {
            *--sp = (int)bp;
            bp = sp;
            sp = sp - *pc++;
        } // make new stack frame
        else if (op == ADJ)
        {
            sp = sp + *pc++;
        } // add esp, <size>
        else if (op == LEV)
        {
            sp = bp;
            bp = (int *)*sp++;
            pc = (int *)*sp++;
        } // restore call frame and PC
        else if (op == LEA)
        {
            ax = (int)(bp + *pc++);
        } // load address for arguments.

        // operadores, não precisa explicar
        // o primeiro valor está na pilha
        // e o segundo está em ax
        // após a operação, o resultado é salvo em ax
        else if (op == OR)
            ax = *sp++ | ax;
        else if (op == XOR)
            ax = *sp++ ^ ax;
        else if (op == AND)
            ax = *sp++ & ax;
        else if (op == EQ)
            ax = *sp++ == ax;
        else if (op == NE)
            ax = *sp++ != ax;
        else if (op == LT)
            ax = *sp++ < ax;
        else if (op == LE)
            ax = *sp++ <= ax;
        else if (op == GT)
            ax = *sp++ > ax;
        else if (op == GE)
            ax = *sp++ >= ax;
        else if (op == SHL)
            ax = *sp++ << ax;
        else if (op == SHR)
            ax = *sp++ >> ax;
        else if (op == ADD)
            ax = *sp++ + ax;
        else if (op == SUB)
            ax = *sp++ - ax;
        else if (op == MUL)
            ax = *sp++ * ax;
        else if (op == DIV)
            ax = *sp++ / ax;
        else if (op == MOD)
            ax = *sp++ % ax;

        // funções intrinsicas
        else if (op == EXIT)
        {
            printf("exit(%d)\n", *sp);
            return *sp;
        }
        else if (op == OPEN)
        {
            ax = open((char *)sp[1], sp[0]);
        }
        else if (op == CLOS)
        {
            ax = close(*sp);
        }
        else if (op == READ)
        {
            ax = read(sp[2], (char *)sp[1], *sp);
        }
        else if (op == PRTF)
        {
            tmp = sp + pc[1];
            ax = printf((char *)tmp[-1], tmp[-2], tmp[-3], tmp[-4], tmp[-5], tmp[-6]);
        }
        else if (op == MALC)
        {
            ax = (int)malloc(*sp);
        }
        else if (op == MSET)
        {
            ax = (int)memset((char *)sp[2], sp[1], *sp);
        }
        else if (op == MCMP)
        {
            ax = memcmp((char *)sp[2], (char *)sp[1], *sp);
        }
        else
        {
            printf("unknown instruction:%d\n", op);
            return -1;
        }
    }
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
    if (!(text = old_text = calloc(poolsize, sizeof(int))))
    {
        puts("could not allocate memory for text area.\n");
        return EXIT_FAILURE;
    }
    if (!(data = calloc(poolsize, sizeof(int))))
    {
        puts("could not allocate memory for data area.\n");
        return EXIT_FAILURE;
    }
    if (!(stack = calloc(poolsize, sizeof(int))))
    {
        puts("could not allocate memory for stack area.\n");
        return EXIT_FAILURE;
    }
    if (!(symbols = calloc(SYMBOLS_SIZE, 1)))
    {
        puts("could not allocate memory for symbol table.\n");
        return EXIT_FAILURE;
    }

    bp = sp = stack + poolsize - 1;
    ax = 0;

    // Simula o cálculo 10 + 20
    i = 0;
    text[i++] = IMM; // carrega o primeiro valor inteiro imediato para ax
    text[i++] = 10;

    text[i++] = PUSH; // coloca o valor imediato de AX na pilha

    text[i++] = IMM; // carrega o segundo valor inteiro imediato para ax
    text[i++] = 20;

    text[i++] = ADD; // ax = 10 + 20

    text[i++] = PUSH; // coloca o resultado na pilha

    text[i++] = EXIT; // sai do programa

    // next instruction to be run
    pc = text;

    program();
    return eval();

    puts("Pressione qualquer tecla para sair");
    getc(fd);
}