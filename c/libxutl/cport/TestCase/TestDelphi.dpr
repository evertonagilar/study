program TestDelphi;

{$APPTYPE CONSOLE}



uses
  SysUtils;

type
  TTime = Real;
  PTime = ^TTime;

function Zeos_ltrim(str: PAnsiChar): PAnsiChar; stdcall; external 'D:\Projetos\libxutl\cport\libxutl.dll';
procedure Zeos_SetLogFileName(const ALogFileName: PAnsiChar); stdcall; external 'D:\Projetos\libxutl\cport\libxutl.dll';
function Zeos_GetLogFileName: PAnsiChar; stdcall; external 'D:\Projetos\libxutl\cport\libxutl.dll';
function Zeos_WriteAlert(const AMessage: PAnsiChar): Integer; stdcall; external 'D:\Projetos\libxutl\cport\libxutl.dll';
function Zeos_StrDateTime(time: PTime): PAnsiChar; stdcall; external 'D:\Projetos\libxutl\cport\libxutl.dll';

var
  str: PAnsiChar;
  str2: PAnsiChar;
  str3: AnsiString;
  v: string;
begin
  try
    Writeln(Zeos_StrDateTime(nil));

    Zeos_SetLogFileName('c:\log.txt');
    Zeos_WriteAlert('Escrevendo no log...');

    GetMem(str, 100);
    StrPCopy(str, '   Everton Agilar');
    str2:= Zeos_ltrim(str);
    WriteLn(str2);

    str3:= 'c:\log.txt';
    Zeos_SetLogFileName(PAnsiChar(str3));
    str3:= 'c:\temp\log.txt';
    Writeln(Zeos_GetLogFileName);

    StrPCopy(str2, str3);
    Zeos_SetLogFileName(str2);
    Zeos_WriteAlert('escrevendo no log...');
    Writeln(Zeos_GetLogFileName);
    StrPCopy(str2, 'c:\poligestor\log.txt');
    Writeln(Zeos_GetLogFileName);



      Readln(v);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
