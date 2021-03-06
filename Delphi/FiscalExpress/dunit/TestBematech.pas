unit TestBematech;

interface

uses
  TestFrameWork, UnImpressoraFiscal, UnImpFiscalInt, UnTestImpInt,
  UnGestorUtils, Dialogs;

type
  TImpressoraTest = class(TTestCase, ITestImp)
  published
    procedure testProgramaAliquota;
    procedure testLeituraX;
    procedure testVendaEVerificaTotal;
    procedure testVendaComDescontoItem;
    procedure testVendaCancelaItemGenerico;
    procedure testVendaComCupomVinculado;
    procedure testCancelaCupom;
    procedure testComandoCancelaCupom;
    procedure testLeituraZ;

  end;

var
  isEmulador: Boolean;
  Porta: string;

implementation

uses SysUtils;


{ TImpressoraTest }

procedure TImpressoraTest.testCancelaCupom;
var
  Impressora: TImpressoraFiscal;
begin
  Impressora:= TImpressoraFiscal.Create(Porta, tiBematech, IsEmulador);
  try
    CheckTrue(Impressora.VendeItem('1', 'PRODUTO1, ', '1700', 1, 0, 10));
    CheckTrue(Impressora.VendeItem('2', 'PRODUTO2, ', '1200', 1, 0, 10));
    CheckTrue(Impressora.VendeItem('3', 'PRODUTO3, ', '2500', 1, 0, 10));
    CheckTrue(Impressora.CancelarCupom);
  finally
    Impressora.Free;
  end;
end;

procedure TImpressoraTest.testComandoCancelaCupom;
var
  Impressora: TImpressoraFiscal;
begin
  Impressora:= TImpressoraFiscal.Create(Porta, tiBematech, IsEmulador);
  try
    CheckTrue(Impressora.CancelarCupom);
  finally
    Impressora.Free;
  end;
end;

procedure TImpressoraTest.testLeituraX;
var
  Impressora: TImpressoraFiscal;
begin
  Impressora:= TImpressoraFiscal.Create(Porta, tiBematech, IsEmulador);
  try
    CheckTrue(Impressora.EmitirX);
  finally
    Impressora.Free;
  end;
end;

procedure TImpressoraTest.testLeituraZ;
var
  Impressora: TImpressoraFiscal;
begin
  if MsgQuestion('Deseja fazer a redu��o Z ?') then
  begin
    Impressora:= TImpressoraFiscal.Create(Porta, tiBematech, IsEmulador);
    try
      CheckTrue(Impressora.EmitirZ);
    finally
      Impressora.Free;
    end;
  end;  
end;

procedure TImpressoraTest.testProgramaAliquota;
var
  Impressora: TImpressoraFiscal;
begin
  Impressora:= TImpressoraFiscal.Create(Porta, tiBematech, IsEmulador);
  try
    CheckTrue(Impressora.progAliquota('0700'));
    CheckTrue(Impressora.progAliquota('1200'));
    CheckTrue(Impressora.progAliquota('1700'));
    CheckTrue(Impressora.progAliquota('2500'));
  finally
    Impressora.Free;
  end;
end;

procedure TImpressoraTest.testVendaEVerificaTotal;
var
  Impressora: TImpressoraFiscal;
begin
  Impressora:= TImpressoraFiscal.Create(Porta, tiBematech, IsEmulador);
  try
    CheckTrue(Impressora.VendeItem('1', 'PRODUTO1, ', '1700', 1, 0, 10));
    CheckTrue(Impressora.VendeItem('2', 'PRODUTO2, ', '1200', 1, 0, 10));
    CheckTrue(Impressora.VendeItem('3', 'PRODUTO3, ', '2500', 1, 0, 10));
    CheckTrue(Impressora.FechaCupom('Dinheiro', 'D', 10, 50));
  finally
    Impressora.Free;
  end;
end;

procedure TImpressoraTest.testVendaCancelaItemGenerico;
var
  Impressora: TImpressoraFiscal;
begin
  Impressora:= TImpressoraFiscal.Create(Porta, tiBematech, IsEmulador);
  try
    CheckTrue(Impressora.VendeItem('1', 'PRODUTO1, ', '1700', 10, 5, 1));
    CheckTrue(Impressora.VendeItem('2', 'PRODUTO2, ', '1200', 10, 5, 2));
    CheckTrue(Impressora.VendeItem('3', 'PRODUTO3, ', '2500', 10, 0, 1));
    CheckTrue(Impressora.VendeItem('4', 'PRODUTO4, ', '1700', 10, 0, 1));
    CheckTrue(Impressora.CancelarItemGen('2'));
    CheckTrue(Impressora.FechaCupom('Dinheiro', 'D', 0, 50));
  finally
    Impressora.Free;
  end;
end;

procedure TImpressoraTest.testVendaComDescontoItem;
var
  Impressora: TImpressoraFiscal;
begin
  Impressora:= TImpressoraFiscal.Create(Porta, tiBematech, IsEmulador);
  try
    CheckTrue(Impressora.VendeItem('1', 'PRODUTO1, ', '1700', 10, 5, 1));
    CheckTrue(Impressora.VendeItem('2', 'PRODUTO2, ', '1200', 12, 6, 2));
    CheckTrue(Impressora.VendeItem('3', 'PRODUTO3, ', '2500', 11, 0, 3));
    CheckTrue(Impressora.FechaCupom('Dinheiro', 'D', 0, 100));
  finally
    Impressora.Free;
  end;
end;

procedure TImpressoraTest.testVendaComCupomVinculado;
var
  Impressora: TImpressoraFiscal;
begin
  Impressora:= TImpressoraFiscal.Create(Porta, tiBematech, IsEmulador);
  try
    CheckTrue(Impressora.VendeItem('1', 'PRODUTO1, ', '1700', 1, 0, 10));
    CheckTrue(Impressora.VendeItem('2', 'PRODUTO2, ', '1200', 1, 0, 10));
    CheckTrue(Impressora.VendeItem('3', 'PRODUTO3, ', '2500', 1, 0, 10));
    Impressora.IniciaFechamentoCupom('D', '%', 0);
    Impressora.EfetuaFormaPagamentoCupom('CREDIARIO', 100);
    Impressora.ImprimeComprovanteVinculado('RECIBO'#13'PAGO POR ESTE RECIBO'#13'AQUANTIDADE DE', 'CREDIARIO');
    Impressora.FechaCupom;
  finally
    Impressora.Free;
  end;
end;

initialization

isEmulador:= ExisteAppParam('emulador') or MsgQuestion('Impressora fiscal � um emulador ?');
if ExisteAppParam('porta') then
  Porta:= GetAppParam('porta')
else
  Porta:= IntToStr(StrToIntDef(InputBox('Qual a porta serial ?', 'Porta Serial', '1'), 1));
RegisterTest('Fiscal Express', TImpressoraTest.Suite);


end.
