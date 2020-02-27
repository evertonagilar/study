//
// Created by agilar on 24/02/2020.
//

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <ctype.h>
#include "database.h"
#include "utils.h"

char *brnix = "brnix";
size_t brnix_sz = 5;
char *str_invalid_datafile = "Arquivo corrompido.";

database_t *open_database(char *name) {
    database_t *new_db = bx_malloc(sizeof(database_t));
    new_db->name = bx_malloc(strlen(name));
    strcpy(new_db->name, name);
    new_db->fd = fopen(name, "r+b");
    if (!new_db->fd){
        perror("Não foi possível abrir banco de dados.");
        exit(EXIT_FAILURE);
    }

    // Se o arquivo está vazio, significa que foi criado e precisamos salvar a estrutura em disco
    if (bx_filesize(new_db->fd) == 0){
        write_database(new_db);
    }else{
        read_database(new_db);
    }
    return new_db;
}


void read_database(database_t *database){
    FILE *fd = database->fd;
    char *buffer = bx_malloc(1024);
    char *pBuffer = buffer;
    int bytes_read;

    fseek(fd, 0, SEEK_SET);

    // Lê os primeiros bytes e verifica se eh um datafile
    bytes_read = fread(buffer, sizeof(char), brnix_sz, fd);
    if (bytes_read > 0){
        if (strncmp(buffer, brnix, brnix_sz) != 0){
            perror("Arquivo não é um banco de dados válido.");
        }

        size_t db_name_sz;
        bytes_read = fread(&db_name_sz, sizeof(size_t), 1, fd);
        if (bytes_read > 0){
            if (fread(buffer, sizeof(char), db_name_sz, fd) > 0){
                if (strncmp(buffer, database->name, db_name_sz) != 0){
                    perror(str_invalid_datafile);
                }
            };
        }else{
            perror(str_invalid_datafile);
        }
    }else{
        perror(str_invalid_datafile);
    }
}

void write_database(database_t *database){
    FILE *fd = database->fd;
    char *buffer = bx_malloc(1024);
    size_t buffer_len;
    char *pBuffer = buffer;

    // os primeiros bytes é a marca dáqua que indica o formato do arquivo
    memcpy(pBuffer, brnix, brnix_sz);
    pBuffer += brnix_sz;

    // escreve o nome do banco de dados
    // primeiro o tamanho, depois a string
    size_t db_name_sz = strlen(database->name);
    memcpy(pBuffer, &db_name_sz, sizeof(size_t));
    pBuffer += sizeof(size_t);
    memcpy(pBuffer, database->name, db_name_sz);
    pBuffer += db_name_sz;

    // calcula tamanho do buffer para saber quantos bytes devem ser escritos
    buffer_len = pBuffer - buffer;

    fwrite(buffer, sizeof(char), buffer_len, fd);
    fflush(fd);
    free(buffer);
}

void stat_database(database_t *database){
    puts("Database info");
    puts("--------------------------------------------------");
    printf("name: %s\n", database->name);
    puts("--------------------------------------------------");

}




