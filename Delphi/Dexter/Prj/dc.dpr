program dc;

{$APPTYPE CONSOLE}

uses
  UnDexter in 'UnDexter.pas',
  Classes,
  SysUtils;

var
  Interpretador: TInterpretador;
  PrjFileName: string;
  i: integer;
begin
  WriteLn('Interpretador Dexter');
  WriteLn('Unifra - Centro Universitario Franciscano');
  WriteLn('Copyright 2006/2007 - Everton de Vargas Agilar');
  WriteLn('------------------------------------------------');
  if ParamCount = 0 then
  begin
    WriteLn('Uso: dc fonte.pas');
    Exit;
  end
  else
  begin
    PrjFileName:= ParamStr(1);
    if FileExists(PrjFileName) then
    begin
      try
        Interpretador:= TInterpretador.Create(PrjFileName);
        try
          Interpretador.Execute;
          WriteLn;
          WriteLn(Interpretador.PrgName + ' executado!');
        finally
          Interpretador.Free;
        end;
      except
        WriteLn;
        WriteLn(PrjFileName + ' executado com erros!');
      end;
      WriteLn;
      WriteLn('Pressione a tecla enter sair...');
      ReadLn;
    end
    else
      WriteLn('Arquivo ' + PrjFileName + ' nao existe!');
  end;
end.
