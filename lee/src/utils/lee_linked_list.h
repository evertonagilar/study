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


#ifndef LEE_LINKED_LIST_H
#define LEE_LINKED_LIST_H

#include <stdbool.h>

typedef struct lee_linked_list_node_t {
    struct lee_linked_list_node_t *next;
    struct lee_linked_list_node_t *prior;
    void *pData;
} lee_linked_list_node_t;

typedef struct {
    lee_linked_list_node_t *head;
    lee_linked_list_node_t *tail;
    int count;
} lee_linked_list_t;

typedef struct {
    lee_linked_list_t *pList;
    lee_linked_list_node_t *current;
    bool reverseMode;
} lee_linked_list_iterator_t;


/* list */
lee_linked_list_t *lee_linked_list_create();
void lee_linked_list_add(lee_linked_list_t *list, void *pData);
void lee_linked_list_remove(lee_linked_list_t *list, void *pData);
void *lee_linked_list_head(lee_linked_list_t *list);
void *lee_linked_list_tail(lee_linked_list_t *list);
int lee_linked_list_count(lee_linked_list_t *list);
void lee_linked_list_free(lee_linked_list_t *list);


/* iterator */
lee_linked_list_iterator_t *lee_linked_list_iterator_create(lee_linked_list_t *list);
lee_linked_list_iterator_t *lee_linked_list_reverse_iterator_create(lee_linked_list_t *list);
void lee_linked_list_iterator_free(lee_linked_list_iterator_t *iterator);
bool lee_linked_list_iterator_has_next(lee_linked_list_iterator_t *iterator);
void *lee_linked_list_iterator_next(lee_linked_list_iterator_t  *iterator);
void *lee_linked_list_iterator_current(lee_linked_list_iterator_t *iterator);

/* tests */
void lee_linked_list_test();

#endif //LEE_LINKED_LIST_H
