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

#include "lee_linked_list.h"
#include <stdlib.h>
#include <stdio.h>

lee_linked_list_node_t *lee_linked_list_iterator_next_node(lee_linked_list_iterator_t *iterator);

lee_linked_list_t *lee_linked_list_create(){
    lee_linked_list_t *list = malloc(sizeof(lee_linked_list_t));
    list->count = 0;
    list->head = NULL;
    list->tail = NULL;
    return list;
}

void *lee_linked_list_head(lee_linked_list_t *list){
    return list->head != NULL ? list->head->pData : NULL;
}

void *lee_linked_list_tail(lee_linked_list_t *list){
    return list->tail != NULL ? list->tail->pData : NULL;
}

int lee_linked_list_count(lee_linked_list_t *list){
    return list->count;
}

void lee_linked_list_add(lee_linked_list_t *list, void *pData){
    lee_linked_list_node_t *node = malloc(sizeof(lee_linked_list_node_t));
    node->prior = list->tail;
    node->pData = pData;
    node->next = NULL;
    list->tail = node;
    if (list->head == NULL){
        list->head = node;
    }
    list->count++;
}

void lee_linked_list_remove(lee_linked_list_t *list, void *pData){
    lee_linked_list_iterator_t *it = lee_linked_list_reverse_iterator_create(list);
    lee_linked_list_node_t *pNode;
    while (pNode = lee_linked_list_iterator_next_node(it)){
        if (pNode->pData == pData){
            if (pNode->prior != NULL){
                pNode->prior->next = pNode->next;
                if (pNode->next != NULL){
                    pNode->next->prior = pNode->prior;
                }
            }
            free(pNode);
        }
    }
    lee_linked_list_iterator_free(it);
}

void lee_linked_list_free(lee_linked_list_t *list){
    lee_linked_list_iterator_t *it = lee_linked_list_reverse_iterator_create(list);
    lee_linked_list_node_t *pNode;
    while (pNode = lee_linked_list_iterator_next_node(it)){
        free(pNode);
    }
    lee_linked_list_iterator_free(it);
    free(list);
}


/* iterator */

lee_linked_list_iterator_t *lee_linked_list_iterator_create(lee_linked_list_t *list){
    lee_linked_list_iterator_t *iterator = malloc(sizeof(lee_linked_list_iterator_t));
    iterator->pList = list;
    iterator->current = list->head;
    iterator->reverseMode = false;
    return iterator;
}

lee_linked_list_iterator_t *lee_linked_list_reverse_iterator_create(lee_linked_list_t *list){
    lee_linked_list_iterator_t *iterator = malloc(sizeof(lee_linked_list_iterator_t));
    iterator->pList = list;
    iterator->current = list->tail;
    iterator->reverseMode = true;
    return iterator;
}

void lee_linked_list_iterator_free(lee_linked_list_iterator_t *iterator){
    free(iterator);
}

bool lee_linked_list_iterator_has_next(lee_linked_list_iterator_t  *iterator){
    return iterator->current != NULL ? iterator->current->next != NULL : false;
}

void *lee_linked_list_iterator_next(lee_linked_list_iterator_t *iterator){
    if (iterator->current != NULL) {
        void *pData = iterator->current->pData;
        iterator->current = iterator->current->next;
        return pData;
    }else{
        return NULL;
    }
}

lee_linked_list_node_t *lee_linked_list_iterator_next_node(lee_linked_list_iterator_t *iterator){
    if (iterator->current != NULL){
        lee_linked_list_node_t *pNode = iterator->current;
        iterator->current = iterator->current->next;
        return pNode;
    }else{
        return NULL;
    };
}

void *lee_linked_list_iterator_current(lee_linked_list_iterator_t *iterator){
    return iterator->current != NULL ? iterator->current->pData : NULL;
}

/* tests */

void lee_linked_list_test(){
    lee_linked_list_t *list = lee_linked_list_create();
    lee_linked_list_add(list, "10");
    lee_linked_list_add(list, "9");
    lee_linked_list_add(list, "8");
    lee_linked_list_add(list, "7");
    lee_linked_list_add(list, "5");

    lee_linked_list_iterator_t *it = lee_linked_list_iterator_create(list);
    char *pStr;
    while (pStr = lee_linked_list_iterator_next(it)){
        printf("Str: %s\n", pStr);
    }

    lee_linked_list_free(list);

}
