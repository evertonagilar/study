program Exerc29;

uses CRT;

var
  Ano: Integer;
  Peso: Real;
  Classe: Byte;
  TaxaRegistro: Real;

begin
  ClrScr;
  WriteLn('Determina classe de peso e taxa de registro de um automovel de Nova Jersey');
  WriteLn('---------------------------------------------------------------------------');

  WriteLn('Informe os dados do automovel:');
  Write('Ano: ');
  ReadLn(Ano);
  Write('Peso do modelo: ');
  ReadLn(Peso);

  Classe:= 0;
  TaxaRegistro:= 0;

  if Ano <= 1970 then
  begin
    if Peso < 1200 then
    begin
      Classe:= 1;
      TaxaRegistro:= 16.50;
    end
    else if (Peso >= 1200) and (Peso <= 1700) then
    begin
      Classe:= 2;
      TaxaRegistro:= 25.50;
    end
    else
    begin
      Classe:= 3;
      TaxaRegistro:= 46.50;
    end
  end
  else if (Ano > 1970) and (Ano <= 1979) then
  begin
    if Peso < 1200 then
    begin
      Classe:= 4;
      TaxaRegistro:= 27.00;
    end
    else if (Peso >= 1200) and (Peso <= 1700) then
    begin
      Classe:= 5;
      TaxaRegistro:= 30.50;
    end
    else
    begin
      Classe:= 6;
      TaxaRegistro:= 52.50;
    end
  end
  else
  begin
    if Peso < 1600 then
    begin
      Classe:= 7;
      TaxaRegistro:= 19.50;
    end
    else if Peso >= 3600 then
    begin
      Classe:= 8;
      TaxaRegistro:= 52.50;
    end;
  end;

  WriteLn;
  WriteLn('Classe: ', Classe);
  WriteLn('Taxa de Registro: $ ', TaxaRegistro:4:2);

  WriteLn;
  WriteLn('Pressione qualquer tecla para continuar...');
  ReadKey;

end.
