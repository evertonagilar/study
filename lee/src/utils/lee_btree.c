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


#include <malloc.h>
#include "lee_btree.h"


/*
 *
 * Ua árvore B de ordem m é uma árvore que satisfaz as seguintes propriedades:
 *        Cada nó tem no máximo m filhos.
 *        Cada nó interno, exceto a raiz, tem pelo menos childrenCount/2 filhos.
 *        Cada nó não folha tem pelo menos dois filhos.
 *        Todas as folhas aparecem no mesmo nível e não carregam nenhuma informação.
 *        Um nó não folha com k filhos contém k −1 chaves.
 *
 *
 */


// ********************************** private functions **********************************

/*
 * Cria um novo currentNode com childrenCount childrens
 *
 */
lee_btree_page_t *btree_page_new(int m) {
    lee_btree_page_t * new_page = malloc(sizeof (lee_btree_page_t));
    new_page->childrenCount = m;
    new_page->is_leaf = true;
    return new_page;
}

/*
 *
 * Cria a btree
 *
 */
lee_btree_t *lee_btree_new(){
    lee_btree_t * btree = malloc(sizeof (lee_btree_t));
    btree->root = btree_page_new(0);
    btree->count = 0;
    btree->height = 0;
    return btree;
}


lee_btree_key_entry_t *btree_key_entry_new(int key){
    lee_btree_key_entry_t *entry = malloc(sizeof(lee_btree_key_entry_t));
    entry->key = key;
    return entry;
}

/*
 *
 *
 */
btree_page_split_t *btree_page_split(lee_btree_page_t *page){
    btree_page_split_t *result = malloc(sizeof(btree_page_split_t));
    result->left = btree_page_new(page->childrenCount / 2 - 1);  // subtrai 1 porque a maior key do lado esquerdo é promovida
    result->right = btree_page_new(page->childrenCount / 2);
    result->key_do_meio = page->keys[page->childrenCount / 2 - 1];

    // Copia as keys menores que key_do_meio para left
    for (int i = 0; i < page->childrenCount / 2 - 1; i++){
        result->left->keys[i] = page->keys[i];
    }
    // Copia as keys maiores que key_do_meio para right
    lee_btree_key_entry_t **pentry = result->right->keys;
    for (int i = page->childrenCount / 2; i < page->childrenCount; i++){
        *pentry++ = page->keys[i];
    }

    return result;
}

/*
 *
 */
lee_btree_page_t *btree_page_insert(lee_btree_page_t *page, int key, int height){
    int i;

    // Se a página é folha, vamos descobrir onde ela vai ser amazenada no array keys
    if (page->is_leaf){

        // Se a página já atingiu o limite, vamos precisar dividir em duas páginas (operação split)
        if (page->childrenCount == ORDER){
            btree_page_split_t *split = btree_page_split(page);
            page->is_leaf = false;      // não é mais folha
            // todo page->

        }else {
            // Encontra a posição nas keys onde a nova key deve ficar
            for (i = 0; i < page->childrenCount; i++) {
                if (key < page->keys[i]->key) break;
            }

            // Agora, move todas as chaves uma posição para frente para abrir espaço para a nova key
            for (int j = page->childrenCount; j > i; j--) {
                page->keys[j] = page->keys[j - 1];
            }

            // Armazenamos a nova entrada da key nesta posição
            page->keys[i] = btree_key_entry_new(key);

            // e incrementamos a quantidade de keys que agora há nesta página
            page->childrenCount++;
        }
    }
    return page;
}


// ********************************** public functions **********************************

bool lee_btree_insert(lee_btree_t *btree, int key){
    lee_btree_page_t *node = btree_page_insert(btree->root, key, btree->height);
    return true;
}

void lee_btree_test() {
    puts("\n\nPrograma teste btree\n");

    lee_btree_t *btree = lee_btree_new();
    bool inseriu;

    // 5  10  12  15
    inseriu = lee_btree_insert(btree, 10);
    inseriu = lee_btree_insert(btree, 5);
    inseriu = lee_btree_insert(btree, 15);
    inseriu = lee_btree_insert(btree, 12);
    inseriu = lee_btree_insert(btree, 4);
    inseriu = lee_btree_insert(btree, 7);

    printf("Btree criado com %d elementos.", btree->height);
}

