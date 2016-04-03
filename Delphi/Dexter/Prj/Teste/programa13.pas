program programa13;
var
  i, j: Integer;
begin
  i:= 15;
  repeat
    i:= i - 1;
    j:= i;
    while j < i+1 do
      j:= j + 1;
    Write('i: ');
    Write(i);
    Write('  j: ');
    WriteLn(j);
  while i > 0;
end.
