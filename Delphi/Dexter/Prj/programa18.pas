program programa18;
var
  i, num1, tmp: integer;
begin
  WriteLn('Informe 4 numeros:');
  num1:= 0;
  for (i:= 0; i < 4; i:= i + 1) do
  begin
    Write('Numero ');
    Write(i);
    Write(': ');
    ReadLn(tmp);
    num1:= num1 + tmp;
  end;
  Write('Total: ');
  WriteLn(num1);

  WriteLn();
  Write('Contando ate ');
  WriteLn(num1);
  WriteLn('----------------------');

  for (i:= 1; i <= num1; i:= i + 1) do
    WriteLn(i);

  WriteLn('----------------------');

  for (i:= num1; i > 0; i:= i - 1) do
    WriteLn(i);

  WriteLn('----------------------');

  for (i:= num1; i > 0; i:= i - 2) do
    WriteLn(i);

end.