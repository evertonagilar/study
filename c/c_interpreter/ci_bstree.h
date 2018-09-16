//
// Created by agilar on 15/09/18.
//

#ifndef C_INTERPRETER_CI_bstree_H
#define C_INTERPRETER_CI_bstree_H

#include <stddef.h>
#include <stdbool.h>

struct ci_bstree_node {
    struct ci_bstree_node *left;
    struct ci_bstree_node *right;
    size_t size;
    char data[];
};



typedef struct ci_bstree_node  ci_bstree_node_t;


// Função para obter um key que corresponde aos dados
typedef const void *ci_bstree_compute_key_func_t(const void *data);


// Função para comparar keys
typedef int ci_bstree_cmp_func_t(const void *pKey1, const void *pKey2);

typedef struct {
    ci_bstree_node_t *pRoot;
    ci_bstree_cmp_func_t *cmp;
    ci_bstree_compute_key_func_t  *compute_key;
} ci_bstree_t;


// Função padrão para retornar um key para um data
// Retorna o data como key
void *ci_bstree_default_key_func(const void *pData);


// Cria uma nova bstree
// cmp      -> função para comparação
// compute_key   -> retorna a key para um data
ci_bstree_t *ci_bstree_new(ci_bstree_cmp_func_t *cmpFunc, ci_bstree_compute_key_func_t *getKeyFunc);


// Adiciona um novo item
bool ci_bstree_insert(ci_bstree_t *bstree, const void *pData, size_t size);


// Search item
const void *ci_bstree_search(const ci_bstree_t *bstree, const void *key);





#endif //C_INTERPRETER_CI_bstree_H
