program Exerc24;

uses CRT;

var
  IdadeDias: Integer;
  IdadeEmAnos: Integer;
  IdadeEmMeses: Integer;
  IdadeEmDias: Integer;
  Restante: Integer;

begin
  ClrScr;
  WriteLn('Programa calcula idade de uma pessoa');
  WriteLn('----------------------------------------');

  Write('Qual a sua idade em dias: ');
  ReadLn(IdadeDias);

  IdadeEmAnos:= IdadeDias div 365;
  Restante:= IdadeDias mod 365;
  IdadeEmMeses:= Restante div 30;
  IdadeEmDias:= Restante mod 30;

  WriteLn;
  WriteLn('Voce ja viveu ', IdadeEmAnos, ' anos, ', IdadeEmMeses,
    ' meses e ', IdadeEmDias, ' dias.');

  WriteLn;
  WriteLn('Pressine qualquer tecla...');
  ReadKey;
end.
