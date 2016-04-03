/*

        Trabalho Sistemas Operacionais
        ====================================================================
         
        Programa Produtor Consumidor

        Objetivo:
        ---------
        
          A implementação proposta visou satisfazer a "Atividade 1" com a 
          sincronização com semáforos da biblioteca semaphore.h e threads da
          biblioteca pthread.h. 
          
          Também visou satisfazer a "Atividade 2" usando proteção crítica 
          através do algorítmo Protocolo 2.

          
        Funcionamento:
        -------------              

           Ao abrir o programa é criado um produtor e vários consumidores
           conforme a constante MAX_CONSUMIDOR. 
           
           Um buffer de inteiros com 8 posições é alocado. Enquanto produtor 
           produz números e adiciona-os no buffer, os consumidores os consomem, 
           removendo-os do buffer e imprimindo-os na tela. Pode-se alterar
           o tamanho do buffer através da constante BUFFER_SIZE.
           
           Para encerrar o programa pressione Ctrl + C


        Autor: Everton Agilar e Thais Rosa
        Criado: 09/10/2010
        Alterado: 12/10/2010

*/

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include <time.h>
#include <unistd.h>

/* Tamanho do buffer compartilhado */
#define BUFFER_SIZE 8

/* Quantos consumidores podem ter no programa */
#define MAX_CONSUMIDOR  5

/* global */
pthread_t produtor_thread;                    // Thread produtor  
pthread_t consumidor_thread[MAX_CONSUMIDOR];  // Thread consumidor
int buffer[BUFFER_SIZE];                      // array de números para compartilhar
int count = 0;                                // quantidade de números produzidos e incluídos no buffer   
int in = 0;                                   // para controle do vetor circular do produto
int out = 0;                                  // para controle do vetor circular do consumidor


void inserir(int numero){
       
  while (count == BUFFER_SIZE){
    ; // Não faz nada nenhum buffer livre
  }  
     
  // adiciona um número no buffer      
  ++count;
  buffer[in] = numero;
  in = (in + 1) % BUFFER_SIZE;
}

int remover(){

  while (count == 0){
     ;  // Não tem nada para consumir
  }      

  --count;
  int meu_numero = buffer[out];
  out = (out + 1) % BUFFER_SIZE;
  
  return meu_numero;
}       
       

/*
  Thread do produtor
*/
void * produtor_thread_proc(){

  while (1) {
    // Dorme um pouco
    sleep(1);        

    // Gera um número novo e inclui no buffer
    int numero = rand() % 100 + 1; // gera um número de 1 a 100
    printf("Número produzido: %d\n", numero);
    inserir(numero);
  }    

  return NULL;
}

/*
  Thread do consumidor
*/
void * consumidor_thread_proc(){
  
  while (1){
    // Dorme um pouco
    sleep(1);        
    
    // Consome um número do buffer
    int numero = remover();
    
    // Mostra o valor consumido
    printf("Número consumido: %d\n", numero);
  }      

  return NULL;
}


/*
  Cria o produtor através da biblioteca ptheads
*/
int createProdutor(){
  printf("Iniciando produtor 0\n");
  int result = pthread_create(&produtor_thread, NULL, produtor_thread_proc, NULL);
  return result;
}

/*
  Cria o consumidor através da biblioteca ptheads
*/
int createConsumidor(int i){
  printf("Iniciando consumidor %d\n", i);
  int result = pthread_create(&consumidor_thread[i], NULL, consumidor_thread_proc, NULL);
  return result;
}


int main(int argc, char **argv){

  int ret_ok;
  int i;

  printf("====================================================\n");
  printf("Produtor Consumidor sem Protecao v 3.0\n");
  printf("Aluno: Everton de Vargas Agilar & Thais Rosa\n");
  printf("Profa. Ana Paula Canal\n");
  printf("====================================================\n");

  // Inicializa a semente dos números randômicos
  srand(time(NULL));

  /* Cria o produtor */
  ret_ok = createProdutor();
  if (ret_ok != 0){
    printf("Ocorreu um erro ao iniciar o produtor: %d\n", ret_ok);
    exit(1);
  }

  /* Cria os consumidores */
  for (i = 0; i < MAX_CONSUMIDOR; i++){
    ret_ok = createConsumidor(i);
    if (ret_ok != 0){
      printf("Ocorreu um erro ao iniciar o consumidor: %d\n", ret_ok);
      exit(1);
    }
  }  

  /* Aguarda o produtor e o primeiro consumidor */
  pthread_join(produtor_thread, (void **) &ret_ok);
  pthread_join(consumidor_thread[0], (void **) &ret_ok);

  puts("Programa produtor consumidor finalizado!\n");
  
  return 0;
}
