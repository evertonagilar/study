#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <strings.h>

enum {tkNum};

char src[80];
int token;
int token_val;
char *lookahead;

// retorna o próximo token
void next(){
    // pula espaços em branco e tabulações
    while (*lookahead == ' ' || *lookahead == '\t'){
        lookahead++;
    }

    // pega o token atual
    token = *lookahead++;

    // se eh um número, vamos fazer o parser
    if (token >= '0' && token <= '9'){
        token_val = token - '0';
        token = tkNum;
        while (*lookahead >= '0' && *lookahead <= '9'){
            token_val = token_val*10 + *lookahead - '0';
            lookahead++;
        }
    }
    return;
}

int eval(){
    while (*lookahead){
        next();
        if (token == tkNum){
            printf("token: %d\n", token_val);
        }else{
            printf("token: %c\n", token);
        }
    }
    
    return 1;
}

int main(int argc, char **argv){
    printf("Minha calculadora\n");
    while (1) {
        printf("\nEntre com uma expressão (pressione EXIT para sair):\n");
        memset(src, 0, sizeof(src));
        scanf("%s", src);
        if (!strcasecmp(src, "exit")){
            exit(0);
        }
        lookahead = src;
        printf("Result: %d\n", eval());
    };
    return 0;
}