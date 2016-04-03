program programa07;
var
  i: Integer;
begin
  i:= 5;
  while i > 0 do
  begin
     if i < 2 then
       if i < 3 then
         if i < 4 then
           if i < 5 then
             if i > 6 then
             begin
               if i < 7 then
               begin
                 if i < 8 then
                   if i > 9 then
                     if i < 10 then
                       WriteLn('Teste de IF: 9 < 10');
               end;
             end
             else if i > 4 then
               WriteLn('5 nao e maior que 6 mas e maior que 4')
             else
               WriteLn('5 nao e maior que 6 e nem maior que 4');
    i:= i - 1;
  end;
end.