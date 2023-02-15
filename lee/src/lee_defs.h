/*
 * %CopyrightBegin%
 *
 * Copyright Everton de Vargas Agilar 2022. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License",
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


#ifndef LEE_DEFS_H
#define LEE_DEFS_H

#include <stddef.h>
#include <glib.h>
#include <stdbool.h>
#include "utils/lee_array_list.h"
#include "utils/lee_hash_table.h"

static char *lee_token_text[] = {
        // Keywords and types
        "abstract",
        "assert",
        "boolean",
        "break",
        "byte",
        "case",
        "catch",
        "char",
        "class",
        "const",
        "continue",
        "default",
        "do",
        "double",
        "else",
        "enum",
        "exports",
        "extends",
        "final",
        "finally",
        "float",
        "for",
        "if",
        "goto",
        "implements",
        "import",
        "instanceof",
        "int",
        "interface",
        "long",
        "module",
        "native",
        "new",
        "package",
        "private",
        "protected",
        "public",
        "return",
        "short",
        "static",
        "super",
        "switch",
        "synchronized",
        "this",
        "throw",
        "throws",
        "to",
        "try",
        "void",
        "while",
        "with",
        "_",

        // Identifier
        "identifier",

        // Null Literal
        "null",

        // Separators
        "(",
        ")",
        "{",
        "}",
        "[",
        "]",
        ";",
        ",",
        ".",

        // Operators
        "=",
        ">",
        "<",
        "!",
        "~",
        "?",
        ":",
        "==",
        "<=",
        ">=",
        "!=",
        "&&",
        "||",
        "++",
        "--",
        "+",
        "-",
        "*",
        "/",
        "%",

        // Eof
        "\0"
};

typedef enum lee_symbol_class_t {
    scIdentifier,
    scLiteral,
    scKeyword,
    scType,
    scSeparator,
    scOperator
} lee_symbol_class_t;

typedef enum{
    // Keywords and types
    tkAbstract,
    tkAssert,
    tkBoolean,
    tkBreak,
    tkByte,
    tkCase,
    tkCatch,
    tkChar,
    tkClass,
    tkConst,
    tkContinue,
    tkDefault,
    tkDo,
    tkDouble,
    tkElse,
    tkEnum,
    tkExports,
    tkExtends,
    tkFinal,
    tkFinally,
    tkFloat,
    tkFor,
    tkIf,
    tkGoto,
    tkImplements,
    tkImport,
    tkInstanceOf,
    tkInt,
    tkInterface,
    tkLong,
    tkModule,
    tkNative,
    tkNew,
    tkPackage,
    tkPrivate,
    tkProtected,
    tkPublic,
    tkReturn,
    tkShort,
    tkStatic,
    tkSuper,
    tkSwitch,
    tkSynchronized,
    tkThis,
    tkThrow,
    tkThrows,
    tkTo,
    tkTry,
    tkVoid,
    tkWhile,
    tkWith,
    tkUnderscore,

    tkIdentifier,

    // Literal
    tkNull,

    // Separators
    tkLParen,
    tkRParen,
    tkLBrace,
    tkRBrace,
    tkLBrack,
    tkRBrack,
    tkSemicolon,
    tkComma,
    tkDot,

    // Operators
    tkAssign,
    tkGT,
    tkLT,
    tkBang,
    tkTilde,
    tkQuestion,
    tkColon,
    tkEqual,
    tkLE,
    tkGE,
    tkNotEqual,
    tkAnd,
    tkOr,
    tkInc,
    tkDec,
    tkAdd,
    tkSub,
    tkMul,
    tkDiv,
    tkMod,

    tkEof
} lee_token_type_t;

typedef struct {
    lee_symbol_class_t symbolClass;
    lee_token_type_t tokenType;
    char *name;
    int name_sz;
} lee_symbol_t;

typedef struct {
    lee_symbol_t *symbol;
    lee_token_type_t type;
    int line;
} lee_token_t;

typedef struct {
    lee_hash_table_t *hash_table;
} lee_symbol_table_t;

typedef struct {
    char *src;              // pointer to source code string
    char *lookahead;        // pointer to _next symbol
    int line;               // currentNode line of scanner
    lee_symbol_table_t *symbolTable;    // pointer to scanner
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

typedef struct {
    char *filename;                 // source filename
    size_t size;                    // count of file
    char *stream;                   // stream of file
} lee_source_file_t;


/*
 * Parse AST structs
 *
 */


typedef struct {
    lee_token_t *token;
} lee_identifier_ast_t;

typedef struct {
    lee_linked_list_t *identifiers;
}lee_qualified_name_ast_t;

typedef struct {
    lee_token_t *token;  // tkModule or tkPackage
    lee_qualified_name_ast_t *qualifiedName;
} lee_program_id_ast_t;


typedef struct {
    lee_token_type_t type;
    lee_identifier_ast_t *identifier;
} lee_func_ast_t;

typedef struct {
    lee_token_t *token;
    lee_array_list_t *funcListDecl;
} lee_interface_decl_ast_t;

typedef struct {
    lee_token_t *token;
    lee_array_list_t funcListDecl;
} lee_implementation_decl_ast_t;

typedef struct {
    lee_interface_decl_ast_t *interfaceDecl;
    lee_implementation_decl_ast_t *implementationDecl;
} lee_program_body_ast_t;

typedef struct {
    lee_program_id_ast_t *programId;
    lee_program_body_ast_t *programBody;
} lee_program_ast_t;

/*
 * lee_parse_ast_context_t é um objeto de contexto utilizado durante a construção da árvore sintática
 *
 */
typedef struct {
    lee_lexer_t *lexer;
    lee_lexer_iterator_t *tokenIterator;
    lee_program_ast_t *ast;
    lee_symbol_table_t *symbolTable;
} lee_parse_ast_context_t;

typedef struct {
    lee_parse_ast_context_t *context;
    lee_program_ast_t *ast;
} lee_parse_ast_t;


/*
 * Loader
 *
 */

typedef struct {
    lee_source_file_t *sourceFile;      // source file of mainModule
    long *text;                         // text segment
    bool compiled;
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

#endif //LEE_DEFS_H
