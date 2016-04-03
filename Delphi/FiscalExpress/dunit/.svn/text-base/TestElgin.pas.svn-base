unit TestElgin;

interface

uses
  TestFrameWork, UnImpressoraFiscal, UnImpFiscalInt, UnTestImpInt;

type
  TImpressoraTest = class(TTestCase, ITestImp)
  published
    procedure testProgramaAliquota;
    procedure testLeituraX;
    procedure testLeituraZ;
    procedure testVendaEVerificaTotal;
    procedure testVendaComDescontoItem;
    procedure testVendaCancelaItemGenerico;
    procedure testCancelaCupom;
    procedure testComandoCancelaCupom;

  end;

implementation




{ TImpressoraTest }

procedure TImpressoraTest.testCancelaCupom;
var
  Impressora: TImpressoraFiscal;
begin
  Impressora:= TImpressoraFiscal.Create('COM4', tiElgin, True);
  try
    CheckTrue(Impressora.VendeItem('1', 'PRODUTO1, ', '1700', 0.1, 0, 10));
    CheckTrue(Impressora.VendeItem('2', 'PRODUTO2, ', '1200', 0.1, 0, 10));
    CheckTrue(Impressora.VendeItem('3', 'PRODUTO3, ', '2500', 0.1, 0, 10));
    CheckTrue(Impressora.CancelarCupom);
  finally
    Impressora.Free;
  end;
end;

procedure TImpressoraTest.testComandoCancelaCupom;
var
  Impressora: TImpressoraFiscal;
begin
  Impressora:= TImpressoraFiscal.Create('COM4', tiElgin, True);
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
  Impressora:= TImpressoraFiscal.Create('COM4', tiElgin, True);
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
{  Impressora:= TImpressoraFiscal.Create('COM4', tiElgin);
  try
    CheckTrue(Impressora.EmitirZ);
  finally
    Impressora.Free;
  end;}
end;

procedure TImpressoraTest.testProgramaAliquota;
var
  Impressora: TImpressoraFiscal;
begin
  Impressora:= TImpressoraFiscal.Create('COM4', tlElgin, True);
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
  Impressora:= TImpressoraFiscal.Create('COM4', tiElgin, True);
  try
    CheckTrue(Impressora.VendeItem('1', 'PRODUTO1, ', '1700', 0.1, 0, 10));
    CheckTrue(Impressora.VendeItem('2', 'PRODUTO2, ', '1200', 0.1, 0, 10));
    CheckTrue(Impressora.VendeItem('3', 'PRODUTO3, ', '2500', 0.1, 0, 10));
    CheckEquals(0.3, Impressora.getValorTotal);
    CheckTrue(Impressora.FechaCupom('Dinheiro', 'D', 10, 50));
  finally
    Impressora.Free;
  end;
end;

procedure TImpressoraTest.testVendaCancelaItemGenerico;
var
  Impressora: TImpressoraFiscal;
begin
  Impressora:= TImpressoraFiscal.Create('COM4', tiElgin, True);
  try
    CheckTrue(Impressora.VendeItem('1', 'PRODUTO1, ', '1700', 0.1, 0, 1));
    CheckTrue(Impressora.VendeItem('2', 'PRODUTO2, ', '1200', 0.1, 0, 1));
    CheckTrue(Impressora.VendeItem('3', 'PRODUTO3, ', '2500', 0.1, 0, 1));
    CheckTrue(Impressora.VendeItem('4', 'PRODUTO4, ', '1700', 0.1, 0, 1));
    CheckTrue(Impressora.CancelarItemGen('2'));
    CheckTrue(Impressora.FechaCupom('Dinheiro', 'D', 0, 0.5));
  finally
    Impressora.Free;
  end;
end;

procedure TImpressoraTest.testVendaComDescontoItem;
var
  Impressora: TImpressoraFiscal;
begin
  Impressora:= TImpressoraFiscal.Create('COM4', tiElgin, True);
  try
    CheckTrue(Impressora.VendeItem('1', 'PRODUTO1, ', '1700', 0.10, 0.05, 1));
    CheckTrue(Impressora.VendeItem('2', 'PRODUTO2, ', '1200', 0.11, 0, 2));
    CheckTrue(Impressora.VendeItem('3', 'PRODUTO3, ', '2500', 0.12, 0, 3));
    CheckTrue(Impressora.FechaCupom('Dinheiro', 'D', 0, 100));
  finally
    Impressora.Free;
  end;
end;

initialization

RegisterTest('Fiscal Express', TImpressoraTest.Suite);


end.
