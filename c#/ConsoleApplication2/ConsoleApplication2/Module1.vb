Module Module1

    Sub Main()

        Dim Vetor1(9) As Integer
        Dim Vetor2(9) As Integer
        Dim Vetor3(9) As Integer
        Dim RefVetor As Object
        Dim elem As Integer
        Dim i, j As Integer

        ' Ler dados para o vetores 1 e 2
        For i = 0 To 1
            ' Obtém a referência do vetor para armazenar os dados
            If i = 0 Then
                Console.WriteLine("Informe os valores para o vetor 1:")
                RefVetor = Vetor1
            Else
                Console.WriteLine("Informe os valores para o vetor 2:")
                RefVetor = Vetor2
            End If

            ' Obtém os dados
            For j = 0 To 9
                Console.WriteLine("Digite o valor " + (j + 1).ToString)
                elem = Integer.Parse(Console.ReadLine())
                RefVetor(j) = elem
            Next
        Next

        For i = 0 To 9
            Vetor3(i) = Vetor1(i) * Vetor2(i)
            Console.WriteLine("Valor " + (i + 1).ToString + " = " + Vetor3(i).ToString)
        Next

        Console.ReadKey()

    End Sub



End Module
