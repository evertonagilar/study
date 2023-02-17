//#include <unistd.h>
#include <stdio.h>
#include <string.h>

extern int lee_strlen(char *str);
extern int strcpy_asm_x64(char *str);
extern int lee_print(char *str);
extern int lee_exit(int status);
extern char* lee_strcpy(char *destination, char *source);


int main(int argc, char *args[]){
    char origem[] = "java";
    char destino[15];
    strcpy(destino, "delphi");
    int tamOrigem = strlen(origem);
    int tamOrigem3 = strcpy_asm_x64(origem);
    int tamOrigem2 = lee_strlen(origem);

    puts(origem);
    lee_print(origem);
    //lee_strcpy(destino, origem);
    //lee_print(destino);


    return 0;
}