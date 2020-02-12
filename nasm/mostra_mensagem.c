#include <string.h>

extern int mostra_mensagem();

int main(){
    char* str = "Hello World\n";
    int len = strlen(str);
    mostra_mensagem(str, len);
    return 1;
}