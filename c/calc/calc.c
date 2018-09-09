#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <strings.h>

enum {tkNum};

char src[80];
int token;
int token_val;
char *lookahead;


/*

    <expr>      ::= <term> <expr_tail>

    <expr_tail> ::= + <term> <expr_tail>
                  | - <term> <expr_tail>
                  | <empty> 

    <term>      ::= <factor> <term_tail>

    <term_tail> ::= * <factor> <term_tail>
                  | / <factor> <term_tail>
                  | <empty>

    <factor>    ::= ( <expr> )
                  | tkNum
*/

void match(int tk){
    if (token != tk){
        printf("Token esperado: %d mas obtido %d em vez disso\n", token, tk);
        exit(EXIT_FAILURE);
    }
    next();
}

int factor(){
    int value = 0;
    if (token == '('){
        match('(');
        value = expr();
        match(')');
    }else{
        value = token_val;
        match(tkNum);
    }
    return value;
}

int term_tail(int lvalue){
    if (token == '*'){
        match('*');
        int value = lvalue * factor();
        return term_tail(value);
    }else if (token == '/'){
        match('/');
        int value = lvalue / factor();
        return term_tail(value);
    }else{
        return lvalue;
    }
}

int term(){
    int lvalue = factor();
    return term_tail(lvalue);
}

expr_tail(int lvalue){
    if (token == '+'){
        match('+');
        int value = lvalue + term();
        return expr_tail(value);
    }else if (token == '-'){
        match('-');
        int value = lvalue - term();
        return expr_tail(value);
    }else{
        return lvalue;
    }
}

int expr(){
    int lvalue = term();
    return expr_tail(lvalue);
}



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
    next();
    return expr();
}

int main(int argc, char **argv){
    printf("Minha calculadora\n");
    while (1) {
        printf("\nEntre com uma expressão (pressione EXIT para sair):\n");
        memset(src, 0, sizeof(src));
        scanf("%s", src);
        if (!strcasecmp(src, "exit")){
            exit(EXIT_SUCCESS);
        }
        lookahead = src;
        printf("Result: %d\n", eval());
    };
    return EXIT_SUCCESS;
}