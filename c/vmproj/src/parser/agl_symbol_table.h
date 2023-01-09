//
// Created by evertonagilar on 06/01/23.
//

#ifndef VMPROJ_AGL_SYMBOL_TABLE_H
#define VMPROJ_AGL_SYMBOL_TABLE_H

enum agl_identifier_type_t { id, ifsmnt, whilesmnt, forsmnt };

typedef struct {
    enum agl_identifier_type_t type;
    int hash;
    char *value;
} agl_identifier_t;


typedef struct {
    int size;
    agl_identifier_t *itens;
} agl_symbol_table_t;


agl_identifier_t *agl_identifier_create();
void agl_identifier_free(agl_identifier_t *id);

agl_symbol_table_t *agl_symbol_table_create();
void agl_symbol_table_free(agl_symbol_table_t *table);
void agl_symbol_table_push(agl_symbol_table_t *table, agl_identifier_t *id);
agl_identifier_t * agl_symbol_table_get(agl_symbol_table_t *table, char *identifier, int identifier_sz);


#endif //VMPROJ_AGL_SYMBOL_TABLE_H
