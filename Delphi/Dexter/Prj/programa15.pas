program programa15;

  //********************************************************************
  //
  // Programa: programa15
  // Objetivo: Demonstrar uso das instruções "repeat while" e
  // "repeat until" de forma aninhada.
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
  m:= 1000;
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
        while k < 10;
      until j > 9;
    while i < 10;
    m:= m - 1;
  end;
  Write('Soma: ');
  WriteLn(soma);
end.
