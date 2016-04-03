program programa06;
var
  opcao: Integer;
begin
  Write('Voce quer ir de onibus (1) ou motocicleta (2) para Agudo ? ');
  ReadLn(opcao);
  if opcao = 1 then
    WriteLn('Voce vai de onibus...')
  else 
  begin
    begin
      WriteLn('Voce vai de motocicleta...');
    end;
  end;

  if opcao = 2 then
  begin
    Write('humm, mas esta chovendo, não sera melhor ir de onibus (1/2) ?');
    ReadLn(opcao);
    if opcao = 2 then
      WriteLn('entao ta, voce que sabe, nao vou mais insistir...')
    else
    begin
      WriteLn('que bom que vai de onibus, com essa chuva...');
      WriteLn('Tu ia pegar uma chuva hein!');
    end;

  end;
end.