#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main() {
    // Argumentos para execv
    // Note o primeiro argumento
    // Note o último argumento precisa ser NULL
    char *ls_args[] = { "/usr/bin/primeiro", "-l", "-h", NULL };
    if (execv("/usr/bin/ls", ls_args) == -1){
        perror("Não foi possível executar o ls");
    }
    puts("Isto só será impresso de execv falhar!");
    return 0;
}
