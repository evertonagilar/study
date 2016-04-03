program Exerc15;

uses CRT;

var
  Matriz10x10: array[1..10, 1..10] of Integer;
  Matriz10x3: array[1..10, 1..10] of Integer;
  Valor: Integer;
  i, j, k: Integer;
begin
  ClrScr;
  WriteLn('Programa Le matriz esparsa e cria matriz condensada');
  WriteLn('------------------------------------------------------');

  WriteLn('Informe dados para Matriz10x10:');
  for i:= 1 to 10 do
  begin
    for j:= 1 to 10 do
    begin
      Write('Matriz10x10[', i, ', ', j, ']: ');
      ReadLn(Matriz10x10[i, j]);
    end;
  end;

  k:= 0;
  WriteLn;
  WriteLn('Matriz condensada contendo elementos nao nulos de Matriz10x10:');
  for i:= 1 to 10 do
  begin
    for j:= 1 to 10 do
    begin
      Valor:= Matriz10x10[i, j];
      if Valor <> 0 then
      begin
        Inc(k);
        Matriz10x3[k, 1]:= Valor;
        Matriz10x3[k, 2]:= i;
        Matriz10x3[k, 3]:= j;
      end;
    end;
  end;


  for i:= 1 to k do
    for j:= 1 to 3 do
      WriteLn('Matriz10x3[', i, ', ', j, ']: ', Matriz10x3[i, j]);

  WriteLn('Pressione qualquer tecla pra terminar...');
  ReadKey;
end.
