//
// Created by agilar on 15/09/18.
//

#ifndef C_INTERPRETER_CI_BTREE_H
#define C_INTERPRETER_CI_BTREE_H

#include <stddef.h>
#include <stdbool.h>

struct ci_btree_node {
    struct ci_btree_node *left;
    struct ci_btree_node *right;
    size_t size;
    char data[];
};



typedef struct ci_btree_node  ci_btree_node_t;


// Função para obter um key que corresponde aos dados
typedef const void *ci_btree_get_key_func_t(const void *data);


// Função para comparar keys
typedef int ci_btree_cmp_func_t(const void *pKey1, const void *pKey2);

typedef struct {
    ci_btree_node_t *pRoot;
    ci_btree_cmp_func_t *cmpFunc;
    ci_btree_get_key_func_t  *getKeyFunc;
} ci_btree_t;


// Função padrão para retornar um key para um data
// Retorna o data como key
void *ci_btree_default_key_func(const void *pData);


// Cria uma nova btree
// cmpFunc      -> função para comparação
// getKeyFunc   -> retorna a key para um data
ci_btree_t *ci_btree_new(ci_btree_cmp_func_t *cmpFunc, ci_btree_get_key_func_t *getKeyFunc);


// Adiciona um novo item
bool ci_btree_insert(ci_btree_t *btree, const void *pData, size_t size);




#endif //C_INTERPRETER_CI_BTREE_H
