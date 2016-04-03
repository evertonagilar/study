/*

   Trabalho 2
             
   Aluno: Everton de Vargas Agilar
   Prof.: Alexandre Zamberlam
   Data: 15/04/2010

   Trabalho para ordena��o de lista encadeada de n�meros inteiros gerada
   randomicamente. Uma vez gerada a lista, copi�-la para mais duas listas 
   tempor�rias. 
   
   Dessa forma, para cada uma dessas listas aplicar os m�todos de ordena��o 
   da bolha, sele��o e inser��o. Por�m, as trocas dos elementos a serem 
   ordenados devem ocorrer sobre os PONTEIROS e n�o sobre os 
   conte�dos da lista.

   Ao final, exibir as listas ordenadas associadas aos algoritmos aplicados.

   Se for necess�rio, a apresenta��o do trabalho ser� solicitada.

*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>



/*
   Registro utilizado no vetor
*/
typedef struct Node{
        int value;
        struct Node *next;
        struct Node *prior;
} Node;       


/*
  Mostra um lista encadeada na tela.
  
  Par�metros: 
      *lista -> ponteiro para lista duplamente encadeada que deve exibida na tela.
 
*/
void mostraLista(Node *lista){
  while (lista->prior != NULL)
    lista = lista->prior;
  while (lista){
    printf("%d\n", lista->value);
    lista = lista->next;
  }            
}     

/* 
  Troca dois n�s de posi��o de uma lista duplamente encadeada.
  
  Par�metros: 
      **lista -> ponteiro para um ponteiro de lista. Necess�rio
                 porque com as trocas, a vari�vel do trabalho
                 que armazena o n� raiz pode ser alterado.
                 
      *no1 -> no a ser trocado de posi��o                 
      *no2 -> no a ser trocado de posi��o                 
  
*/
void troca_no(Node **lista, Node *no1, Node *no2){
  if (no1 != NULL && no2 != NULL && no1 != no2)
  {         
    if (no1->next != no2){
      Node *prior_no2 = no2->prior;        
      Node *next_no2 = no2->next;        
      Node *prior_no1 = no1->prior;        
      Node *next_no1 = no1->next;        
      
      no2->next = next_no1;
      no2->prior = prior_no1;
      no1->next = next_no2;
      no1->prior = prior_no2;
      
      if (prior_no2 != NULL){
        if (prior_no2 != no1)
          prior_no2->next = no1;
        else
          prior_no2->next = NULL;  
      }  
      if (next_no2 != NULL){
        if (next_no2 != no1)
          next_no2->prior = no1;
        else
          next_no2->prior = NULL;
      }  
        
      if (prior_no1 != NULL){ 
        if (prior_no1 != no2)
          prior_no1->next = no2;
        else
          prior_no1->next = NULL;  
      }  
      if (next_no1 != NULL){
        if (next_no1 != no2)  
          next_no1->prior = no2;
        else
          next_no1->prior = NULL;
      }  
   }                         
   else 
   {
     if (no1->prior)
       no1->prior->next = no2;
     no2->prior = no1->prior;  
        
     if (no2->next)
       no2->next->prior = no1;
     no1->next = no2->next;
     
     no2->next = no1;
     no1->prior = no2;
     
     if (no2->prior == NULL)
       *lista = no2;
   }    

   Node *p = no1;
   while (p->prior != NULL)
     p = p->prior;
   *lista = p;  
  }  
}     



/* 
  Ordena��o Bubble Sort 
  
  Par�metros:
        **lista -> ponteiro para ponteiro de lista duplamente encadeada.  
*/
void BubbleSort(Node **lista){
     int houveTroca; 
     Node *no, *prox;
     do {
        no = *lista;
        houveTroca = 0; // n�o houve troca
        while (no && no->next){
          prox = no->next;
          if (no->value > no->next->value){
             troca_no(lista, no, no->next);
             houveTroca = 1; // houve troca
          }   
          no = prox;
        }      
      } while (houveTroca);
}    



/* 
  Ordena��o Selection Sort
  
  Par�metros:
        **lista -> ponteiro para ponteiro de lista duplamente encadeada.  
*/
void SelectionSort(Node **lista){
     Node *no, *prox, *min, *cur;
     no = *lista;
     while (no){
       prox = no->next;
       min = no;       // posi��o a ser ordenada
       cur = no;
       no = prox;
       while (no){
         if (no->value < min->value)
           min = no;            
         no = no->next;
       } 
       if (cur != min)     
         troca_no(lista, cur, min);
       no = prox;
     }      

     /*for (i = 0; i < tamanho; i++){
         min = i;  // posi��o a ser ordenada
         for (j = i+1; j < tamanho; j++){
             if (lista[j].value < lista[min].value)
               min = j;  // posi��o a ser trocada
         }      
         tmp = lista[min];
         lista[min] = lista[i];
         lista[i] = tmp;
     } */         
}    



/*
  Insere um n�mero na lista encadeada.
  Parametros:
    lista -> lista encadeada ou NULL se aina n�o existe a lista.
    value -> valor inteiro a ser adicionado na lista.

  Retorno: ponteiro para primeiro elemento da lista encadeada, 
           ou seja, o n� com o primeiro elemento da lista.
                    
*/
Node *insereNumeroLista(Node *lista, int value){
  Node *no = (Node*) malloc(sizeof(Node));          
  no->value = value;
  no->next = lista;
  no->prior = NULL;
  if (lista != NULL){
    lista->prior = no;
  }  
  
  return no;
}     



/*
  Retorna um ponteiro para uma lista ordenada gerada
  com n�mero aleat�rios para o exerc�cio.  
*/
Node *createListaEncadeadaComNumerosGeradoRandomicamente(){
  Node *lista = NULL;                   
  int i, num;
  srand(time(NULL));
  
/*  lista = insereNumeroLista(lista, 3);
  lista = insereNumeroLista(lista, 1);
  lista = insereNumeroLista(lista, 0);
  lista = insereNumeroLista(lista, 4);
*/

  for (i = 0; i < 10; i++) {
    num = rand() % 1000; // sorteia n�meros de 0 a 999
    lista = insereNumeroLista(lista, num);
  }  
     
  return lista;     
}     



/*
  Clonar ou fazer uma c�pia de uma lista encadeada.
  
  Par�metros: 
      *lista -> ponteiro para lista duplamente encadeada que deve ser clonada.
  
  Retorno: 
      Retorna outra lista encadeada igual a lista passada como argumento.
*/
Node * clonaLista(Node *lista){
  Node * lista_clone = NULL;   
  while (lista){
    lista_clone = insereNumeroLista(lista_clone, lista->value);
    lista = lista->next;
  }            
  return lista_clone;
}     



int main(int argc, char *argv[])
{
  printf("Trabalho 2 de Ordenacao\n");
  printf("Aluno: Everton de Vargas Agilar\n");
  printf("Prof.: Alexandre Zamberlam\n");
  printf("=================================\n\n");

  /*
     Criar as listas do trabalho para aplicar a ordena��o.
  */   
  Node * lista1 = createListaEncadeadaComNumerosGeradoRandomicamente();
  Node * lista2 = clonaLista(lista1);
  Node * lista3 = clonaLista(lista1);

  /*
     Aplicar os m�todos de ordena��o da bolha, sele��o e inser��o.
  */   
  BubbleSort(&lista1);
  printf("\nMetodo Bubble Sort:\n");
  mostraLista(lista1); 

  SelectionSort(&lista2);
  printf("\nMetodo Selection Sort:\n");
  mostraLista(lista2); 

  puts("\n");
  system("PAUSE");	
  return 0;
}
