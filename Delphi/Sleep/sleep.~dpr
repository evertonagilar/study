program sleep;

{$APPTYPE CONSOLE}

uses
  SysUtils;

var
  Tempo: Integer;
begin
  if (ParamCount = 0) then
  begin
    WriteLn('Sleep V.1');
    WriteLn('PoliDados Informatica Total');
    WriteLn('Autor: Everton de Vargas Agilar');
    WriteLn('Uso: sleep [segundos] [mensagem]');
    WriteLn('      segundos ==> Segundos a aguardar. Por padrao 1 segundo (opcional)');
    WriteLn('      mensagem ==> Mensagem exibida. (opcional)');
    Exit;
  end;

  if ParamCount > 0 then
    Tempo:= StrToIntDef(ParamStr(1), 1000)
  else
    Tempo:= 1000;

  if Tempo < 1000 then
    Tempo:= Tempo * 1000;

  if ParamCount = 2 then
    WriteLn(ParamStr(2))
  else
    WriteLn('Sleeping '+ IntToStr(Tempo div 1000) + ' segundos...');
  SysUtils.Sleep(Tempo);
end.
