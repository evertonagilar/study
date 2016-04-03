/*
  
    Construa um programa que funcione em linha de comando (por exemplo, console shell Linux).

    O programa deve receber TRÊS parâmetros como entrada:
    1- arquivo de texto (existente) com a relação de nomes de pessoas, um em cada linha (arquivo de origem);
    2- nome de arquivo texto para receber os nomes ordenados pelo processamento (arquivo de destino);
    3- qual o algoritmo de ordenação que será utilizado para ordenar o arquivo (bolha, selecao, insercao, shell)
    
    O programa deve carregar os nomes do arquivo de entrada para um lista dinâmica. A partir do algoritmo escolhido no terceiro parâmetro, ordenar esses nomes e, finalmente, criar um arquivo texto destino com tais nomes ordenados dentro dele.
    
    Por exemplo,
    
    Imagine um arquivo origem de nome amigosF.txt com os seguintes nomes:
    Carla Sasso
    Zandira Silva
    Abigail Oliva
    Bertoldo do Amaral
    Andre Couto
    Cenira de Castro e Silva
    
    Se o programa fosse executado, teria o seguinte funcionamento:
    
    
    c:\>ordena amigosF.txt saida.txt shell
    
    Ou seja, carrega e ordena o arquivo amigosF.txt para dentro do nome arquivo saida.txt, via o algoritmo de ordenação shellsort.
    
    O arquivo saida.txt teria o seguinte conteúdo:
    Abigail Oliva
    Andre Couto
    Bertoldo do Amaral
    Carla Sasso
    Cenira de Castro e Silva
    Zandira Silva

    Autor: Everton de Vargas Agilar

*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>


/*
   Registro utilizado no vetor
*/
typedef struct {
        int chave;
} Registro;       


/* 
   Popula um vetor de Registro com valores aleatórios entre 1 e 999 no campo chave.
   
   Retorno: Ponteiro para o vetor populado.
   
   Data: 18/03/2010              
*/
Registro *popula(Registro *v, int tamanho){
    int i;
    v = (Registro *)malloc(sizeof(Registro)*tamanho);
    srand(time(NULL));
    for (i = 0; i < tamanho; i++)
        v[i].chave = rand() % 1000 + 1;
    return v;   
}    

/*
  Realiza troca entre dois elementos do vetor e 
  faz a contabilização da quantidade de trocas
  
  Data: 19/03/2010
*/
void troca(Registro * r1, Registro * r2){
     Registro tmp = *r1;    
     *r1 = *r2;
     *r2 = tmp;        
}     


/*
   Testa se uma lista está ordenado:
   Retornos:      
           2 - vetor ordenado descrecente
           1 - vetor ordenado crescente
           0 - se desordenado

   Data: 18/03/2010           
*/    
int isOrdenado(Registro lista[], int tamanho){
	int i;
    int x, y;
	int result = 1;  // ordenado crescentemente

	if (tamanho > 1){
	 	// Testa se ordenado crescente  Ex.: 1, 2, 3, 4
	 	x = lista[0].chave;
		result = 1;
	    for (i = 1; i < tamanho; i++){
			y = lista[i].chave;
			if (x > y) {
				result = 0;
				break;  
			}
		}

		// Se não está ordenado crescente verifica se está ordenado descrescente
		if (result == 0)
 		{
		 	// testa ordenado decrescente  Ex.: 4, 3. 2, 1
		 	x = lista[0].chave;
			result = 2;
		    for (i = 1; i < tamanho; i++){
				y = lista[i].chave;
				if (x < y) {
					result = 0;
					break;
				}
			}
		}

	}

    return result;  
}


/* 
  Ordenação Bubble Sort 
*/
void BubbleSort(Registro *lista, int tamanho){
     int i;
     Registro aux;
     int houveTroca; 
     do {
        houveTroca = 0; // não houve troca
        for (i = 0; i < tamanho; i++){
            if (lista[i].chave > lista[i+1].chave){
               /*aux = lista[i];
               lista[i] = lista[i+1];
               lista[i+1] = aux;*/
               troca(&lista[i], &lista[i+1]);
               houveTroca = 1; // houve troca
            }                                             
        } 
     } while (houveTroca);
}    

/* 
  Ordenação Selection Sort
*/
void SelectionSort(Registro *lista, int tamanho){
     int i, j, min;
     Registro tmp;
     for (i = 0; i < tamanho; i++){
         min = i;  // posição a ser ordenada
         for (j = i+1; j < tamanho; j++){
             if (lista[j].chave < lista[min].chave)
               min = j;  // posição a ser trocada
         }      
         /*tmp = lista[min];
         lista[min] = lista[i];
         lista[i] = tmp;*/
         troca(&lista[min], &lista[i]);
     }          
}    

/* 
  Ordenação Insertion Sort
*/
void InsertionSort(Registro *lista, int tamanho){
     int i, j;
     Registro tmp;
     for (j = 1; j < tamanho; j++){
         tmp = lista[j];
         i = j - 1;
         while ((i >= 0) && (lista[i].chave > tmp.chave)){
               lista[i+1] = lista[i];
               i = i - 1;
         }            
         lista[i+1] = tmp;
     }    
}    

/* 
  Ordenação Shell Sort
*/
void ShellSort(Registro *lista, int tamanho){
     int i, j;
     Registro tmp;
     int h = 1; // distância de pesquisa
     do {
        h = 3 * h + 1;
     } while (h < tamanho);
     do {
         h /= 3;
         for (i = h; i < tamanho; i++){
             tmp = lista[i];
             j = i - h;
             while (j >= 0 && tmp.chave < lista[j].chave) {
                   lista[j + h] = lista[j];
                   j -= h;
             }      
             lista[j + h] = tmp;

         }    
     } while (h > 1);
}

/*
  Inverte o vetor trocando a ordem dos seus elementos 
  crescente para descrecente ou vice-versa.
*/
void InverteVetor(Registro *lista, int tamanho){
   int i, j;
   Registro *v = (Registro *)malloc(sizeof(Registro)*tamanho);
   memcpy(v, lista, sizeof(Registro)*tamanho);
   j = 0;
   for (i = tamanho-1; i >= 0; i--)
     lista[j++] = v[i];
   free(v);  
}     

int main(int argc, char *argv[])
{

  printf("Programa Sort\n");
  printf("Aluno: Everton de Vargas Agilar\n");
  printf("=================================\n");

  if (argc != 4){
     puts("Uso: c:\\>sort amigosF.txt saida.txt shell");
     system("PAUSE");	
     return 0;
  }   

  char* arqEntrada = (char*) malloc(strlen(argv[1]))+1;
  char* arqSaida = (char*) malloc(strlen(argv[2]))+1;
  char* metodo_ordena = (char*) malloc(strlen(argv[3]))+1;
  
  strcpy(arqEntrada, argv[1]);
  strcpy(arqSaida, argv[2]);
  strcpy(metodo_ordena, argv[3]);

  FILE *arq;
  Registro *lista = (Registro*) malloc(sizeof(Registro)*1000);
  char linha[80];
  int qtd_linhas;
  
  qtd_linhas = 0;
  
  if ((arq = fopen(arqEntrada, "r") != NULL)){
     // Adiciona o arquivo na lista
    /* do{
        fgets(linha, 79, arq);
        Registro rec = lista[qtd_linhas++];
        rec.chave = strlen(linha); 
     } while (!feof(arq));                      
      */ 
     // Aplica o método de ordenação
     if (strcmp(metodo_ordena, "shell")){
        printf("shell...");                                        
     } 
     else if (strcmp(metodo_ordena, "bolha")){
        printf("bolha");                                        
     }       
                               
                               
                                                              
  }           
  else
  {
     printf("Arquivo '%s' nao existe!\n", arqEntrada);
     system("PAUSE");	
     return 0;
  }

  puts("\n");
  system("PAUSE");	
  return 0;
}
