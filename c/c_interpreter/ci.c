#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <string.h>
#include <unistd.h>
#include "utils.c"

int token;              // current token
char *src, *old_src;    // pointer to source code
int poolsize;           // default size of text/data/stack
int line;               // line number

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