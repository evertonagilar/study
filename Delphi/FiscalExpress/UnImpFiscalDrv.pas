
{***************************************************************************}
{ TImpFiscalUniversalDriver                                                 }
{                                                                           }
{ Driver universal que implementa a interface IImpFiscal.                   }
{                                                                           }
{ Impressoras suportadas:                                                   }
{     Bematech                                                              }
{     Daruma                                                                }
{     Elgin                                                                 }
{                                                                           }
{ Autor: Everton de Vargas Agilar                                           }
{ Ano: 2009                                                                 }
{                                                                           }
{ Alterado:                                                                 }
{    29/04/2010 por Everton Agilar                                          }
{     - Revisado log                                                        }
{     - O nome do arquivo de log foi renomeado para libfiscalunv.log        }
{***************************************************************************}

unit UnImpFiscalDrv;

interface

uses
  SysUtils, Classes, Dialogs, UnImpFiscalInt, UnGestorUtils, UnImports;

type
  TImpFiscalUniversalDriver = class(TComponent, IImpFiscal)
  private
    FPorta: string;
    FTipoImpressora: TTipoImpressora;
    FAbriuCupom: Boolean;
    FCpfCnpj: string;
    FMensagemPromocional: string;
    FIsEmulador: Boolean;
    FCodCliente: string;
    FNomeCliente: string;
    FIECliente: string;
    FEndereco: string;
    FDataSaida: string;
    FHoraSaida: string;
    FPlaca: string;
    FCidade: string;
    FOperador: string;
    FVendedor: string;
    FIdentificacao: string;
    FUltErro: string;
    function TrataErroElgin(ret: Integer): Boolean;
    function TrataErroBematech(ret: Integer): Boolean;
    function TrataErroDaruma(ret: Integer): Boolean;
    function CheckRetorno(ret: Integer): Boolean;
    procedure Erro(const S: string);
  public
    constructor Create(
      const APorta: string = 'COM1';
      ATipoImpressora: TTipoImpressora = tiBematech;
      AIsEmulador: Boolean = False);
    destructor Destroy;

    // Informa��es
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
    // Finalizando e fechando cupom
    function FechaCupom(
      const AFormaPgto: string;
      const ADescAcrescimo: Char;
      AValorDescAcrescimo: Currency;
      AValorDinheiro: Currency): Boolean; overload;

    function IniciaFechamentoCupom(
      const ADescAcrescimo: Char;
      const ATipoDescAcrescimo: Char;
      AValorDescAcrescimo: Currency): Boolean;
    function EfetuaFormaPagamentoCupom(
      const AFormaPgto: string;
      AValor: Currency): Boolean;
    function FechaCupom: Boolean; overload;

    // Identifica��o
    procedure IdentificaCliente(
      const ACodCli, ANomeCli, ACPFCNPJ, AIE, AEndereco, AData, AHora,
      APlaca, ACidade : string;
      const AOperador : string = '';
      const AVendedor: string = '');
    procedure IdentificaPlaca(const APlaca: string);
    procedure LimpaIdentificacao;

    // Relat�rios
    function EmitirZ : Boolean;
    function EmitirX : Boolean;
    function EmitirLeituraMemFiscal(ADataInicial, ADataFinal: TDateTime) : Boolean;
    function ImprimeComprovanteVinculado(const ATexto: string; const AFormaPgto: string) : Boolean;

    // Outros
    function AbrirGaveta : Boolean;
    function AutenticarDoc : Boolean;
    function progAliquota(const Aliq: string) : Boolean;
    function horarioVerao : Boolean;
    function getStatus : ifStatus;
    function getUltErro: string;
    function getValorTotal: Currency;
    function getModelo: string;
    function isEmulador: Boolean;
    function FaltaRealizarReducaoZ: Boolean;
    function ReducaoZJaFoiRealizada: Boolean;

    // Informa��es do cliente
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


    property TipoImpressora: TTipoImpressora read FTipoImpressora;
    property AbriuCupom: Boolean read FAbriuCupom;
    property CpfCnpj: string read FCpfCnpj write FCpfCnpj;
    property MensagemPromocional: string read FMensagemPromocional write FMensagemPromocional;
  end;

implementation

var
  emul_nro_serie: string = '1';
  emul_nro_cupom: Integer = 1;


{ TImpFiscalUniversalDriver }

procedure _WriteAlert(const S: string);
const
  logname : string = 'c:\poligestor\libfiscalunv.log';
var
  Arq: TextFile;
begin
  // Existe tamb�m uma implementa��o na classe TFormPlus
  AssignFile(Arq, logname);
  if FileExists(logname) then
    Append(Arq)
  else
    Rewrite(Arq);
  try
    if S <> '' then
      Writeln(Arq, DateTimeToStr(Now) + ' ' + S)
    else
      WriteLn(Arq, ' ');
  finally
    CloseFile(Arq);
  end;
end;

procedure TImpFiscalUniversalDriver.AbreCupom;
var
  sEmpresa: string;
  retorno_imp_fiscal: Integer;
begin
  _WriteAlert('dll abre cupom');
  case FTipoImpressora of
    tiDaruma:
    begin
       _WriteAlert('retorno_imp_fiscal:= Daruma_FI_AbreCupom( PAnsiChar( CpfCnpj ) );');
       retorno_imp_fiscal:= Daruma_FI_AbreCupom( PAnsiChar( CpfCnpj ) );
       _WriteAlert('ret Daruma_FI_AbreCupom: '+ IntToStr(retorno_imp_fiscal));
       FAbriuCupom:= True;
    end;
    tiBematech:
    begin
       _WriteAlert('retorno_imp_fiscal:= Bematech_FI_AbreCupom( PAnsiChar( CpfCnpj ) );');
       retorno_imp_fiscal:= Bematech_FI_AbreCupom( PAnsiChar( CpfCnpj ) );
       _WriteAlert('ret Bematech_FI_AbreCupom: '+ IntToStr(retorno_imp_fiscal));
       FAbriuCupom:= True;
    end;
    tiElgin:
    begin
      _WriteAlert('retorno_imp_fiscal:= Elgin_FI_AbreCupom( PAnsiChar( CpfCnpj ) );');
      retorno_imp_fiscal:= Elgin_AbreCupom( PAnsiChar( CpfCnpj ) );
      _WriteAlert('ret Elgin_FI_AbreCupom: '+ IntToStr(retorno_imp_fiscal));
      FAbriuCupom:= True;
    end;
  end;
end;

constructor TImpFiscalUniversalDriver.Create(
  const APorta: string = 'COM1';
  ATipoImpressora: TTipoImpressora = tiBematech;
  AIsEmulador: Boolean = False);
begin
  inherited Create(nil);
  FPorta:= LowerCase(APorta);
  FTipoImpressora:= ATipoImpressora;
  FAbriuCupom:= False;
  FCpfCnpj:= '';
  FMensagemPromocional:= '';
  FIsEmulador:= AIsEmulador;
  FCodCliente:= '';
  FNomeCliente:= '';
  FIECliente:= '';
  FEndereco:= '';
  FDataSaida:= '';
  FHoraSaida:= '';
  FPlaca:= '';
  FCidade:= '';
  FOperador:= '';
  FVendedor:= '';
  FIdentificacao:= '';
  FUltErro:= '';
  _WriteAlert(#13#10'Conectando impressora com libfiscalunv.dll em '+ FormatDateTime('dd/mm/yyyy hh:nn', Now));
  _WriteAlert('   Porta: '+ FPorta + '  Emulador: ' + BoolToSimNao(FIsEmulador) + ' TipoImpressora: '+ IntToStr(Byte(ATipoImpressora)));
end;

destructor TImpFiscalUniversalDriver.Destroy;
begin
  inherited;
end;

function TImpFiscalUniversalDriver.getNumeroCupom: Integer;
var
  Str_proximoCupom: string;
  retorno_imp_fiscal: Integer;
begin
  if isEmulador then
  begin
    Result:= emul_nro_cupom;
    Inc(emul_nro_cupom);
  end
  else
  begin
    SetLength (Str_proximoCupom,6);
    case FTipoImpressora of
      tiDaruma:
      begin
        retorno_imp_fiscal:= Daruma_FI_NumeroCupom(Str_proximoCupom);
        _WriteAlert('ret Daruma_FI_NumeroCupom: '+ Str_proximoCupom);
        Result:= (StrToInt(str_proximoCupom));
      end;
      tiBematech:
      begin
        retorno_imp_fiscal:= Bematech_FI_NumeroCupom(Str_proximoCupom);
        _WriteAlert('ret Bematech_FI_NumeroCupom: '+ Str_proximoCupom);
        Result:= StrToIntDef(str_proximoCupom, 1);
      end;
      tiElgin:
      begin
        retorno_imp_fiscal:= Elgin_NumeroCupom(Str_proximoCupom);
        Result:= StrToInt(str_proximoCupom);
        _WriteAlert('ret Elgin_FI_NumeroCupom: '+ Str_proximoCupom);
        TrataErroElgin(retorno_imp_fiscal);
      end;
    end;
  end;
end;

function TImpFiscalUniversalDriver.getNumeroSerie: string;
var
  sNumero_serie: string;
  retorno_imp_fiscal: Integer;
begin
  if isEmulador then
    Result:= emul_nro_serie
  else
  begin
    //--- Pega o numero de serie do ecf
    SetLength (sNumero_serie,15);

    case FTipoImpressora of
      tiDaruma: retorno_imp_fiscal:= Daruma_FI_NumeroSerie(sNumero_serie);
      tiBematech: Bematech_FI_NumeroSerie(sNumero_serie);
      tiElgin:
      begin
        Elgin_NumeroSerie(sNumero_serie);
        TrataErroElgin(retorno_imp_fiscal);
      end;
    end;
  end;
end;


function TImpFiscalUniversalDriver.VendeItem(const ACodigo, ADescricao,
  AAliquota: string; AValorUnitario, AValorDesconto: Currency; AQuantidade: Real): Boolean;
var
  Str_Codigo: string;
  Str_Descricao: string;
  Str_Aliquota: string;
  Str_Tipo_de_Quantidade: string;
  Str_Quantidade: string;
  Int_Casas_Decimais: Integer;
  Str_Valor_Unitario: string;
  Str_Tipo_de_Desconto: string;
  Str_Valor_do_Desconto: string;
  sRetorno: string;
  Retorno_imp_Fiscal: Integer;
begin
  Str_Codigo := '';
  Str_Descricao:='';
  Str_Aliquota:='';
  Str_Tipo_de_Quantidade:='';
  Str_Quantidade:='';
  Int_Casas_Decimais:=0;
  Str_Valor_Unitario:='';
  Str_Tipo_de_Desconto:='';
  Str_Valor_do_Desconto:='';
  sRetorno:= '';

  Str_Codigo := Trim(ACodigo);
  Str_Descricao := Trim(ADescricao);
  Str_Aliquota := AAliquota;

{  if ( (AAliquota='II') OR (AAliquota='NN') OR (AAliquota='FF') ) Then
     Str_Aliquota := AAliquota;
  else
     Str_aliquota:= Copy(AAliquota, 1, 2) + ',' + '00';
}

  //Str_Tipo_de_Quantidade :='I';
  //Str_Quantidade :=formatfloat('#,##0.00',dados.tbl_itensPDVQUANTIDADE.AsFloat);

  Str_Tipo_de_Quantidade :='F';
  Str_Quantidade :=formatfloat('#,##0.000', AQuantidade);

  Int_Casas_Decimais :=2;
  Str_Valor_Unitario:=formatfloat('###,###,##0.00', AValorUnitario);

  case FTipoImpressora of
    tiDaruma:
    begin
       //Str_Tipo_de_Desconto := Trim('1');
       //Str_Valor_do_Desconto := Trim('0,00');
       Str_Tipo_de_Desconto := Trim('$');
       Str_Valor_do_Desconto := formatfloat('###,###,##0.00', AValorDesconto);
    end;
    tiBematech:
    begin
       //Str_Tipo_de_Desconto := Trim('%');
       //Str_Valor_do_Desconto := Trim('0000');
       Str_Tipo_de_Desconto := Trim('$');
       Str_Valor_do_Desconto := formatfloat('###,###,##0.00', AValorDesconto);
    end;
    tiElgin:
    begin
       //Str_Tipo_de_Desconto := Trim('%');
       //Str_Valor_do_Desconto := Trim('0000');
       Str_Tipo_de_Desconto := Trim('$');
       Str_Valor_do_Desconto := formatfloat('###,###,##0.00', AValorDesconto);
    end;
  end;

  _WriteAlert('init VendeItem: ACodigo: '+ ACodigo + ' ADescricao: '+ ADescricao +
    ' AAliquota: '+ AAliquota + ' AValorUnitario: '+ Str_Valor_Unitario +
    ' AValorDesconto: '+ Str_Valor_do_Desconto + ' AQuantidade: ' + Str_Quantidade);

  case FTipoImpressora of
    tiDaruma:
    begin
       Retorno_imp_Fiscal := Daruma_FI_VendeItem(PAnsiChar( Str_Codigo ), PAnsiChar( Str_Descricao ), PAnsiChar( Str_Aliquota ), PAnsiChar( Str_Tipo_de_Quantidade ), PAnsiChar( Str_Quantidade ), Int_Casas_Decimais, PAnsiChar( Str_Valor_Unitario ), PAnsiChar( Str_Tipo_de_Desconto ), PAnsiChar( Str_Valor_do_Desconto ) );
       Result:= Retorno_imp_Fiscal = 1;
       _WriteAlert('ret Daruma_VendeItem: '+ IntToStr(Retorno_imp_Fiscal));
       {if sRetorno = '0'   then  showmessage ('Erro de comunica��o.');
       if sRetorno = '-2'  then  showmessage ('Par�metro inv�lido na fun��o.');
       if sRetorno = '-3'  then  showmessage ('Al�quota n�o programada.');
       if sRetorno = '-4'  then  showmessage ('O arquivo de inicializa��o BemaFI32.ini n�o foi encontrado no diret�rio de sistema do Windows.');
       if sRetorno = '-5'  then  showmessage ('Erro ao abrir a porta de comunica��o.');
       if sRetorno = '-27' then  showmessage ('Status da impressora diferente de 6,0,0');}
    end;
    tiBematech:
    begin
       Retorno_imp_Fiscal := Bematech_FI_VendeItem(PAnsiChar( Str_Codigo ), PAnsiChar( Str_Descricao ), PAnsiChar( Str_Aliquota ), PAnsiChar( Str_Tipo_de_Quantidade ), PAnsiChar( Str_Quantidade ), Int_Casas_Decimais, PAnsiChar( Str_Valor_Unitario ), PAnsiChar( Str_Tipo_de_Desconto ), PAnsiChar( Str_Valor_do_Desconto ) );
       Result:= CheckRetorno(retorno_imp_fiscal);
       _WriteAlert('ret Bematech_VendeItem: '+ IntToStr(Retorno_imp_Fiscal));
       {if sRetorno = '0'   then  showmessage ('Erro de comunica��o.');
       if sRetorno = '-2'  then  showmessage ('Par�metro inv�lido na fun��o.');
       if sRetorno = '-3'  then  showmessage ('Al�quota n�o programada.');
       if sRetorno = '-4'  then  showmessage ('O arquivo de inicializa��o BemaFI32.ini n�o foi encontrado no diret�rio de sistema do Windows.');
       if sRetorno = '-5'  then  showmessage ('Erro ao abrir a porta de comunica��o.');
       if sRetorno = '-27' then  showmessage ('Status da impressora diferente de 6,0,0');}
    end;
    tiElgin:
    begin
       Retorno_imp_Fiscal:= Elgin_VendeItem( PAnsiChar ( Str_Codigo ),
                                               PAnsiChar( Str_Descricao ),
                                               PAnsiChar( Str_Aliquota ),
                                               PAnsiChar( Str_Tipo_de_Quantidade ),
                                               PAnsiChar( Str_Quantidade ),
                                               int_Casas_Decimais,
                                               PAnsiChar( Str_Valor_Unitario ),
                                               PAnsiChar( Str_Tipo_de_Desconto ),
                                               PAnsiChar( Str_Valor_do_Desconto ) );
       Result:= TrataErroElgin(retorno_imp_fiscal);
       _WriteAlert('ret Elgin_VendeItem: '+ IntToStr(Retorno_imp_Fiscal));
    end;
  end;
end;

// Funcao original
function TImpFiscalUniversalDriver.FechaCupom(
  const AFormaPgto: string;
  const ADescAcrescimo: Char;
  AValorDescAcrescimo: Currency;
  AValorDinheiro: Currency): Boolean;
var
  S_Forma_de_Pagamento: String;
  S_Acrescimo_ou_Desconto: String;
  S_Tipo_Acrescimo_ou_Desconto: String;
  S_Valor_Acrescimo_ou_Desconto: String;
  sValor: string;
  iRetorno: Integer;
  Retorno_imp_Fiscal: Integer;
begin
   S_Acrescimo_ou_Desconto:= ADescAcrescimo;
   S_Tipo_Acrescimo_ou_Desconto:= '$';
   s_Valor_Acrescimo_ou_Desconto:=formatfloat('###,###,##0.00', AValorDescAcrescimo);

   case FTipoImpressora of
     tiDaruma:
     begin
       iRetorno:=Daruma_FI_IniciaFechamentoCupom( PAnsiChar(s_Acrescimo_ou_Desconto), PAnsiChar(s_Tipo_Acrescimo_ou_Desconto), PAnsiChar(s_Valor_Acrescimo_ou_Desconto));
     end;
     tiBematech:
     begin
       iRetorno:=Bematech_FI_IniciaFechamentoCupom( PAnsiChar(s_Acrescimo_ou_Desconto), PAnsiChar(s_Tipo_Acrescimo_ou_Desconto), PAnsiChar(s_Valor_Acrescimo_ou_Desconto));
     end;
     tiElgin:
     begin
       iRetorno:=Elgin_IniciaFechamentoCupom( PAnsiChar(s_Acrescimo_ou_Desconto), PAnsiChar(s_Tipo_Acrescimo_ou_Desconto), PAnsiChar(s_Valor_Acrescimo_ou_Desconto));
       TrataErroElgin(iRetorno);
     end;
   end;

   // Executa a rotina EFETUAFORMAPAGAMENTO
   if (AValorDinheiro > 0) then
   begin
      S_Forma_de_Pagamento:='DINHEIRO';
      sValor:=formatfloat('###,###,##0.00', AValorDinheiro);
      case FTipoImpressora of
        tiDaruma:
        begin
           Retorno_imp_Fiscal:=Daruma_FI_EfetuaFormaPagamento( PAnsiChar( S_Forma_de_Pagamento), PAnsiChar(sValor));
        end;
        tiBematech:
        begin
           Retorno_imp_Fiscal:=Bematech_FI_EfetuaFormaPagamento( PAnsiChar( S_Forma_de_Pagamento), PAnsiChar(sValor));
        end;
        tiElgin:
        begin
           Retorno_imp_Fiscal:=Elgin_EfetuaFormaPagamento( PAnsiChar( S_Forma_de_Pagamento), PAnsiChar(sValor));
           TrataErroElgin(retorno_imp_fiscal);
        end;
      end;
   end;

{   if (ed_cheque.value > 0) then
   begin
      S_Forma_de_Pagamento:='CHEQUE';
      sValor:=formatfloat('###,###,##0.00',ed_cheque.value);
      if s_ImpFiscal = 'ECF Daruma' then
      begin
         Retorno_imp_Fiscal:=Daruma_FI_EfetuaFormaPagamento( PAnsiChar( S_Forma_de_Pagamento), PAnsiChar(sValor));
      end;
      if s_ImpFiscal = 'ECF Bematech' then
      begin
         Retorno_imp_Fiscal:=Bematech_FI_EfetuaFormaPagamento( PAnsiChar( S_Forma_de_Pagamento), PAnsiChar(sValor));
      end;
      if s_ImpFiscal = 'ECF Elgin' then
      begin
         Retorno_imp_Fiscal:=Elgin_EfetuaFormaPagamento( PAnsiChar( S_Forma_de_Pagamento), PAnsiChar(sValor));
         TrataErroElgin(retorno_imp_fiscal);
      end;
   end;

   if (ed_cartao.Value = 0) then
   begin
      // Executa a rotina IDENTIFICACONSUMIDOR
      if (s_nome_consumidor <> '') then
      begin
         if s_ImpFiscal = 'ECF Daruma' then
            Retorno_imp_Fiscal:=Daruma_FI_IdentificaConsumidor( PAnsiChar(S_Nome_Consumidor), PAnsiChar(S_Endereco), PAnsiChar(S_CPF_ou_CNPJ));
      end;
 }

  // Executa a rotina TERMINAFECHAMENTOCUPOM
  case FTipoImpressora of
    tiDaruma:
    begin
       Retorno_imp_Fiscal:=Daruma_FI_TerminaFechamentoCupom( PAnsiChar(FIdentificacao));
    end;
    tiBematech:
    begin
      Retorno_imp_Fiscal:=Bematech_FI_TerminaFechamentoCupom( PAnsiChar(FIdentificacao));
    end;
    tiElgin:
    begin
       Retorno_imp_Fiscal:=Elgin_TerminaFechamentoCupom( PAnsiChar(FIdentificacao));
    end;
  end;

  LimpaIdentificacao;
  Result:= True;
end;

function TImpFiscalUniversalDriver.getCaixa: Integer;
begin
  Result:= 1;
end;

function TImpFiscalUniversalDriver.getLoja: Integer;
begin
  Result:= 1;
end;

function TImpFiscalUniversalDriver.CancelarCupom: Boolean;
var
  Retorno_imp_Fiscal: Integer;
begin
   case FTipoImpressora of
     tiDaruma:
     begin
       Retorno_imp_Fiscal:= Daruma_FI_CancelaCupom();
       _WriteAlert('ret Daruma_FI_CancelaCupom: '+ IntToStr(Retorno_imp_Fiscal));
     end;
     tiBematech:
     begin
       Retorno_imp_Fiscal:= Bematech_FI_CancelaCupom();
       _WriteAlert('ret Bematech_FI_CancelaCupom: '+ IntToStr(Retorno_imp_Fiscal));
     end;
     tiElgin:
     begin
       Retorno_imp_Fiscal:= Elgin_CancelaCupom();
       TrataErroElgin(retorno_imp_fiscal);
       _WriteAlert('ret Elgin_FI_CancelaCupom: '+ IntToStr(Retorno_imp_Fiscal));
     end;
   end;
   Result:= Retorno_imp_Fiscal = 1;
   LimpaIdentificacao;
end;

procedure TImpFiscalUniversalDriver.IdentificaCliente(const ACodCli, ANomeCli,
  ACPFCNPJ, AIE, AEndereco, AData, AHora, APlaca, ACidade: string;
  const AOperador: string = '';
  const AVendedor: string = '');
var
  tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7, tmp8, tmp9, tmp10: string;
begin
   // **************************************************************************
   // Fun��o que monta a idenTImpFiscalUniversalDriverica��o do cliente para impress�o
   // Formato dos dados
   // Cliente: 99999999999999999999 (C�digo=20)
   //    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx (Nome=35)
   // CNPJ:00.101.058/0001-21 IE:109/0198512
   // xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx (Endere�o=38)
   // Cidade : xxxxxxxxxxxxxxxxxxxx - xx
   // Sa�da: 22/03/00 �s 16:44
   // Placa do ve�culo : IIA - 7894
   // Assinatura : _________________________________
   //***************************************************************************

    FCodCliente:= ACodCli;
    FNomeCliente:= ANomeCli;
    FCpfCnpj:= ACPFCNPJ;
    FIECliente:= AIE;
    FEndereco:= AEndereco;
    FDataSaida:= AData;
    FHoraSaida:= AHora;
    FPlaca:= APlaca;
    FCidade:= ACidade;
    FOperador:= AOperador;

   if FCodCliente <> '' then
     tmp1:= 'Matr�cula: '+ FCodCliente + #13 + #10;

   // Nome do Cliente
   If FNomeCliente <> '' Then
     tmp2:= 'Cliente: ' + FNomeCliente + #13 + #10;

   //CPF/CNPJ e Inscri��o Estadual
   if (FCPFCNPJ <> '') then
   begin
     if IsCNPJ(ExtraiNumero(FCpfCnpj)) then
        tmp3:= 'CNPJ: '+  FCpfCnpj + #13 + #10 + 'I.E: ' + AIE + #13 + #10
     else
        tmp3:= 'CPF: '+  FCpfCnpj +  #13 + #10 + 'I.E: ' + AIE + #13 + #10;
   end;

   //Endere�o
   if FEndereco <> '' then
     tmp4 := 'Endere�o: '+ FEndereco + #13 + #10;

   //Data e hora de sa�da
   if (FDataSaida <> '') and (FHoraSaida <> '') then
     tmp5:= 'Sa�da: '+ FDataSaida + ' ' + FHoraSaida + #13 + #10;

   //placa do ve�culo / observa��o
   if FPlaca <> '' then
     tmp6:= 'Placa do ve�culo: '+ FPlaca + #13 + #10;

   //Cidade
   if FCidade <> '' then
     tmp7:= 'Cidade: '+ FCidade + #13 + #10;

   // Operador
   if FOperador <> '' then
     tmp8:= 'Operador: '+ FOperador + #13 + #10;

   // Vendedor
   if FOperador <> '' then
     tmp9:= 'Vendedor: '+ FVendedor + #13 + #10;

   // Assinatura
   if FCPFCNPJ <> '' then
     tmp10:= 'Assinatura: ____________________________' + #13 + #10;

   FIdentificacao := tmp1 + tmp2 + tmp3 + tmp4 + tmp5 + tmp6 + tmp7 + tmp8 + tmp9 + tmp10;
end;

procedure TImpFiscalUniversalDriver.LimpaIdentificacao;
begin
  FCodCliente:= '';
  FNomeCliente:= '';
  FCpfCnpj:= '';
  FIECliente:= '';
  FEndereco:= '';
  FDataSaida:= '';
  FHoraSaida:= '';
  FPlaca:= '';
  FCidade:= '';
  FOperador:= '';
  FVendedor:= '';
  FIdentificacao:= '';
end;

function TImpFiscalUniversalDriver.EmitirX: Boolean;
var
  retorno_imp_fiscal: Integer;
begin
  case FTipoImpressora of
    tiDaruma:
    begin
       retorno_imp_fiscal:= Daruma_FI_LeituraX;
    end;
    tiBematech:
    begin
       retorno_imp_fiscal:= Bematech_FI_LeituraX;
    end;
    tiElgin:
    begin
       retorno_imp_fiscal:= Elgin_LeituraX;
    end;
  end;
  Result:= CheckRetorno(retorno_imp_fiscal);
end;

function TImpFiscalUniversalDriver.EmitirZ: Boolean;
var
  retorno_imp_fiscal: Integer;
begin
  case FTipoImpressora of
    tiDaruma:
    begin
       retorno_imp_fiscal:= Daruma_FI_ReducaoZ('', '');
    end;
    tiBematech:
    begin
       retorno_imp_fiscal:= Bematech_FI_ReducaoZ('', '');
    end;
    tiElgin:
    begin
       retorno_imp_fiscal:= Elgin_ReducaoZ('', '');
    end;
  end;
  Result:= CheckRetorno(retorno_imp_fiscal);
end;

function TImpFiscalUniversalDriver.TrataErroElgin(ret: Integer): Boolean;
var
  iCodErro: integer;
  strErroMsg: string;
begin
  if (ret <> 1) then
  begin
    strErroMsg := StringOfChar(' ',100);
    Elgin_RetornoImpressora( iCodErro, strErroMsg );
    FUltErro:= 'Erro N� '+inttostr(iCodErro)+chr(13)+chr(10)+strErroMsg;
  end;
  Result:= ret = 1;
end;

function TImpFiscalUniversalDriver.FecharPorta: Boolean;
var
  retorno_imp_fiscal: Integer;
begin
  case FTipoImpressora of
    tiDaruma:
    begin
       retorno_imp_fiscal:= Daruma_FI_FechaPortaSerial;
    end;
    tiBematech:
    begin
       retorno_imp_fiscal:= Bematech_FI_FechaPortaSerial;
    end;
    tiElgin:
    begin
       retorno_imp_fiscal:= Elgin_FechaPortaSerial;
    end;
  end;
  Result:= CheckRetorno(retorno_imp_fiscal);
end;

function TImpFiscalUniversalDriver.EmitirLeituraMemFiscal(ADataInicial,
  ADataFinal: TDateTime): Boolean;
var
  retorno_imp_fiscal: Integer;
  dtInicial, dtFinal: string;
begin
  dtInicial := FormatDateTime('ddmmyy', ADataInicial);
  dtFinal := FormatDateTime('ddmmyy', ADataFinal);

  case FTipoImpressora of
    tiDaruma:
    begin
       retorno_imp_fiscal:= Daruma_FI_LeituraMemoriaFiscalData(PAnsiChar(dtInicial), PAnsiChar(dtFinal));
    end;
    tiBematech:
    begin
       retorno_imp_fiscal:= Bematech_FI_LeituraMemoriaFiscalData(PAnsiChar(dtInicial), PAnsiChar(dtFinal));
    end;
    tiElgin:
    begin
       retorno_imp_fiscal:= Elgin_LeituraMemoriaFiscalData(PAnsiChar(dtInicial), PAnsiChar(dtFinal), '1');
    end;
  end;
  Result:= CheckRetorno(retorno_imp_fiscal);
end;

function TImpFiscalUniversalDriver.AbrirGaveta: Boolean;
var
  retorno_imp_fiscal: Integer;
begin
  case FTipoImpressora of
    tiDaruma:
    begin
       retorno_imp_fiscal:= Daruma_FI_AcionaGaveta;
    end;
    tiBematech:
    begin
       retorno_imp_fiscal:= Bematech_FI_AcionaGaveta;
    end;
    tiElgin:
    begin
       retorno_imp_fiscal:= Elgin_AcionaGaveta;
    end;
  end;
  Result:= CheckRetorno(retorno_imp_fiscal);
end;

function TImpFiscalUniversalDriver.AutenticarDoc: Boolean;
var
  retorno_imp_fiscal: Integer;
begin
  case FTipoImpressora of
    tiDaruma:
    begin
       retorno_imp_fiscal:= Daruma_FI_Autenticacao;
    end;
    tiBematech:
    begin
       retorno_imp_fiscal:= Bematech_FI_Autenticacao;
    end;
    tiElgin:
    begin
       retorno_imp_fiscal:= Elgin_Autenticacao;
    end;
  end;
  Result:= CheckRetorno(retorno_imp_fiscal);
end;

function TImpFiscalUniversalDriver.CancelarItemGen(
  const ANumeroItem: string): Boolean;
var
  retorno_imp_fiscal: Integer;
begin
  case FTipoImpressora of
    tiDaruma:
    begin
       retorno_imp_fiscal:= Daruma_FI_CancelaItemGenerico(ANumeroItem);
    end;
    tiBematech:
    begin
       retorno_imp_fiscal:= Bematech_FI_CancelaItemGenerico(ANumeroItem);
    end;
    tiElgin:
    begin
       retorno_imp_fiscal:= Elgin_CancelaItemGenerico(ANumeroItem);
    end;
  end;
  Result:= CheckRetorno(retorno_imp_fiscal);
end;

function TImpFiscalUniversalDriver.progAliquota(
  const Aliq: string): Boolean;
var
  retorno_imp_fiscal: Integer;
begin
  case FTipoImpressora of
    tiDaruma:
    begin
       retorno_imp_fiscal:= Daruma_FI_ProgramaAliquota(PAnsiChar(Aliq), 0);
    end;
    tiBematech:
    begin
       retorno_imp_fiscal:= Bematech_FI_ProgramaAliquota(PAnsiChar(Aliq), 0);
    end;
    tiElgin:
    begin
       retorno_imp_fiscal:= Elgin_ProgramaAliquota(PAnsiChar(Aliq), 0);
    end;
  end;
  Result:= CheckRetorno(retorno_imp_fiscal);
end;

function TImpFiscalUniversalDriver.horarioVerao: Boolean;
var
  retorno_imp_fiscal: Integer;
begin
  case FTipoImpressora of
    tiDaruma:
    begin
       retorno_imp_fiscal:= Daruma_FI_ProgramaHorarioVerao;
    end;
    tiBematech:
    begin
       retorno_imp_fiscal:= Bematech_FI_ProgramaHorarioVerao;
    end;
    tiElgin:
    begin
       retorno_imp_fiscal:= Elgin_ProgramaHorarioVerao;
    end;
  end;
  Result:= CheckRetorno(retorno_imp_fiscal);
end;

function TImpFiscalUniversalDriver.getCidade: string;
begin
  Result:= FCidade;
end;

function TImpFiscalUniversalDriver.getCpfCnpjCliente: string;
begin
  Result:= FCpfCnpj;
end;

function TImpFiscalUniversalDriver.getDataSaida: string;
begin
  Result:= FDataSaida;
end;

function TImpFiscalUniversalDriver.getEndereco: string;
begin
  Result:= FEndereco;
end;

function TImpFiscalUniversalDriver.getHoraSaida: string;
begin
  Result:= FHoraSaida;
end;

function TImpFiscalUniversalDriver.getIECliente: string;
begin
  Result:= FIECliente;
end;

function TImpFiscalUniversalDriver.getNomeCliente: string;
begin
  Result:= FNomeCliente;
end;

function TImpFiscalUniversalDriver.getOperador: string;
begin
  Result:= FOperador;
end;

function TImpFiscalUniversalDriver.getPlaca: string;
begin
  Result:= FPlaca;
end;

function TImpFiscalUniversalDriver.getVendedor: string;
begin
  Result:= FVendedor;
end;

procedure TImpFiscalUniversalDriver.IdentificaPlaca(const APlaca: string);
begin
  FPlaca:= APlaca;
end;

function TImpFiscalUniversalDriver.getStatus: ifStatus;
var
  i, ack, st1, st2, retflags, val : integer;
  _ack, _st1, _st2: Integer;
  modoOp: string;
  DataMovimento: string;
begin
  FillChar(Result, SizeOf(Result), ifsInicia);
  ack := 0; st1 := 0; st2 := 0;

  case FTipoImpressora of
    tiDaruma:
    begin
       i:= Daruma_FI_VerificaEstadoImpressora(ack, st1, st2);
    end;
    tiBematech:
    begin
       i:= Bematech_FI_VerificaEstadoImpressora(ack, st1, st2);
    end;
    tiElgin:
    begin
       i:= Elgin_VerificaEstadoImpressora(ack, st1, st2);
    end;
  end;

   if (i <> 1) and (i <> -27) then
   begin
     result[0] := ifsErro;
     exit;
   end;

   _ack := ack;
   _st1 := st1;
   _st2 := st2;

   // Fim de papel
   If st1 >= 128 Then
       begin
           result[13] := ifsFimPapel;
           st1 := st1 - 128;
       end;
   // Pouco papel
   If st1 >= 64 Then
       begin
           result[14] := ifsPoucoPapel;
           st1 := st1 - 64;
       end;
   // Erro no rel�gio
   If st1 >= 32 Then
       begin
           result[0] := ifsErro;
           st1 := st1 - 32;
       end;
   // Impressora em Erro
   If st1 >= 16 Then
       begin
           result[0] := ifsErro;
           st1 := st1 - 16;
       end;
   // Primeiro comando n�o foi ESC
   If st1 >= 8 Then
       begin
           result[0] := ifsErro;
           st1 := st1 - 8;
       end;
   // Comando Inexistente
   If st1 >= 4 Then
       begin
           result[0] := ifsErro;
           st1 := st1 - 4;
       end;
   // Cupom Aberto
   If st1 >= 2 Then
       begin
           result[11] := ifsCupomAberto;
           st1 := st1 - 2;
       end;
   // N�mero de par�metros inv�lido
   If st1 >= 1 Then
       begin
           result[0] := ifsErro;
           st1 := st1 - 1;
       end;
   // Tipo de par�metro inv�lido
   If st2 >= 128 Then
       begin
           result[0] := ifsErro;
           st2 := st2 - 128;
       end;
   // Fim de papel
   If st2 >= 64 Then
       begin
           result[0] := ifsErro;
           st2 := st2 - 64;
       end;
   // Erro na mem�ria RAM CMOS
   If st2 >= 32 Then
       begin
           result[0] := ifsErro;
           st2 := st2 - 32;
       end;
   // Al�quota n�o programada
   If st2 >= 16 Then
       begin
           result[15] := ifsAliqNaoProg;
           st2 := st2 - 16;
       end;
   // Capacidade de Al�quotas Lotadas
   If st2 >= 8 Then
       begin
           result[0] := ifsErro;
           st2 := st2 - 8;
       end;
   // Cancelamento n�o permitido
   If st2 >= 4 Then
       begin
           result[16] := ifsCancNaoPerm;
           st2 := st2 - 4;
       end;
   // CGC/IE n�o programados
   If st2 >= 2 Then
       begin
           result[0] := ifsErro;
           st2 := st2 - 2;
       end;
   // Comando n�o executado
   If st2 >= 1 Then
       begin
         if result[15] <> ifsAliqNaoProg Then
           result[0] := ifsErro;
         st2 := st2 - 1;
       end;

  // Se a impressora ja estiver em erro sai
  if Result[0] = ifsErro then Exit;


  // Se a impressora ja estiver em erro sai
  if Result[0] = ifsErro then Exit;

   // ******** Dados dos Flags Fiscais *************
     retflags := 0;

    case FTipoImpressora of
      tiDaruma:
      begin
         i:= Daruma_FI_FlagsFiscais(retflags);
      end;
      tiBematech:
      begin
         i:= Bematech_FI_FlagsFiscais(retflags);
      end;
      tiElgin:
      begin
         i:= Elgin_FlagsFiscais(retflags);
      end;
    end;

     If (i <> 1) And (i <> -27) Then
         begin
             result[0] := ifsErro;
             exit;
         end;
     val := 128;
     While retFlags >= 32 Do
         begin
             If retFlags >= val Then
                 retFlags := retFlags - val;
             val := val div 2;
         end;
     // J� houve redu��o Z no dia
     If retflags >= 8 Then
         begin
             result[9] := ifsJaHouveZ;
             retflags := retflags - 8;
         end;
     // Hor�rio de ver�o
     If retFlags >= 4 Then
         retFlags := retFlags - 4;
     // Fechamento de formas de pagamento iniciado
     If retflags >= 2 Then
         begin
             result[5] := ifsPgto;
             retflags := retflags - 2;
         end;
     // Cupom Aberto
     If retflags >= 1 Then
         begin
             result[4] := ifsItem;
             retflags := retflags - 1;
         end;

  // Verifica se aguarda Redu��o Z
  DataMovimento:= '000000';
  SetLength(DataMovimento, 6);

  case FTipoImpressora of
    tiDaruma:
    begin
       i:= Daruma_FI_DataMovimento(PAnsiChar(DataMovimento));
    end;
    tiBematech:
    begin
       i:= Bematech_FI_DataMovimento(PAnsiChar(DataMovimento));
    end;
    tiElgin:
    begin
       i:= Elgin_DataMovimento(PAnsiChar(DataMovimento));
    end;
  end;

   if (i <> 1) and (i <> -27) then
   begin
     result[0] := ifsErro;
     exit;
   end;
   if (DataMovimento <> '000000') and (DataMovimento <> FormatDateTime('ddmmyy', Date)) then
     Result[1] := ifsAguardaZ;
end;

function TImpFiscalUniversalDriver.getUltErro: string;
begin
  Result:= FUltErro;
end;

function TImpFiscalUniversalDriver.CheckRetorno(ret: Integer): Boolean;
begin
  FUltErro:= '';
  case FTipoImpressora of
    tiDaruma: Result:= TrataErroDaruma(ret);
    tiBematech: Result:= TrataErroBematech(ret);
    tiElgin: Result:= TrataErroElgin(ret);
  end;              
end;

function TImpFiscalUniversalDriver.TrataErroBematech(ret: Integer): Boolean;
var
  st1, st2: byte;
  _ack, _st1, _st2: Integer;
begin
  st1:= 0; st2:= 0;
  _ack:= 0; _st1:= 0; _st2:= 0;
  Result := True;
  if ret = -27 then
  begin
    // Se houve erro na execu��o do comando
    if ret <> 1 Then
    begin
      // Se houve erro na impressora
      if ret = -27 Then
      begin
        Bematech_FI_RetornoImpressora(_ack, _st1, _st2);
        // Trata retornos da fun��o
        if _ack = 21 Then
        begin
          Erro('A impressora retornou NAK (21)');
          Result := False;
        end
        Else
        begin
          st1 := _st1;
          st2 := _st2;
          if st1 >= 128 Then st1 := st1 - 128; // Fim de papel
          if st1 >= 64 Then st1 := st1 - 64;   // Pouco papel
          if st1 >= 32 Then
          begin
            Erro('Erro no Rel�gio');
            st1 := st1 - 32;
            Result := False;
          end;
          if st1 >= 16 Then
          begin
            Erro('Impressora em Erro');
            st1 := st1 - 16;
            Result := False;
          end;
          if st1 >= 8 Then
          begin
            Erro('Primeiro dado do comando diferente de ESC');
            st1 := st1 - 8;
            Result := False;
          end;
          if st1 >= 4 Then
          begin
            Erro('Comando inexistente');
            st1 := st1 - 4;
            Result := False;
          end;
          if st1 >= 2 Then st1 := st1 - 2; // Cupom Aberto
          if st1 >= 1 Then
          begin
            Erro('N�mero inv�lido de par�metros no comando');
            Result := False;
          end;
          if st2 >= 128 Then
          begin
            Erro('Tipo de par�metro inv�lido no comando');
            st2 := st2 - 128;
            Result := False;
          end;
          if st2 >= 64 Then
          begin
            Erro('Mem�ria Fiscal lotada');
            st2 := st2 - 64;
            Result := False;
          end;
          if st2 >= 32 Then
          begin
            Erro('Erro na mem�ria RAM');
            st2 := st2 - 32;
            Result := False;
          end;
          // Al�quota n�o programada
          if st2 >= 16 Then
          begin
            Erro('Al�quota n�o programada');
            st2 := st2 - 16;
            Result := False;
          end;
          // Capacidade de Al�quotas Lotadas
          if st2 >= 8 Then
          begin
            Erro('Capacidade de al�quota esgotada ao');
            st2 := st2 - 8;
            Result := False;
          end;
          // Cancelamento n�o permitido
          if st2 >= 4 Then st2 := st2 - 4;
          // CNPJ/IE n�o programados
          if st2 >= 2 then
          begin
            Erro('CPNJ/IE n�o programados');
            st2 := st2 - 2;
            Result := False;
          end;
          // Comando n�o executado
          if st2 >= 1 then Result := False;
        end;
      end
      // Outros erros
      else
        Result := False;
    end;
  end;
end;

function TImpFiscalUniversalDriver.TrataErroDaruma(ret: Integer): Boolean;
begin
  Result:= True;
end;

procedure TImpFiscalUniversalDriver.Erro(const S: string);
begin
  FUltErro:= S;
end;

function TImpFiscalUniversalDriver.getValorTotal: Currency;
var
  retorno_imp_fiscal: Integer;
  bResult: Boolean;
  aux : string;
begin
  aux := StringOfChar(' ', 14);
  case FTipoImpressora of
    tiDaruma:
    begin
       retorno_imp_fiscal:= Daruma_FI_SubTotal(PAnsiChar(aux));
    end;
    tiBematech:
    begin
       retorno_imp_fiscal:= Bematech_FI_SubTotal(PAnsiChar(aux));
    end;
    tiElgin:
    begin
       retorno_imp_fiscal:= Elgin_SubTotal(PAnsiChar(aux));
    end;
  end;
  bResult:= CheckRetorno(retorno_imp_fiscal);
  if not bResult then
    Result:= 0.00
  else
    Result := StrToCurrDef(aux, 0.00)/100;
end;

function TImpFiscalUniversalDriver.getModelo: string;
begin
  case FTipoImpressora of
    tiDaruma: Result:= 'Daruma';      // 0
    tiBematech: Result:= 'Bematech';  // 1
    tiElgin: Result:= 'Elgin';        // 2
  end;
end;

function TImpFiscalUniversalDriver.isEmulador: Boolean;
begin
  Result:= FIsEmulador;
end;

function TImpFiscalUniversalDriver.FaltaRealizarReducaoZ: Boolean;
var
  status: ifStatus;
begin
  status:= getStatus;
  Result:= status[Integer(ifsAguardaZ)] = ifsAguardaZ;
end;

function TImpFiscalUniversalDriver.ReducaoZJaFoiRealizada: Boolean;
var
  status: ifStatus;
begin
  status:= getStatus;
  Result:= status[Integer(ifsJaHouveZ)] = ifsJaHouveZ;
end;

function TImpFiscalUniversalDriver.getProximoNumeroCupom: Integer;
begin
  Result:= getNumeroCupom+1;
end;

function TImpFiscalUniversalDriver.IniciaFechamentoCupom(
  const ADescAcrescimo, ATipoDescAcrescimo: Char;
  AValorDescAcrescimo: Currency): Boolean;
var
  S_Acrescimo_ou_Desconto: String;
  S_Tipo_Acrescimo_ou_Desconto: String;
  S_Valor_Acrescimo_ou_Desconto: String;
  iRetorno: Integer;
begin
   S_Acrescimo_ou_Desconto:= ADescAcrescimo;
   S_Tipo_Acrescimo_ou_Desconto:= '$';
   s_Valor_Acrescimo_ou_Desconto:=formatfloat('###,###,##0.00', AValorDescAcrescimo);

   case FTipoImpressora of
     tiDaruma:
     begin
       iRetorno:= Daruma_FI_IniciaFechamentoCupom( PAnsiChar(s_Acrescimo_ou_Desconto), PAnsiChar(s_Tipo_Acrescimo_ou_Desconto), PAnsiChar(s_Valor_Acrescimo_ou_Desconto));
     end;
     tiBematech:
     begin
       iRetorno:= Bematech_FI_IniciaFechamentoCupom( PAnsiChar(s_Acrescimo_ou_Desconto), PAnsiChar(s_Tipo_Acrescimo_ou_Desconto), PAnsiChar(s_Valor_Acrescimo_ou_Desconto));
     end;
     tiElgin:
     begin
       iRetorno:= Elgin_IniciaFechamentoCupom( PAnsiChar(s_Acrescimo_ou_Desconto), PAnsiChar(s_Tipo_Acrescimo_ou_Desconto), PAnsiChar(s_Valor_Acrescimo_ou_Desconto));
       TrataErroElgin(iRetorno);
     end;
   end;
  Result:= True;
end;

function TImpFiscalUniversalDriver.EfetuaFormaPagamentoCupom(
  const AFormaPgto: string; AValor: Currency): Boolean;
var
  S_Forma_de_Pagamento: String;
  sValor: string;
  iRetorno: Integer;
  Retorno_imp_Fiscal: Integer;
begin
   // Executa a rotina EFETUAFORMAPAGAMENTO
   if (AValor > 0) then
   begin
      S_Forma_de_Pagamento:='DINHEIRO';
      sValor:=formatfloat('###,###,##0.00', AValor);
      case FTipoImpressora of
        tiDaruma:
        begin
           Retorno_imp_Fiscal:=Daruma_FI_EfetuaFormaPagamento( PAnsiChar( S_Forma_de_Pagamento), PAnsiChar(sValor));
        end;
        tiBematech:
        begin
           Retorno_imp_Fiscal:=Bematech_FI_EfetuaFormaPagamento( PAnsiChar( S_Forma_de_Pagamento), PAnsiChar(sValor));
        end;
        tiElgin:
        begin
           Retorno_imp_Fiscal:=Elgin_EfetuaFormaPagamento( PAnsiChar( S_Forma_de_Pagamento), PAnsiChar(sValor));
           TrataErroElgin(retorno_imp_fiscal);
        end;
      end;
   end;
   Result:= True;
end;

function TImpFiscalUniversalDriver.FechaCupom: Boolean;
var
  Retorno_imp_Fiscal: Integer;
begin
  // Executa a rotina TERMINAFECHAMENTOCUPOM
  case FTipoImpressora of
    tiDaruma:
    begin
       Retorno_imp_Fiscal:=Daruma_FI_TerminaFechamentoCupom( PAnsiChar(FIdentificacao));
    end;
    tiBematech:
    begin
      Retorno_imp_Fiscal:=Bematech_FI_TerminaFechamentoCupom( PAnsiChar(FIdentificacao));
    end;
    tiElgin:
    begin
       Retorno_imp_Fiscal:=Elgin_TerminaFechamentoCupom( PAnsiChar(FIdentificacao));
    end;
  end;

  LimpaIdentificacao;
  Result:= True;

end;

function TImpFiscalUniversalDriver.ImprimeComprovanteVinculado(
  const ATexto: string; const AFormaPgto: string): Boolean;
const
  SEspacamento = #13#10#13#10#13#10#13#10#13#10#13#10#13#10#13#10;
  LarguraTextoImpressao = 600;
var
  vValor, vNumeroCupom: string;
  Retorno_imp_Fiscal: Integer;
  Linha: string;
  pBBB: Integer;
  Comp: string;
  formaPgto: string;

   { Verifica o espacamento de cupom para Banrisul.
     Retorna True se existe o espacamento }
   function CheckEspacamentoCupomBanrisul: Boolean;
   begin
     pBBB:= Pos('BBB', Comp);
     if pBBB > 0 then
     begin
       Insert(SEspacamento, Comp, pBBB);
       Result:= True;
       Inc(pBBB, Length(SEspacamento));
     end
     else
       Result:= False;
   end;

  { Imprime o comprovante }
  procedure DoImprimeComprovante(ALinha: string);
  var
    //ret, i: integer;
    Texto: string;
    Result: Boolean;

    { Faz o ajustamento do texto para que o final do texto sempre
      contenha os car�cters CRLF }
    procedure RealizaAjustamentoTexto;
    var
      i: Integer;
    begin
      for i:= Length(Texto) downto 1 do
      begin
        if Texto[i] = #10 then
        begin
          Texto[i+1]:= #0;
          SetLength(Texto, i);
          Break;
        end;
      end;
    end;

    function ImprimeLinha(var S: string): Boolean;
    var
      i: Integer;
    begin
      case FTipoImpressora of
        tiDaruma:
        begin
          i:= Daruma_FI_UsaComprovanteNaoFiscalVinculado(PAnsiChar(S));
        end;
        tiBematech:
        begin
          i:= Bematech_FI_UsaComprovanteNaoFiscalVinculado(PAnsiChar(S));
        end;
        tiElgin:
        begin
          i:= Elgin_UsaComprovanteNaoFiscalVinculado(PAnsiChar(S));
        end;
      end;
      Result:= i = 1;
    end;

  begin
    while ALinha <> '' do
    begin
      Texto:= Copy(ALinha, 1, LarguraTextoImpressao);
      RealizaAjustamentoTexto;
      Delete(ALinha, 1, Length(Texto));
      Result:= ImprimeLinha(Texto);
    end;
  end;

begin
  vValor:= '';
  vNumeroCupom:= '';
  Comp:= ATexto;
  formaPgto:= AFormaPgto;

  case FTipoImpressora of
    tiDaruma:
    begin
      Retorno_imp_Fiscal:= Daruma_FI_AbreComprovanteNaoFiscalVinculado(
        PAnsiChar(formaPgto), PAnsiChar(vValor), PAnsiChar(vNumeroCupom));
    end;
    tiBematech:
    begin
      Retorno_imp_Fiscal:= Bematech_FI_AbreComprovanteNaoFiscalVinculado(
        PAnsiChar(formaPgto), PAnsiChar(vValor), PAnsiChar(vNumeroCupom));
    end;
    tiElgin:
    begin
      Retorno_imp_Fiscal:= Elgin_AbreComprovanteNaoFiscalVinculado(
        PAnsiChar(formaPgto), PAnsiChar(vValor), PAnsiChar(vNumeroCupom));
    end;
  end;

  try
    { Verifica o espa�amento entre cupons para Banrisul }
    if CheckEspacamentoCupomBanrisul then
    begin
      { Obt�m a mensagem at� BBB }
      Linha:= Copy(Comp, 1, pBBB-1);
      comp:= Copy(comp, pBBB+3, Length(Linha));

      { Imprime o cupom e pede para destacar o cupom }
      DoImprimeComprovante(Linha);
      Sleep(2000);
      MsgInformation('Por favor, destaque o cupom')
    end;
    DoImprimeComprovante(comp);

    case FTipoImpressora of
      tiDaruma:
      begin
        Retorno_imp_Fiscal:= Daruma_FI_FechaComprovanteNaoFiscalVinculado;
      end;
      tiBematech:
      begin
        Retorno_imp_Fiscal:= Bematech_FI_FechaComprovanteNaoFiscalVinculado;
      end;
      tiElgin:
      begin
        Retorno_imp_Fiscal:= Elgin_FechaComprovanteNaoFiscalVinculado;
      end;
    end;

    Result:= True;
  except
    Result:= False;
  end;
end;

end.
