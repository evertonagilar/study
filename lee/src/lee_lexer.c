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


#include "lee_global.h"
#include <stdio.h>

lee_lexer_node_t *lee_lexer_node_create(lee_token_t *token){
    lee_lexer_node_t *node = malloc(sizeof(lee_lexer_node_t));
    node->token = token;
    node->next = NULL;
    return node;
}

bool lee_lexer_node_free(lee_lexer_node_t *node){
    free(node);
}

void lee_lexer_node_visit(lee_lexer_node_t *node, lee_lexer_node_callback_visitor cb){
    while (node != NULL){
        if (cb(node)){
            node = node->next;
        }else{
            break;
        }
    }
}

lee_lexer_t *lee_lexer_create(lee_source_file_t  *sourceFile){
    lee_lexer_t *lexer = malloc(sizeof(lee_lexer_t));
    lexer->scanner = lee_scanner_create(sourceFile);
    lexer->root = NULL;
    lexer->childCount = 0;
    lee_lexer_node_t *node, *currentNode;
    lee_token_t *token;
    do {
        token = lee_scanner_next_token(lexer->scanner);
        printf("get_current_token is: %d\n", token->type);
        node = lee_lexer_node_create(token);
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

void lee_lexer_free(lee_lexer_t *lexer){
    lee_lexer_node_t *node = lexer->root;
    while (node != NULL){
        lee_lexer_node_t *nextNode = node->next;
        lee_lexer_node_free(node);
        node = nextNode;
    }
    lee_scanner_free(lexer->scanner);
    free(lexer);
}

lee_lexer_iterator_t *lee_lexer_iterator_create(lee_lexer_t *lexer){
    lee_lexer_iterator_t *iterator = malloc(sizeof(lee_lexer_iterator_t));
    iterator->lexer = lexer;
    iterator->currentNode = lexer->root;
    iterator->priorNode = NULL;
}

lee_token_t *lee_lexer_next_token(lee_lexer_iterator_t *iterator){
    iterator->priorNode = iterator->currentNode;
    iterator->currentNode = iterator->currentNode->next;
    return iterator->currentNode->token;
}

lee_token_t *lee_lexer_first_token(lee_lexer_iterator_t *iterator){
    return iterator->lexer->root->token;
}

lee_token_t *lee_lexer_current_token(lee_lexer_iterator_t *iterator){
    return iterator->currentNode->token;
}

lee_token_t *lee_lexer_prior_token(lee_lexer_iterator_t *iterator){
    return iterator->priorNode->token;
}

void *lee_lexer_iterator_free(lee_lexer_iterator_t *iterator){
    free(iterator);
}