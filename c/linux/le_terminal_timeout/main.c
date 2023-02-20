#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <signal.h>
#include <errno.h>

#define BUFFER_SIZE 100
char buffer[BUFFER_SIZE];
struct sigaction sa;

void alarmHandler(int sig){
    puts("Ocorreu timeout na leitura");
}

void configSignalAlarm(){
    sa.sa_flags = SA_RESTART;
    sigemptyset(&sa.sa_mask);
    sa.sa_handler = alarmHandler;
    if (sigaction(SIGALRM, &sa, NULL) == -1){
        perror("Não foi possível definir alarmSignal");
        exit(EXIT_FAILURE);
    }
}

int main() {
    printf("Program Lê Terminal com Timeout!\n");
    configSignalAlarm();
    alarm(3);
    ssize_t bytesRead = read(STDIN_FILENO, buffer, BUFFER_SIZE-1);
    if (errno == EINTR){
        puts("Ocorreu interrupção");
    }
    alarm(0); // desliga
    switch (bytesRead){
        case -1:
            perror("Ocorreu um erro ao ler dados");
            exit(EXIT_FAILURE);
        case 0:
            puts("Fim leitura");
            break;
        default:
            fprintf(stdout, "Você leu %ld caracteres: %s\n", bytesRead, buffer);
    }

    return EXIT_SUCCESS;
}
