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


BTREE new_node() {
    BTREE node = malloc(sizeof(NODE));
    node->left = NULL;

    return node;
}


BTREE init_node(DATA d1, BTREE pLeft, BTREE pRight) {
    BTREE t;
    t = new_node();
    t->d = d1;

    if (pLeft != NULL && pRight != NULL){
        if (pLeft->d < )
    }else {
        t->left = pLeft;
        t->right = pRight;
    }
    return t;
}


/* create a linked binary tree from an array */

BTREE create_tree(DATA a[], int i, int size) {
    if (i >= size)
        return NULL;
    else
        return (init_node(a[i],
                          create_tree(a, 2 * i + 1, size),
                          create_tree(a, 2 * i + 2, size)));
}


/* preorder traversal */

void preorder(BTREE root) {
    if (root != NULL) {
        printf("%c ", root->d);
        preorder(root->left);
        preorder(root->right);
    }
}


/* Inorder traversal */

void inorder(BTREE root) {
    if (root != NULL) {
        inorder(root->left);
        printf("%c ", root->d);
        inorder(root->right);
    }
}


/* postorder binary tree traversal */

void postorder(BTREE root) {
    if (root != NULL) {
        postorder(root->left);
        postorder(root->right);
        printf("%c ", root->d);
    }
}


void test_binary_tree() {
    char lista[] = {'6', '4', '2', '8'};
    BTREE root;
    root = create_tree(lista, 0, sizeof(lista));
    assert(root != NULL);
    printf("PREORDER\n");
    preorder(root);
    printf("\n");
    printf("INORDER\n");
    inorder(root);
    printf("\n");
    printf("POSTORDER\n");
    postorder(root);
    printf("\n");
}

#include "lee_binary_tree.h"
