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

#include "agl_bytecode.h"

void agl_bytecode_emit_declaration(agl_parse_tree_node_t *pNode);

void agl_bytecode_error(char *msg){
    printf("Error: %s\n", msg);
    exit(EXIT_FAILURE);
}

void agl_bytecode_emit_declaration(agl_parse_tree_node_t *nodeStatement) {
    printf("emit declaration %s\n", nodeStatement->token->identifier->value);
    return;
}

bool agl_bytecode_init(agl_parse_tree_node_t *node) {
    switch (node->token->type){
        case tkIdentifier:
            agl_bytecode_emit_declaration(node);
            break;
    }
    return true;
}

agl_bytecode_t *agl_bytecode_create(agl_source_file_t *sourceFile){
    agl_bytecode_t *bytecode = malloc(sizeof(agl_module_t));
    bytecode->scanner = agl_lexer_create(sourceFile);
    bytecode->ast = agl_parser_create_ast(bytecode->scanner);
    agl_parser_ast_visit(bytecode->ast->root, agl_bytecode_init);
    return bytecode;
}

void agl_bytecode_free(agl_bytecode_t *bytecode){
    agl_lexer_free(bytecode->scanner);
    agl_parser_free_ast(bytecode->ast);
    free(bytecode);
}


