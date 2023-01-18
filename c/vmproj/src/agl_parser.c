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

agl_parse_tree_node_t *agl_parse_tree_node_create(agl_token_t *token){
    agl_parse_tree_node_t *node = malloc(sizeof(agl_parse_tree_node_t));
    node->token = token;
    node->next = NULL;
    return node;
}

bool agl_parse_tree_node_free(agl_parse_tree_node_t *node){
    free(node);
}

void agl_parser_ast_visit(agl_parse_tree_node_t *node, agl_parse_tree_callback_visitor cb){
    while (node != NULL){
        if (cb(node)){
            node = node->next;
        }else{
            break;
        }
    }
}

agl_parse_tree_t *agl_parser_create_ast(agl_scanner_t *scanner){
    agl_parse_tree_t *ast = malloc(sizeof(agl_parse_tree_t));
    ast->root = NULL;
    ast->childCount = 0;
    agl_parse_tree_node_t *node, *currentNode;
    agl_token_t *token = agl_lexer_next_token(scanner);
    while (token->type != tkEof){
        printf("token is: %d\n", token->type);
        node = agl_parse_tree_node_create(token);
        if (ast->root == NULL){
            ast->root = node;
            currentNode = node;
        }else{
            currentNode->next = node;
            currentNode = node;
        }
        ++ast->childCount;
        token = agl_lexer_next_token(scanner);
    }
    return ast;
}

void agl_parser_free_ast(agl_parse_tree_t *ast){
    agl_parse_tree_node_t *node = ast->root;
    while (node != NULL){
        agl_parse_tree_node_t *nextNode = node->next;
        agl_parse_tree_node_free(node);
        node = nextNode;
    }
    free(ast);
}


