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
#include "agl_list.h"

#define LIST_DEFAULT_CAPACITY 100

agl_list_t *agl_list_create(int initialCapacity){
    agl_list_t *list = malloc(sizeof(agl_list_t));
    if (initialCapacity > 0 && initialCapacity < 9999){
        list->data = malloc(sizeof(void*) * initialCapacity);
        list->size = initialCapacity;
    }else{
        list->data = malloc(sizeof(void*) * LIST_DEFAULT_CAPACITY);
        list->size = LIST_DEFAULT_CAPACITY;
    }
    list->count = 0;
    return list;
}

int agl_list_add(agl_list_t *list, void *value){
    if (list->count == list->size){
        list->data = realloc(list->data, list->size + LIST_DEFAULT_CAPACITY);
        list->size += LIST_DEFAULT_CAPACITY;
    }
    int idxElement = list->count++;
    list->data[idxElement] = value;
    return idxElement;
}

void *agl_list_get(agl_list_t *list, int idxElement){
    if (idxElement > 0 && idxElement < list->size){
        return list->data[idxElement];
    }
    return NULL;
}

int agl_list_count(agl_list_t *list){
    return list->count;
}

agl_list_iterator_t *agl_list_iterator(const agl_list_t *list){
    agl_list_iterator_t *iterator = malloc(sizeof(agl_list_iterator_t));
    iterator->list = list;
    iterator->index = 0;
    return iterator;
}

bool agl_list_iterator_has_next(agl_list_iterator_t  *iterator){
    return iterator->index != iterator->list->count;
}

void *agl_list_iterator_next(agl_list_iterator_t *iterator){
    if (iterator->index == iterator->list->count){
        return NULL;
    }else {
        return iterator->list->data[iterator->index++];
    }
}

void *agl_list_iterator_current(agl_list_iterator_t *iterator){
    if (iterator->index == iterator->list->count){
        return NULL;
    }else {
        return iterator->list->data[iterator->index];
    }
}
