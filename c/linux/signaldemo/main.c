#include <stdio.h>
#include <signal.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdbool.h>
#include <stdarg.h>

static int SIGINT_count = 0;
pid_t meupid;

void signalHandler(int signal){
    switch (signal){
        case SIGINT:
            SIGINT_count++;
            printf("\tSinal SIGINT recebido, haha!\n");
            if (SIGINT_count == 2){
                printf("\tSinal SIGTERM recebido novamente, fechando graciosamente!\n");
                exit(EXIT_SUCCESS);
            }
            break;
        case SIGQUIT:
            printf("\tSinal SIGQUIT recebido, snif!\n");
            exit(EXIT_FAILURE);
        case SIGTERM:
            printf("\tSinal SIGTERM recebido, fechando graciosamente!\n");
            exit(EXIT_SUCCESS);
        case SIGTSTP:
            printf("\tDescansar um pouco!\n");
            pause();
            break;
        case SIGCONT:
            printf("\tVoltando a trabalhar!\n");
            break;
    }
}

void registraSignals(int argc, ...){
    va_list listaSignals;
    va_start(listaSignals, argc);
    for (int i = 0; i < argc; i++){
        int sig = va_arg(listaSignals, int);
        if (signal(sig, signalHandler) == SIG_ERR){
            perror("Não foi possível registrar o signal");
            exit(EXIT_FAILURE);
        }
    }
    va_end(listaSignals);
}

int main() {
    meupid = getpid();
    printf("Programa signals  < PID: %d >\n", meupid);
    registraSignals(5, SIGINT, SIGQUIT, SIGTERM, SIGTSTP, SIGCONT);
    while (true){
        puts("Working!!!");
        sleep(1);
    }
    return 0;
}
