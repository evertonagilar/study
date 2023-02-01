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

static char *lee_token_text[] = {
        "program",
        "char",
        "else",
        "enum",
        "if",
        "int",
        "return",
        "sizeof",
        "while",
        "void",
        "identifier",
        "interface",
        "implementation",
        ".",
        "+",
        "-",
        "*",
        "/",
        "==",
        "=",
        "(",
        ")",
        ";",
        "\n"
};

typedef enum lee_symbol_class_t {
    scIdentifier,
    scKeyword,
    scType
} lee_symbol_class_t;

typedef enum{
    tkProgram,
    tkChar,
    tkElse,
    tkEnum,
    tkIf,
    tkInt,
    tkReturn,
    tkSizeOf,
    tkWhile,
    tkVoid,
    tkIdentifier,
    tkInterface,
    tkImplementation,
    tkDot,
    tkPlus,
    tkMinus,
    tkMul,
    tkDiv,
    tkEqual,
    tkAssign,
    tkOpenP,
    tkCloseP,
    tkOpenK,
    tkCloseK,
    tkSemicolon,
    tkEof
} lee_token_type_t;

typedef struct {
    lee_symbol_class_t symbolClass;
    lee_token_type_t tokenType;
    int hash;
    char *name;
} lee_symbol_t;

typedef struct {
    int hash;
    lee_symbol_t *symbol;
    lee_token_type_t type;
    int line;
} lee_token_t;

typedef struct {
    int count;
    lee_symbol_t *itens;
} lee_scanner_symbol_table_t;

typedef struct {
    char *src;              // pointer to source code string
    char *lookahead;        // pointer to next symbol
    int line;               // currentNode line of scanner
    lee_scanner_symbol_table_t *symbolTable;
} lee_scanner_t;

typedef struct lee_lexer_node_t {
    lee_token_t *token;
    struct lee_lexer_node_t *next;
} lee_lexer_node_t;

typedef struct lee_lexer_t {
    lee_scanner_t *scanner;
    lee_lexer_node_t *root;
    int childCount;
} lee_lexer_t;

typedef struct {
    lee_lexer_t *lexer;
    lee_lexer_node_t *currentNode;
    lee_lexer_node_t *priorNode;
} lee_lexer_iterator_t;

#include "lee_parse_ast_defs.h"

/*
 * lee_parse_ast_context_t é um objeto de contexto passado durante a construção do parse
 * para dar acesso ao analisador léxico.
 *
 */
typedef struct {
    lee_lexer_t *lexer;
    lee_lexer_iterator_t *tokenIterator;
    lee_program_ast_t *ast;
} lee_parse_ast_context_t;

typedef struct {
    lee_program_ast_t *ast;
} lee_parse_ast_t;

typedef struct {
    char *filename;                 // source filename
    size_t size;                    // count of file
    char *stream;                   // stream of file
} lee_source_file_t;

typedef struct {
    lee_source_file_t *sourceFile;      // source file of mainModule
    long *text;                         // text segment
    bool compiled;
    GList *imports;
    lee_parse_ast_t *parseAST;
} lee_module_t;

typedef struct {
    lee_module_t *mainModule;
} lee_program_t;

// instructions
enum {
    LEA, IMM, JMP, CALL, JZ, JNZ, ENT, ADJ, LEV, LI, LC, SI, SC, PUSH,
    OR, XOR, AND, EQ, NE, LT, GT, LE, GE, SHL, SHR, ADD, SUB, MUL, DIV, MOD,
    OPEN, READ, CLOS, PRTF, MALC, MSET, MCMP, EXIT
};

typedef struct {
    lee_program_t *program;
    bool debug;
} lee_vm_t;

#endif //VMPROJ_AGL_DEFS_H
