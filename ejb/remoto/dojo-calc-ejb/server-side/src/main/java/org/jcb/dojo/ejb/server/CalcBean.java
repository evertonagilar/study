package org.jcb.dojo.ejb.server;

import java.util.Scanner;

import javax.ejb.Remote;
import javax.ejb.Stateless;

@Stateless
@Remote(ICalc.class)
public class CalcBean implements ICalc {
	/* Declaração dos métodos */
	/* (non-Javadoc)
	 * @see org.jcb.calculadora.ICalc#som(int, int)
	 */
	@Override
	public int som(int num1, int num2) {
		return num1 + num2;
	}

	/* (non-Javadoc)
	 * @see org.jcb.calculadora.ICalc#sub(int, int)
	 */
	@Override
	public int sub(int num1, int num2) {
		return num1 - num2;
	}

	/* (non-Javadoc)
	 * @see org.jcb.calculadora.ICalc#div(int, int)
	 */
	@Override
	public int div(int num1, int num2) {
		return num1 / num2;
	}

	/* (non-Javadoc)
	 * @see org.jcb.calculadora.ICalc#mult(int, int)
	 */
	@Override
	public int mult(int num1, int num2) {
		return num1 * num2;
	}

	// --------------- Metodo principal
	public static void main(String args[]) {
		// criando um objeto c a apartir do metodo calc
		ICalc c = new CalcBean();
		// declarando as varíaveis
		int opcao = 5;
		int num1;
		int num2;
		Scanner input = new Scanner(System.in);
		System.out.println("-Escolha uma opção-");
		System.out.println("1. Soma");
		System.out.println("2. Subtracao");
		System.out.println("3. Multiplicacao");
		System.out.println("4. Divisao");
		System.out.println("0. Sair");
		System.out.println("Operação: ");
		opcao = input.nextInt();
		while (opcao != 0) {
			Scanner input1 = new Scanner(System.in);
			System.out.println("Qual o primeiro numero: ");
			num1 = input1.nextInt();
			System.out.println("Qual o segundo numero: ");
			num2 = input1.nextInt();
			if (opcao == 1) {
				int operacao = c.som(num1, num2);
				System.out.printf("\nO resultado da soma é: %d\n", operacao);
				break;
			} else if (opcao == 2) {
				int operacao = c.sub(num1, num2);
				System.out.printf("\nO resultado da subtração é: %d\n", operacao);
				break;
			} else if (opcao == 3) {
				int operacao = c.mult(num1, num2);
				System.out.printf("\nO resultado da multiplicação é: %d\n", operacao);
				break;
			} else if (opcao == 4) {
				int operacao = c.div(num1, num2);
				System.out.printf("\nO resultado da divisão é: %d\n", operacao);
				break;
			} else {
				System.out.println("????");
				break;
			}
		} // fim do while - usuario optou por sair
	} // fim do metodo principal
}
