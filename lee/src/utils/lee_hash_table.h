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
 * Purpose: A simple hash table that does not validate duplicates
 *
 */

#ifndef LEE_HASH_H
#define LEE_HASH_H

#include <stdbool.h>

typedef struct {
    void *pDataOrList;
    char *key;
    int key_sz;
    int hash;
    bool hasColision;
} lee_hash_entry_t;


typedef struct{
    lee_hash_entry_t **itens;
    int count;
    int capacity;
    int colisionCount;
} lee_hash_table_t;

lee_hash_table_t *lee_hash_table_create(int capacity);
void *lee_hash_table_get(lee_hash_table_t *table, char *key, int key_sz);
void lee_hash_table_push(lee_hash_table_t *table, char *key, int key_sz, void *pData);
void lee_hash_table_free(lee_hash_table_t *table);
void lee_hash_table_test();

#endif //LEE_LEE_HASH_H
