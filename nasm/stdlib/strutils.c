//#include <unistd.h>

extern int lee_strlen(char *str);
extern int lee_print(char *str);
extern int lee_exit(int status);
extern char* lee_strcpy(char *destination, char *source);


int main(int argc, char **args[]){
    char *msg = "Programa usando strutils!\n";
    lee_print(msg);

    char destino[100];
    lee_strcpy(destino, msg);
    lee_print(destino);



    return 0;
}