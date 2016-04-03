using System;
using System.Collections.Generic;
using System.Text;

namespace ConsoleApplication1
{
    class Program
    {
        static void Main(string[] args)
        {
            int[] elementos = new int[20];
            int elem, QtdElemPares = 0, idx;
            
            for (int i = 0; i < 20; i++){
                idx = i + 1;
                Console.WriteLine("Digite o valor " + idx.ToString() + ":");
                elem = int.Parse(Console.ReadLine());
                elementos[i] = elem;
                if (elem % 2 == 0)
                    QtdElemPares++;

            }

            Console.WriteLine("Quantidade de elementos pares: " + QtdElemPares.ToString());

            Console.ReadKey();
        }
    }
}
