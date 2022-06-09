//
// Created by evertonagilar on 07/06/22.
//

#ifndef VMPROJ_BTREE_H
#define VMPROJ_BTREE_H

#include <stdbool.h>

#define MAX_CHILDREN_NODE 4

typedef struct {
    int key;
    struct btree_node_t *next;
} btree_node_entry;

typedef struct btree_node_t{
    int m;                                           // número de filhos
    btree_node_entry children[MAX_CHILDREN_NODE];    // array de childrens
} btree_node_t;

typedef struct {
    int n;                              // quantos elementos estão na btree
    int height;                         // altura da btree
    btree_node_t *root;                 // root da btree
} btree_t;


btree_t *create_btree();
bool *add_btree(btree_t *btree, int key);


#endif //VMPROJ_BTREE_H
