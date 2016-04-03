program Exerc26;

uses CRT;

var
  NomeFuncionario: string;
  Idade: Integer;
  Categoria: Char;
  SalarioBase: Real;
  SalarioBruto, SalarioLiquido: Real;

begin
  ClrScr;
  WriteLn('Programa calcula salario');
  WriteLn('------------------------------');

  Write('Nome do funcionario: ');
  ReadLn(NomeFuncionario);
  Write('Idade: ');
  ReadLn(Idade);
  Write('Categoria funcional (A, B, C): ');
  ReadLn(Categoria);
  Write('Salario base: ');
  ReadLn(SalarioBase);

  SalarioBase:= SalarioBase + (SalarioBase * 38 / 100);
  SalarioBruto:= SalarioBase + (SalarioBase * 20 / 100);
  SalarioLiquido:= SalarioBruto - (SalarioBruto * 15 / 100);

  WriteLn;
  WriteLn('Nome do funcionario: ', NomeFuncionario);
  WriteLn('Idade: ', Idade);
  WriteLn('Categoria funcional: ', Categoria);
  WriteLn('Salario bruto: ', SalarioBruto:4:2);
  WriteLn('Salario liquido: ', SalarioLiquido:4:2);

  WriteLn;
  WriteLn('Pressione qualquer tecla para continuar...');
  ReadKey;


end.
