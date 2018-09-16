//
// Created by agilar on 15/09/18.
//

#include <stdlib.h>
#include <string.h>
#include "ci_btree.h"

// Private functions

static bool ci_btree_insert2(ci_btree_t *btree, ci_btree_node_t **ppNode, const void *pData, size_t size);
static const void *ci_btree_search2(const ci_btree_t *btree, const ci_btree_node_t *pNode, const void *key);


// Helper functions

void *ci_btree_default_key_func(const void *pData) {
    return pData;
}


// Implementation

ci_btree_t *ci_btree_new(ci_btree_cmp_func_t *cmpFunc, ci_btree_compute_key_func_t *getKeyFunc) {
    if (cmpFunc == NULL){
        return NULL;
    }
    ci_btree_t *btree = malloc(sizeof(ci_btree_t));
    if (!btree){
        btree->pRoot = NULL;
        btree->cmp = cmpFunc;
        btree->compute_key = getKeyFunc == NULL ?  ci_btree_default_key_func : getKeyFunc;
    }
    return btree;
}


bool ci_btree_insert(ci_btree_t *btree, const void *pData, size_t size) {
    if (btree == NULL || pData == NULL || size == 0) {
        return false;
    } else {
        ci_btree_insert2(btree, &(btree->pRoot), pData, size);
    }
}

const void *ci_btree_search(const ci_btree_t *btree, const void *key){
    if (btree == NULL || key == NULL){
        return NULL;
    }
    return ci_btree_search2(btree, btree->pRoot, key);
}


// private functions

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
        const void *pKey1 = btree->compute_key(pData),
                *pKey2 = btree->compute_key(pNode->data);
        if (btree->cmp(pKey1, pKey2) < 0){
            return ci_btree_insert2(btree, &pNode->left, pData, size);
        }else{
            return ci_btree_insert2(btree, &pNode->right, pData, size);
        }
    }
}


static const void *ci_btree_search2(const ci_btree_t *btree, const ci_btree_node_t *pNode, const void *key) {
    if (pNode == NULL){
        return NULL;
    }
    const void *key2 = btree->compute_key(pNode->data);
    int cmp_result = btree->cmp(key, key2);
    if (cmp_result == 0){
        return pNode->data;
    }else if (cmp_result < 0){
        return ci_btree_search2(btree, pNode->left, key);
    }else{
        return ci_btree_search2(btree, pNode->right, key);
    }
}

