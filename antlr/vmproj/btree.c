//
// Created by evertonagilar on 09/06/22.
//


#include <malloc.h>
#include "btree.h"

// ********************************** private functions **********************************

/*
 * Cria um novo node com m childrens
 *
 */
btree_node_t *create_btree_node(int m) {
    btree_node_t * node = malloc(sizeof (btree_node_t));
    node->m = m;
    return node;
}

/*
 *
 * Cria a btree
 *
 */
btree_t *create_btree(){
    btree_t * btree = malloc(sizeof (btree_t));
    btree->root = create_btree_node(0);
    btree->n = 0;
    btree->height = 0;
    return btree;
}

/*
 *
 *
 *
 */
btree_node_t *add_btree_node(btree_node_t *h, int key, int height){
    int i;
    for (i = 0; i < h->m; i++){
        if (key < h->children[i].key) break;
    }
    for (int j = h->m; j > i; j--){
        h->children[j] = h->children[j-1];
    }
    h->children[i].key = key;
    h->m++;
    return h;
}


// ********************************** public functions **********************************

bool *add_btree(btree_t *btree, int key){
    btree_node_t *node = add_btree_node(btree->root, key, btree->height);
    return node != NULL;
}

int main(int argc, char **argv) {
    puts("Programa teste btree\n");

    btree_t *btree = create_btree();
    bool inseriu;
    inseriu = add_btree(btree, 10);
    inseriu = add_btree(btree, 5);
    inseriu = add_btree(btree, 15);
    inseriu = add_btree(btree, 12);
    inseriu = add_btree(btree, 7);

    printf("Btree criado com %d elementos.", btree->height);

    return 0;
}

