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

////////////////////////////////////////// Function support///////////////////////////////////////////////////////////

void parse_error(char *msg) {
    printf("Error: %s\n", msg);
    exit(EXIT_FAILURE);
}

agl_token_t *get_token_and_next(agl_parse_ast_context_t *context) {
    agl_token_t *token = agl_lexer_current_token(context->tokenIterator);
    agl_lexer_next_token(context->tokenIterator);
    return token;
}

agl_token_t *get_current_token(agl_parse_ast_context_t *context) {
    agl_token_t *token = agl_lexer_current_token(context->tokenIterator);
    return token;
}

bool is_token_type(agl_token_t *token, agl_token_type_t type) {
    return token != NULL && token->type == type;
}

agl_token_t *match_token(agl_parse_ast_context_t *context, agl_token_type_t type) {
    agl_token_t *token = get_token_and_next(context);
    if (!is_token_type(token, type)) {
        printf("Error: Sintáxe inválida, token esperado: %s mas encontrado %s\n", agl_token_text[type],
               agl_token_text[token->type]);
    }
    return token;
}


/////////////////////////////////////////////// AST ///////////////////////////////////////////////////////////////////

void emitVarDecls(agl_parse_ast_context_t *context) {

}

void emitFuncDecls(agl_parse_ast_context_t *context) {

}

void emitDecls(agl_parse_ast_context_t *context) {
//    match_token(context, tkIdentifier);
//    if (context->currentNode->next->next->get_current_token->type == tkOpenP){
//        emitFuncDecls(context);
//    }else{
//        emitVarDecls(context);
//    }
    return;
}

bool doStatement(agl_parse_ast_context_t *context) {
//    switch (context->currentNode->get_current_token->type){
//        case tkIdentifier:
//            emitDecls(context);
//            break;
//    }
    return true;
}

agl_identifier_ast_t *identifier(agl_parse_ast_context_t *context) {
    agl_token_t *token = match_token(context, tkIdentifier);
    agl_identifier_ast_t *identifierAST = malloc(sizeof(agl_identifier_ast_t));
    identifierAST->token = token;
    return identifierAST;
}


agl_program_id_ast_t *program_id(agl_parse_ast_context_t *context, agl_program_ast_t *programAST) {
    match_token(context, tkProgram);
    agl_program_id_ast_t *programId = malloc(sizeof(agl_program_id_ast_t));
    programId->programName = identifier(context);
    return programId;
}

bool is_func_type_decl(agl_parse_ast_context_t *context) {
    agl_token_t *token = get_current_token(context);
    switch (token->type) {
        case tkVoid :
            return true;
        case tkInt :
            return true;
        default:
            return false;
    }
}

agl_func_type_t func_type_decl(agl_parse_ast_context_t *context) {
    agl_token_t *token = get_current_token(context);
    switch (token->type) {
        case tkVoid :
            return ftVoid;
        case tkInt :
            return ftInt;
        default:
            parse_error("Type exptected");
    }
}

void func_list_decl_tail(agl_parse_ast_context_t *context, agl_list_t *list) {
    tail_recursion:
    if (is_func_type_decl(context)) {
        agl_func_ast_t *func = malloc(sizeof(agl_func_ast_t));
        func->type = func_type_decl(context);
        func->identifier = identifier(context);
        agl_list_add(list, func);
        goto tail_recursion;
    }
}

agl_list_t *func_list_decl(agl_parse_ast_context_t *context) {
    agl_list_t *list = agl_list_create(30);
    func_list_decl_tail(context, list);
    return list;
}

agl_interface_decl_ast_t *interface_decl(agl_parse_ast_context_t *context) {
    agl_token_t *token = match_token(context, tkInterface);
    agl_interface_decl_ast_t *interfaceDeclAST = malloc(sizeof(agl_interface_decl_ast_t));
    interfaceDeclAST->token = token;
    interfaceDeclAST->funcListDecl = func_list_decl(context);
    return interfaceDeclAST;
}

agl_implementation_decl_ast_t *implementation_decl(agl_parse_ast_context_t *context) {
    agl_token_t *token = match_token(context, tkImplementation);
    agl_implementation_decl_ast_t *implementationDeclAST = malloc(sizeof(agl_implementation_decl_ast_t));
    implementationDeclAST->token = token;
    return implementationDeclAST;
}

agl_program_body_ast_t *program_body(agl_parse_ast_context_t *context, agl_program_ast_t *programAST) {
    agl_program_body_ast_t *programBodyAST = malloc(sizeof(agl_program_body_ast_t));
    programBodyAST->interfaceDecl = interface_decl(context);
    programBodyAST->implementationDecl = implementation_decl(context);
    return programBodyAST;
}

/*
 * Início do AST em program
 *
 */
agl_program_ast_t *program(agl_parse_ast_context_t *context) {
    agl_program_ast_t *programAST = malloc(sizeof(agl_program_ast_t));
    programAST->programId = program_id(context, programAST);
    programAST->programBody = program_body(context, programAST);
    return programAST;
}

/////////////////////////////////////////////// AST ///////////////////////////////////////////////////////////////////

agl_parse_ast_context_t *agl_parse_ast_create_context(agl_source_file_t *sourceFile) {
    agl_parse_ast_context_t *context = malloc(sizeof(agl_parse_ast_context_t));
    context->lexer = agl_lexer_create(sourceFile);
    context->tokenIterator = agl_lexer_iterator_create(context->lexer);
    return context;
}

void agl_parse_ast_free_context(agl_parse_ast_context_t *context) {
    agl_lexer_free(context->lexer);
    agl_lexer_iterator_free(context->tokenIterator);
    free(context);
}

agl_parse_ast_t *agl_parse_ast_create(agl_source_file_t *sourceFile) {
    agl_parse_ast_context_t *context = agl_parse_ast_create_context(sourceFile);
    agl_parse_ast_t *parseAST = malloc(sizeof(agl_parse_ast_t));
    parseAST->ast = program(context);
    agl_parse_ast_free_context(context);
    return parseAST;
}

void agl_parse_ast_free(agl_parse_ast_t *parseAST) {
    free(parseAST);
}


