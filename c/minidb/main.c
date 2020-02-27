#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "database.h"

int main(int argc, char **args) {
    if (argc != 2){
        printf("minidb [dbname]");
        exit(EXIT_FAILURE);
    }
    args++;

    printf("Mini database instance\n");

    char *name = *args;
    database_t *db = open_database(name);

    stat_database(db);

    puts("\nfim do programa");
    return 0;
}
