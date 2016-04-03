/*

   Trabalho: 
             
   Aluno: Everton de Vargas Agilar
   Prof.: Alexandre Zamberlam
   Data: 18/03/2010 - 20/03/2010             

*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

/* 
   Variáveis globais 
*/
time_t tempo_ini, tempo_fim;
double tempo_diff;
int qtd_passadas, qtd_comparacoes, qtd_trocas;
int TAM = 8000;

// Armazena estatísticas de todos os métodos x listas ordenada, não ordenada, parc. ordenada, desordenada
int resultado_qtd_passada_tot_desordenado[4];
int resultado_qtd_comparacoes_tot_desordenado[4];
int resultado_qtd_trocas_tot_desordenado[4];
double resultado_tempo_tot_desordenado[4];

int resultado_qtd_passada_parc_ordenado[4];
int resultado_qtd_comparacoes_parc_ordenado[4];
int resultado_qtd_trocas_parc_ordenado[4];
double resultado_tempo_parc_ordenado[4];

int resultado_qtd_passada_ordenado_desc[4];
int resultado_qtd_comparacoes_ordenado_desc[4];
int resultado_qtd_trocas_ordenado_desc[4];
double resultado_tempo_ordenado_desc[4];

int resultado_qtd_passada_tot_ordenado[4];
int resultado_qtd_comparacoes_tot_ordenado[4];
int resultado_qtd_trocas_tot_ordenado[4];
double resultado_tempo_tot_ordenado[4];

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
     qtd_trocas++;
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
        qtd_passadas++;
        for (i = 0; i < tamanho; i++){
            qtd_comparacoes++;
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
         qtd_passadas++;
         for (j = i+1; j < tamanho; j++){
             qtd_comparacoes++;
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
         qtd_passadas++;
         while ((i >= 0) && (lista[i].chave > tmp.chave)){
               lista[i+1] = lista[i];
               i = i - 1;
               qtd_trocas++;
               qtd_comparacoes++;
         }            
         lista[i+1] = tmp;
         qtd_trocas++;
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
         qtd_passadas++;
         for (i = h; i < tamanho; i++){
             tmp = lista[i];
             j = i - h;
             while (j >= 0 && tmp.chave < lista[j].chave) {
                   lista[j + h] = lista[j];
                   j -= h;
                   qtd_trocas++;
                   qtd_comparacoes++;
             }      
             lista[j + h] = tmp;
             qtd_trocas++;

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

/*
  Inicializa o Teste
*/  
void InicializaTeste(){
  time(&tempo_ini);
  qtd_trocas = 0;
  qtd_passadas = 0;
  qtd_comparacoes = 0;
}

/*
  Imprime o tempo decorrido para ordenar no console
*/  
void MostraResultadoParcial(){
  time(&tempo_fim);     
  tempo_diff = difftime(tempo_fim, tempo_ini);
  printf("Tempo decorrido (segs): \t%9.2f\n", tempo_diff);
  printf("Quantidade trocas: \t\t%9.1d\n", qtd_trocas);
  printf("Quantidade comparacoes: \t%9.1d\n", qtd_comparacoes);
  printf("Quantidade passadas: \t\t%9.1d\n", qtd_passadas);
};  

void AlteraTamanhoVetor(){
  printf("\n\nInforme o tamanho do vetor (Atualmente = %d): ", TAM);
  scanf("%d", &TAM);    
}     

/*
  Imprime na tela os primeiros 10 elementos do vetor.
*/
void Mostra10PrimeirosElementosVetor(Registro *vetor, int tamanho){
  int i, max;
  max = tamanho < 10 ? tamanho : 10;
  printf("\n\nPrimeiros 10 elementos do Vetor[%d]: ", tamanho);
  printf("\n-----------------------------------------\n");
  for (i = 0; i < max; i++) 
      printf("%d  ", vetor[i].chave);     
  printf("\n\n");    
}

/*
  Aplica todos os métodos de ordenação e armazena as estatísticas.
*/     
void AplicaMetodosOrdenacao(
     Registro *vetor,
     int resultado_qtd_passada[],
     int resultado_qtd_comparacoes[],
     int resultado_qtd_trocas[],
     double resultado_tempo[]
)
{
  // Precisamos de uma cópia do vetor para que em cada método de ordenação
  // possamos ter um vetor igual para análise
  Registro *copia_vetor = (Registro *)malloc(sizeof(Registro)*TAM);  
  memcpy(copia_vetor, vetor, sizeof(Registro) * TAM);

  /*
    Método Bubble Sort
  */

  puts("Metodo: Bubble Sort");
  puts("=======================");
  InicializaTeste();
  BubbleSort(vetor, TAM);
  MostraResultadoParcial();
  
  resultado_qtd_passada[0] = qtd_passadas;
  resultado_qtd_comparacoes[0] = qtd_comparacoes;
  resultado_qtd_trocas[0] = qtd_trocas;
  resultado_tempo[0] = tempo_diff;
 
  /*
    Método Selection Sort
  */

  puts("\n\nMetodo: Selection Sort");
  puts("==========================");
  memcpy(vetor, copia_vetor, sizeof(Registro) * TAM);
  InicializaTeste();
  SelectionSort(vetor, TAM);
  MostraResultadoParcial();

  resultado_qtd_passada[1] = qtd_passadas;
  resultado_qtd_comparacoes[1] = qtd_comparacoes;
  resultado_qtd_trocas[1] = qtd_trocas;
  resultado_tempo[1] = tempo_diff;

  /*
    Método Insertion Sort
  */

  puts("\n\nMetodo: Insertion Sort");
  puts("==========================");
  memcpy(vetor, copia_vetor, sizeof(Registro) * TAM);
  InicializaTeste();
  InsertionSort(vetor, TAM);
  MostraResultadoParcial();

  resultado_qtd_passada[2] = qtd_passadas;
  resultado_qtd_comparacoes[2] = qtd_comparacoes;
  resultado_qtd_trocas[2] = qtd_trocas;
  resultado_tempo[2] = tempo_diff;


  /*
    Método Shell Sort
  */

  puts("\n\nMetodo: Shell Sort");
  puts("======================");
  memcpy(vetor, copia_vetor, sizeof(Registro) * TAM);
  InicializaTeste();
  ShellSort(vetor, TAM);
  MostraResultadoParcial();

  resultado_qtd_passada[3] = qtd_passadas;
  resultado_qtd_comparacoes[3] = qtd_comparacoes;
  resultado_qtd_trocas[3] = qtd_trocas;
  resultado_tempo[3] = tempo_diff;
  
}     

/*
   TESTES DO TRABALHO
   
   Abaixo segue as funções para teste.
   
*/

void TesteTotalmenteDesordenado(){
     
  // Cria um vetor com dados aleatórios para o teste
  Registro *vetor = popula(vetor, TAM);    

  printf("\n\n**** TESTE TOTALMENTE DESORDENADO ****\n");
  printf("-------------------------------------\n\n");

  AplicaMetodosOrdenacao(
    vetor, 
    resultado_qtd_passada_tot_desordenado,
    resultado_qtd_comparacoes_tot_desordenado,
    resultado_qtd_trocas_tot_desordenado,
    resultado_tempo_tot_desordenado);
}     

void TesteParcialmenteOrdenado(){

  // Cria um vetor com dados aleatórios para o teste
  Registro *vetor = popula(vetor, TAM);    

  // Precisamos ordenar 50% do vetor para este teste, com certeza usando Shell sort!
  ShellSort(vetor, TAM / 2);
 
  printf("\n**** TESTE PARCIALMENTE ORDENADO ****\n");
  printf("-------------------------------------\n\n");
    
  AplicaMetodosOrdenacao(
    vetor, 
    resultado_qtd_passada_parc_ordenado,
    resultado_qtd_comparacoes_parc_ordenado,
    resultado_qtd_trocas_parc_ordenado,
    resultado_tempo_parc_ordenado);
}     

void TesteOrdenadoDecrescente(){
     
  // Cria um vetor com dados aleatórios para o teste
  Registro *vetor = popula(vetor, TAM);    

  // Precisamos ordenar 100% o vetor para este teste
  ShellSort(vetor, TAM);

  // Inverter de crescente para decreScente
  InverteVetor(vetor, TAM) ;

  printf("\n**** TESTE ORDENADO DECRESCENTE ****\n");
  printf("------------------------------------\n\n");
    
  AplicaMetodosOrdenacao(
    vetor, 
    resultado_qtd_passada_ordenado_desc,
    resultado_qtd_comparacoes_ordenado_desc,
    resultado_qtd_trocas_ordenado_desc,
    resultado_tempo_ordenado_desc);
  
}     

void TesteTotalmenteOrdenado(){

  // Cria um vetor com dados aleatórios para o teste
  Registro *vetor = popula(vetor, TAM);    

  // Precisamos ordenar 100% o vetor para este teste
  ShellSort(vetor, TAM);
 
  printf("\n**** TESTE TOTALMENTE ORDENADO ****\n");
  printf("------------------------------------\n\n");
  
  AplicaMetodosOrdenacao(
    vetor, 
    resultado_qtd_passada_tot_ordenado,
    resultado_qtd_comparacoes_tot_ordenado,
    resultado_qtd_trocas_tot_ordenado,
    resultado_tempo_tot_ordenado);
}     

void ExecutarTodosTestes(){

  // Executar todos os testes e coletar estatísticas 
  TesteTotalmenteDesordenado();
  TesteParcialmenteOrdenado();
  TesteOrdenadoDecrescente();
  TesteTotalmenteOrdenado();

  // Exibe as estatísticas
  printf("\n\n\t\t\t\tRESULTADO FINAL DA COMPARACAO DOS METODOS\n");
  printf("\t\t\t\t===========================================\n\n");
  printf("Metodo\t\t\t\t Qtd. Passada \t Qtd. Comp. \t Qtd. Trocas \t Tempo (segs)\n");
  printf("-----------------------------------------------------------------------------------------------\n");

  
  // Totalmente desordenado
  
  printf("Totalmente desordenado\n");
  printf("   Bubble Sort\t\t\t    %9.1d \t %9.1d \t  %9.1d", 
                                          resultado_qtd_passada_tot_desordenado[0], 
                                          resultado_qtd_comparacoes_tot_desordenado[0],
                                          resultado_qtd_trocas_tot_desordenado[0]);
  printf("\t    %9.2f\n", resultado_tempo_tot_desordenado[0]);                                                                                    

  printf("   Selection Sort\t\t    %9.1d \t %9.1d \t  %9.1d", 
                                          resultado_qtd_passada_tot_desordenado[1], 
                                          resultado_qtd_comparacoes_tot_desordenado[1],
                                          resultado_qtd_trocas_tot_desordenado[1]);
  printf("\t    %9.2f\n", resultado_tempo_tot_desordenado[1]);                                                                                    

  printf("   Insertion Sort\t\t    %9.1d \t %9.1d \t  %9.1d", 
                                          resultado_qtd_passada_tot_desordenado[2], 
                                          resultado_qtd_comparacoes_tot_desordenado[2],
                                          resultado_qtd_trocas_tot_desordenado[2]);
  printf("\t    %9.2f\n", resultado_tempo_tot_desordenado[2]);                                                                                    

  printf("   Shell Sort\t\t\t    %9.1d \t %9.1d \t  %9.1d", 
                                          resultado_qtd_passada_tot_desordenado[3], 
                                          resultado_qtd_comparacoes_tot_desordenado[3],
                                          resultado_qtd_trocas_tot_desordenado[3]);
  printf("\t    %9.2f\n", resultado_tempo_tot_desordenado[3]);                                                                                    


  // Parcialmente ordenado
  
  printf("\nParcialmente ordenado\n");
  printf("   Bubble Sort\t\t\t    %9.1d \t %9.1d \t  %9.1d", 
                                          resultado_qtd_passada_parc_ordenado[0], 
                                          resultado_qtd_comparacoes_parc_ordenado[0],
                                          resultado_qtd_trocas_parc_ordenado[0]);
  printf("\t    %9.2f\n", resultado_tempo_parc_ordenado[0]);                                                                                    

  printf("   Selection Sort\t\t    %9.1d \t %9.1d \t  %9.1d", 
                                          resultado_qtd_passada_parc_ordenado[1], 
                                          resultado_qtd_comparacoes_parc_ordenado[1],
                                          resultado_qtd_trocas_parc_ordenado[1]);
  printf("\t    %9.2f\n", resultado_tempo_parc_ordenado[1]);                                                                                    

  printf("   Insertion Sort\t\t    %9.1d \t %9.1d \t  %9.1d", 
                                          resultado_qtd_passada_parc_ordenado[2], 
                                          resultado_qtd_comparacoes_parc_ordenado[2],
                                          resultado_qtd_trocas_parc_ordenado[2]);
  printf("\t    %9.2f\n", resultado_tempo_parc_ordenado[2]);                                                                                    

  printf("   Shell Sort\t\t\t    %9.1d \t %9.1d \t  %9.1d", 
                                          resultado_qtd_passada_parc_ordenado[3], 
                                          resultado_qtd_comparacoes_parc_ordenado[3],
                                          resultado_qtd_trocas_parc_ordenado[3]);
  printf("\t    %9.2f\n", resultado_tempo_parc_ordenado[3]);                                                                                    

  // Ordenado decrecente
  
  printf("\nOrdenado decrescente\n");
  printf("   Bubble Sort\t\t\t    %9.1d \t %9.1d \t  %9.1d", 
                                          resultado_qtd_passada_ordenado_desc[0], 
                                          resultado_qtd_comparacoes_ordenado_desc[0],
                                          resultado_qtd_trocas_ordenado_desc[0]);
  printf("\t    %9.2f\n", resultado_tempo_ordenado_desc[0]);                                                                                    

  printf("   Selection Sort\t\t    %9.1d \t %9.1d \t  %9.1d", 
                                          resultado_qtd_passada_ordenado_desc[1], 
                                          resultado_qtd_comparacoes_ordenado_desc[1],
                                          resultado_qtd_trocas_ordenado_desc[1]);
  printf("\t    %9.2f\n", resultado_tempo_ordenado_desc[1]);                                                                                    

  printf("   Insertion Sort\t\t    %9.1d \t %9.1d \t  %9.1d", 
                                          resultado_qtd_passada_ordenado_desc[2], 
                                          resultado_qtd_comparacoes_ordenado_desc[2],
                                          resultado_qtd_trocas_ordenado_desc[2]);
  printf("\t    %9.2f\n", resultado_tempo_ordenado_desc[2]);                                                                                    

  printf("   Shell Sort\t\t\t    %9.1d \t %9.1d \t  %9.1d", 
                                          resultado_qtd_passada_ordenado_desc[3], 
                                          resultado_qtd_comparacoes_ordenado_desc[3],
                                          resultado_qtd_trocas_ordenado_desc[3]);
  printf("\t    %9.2f\n", resultado_tempo_ordenado_desc[3]);                                                                                    

  
  // Ordenado totalmente
  
  printf("\nTotalmente ordenado\n");
  printf("   Bubble Sort\t\t\t    %9.1d \t %9.1d \t  %9.1d", 
                                          resultado_qtd_passada_tot_ordenado[0], 
                                          resultado_qtd_comparacoes_tot_ordenado[0],
                                          resultado_qtd_trocas_tot_ordenado[0]);
  printf("\t    %9.2f\n", resultado_tempo_tot_ordenado[0]);                                                                                    

  printf("   Selection Sort\t\t    %9.1d \t %9.1d \t  %9.1d", 
                                          resultado_qtd_passada_tot_ordenado[1], 
                                          resultado_qtd_comparacoes_tot_ordenado[1],
                                          resultado_qtd_trocas_tot_ordenado[1]);
  printf("\t    %9.2f\n", resultado_tempo_tot_ordenado[1]);                                                                                    

  printf("   Insertion Sort\t\t    %9.1d \t %9.1d \t  %9.1d", 
                                          resultado_qtd_passada_tot_ordenado[2], 
                                          resultado_qtd_comparacoes_tot_ordenado[2],
                                          resultado_qtd_trocas_tot_ordenado[2]);
  printf("\t    %9.2f\n", resultado_tempo_tot_ordenado[2]);                                                                                    

  printf("   Shell Sort\t\t\t    %9.1d \t %9.1d \t  %9.1d", 
                                          resultado_qtd_passada_tot_ordenado[3], 
                                          resultado_qtd_comparacoes_tot_ordenado[3],
                                          resultado_qtd_trocas_tot_ordenado[3]);
  printf("\t    %9.2f\n", resultado_tempo_tot_ordenado[3]);
  
  printf("\n\n\t\t\t FOI UTILIZADO UM VETOR COM %d ELEMENTOS", TAM);  
  
}     

int main(int argc, char *argv[])
{

  printf("Trabalho de Ordenacao\n");
  printf("Aluno: Everton de Vargas Agilar\n");
  printf("Prof.: Alexandre Zamberlam\n");
  printf("=================================");

  char opcao;
  do{
      printf("\n\nSelecione um opcao (Tamanho do Vetor: %d)\n--------------------------------------------\n", TAM);
      puts("1 - Executar todos os metodos e mostrar o pior e melhor caso");
      puts("2 - Totalmente desordenado");
      puts("3 - Parcialmente Ordenado");
      puts("4 - Ja ordenado, porem de forma decrescente");
      puts("5 - Totalmente ordenado (crescente)");
      puts("6 - Alterar tamanho do vetor");
      puts("7 - SAIR");

      printf("OPCAO: ");
      opcao = getch();
      switch (opcao) {
             case '1': ExecutarTodosTestes(); break;
             case '2': TesteTotalmenteDesordenado(); break;
             case '3': TesteParcialmenteOrdenado(); break;
             case '4': TesteOrdenadoDecrescente(); break;
             case '5': TesteTotalmenteOrdenado(); break;
             case '6': AlteraTamanhoVetor(); break;
             case '7': exit(0);
      }       

      printf("\n\nVoltar para o menu ? (S, N): ");
      opcao = getch();
      
   } while (opcao == 'S' || opcao == 's');    
 
  puts("\n");
  system("PAUSE");	
  return 0;
}
