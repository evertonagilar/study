// Exerc4.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <stdlib.h>
#include <iostream>


// Retorna True/False se existe um valor em um vetor
bool ExisteValorVetor(int* pVetor, int TamVetor, int Valor){
	int* val;
	for (int i = 0; i < TamVetor; i++){
		val = pVetor + (i* sizeof(int));
		if (*val == Valor) 
			return true;
	}
	return false;
}


int _tmain(int argc, _TCHAR* argv[])
{
	using namespace std;

	int X[9], Y[9];
	int* P; 
	int elem;

	// Informe os dados do primeiro vetor 
	cout << "Informe os dados para o vetor X:\n";
	for (int i = 0; i < 10; i++){
		cout << "Informe o valor " << i+1 << ": ";
		cin >> elem;
		X[i] = elem;
	}
	
   // Informe os dados do segundo vetor 
	cout << "\nInforme os dados para o vetor X:\n";
	for (int i = 0; i < 10; i++){
		cout << "Informe o valor " << i+1 << ": ";
		cin >> elem;
		Y[i] = elem;
	}

	// Realizando a união dos vetores
	cout << "Realizando a uniao de X e Y:\n";
	P = new int(20);
	int idx = 0;
	
	// Adiciona os elementos de X
	for (int i = 0; i < 10; i++){
		elem = X[i];
		if (!ExisteValorVetor(P, 10, elem))
		  P[idx++] = elem;
	}

	// Adiciona os elementos de Y
	for (int i = 0; i < 9; i++){
		elem = Y[i];
		if (!ExisteValorVetor(P, 10, elem))
		  P[idx++] = elem;
	}

	// Mostra a uniao
	cout << "\nMostrando a uniao dos vetores:\n";
	for (int i = 0; i <= idx; i++){
		cout << "Valor " << i+1 << ": " << P[i] << endl;
	}

	
	system("PAUSE");
	return 0;
}

