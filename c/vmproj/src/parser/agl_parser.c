//
// Created by evertonagilar on 05/01/23.
//

#include "agl_parser.h"
#include "agl_lexer.h"
#include <stdio.h>

agl_parse_tree_node_t *agl_parse_tree_node_create(agl_token_t *token){
    agl_parse_tree_node_t *node = malloc(sizeof(agl_parse_tree_node_t));
    node->token = token;
    node->next = NULL;
    return node;
}

void scan_tokens(agl_parse_tree_t *parseTree, agl_scanner_t *scanner) {
    agl_parse_tree_node_t *node, *currentNode;
    agl_token_t *token = agl_lexer_next_token(scanner);
    while (token->type != tkEof){
        printf("token is: %d\n", token->type);
        node = agl_parse_tree_node_create(token);
        if (parseTree->root == NULL){
            parseTree->root = node;
            currentNode = node;
        }else{
            currentNode->next = node;
            currentNode = node;
        }
        ++parseTree->childCount;
        token = agl_lexer_next_token(scanner);
    }
}

agl_parse_tree_t *agl_parser_create_ast(const agl_module_t *module) {
    agl_parse_tree_t *parseTree = malloc(sizeof(agl_parse_tree_t));
    parseTree->root = NULL;
    parseTree->childCount = 0;
    agl_scanner_t *scanner = agl_lexer_create(module);
    scan_tokens(parseTree, scanner);
    agl_lexer_free(scanner);
}


