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

#include "lee_parse_ast.h"

////////////////////////////////////////// Function support///////////////////////////////////////////////////////////

void parse_error(char *msg) {
    printf("Error: %s\n", msg);
    exit(EXIT_FAILURE);
}

lee_token_t *get_token_and_next(lee_parse_ast_context_t *context) {
    lee_token_t *token = lee_lexer_current_token(context->tokenIterator);
    lee_lexer_next_token(context->tokenIterator);
    return token;
}

lee_token_t *get_current_token(lee_parse_ast_context_t *context) {
    lee_token_t *token = lee_lexer_current_token(context->tokenIterator);
    return token;
}

bool is_token_type(lee_token_t *token, lee_token_type_t type) {
    return token != NULL && token->type == type;
}

lee_token_t *match_token(lee_parse_ast_context_t *context, lee_token_type_t type) {
    lee_token_t *token = get_token_and_next(context);
    if (!is_token_type(token, type)) {
        printf("Error: Sintáxe inválida, token esperado: %s mas encontrado %s\n", lee_token_text[type],
               lee_token_text[token->type]);
    }
    return token;
}


/////////////////////////////////////////////// AST ///////////////////////////////////////////////////////////////////

void emitVarDecls(lee_parse_ast_context_t *context) {

}

void emitFuncDecls(lee_parse_ast_context_t *context) {

}

void emitDecls(lee_parse_ast_context_t *context) {
//    match_token(context, tkIdentifier);
//    if (context->currentNode->next->next->get_current_token->type == tkOpenP){
//        emitFuncDecls(context);
//    }else{
//        emitVarDecls(context);
//    }
    return;
}

bool doStatement(lee_parse_ast_context_t *context) {
//    switch (context->currentNode->get_current_token->type){
//        case tkIdentifier:
//            emitDecls(context);
//            break;
//    }
    return true;
}

lee_identifier_ast_t *identifier(lee_parse_ast_context_t *context) {
    lee_token_t *token = match_token(context, tkIdentifier);
    lee_identifier_ast_t *identifierAST = malloc(sizeof(lee_identifier_ast_t));
    identifierAST->token = token;
    return identifierAST;
}


lee_program_id_ast_t *program_id(lee_parse_ast_context_t *context, lee_program_ast_t *programAST) {
    match_token(context, tkProgram);
    lee_program_id_ast_t *programId = malloc(sizeof(lee_program_id_ast_t));
    programId->programName = identifier(context);
    return programId;
}

bool is_func_type_decl(lee_parse_ast_context_t *context) {
    lee_token_t *token = get_current_token(context);
    switch (token->type) {
        case tkVoid :
        case tkInt :
        case tkChar:
        case tkEnum:
            return true;
        default:
            return false;
    }
}

lee_token_type_t func_type_decl(lee_parse_ast_context_t *context) {
    lee_token_t *token = get_token_and_next(context);
    return token->type;
}

void func_list_decl_tail(lee_parse_ast_context_t *context, lee_list_t *list) {
    tail_recursion:
    if (is_func_type_decl(context)) {
        lee_func_ast_t *func = malloc(sizeof(lee_func_ast_t));
        func->type = func_type_decl(context);
        func->identifier = identifier(context);
        match_token(context, tkOpenP);
        match_token(context, tkCloseP);
        match_token(context, tkSemicolon);
        lee_list_add(list, func);
        goto tail_recursion;
    }
}

lee_list_t *func_list_decl(lee_parse_ast_context_t *context) {
    lee_list_t *list = lee_list_create(30);
    func_list_decl_tail(context, list);
    return list;
}

lee_interface_decl_ast_t *interface_decl(lee_parse_ast_context_t *context) {
    lee_token_t *token = match_token(context, tkInterface);
    lee_interface_decl_ast_t *interfaceDeclAST = malloc(sizeof(lee_interface_decl_ast_t));
    interfaceDeclAST->token = token;
    interfaceDeclAST->funcListDecl = func_list_decl(context);
    return interfaceDeclAST;
}

lee_implementation_decl_ast_t *implementation_decl(lee_parse_ast_context_t *context) {
    lee_token_t *token = match_token(context, tkImplementation);
    lee_implementation_decl_ast_t *implementationDeclAST = malloc(sizeof(lee_implementation_decl_ast_t));
    implementationDeclAST->token = token;
    return implementationDeclAST;
}

lee_program_body_ast_t *program_body(lee_parse_ast_context_t *context, lee_program_ast_t *programAST) {
    lee_program_body_ast_t *programBodyAST = malloc(sizeof(lee_program_body_ast_t));
    programBodyAST->interfaceDecl = interface_decl(context);
    programBodyAST->implementationDecl = implementation_decl(context);
    return programBodyAST;
}

/*
 * Início do AST em program
 *
 */
lee_program_ast_t *program(lee_parse_ast_context_t *context) {
    lee_program_ast_t *programAST = malloc(sizeof(lee_program_ast_t));
    programAST->programId = program_id(context, programAST);
    programAST->programBody = program_body(context, programAST);
    return programAST;
}

/////////////////////////////////////////////// AST ///////////////////////////////////////////////////////////////////

lee_parse_ast_context_t *lee_parse_ast_create_context(lee_source_file_t *sourceFile) {
    lee_parse_ast_context_t *context = malloc(sizeof(lee_parse_ast_context_t));
    context->lexer = lee_lexer_create(sourceFile);
    context->tokenIterator = lee_lexer_iterator_create(context->lexer);
    return context;
}

void lee_parse_ast_free_context(lee_parse_ast_context_t *context) {
    lee_lexer_free(context->lexer);
    lee_lexer_iterator_free(context->tokenIterator);
    free(context);
}

lee_parse_ast_t *lee_parse_ast_create(lee_source_file_t *sourceFile) {
    lee_parse_ast_context_t *context = lee_parse_ast_create_context(sourceFile);
    lee_parse_ast_t *parseAST = malloc(sizeof(lee_parse_ast_t));
    parseAST->ast = program(context);
    lee_parse_ast_free_context(context);
    return parseAST;
}

void lee_parse_ast_free(lee_parse_ast_t *parseAST) {
    free(parseAST);
}


