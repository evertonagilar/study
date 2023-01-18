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


#ifndef VMPROJ_AGL_DEFS_H
#define VMPROJ_AGL_DEFS_H

#include <stddef.h>
#include <glib.h>
#include <stdbool.h>

enum agl_identifier_type_t { id, ifsmnt, whilesmnt, forsmnt };

typedef struct {
    enum agl_identifier_type_t type;
    int hash;
    char *value;
} agl_identifier_t;

typedef enum {
    tkIf,
    tkElse,
    tkWhile,
    tkIdentifier,
    tkDot,
    tkPlus,
    tkMinus,
    tkMul,
    tkDiv,
    tkEqual,
    tkAssign,
    tkOpenP,
    tkCloseP,
    tkSemicolon,
    tkEof,
    tkVoid
} agl_token_type;

typedef struct {
    int hash;
    agl_identifier_t *identifier;
    agl_token_type type;
    char *value;
    int line;
} agl_token_t;

typedef struct {
    int size;
    agl_identifier_t *itens;
} agl_symbol_table_t;

typedef struct {
    char *src;              // pointer to source code string
    char *lookahead;        // pointer to next identifier
    int line;               // current line of scanner
    agl_symbol_table_t *symbolTable;
} agl_scanner_t;

typedef struct agl_parse_tree_node_t {
    agl_token_t *token;
    struct agl_parse_tree_node_t *next;
} agl_parse_tree_node_t;

typedef struct agl_parse_tree_t {
    agl_parse_tree_node_t *root;
    int childCount;
} agl_parse_tree_t;

typedef struct {
    agl_parse_tree_t *ast;
    agl_parse_tree_node_t *node;
} agl_parse_tree_visitor_t;

typedef struct {
    agl_scanner_t *scanner;
    agl_parse_tree_t *ast;
} agl_bytecode_t;

typedef struct {
    char *filename;                 // source filename
    size_t size;                    // size of file
} agl_source_file_t;

typedef struct {
    agl_source_file_t *sourceFile;      // source file of mainModule
    long *text;                         // text segment
    bool compiled;
    GList *imports;
    agl_bytecode_t *bytecode;
} agl_module_t;

typedef struct {
    agl_module_t *mainModule;
} agl_program_t;

// instructions
enum {
    LEA, IMM, JMP, CALL, JZ, JNZ, ENT, ADJ, LEV, LI, LC, SI, SC, PUSH,
    OR, XOR, AND, EQ, NE, LT, GT, LE, GE, SHL, SHR, ADD, SUB, MUL, DIV, MOD,
    OPEN, READ, CLOS, PRTF, MALC, MSET, MCMP, EXIT
};

typedef struct {
    agl_program_t *program;
    bool debug;
} agl_vm_t;

#endif //VMPROJ_AGL_DEFS_H
