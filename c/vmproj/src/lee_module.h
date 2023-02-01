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


#ifndef VMPROJ_AGL_MODULE_H
#define VMPROJ_AGL_MODULE_H

#include "lee_global.h"
#include <stddef.h>
#include <glib.h>
#include <stdbool.h>


lee_module_t *lee_module_load(char *fileName);
void lee_module_free(lee_module_t *module);


#endif //VMPROJ_AGL_MODULE_H
