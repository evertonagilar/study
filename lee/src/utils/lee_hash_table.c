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
#include "lee_array_list.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <assert.h>


/* lee_hash_table */

lee_hash_table_t *lee_hash_table_create(int capacity){
    assert(capacity > 0);
    lee_hash_table_t *table = malloc(sizeof(lee_hash_table_t));
    table->hash_tbl = calloc(capacity, sizeof(lee_hash_table_t*));
    table->list = lee_linked_list_create();
    table->capacity = capacity;
    table->count = 0;
    table->colisionCount = 0;
    return table;
}

int lee_hash_compute_hash_code(lee_hash_table_t *table, char *key, int key_sz){
    int i = 0;
    for (int j = 0; j < key_sz; j++){
        i += key[j];
    }
    int hash = i % table->capacity;
    return hash;
}

lee_hash_entry_t *lee_hash_table_create_entry(int hash, char *key, int key_sz, void *pData){
    lee_hash_entry_t *item = malloc(sizeof(lee_hash_entry_t));
    item->key = key;
    item->key_sz = key_sz;
    item->hash = hash;
    item->pDataOrList = pData;
}

void lee_hash_table_free_entry(lee_hash_entry_t *pItem ) {
    free(pItem);
}

void *lee_hash_table_get_pentry(lee_hash_table_t *table, int hash){
    lee_hash_entry_t **item = table->hash_tbl + hash;
    return item;
}

void *lee_hash_table_get(lee_hash_table_t *table, char *key, int key_sz){
    int hashCode = lee_hash_compute_hash_code(table, key, key_sz);
    lee_hash_entry_t **pItem = table->hash_tbl + hashCode;
    if (*pItem != NULL) {
        // Se tem colisão, tem que procurar na lista encadeada em (*pItem)->pDataOrList
        if ((*pItem)->hasColision){
            lee_array_list_iterator_t *it = lee_array_list_iterator_create((*pItem)->pDataOrList);
            lee_hash_entry_t *pItemTmp;
            void *pData;
            while (pItemTmp = lee_array_list_iterator_next(it)){
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
    int hashCode = lee_hash_compute_hash_code(table, key, key_sz);
    lee_hash_entry_t *newEntry = lee_hash_table_create_entry(hashCode, key, key_sz, pData);
    lee_hash_entry_t **pItem = lee_hash_table_get_pentry(table, hashCode);
    table->count++;
    // Houve colisão e mais de um dado vai ser armazenado nesta entrada por meio de uma lista encadeada
    if (*pItem != NULL){
        lee_array_list_t *dataList;
        // Se hasColision é false, temos que:
        //      - criar uma lista (vai ocorrer colisão agora),
        //      - migrar pData atual para a lista
        //      -  e também adicionar o novo pData na lista.
        //      - Por fim, (*pItem)->pDataOrList passa apontar para essa nova lista.
        // Obs.: Push subsequentes com o mesmo hashCode só vão adicionando hash_table na lista.
        if ((*pItem)->hasColision){
            dataList = (*pItem)->pDataOrList;
        }else {
            dataList = lee_array_list_create(10);
            // migra o primeiro elemento desta hashCode para a lista da entrada
            lee_array_list_add(dataList,
                               lee_hash_table_create_entry(hashCode, (*pItem)->key, (*pItem)->key_sz,
                                                           (*pItem)->pDataOrList));
            (*pItem)->pDataOrList = dataList;   // agora (*pItem)->pDataOrList é uma lista
            (*pItem)->hasColision = true;       // sinaliza que houve colisão
        }
        lee_array_list_add(dataList, newEntry); // Add pData que colidiu como um novo lee_hash_entry_t*
        table->colisionCount++;
    }else {
        *pItem = newEntry;
    }
    lee_linked_list_add(table->list, newEntry);
}

int lee_hash_table_count(lee_hash_table_t *table){
    return table->count;
}

void lee_hash_table_free(lee_hash_table_t *table){
    if (table->count > 0) {
        lee_hash_table_iterator_t *it = lee_hash_table_reverse_iterator_create(table);
        lee_hash_entry_t *item;
        while (item = lee_hash_table_iterator_next(it)) {
            // Se houve colisão vamos ter que liberar a lista encadeada dos elementos do item
            if (item->hasColision) {
                lee_array_list_iterator_t *iteratorItem = lee_array_list_iterator_create(item->pDataOrList);
                lee_hash_entry_t *pItemTmp;
                while (pItemTmp = lee_array_list_iterator_next(iteratorItem)) {
                    lee_hash_table_free_entry(pItemTmp);
                }
                lee_array_list_free(item->pDataOrList);
                lee_array_list_iterator_free(iteratorItem);
            } else { // senão basta liberar o lee_hash_entry_t
                lee_hash_table_free_entry(item);
            }
        }
    }
    free(table->hash_tbl);
    lee_linked_list_free(table->list);
    free(table);
}


/* iterator */

lee_hash_table_iterator_t *lee_hash_table_iterator_create(lee_hash_table_t *table){
    lee_hash_table_iterator_t *it = malloc(sizeof(lee_hash_table_iterator_t));
    it->iterator = lee_linked_list_iterator_create(table->list);
    return it;
}

lee_hash_table_iterator_t *lee_hash_table_reverse_iterator_create(lee_hash_table_t *table){
    lee_hash_table_iterator_t *it = malloc(sizeof(lee_hash_table_iterator_t));
    it->iterator = lee_linked_list_reverse_iterator_create(table->list);
    return it;
}

void lee_hash_table_iterator_free(lee_hash_table_iterator_t *iterator){
    lee_linked_list_iterator_free(iterator->iterator);
    free(iterator);
}

bool lee_hash_table_iterator_has_next(lee_hash_table_iterator_t *iterator){
    return lee_linked_list_iterator_has_next(iterator->iterator);
}

void *lee_hash_table_iterator_next(lee_hash_table_iterator_t  *iterator){
    return lee_linked_list_iterator_next(iterator->iterator);
}

void *lee_hash_table_iterator_current(lee_hash_table_iterator_t *iterator){
    return lee_linked_list_iterator_current(iterator->iterator);
}

void lee_hash_table_test() {
    printf("\n\nTeste hash table\n");

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

    printf("\nnúmero de chaves: %d\n", table->count);
    printf("número de colisões: %d\n", table->colisionCount);

    printf("Imprime tokens:\n");
    lee_hash_table_iterator_t *it = lee_hash_table_iterator_create(table);
    char *str;
    while (str = lee_hash_table_iterator_next(it)){
        printf("Token: %s\n", str);
    }
    lee_hash_table_iterator_free(it);

    lee_hash_table_free(table);
}