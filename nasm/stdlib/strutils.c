//#include <unistd.h>
#include <stdio.h>

extern int lee_strlen(char *str);
extern int lee_print(char *str);
extern int lee_exit(int status);
extern char* lee_strcpy(char *destination, char *source);


int main(int argc, char *args[]){
    char origem[] = "teste\n\0";
    char destino[100];
    int tamOrigem = lee_strlen(origem);

    puts(origem);
    lee_print(origem);
    //lee_strcpy(destino, origem);
    //lee_print(destino);


    return 0;
}