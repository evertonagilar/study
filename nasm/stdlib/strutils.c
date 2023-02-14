#include <unistd.h>
#include <string.h>

extern int lee_strlen(char *str);

int main(int argc, char **args[]){
    char *msg = "Everton de Vargas Agilar\n";
    int tam = lee_strlen(msg);
    write(STDOUT_FILENO, msg, tam);
    _exit(1);
}