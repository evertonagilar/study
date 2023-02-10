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
#include <stdarg.h>

/* lee_binary_tree_node */

lee_binary_tree_node_t *lee_binary_tree_node_create(int key){
    lee_binary_tree_node_t *node = malloc(sizeof(lee_binary_tree_node_t));
    node->key = key;
    node->left = NULL;
    node->right = NULL;
    return node;
}

void lee_binary_tree_node_free(lee_binary_tree_node_t *node){
    if (node != NULL) {
        lee_binary_tree_node_free(node->left);
        lee_binary_tree_node_free(node->right);
        free(node);
    }
}


/* lee_binary_tree */

lee_binary_tree_t *lee_binary_tree_create(){
    lee_binary_tree_t *tree = malloc(sizeof(lee_binary_tree_t));
    tree->root = NULL;
    return tree;
}

void lee_binary_tree_free(lee_binary_tree_t *tree){
    lee_binary_tree_node_free(tree->root);
    free(tree);
}

bool lee_binary_tree_push(lee_binary_tree_t *tree, int key) {
    lee_binary_tree_node_t *node = lee_binary_tree_node_create(key);
    if (tree->root == NULL) {
        tree->root = node;
        return true;
    }
    lee_binary_tree_node_t *current = tree->root;
    while (current != NULL) {
        lee_binary_tree_node_t *parent = current;
        if (key < current->key) {
            current = current->left;
            if (current == NULL){
                parent->left = node;
                return true;
            }
        } else if (key > current->key) {
            current = current->right;
            if (current == NULL){
                parent->right = node;
                return true;
            }
        }else{
            return false;
        }
    }
}

/*
 * Encontra o sucessor de um node
 *
 * Retorna o sucessor e também parentSucessor será retornado o pai do sucessor
 *
 * Algoritmo: vai um node a direita e depois sempre para a esquerda até chegar ao node
 */
lee_binary_tree_node_t *lee_binary_tree_node_find_sucessor(lee_binary_tree_node_t *node, lee_binary_tree_node_t **parentSucessor){
    *parentSucessor = node;
    lee_binary_tree_node_t *current = node->right;
    while (current->left != NULL){
        *parentSucessor = current;
        current = current->left;
    }
    return current;
}


/*
 * Remoção tem 3 casos:
 *  caso 1: Nó não tem filhos: ajusta o ponteiro para o pai não apontar mais para o nó removido
 *  caso 2: Nó tem apenas 1 filho a esquerda ou a direita: o pai deve apontar para um dos filhos do nó removido
 *  caso 3: Nó tem 2 filhos: escolhe o filho da direita sucessor do nó para ser o que vai ocupar a posição dele
 */
bool lee_binary_tree_remove(lee_binary_tree_t *tree, int key){
    // encontrar o nó a ser movido sempre anotando a direção percorrida
    lee_binary_tree_node_t *node = tree->root;
    lee_binary_tree_node_t *parent = NULL;
    bool walked_to_left;
    while (node != NULL){
        if (key < node->key){
            parent = node;
            node = node->left;
            walked_to_left = true;
        }else if (key > node->key){
            parent = node;
            node = node->right;
            walked_to_left = false;
        }else{
            /* encontramos o node que deve ser removido */

            // caso 1: não tem filhos: ajusta o ponteiro para o pai não apontar mais para o nó removido
            if (node->left == NULL && node->right == NULL) {
                if (parent != NULL) {
                    if (walked_to_left) {
                        parent->left = NULL;
                    } else {
                        parent->right = NULL;
                    }
                }else{
                    tree->root = NULL;
                }
            }else if (node->left != NULL && node->right != NULL){
                // caso 3: Nó tem 2 filhos: escolhe o filho da direita sucessor do nó para ser o que vai ocupar a posição dele
                lee_binary_tree_node_t *parentSucessor = NULL;
                lee_binary_tree_node_t *sucessor = lee_binary_tree_node_find_sucessor(node, &parentSucessor);
                if (parent != NULL) {
                    if (walked_to_left) {
                        parent->left = sucessor;
                    } else {
                        parent->right = sucessor;
                    }
                }else{
                    tree->root = sucessor;
                }
                sucessor->left = node->left;
                if (parentSucessor != node) {
                    sucessor->right = node->right;
                    parentSucessor->left = NULL;
                }
            }else{
                // caso 2: tem apenas 1 filho a esquerda ou a direita: o pai deve apontar para um dos filhos do nó removido
                if (node->left != NULL){    // tem filho da esquerda
                    if (parent != NULL) {
                        if (walked_to_left) {
                            parent->left = node->left;
                        } else {
                            parent->right = node->left;
                        }
                    }else{
                        tree->root = node->left;
                    }
                }else{ // tem filho da direita
                    if (parent != NULL) {
                        if (walked_to_left) {
                            parent->left = node->right;
                        } else {
                            parent->right = node->right;
                        }
                    }else{
                        tree->root = node->right;
                    }
                }
            }

            // finalmente, podemos liberar o node
            free(node);
            return true;
        }
    }
    return false;
}

lee_binary_tree_node_t *lee_binary_tree_find(lee_binary_tree_t *tree, int key){
    lee_binary_tree_node_t *current = tree->root;
    while (current != NULL){
        if (key < current->key){
            current = current->left;
        }else if (key > current->key){
            current = current->right;
        }else{
            return current;
        }
    }
    return NULL;
}

/* traversal */

void lee_binary_tree_traversal_node_inorder(lee_binary_tree_node_t *node, lee_binary_tree_traversal_callback_t *func, va_list *ap){
    if (node == NULL){
        return;
    }
    va_list args;
    va_copy(args, *ap);
    lee_binary_tree_traversal_node_inorder(node->left, func, &args);
    func(node, &args);
    lee_binary_tree_traversal_node_inorder(node->right, func, &args);
    va_end(args);
}

void lee_binary_tree_traversal_node_preorder(lee_binary_tree_node_t *node, lee_binary_tree_traversal_callback_t *func, va_list *ap){
    if (node == NULL){
        return;
    }
    va_list args;
    va_copy(args, *ap);
    func(node, &args);
    lee_binary_tree_traversal_node_preorder(node->left, func, &args);
    lee_binary_tree_traversal_node_preorder(node->right, func, &args);
    va_end(args);
}

void lee_binary_tree_traversal_node_posorder(lee_binary_tree_node_t *node, lee_binary_tree_traversal_callback_t *func, va_list *ap){
    if (node == NULL){
        return;
    }
    va_list args;
    va_copy(args, *ap);
    lee_binary_tree_traversal_node_posorder(node->left, func, &args);
    lee_binary_tree_traversal_node_posorder(node->right, func, &args);
    func(node, &args);
    va_end(args);
}

void lee_binary_tree_traversal(lee_binary_tree_t *tree, lee_binary_tree_traversal_type_t traversalType, lee_binary_tree_traversal_callback_t *func, ...){
    va_list args;
    va_start(args, func);
    switch (traversalType) {
        case preorder:
            lee_binary_tree_traversal_node_preorder(tree->root, func, &args);
            break;
        case posorder:
            lee_binary_tree_traversal_node_posorder(tree->root, func, &args);
            break;
        default:
            lee_binary_tree_traversal_node_inorder(tree->root, func, &args);
    }
    va_end(args);
}

/* lee_binary_tree_sort */

void lee_binary_tree_sort_add_nodes_callback(lee_binary_tree_node_t *node, va_list *ap){
    va_list args;
    va_copy(args, *ap);
    lee_binary_tree_t *tree = va_arg(args, lee_binary_tree_t*);
    lee_binary_tree_push(tree, node->key);
    va_end(args);
}

lee_binary_tree_t *lee_binary_tree_sort(lee_binary_tree_t *tree){
    lee_binary_tree_t *tree2 = lee_binary_tree_create();
    lee_binary_tree_traversal(tree, inorder, lee_binary_tree_sort_add_nodes_callback, tree2);
    return tree2;
}


/* tests */

void imprimeNoCallback(struct lee_binary_tree_node_t *node, va_list *ap){
    printf("Key: %d\n", node->key);
}

void test_binary_tree() {
    printf("\n\nTeste binary tree\n");

    lee_binary_tree_t *tree = lee_binary_tree_create();
    lee_binary_tree_push(tree, 10);
    lee_binary_tree_push(tree, 7);
    lee_binary_tree_push(tree, 14);
    lee_binary_tree_push(tree, 3);
    lee_binary_tree_push(tree, 21);
    lee_binary_tree_push(tree, 12);
    lee_binary_tree_push(tree, 8);
    lee_binary_tree_push(tree, 2);

    // pesquisas
    lee_binary_tree_find(tree, 7);
    lee_binary_tree_find(tree, 14);
    lee_binary_tree_find(tree, 25);
    lee_binary_tree_find(tree, 3);

    // remoções
    lee_binary_tree_remove(tree, 7);
    lee_binary_tree_remove(tree, 10);

    // sort
    lee_binary_tree_t *sortTree = lee_binary_tree_sort(tree);

    puts("\nPre ordem:");
    lee_binary_tree_traversal(tree, preorder, imprimeNoCallback);

    puts("\nEm ordem:");
    lee_binary_tree_traversal(tree, inorder, imprimeNoCallback);

    puts("\nPos ordem:");
    lee_binary_tree_traversal(tree, posorder, imprimeNoCallback);

    lee_binary_tree_free(tree);

}


