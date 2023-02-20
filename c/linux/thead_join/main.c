#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <stdbool.h>
#include <unistd.h>

#define MAX_PESSOAS 5

typedef struct {
    char nome[10];
    pthread_t id;
    pthread_attr_t attr;
    char textoFalar[100];
} alguem_t;

int thread_func(alguem_t *alguem) {
    printf("%s: %s\n", alguem->nome, alguem->textoFalar);
    sleep(2);
    return EXIT_SUCCESS;
}

bool alguemChegou(alguem_t *alguem) {
    int ret = pthread_create(&alguem->id, &alguem->attr, (void *(*)(void *)) thread_func, alguem);
    if (ret > 0) {
        printf("Ocorreu um erro ao entrar %s\n", alguem->nome);
        return false;
    } else {
        printf("\nEntrou na conversa: %s\n", alguem->nome);
        return true;
    }
}

void aguarda(alguem_t *alguem) {
    if (pthread_join(alguem->id, NULL) != 0) {
        printf("Ocorreu um erro ao aguardar %s\n", alguem->nome);
    }else{
        printf("Saiu: %s\n", alguem->nome);
    }
}


int main() {
    alguem_t p1 = {.nome = "joão", .textoFalar = "Quem é você?"};
    alguem_t p2 = {.nome = "maria", .textoFalar = "Eu sou o maria"};
    alguem_t p3 = {.nome = "felipe", .textoFalar = "Alguém no grupo?"};
    alguem_t p4 = {.nome = "luis", .textoFalar = "Preciso de ajuda, você pode me ajudar joão!"};
    alguem_t p5 = {.nome = "rafael", .textoFalar = "Olá meus amigos, espero que todos estejam bem!"};

    alguem_t *pessoas[MAX_PESSOAS] = {&p1, &p2, &p3, &p4, &p5};

    for (int i = 0; i < MAX_PESSOAS; i++) {
        alguem_t *p = pessoas[i];
        alguemChegou(p);
    }

    for (int i = 0; i < MAX_PESSOAS; i++) {
        alguem_t *p = pessoas[i];
        aguarda(p);
    }

    printf("\nFinalizando programa!\n");
    return 0;
}
