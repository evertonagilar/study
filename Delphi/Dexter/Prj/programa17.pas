program programa17;
var
  i, j, k: Integer;
begin
  for (i:= 1; i <= 4; i:= i + 1) do
  begin
    Write('i: ');
    WriteLn(i);
    for (j:= 1; j <= 3; j:= j + 1) do
    begin
      for (k:= 1; k < 10; k:= k + 1) do
        Write(' ');
      Write('j: ');
      WriteLn(j);
    end;
  end;
end.


