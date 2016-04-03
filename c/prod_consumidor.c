/*

        Trabalho Sistemas Operacionais
        ====================================================================
         
        Programa Produtor Consumidor

        Objetivo:
        ---------
        
          A implementa��o proposta visou satisfazer a "Atividade 1" com a 
          sincroniza��o com sem�foros da biblioteca semaphore.h e threads da
          biblioteca pthread.h. 
          
          Tamb�m visou satisfazer a "Atividade 2" usando prote��o cr�tica 
          atrav�s do algor�tmo Protocolo 2.

          
        Funcionamento:
        -------------              

           Ao abrir o programa � criado um produtor e v�rios consumidores
           conforme a constante MAX_CONSUMIDOR. 
           
           Um buffer de inteiros com 8 posi��es � alocado. Enquanto produtor 
           produz n�meros e adiciona-os no buffer, os consumidores os consomem, 
           removendo-os do buffer e imprimindo-os na tela. Pode-se alterar
           o tamanho do buffer atrav�s da constante BUFFER_SIZE.
           
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

// voc� deve entender o algoritmo deste, l� o livro

// aqui definimos uma constante BUFFER_SIZE para dizer o tamanho do buffer

/* Tamanho do buffer compartilhado */
#define BUFFER_SIZE 4

// quantos consumidores v�o ter...
// a, e muito importante, n�o tem constante para definir quandos V�O PRODUZIR, POIS � SOMENTE 1
// mas v�rios podem consumidr...

/* Quantos consumidores no programa */
#define MAX_CONSUMIDOR  1

/* Tipos de sem�foros poss�veis */
#define SEMAFORO_PTHREAD            1
#define SEMAFORO_PROTOCOLO_2        2

/* Flags booleanos */
#define TRUE                        1
#define FALSE                       0

// essa parte aqui � tudo igual ao outro
// vou pular para parte diferente
// ok ? ok
/* 
  Define nosso Semaforo. 
  
  Internamente pode trabalhar atrav�s de dois m�todos 
  conforme o flag tipo_semaforo:
  
  M�todo 1 -> usar Sem�foro Pthread para o exerc�cio 1.

  M�todo 2 -> usar o Protocolo 2 para o exerc�cio 2.
  
*/
typedef struct Semaforo {
  // vari�veis para Pthread
  sem_t sem1;                                       

  // vari�veis para Protocolo 2
  volatile int sem2[2];
  volatile int sem2_flag;                         // vari�vel auxiliar sem�foro    
  
  volatile int flag0;
  volatile int flag1;
    
  int tipo_semaforo;                              // tipo de sem�foro utilizado: SEMAFORO_PTRHEAD ou SEMAFORO_PROTOCOLO_2 
} Semaforo;       


/* global */
// as threads, nada de mais
pthread_t produtor_thread;                    // Thread produtor  
pthread_t consumidor_thread[MAX_CONSUMIDOR];  // Thread consumidor

// o buffer, � um array do tamanho de BUFFER_SiZE
int buffer[BUFFER_SIZE];                    // array de n�meros para compartilhar
int in = 0;                                   // para controle do vetor circular do produto
int out = 0;                                  // para controle do vetor circular do consumidor

// quantos n�meros h� no buffer
// volatile provavelmente a professora n�o deu, n�o sei se ela sabe
// pode fazer um grau l� na hora, explicando
// consulte o wiki...
volatile int count = 0;                       // quantos n�meros h� no buffer

// os sem�foros, conforme  o livro, vamos usar tr�s neste programa
Semaforo mutex;
Semaforo vazio;
Semaforo cheio;

// vou pular, igual...

/*
  M�todos auxiliares para tratamento do sem�foro.
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
     
     sem->flag0 = FALSE;
     sem->flag1 = FALSE;
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
     // Agilar: Implementa��o conforme caderno
     sem->sem2_flag = 1 - sem->sem2_flag;
     sem->sem2[sem->sem2_flag] = TRUE;
     while (sem->sem2[sem->sem2_flag] == TRUE)
       sched_yield();  // nenhum opera��o  (sched_yield() � igual a Thread.yield() em Java);
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
     // Implementa��o conforme caderno
     //sem->sem2[sem->sem2_flag] = FALSE;
     
     if (t == 0)
        sem->flag0 = FALSE;
     else
        sem->flag1 = FALSE;   
  }    
}          

// aqui come�a o algortimo produtor-consumidor, igual ao livro...


/*
  Inserir um n�mero no buffer. Invocado pelo produtor.
*/
void inserir(int numero){
  while (count == BUFFER_SIZE) 
     sched_yield(); // aguarda  
     
  sem_adquire(&vazio, 0);
  sem_adquire(&mutex, 0);
     
  // adiciona um n�mero no buffer      
  ++count;
  buffer[in] = numero;
  in = (in + 1) % BUFFER_SIZE;
  //printf("in=%d\n", in);
  
  sem_libera(&mutex, 0);
  sem_libera(&cheio, 0);  
}


/*
  Remover um n�mero no buffer. Invocado pelo consumidor.
*/
int remover(){
  
  // usei sched_yield() para ser igual ao do Java  Thread.yeld()
  // explica isso l� para prof...
  while (count == 0) 
     sched_yield(); // aguarda  

  sem_adquire(&cheio, 0);
  sem_adquire(&mutex, 0);

  // remove um n�mero do buffer
  --count;
  int meu_numero = buffer[out];
  out = (out + 1) % BUFFER_SIZE;
  //printf("out=%d\n", out);
  
  sem_libera(&mutex, 0);
  sem_libera(&vazio, 0);  

  return meu_numero;
}       


// aqui, como no outro programa, e as duas fun��es de thread
// produtor e consumidor       

/*
  Thread do produtor
*/
void * produtor_thread_proc(){

  while (1) {
    // Dorme um pouco
    //sleep(0.5);        

    // Gera um n�mero novo e inclui no buffer
    // gera um n�mero entre 1 e 100 sempre aleat�rio para inserir no buffer
    // ok ? ok
    int numero = rand() % 100 + 1; // gera um n�mero de 1 a 100
    printf("N�mero produzido: %d\n", numero);
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
    sleep(3);        
    
    // Consome um n�mero do buffer
    int numero = remover();
    
    // Mostra o valor consumido
    printf("N�mero consumido: %d\n", numero);
  }      

  return NULL;
}


// as duas fun��es que criam as threads... padr�o...

/*
  Cria o produtor atrav�s da biblioteca ptheads
*/
int createProdutor(){
  printf("Iniciando produtor 0\n");
  int result = pthread_create(&produtor_thread, NULL, produtor_thread_proc, NULL);
  return result;
}

/*
  Cria o consumidor atrav�s da biblioteca ptheads
*/
int createConsumidor(int i){
  printf("Iniciando consumidor %d\n", i);
  int result = pthread_create(&consumidor_thread[i], NULL, consumidor_thread_proc, NULL);
  return result;
}


// e a main...

int main(int argc, char **argv){

  int ret_ok;
  int i;

  printf("====================================================\n");
  printf("Produtor Consumidor sem Protecao v 3.0\n");
  printf("Aluno: Everton de Vargas Agilar & Thais Rosa\n");
  printf("Profa. Ana Paula Canal\n");
  printf("====================================================\n");

   // inicializa a semente de n�meros
   // precisa em c
   // para usar a fun��o que cria n�meros rand�micos...
   
  // Inicializa a semente dos n�meros rand�micos
  srand(time(NULL));
  
  /* Inicializa os sem�foros */
  // cria tr�s sem�foros para o programa, ...
  inicializa_semaforo(&mutex, SEMAFORO_PROTOCOLO_2);
  inicializa_semaforo(&vazio, SEMAFORO_PROTOCOLO_2);
  inicializa_semaforo(&cheio, SEMAFORO_PROTOCOLO_2);

  // cria produtor (1) e os consumidores (MAX_CONSUMIDOR)

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

  // AGUARDA terminar... ctrl + c

  /* Aguarda o produtor e o primeiro consumidor */
  pthread_join(produtor_thread, (void **) &ret_ok);
  pthread_join(consumidor_thread[0], (void **) &ret_ok);

  // terminou... 

  puts("Programa produtor consumidor finalizado!\n");
  
  return 0;
}
