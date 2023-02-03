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
 * A simple list implemented with an array
 *
 */

#ifndef LEE_LIST_H
#define LEE_LIST_H

#include <stdbool.h>

typedef struct {
    void **pData;
    int size;
    int count;
} lee_list_t;

typedef struct {
    lee_list_t *list;
    int index;
} lee_list_iterator_t;


/* list */
lee_list_t *lee_list_create(int initialCapacity);
int lee_list_add(lee_list_t *list, void *pData);
void *lee_list_get(lee_list_t *list, int idxElement);
int lee_list_count(lee_list_t *list);

/* iterator */
lee_list_iterator_t *lee_list_iterator(lee_list_t *list);
bool lee_list_iterator_has_next(lee_list_iterator_t  *iterator);
void *lee_list_iterator_next(lee_list_iterator_t  *iterator);
void *lee_list_iterator_current(lee_list_iterator_t *iterator);

#endif //LEE_LIST_H
