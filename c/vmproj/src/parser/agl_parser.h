//
// Created by evertonagilar on 05/01/23.
//

#ifndef VMPROJ_AGL_PARSER_H
#define VMPROJ_AGL_PARSER_H

#include "../agl_module.h"
#include "agl_token.h"

typedef struct agl_terminal_node_t {
    agl_token_t *token;
    struct agl_terminal_node_t *next;
    struct agl_terminal_node_t *prior;
} agl_terminal_node_t;

typedef struct agl_parse_tree_t {
    agl_terminal_node_t *root;
    int childCount;
} agl_parse_tree_t;

agl_parse_tree_t *agl_parser_create_ast(agl_module_t *module);

#endif //VMPROJ_AGL_PARSER_H
