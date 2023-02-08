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

#ifndef LEE_BINARY_TREE_H
#define LEE_BINARY_TREE_H

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

typedef struct lee_binary_tree_node_t {
    int key;
    struct lee_binary_tree_node_t *left;
    struct lee_binary_tree_node_t *right;
} lee_binary_tree_node_t;

typedef struct {
    lee_binary_tree_node_t *root;
} lee_binary_tree_t;

typedef void lee_binary_tree_traversal_callback_t(lee_binary_tree_node_t *node);

lee_binary_tree_t *lee_binary_tree_create();
void lee_binary_tree_free(lee_binary_tree_t *tree);
void lee_binary_tree_push(lee_binary_tree_t *tree, int key);
lee_binary_tree_node_t *lee_binary_tree_find(lee_binary_tree_t *tree, int key);
void lee_binary_tree_traversal_inorder(lee_binary_tree_t *tree, lee_binary_tree_traversal_callback_t *func);


void test_binary_tree();


#endif //LEE_BINARY_TREE_H
