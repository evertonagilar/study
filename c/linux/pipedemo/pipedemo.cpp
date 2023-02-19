#include <cstdio>
#include <cstdlib>
#include <iostream>
#include <unistd.h>
#include <sys/wait.h>
#include <cstring>

int main(int argc, char *args[]) {
    char *texto;
    int pipeFd[2];
    char buffer[100];
    ssize_t bytesRead = 0;

    puts("Iniciando pipedemo");

    if (argc != 2 || strcmp(args[1], "--help") == 0){
        fprintf(stderr, "Uso: %s string.\n", args[0]);
        exit(EXIT_SUCCESS);
    }

    if (pipe(pipeFd) == -1){
        perror("Não foi possível criar pipe");
        exit(EXIT_FAILURE);
    }

    // texto que será enviado
    texto = args[1];

    switch (fork()){
        case -1:
            perror("Não foi possível criar processo filho");
            exit(EXIT_FAILURE);

        case 0: // filho
            puts("filho na área");
            // filho vai ler então fecha o fd de saída
            if (close(pipeFd[1]) == -1){
                perror("Não foi possível fechar saída no filho");
                exit(EXIT_FAILURE);
            };
            while (true) {
                bytesRead = read(pipeFd[0], buffer, sizeof(buffer));
                if (bytesRead == -1){
                    perror("Não foi possível receber dados do pai");
                    exit(EXIT_FAILURE);
                }
                if (bytesRead == 0){
                    break;
                }
                if (write(STDOUT_FILENO, buffer, bytesRead) == -1){
                    perror("Não foi possível escrever no terminal");
                    exit(EXIT_FAILURE);
                };
            }
            if (close(pipeFd[0]) == -1){
                perror("Não foi possível fechar entrada no filho");
                exit(EXIT_FAILURE);
            };
            _exit(EXIT_SUCCESS);
        default: // pai
            // pai vai somente enviar dados então fecha a entrada
            if (close(pipeFd[0]) == -1){
                perror("Não foi possível fechar entrada no pai");
                exit(EXIT_FAILURE);
            };
            printf("escrevendo %ld bytes\n", strlen(texto));
            if (write(pipeFd[1], texto, strlen(texto)) == -1){
                perror("Não foi possível enviar dados para o filho");
                exit(EXIT_FAILURE);
            }
            if (close(pipeFd[1]) == -1){
                perror("Não foi possível fechar saída no pai");
                exit(EXIT_FAILURE);
            }
            wait(NULL);
            exit(EXIT_SUCCESS);
    }
}
