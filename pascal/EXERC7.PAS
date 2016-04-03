program Exerc7;

uses CRT;

var
  NumeroAndar: Integer;
  NumeroAndarAnterior: Integer;

begin
  WriteLn('Programa para simular um elevador');
  WriteLn('----------------------------------------');

  NumeroAndar:= 0;
  while True do
  begin
    NumeroAndarAnterior:= NumeroAndar;
    Write('Informe o andar: ');
    ReadLn(NumeroAndar);
    if NumeroAndar < 0 then Continue;
    if NumeroAndar > NumeroAndarAnterior then
      WriteLn('sobe')
    else if NumeroAndar < NumeroAndarAnterior then
      WriteLn('desce')
    else
      break;
  end;

  WriteLn;
  Write('Pressione qualquer tecla para terminar...');
  ReadKey;


end.
