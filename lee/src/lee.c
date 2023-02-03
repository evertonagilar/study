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

#include <stdio.h>
#include "lee_vm.h"
#include "lee_defs.h"
#include "lee_hash_table.h"

int main(int argc, char **argv) {
    printf("Lee -> The Samurai Programing Language\n");

    lee_hash_table_t *table = lee_hash_table_create(1000);

    lee_hash_table_push(table, "abstract", strlen("abstract"), "abstract");
    lee_hash_table_push(table, "assert", strlen("assert"), "assert");
    lee_hash_table_push(table, "boolean", strlen("boolean"), "boolean");
    lee_hash_table_push(table, "break", strlen("break"), "break");
    lee_hash_table_push(table, "byte", strlen("byte"), "byte");
    lee_hash_table_push(table, "case", strlen("case"), "case");
    lee_hash_table_push(table, "catch", strlen("catch"), "catch");
    lee_hash_table_push(table, "char", strlen("char"), "char");
    lee_hash_table_push(table, "class", strlen("class"), "class");
    lee_hash_table_push(table, "const", strlen("const"), "const");
    lee_hash_table_push(table, "continue", strlen("continue"), "continue");
    lee_hash_table_push(table, "default", strlen("default"), "default");
    lee_hash_table_push(table, "do", strlen("do"), "do");
    lee_hash_table_push(table, "double", strlen("double"), "double");
    lee_hash_table_push(table, "else", strlen("else"), "else");
    lee_hash_table_push(table, "enum", strlen("enum"), "enum");
    lee_hash_table_push(table, "exports", strlen("exports"), "exports");
    lee_hash_table_push(table, "final", strlen("final"), "final");
    lee_hash_table_push(table, "finally", strlen("finally"), "finally");
    lee_hash_table_push(table, "float", strlen("float"), "float");  // colide com class
    lee_hash_table_push(table, "for", strlen("for"), "for");
    lee_hash_table_push(table, "if", strlen("if"), "if");
    lee_hash_table_push(table, "goto", strlen("goto"), "goto");
    lee_hash_table_push(table, "implements", strlen("implements"), "implements");
    lee_hash_table_push(table, "import", strlen("import"), "import");
    lee_hash_table_push(table, "instanceof", strlen("instanceof"), "instanceof");
    lee_hash_table_push(table, "int", strlen("int"), "int");
    lee_hash_table_push(table, "interface", strlen("interface"), "interface");
    lee_hash_table_push(table, "long", strlen("long"), "long");
    lee_hash_table_push(table, "module", strlen("module"), "module");
    lee_hash_table_push(table, "native", strlen("native"), "native");
    lee_hash_table_push(table, "new", strlen("new"), "new");
    lee_hash_table_push(table, "package", strlen("package"), "package");
    lee_hash_table_push(table, "private", strlen("private"), "private");
    lee_hash_table_push(table, "protected", strlen("protected"), "protected");
    lee_hash_table_push(table, "provides", strlen("provides"), "provides");
    lee_hash_table_push(table, "public", strlen("public"), "public");
    lee_hash_table_push(table, "short", strlen("short"), "short");
    lee_hash_table_push(table, "static", strlen("static"), "static");
    lee_hash_table_push(table, "super", strlen("super"), "super");
    lee_hash_table_push(table, "switch", strlen("switch"), "switch");  // colide com assert
    lee_hash_table_push(table, "synchronized", strlen("synchronized"), "synchronized");
    lee_hash_table_push(table, "this", strlen("this"), "this");
    lee_hash_table_push(table, "throw", strlen("throw"), "throw");
    lee_hash_table_push(table, "throws", strlen("throws"), "throws");
    lee_hash_table_push(table, "to", strlen("to"), "to");
    lee_hash_table_push(table, "try", strlen("try"), "try");
    lee_hash_table_push(table, "void", strlen("void"), "void");
    lee_hash_table_push(table, "while", strlen("while"), "while");
    lee_hash_table_push(table, "with", strlen("with"), "with");

    lee_hash_table_push(table, "(", strlen("("), "(");
    lee_hash_table_push(table, ")", strlen(")"), ")");
    lee_hash_table_push(table, "{", strlen("{"), "{");
    lee_hash_table_push(table, "}", strlen("}"), "}");

    lee_hash_table_push(table, "=", strlen("="), "=");
    lee_hash_table_push(table, ">", strlen(">"), ">");
    lee_hash_table_push(table, "<", strlen("<"), "<");


    char *token = lee_hash_table_get(table, "this", strlen("this"));
    token = lee_hash_table_get(table, "float", strlen("float"));
    token = lee_hash_table_get(table, "class", strlen("class"));
    token = lee_hash_table_get(table, "assert", strlen("assert"));
    token = lee_hash_table_get(table, "=", strlen("="));
    token = lee_hash_table_get(table, "<", strlen("<"));
    token = lee_hash_table_get(table, "}", strlen("}"));
    token = lee_hash_table_get(table, "public", strlen("public"));

    printf("número de chaves: %d\n", table->count);
    printf("número de colisões: %d\n", table->colisionCount);

    lee_hash_table_free(table);

    exit(1);

    if (argc < 2) {
        printf("Usage: lee <file.lee>\n");
        return -1;
    }

    char *programFileName = argv[1];
    lee_vm_t *vm = lee_vm_create(programFileName, true);
    lee_vm_free(vm);

    return 0;
}
