#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>

int main(){
	ssize_t bytes_lidos;
	size_t tamanho_linha = 5;
	char *linha;

	printf("Programa lê linha com getline\n");

	linha = malloc(tamanho_linha);
	if (linha == NULL){
		perror("Não foi possível alocar memória.");
		exit(EXIT_FAILURE);
	}

	while ((bytes_lidos = getline(&linha, &tamanho_linha, stdin)) != -1){
		if (linha[0] == '\n') {
			puts("Enter!");
			break;
		}
		printf("Texto que vc escreveu (%ld caracteres): %s\n", bytes_lidos, linha);
	}

	free(linha);
	return EXIT_SUCCESS;
}
