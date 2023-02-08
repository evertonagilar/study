/*
 * %CopyrightBegin%
 *
 * Copyright Everton de Vargas Agilar 2022. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * %CopyrightEnd%
 */


#include "lee_binary_tree.h"
#include <stdbool.h>

/* lee_binary_tree */

lee_binary_tree_t *lee_binary_tree_create(){
    lee_binary_tree_t *tree = malloc(sizeof(lee_binary_tree_t));
    tree->root = NULL;
    return tree;
}


lee_binary_tree_node_t *lee_binary_tree_create_node(int key){
    lee_binary_tree_node_t *node = malloc(sizeof(lee_binary_tree_node_t));
    node->key = key;
    node->left = NULL;
    node->right = NULL;
    return node;
}

void lee_binary_tree_push(lee_binary_tree_t *tree, int key) {
    lee_binary_tree_node_t *node = lee_binary_tree_create_node(key);
    if (tree->root == NULL) {
        tree->root = node;
        return;
    }
    lee_binary_tree_node_t *current = tree->root;
    while (true) {
        lee_binary_tree_node_t *parent = current;
        if (key < current->key) {
            current = current->left;
            if (current == NULL){
                parent->left = node;
                return;
            }
        } else if (key > current->key) {
            current = current->right;
            if (current == NULL){
                parent->right = node;
                return;
            }
        }
    }
}

lee_binary_tree_node_t *lee_binary_tree_find(lee_binary_tree_t *tree, int key){
    if (tree->root == NULL){
        return NULL;
    }
    lee_binary_tree_node_t *node = tree->root;
    while (node != NULL){
        if (key < node->key){
            node = node->left;
        }else if (key > node->key){
            node = node->right;
        }else{
            return node;
        }
    }
    return NULL;
}

/* traversal */

void lee_binary_tree_traversal_node_inorder(lee_binary_tree_node_t *node, lee_binary_tree_traversal_callback_t *func){
    if (node == NULL){
        return;
    }
    lee_binary_tree_traversal_node_inorder(node->left, func);
    func(node);
    lee_binary_tree_traversal_node_inorder(node->right, func);
}

void lee_binary_tree_traversal_inorder(lee_binary_tree_t *tree, lee_binary_tree_traversal_callback_t *func){
    lee_binary_tree_traversal_node_inorder(tree->root, func);
}


/* tests */

void test_binary_tree() {
    lee_binary_tree_t *tree = lee_binary_tree_create();
    lee_binary_tree_push(tree, 10);
    lee_binary_tree_push(tree, 7);
    lee_binary_tree_push(tree, 14);
    lee_binary_tree_push(tree, 3);

    lee_binary_tree_find(tree, 7);
    lee_binary_tree_find(tree, 14);
    lee_binary_tree_find(tree, 25);
    lee_binary_tree_find(tree, 3);

}


