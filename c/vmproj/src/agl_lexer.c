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


#include "agl_global.h"
#include <stdio.h>

agl_lexer_node_t *agl_lexer_node_create(agl_token_t *token){
    agl_lexer_node_t *node = malloc(sizeof(agl_lexer_node_t));
    node->token = token;
    node->next = NULL;
    return node;
}

bool agl_lexer_node_free(agl_lexer_node_t *node){
    free(node);
}

void agl_lexer_node_visit(agl_lexer_node_t *node, agl_lexer_node_callback_visitor cb){
    while (node != NULL){
        if (cb(node)){
            node = node->next;
        }else{
            break;
        }
    }
}

agl_lexer_t *agl_lexer_create(agl_source_file_t  *sourceFile){
    agl_lexer_t *lexer = malloc(sizeof(agl_lexer_t));
    lexer->scanner = agl_scanner_create(sourceFile);
    lexer->root = NULL;
    lexer->childCount = 0;
    agl_lexer_node_t *node, *currentNode;
    agl_token_t *token;
    do {
        token = agl_scanner_next_token(lexer->scanner);
        printf("get_current_token is: %d\n", token->type);
        node = agl_lexer_node_create(token);
        if (lexer->root == NULL){
            lexer->root = node;
            currentNode = node;
        }else{
            currentNode->next = node;
            currentNode = node;
        }
        ++lexer->childCount;
    } while (token->type != tkEof);
    return lexer;
}

void agl_lexer_free(agl_lexer_t *lexer){
    agl_lexer_node_t *node = lexer->root;
    while (node != NULL){
        agl_lexer_node_t *nextNode = node->next;
        agl_lexer_node_free(node);
        node = nextNode;
    }
    agl_scanner_free(lexer->scanner);
    free(lexer);
}

agl_lexer_iterator_t *agl_lexer_iterator_create(agl_lexer_t *lexer){
    agl_lexer_iterator_t *iterator = malloc(sizeof(agl_lexer_iterator_t));
    iterator->lexer = lexer;
    iterator->currentNode = lexer->root;
    iterator->priorNode = NULL;
}

agl_token_t *agl_lexer_next_token(agl_lexer_iterator_t *iterator){
    iterator->priorNode = iterator->currentNode;
    iterator->currentNode = iterator->currentNode->next;
    return iterator->currentNode->token;
}

agl_token_t *agl_lexer_first_token(agl_lexer_iterator_t *iterator){
    return iterator->lexer->root->token;
}

agl_token_t *agl_lexer_current_token(agl_lexer_iterator_t *iterator){
    return iterator->currentNode->token;
}

agl_token_t *agl_lexer_prior_token(agl_lexer_iterator_t *iterator){
    return iterator->priorNode->token;
}

void *agl_lexer_iterator_free(agl_lexer_iterator_t *iterator){
    free(iterator);
}