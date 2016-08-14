#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>

void parse_file(FILE *fin){
	fseek(fin, 0, SEEK_END);
	int size_file = ftell(fin);
	fseek(fin, SEEK_SET, 0);
	int size_buffer = sizeof(char) * size_file +1;
	char *buffer = malloc(size_buffer);
	fread(buffer, size_buffer, 1, fin);
	printf("File content: %s", buffer);
	printf("File size: %d\n", size_buffer);
	free(buffer);
}

int main(int argc, char **args){
	if (argc < 2){
		puts("Informe o nome do arquivo!");
	}
	
	char *filename = args[1];
	printf("Nome do arquivo: %s\n", filename);
	
	FILE *fin = fopen(filename, "r");
	if (!fin){
		printf("Erro: %s!\n", strerror(errno));
		return 1;
	}
	
	parse_file(fin);
	fclose(fin);
}


