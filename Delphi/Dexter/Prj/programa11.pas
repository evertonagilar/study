program programa11;
var
  i, j, k: Integer;
begin
  i:= 1000;
  j:= 1000;
  k:= 1000;
  while i > 0 do
  begin
    while j > 0 do
      while k > 0 do
      begin
        Write('i: ');
        WriteLn(i);
        i:= i - 1;
        j:= j - 1;
        k:= k - 1;
      end;
  end;
end.
