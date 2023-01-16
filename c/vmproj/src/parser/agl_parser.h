//
// Created by evertonagilar on 05/01/23.
//

#ifndef VMPROJ_AGL_PARSER_H
#define VMPROJ_AGL_PARSER_H

#include "../agl_module.h"
#include "agl_token.h"

typedef struct agl_parse_tree_node_t {
    agl_token_t *token;
    struct agl_parse_tree_node_t *next;
} agl_parse_tree_node_t;

typedef struct agl_parse_tree_t {
    agl_parse_tree_node_t *root;
    int childCount;
} agl_parse_tree_t;

typedef void agl_parse_tree_callback_visitor(agl_parse_tree_node_t *node);

agl_parse_tree_t *agl_parser_create_ast(const agl_module_t *module);
void agl_parser_free_ast(agl_parse_tree_t *ast);
void agl_parser_ast_visit(const agl_parse_tree_t *ast, agl_parse_tree_callback_visitor cb);

#endif //VMPROJ_AGL_PARSER_H
