#include <iostream>
#include <stdlib.h>
#include <iomanip.h>

using namespace std;

const int QTD_TIJOLO_AREA = 30;

int main(int argc, char *argv[])
{
    float Largura, Altura, Comprimento;
    float LarguraPorta, AlturaPorta;
    float AreaTotal, AreaPorta, AreaParede;
    float QtdTijolos;
    float PrecoTijolo, GastoTotalTijolo;
    
    // Obtém dados do usuário
    cout << "Informe a largura do pavilhão: ";
    cin >> Largura;  
    cout << "Informe a altura do pavilhão: ";
    cin >> Altura;  
    cout << "Informe o comprimento do pavilhão: ";
    cin >> Comprimento;  
    cout << "Informe o valor do tijolo: ";
    cin >> PrecoTijolo;  
    cout << "Informe a largura da porta de entrada: ";
    cin >> LarguraPorta;  
    cout << "Informe a altura da porta de entrada: ";
    cin >> AlturaPorta;  

    // Cálculos
    AreaPorta = LarguraPorta * AlturaPorta;
    AreaTotal = (Largura * Altura * 2) + (Comprimento * Altura * 2);
    AreaParede = AreaTotal - AreaPorta;
    QtdTijolos = AreaParede * QTD_TIJOLO_AREA;
    GastoTotalTijolo = PrecoTijolo * QtdTijolos;
    
    // Mostre os resultados
    cout << "Area total das paredes: " << setprecision(4) << AreaParede << endl;
    cout << "Numero de tijolos necessarios: " << setprecision(4) << QtdTijolos << endl;
    cout << "Valor gasto com a compra de tijolos: " << setprecision(4) << GastoTotalTijolo << endl;
  
  system("PAUSE");	
  return 0;
}
