program program05;
var
  i: Integer;
begin
  Writeln('Programa este if-then-else');
  i:= 0;
  if 1 = 1 then
  begin
    i:= 5;
    Write('i = '); WriteLn(i);
    WriteLn('1 = 1');
  end; 
  if 1 < 2 then
  begin
    if 1 > 2 then
    begin
      i:= 1;
      Write('i = '); WriteLn(i);
      WriteLn('1 > 2');
    end  
    else
      i:= 2;
    WriteLn('1 < 2');
  end
  else
  begin
    i:= 3;
    WriteLn('2 > 1');
  end;	


end.


