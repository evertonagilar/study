program format;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes, UnGestorUtils;

var
  fmt, val, res: string;
begin
  WriteLn('Format - Utilitario para Teste do Format Delphi Function  V.2');
  WriteLn('Autor: Everton de Vargas Agilar');
  WriteLn;

  if ParamCount < 2 then
  begin
    WriteLn('Uso: "<format>" <valor');
    Exit;
  end;

  fmt:= QuotedStr(RemoveAspasAoRedor(ParamStr(1)));
  val:= ParamStr(2);
  val:= TrocaString(val, '.', ',');
  try
    if (Pos('d', fmt) > 0) or (Pos('u', fmt) > 0) then
      res:= SysUtils.Format(fmt, [StrToInt(val)])
    else if (Pos('f', fmt) > 0) or (Pos('g', fmt) > 0) or (Pos('n', fmt) > 0) then
      res:= SysUtils.Format(fmt, [StrToFloat(val)])
    else
      res:= SysUtils.Format(fmt, [val]);
  except
    WriteLn('Formato ou valor invalido!');
    Exit;
  end;
  fmt:= RemoveAspasAoRedor(fmt, #39);
  WriteLn(fmt + ' ' + val + ' = ' + res);
  WriteLn;
end.
