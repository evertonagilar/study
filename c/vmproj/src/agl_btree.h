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

#ifndef VMPROJ_AGL_BTREE_H
#define VMPROJ_AGL_BTREE_H

#include <stdbool.h>

#define ORDER 4

typedef struct {
    int key;
    void *value;
} agl_btree_key_entry_t;


typedef struct {
    int m;                                       // número de filhos da página
    bool is_leaf;                                // indica se a página é uma folha
    agl_btree_key_entry_t *keys[ORDER];                // array de keys entries
    struct btree_page_t *children[ORDER-1];
} agl_btree_page_t;

typedef struct {
    int n;                              // quantos elementos estão na btree
    int height;                         // altura da btree
    agl_btree_page_t *root;                 // root da btree
} agl_btree_t;

typedef struct {
    agl_btree_page_t *left;
    agl_btree_page_t *right;
    agl_btree_key_entry_t *key_do_meio;
} btree_page_split_t;

agl_btree_t *btree_new();
bool btree_insert(agl_btree_t *btree, int key);


#endif //VMPROJ_AGL_BTREE_H
