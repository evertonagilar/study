#include <stdio.h>

int main() {
    char c = 0;
    int contador_c = 0;
    int contador_d = 0;
    while (c != EOF){
        c = getchar();
        if (c == 'c'){
            contador_c++;
        } else if (c == 'd'){
            contador_d++;
        }
    }
    printf("Você digitou %d letras c\n", contador_c);
    printf("Você digitou %d letras d\n", contador_d);
    return 0;
}
