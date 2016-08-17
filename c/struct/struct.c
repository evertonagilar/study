#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
	short version;
	char author[120];
	char charset[80]; 
} database_t;


void write_database(char *database_name){
	printf("Criando estrutura do banco %s\n", database_name);
	database_t db = {1, "Everton Agilar", "UTF-8"};
	FILE *db_in = fopen(database_name, "w");
	fwrite(&db, sizeof(database_t), 1, db_in);
	fclose(db_in);
}	

void read_database(char *database_name){
	printf("Lendo estrutura do banco %s\n", database_name);
	database_t db;
	FILE *db_out = fopen(database_name, "r");
	fread(&db, sizeof(database_t), 1, db_out);
	printf("version: %i\nauthor:%s\ncharset:%s\n", db.version, db.author, db.charset);
	fclose(db_out);
}	


int main(int argc, char *argv[]){
	if (argc < 3){
		printf("Informe o nome do arquivo para salvar a estrutura do banco\n");
		exit(1);
	}
	
	char *database_name = argv[1];
	char *opcao	= argv[2]; // read or write
	
	if (strcmp(opcao, "read") == 0){
		read_database(database_name);
	}else if (strcmp(opcao, "write") == 0){
		write_database(database_name);
	}



	
	
	
}
