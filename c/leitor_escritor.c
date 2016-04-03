
/*

        Trabalho Sistemas Operacionais
        ======================================================================
        
        Programa Leitores Escritores
        
        Objetivo:
        ---------
        
          A implementação proposta visou satisfazer a "Atividade 1" com a 
          sincronização com semáforos da biblioteca semaphore.h e threads da
          biblioteca pthread.h. 
          
          Também visou satisfazer a "Atividade 2" usando proteção crítica 
          através do algorítmo Protocolo 2.
          
        Funcionamento:
        -------------              

          Foi implementado um tipo struct Semaforo e funções para tratamento 
          de semáforos: inicializa_semaforo, sem_adquire, sem_libera.  

          Também foi desenvolvido as funções para bloqueio de leitura e escrita. As
          threads de leitores e escritores são criadas através das funções 
          createLeitores() e createEscritores() que iniciam tantos leitores ou 
          escritores quanto definido nas constantes MAX_LEITOR e MAX_ESCRITOR.

          Ao iniciar o programa, é inicializado dois semáforos (mutex e db). O 
          semáforo mutex é usado para entrar seção crítica das funções adquireReadLock()
          e liberaReadLock() e o semáforo db para controlar o acesso ao banco de dados.
          
          Ao obter permissão para leitura ou escrita, cada leitor ou escritor dorme
          por 1 segundo para simular algum trabalho útil.
          
          Para encerrar o programa pressione Ctrl + C


        Autores: Everton Agilar e Thais Rosa
        Data: 09/10/2010
        Alterado: 12/10/2010
        Alterado: 13/10/2010

*/

// Includes necessários
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include <time.h>
#include <unistd.h>

// aqui eu declarei as constantes do projeto
// estas seis constantes definem
// o tipo de semáforo
// no exercício era para implementar usando PTHRED e usando o protocolo 2
// olhe no seu papel exercicio 1 A B C  e dois refazer usando protocolo 2
// eu optei por fazer um único programa e então criar uma constante
// SEMAFORO_PTHREAD e SEMAFORO_PROTOCOLO_2
// que define como qual tipo de semáforo o programa vai trabalhar
// entendeu minha lógica, em vez de escrever dois programas eu escrevi apenas 1
// ? ok depois salva este com esses comentário pra eu lembra do esta me dizendo agora
// Lá na função main() onde começa prgrama em C eu declaro ou crio os semáfros que 
// o programa vai usar, então lá eu vou ter que informar estas constantes
// quando chegarmos lá vocÊ vai ver...

/* Tipos de semáforos possíveis */
#define SEMAFORO_PTHREAD            1
#define SEMAFORO_PROTOCOLO_2        2

// Bom, c não tem booleano como em pascal, então declarei duas constantes...

/* Flags booleanos */
#define TRUE                        1
#define FALSE                       0

// aqui eu declarei duas constantes para mexer na quantidade de leitores e escritores do programa
// essa parte é leval porque dá para ver como vai ser a concorrência
// com mais leitores 

/* Quandos leitores e escritores este programa deve permitir */
#define MAX_LEITOR                  2
#define MAX_ESCRITOR                1

// Aqui eu declaro um struct (record em pascal)
// igual só com sintaxe diferente
// defini este tipo porque precisava várias variáveis
// para controle do semáforo (cada tipo de semáforo tem suas próprias variáveis)
// depois vamos ver isso sendo usado...

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
    
  int tipo_semaforo;                              // tipo de semáforo utilizado: SEMAFORO_PTRHEAD ou SEMAFORO_PROTOCOLO_2 
} Semaforo;       

// aqui vem uma parte importante
// do c
// para criar aplicativo com Pthread ou seja com uso de threads
// deve-se usar variáveis pthread_t
// como eu implementei a possibilidade de ter vários leitores e vários
// escritores, está declarado abaixo um array de leitores e um array de
// escritores. Olhe só, a constante sendo usada em vez de um número direto!
// entendeu ?
//sim, ok, esta é a sintaxe para declarar arrays em c  int minhaVar[10]   <- um array de 10 elementos

/* global */


pthread_t leitor_thread[MAX_LEITOR];              // Threads para leitores
pthread_t escritor_thread[MAX_ESCRITOR];          // Threads para escritores 

// aqui olha só, estamos usando o record Semaforo, já imaginou ter que declarar tantas variáveis para
// cada tipo de semáforo
// no livro é usado dois semáforos nos algoritmos: mutex e db
// manti o mesmo nome, para facilitar a explicação
// pode estudar pelo livro e acompnhar tranquilo aqui

Semaforo mutex;                                   
Semaforo db;

// no livro também declara um variável para saber quantas leituras houve
int leitor_count = 0;                               


// bom, aqui começa as funções para o semáforo
// digamos que estas funções ainda não faz parte do programa
// poderia ser uma biblioteca
// a implementação seque a do livro, nós fizemos sábado a tarde
// como minha implementação foi usar os DOIS tipos de semáforos
// no mesmo programa e não escrever dois programas cada cada exercício,
//  em um IF aqui
// na chamada da função nós vamos informar, quero usar o semáforo protocolo 2, ou 
// quero usar o semáforo pthreads...
// a implementação que tem dentro do if, é a implementação padrão que existe
// no livro...
// até aqui ok ? ok estou com o livro aqui buena...

/*
  Métodos auxiliares para tratamento do semáforo.
*/

void inicializa_semaforo(Semaforo *sem, int tipo_semaforo){
  // qual tipo de semáforo vamos usar
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

// no livro temos duas rotinas adquire e libera
// no programa em C precisa também de uma procedure inicializa
// porque não tem construtores como em Java que basta chamar new Objeto
// ok, então a rotina inicializa_semaforo é para criar um semaforo 

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

///////////////// ---------------

// ok, as três rotinas acima implementa o semáforo

// agora estas quatro rotinas abaixo (vide livro)
// implemental o algoritmo do leitor escritor
// está quase igual ao do livro
// dispensa explicação do algoritmo pois você deve ler no livro, ok ? ok
// depois qualquer coisa pergunte
// mas em C ficou semelhante


/*
   Funções para bloqueio de leitura/escrita no banco de dados.
*/


void adquireReadLock(){
  sem_adquire(&mutex, 0);
  ++leitor_count;

  // Quando for o primeiro leitor, diz a todos os outros
  // que o banco de dados está sendo lido
  if (leitor_count == 1)
    sem_adquire(&db, 0);
    
  sem_libera(&mutex, 0);  
}     


void liberaReadLock(){
  sem_adquire(&mutex, 0);
  --leitor_count;

  // Quando é o último leitor, diz a todos os outros
  // que o banco de dados não está sendo lido
  if (leitor_count == 0)
    sem_libera(&db, 0);
    
  sem_libera(&mutex, 0);  
}     

void adquireWriteLock(){
  sem_adquire(&db, 0);
}     


void liberaWriteLock(){
  sem_libera(&db, 0);
}     

// -----------------------------------------------------------------

// aqui começa o programa propriamente dito,
// segue a implementação de duas funções para ser as trheads
// leitor_thread_proc() é a thread de um leitor
// pode ter tantos leitores quanto o que foi definido naquela constante no início do programa
// escritor_thread_proc() é a thread para escritor...

/*
  Thread do leitor
*/
void * leitor_thread_proc(){

  // Fica em um loop infinito lendo dados do banco
  while (1) {
      // Dorme um pouco para simular processamento
      sleep(1);

      printf("Obter read-lock\n");
      
      // Adquire bloqueio de leitura antes de ler
      adquireReadLock();
    
      // Temos acesso para ler o banco de dados
      printf("Lendo dados no banco de dados\n");
      sleep(1);  
      
      // Libera o bloqueio de leitura
      liberaReadLock();
  }
      
  return NULL;
}


/*
  Thread do escritor
*/
void * escritor_thread_proc(){

  // Fica em um loop infinito escrevendo dados no banco
  while (1) {
      // Dorme um pouco para simular processamento
      sleep(1);

      printf("Obter write-lock\n");   
      
      // Adquire bloqueio de escrita antes de ler
      adquireWriteLock();
    
      // Temos acesso para escrever no banco de dados
      printf("Escrevendo dados no banco de dados\n");
      sleep(1);  
      
      // Libera o bloqueio de leitura
      liberaWriteLock();
  }

  return NULL;
}

// -----------------------

// estas duas rotinas eu escrevi para criar threads
// nas aulas de sistmas distribuidos, nós colocavamos os códigos
//  pthread_create(...) direto nos fontes, lembra-se ? não recordo mas pode continuar q eu busco isso
// aqui eu encapsulei em duas funções
// o que estas funções fazem ? bom, elas percorrem um array
// e criam as threads, uma a uma

// está aqui por exemplo createLeitores() percorre for i:= 0 to Max_Leitor do
//                                                   pthread_create(...)                                                               

// a função createEscritores faz a mesma coisa com os escritores

/*
  Cria leitores através da biblioteca ptheads
*/
void createLeitores(){
  int i;   

  for (i = 0; i < MAX_LEITOR; i++){
    printf("Iniciando leitor %d\n", i);
    // a chamada ptread_create passa a função que vai servir a thread
    // essa função é a thread propriamente dita
    int result = pthread_create(&leitor_thread[i], NULL, leitor_thread_proc, NULL);
    
    // aqui eu testo se a função pthread_create retornou um número 
    // se retornar zero funcionou, se retornar um número
    // indica um erro
    // qualquer erro que ocorrer eu chamo exit(1) para sair do programa imediatamente!
    if (result != 0){
      printf("Ocorreu um erro ao criar leitor: %d\n", result);
      exit(1);
    }  
  }  
}


/*
  Cria escritores através da biblioteca ptheads
*/
void createEscritores(){
  int i;
  
  for (i = 0; i < MAX_ESCRITOR; i++){
    printf("Iniciando escritor %d\n", i);
    int result = pthread_create(&escritor_thread[i], NULL, escritor_thread_proc, NULL);
    // a chamada ptread_create passa a função que vai servir a thread
    // essa função é a thread propriamente dita

    // aqui eu testo se a função pthread_create retornou um número 
    // se retornar zero funcionou, se retornar um número
    // indica um erro
    // qualquer erro que ocorrer eu chamo exit(1) para sair do programa imediatamente!
    if (result != 0){
      printf("Ocorreu um erro ao criar leitor: %d\n", result);
      exit(1);
    }  
  }  
}


// ok ? beleza! 
// vamos para função main() 
// a função que começa a executar quando você digita ./leitor   ou ./prod...



int main(int argc, char **argv){

  // printf, vocÊ SABE writeln()
  printf("====================================================\n");
  printf("Leitores Escritores v 5.0\n");
  printf("Aluno: Everton de Vargas Agilar & Thais Rosa\n");
  printf("Profa. Ana Paula Canal\n");
  printf("====================================================\n");
  
  int ret_ok;
  
  /* Inicializa os semáforos */
  
  // olha só, cria dois semáforos, semelhante a java new Semaforo()
  
  // aqui estou criando conforme SEMAFORO_PTHREAD, ou seja
  // o programa vai usar semáforos pthreads
  // podemos alternar essa constante com a outra 
  // para mudar
  // se a professora quiser ver o programa funcionando com 
  // os semáforos do protocolo 2, você vai TER QUE MUDAR AQUI E COMPILAR O PROGRAMA DE NOVO
  // ok ? vocÇe está me acompanhand ? s como mudar?
  inicializa_semaforo(&mutex, SEMAFORO_PTHREAD);
  inicializa_semaforo(&db, SEMAFORO_PTHREAD);
 
 // cria as threads
 
  /* Cria os leitores do banco de dados */
  createLeitores();

  /* Cria os escritores do banco de dados */
  createEscritores();

  // aguarda as threads terminarem, para sair do programa ctlrl + c

  /* Aguarda o primeiro leitor e o primeiro escritor */
  pthread_join(leitor_thread[0], (void **) &ret_ok);
  pthread_join(escritor_thread[0], (void **) &ret_ok);

  // uma mensagem apenas...
  puts("Programa leitores escritores finalizado!\n");

  // é isso, a explicação está dada
  // vamos a outro programa
  // ok ? ok! pode salvar este depois me passar? já está salvo

  return 0;
}
