#include <stdio.h>

int file_exists(const char * filename){
  FILE *arq;
  if ((arq = fopen(filename, "r") != NULL))
  {
	fclose(arq);
	return 1;
  }
  else 
	return 0;		
}


void printArquivo(const char * fileName){
  if (!file_exists(fileName)){
	printf("Arquivo %s nao existe.", fileName);
	exit(1);
  }
}

int main(int argc, char *args){
  if (argc == 0){
	puts("Arquivo %s nao encontrado.\n");
        exit(1);
  }

  int i;
  char nomeArq[250];
  for (i = 0; i < argc; i++){
	strcpy(nomeArq, args[i]);
//	printArquivo(&nomeArq);
  } 
}
