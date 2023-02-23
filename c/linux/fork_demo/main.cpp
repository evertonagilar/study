#include <iostream>
#include <unistd.h>
#include <wait.h>

/*
 *
 * Esse programa demonstra que após o fork o processo pai e o filho estão em
 * espaço de memória diferentes e não compartilham nada.
 *
 *
 */

// .data
int c = 30;

int main() {
    // variável na pilha
    int a = 10;

    // variável no heap
    int *b = (int *) malloc(sizeof(int));
    *b = 15;

    pid_t pid = fork();

    if (pid == 0){
        // ------------ filho ------------------
        puts("Filho -> Antes:");
        printf("Filho -> Variável a: %d   endereco: %p\n", a, &a);
        printf("Filho -> Variável b: %d   endereco: %p\n", *b, b);
        printf("Filho -> Variável c: %d   endereco: %p\n", c, &c);
        puts("Filho -> Depois:");
        a = 11;
        *b = 16;
        c = 31;
        printf("Filho -> Variável a: %d   endereco: %p\n", a, &a);
        printf("Filho -> Variável b: %d   endereco: %p\n", *b, b);
        printf("Filho -> Variável c: %d   endereco: %p\n", c, &c);

        puts("Filho termino\n");
        exit(EXIT_SUCCESS);
    }else{
        // ------------ pai --------------

        // dá tempo para filho executar
        sleep(2);

        puts("Pai -> antes wait");
        printf("Pai -> Variável a: %d   endereco: %p\n", a, &a);
        printf("Pai -> Variável b: %d   endereco: %p\n", *b, b);
        printf("Pai -> Variável c: %d   endereco: %p\n", c, &c);

        waitpid(pid, NULL, 0);

        puts("Pai -> após wait");
        printf("Pai -> Variável a: %d   endereco: %p\n", a, &a);
        printf("Pai -> Variável b: %d   endereco: %p\n", *b, b);
        printf("Pai -> Variável c: %d   endereco: %p\n", c, &c);

        puts("Pai termino\n");
        exit(EXIT_SUCCESS);
    }
}
