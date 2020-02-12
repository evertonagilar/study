#include <stdio.h>

void __attribute__((constructor)) iniciando(void)
{
    printf("Constructor called!\n");
}

void __attribute__((destructor)) finalizando(void)
{
    printf("Destructor called!\n");
}


int main()
{
    printf("Ola Everton\n");
}