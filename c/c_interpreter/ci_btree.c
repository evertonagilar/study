//
// Created by agilar on 15/09/18.
//

#include <stdlib.h>
#include <string.h>
#include "ci_btree.h"


void *ci_btree_default_key_func(const void *pData) {
    return pData;
}


ci_btree_t *ci_btree_new(ci_btree_cmp_func_t *cmpFunc, ci_btree_get_key_func_t *getKeyFunc) {
    if (cmpFunc == NULL){
        return NULL;
    }
    ci_btree_t *btree = malloc(sizeof(ci_btree_t));
    if (!btree){
        btree->pRoot = NULL;
        btree->cmpFunc = cmpFunc;
        btree->getKeyFunc = getKeyFunc == NULL ?  ci_btree_default_key_func : getKeyFunc;
    }
    return btree;
}


// Função auxiliar para inserir
static bool ci_btree_insert2(ci_btree_t *btree, ci_btree_node_t **ppNode, const void *pData, size_t size) {
    ci_btree_node_t *pNode = *ppNode;
    if (pNode == NULL){
        pNode = malloc(sizeof(ci_btree_node_t) + size);
        if (pNode != NULL){
            pNode->left = pNode->right = NULL;
            memcpy(pNode->data, pData, size);
            *ppNode = pNode;
        }else{
            return false;
        }
    }else{
        const void *pKey1 = btree->getKeyFunc(pData),
                   *pKey2 = btree->getKeyFunc(pNode->data);
        if (btree->cmpFunc(pKey1, pKey2) < 0){
            return ci_btree_insert2(btree, &pNode->left, pData, size);
        }else{
            return ci_btree_insert2(btree, &pNode->right, pData, size);
        }
    }
}




bool ci_btree_insert(ci_btree_t *btree, const void *pData, size_t size) {
    if (btree == NULL || pData == NULL || size == 0) {
        return false;
    } else {
        ci_btree_insert2(btree, &(btree->pRoot), pData, size);
    }
}
