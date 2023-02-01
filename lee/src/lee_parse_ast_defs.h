//
// Created by evertonagilar on 24/01/23.
//

#ifndef VMPROJ_AGL_PARSE_AST_DEFS_H
#define VMPROJ_AGL_PARSE_AST_DEFS_H

/*
 * Parse AST structs
 *
 */

typedef struct {
    lee_token_t *token;
} lee_identifier_ast_t;

typedef struct {
    lee_identifier_ast_t *programName;
} lee_program_id_ast_t;


typedef struct {
    lee_token_type_t type;
    lee_identifier_ast_t *identifier;
} lee_func_ast_t;

typedef struct {
    lee_token_t *token;
    lee_list_t *funcListDecl;
} lee_interface_decl_ast_t;

typedef struct {
    lee_token_t *token;
    lee_list_t funcListDecl;
} lee_implementation_decl_ast_t;

typedef struct {
    lee_interface_decl_ast_t *interfaceDecl;
    lee_implementation_decl_ast_t *implementationDecl;
} lee_program_body_ast_t;

typedef struct {
    lee_program_id_ast_t *programId;
    lee_program_body_ast_t *programBody;
} lee_program_ast_t;

#endif //VMPROJ_AGL_PARSE_AST_DEFS_H
