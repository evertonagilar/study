program Exerc02;

uses CRT;

var
  NumeroVendedor: Integer;
  Salario: Real;
  TotalVendas: Real;
  SalarioTotal: Real;
begin
  ClrScr;
  WriteLn('Calcula salario');
  WriteLn('-----------------------');

  Write('Numero do vendedor: ');
  ReadLn(NumeroVendedor);
  Write('Salario fixo: ');
  ReadLn(Salario);
  Write('Total em Vendas: ');
  ReadLn(TotalVendas);

  if Salario <= 1000 then
    SalarioTotal:= Salario + (TotalVendas * 3 / 100)
  else if (Salario > 1000) and (Salario <= 2000) then
    SalarioTotal:= Salario + (TotalVendas * 5 / 100)
  else { > 2000 }
    SalarioTotal:= Salario + (TotalVendas * 10 / 100);

  WriteLn('');
  WriteLn('Numero do vendedor: ', NumeroVendedor);
  WriteLn('Total em Vendas: ', TotalVendas:4:2);
  WriteLn('Salario fixo: ', Salario:4:2);
  WriteLn('Salario total: ', SalarioTotal:4:2);

  ReadKey;


end.
