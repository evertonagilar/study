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
 * init     : program identifier
 *
 * statement -> decls
 *
 * decls -> funcDecls | varDecls
 *
 * varDecls -> type id ( = expression )?
 *
 * funcDecls -> type id '(' paramList ')' '{' statement '}'
 *
 * identifier -> [ 1-9 ]
 *
 *
 *
 *
 */

void parseError(char *msg){
    printf("Error: %s\n", msg);
    exit(EXIT_FAILURE);
}

void nextToken(agl_parse_ast_context_t *parseAST){
    parseAST->priorNode = parseAST->currentNode;
    parseAST->currentNode = parseAST->currentNode->next;
}

void matchToken(agl_parse_ast_context_t *parseAST, agl_token_type_t type){
    if (parseAST->currentNode->token->type != type){
        parseError("Esperado identificador");
    }
    nextToken(parseAST);
}

void emitVarDecls(agl_parse_ast_context_t *parseAST) {

}

void emitFuncDecls(agl_parse_ast_context_t *parseAST) {

}

void emitDecls(agl_parse_ast_context_t *parseAST) {
    matchToken(parseAST, tkIdentifier);
    if (parseAST->currentNode->next->next->token->type == tkOpenP){
        emitFuncDecls(parseAST);
    }else{
        emitVarDecls(parseAST);
    }
    return;
}

bool doStatement(agl_parse_ast_context_t *parseAST) {
    switch (parseAST->currentNode->token->type){
        case tkIdentifier:
            emitDecls(parseAST);
            break;
    }
    return true;
}

void doProgram(agl_parse_ast_context_t *parseAST) {
    matchToken(parseAST, tkProgram);
    if (parseAST->currentNode->token->type == tkIdentifier){
        parseAST->ast = malloc(sizeof(agl_parse_ast_t));
        parseAST->ast->type = tkProgram;
        parseAST->ast->programSmnt.programName = parseAST->currentNode->token->symbol->name;
    }else{
        parseError("Esperado nome do programa após token program");
    }
}

agl_parse_ast_context_t *agl_parse_ast_create(agl_source_file_t *sourceFile){
    agl_parse_ast_context_t *parseAST = malloc(sizeof(agl_module_t));
    parseAST->lexer = agl_lexer_create(sourceFile);
    parseAST->currentNode = parseAST->lexer->root;
    doProgram(parseAST);
    return parseAST;
}

void agl_parse_ast_free(agl_parse_ast_context_t *parseAST){
    agl_lexer_free(parseAST->lexer);
    free(parseAST);
}


