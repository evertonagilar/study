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

#include "lee_hash_table.h"
#include "lee_list.h"
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

lee_hash_table_t *lee_hash_table_create(int capacity){
    lee_hash_table_t *table = malloc(sizeof(lee_hash_table_t*));
    table->itens = calloc(capacity, sizeof(lee_hash_table_t*));
    table->capacity = capacity;
    table->count = 0;
    table->colisionCount = 0;
    return table;
}

int lee_hash_compute_hash(lee_hash_table_t *table, char *key, int key_sz){
    int i = 0;
    for (int j = 0; j < key_sz; j++){
        i += key[j];
    }
    int hash = i % table->capacity;
    return hash;
}

lee_hash_entry_t *lee_hash_create_entry(int hash, char *key, int key_sz, void *data){
    lee_hash_entry_t *item = malloc(sizeof(lee_hash_entry_t));
    item->key = key;
    item->key_sz = key_sz;
    item->hash = hash;
    item->pDataOrList = data;
}

void *lee_hash_table_get_pentry(lee_hash_table_t *table, int hash){
    lee_hash_entry_t **item = table->itens + hash;
    return item;
}

void *lee_hash_table_get(lee_hash_table_t *table, char *key, int key_sz){
    int hash = lee_hash_compute_hash(table, key, key_sz);
    lee_hash_entry_t **pItem = table->itens + hash;
    if (*pItem != NULL) {
        if ((*pItem)->hasColision){
            lee_list_iterator_t *it = lee_list_iterator((*pItem)->pDataOrList);
            void *pData;
            while (pData = lee_list_iterator_next(it)){

            }
        }
        return (*pItem)->pDataOrList;
    }else{
        return NULL;
    }
}

void lee_hash_table_push(lee_hash_table_t *table, char *key, int key_sz, void *pData){
    int hash = lee_hash_compute_hash(table, key, key_sz);
    lee_hash_entry_t **pItem = lee_hash_table_get_pentry(table, hash);
    // pItem já está ocupado?
    if (*pItem != NULL){
        lee_list_t *dataList;
        // Como pItem já está ocupado, hasColision quando true indica que pDataOrList é uma lista.
        // Se hasColision é false, temos que criar uma lista, migrar pData atual para a lista e também adicionar
        // o novo pData na lista. Dai (*pItem)->pDataOrList passa apontar para essa nova lista. Pushs
        // subsequentes com o mesmo hash só vão adicionando itens na lista.
        if ((*pItem)->hasColision){
            dataList = (*pItem)->pDataOrList;
        }else {
            dataList = lee_list_create(10);
            lee_list_add(dataList, (*pItem)->pDataOrList); // pData atual
            (*pItem)->pDataOrList = dataList;   // aponta para pData mas agora aponta para uma lista
            (*pItem)->hasColision = true;       // sinaliza que houve colisão
        }
        lee_list_add(dataList, pData); // pData que colidiu
        table->colisionCount++;
    }
    table->count++;
    *pItem = lee_hash_create_entry(hash, key, key_sz, pData);
}

void lee_hash_table_free(lee_hash_table_t *table){
    lee_hash_entry_t **pItem;
    if (table->count > 0) {
        for (int i = 0; i < table->capacity; i++) {
            pItem = table->itens + (i * sizeof(lee_hash_entry_t *));
            if (*pItem != NULL) {
                free(pItem);
            }
        }
    }
    free(table);
}