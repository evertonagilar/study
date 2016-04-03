/*

        Trabalho Sistemas Distribuidos

        Utilizando sockets e Threads, implementar um “chat”, de forma distribuída, de
        maneira que vários clientes possam se conectar a um servidor e que as mensagens enviadas
        por um “cliente”, sejam recebidas por todos os “clientes” que estejam conectados no
        mesmo servidor.

        O servidor não deve mostras as mensagens na tela, apenas quais clientes estão
        conectados.

        O trabalho deverá ser desenvolvido individualmente, mas a implementação pode
        (deve) ser discutida entre todos indiscriminadamente.

        Deve ser implementado na linguagem de programação C, no sistema operacional
        Linux, utilizando os ambiente e ferramentas de programação que julgarem mais
        apropriados.

        Autor: Everton Agilar
               Jader Adiel

*/

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include <time.h>

#define TAM_BUFFER	512
#define SERVER_PORT 3000
#define BACKLOG 100

/* Códigos de retorno (status) para exit() */
#define ERRO_INIT_LISTENER 1
#define ERRO_INIT_SOCKET_CLIENTE 2
#define ERRO_INIT_SOCKET_SERVER 3
#define ERRO_BIND_SERVER 4
#define ERRO_INIT_SERVER_CHAT 5

/*
   Registro descritor para armazenar informações
   sobre uma conexão de cliente.
*/
typedef struct Cliente{
    int cli_sockfd;
    int cli_len;
    struct sockaddr_in cli_addr;
    char IP[15];
} Cliente;


/*
  Lista simplesmente encadeada para lista de conexões de clientes.
*/
typedef struct ListaCliente {
    Cliente *cliente;
    struct ListaCliente *proximo;
};

/* global */
pthread_t listener_thread, servidor_thread;
struct sockaddr_in serv_addr;
int sockfd;                                 // descritor de socket do servidor
short server_running = 0;                   // 1 = running 0 = terminated
struct ListaCliente *listaClientes;                 // lista de clientes conectados
char erro[250];                             // buffer global para mensagens de erro
int ret_ok;                                 // variável para receber retorno de funções

/*
  Adiciona um cliente na lista de clientes.
*/
void *addClienteLista(Cliente *cliente){
    struct ListaCliente *no = (struct ListaCliente*) malloc(sizeof(struct ListaCliente));
    no->cliente = cliente;
    if (listaClientes){
      no->proximo = listaClientes;
      listaClientes = no;
    }
    else
      listaClientes = no;
}

void *enviaMsgParaClientes(Cliente *de){
  puts("todo");
}

/*
  Retorna uma mensagem de erro e finaliza o servidor.
*/
void exit_server(char * message, int status){
  printf("%s", message);
  exit(status);
}

void * servidor_thread_proc(void * args){
  Cliente *cliente = (Cliente*) args;
  char buffer[TAM_BUFFER];
  int bytes_rec;

  while (server_running){
    printf("Novo cliente conectado --> IP: %s\n", cliente->IP);
    bytes_rec = recv(cliente->cli_sockfd, buffer, TAM_BUFFER, 0);
    if (bytes_rec = -1)
      printf("Erro ao receber mensagem do IP %s.\n", cliente->IP);
    else
      enviaMsgParaClientes(cliente);
  }
  return NULL;
}

/*
  Cria um servidor para atender uma conexão de cliente.
*/
int createServidorChat(Cliente *cliente){
  int result = pthread_create(&servidor_thread, NULL, servidor_thread_proc, cliente);
  if (result == 0)
    addClienteLista(cliente);
  return result;
}

/*
  Thread do listener.
*/
void * listener_thread_proc(){
  Cliente *cliente;
  char *IP;

  while (server_running){
    puts("\n + Servidor na escuta, cambio!!!\n");

    cliente = (Cliente*) malloc(sizeof(Cliente));
    cliente->cli_len = sizeof(cliente->cli_addr);

    cliente->cli_sockfd = accept(sockfd, (struct sockaddr*) &cliente->cli_addr, (socklen_t*) &cliente->cli_len);

    if (cliente->cli_sockfd < 0){
      sprintf(erro, "Erro ao iniciar socket do cliente.\nErro interno: %d.\n", cliente->cli_sockfd);
      exit_server(erro, ERRO_INIT_SOCKET_CLIENTE);
    }

    IP = inet_ntoa(cliente->cli_addr.sin_addr);
    strcpy(cliente->IP, IP);

    /* Cria o servidor para atender ao cliente */
    ret_ok = createServidorChat(cliente);
    if (ret_ok != 0){
      sprintf(erro, "Ocorreu um erro ao criar servidor para o cliente %s.\n", cliente->IP);
      exit_server(erro, ERRO_INIT_SERVER_CHAT);
    }
  }

  return NULL;
}


/*
  Cria o listener para escutar conexões. Esta função
  cria a thread "thread listener_thread", responsável
  pelo listener.
*/
int createListener(){
  listen(sockfd, BACKLOG);
  printf("Servidor aguardando conexão na porta %d.\n", SERVER_PORT);
  int result = pthread_create(&listener_thread, NULL, listener_thread_proc, NULL);
  return result;
}


int main(int argc, char **argv){

  printf("===============================================\n");
  printf("Servidor Chat v2.0\n");
  printf("Aluno: Everton de Vargas Agilar & Jader Adiel\n");
  printf("Prof. Luis Claudio Gubert\n");
  printf("===============================================\n");

  if ((sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0){
    sprintf(erro, "Erro ao criar socket do servidor.\nErro interno: %d!\n", sockfd);
    exit_server(erro, ERRO_INIT_SOCKET_SERVER);
  }
  else
  {
      memset((void*) &serv_addr, '\0', sizeof(serv_addr));

      serv_addr.sin_family = AF_INET;
      serv_addr.sin_port = htons(SERVER_PORT);
      serv_addr.sin_addr.s_addr = htonl(INADDR_ANY);

      if (bind(sockfd, (struct sockaddr*) &serv_addr, (socklen_t) sizeof(serv_addr)) < 0){
        strcpy(erro, "Erro ao fazer bind para o socket do servidor.");
        exit_server(erro, ERRO_BIND_SERVER);
      }

      server_running = 1;
      listaClientes = NULL;

      /* Cria o listener do Chat */
      ret_ok = createListener();
      if (ret_ok != 0){
        sprintf(erro, "Ocorreu um erro ao iniciar o listener\nErro interno: %d", ret_ok);
        exit_server(erro, ERRO_INIT_LISTENER);
      }

      pthread_join(listener_thread, (void **) &ret_ok);

      puts("Servidor finalizado!\n");
  }
  return 0;
}
