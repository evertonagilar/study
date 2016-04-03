program programa22;

var
  temp: string;
  x, y: Integer;

function Rotina(): string;
begin
  //WriteLn('rotina...');
  temp:= 'passou pela rotina...';
  Result:= temp;

end;

var k: Integer;

function Fatorial5(): integer;
begin
  writeln('i=', i);
  k:= i;
  i:= i-1;
  if i > 1 then
  begin
    Result:= Fatorial5() * k;
    Writeln('return ', result);
  end
  else
    Result:= k;
end;

function add(): integer;
begin
  x:= x + y;
  Result:= x;
end;

var
  i: Integer;
begin
  i:= 5;
  writeln('Faorial de 5: ', Fatorial5());
  for (i := 0; i < 5; i:= i + 1) do
  begin
    writeln(Rotina());
    writeln('for: ', temp);
  end;
  Rotina();
  temp:= 'Everton' + ' de ' + ' Vargas Agilar';
  WriteLn(temp);
  temp:= '';
  temp:= 'Thaise';
  temp:= temp + ' Stefanelo Agilar';
  WriteLn('Everton' + ' & ' + temp);
  WriteLn('select * from produto ' || ' where desc = arroz');
  WriteLn(temp + '...');
  WriteLn('D', 'e', 'x', 't' + 'er' + '!');
  Rotina();

  x:= 10; y:= 10;
  writeln('result: ', Add()+10);
  WriteLn('result: ', x);

  {*connect 'txt:c:\autoexec.bat' into txt;
  for select * from txt.lines
    into tmp
  do
    WriteLn(tmp);

  connect 'sql:firebird:c:\argos\db\argos.fdb' into db1;
  for select codigo, descricao, precovenda
    from db1.produto
    into codigo, descricao, precovenda
  do
  begin
    WriteLn('Produto: ', p.codigo || ' - ' || p.descricao);
  end;

  *}

  ReadLn(temp);

end.
