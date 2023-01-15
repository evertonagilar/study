//
// Created by evertonagilar on 05/01/23.
//

#include "agl_parser.h"
#include "agl_lexer.h"
#include <stdio.h>

agl_terminal_node_t *agl_terminal_node_create(const agl_token_t *token){
    agl_terminal_node_t *node = malloc(sizeof(agl_terminal_node_t));
    node->token = NULL;
    node->next = NULL;
    node->prior = NULL;
    return node;
}

void scan_tokens(agl_parse_tree_t *parseTree, agl_scanner_t *scanner) {
    agl_terminal_node_t *node;
    while (agl_lexer_next_token(scanner)){
        printf("token is: %d\n", scanner->token->type);
        node = agl_terminal_node_create();
        node->token =
    }
}

agl_parse_tree_t *agl_parser_create_ast(agl_module_t *module) {
    agl_parse_tree_t *parseTree = malloc(sizeof(agl_parse_tree_t));
    agl_scanner_t *scanner = agl_lexer_create(module);
    scan_tokens(parseTree, scanner);
    agl_lexer_free(scanner);
}


