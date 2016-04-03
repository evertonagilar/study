program Exerc22;

uses CRT;

var
  opcao: Char;
  QtdNumeros: Integer;
  Numero, Total: Real;
  i: Integer;
begin
  ClrScr;
  WriteLn('Programa maquina esperta');
  Writeln('---------------------------');

  repeat
    WriteLn;
    WriteLn('MAQUINA ESPERTA');
    WriteLn('1   Soma varios numeros');
    WriteLn('2   Multiplica varios numeros');
    WriteLn('3   Sai do algoritmo');
    Write('OPCAO: ');
    ReadLn(opcao);
    WriteLn;

    case opcao of
      '1':
      begin
        Write('Qtd de numeros que deseja somar: ');
        ReadLn(QtdNumeros);
        Total:= 0;
        for i:= 1 to QtdNumeros do
        begin
          Write('Numero ', i, ': ');
          ReadLn(Numero);
          Total:= Total + Numero;
        end;
        WriteLn('Soma: ', Total:4:2);
      end;
      '2':
      begin
        Write('Qtd de numeros que deseja multiplicar: ');
        ReadLn(QtdNumeros);
        Total:= 0;
        for i:= 1 to QtdNumeros do
        begin
          Write('Numero ', i, ': ');
          ReadLn(Numero);
          if Total = 0 then
            Total:= Numero
          else
            Total:= Total * Numero;
        end;
        WriteLn('Produto: ', Total:4:2);
      end;
    end;
  until opcao = '3';

  WriteLn;
  WriteLn('Pressione qualquer tecla...');
  ReadKey;
end.
