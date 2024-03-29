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

#include <stdlib.h>
#include <assert.h>
#include "lee_array_list.h"

#define DEFAULT_CAPACITY 100

/* list */

lee_array_list_t *lee_array_list_create(int initialCapacity){
    lee_array_list_t *list = malloc(sizeof(lee_array_list_t));
    assert(initialCapacity > 0);
    list->pData = malloc(sizeof(void*) * initialCapacity);
    list->size = initialCapacity;
    list->count = 0;
    return list;
}

void lee_array_list_free(lee_array_list_t *list){
    free(list->pData);
    free(list);
}

int lee_array_list_add(lee_array_list_t *list, void *pData){
    if (list->count == list->size){
        list->pData = realloc(list->pData, list->size + DEFAULT_CAPACITY);
        list->size += DEFAULT_CAPACITY;
    }
    int idxElement = list->count++;
    list->pData[idxElement] = pData;
    return idxElement;
}

void *lee_array_list_get(lee_array_list_t *list, int idxElement){
    if (idxElement > 0 && idxElement < list->size){
        return list->pData[idxElement];
    }
    return NULL;
}

int lee_array_list_count(lee_array_list_t *list){
    return list->count;
}

/* iterator */

lee_array_list_iterator_t *lee_array_list_iterator_create(lee_array_list_t *list){
    lee_array_list_iterator_t *iterator = malloc(sizeof(lee_array_list_iterator_t));
    iterator->pList = list;
    iterator->index = 0;
    return iterator;
}

void lee_array_list_iterator_free(lee_array_list_iterator_t *iterator){
    free(iterator);
}

bool lee_array_list_iterator_has_next(lee_array_list_iterator_t  *iterator){
    return iterator->index != iterator->pList->count;
}

void *lee_array_list_iterator_next(lee_array_list_iterator_t *iterator){
    if (iterator->index == iterator->pList->count){
        return NULL;
    }else {
        return iterator->pList->pData[iterator->index++];
    }
}

void *lee_array_list_iterator_current(lee_array_list_iterator_t *iterator){
    if (iterator->index == iterator->pList->count){
        return NULL;
    }else {
        return iterator->pList->pData[iterator->index];
    }
}
