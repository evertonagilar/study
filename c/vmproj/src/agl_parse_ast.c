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

#include "agl_parse_ast.h"


/*
 *
 * statement -> decls
 *
 * decls -> funcDecls | varDecls
 *
 * varDecls -> type id ( = expression )?
 *
 * funcDecls -> type id '(' paramList ')' '{' statement '}'
 *
 *
 *
 *
 *
 *
 */

void error(char *msg){
    printf("Error: %s\n", msg);
    exit(EXIT_FAILURE);
}

void match(struct agl_lexer_node_t *node, agl_token_type_t type){
    if (node->token->type != type){
        error( "Esperado identificador");
    }
}

void emitVarDecls(agl_parse_ast_t *parseAST) {

}

void emitFuncDecls(agl_parse_ast_t *parseAST) {

}

void emitDecls(agl_parse_ast_t *parseAST) {
    match(parseAST->node, tkIdentifier);
    if (parseAST->node->next->next->token->type == tkOpenP){
        emitFuncDecls(parseAST);
    }else{
        emitVarDecls(parseAST);
    }
    return;
}

bool doStatement(agl_parse_ast_t *parseAST) {
    switch (parseAST->node->token->type){
        case tkIdentifier:
            emitDecls(parseAST);
            break;
    }
    return true;
}

agl_parse_ast_t *agl_parse_ast_create(agl_source_file_t *sourceFile){
    agl_parse_ast_t *parseAST = malloc(sizeof(agl_module_t));
    parseAST->lexer = agl_lexer_create(sourceFile);
    parseAST->node = parseAST->lexer->root;
    doStatement(parseAST);
    return parseAST;
}

void agl_parse_ast_free(agl_parse_ast_t *parseAST){
    agl_lexer_free(parseAST->lexer);
    free(parseAST);
}


