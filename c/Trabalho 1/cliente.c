/*

        Trabalho Sistemas Distribuidos

        Programa cliente

        Utilizando sockets e Threads, implementar um chat, de forma distribuida, de
        maneira que vários clientes possam se conectar a um servidor e que as mensagens enviadas
        por um cliente, sejam recebidas por todos os clientes que estejam conectados no
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

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <string.h>
#include <pthread.h>
#include <unistd.h> 
#include <termios.h> 



#define SERVER_PORT  3000
#define TAM_LINHA 100

/* Códigos de retorno (status) para exit() */
#define ERRO_SERVER_NAO_INFORMADO 1
#define ERROR_ABRIR_SOCKET 2
#define ERRO_CONNECT_SERVER 3
#define ERRO_ENVIA_MSG 4
#define ERRO_RECEBER_MSG 5

/*
  Struct para armazenar informações sobre o servidor.
*/
struct Servidor {
  int sockfd;
  struct sockaddr_in  serv_addr;
  struct hostent *hp;
  char serverName[50];
  pthread_t servidorMensageiroThread;
};

/* 
  Fila de mensagens recebidas do servidor.
*/
struct FilaMensagens{
  char *list[50][TAM_LINHA];
  int count;
};

// global
struct Servidor servidor;
int client_running;
char nomeUsuario[50];
struct FilaMensagens filaMensagens;
char erro[250];
char *cmd_quit = "quit";


/*
  Retorna uma mensagem de erro e finaliza o servidor.
*/
void exit_client(char * message, int status){
  printf("%s", message);
  client_running = 0;
  exit(status);
}

/*
  Escreve o símbolo de promptidão no console.
*/
inline void prompt(){
  printf("%s:> ", nomeUsuario);
}


void leTeclado(char *buffer){
   memset(buffer, '\0', TAM_LINHA);   
   fgets(buffer, TAM_LINHA, stdin);
   buffer[strlen(buffer)-1] = '\0';
}

void iniciarConversacao(){
   char msg[TAM_LINHA];
   char msg_sock[TAM_LINHA];
   int  msg_len;

   // Obtem o nome do usuário
   printf("Informe o seu nome ? ");
   fgets(nomeUsuario, 50, stdin);
   nomeUsuario[strlen(nomeUsuario)-1] = '\0';
   printf("\nBem vindo ao chat %s!\n\nUSO: Digite quit para sair ou a mensagem com ponto final enviar.\n\n", nomeUsuario);

   // Inicia conversação
   do {   
     prompt();
     leTeclado(msg);
     fflush(stdout);
     msg_len = strlen(msg);
     if (msg_len != 0) 
     {
       // verifica comando "quit" para sair	
       if (strcasecmp(msg, cmd_quit) == 0)
         exit_client("Finalizando chat, tchau!!!\n", 0); 
       
       // envia mensagem ao servidor do chat
       sprintf(msg_sock, "%s: %s", nomeUsuario, msg);
       msg_len = strlen(msg_sock);
       if (send(servidor.sockfd, msg_sock, msg_len, 0) != msg_len)
         exit_client("Erro: Ocorreu um erro ao enviar mensagem ao servidor!\n", ERRO_ENVIA_MSG);
     }
   } while (client_running);  
}

void * servidor_mensageiro_thread_proc(){
  char buffer[500];
  char msg[TAM_LINHA];
  int bytes_rec;

  while (client_running){
    memset(buffer, '\0', TAM_LINHA);
    memset(msg, '\0', TAM_LINHA);      
    bytes_rec = recv(servidor.sockfd, buffer, TAM_LINHA-1, 0);
    if (bytes_rec == -1)
      exit_client("Erro: Nao conseguiu obter mensagem do servidor.\n", ERRO_RECEBER_MSG);
    else {
      strncpy(msg, buffer, bytes_rec);
      printf("\n%s\n", msg);	
      fflush(stdout);
      prompt();
      fflush(stdout);
    }
  }
  return NULL;
}

/*
  Cria um servidor para atender uma conexÃ£o de cliente.
*/
int createServidorMensageiro(){
  int result = pthread_create(&servidor.servidorMensageiroThread, NULL, servidor_mensageiro_thread_proc, NULL);
  return result;
}


int main(int argc, char *argv[]){

  printf("====================================================\n");
  printf("Cliente Chat v5.0\n");
  printf("Aluno: Everton de Vargas Agilar & Jader Adiel\n");
  printf("Prof. Luis Claudio Gubert\n");
  printf("====================================================\n");

  // Verifica se foi informado o nome do servidor
  if (argc < 2) {
     exit_client("Digite o nome do servidor!\nUso: cliente <host>\n", ERRO_SERVER_NAO_INFORMADO); 
  }
  strcpy(servidor.serverName, argv[1]);
  
  // Configura o socket
  servidor.hp = gethostbyname(servidor.serverName);
  memset(&servidor.serv_addr, '\0', sizeof(servidor.serv_addr));
  bcopy(servidor.hp->h_addr, (char *) &servidor.serv_addr.sin_addr, servidor.hp->h_length);
  servidor.serv_addr.sin_family = AF_INET;
  /* serv_addr.sin_addr.s_addr = inet_addr(SERV_HOST_ADDR); */
  servidor.serv_addr.sin_port = htons(SERVER_PORT);

  // Abre um socket para conexão
  if ((servidor.sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0)
     exit_client("Erro: Nao foi possivel abrir um socket para conexão.\n", ERROR_ABRIR_SOCKET);

  // Conecta ao servidor	
  if (connect(servidor.sockfd, (struct sockaddr *)&servidor.serv_addr, sizeof(servidor.serv_addr)) < 0 ) {
    sprintf(erro, "Nao e possivel conectar ao servidor %s.\n", servidor.serverName);
    exit_client(erro, ERRO_CONNECT_SERVER);
  }
  printf("Conectado ao servidor %s.\n\n", servidor.serverName);

  client_running = 1;
  filaMensagens.count = 0;

  // Cria o servidor responsavel por obter as mensagens do servidor do chat
  createServidorMensageiro();

  // Inicia a conversação no chat
  iniciarConversacao();

  // fecha o socket
  shutdown(servidor.sockfd, SHUT_RDWR);

  return 0;
}


