
/*

        Trabalho Sistemas Operacionais
        ======================================================================
        
        Programa banco_dados.c
        
        Objetivo:
        ---------
        
          A implementação proposta visou satisfazer a "Atividade 1" letra f.
          
        Funcionamento:
        -------------              

          
          Para encerrar o programa pressione Ctrl + C


        Autores: Everton Agilar e Thais Rosa
        Data: 13/10/2010
        Alterado: 12/10/2010

*/

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include <time.h>
#include <unistd.h>

/* Tipos de semáforos possíveis */
#define SEMAFORO_PTHREAD            1
#define SEMAFORO_PROTOCOLO_2        2

/* Flags booleanos */
#define TRUE                        1
#define FALSE                       0

/* Quandos leitores e escritores este programa deve permitir */
#define MAX_LEITOR                  2
#define MAX_ESCRITOR                1

/* 
  Define nosso Semáforo. 
  
  Internamente pode trabalhar através de dois métodos 
  conforme o flag tipo_semaforo:
  
  Método 1 -> usar Semáforo Pthread para o exercício 1.

  Método 2 -> usar o Protocolo 2 para o exercício 2.
  
*/
typedef struct Semaforo {
  // variáveis para Pthread
  sem_t sem1;                                       

  // variáveis para Protocolo 2
  volatile int sem2[2];
  volatile int sem2_flag;                         // variável auxiliar semáforo    
  
  volatile int flag0;
  volatile int flag1;
    
  int tipo_semaforo;                              // tipo de semáforo utilizado: SEMAFORO_PTRHEAD ou SEMAFORO_PROTOCOLO_2 
} Semaforo;       


typedef struct Bloqueio {
  Semaforo mutex;                                   
  Semaforo db;                                   
  int leitor_count;
} Bloqueio;
        

/* global */
pthread_t transacao_thread[3];                              // Threads para transações

/*
  Métodos auxiliares para tratamento do semáforo.
*/

void inicializa_semaforo(Semaforo *sem, int tipo_semaforo){
  if (tipo_semaforo == SEMAFORO_PTHREAD){
     sem_init(&sem->sem1, 0, 1);
  } 
  else // SEMAFORO_PROTOCOLO_2
  {
     sem->sem2[0] = FALSE;
     sem->sem2[1] = FALSE;
     sem->sem2_flag = 0;
  }    
  
  sem->tipo_semaforo = tipo_semaforo;
}     

void sem_adquire(Semaforo *sem, int t){
  if (sem->tipo_semaforo == SEMAFORO_PTHREAD){
     sem_wait(&sem->sem1);          
  } 
  else // SEMAFORO_PROTOCOLO_2
  {
     /* 
     // Agilar: Implementação conforme caderno
     sem->sem2_flag = 1 - sem->sem2_flag;
     sem->sem2[sem->sem2_flag] = TRUE;
     while (sem->sem2[sem->sem2_flag] == TRUE)
       sched_yield();  // nenhum operação  (sched_yield() é igual a Thread.yield() em Java);
     */
     
     if (t == 0){
       sem->flag0 = TRUE;
       while (sem->flag1 == TRUE)      
            sched_yield();
     }else {
        sem->flag1 = TRUE;
        while (sem->flag0 == TRUE)
            sched_yield();
     }      
  }    
}


void sem_libera(Semaforo *sem, int t){
  if (sem->tipo_semaforo == SEMAFORO_PTHREAD){
     sem_post(&sem->sem1);          
  } 
  else // SEMAFORO_PROTOCOLO_2
  {
     // Implementação conforme caderno
     //sem->sem2[sem->sem2_flag] = FALSE;
     
     if (t == 0)
        sem->flag0 = FALSE;
     else
        sem->flag1 = FALSE;   

  }    
}          


/*
   Funções para bloqueio de leitura/escrita no banco de dados.
*/

Bloqueio * createBloqueio(){

  Bloqueio *bloqueio = (Bloqueio*) malloc(sizeof(Bloqueio));

  /* Inicializa os semáforos */
  inicializa_semaforo(&bloqueio->mutex, SEMAFORO_PTHREAD);
  inicializa_semaforo(&bloqueio->db, SEMAFORO_PTHREAD);
  bloqueio->leitor_count = 0;

  return bloqueio;         
}         

void adquireReadLock(Bloqueio *bloqueio){
  sem_adquire(&bloqueio->mutex, 0);
  bloqueio->leitor_count++;

  // Quando for o primeiro leitor, diz a todos os outros
  // que o banco de dados está sendo lido
  if (bloqueio->leitor_count == 1)
    sem_adquire(&bloqueio->db, 0);
    
  sem_libera(&bloqueio->mutex, 0);  
}     


void liberaReadLock(Bloqueio *bloqueio){
  sem_adquire(&bloqueio->mutex, 0);
  bloqueio->leitor_count--;

  // Quando é o último leitor, diz a todos os outros
  // que o banco de dados não está sendo lido
  if (bloqueio->leitor_count == 0)
    sem_libera(&bloqueio->db, 0);
    
  sem_libera(&bloqueio->mutex, 0);  
}     

void adquireWriteLock(Bloqueio *bloqueio){
  sem_adquire(&bloqueio->db, 0);
}     


void liberaWriteLock(Bloqueio *bloqueio){
  sem_libera(&bloqueio->db, 0);
}     


/*
  Transação 1
*/
void * transacao_thread_1_proc(){

// falta código aqui
      
  return NULL;
}


/*
  Transação 2
*/
void * transacao_thread_2_proc(){

// falta código aqui
      
  return NULL;
}


/*
  Transação 3
*/
void * transacao_thread_3_proc(){

// falta código aqui
      
  return NULL;
}


/*
  Cria as transações para o programa
*/
void createTransacao(int t){
  int result;    
  printf("Iniciando transacao %d\n", t);

  // Cria a thread
  switch (t) {
    case 1: result = pthread_create(&transacao_thread[t], NULL, transacao_thread_1_proc, NULL); break;
    case 2: result = pthread_create(&transacao_thread[t], NULL, transacao_thread_2_proc, NULL); break;
    case 3: result = pthread_create(&transacao_thread[t], NULL, transacao_thread_3_proc, NULL); break;
  }  

  // Verifica se criou com sucesso a thread
  if (result != 0){
    printf("Ocorreu um erro ao criar a transacao %d!\n", t);
    exit(1);
  }                
}


int main(int argc, char **argv){

  printf("====================================================\n");
  printf("Banco Dados v 1.0\n");
  printf("Aluno: Everton de Vargas Agilar & Thais Rosa\n");
  printf("Profa. Ana Paula Canal\n");
  printf("====================================================\n");
  
  int ret_ok;
  
  /* Cria as transações */
  createTransacao(1);
  createTransacao(2);
  createTransacao(3);

  /* Aguarda as transações terminarem */
  pthread_join(transacao_thread[0], (void **) &ret_ok);
  pthread_join(transacao_thread[1], (void **) &ret_ok);
  pthread_join(transacao_thread[2], (void **) &ret_ok);

  puts("Programa banco_dados finalizado!\n");

  return 0;
}
