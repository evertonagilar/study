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
#include "lee_lexer.h"
#include "lee_symbol_table.h"
#include <stdio.h>

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

bool is_eof_token(lee_parse_ast_context_t *context) {
    lee_token_t *token = get_current_token(context);
    return token->type != tkEof;
}

bool is_token_type_of(lee_token_t *token, lee_token_type_t type) {
    return token != NULL && token->type == type;
}

bool is_current_token_type_of(lee_parse_ast_context_t *context, lee_token_type_t type) {
    lee_token_t *token = get_current_token(context);
    return token != NULL && token->type == type;
}

lee_token_t *match_token(lee_parse_ast_context_t *context, lee_token_type_t type) {
    lee_token_t *token = get_token_and_next(context);
    if (!is_token_type_of(token, type)) {
        printf("Error: Sintáxe inválida, token esperado: %s mas encontrado %s\n", lee_token_text[type],
               lee_token_text[token->type]);
    }
    return token;
}

lee_token_t *match_token2(lee_parse_ast_context_t *context, lee_token_type_t type, lee_token_type_t type2) {
    lee_token_t *token = get_token_and_next(context);
    if (!(is_token_type_of(token, type) || is_token_type_of(token, type2))) {
        printf("Error: Sintáxe inválida, token esperado: %s ou %s mas encontrado %s\n",
               lee_token_text[type],
               lee_token_text[type2],
               lee_token_text[token->type]);
    }
    return token;
}

/////////////////////////////////////////////// AST ///////////////////////////////////////////////////////////////////

lee_identifier_ast_t *identifier(lee_parse_ast_context_t *context) {
    lee_token_t *token = match_token(context, tkIdentifier);
    lee_identifier_ast_t *identifierAST = malloc(sizeof(lee_identifier_ast_t));
    identifierAST->token = token;
    return identifierAST;
}

lee_qualified_name_ast_t *qualifiedName(lee_parse_ast_context_t *context) {
    lee_qualified_name_ast_t  *qualifiedNameAST = malloc(sizeof(lee_identifier_ast_t));
    qualifiedNameAST->identifiers = lee_linked_list_create();
    lee_identifier_ast_t *identifierAST;
    do{
        identifierAST = identifier(context);
        lee_linked_list_add(qualifiedNameAST->identifiers, identifierAST);
        if (is_current_token_type_of(context, tkDot)){
            match_token(context, tkDot);
        }else{
            break;
        }
    } while (true);
    match_token(context, tkSemicolon);
    return qualifiedNameAST;
}

lee_program_id_ast_t *program_id(lee_parse_ast_context_t *context, lee_program_ast_t *programAST) {
    lee_token_t *token = match_token2(context, tkModule, tkPackage);
    lee_program_id_ast_t *programId = malloc(sizeof(lee_program_id_ast_t));
    programId->qualifiedName = qualifiedName(context);
    programId->token = token;
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

void func_list_decl_tail(lee_parse_ast_context_t *context, lee_array_list_t *list) {
    tail_recursion:
    if (is_func_type_decl(context)) {
        lee_func_ast_t *func = malloc(sizeof(lee_func_ast_t));
        func->type = func_type_decl(context);
        func->identifier = identifier(context);
        match_token(context, tkLParen);
        match_token(context, tkRParen);
        match_token(context, tkSemicolon);
        lee_array_list_add(list, func);
        goto tail_recursion;
    }
}

lee_array_list_t *func_list_decl(lee_parse_ast_context_t *context) {
    lee_array_list_t *list = lee_array_list_create(30);
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
    lee_token_t *token = match_token(context, tkInterface);
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
 * Entry point
 *
 */
lee_program_ast_t *lee_program_ast_entry(lee_parse_ast_context_t *context) {
    lee_program_ast_t *programAST = malloc(sizeof(lee_program_ast_t));
    programAST->programId = program_id(context, programAST);
    programAST->programBody = program_body(context, programAST);
    return programAST;
}

///////////////////////////////////

lee_parse_ast_context_t *lee_parse_ast_create_context(lee_source_file_t *sourceFile) {
    lee_parse_ast_context_t *context = malloc(sizeof(lee_parse_ast_context_t));
    context->symbolTable = lee_symbol_table_create();
    context->lexer = lee_lexer_create(sourceFile, context->symbolTable);
    context->tokenIterator = lee_lexer_iterator_create(context->lexer);
    return context;
}

void lee_parse_ast_free_context(lee_parse_ast_context_t *context) {
    lee_lexer_free(context->lexer);
    lee_lexer_iterator_free(context->tokenIterator);
    lee_symbol_table_free(context->symbolTable);
    free(context);
}

lee_parse_ast_t *lee_parse_ast_create(lee_source_file_t *sourceFile) {
    lee_parse_ast_t *parseAST = malloc(sizeof(lee_parse_ast_t));
    parseAST->context = lee_parse_ast_create_context(sourceFile);
    parseAST->ast = lee_program_ast_entry(parseAST->context);
    return parseAST;
}

void lee_parse_ast_free(lee_parse_ast_t *parseAST) {
    lee_parse_ast_free_context(parseAST->context);
    free(parseAST);
}


