#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <signal.h>
#include <sys/wait.h>
#include <stdbool.h>
#include <sys/mman.h>
#include <limits.h>

pid_t filho;
int *pValorComputado;  // memória compartilhada com mmap

void signalHandler(int sig){
    switch (sig) {
        case SIGTERM:
            printf("Filho recebeu signal: %d\n", sig);
            exit(1);
        default:
            printf("Filho recebeu signal não tratado: %d\n", sig);
    }
}

void rotinaFilho() {
    bool terminei = false;
    *pValorComputado = 0;
    puts("Rotina filho executando");
    signal(SIGTERM, signalHandler);
    while (true){
        terminei = !terminei;
        printf("Valor computado incrementado: %d\n", *pValorComputado);
        *pValorComputado = *pValorComputado + 1;
        if (*pValorComputado == 1000){
            break;
        }
    }
    exit(terminei);
}

void rotinaPai(){
    puts("Rotina pai executando");
    sleep(1);
    kill(filho, SIGTERM);
    int wstatus;
    int ret;
    waitpid(filho, &wstatus, 0);

    if (WIFEXITED(wstatus)) {
        ret = WEXITSTATUS(wstatus);
    } else if (WIFSIGNALED(wstatus)) {
        ret = WTERMSIG(wstatus);
    } else if (WIFSTOPPED(wstatus)) {
        ret = WSTOPSIG(wstatus);
    } else if (WIFCONTINUED(wstatus)) {
        ret = 0;
    }
    printf("Pai encerra. Filho ret: %d  valorComputado: %d\n", ret, *pValorComputado);
    pause();
    exit(EXIT_SUCCESS);
}

int main() {
    printf("Programa pai executando!\n");
    int protecao = PROT_READ | PROT_WRITE;
    int visibilidade = MAP_SHARED | MAP_ANON;
    pValorComputado = (int*) mmap(NULL, sizeof(int), protecao, visibilidade, 0, 0);
    if (pValorComputado == -1){
        perror("Não foi possível criar memória compartilhada");
        exit(EXIT_FAILURE);
    }
    filho = fork();
    switch (filho){
        case -1:
            perror("Ocorreu um erro ao criar filho");
            exit(EXIT_FAILURE);
        case 0:
            rotinaFilho();
            break;
        default:
            rotinaPai();
            break;
    }
    return EXIT_SUCCESS;
}
