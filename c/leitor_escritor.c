
/*

        Trabalho Sistemas Operacionais
        ======================================================================
        
        Programa Leitores Escritores
        
        Objetivo:
        ---------
        
          A implementa��o proposta visou satisfazer a "Atividade 1" com a 
          sincroniza��o com sem�foros da biblioteca semaphore.h e threads da
          biblioteca pthread.h. 
          
          Tamb�m visou satisfazer a "Atividade 2" usando prote��o cr�tica 
          atrav�s do algor�tmo Protocolo 2.
          
        Funcionamento:
        -------------              

          Foi implementado um tipo struct Semaforo e fun��es para tratamento 
          de sem�foros: inicializa_semaforo, sem_adquire, sem_libera.  

          Tamb�m foi desenvolvido as fun��es para bloqueio de leitura e escrita. As
          threads de leitores e escritores s�o criadas atrav�s das fun��es 
          createLeitores() e createEscritores() que iniciam tantos leitores ou 
          escritores quanto definido nas constantes MAX_LEITOR e MAX_ESCRITOR.

          Ao iniciar o programa, � inicializado dois sem�foros (mutex e db). O 
          sem�foro mutex � usado para entrar se��o cr�tica das fun��es adquireReadLock()
          e liberaReadLock() e o sem�foro db para controlar o acesso ao banco de dados.
          
          Ao obter permiss�o para leitura ou escrita, cada leitor ou escritor dorme
          por 1 segundo para simular algum trabalho �til.
          
          Para encerrar o programa pressione Ctrl + C


        Autores: Everton Agilar e Thais Rosa
        Data: 09/10/2010
        Alterado: 12/10/2010
        Alterado: 13/10/2010

*/

// Includes necess�rios
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include <time.h>
#include <unistd.h>

// aqui eu declarei as constantes do projeto
// estas seis constantes definem
// o tipo de sem�foro
// no exerc�cio era para implementar usando PTHRED e usando o protocolo 2
// olhe no seu papel exercicio 1 A B C  e dois refazer usando protocolo 2
// eu optei por fazer um �nico programa e ent�o criar uma constante
// SEMAFORO_PTHREAD e SEMAFORO_PROTOCOLO_2
// que define como qual tipo de sem�foro o programa vai trabalhar
// entendeu minha l�gica, em vez de escrever dois programas eu escrevi apenas 1
// ? ok depois salva este com esses coment�rio pra eu lembra do esta me dizendo agora
// L� na fun��o main() onde come�a prgrama em C eu declaro ou crio os sem�fros que 
// o programa vai usar, ent�o l� eu vou ter que informar estas constantes
// quando chegarmos l� voc� vai ver...

/* Tipos de sem�foros poss�veis */
#define SEMAFORO_PTHREAD            1
#define SEMAFORO_PROTOCOLO_2        2

// Bom, c n�o tem booleano como em pascal, ent�o declarei duas constantes...

/* Flags booleanos */
#define TRUE                        1
#define FALSE                       0

// aqui eu declarei duas constantes para mexer na quantidade de leitores e escritores do programa
// essa parte � leval porque d� para ver como vai ser a concorr�ncia
// com mais leitores 

/* Quandos leitores e escritores este programa deve permitir */
#define MAX_LEITOR                  2
#define MAX_ESCRITOR                1

// Aqui eu declaro um struct (record em pascal)
// igual s� com sintaxe diferente
// defini este tipo porque precisava v�rias vari�veis
// para controle do sem�foro (cada tipo de sem�foro tem suas pr�prias vari�veis)
// depois vamos ver isso sendo usado...

/* 
  Define nosso Sem�foro. 
  
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
    
  int tipo_semaforo;                              // tipo de sem�foro utilizado: SEMAFORO_PTRHEAD ou SEMAFORO_PROTOCOLO_2 
} Semaforo;       

// aqui vem uma parte importante
// do c
// para criar aplicativo com Pthread ou seja com uso de threads
// deve-se usar vari�veis pthread_t
// como eu implementei a possibilidade de ter v�rios leitores e v�rios
// escritores, est� declarado abaixo um array de leitores e um array de
// escritores. Olhe s�, a constante sendo usada em vez de um n�mero direto!
// entendeu ?
//sim, ok, esta � a sintaxe para declarar arrays em c  int minhaVar[10]   <- um array de 10 elementos

/* global */


pthread_t leitor_thread[MAX_LEITOR];              // Threads para leitores
pthread_t escritor_thread[MAX_ESCRITOR];          // Threads para escritores 

// aqui olha s�, estamos usando o record Semaforo, j� imaginou ter que declarar tantas vari�veis para
// cada tipo de sem�foro
// no livro � usado dois sem�foros nos algoritmos: mutex e db
// manti o mesmo nome, para facilitar a explica��o
// pode estudar pelo livro e acompnhar tranquilo aqui

Semaforo mutex;                                   
Semaforo db;

// no livro tamb�m declara um vari�vel para saber quantas leituras houve
int leitor_count = 0;                               


// bom, aqui come�a as fun��es para o sem�foro
// digamos que estas fun��es ainda n�o faz parte do programa
// poderia ser uma biblioteca
// a implementa��o seque a do livro, n�s fizemos s�bado a tarde
// como minha implementa��o foi usar os DOIS tipos de sem�foros
// no mesmo programa e n�o escrever dois programas cada cada exerc�cio,
//  em um IF aqui
// na chamada da fun��o n�s vamos informar, quero usar o sem�foro protocolo 2, ou 
// quero usar o sem�foro pthreads...
// a implementa��o que tem dentro do if, � a implementa��o padr�o que existe
// no livro...
// at� aqui ok ? ok estou com o livro aqui buena...

/*
  M�todos auxiliares para tratamento do sem�foro.
*/

void inicializa_semaforo(Semaforo *sem, int tipo_semaforo){
  // qual tipo de sem�foro vamos usar
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
// no programa em C precisa tamb�m de uma procedure inicializa
// porque n�o tem construtores como em Java que basta chamar new Objeto
// ok, ent�o a rotina inicializa_semaforo � para criar um semaforo 

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

///////////////// ---------------

// ok, as tr�s rotinas acima implementa o sem�foro

// agora estas quatro rotinas abaixo (vide livro)
// implemental o algoritmo do leitor escritor
// est� quase igual ao do livro
// dispensa explica��o do algoritmo pois voc� deve ler no livro, ok ? ok
// depois qualquer coisa pergunte
// mas em C ficou semelhante


/*
   Fun��es para bloqueio de leitura/escrita no banco de dados.
*/


void adquireReadLock(){
  sem_adquire(&mutex, 0);
  ++leitor_count;

  // Quando for o primeiro leitor, diz a todos os outros
  // que o banco de dados est� sendo lido
  if (leitor_count == 1)
    sem_adquire(&db, 0);
    
  sem_libera(&mutex, 0);  
}     


void liberaReadLock(){
  sem_adquire(&mutex, 0);
  --leitor_count;

  // Quando � o �ltimo leitor, diz a todos os outros
  // que o banco de dados n�o est� sendo lido
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

// aqui come�a o programa propriamente dito,
// segue a implementa��o de duas fun��es para ser as trheads
// leitor_thread_proc() � a thread de um leitor
// pode ter tantos leitores quanto o que foi definido naquela constante no in�cio do programa
// escritor_thread_proc() � a thread para escritor...

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
// nas aulas de sistmas distribuidos, n�s colocavamos os c�digos
//  pthread_create(...) direto nos fontes, lembra-se ? n�o recordo mas pode continuar q eu busco isso
// aqui eu encapsulei em duas fun��es
// o que estas fun��es fazem ? bom, elas percorrem um array
// e criam as threads, uma a uma

// est� aqui por exemplo createLeitores() percorre for i:= 0 to Max_Leitor do
//                                                   pthread_create(...)                                                               

// a fun��o createEscritores faz a mesma coisa com os escritores

/*
  Cria leitores atrav�s da biblioteca ptheads
*/
void createLeitores(){
  int i;   

  for (i = 0; i < MAX_LEITOR; i++){
    printf("Iniciando leitor %d\n", i);
    // a chamada ptread_create passa a fun��o que vai servir a thread
    // essa fun��o � a thread propriamente dita
    int result = pthread_create(&leitor_thread[i], NULL, leitor_thread_proc, NULL);
    
    // aqui eu testo se a fun��o pthread_create retornou um n�mero 
    // se retornar zero funcionou, se retornar um n�mero
    // indica um erro
    // qualquer erro que ocorrer eu chamo exit(1) para sair do programa imediatamente!
    if (result != 0){
      printf("Ocorreu um erro ao criar leitor: %d\n", result);
      exit(1);
    }  
  }  
}


/*
  Cria escritores atrav�s da biblioteca ptheads
*/
void createEscritores(){
  int i;
  
  for (i = 0; i < MAX_ESCRITOR; i++){
    printf("Iniciando escritor %d\n", i);
    int result = pthread_create(&escritor_thread[i], NULL, escritor_thread_proc, NULL);
    // a chamada ptread_create passa a fun��o que vai servir a thread
    // essa fun��o � a thread propriamente dita

    // aqui eu testo se a fun��o pthread_create retornou um n�mero 
    // se retornar zero funcionou, se retornar um n�mero
    // indica um erro
    // qualquer erro que ocorrer eu chamo exit(1) para sair do programa imediatamente!
    if (result != 0){
      printf("Ocorreu um erro ao criar leitor: %d\n", result);
      exit(1);
    }  
  }  
}


// ok ? beleza! 
// vamos para fun��o main() 
// a fun��o que come�a a executar quando voc� digita ./leitor   ou ./prod...



int main(int argc, char **argv){

  // printf, voc� SABE writeln()
  printf("====================================================\n");
  printf("Leitores Escritores v 5.0\n");
  printf("Aluno: Everton de Vargas Agilar & Thais Rosa\n");
  printf("Profa. Ana Paula Canal\n");
  printf("====================================================\n");
  
  int ret_ok;
  
  /* Inicializa os sem�foros */
  
  // olha s�, cria dois sem�foros, semelhante a java new Semaforo()
  
  // aqui estou criando conforme SEMAFORO_PTHREAD, ou seja
  // o programa vai usar sem�foros pthreads
  // podemos alternar essa constante com a outra 
  // para mudar
  // se a professora quiser ver o programa funcionando com 
  // os sem�foros do protocolo 2, voc� vai TER QUE MUDAR AQUI E COMPILAR O PROGRAMA DE NOVO
  // ok ? voc�e est� me acompanhand ? s como mudar?
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

  // � isso, a explica��o est� dada
  // vamos a outro programa
  // ok ? ok! pode salvar este depois me passar? j� est� salvo

  return 0;
}
