program programa14;
var
  i: Integer;
begin
  WriteLn('Exibe os numeros de 1 a 10 usando "repeat while"');
  i:= 1;
  repeat
    Write('i: ');
    WriteLn(i);
    i:= i + 1;
  while i <= 10;

  WriteLn();
  WriteLn('Exibe os numeros de 1 a 10 usando "repeat until"');
  i:= 1;
  repeat
    Write('i: ');
    WriteLn(i);
    i:= i + 1;
  until i > 10;

end.
