#include <stdio.h>

int main(int argc, char *args[]) {
    char comando[256] = "ls";
    FILE *fp;
    char c = 0;
    // Abre um pipe do ls para leitura
    fp = popen(comando, "r");

    // Filtra e imprime na tela somente as extensões
    while ((c = fgetc(fp)) != EOF) {
        if (c == '.'){
            do {
                fputc(c, stdout);
                c = fgetc(fp);
            } while (c != '\n' && c != EOF);
            putchar('\n');
        }
    };

    pclose(fp);
    return 0;
}
