#include <iostream>
#include <stdlib.h>
#include <iomanip>
#include <string>

using namespace std;

int main(int argc, char *argv[])
{
  float NHorasAluno;
  string NomeAluno;
  int NPresenca;
  float Nota1, Nota2;
  float Media, Frequencia;
  float MediaFinal, NotaExame;
  bool Aprovado;
  
  // Obtém os dados
  cout << "Numero de horas ministradas na disciplina: ";
  cin >> NHorasAluno;
  cout << "Nome do aluno: ";
  cin >> NomeAluno;
  cout << "Numero de presenca: ";
  cin >> NPresenca;
  cout << "Primeira nota do semrestre: ";
  cin >> Nota1;
  cout << "Segunda nota do semrestre: ";
  cin >> Nota2;
  
  // Cálculos
  Media = (Nota1 + Nota2) / 2;
  Frequencia = NPresenca / NHorasAluno * 100;
  
  if (Media >= 70){
      Aprovado = true;
      MediaFinal = Media;
  }
  else {
      if (Frequencia >= 7){
          cout << "Informe a nota do exame: ";
          cin >> NotaExame;
          MediaFinal = (Media + NotaExame) / 2;
          Aprovado = MediaFinal > 5;
      } 
      else {
          Aprovado = false;
      }                
  }        
          
  // Mostra resultados    
  cout << "Nome do aluno: " << NomeAluno << endl;
  cout << "Media do semestre: " << setprecision(4) << MediaFinal << endl;
  cout << "Frequencia: " << setprecision(4) << Frequencia << "%" << endl;
  
  string sAprovado = (Aprovado) ? "Aprovado!" : "Reprovado!";
  cout << sAprovado << endl;  
  
  system("PAUSE");	
  return 0;
}
