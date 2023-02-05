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

#include "lee_hash_table.h"
#include "lee_list.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

lee_hash_table_t *lee_hash_table_create(int capacity){
    lee_hash_table_t *table = malloc(sizeof(lee_hash_table_t*));
    table->itens = calloc(capacity, sizeof(lee_hash_table_t*));
    table->capacity = capacity;
    table->count = 0;
    table->colisionCount = 0;
    return table;
}

int lee_hash_compute_hash(lee_hash_table_t *table, char *key, int key_sz){
    int i = 0;
    for (int j = 0; j < key_sz; j++){
        i += key[j];
    }
    int hash = i % table->capacity;
    return hash;
}

lee_hash_entry_t *lee_hash_create_entry(int hash, char *key, int key_sz, void *pData){
    lee_hash_entry_t *item = malloc(sizeof(lee_hash_entry_t));
    item->key = key;
    item->key_sz = key_sz;
    item->hash = hash;
    item->pDataOrList = pData;
}

void lee_hash_free_entry(lee_hash_entry_t *pItem ) {
    free(pItem);
}

void *lee_hash_table_get_pentry(lee_hash_table_t *table, int hash){
    lee_hash_entry_t **item = table->itens + hash;
    return item;
}

void *lee_hash_table_get(lee_hash_table_t *table, char *key, int key_sz){
    int hash = lee_hash_compute_hash(table, key, key_sz);
    lee_hash_entry_t **pItem = table->itens + hash;
    if (*pItem != NULL) {
        if ((*pItem)->hasColision){
            lee_list_iterator_t *it = lee_list_iterator_create((*pItem)->pDataOrList);
            lee_hash_entry_t *pItemTmp;
            void *pData;
            while (pItemTmp = lee_list_iterator_next(it)){
                if (pItemTmp->key_sz == key_sz && strncmp(pItemTmp->key, key, key_sz) == 0){
                    return pItemTmp->pDataOrList;
                }
            }
        }else{
            return (*pItem)->pDataOrList;
        }
    }else{
        return NULL;
    }
}

void lee_hash_table_push(lee_hash_table_t *table, char *key, int key_sz, void *pData){
    int hash = lee_hash_compute_hash(table, key, key_sz);
    lee_hash_entry_t **pItem = lee_hash_table_get_pentry(table, hash);
    table->count++;
    // pItem já está ocupado, vai haver um colisão?
    if (*pItem != NULL){
        lee_list_t *dataList;
        // Como pItem já ocupado, hasColision pode ser true caso (*pItem)->pDataOrList for lista (já vou colisão anteriormente para essa hash).
        // Se hasColision é false, temos que:
        //      - criar uma lista (vai ocorrer colisão agora),
        //      - migrar pData atual para a lista
        //      -  e também adicionar o novo pData na lista.
        //      - Por fim, (*pItem)->pDataOrList passa apontar para essa nova lista.
        // Obs.: Push subsequentes com o mesmo hash só vão adicionando itens na lista.
        if ((*pItem)->hasColision){
            dataList = (*pItem)->pDataOrList;
        }else {
            dataList = lee_list_create(10);
            lee_list_add(dataList, lee_hash_create_entry(hash, (*pItem)->key, (*pItem)->key_sz, (*pItem)->pDataOrList)); // migra o primeiro elemento desta hash na lista
            (*pItem)->pDataOrList = dataList;   // agora (*pItem)->pDataOrList é uma lista
            (*pItem)->hasColision = true;       // sinaliza que houve colisão
        }
        lee_list_add(dataList, lee_hash_create_entry(hash, key, key_sz, pData)); // Add pData que colidiu como um novo lee_hash_entry_t*
        table->colisionCount++;
    }else {
        *pItem = lee_hash_create_entry(hash, key, key_sz, pData);
    }
}

void lee_hash_table_free(lee_hash_table_t *table){
    lee_hash_entry_t **pItem;
    if (table->count > 0) {
        for (int i = 0; i < table->capacity; i++) {
            pItem = table->itens + i;
            if (*pItem != NULL) {
                if ((*pItem)->hasColision){
                    lee_list_iterator_t *it = lee_list_iterator_create((*pItem)->pDataOrList);
                    lee_hash_entry_t *pItemTmp;
                    while (pItemTmp = lee_list_iterator_next(it)){
                        lee_hash_free_entry(pItemTmp);
                    }
                    lee_list_free((*pItem)->pDataOrList);
                    lee_list_iterator_free(it);
                }else{
                    lee_hash_free_entry((*pItem)->pDataOrList);
                }
            }
        }
    }
    free(table);
}

void lee_hash_table_test() {
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
}