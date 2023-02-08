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

/*
 *
 * Purpose: A simple hash_tbl table
 *
 */

#ifndef LEE_HASH_H
#define LEE_HASH_H

#include <stdbool.h>
#include "lee_linked_list.h"

typedef struct {
    void *pDataOrList;
    char *key;
    int key_sz;
    int hash;
    bool hasColision;
} lee_hash_entry_t;


typedef struct{
    lee_hash_entry_t **hash_tbl;    // tabela hash em vector
    lee_linked_list_t *list;        // uma lista encadeada de cada elemento adicionado utilizado para free e iterators
    int count;
    int capacity;
    int colisionCount;              // quantas colisões existem na tabela hash_tbl
} lee_hash_table_t;


typedef struct {
    lee_linked_list_iterator_t *iterator;
} lee_hash_table_iterator_t;


/* hash_table */
lee_hash_table_t *lee_hash_table_create(int capacity);
void *lee_hash_table_get(lee_hash_table_t *table, char *key, int key_sz);
void lee_hash_table_push(lee_hash_table_t *table, char *key, int key_sz, void *pData);
int lee_hash_table_count(lee_hash_table_t *table);
void lee_hash_table_free(lee_hash_table_t *table);


/* iterator */
lee_hash_table_iterator_t *lee_hash_table_iterator_create(lee_hash_table_t *table);
lee_hash_table_iterator_t *lee_hash_table_reverse_iterator_create(lee_hash_table_t *table);
void lee_hash_table_iterator_free(lee_hash_table_iterator_t *iterator);
bool lee_hash_table_iterator_has_next(lee_hash_table_iterator_t *iterator);
void *lee_hash_table_iterator_next(lee_hash_table_iterator_t  *iterator);
void *lee_hash_table_iterator_current(lee_hash_table_iterator_t *iterator);

/* tests */
void lee_hash_table_test();


#endif //LEE_LEE_HASH_H
