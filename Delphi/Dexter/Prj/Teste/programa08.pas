program programa08.pas;

var
  i, j: Integer;

begin
  i:= 1;
  j:= 2;
  if i < j then
  begin
    WriteLn('i < j');
    i:= i + 1;
    if i < j then
    begin
      WriteLn('i < j');
      i:= i + 1;
      if i < j then
      begin
        WriteLn('i < j');
        i:= i + 1;
      end;
    end 
    else
    begin
      WriteLn('j > i');
      i:= i - 1;
      if i < j then
      begin
      WriteLn('i < j');
        i:= i + 1;
        if i < j then
        begin
          WriteLn('i < j');
          i:= i + 1;
          if i < j then
          begin
            WriteLn('i < j');
            i:= i + 1;
          end;
        end 
        else
        begin
          WriteLn('j > i');
          i:= i - 1;
        end;
     end;  
    end;
  end
  else
    WriteLn('j > i');

end.
  
