program Exerc30;

uses CRT;

var
  Angulo: Integer;

begin
  ClrScr;
  WriteLn('Programa para determinar o quadrante de um angulo');

  WriteLn;
  Write('Informe o angulo: ');
  ReadLn(Angulo);
  WriteLn;

  if Angulo > 360 then
    Angulo:= Angulo mod 360;

  if Angulo = 0 then
    WriteLn('Angulo 0 - eixo X positivo')
  else if Angulo = 90 then
    WriteLn('Angulo 90 - eixo Y positivo')
  else if Angulo = 180 then
    WriteLn('Angulo 180 - eixo X negativo')
  else if Angulo = 270 then
    WriteLn('Angulo 270 - eixo Y negativo')
  else
  begin
    if (Angulo > 0) and (Angulo < 90) then
      WriteLn('Angulo ', Angulo, ' - 1 Quadrante')
    else if (Angulo > 90) and (Angulo < 180) then
      WriteLn('Angulo ', Angulo, ' - 2 Quadrante')
    else if (Angulo > 180) and (Angulo < 270) then
      WriteLn('Angulo ', Angulo, ' - 3 Quadrante')
    else if (Angulo > 270) and (Angulo < 360) then
      WriteLn('Angulo ', Angulo, ' - 4 Quadrante');
  end;

  WriteLn;
  WriteLn('Pressione qualquer tecla para continuar...');
  ReadKey;

end.
 