program Exerc27;

uses CRT;

var
  p: Real;
  i: Real;
  n: Integer;
  Rendimento: Real;

  function Potencia(Base: Real; Expoente: Integer): Real;
  var
    Result: Real;
    i: Integer;
  begin
    if Base = 0 then
      Result:= 0
    else if Expoente = 0 then
      Result:= 1
    else
    begin
      Result:= Base;
      for i:= 1 to Expoente-1 do
        Result:= Result * Base;
    end;
    Potencia:= Result;
  end;

begin
  ClrScr;
  WriteLn('Programa calcula rendimento aplicacao em poupanca programada');
  WriteLn('-------------------------------------------');

  Write('Valor da aplicacao mensal: ');
  ReadLn(p);
  Write('Taxa (%): ');
  ReadLn(i);
  i:= i / 100;
  Write('Quantidade meses aplicacao: ');
  ReadLn(n);

  Rendimento:= p * (Potencia(1 + i, n) - 1) / i;

  WriteLn;
  WriteLn('Rendimento: ', Rendimento:4:2);

  WriteLn;
  WriteLn('Pressione qualquer tecla para terminar...');
  ReadKey;


end.
