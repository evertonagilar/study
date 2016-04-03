program programa12;
var
  i: Integer;
begin
  i:= 1;
  repeat
    Write('i: ');
    WriteLn(i);
    i:= i + 1;
  until  i > 1000;

  i:= 0;

  repeat i:= i + 1 until i > 15;

  repeat i:= i + 1; until i > 10000;

  repeat
    i:= i + 1;
    WriteLn(i)
  until i > 100;


end.
