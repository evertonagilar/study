//
// Created by agilar on 24/02/2020.
//

#ifndef MINIDB_DATABASE_H
#define MINIDB_DATABASE_H

typedef struct _database {
    char* name;
    FILE *fd;
} database_t;

database_t *open_database(char *name);
void read_database(database_t *database);
void write_database(database_t *database);
void stat_database(database_t *database);
void database_to_buffer(database_t *database, char **buffer, size_t *buffer_len);


#endif //MINIDB_DATABASE_H
