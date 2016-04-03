#include <iostream>
#include <stdlib.h>

using namespace std;

int main(int argc, char *argv[])
{
    int numero, result;
    
    // Verifica se não há parâmetros
    if (argc == 1 && argv[1] == "--help"){
        cout << "fatorial - Calcula o fatorial de um numero." << endl;
        cout << "Use fatorial --help para obter mais informacoes." << endl;
    }        

    numero = atol(argv[1]);

    cout << "Fatorial..." << endl;
    result = numero;

    for (int i = numero; i != 0; i--){
        result = (int) result * i;
        cout << result << " * " << i-1 << " = " << result << endl;
    }        
    
    printf("Fatorial de %d = %d", numero, result);
    
  cout << endl;
  system("PAUSE");	
  return 0;
}
