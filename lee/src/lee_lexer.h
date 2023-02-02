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


#ifndef LEE_LEXER_H
#define LEE_LEXER_H

#include "lee_defs.h"


/* lexer */

lee_lexer_t *lee_lexer_create(lee_source_file_t  *sourceFile, lee_symbol_table_t *symbolTable);
void lee_lexer_free(lee_lexer_t *lexer);

/* visitor */

/*
 * Definição do callback para função visitor lee_lexer_node_visit
 * Se retornar true continua visitando os nós.
 */
typedef bool lee_lexer_node_callback_visitor(lee_lexer_node_t *node);

void lee_lexer_node_visit(lee_lexer_node_t *node, lee_lexer_node_callback_visitor cb);

/* iterator */

lee_lexer_iterator_t *lee_lexer_iterator_create(lee_lexer_t *lexer);
lee_token_t *lee_lexer_first_token(lee_lexer_iterator_t *iterator);
lee_token_t *lee_lexer_current_token(lee_lexer_iterator_t *iterator);
lee_token_t *lee_lexer_next_token(lee_lexer_iterator_t *iterator);
lee_token_t *lee_lexer_prior_token(lee_lexer_iterator_t *iterator);
void *lee_lexer_iterator_free(lee_lexer_iterator_t *iterator);

#endif //LEE_LEXER_H
