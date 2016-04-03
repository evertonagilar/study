program programa16;


  //********************************************************************
  //
  // Programa: programa15
  // Objetivo: Demonstrar uso da instrução "repeat until" aninhada.
  // Data: 08/07/2007
  //
  //********************************************************************

var
  i, j, k, l, m: Integer;
  soma: Integer;
begin
  i:= 1;
  j:= 1;
  k:= 1;
  l:= 1;
  m:= 100;
  soma:= 0;
  while m > 0 do
  begin
    repeat
      soma:= soma + i;
      i:= i + 1;
      repeat
        soma:= soma + j;
        j:= j + 1;
        repeat
          soma:= soma + k;
          k:= k + 1;
          repeat
            soma:= soma + l;
            l:= l + 1;
          until l > 9;
        until k > 9;
      until j > 9;
    until i > 9;
    m:= m - 1;
  end;
  Write('Soma: ');
  WriteLn(soma);
end.


