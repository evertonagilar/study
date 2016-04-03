/*

        Trabalho Sistemas Distribuidos

        Programa cliente

        Utilizando sockets e Threads, implementar um âchatâ, de forma distribuÃ­da, de
        maneira que vÃ¡rios clientes possam se conectar a um servidor e que as mensagens enviadas
        por um âclienteâ, sejam recebidas por todos os âclientesâ que estejam conectados no
        mesmo servidor.

        O servidor nÃ£o deve mostras as mensagens na tela, apenas quais clientes estÃ£o
        conectados.

        O trabalho deverÃ¡ ser desenvolvido individualmente, mas a implementaÃ§Ã£o pode
        (deve) ser discutida entre todos indiscriminadamente.

        Deve ser implementado na linguagem de programaÃ§Ã£o C, no sistema operacional
        Linux, utilizando os ambiente e ferramentas de programaÃ§Ã£o que julgarem mais
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
#define TAM_LINHA 350

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
  printf("%s: ", nomeUsuario);
}

/* 
  Adiciona uma mensagem na fila de mensagens recebidas do servidor.
*/
void addMensagemFila(char *msg){
  strcpy((char *)filaMensagens.list[filaMensagens.count++], msg);
}

/* 
  Adiciona uma mensagem na fila de mensagens recebidas do servidor.
*/
void checkMensagemRecebida(){
  if (filaMensagens.count > 0){
    char *msg = (char*) filaMensagens.list[--filaMensagens.count];
    printf("\n%s\n", msg);
    prompt();
  }
}

void leTeclado(char *buffer){
  char chr;
  int result;
  struct termios term;
  char *p = buffer;
  tcgetattr(STDIN_FILENO, &term);
  term.c_lflag &= ~ICANON;
  term.c_cc[VMIN] = 0;
  term.c_cc[VTIME] = 1;
  if (tcsetattr(STDIN_FILENO, TCSAFLUSH, &term) < 0)
    perror("We failed to change terminal settings\n");

  //Polling the keyboard
  while (client_running) {
    result = read(STDIN_FILENO, &chr, 1);
    if (result == 1) {
      if (chr == '.'){
        *p = '\0';
        break;
      }
     *p = chr;
     p++;
    }
    checkMensagemRecebida();
    fflush(STDIN_FILENO);
  }
}

void iniciarConversacao(){
   char msg[TAM_LINHA];
   char msg_sock[TAM_LINHA];
   int  msg_len;
   char *cmd_quit = "quit";

   // Obtem o nome do usuário
   printf("Informe o seu nome ? ");
   gets(nomeUsuario);
   printf("\nBem vindo ao chat %s!\n\n\t, Digite quit para sair ou digite uma mensagem e pressione . para enviar.\n\n", nomeUsuario);

   // Inicia conversação
   do {   
     prompt();
     leTeclado(msg);
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
    bytes_rec = recv(servidor.sockfd, buffer, TAM_LINHA, 0);
    if (bytes_rec == -1)
      exit_client("Erro: Nao conseguiu obter mensagem do servidor.\n", ERRO_RECEBER_MSG);
    else {
      strncpy(msg, buffer, bytes_rec);
      addMensagemFila(msg);
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
  printf("Cliente Chat v4.0\n");
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


