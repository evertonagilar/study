program program10; 
var
  i, j: Integer;
begin
  i := 100;
  j:= 1;
  while i > 0 do
  begin
    Write('i: ');
    WriteLn(i);
    i:= i - 1;
    j:= 1;
    while j < 10 do
    begin
      Write('  j: ');
      WriteLn(j);
      j:= j + 1;
    end;
  end;
end.

