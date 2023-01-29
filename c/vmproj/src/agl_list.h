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

#ifndef VMPROJ_agl_list_t_H
#define VMPROJ_agl_list_t_H

#include <stdbool.h>

typedef struct {
    void **data;
    int size;
    int count;
} agl_list_t;

typedef struct {
    agl_list_t *list;
    int index;
} agl_list_iterator_t;

agl_list_t *agl_list_create(int initialCapacity);
int agl_list_add(agl_list_t *list, void *value);
void *agl_list_get(agl_list_t *list, int idxElement);
int agl_list_count(agl_list_t *list);
agl_list_iterator_t *agl_list_iterator(const agl_list_t *list);
bool agl_list_iterator_has_next(agl_list_iterator_t  *iterator);
void *agl_list_iterator_next(agl_list_iterator_t  *iterator);
void *agl_list_iterator_current(agl_list_iterator_t *iterator);

#endif //VMPROJ_agl_list_t_H
