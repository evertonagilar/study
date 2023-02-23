#include <stdio.h>

/* Type your code here, or load an example. */
void exibeMensagem(char *mensagem) {
    printf("%s\n", mensagem);
}

void main(void){
    char *msg = "Boa noite galera!AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
    exibeMensagem(msg);
}