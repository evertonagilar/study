//
// Created by agilar on 15/09/18.
//

#ifndef CI_BSTREE_H
#define CI_BSTREE_H

#include <stddef.h>
#include <stdbool.h>

// Um nó da árvore de pesquisa binária
struct ci_bstree_node {
    struct ci_bstree_node *left;
    struct ci_bstree_node *right;
    size_t size;
    char data[];
};

typedef struct ci_bstree_node  ci_bstree_node_t;

// Tipo para função para obter um key que corresponde aos dados
typedef const void *ci_bstree_compute_key_func_t(const void *data);

// Tipo para função para comparar keys
typedef int ci_bstree_cmp_func_t(const void *pKey1, const void *pKey2);

// Estrutura principal da árvore de pesquisa binária
typedef struct {
    ci_bstree_node_t *pRoot;
    ci_bstree_cmp_func_t *cmp;
    ci_bstree_compute_key_func_t  *compute_key;
} ci_bstree_t;

// Função padrão para retornar um key para um data
// Retorna o data como key
const void *ci_bstree_default_key_func(const void *pData);

// Cria uma nova bstree
// cmp      -> função para comparação
// compute_key   -> retorna a key para um data
ci_bstree_t *ci_bstree_new(ci_bstree_cmp_func_t *cmpFunc, ci_bstree_compute_key_func_t *getKeyFunc);

// Adiciona um novo item
bool ci_bstree_insert(ci_bstree_t *bstree, const void *pData, size_t size);

// Pesquisa um item
const void *ci_bstree_search(const ci_bstree_t *bstree, const void *key);

// Remove um item que possui a key
// Algoritmo utilizado:
//    1) Percore a árvore e localiza o node com a key
//    2) Encontrando o node, verifica se este node tem filhos
//    3) não tendo nenhum filho, apenas remove o node
//    4) Se tiver apenas 1 filho, este filho liga-se ao node parent do node sendo removido
//    5) se tiver dois filhos, localiza o filho com menor key e liga ao node parent
//
bool ci_bstree_remove(const ci_bstree_t *bstree, const void *key);




#endif //CI_BSTREE_H
