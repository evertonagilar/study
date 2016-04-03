program Exerc14;

uses CRT;

var
  Matriz5x5: array[1..5, 1..5] of Integer;
  SL: array[1..5] of Integer;
  SC: array[1..5] of Integer;
  SomaLin, SomaCol: Integer;
  lin, col: Integer;
  i: Integer;
begin
  ClrScr;

  WriteLn('Programa le matriz 5x5 e cria vetores SL(5) e SC(5)');
  WriteLn('-------------------------------------------------------');

  for lin:= 1 to 5 do
  begin
    for col:= 1 to 5 do
    begin
      Write('Informe valor ', lin, col, ': ');
      ReadLn(Matriz5x5[lin, col]);
    end;
  end;

  for lin:= 1 to 5 do
  begin
    SomaLin:= 0;
    for col:= 1 to 5 do
      SomaLin:= SomaLin + Matriz5x5[lin, col];
    SL[lin]:= SomaLin;
  end;

  for col:= 1 to 5 do
  begin
    SomaCol:= 0;
    for lin:= 1 to 5 do
      SomaCol:= SomaCol + Matriz5x5[lin, col];
    SC[col]:= SomaCol;
  end;

  WriteLn;
  WriteLn('Matriz:');
  for lin:= 1 to 5 do
  begin
    for col:= 1 to 5 do
      WriteLn('Matriz[', lin, ', ', col, '] := ', Matriz5x5[lin, col]);
  end;

  WriteLn;
  WriteLn('Vetor SL:');
  for i:= 1 to 5 do
    WriteLn('SL[', i, '] := ', SL[i]);

  WriteLn;
  WriteLn('Vetor SC:');
  for i:= 1 to 5 do
    WriteLn('SC[', i, '] := ', SC[i]);

  ReadKey;
end.
