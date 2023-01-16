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

void agl_parse_tree_node_free(agl_parse_tree_node_t *node){
    free(node);
}

void agl_parser_ast_visit(const agl_parse_tree_t *ast, agl_parse_tree_callback_visitor cb){
    agl_parse_tree_node_t *node = ast->root;
    agl_parse_tree_node_t *nextNode = NULL;
    while (node != NULL){
        nextNode = node->next;
        cb(node);
        node = nextNode;
    }
}

agl_parse_tree_t *agl_parser_create_ast(const agl_module_t *module){
    agl_parse_tree_t *ast = malloc(sizeof(agl_parse_tree_t));
    ast->root = NULL;
    ast->childCount = 0;
    agl_scanner_t *scanner = agl_lexer_create(module);
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
    agl_lexer_free(scanner);
    return ast;
}

void agl_parser_free_ast(agl_parse_tree_t *ast){
    agl_parser_ast_visit(ast, agl_parse_tree_node_free);
    free(ast);
}


