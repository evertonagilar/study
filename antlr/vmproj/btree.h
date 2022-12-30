//
// Created by evertonagilar on 07/06/22.
//

#ifndef VMPROJ_BTREE_H
#define VMPROJ_BTREE_H

#include <stdbool.h>

#define ORDER 4

typedef struct {
    int key;
    void *value;
} btree_key_entry;


typedef struct {
    int m;                                       // número de filhos da página
    bool is_leaf;                                // indica se a página é uma folha
    btree_key_entry *keys[ORDER];                // array de keys entries
    struct btree_page_t *children[ORDER-1];
} btree_page_t;

typedef struct {
    int n;                              // quantos elementos estão na btree
    int height;                         // altura da btree
    btree_page_t *root;                 // root da btree
} btree_t;

typedef struct {
    btree_page_t *left;
    btree_page_t *right;
    btree_key_entry *key_do_meio;
} btree_page_split_t;

btree_t *btree_new();
bool btree_insert(btree_t *btree, int key);


#endif //VMPROJ_BTREE_H
