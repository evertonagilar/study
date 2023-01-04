//
// Created by evertonagilar on 09/06/22.
//


#include <malloc.h>
#include "btree.h"


/*
 *
 * Ua árvore B de ordem m é uma árvore que satisfaz as seguintes propriedades:
 *        Cada nó tem no máximo m filhos.
 *        Cada nó interno, exceto a raiz, tem pelo menos m/2 filhos.
 *        Cada nó não folha tem pelo menos dois filhos.
 *        Todas as folhas aparecem no mesmo nível e não carregam nenhuma informação.
 *        Um nó não folha com k filhos contém k −1 chaves.
 *
 *
 */


// ********************************** private functions **********************************

/*
 * Cria um novo node com m childrens
 *
 */
btree_page_t *btree_page_new(int m) {
    btree_page_t * new_page = malloc(sizeof (btree_page_t));
    new_page->m = m;
    new_page->is_leaf = true;
    return new_page;
}

/*
 *
 * Cria a btree
 *
 */
btree_t *btree_new(){
    btree_t * btree = malloc(sizeof (btree_t));
    btree->root = btree_page_new(0);
    btree->n = 0;
    btree->height = 0;
    return btree;
}


btree_key_entry *btree_key_entry_new(int key){
    btree_key_entry *entry = malloc(sizeof(btree_key_entry));
    entry->key = key;
    return entry;
}

/*
 *
 *
 */
btree_page_split_t *btree_page_split(btree_page_t *page){
    btree_page_split_t *result = malloc(sizeof(btree_page_split_t));
    result->left = btree_page_new(page->m/2-1);  // subtrai 1 porque a maior key do lado esquerdo é promovida
    result->right = btree_page_new(page->m/2);
    result->key_do_meio = page->keys[page->m/2-1];

    // Copia as keys menores que key_do_meio para left
    for (int i = 0; i < page->m/2-1; i++){
        result->left->keys[i] = page->keys[i];
    }
    // Copia as keys maiores que key_do_meio para right
    btree_key_entry **pentry = result->right->keys;
    for (int i = page->m/2; i < page->m; i++){
        *pentry++ = page->keys[i];
    }

    return result;
}

/*
 *
 */
btree_page_t *btree_page_insert(btree_page_t *page, int key, int height){
    int i;

    // Se a página é folha, vamos descobrir onde ela vai ser amazenada no array keys
    if (page->is_leaf){

        // Se a página já atingiu o limite, vamos precisar dividir em duas páginas (operação split)
        if (page->m == ORDER){
            btree_page_split_t *split = btree_page_split(page);
            page->is_leaf = false;      // não é mais folha
            // todo page->

        }else {
            // Encontra a posição nas keys onde a nova key deve ficar
            for (i = 0; i < page->m; i++) {
                if (key < page->keys[i]->key) break;
            }

            // Agora, move todas as chaves uma posição para frente para abrir espaço para a nova key
            for (int j = page->m; j > i; j--) {
                page->keys[j] = page->keys[j - 1];
            }

            // Armazenamos a nova entrada da key nesta posição
            page->keys[i] = btree_key_entry_new(key);

            // e incrementamos a quantidade de keys que agora há nesta página
            page->m++;
        }
    }
    return page;
}


// ********************************** public functions **********************************

bool btree_insert(btree_t *btree, int key){
    btree_page_t *node = btree_page_insert(btree->root, key, btree->height);
    return true;
}

int _main(int argc, char **argv) {
    puts("Programa teste btree\n");

    btree_t *btree = btree_new();
    bool inseriu;

    // 5  10  12  15
    inseriu = btree_insert(btree, 10);
    inseriu = btree_insert(btree, 5);
    inseriu = btree_insert(btree, 15);
    inseriu = btree_insert(btree, 12);
    inseriu = btree_insert(btree, 7);

    printf("Btree criado com %d elementos.", btree->height);

    return 0;
}

