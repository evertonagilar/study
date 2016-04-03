program programa02;
var
  x, y: Integer;
  Result: Boolean;
begin
  WriteLn('Teste de escrita de string');
  Write('1 + 1 sao ');
  WriteLn(1 + 1);
  x:= 5;
  y:= 10;
  x:= 10;
  Write('X vale ');
  WriteLn(x);
  Write('Y vale ');
  WriteLn(y);

  Write('x = y: ');
  Result:= x = y;
  
  WriteLn(x = y = 5);  

  x:= x + 1;

  Write('Agora x = y: ');
  Result:= x = y;
  WriteLn(Result);  


  Write('x < y: ');
  Result:= x < y;
  WriteLn(Result);  
  WriteLn('Teste final de escrita...');;	

end.
