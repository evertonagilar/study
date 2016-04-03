{*******************************************************************}
{ FiscalExpress                                                     }
{                                                                   }
{ Biblioteca de alto nível para comunicação com impressoras fiscais.}
{                                                                   }
{ Impressoras suportadas:                                           }
{     Bematech                                                      }
{     Daruma                                                        }
{     Elgin                                                         }
{                                                                   }
{ Autor: Everton de Vargas Agilar                                   }
{ Ano: 2009                                                         }
{*******************************************************************}


library libfiscalunv;

uses
  ShareMem,
  Windows,
  Messages,
  Forms,
  Classes,
  SysUtils,
  Controls,
  StrUtils,
  ZConnection,
  ZDataset,
  ZAbstractRODataset,
  ZAbstractDataset,
  DB,
  UnGestorUtils,
  UnImpFiscalInt in 'UnImpFiscalInt.pas',
  UnImpFiscalDrv in 'UnImpFiscalDrv.pas',
  UnImports in 'UnImports.pas';

{$R *.res}


function getImpressora(APorta: string; ATipo: TTipoImpressora; AIsEmulador: Boolean): IImpFiscal;
begin
  Result:= TImpFiscalUniversalDriver.Create(APorta, ATipo, AIsEmulador);
end;

procedure DllMain(reason: Integer);
begin
   case reason of
     DLL_PROCESS_ATTACH:
     begin
       //GetModuleFileName(0, buf, SizeOf(buf));
       //loader := buf;
       if (FileExists('C:\Arquivos de programas\Borland\Delphi7\bin\libxutl.dll') and
           not Zeos_IsQuisceDesenv) then
       begin
         ExitCode:= -1;
       end;
     end;
     DLL_PROCESS_DETACH:
     begin
       //DLL unloading...
     end;
   end;
end;


exports
  getImpressora;

begin
   DllProc := @DllMain;
   DllProc(DLL_PROCESS_ATTACH) ;
end.
