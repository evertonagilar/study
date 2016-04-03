{*******************************************************************}
{ TImpressoraFiscal                                                 }
{                                                                   }
{ Componente para comunicação de impressoas fiscais                 }
{                                                                   }
{ Impressoras suportadas:                                           }
{     Bematech                                                      }
{     Daruma                                                        }
{     Elgin                                                         }
{                                                                   }
{ Autor: Everton de Vargas Agilar                                   }
{ Ano: 2009                                                         }
{*******************************************************************}

unit UnImpressoraFiscal;

interface

uses
  SysUtils, Windows, Classes, UnImpFiscalInt;

type
  TDriverFunc = function(APorta: string; ATipo: TTipoImpressora; AIsEmulador: Boolean): IImpFiscal;

  TImpressoraFiscal = class(TComponent, IImpFiscal)
  private
    FhLib: THandle;
    FDriver: IImpFiscal;
    FTipoImpressora: TTipoImpressora;
    FPorta: string;
    FIsEmulador: Boolean;
    FLibName: string;
    procedure CarregaDriver;
    procedure DescarregaDriver;
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(APorta: string; ATipoImpressora: TTipoImpressora; AIsEmulador: Boolean); overload;
    destructor Destroy; override;

    // Informações
    function getNumeroSerie: string;
    function getNumeroCupom: Integer;
    function getProximoNumeroCupom: Integer;
    function getCaixa: Integer;
    function getLoja: Integer;

    function FecharPorta: Boolean;

    // Venda
    procedure AbreCupom;
    function VendeItem(
      const ACodigo, ADescricao: string;
      const AAliquota: string;
      AValorUnitario: Currency;
      AValorDesconto: Currency;
      AQuantidade: Real): Boolean;
    function CancelarCupom: Boolean;
    function CancelarItemGen(const ANumeroItem : string) : Boolean;
    function FechaCupom(
      const AFormaPgto: string;
      const ADescAcrescimo: Char;
      AValorDescAcrescimo: Currency;
      AValorDinheiro: Currency): Boolean; overload;

    // finalizando vendas
    function IniciaFechamentoCupom(
      const ADescAcrescimo: Char;
      const ATipoDescAcrescimo: Char;
      AValorDescAcrescimo: Currency): Boolean;
    function EfetuaFormaPagamentoCupom(
      const AFormaPgto: string;
      AValor: Currency): Boolean;
    function FechaCupom: Boolean; overload;


    // Identificação
    procedure IdentificaCliente(
      const ACodCli, ANomeCli, ACPFCNPJ, AIE, AEndereco, AData, AHora,
      APlaca, ACidade : string;
      const AOperador : string = '';
      const AVendedor: string = '');
    procedure IdentificaPlaca(const APlaca: string);
    procedure LimpaIdentificacao;

    // Relatórios
    function EmitirZ : Boolean;
    function EmitirX : Boolean;
    function EmitirLeituraMemFiscal(ADataInicial, ADataFinal: TDateTime) : Boolean;

    // Outros
    function AbrirGaveta : Boolean;
    function AutenticarDoc : Boolean;
    function progAliquota(const Aliq: string) : Boolean;
    function horarioVerao : Boolean;
    function getStatus : ifStatus;
    function getUltErro: string;
    function getValorTotal: Currency;
    function getModelo: string;
    function IsEmulador: Boolean;
    function FaltaRealizarReducaoZ: Boolean;
    function ReducaoZJaFoiRealizada: Boolean;
    function ImprimeComprovanteVinculado(const ATexto: string; const AFormaPgto: string) : Boolean;

    // Informações do cliente
    function getNomeCliente: string;
    function getCpfCnpjCliente: string;
    function getIECliente: string;
    function getEndereco: string;
    function getCidade: string;
    function getPlaca: string;
    function getDataSaida: string;
    function getHoraSaida: string;
    function getOperador: string;
    function getVendedor: string;


  published
    property TipoImpressora: TTipoImpressora read FTipoImpressora write FTipoImpressora default tiBematech;
    property Porta: string read FPorta write FPorta;
    property LibName: string read FLibName write FLibName;

  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('FiscalExpress', [TImpressoraFiscal]);
end;

{ TImpressoraFiscal }

procedure TImpressoraFiscal.AbreCupom;
begin
  FDriver.AbreCupom;
end;

function TImpressoraFiscal.AbrirGaveta: Boolean;
begin
  Result:= FDriver.AbrirGaveta;
end;

function TImpressoraFiscal.AutenticarDoc: Boolean;
begin
  Result:= FDriver.AutenticarDoc;
end;

function TImpressoraFiscal.CancelarCupom: Boolean;
begin
  Result:= FDriver.CancelarCupom;
end;

procedure TImpressoraFiscal.CarregaDriver;
var
  driverFunc: TDriverFunc;
begin
  FhLib:= LoadLibrary(PChar(FLibName));
  if FhLib = 0 then
    raise Exception.Create('Driver libfiscalunv.dll não localizado!');
  driverFunc:= Pointer(GetProcAddress(FhLib, 'getImpressora'));
  if not Assigned(driverFunc) then
    raise Exception.Create('Função de entrada do driver libfiscalunv.dll não localizado!');
  FDriver:= driverFunc(FPorta, FTipoImpressora, FIsEmulador);
end;

constructor TImpressoraFiscal.Create(AOwner: TComponent);
begin
  inherited;
  FTipoImpressora:= tiBematech;
  FPorta:= 'COM1';
  FIsEmulador:= False;
  FLibName:= 'libfiscalunv.dll';
  CarregaDriver;
end;

constructor TImpressoraFiscal.Create(APorta: string; ATipoImpressora: TTipoImpressora; AIsEmulador: Boolean);
begin
  inherited Create(nil);
  FTipoImpressora:= ATipoImpressora;
  FPorta:= APorta;
  FIsEmulador:= AIsEmulador;
  FLibName:= 'libfiscalunv.dll';
  CarregaDriver;
end;

procedure TImpressoraFiscal.DescarregaDriver;
begin
  try
//    if FhLib <> 0 then
//      FreeLibrary(FhLib);
  except

  end;
end;

destructor TImpressoraFiscal.Destroy;
begin
  inherited;
  DescarregaDriver;
end;

function TImpressoraFiscal.EmitirLeituraMemFiscal(ADataInicial,
  ADataFinal: TDateTime): Boolean;
begin
  Result:= FDriver.EmitirLeituraMemFiscal(ADataInicial, ADataFinal);
end;

function TImpressoraFiscal.EmitirX: Boolean;
begin
  Result:= FDriver.EmitirX;
end;

function TImpressoraFiscal.EmitirZ: Boolean;
begin
  Result:= FDriver.EmitirZ;
end;

function TImpressoraFiscal.FechaCupom(const AFormaPgto: string;
  const ADescAcrescimo: Char; AValorDescAcrescimo,
  AValorDinheiro: Currency): Boolean;
begin
  Result:= FDriver.FechaCupom(AFormaPgto, ADescAcrescimo, AValorDescAcrescimo, AValorDinheiro);
end;

function TImpressoraFiscal.FecharPorta: Boolean;
begin
  Result:= FDriver.FecharPorta;
end;

function TImpressoraFiscal.getCaixa: Integer;
begin
  Result:= FDriver.getCaixa;
end;

function TImpressoraFiscal.getLoja: Integer;
begin
  Result:= FDriver.getLoja;
end;

function TImpressoraFiscal.getNumeroCupom: Integer;
begin
  Result:= FDriver.getNumeroCupom;
end;

function TImpressoraFiscal.getProximoNumeroCupom: Integer;
begin
  Result:= FDriver.getProximoNumeroCupom;
end;

function TImpressoraFiscal.getNumeroSerie: string;
begin
  Result:= FDriver.getNumeroSerie;
end;

procedure TImpressoraFiscal.IdentificaCliente(const ACodCli, ANomeCli, ACPFCNPJ,
  AIE, AEndereco, AData, AHora, APlaca, ACidade, AOperador,
  AVendedor: string);
begin
  FDriver.IdentificaCliente(ACodCli, ANomeCli, ACPFCNPJ, AIE, AEndereco,
      AData, AHora, APlaca, ACidade, AOperador, AVendedor);
end;

procedure TImpressoraFiscal.LimpaIdentificacao;
begin
  FDriver.LimpaIdentificacao;
end;

function TImpressoraFiscal.VendeItem(const ACodigo, ADescricao, AAliquota: string;
  AValorUnitario, AValorDesconto: Currency; AQuantidade: Real): Boolean;
begin
  Result:= FDriver.VendeItem(ACodigo, ADescricao, AAliquota,
      AValorUnitario, AValorDesconto, AQuantidade);
end;

procedure TImpressoraFiscal.Loaded;
begin
  inherited;
  if not (csDesigning in ComponentState) then
    CarregaDriver;
end;

function TImpressoraFiscal.CancelarItemGen(const ANumeroItem: string): Boolean;
begin
  Result:= FDriver.CancelarItemGen(ANumeroItem);
end;

function TImpressoraFiscal.progAliquota(const Aliq: string): Boolean;
begin
  Result:= FDriver.progAliquota(Aliq);
end;

function TImpressoraFiscal.horarioVerao: Boolean;
begin
  Result:= FDriver.horarioVerao;
end;

function TImpressoraFiscal.getCidade: string;
begin
  Result:= FDriver.getCidade;
end;

function TImpressoraFiscal.getCpfCnpjCliente: string;
begin
  Result:= FDriver.getCpfCnpjCliente;
end;

function TImpressoraFiscal.getDataSaida: string;
begin
  Result:= FDriver.getDataSaida;
end;

function TImpressoraFiscal.getEndereco: string;
begin
  Result:= FDriver.getEndereco;
end;

function TImpressoraFiscal.getHoraSaida: string;
begin
  Result:= FDriver.getHoraSaida;
end;

function TImpressoraFiscal.getIECliente: string;
begin
  Result:= FDriver.getIECliente;
end;

function TImpressoraFiscal.getNomeCliente: string;
begin
  Result:= FDriver.getNomeCliente;
end;

function TImpressoraFiscal.getOperador: string;
begin
  Result:= FDriver.getOperador;
end;

function TImpressoraFiscal.getPlaca: string;
begin
  Result:= FDriver.getPlaca;
end;

function TImpressoraFiscal.getVendedor: string;
begin
  Result:= FDriver.getVendedor;
end;

procedure TImpressoraFiscal.IdentificaPlaca(const APlaca: string);
begin
  FDriver.IdentificaPlaca(APlaca);
end;

function TImpressoraFiscal.getStatus: ifStatus;
begin
  Result:= FDriver.getStatus;
end;

function TImpressoraFiscal.getUltErro: string;
begin
  Result:= FDriver.getUltErro;
end;

function TImpressoraFiscal.getValorTotal: Currency;
begin
  Result:= FDriver.getValorTotal;
end;

function TImpressoraFiscal.getModelo: string;
begin
  Result:= FDriver.getModelo;
end;

function TImpressoraFiscal.IsEmulador: Boolean;
begin
  Result:= FIsEmulador;
end;

function TImpressoraFiscal.FaltaRealizarReducaoZ: Boolean;
begin
  Result:= FDriver.FaltaRealizarReducaoZ;
end;

function TImpressoraFiscal.ReducaoZJaFoiRealizada: Boolean;
begin
  Result:= FDriver.ReducaoZJaFoiRealizada;
end;

function TImpressoraFiscal.FechaCupom: Boolean;
begin
  Result:= FDriver.FechaCupom;
end;

function TImpressoraFiscal.IniciaFechamentoCupom(const ADescAcrescimo,
  ATipoDescAcrescimo: Char; AValorDescAcrescimo: Currency): Boolean;
begin
  Result:= FDriver.IniciaFechamentoCupom(ADescAcrescimo, ATipoDescAcrescimo, AValorDescAcrescimo);
end;

function TImpressoraFiscal.EfetuaFormaPagamentoCupom(
  const AFormaPgto: string; AValor: Currency): Boolean;
begin
  Result:= FDriver.EfetuaFormaPagamentoCupom(AFormaPgto,AValor);
end;

function TImpressoraFiscal.ImprimeComprovanteVinculado(const ATexto,
  AFormaPgto: string): Boolean;
begin
  Result:= FDriver.ImprimeComprovanteVinculado(ATexto, AFormaPgto);
end;

end.
