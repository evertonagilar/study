program Exerc28;

uses CRT;

var
  Numero1: Integer;
  Numero2: Integer;
  SomaNumeros: Integer;
  Media: Integer;
  QtdPares: Integer;
  i: Integer;
begin
  ClrScr;
  WriteLn('Programa que pede dois numeros inteiros positivos');
  WriteLn('---------------------------------------------');

  WriteLn('Informe dois numeros inteiros positivos: ');
  repeat
    Write('Numero 1: ');
    ReadLn(Numero1);
  until Numero1 >= 0;

  repeat
    Write('Numero 2: ');
    ReadLn(Numero2);
  until Numero2 >= 0;

  if Numero2 > Numero1 then
  begin
    SomaNumeros:= 0;
    for i:= Numero1 to Numero2 do
      SomaNumeros:= SomaNumeros + i;
    Media:= SomaNumeros div (Numero2 - Numero1);
    WriteLn('Media dos numeros do intervalo: ', Media);
  end

  else if Numero2 < Numero1 then
  begin
    QtdPares:= 0;
    for i:= Numero2 to Numero1 do
    begin
      if i mod 2 = 0 then
        QtdPares:= QtdPares + 1;
    end;
    WriteLn('Quantidade de numeros pares do intervalo: ', QtdPares);
  end
  else
    WriteLn('Os numeros sao iguais!');


  WriteLn;
  WriteLn('Pressione qualquer tecla para continuar...');
  ReadKey;
end.
