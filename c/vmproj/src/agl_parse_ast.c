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

void parseError(char *msg){
    printf("Error: %s\n", msg);
    exit(EXIT_FAILURE);
}

agl_token_t *nextToken(agl_parse_ast_context_t *context){
    return agl_lexer_next_token(context->tokenIterator);
}

agl_token_t *currentToken(agl_parse_ast_context_t *context){
    return agl_lexer_current_token(context->tokenIterator);
}

agl_token_t *priorToken(agl_parse_ast_context_t *context){
    return agl_lexer_prior_token(context->tokenIterator);
}

void matchToken(agl_parse_ast_context_t *context, agl_token_type_t type){
    if (currentToken(context)->type != type){
        parseError("Esperado identificador");
    }
    nextToken(context);
}

bool isTokenType(agl_token_t *token, agl_token_type_t type){
    return token != NULL && token->type == type;
}

void emitVarDecls(agl_parse_ast_context_t *context) {

}

void emitFuncDecls(agl_parse_ast_context_t *context) {

}

void emitDecls(agl_parse_ast_context_t *context) {
//    matchToken(context, tkIdentifier);
//    if (context->currentNode->next->next->currentToken->type == tkOpenP){
//        emitFuncDecls(context);
//    }else{
//        emitVarDecls(context);
//    }
    return;
}

bool doStatement(agl_parse_ast_context_t *context) {
//    switch (context->currentNode->currentToken->type){
//        case tkIdentifier:
//            emitDecls(context);
//            break;
//    }
    return true;
}

agl_identifier_ast_t *identifier(agl_parse_ast_context_t *context) {
    return NULL;
}


agl_program_id_ast_t *programId(agl_parse_ast_context_t *context, agl_program_ast_t *programAST) {
    matchToken(context, tkProgram);
    agl_program_id_ast_t *programId = malloc(sizeof(agl_program_id_ast_t));
    programId->programName = identifier(context);
    return programId;
}

void interfaceDecl(agl_parse_ast_context_t *context) {
    matchToken(context, tkInterface);
}

void implementationDecl(agl_parse_ast_context_t *context) {
    matchToken(context, tkImplementation);
}

agl_program_body_ast_t *programBody(agl_parse_ast_context_t *context, agl_program_ast_t *programAST) {
    interfaceDecl(context);
    implementationDecl(context);
    return NULL;
}

void program(agl_parse_ast_context_t *context) {
    agl_program_ast_t *programAST = malloc(sizeof(agl_program_ast_t));
    context->ast = programAST;
    programAST->programId = programId(context, programAST);
    programAST->programBody = programBody(context, programAST);
}

agl_parse_ast_context_t *agl_parse_ast_create(agl_source_file_t *sourceFile){
    agl_parse_ast_context_t *context = malloc(sizeof(agl_parse_ast_context_t));
    context->lexer = agl_lexer_create(sourceFile);
    context->tokenIterator = agl_lexer_iterator_create(context->lexer);
    program(context);
    return context;
}

void agl_parse_ast_free(agl_parse_ast_context_t *context){
    agl_lexer_free(context->lexer);
    free(context);
}


