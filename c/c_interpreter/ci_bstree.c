//
// Created by agilar on 15/09/18.
//

#include <stdlib.h>
#include <string.h>
#include "ci_bstree.h"

// Private functions

static bool ci_bstree_insert2(ci_bstree_t *bstree, ci_bstree_node_t **ppNode, const void *pData, size_t size);
static const void *ci_bstree_search2(const ci_bstree_t *bstree, const ci_bstree_node_t *pNode, const void *key);


// Helper functions

void *ci_bstree_default_key_func(const void *pData) {
    return pData;
}


// Implementation

ci_bstree_t *ci_bstree_new(ci_bstree_cmp_func_t *cmpFunc, ci_bstree_compute_key_func_t *getKeyFunc) {
    if (cmpFunc == NULL){
        return NULL;
    }
    ci_bstree_t *bstree = malloc(sizeof(ci_bstree_t));
    if (!bstree){
        bstree->pRoot = NULL;
        bstree->cmp = cmpFunc;
        bstree->compute_key = getKeyFunc == NULL ?  ci_bstree_default_key_func : getKeyFunc;
    }
    return bstree;
}


bool ci_bstree_insert(ci_bstree_t *bstree, const void *pData, size_t size) {
    if (bstree == NULL || pData == NULL || size == 0) {
        return false;
    } else {
        ci_bstree_insert2(bstree, &(bstree->pRoot), pData, size);
    }
}

const void *ci_bstree_search(const ci_bstree_t *bstree, const void *key){
    if (bstree == NULL || key == NULL){
        return NULL;
    }
    return ci_bstree_search2(bstree, bstree->pRoot, key);
}


// private functions

static bool ci_bstree_insert2(ci_bstree_t *bstree, ci_bstree_node_t **ppNode, const void *pData, size_t size) {
    ci_bstree_node_t *pNode = *ppNode;
    if (pNode == NULL){
        pNode = malloc(sizeof(ci_bstree_node_t) + size);
        if (pNode != NULL){
            pNode->left = pNode->right = NULL;
            memcpy(pNode->data, pData, size);
            *ppNode = pNode;
        }else{
            return false;
        }
    }else{
        const void *pKey1 = bstree->compute_key(pData),
                *pKey2 = bstree->compute_key(pNode->data);
        if (bstree->cmp(pKey1, pKey2) < 0){
            return ci_bstree_insert2(bstree, &pNode->left, pData, size);
        }else{
            return ci_bstree_insert2(bstree, &pNode->right, pData, size);
        }
    }
}


static const void *ci_bstree_search2(const ci_bstree_t *bstree, const ci_bstree_node_t *pNode, const void *key) {
    if (pNode == NULL){
        return NULL;
    }
    const void *key2 = bstree->compute_key(pNode->data);
    int cmp_result = bstree->cmp(key, key2);
    if (cmp_result == 0){
        return pNode->data;
    }else if (cmp_result < 0){
        return ci_bstree_search2(bstree, pNode->left, key);
    }else{
        return ci_bstree_search2(bstree, pNode->right, key);
    }
}

