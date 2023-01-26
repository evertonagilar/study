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
    agl_token_t *token;
} agl_identifier_ast_t;

typedef struct {
    agl_identifier_ast_t *programName;
} agl_program_id_ast_t;

typedef struct {
    agl_token_t *token;
} agl_interface_decl_ast_t;

typedef struct {
    agl_token_t *token;
} agl_implementation_decl_ast_t;

typedef struct {
    agl_interface_decl_ast_t *interfaceDecl;
    agl_implementation_decl_ast_t *implementationDecl;
} agl_program_body_ast_t;

typedef struct {
    agl_program_id_ast_t *programId;
    agl_program_body_ast_t *programBody;
} agl_program_ast_t;

#endif //VMPROJ_AGL_PARSE_AST_DEFS_H
