library libxnet;

//*************************************************************************
// libxnet - Library for network utilities
//
// Finalidade: Oferecer funções para internet, como ping, enviar email,
//             testar portas, etc
//
// Autor: Everton de Vargas Agilar
// Data: 2010
//*************************************************************************

uses
  SysUtils,
  Classes,
  Sockets,
  IdIcmpClient,
  IdSMTP,
  IdMessage,
  IdSSLOpenSSL,
  IdHTTP,
  Registry,
  Windows;

{$R *.res}

function Zeos_Ping(const AIP: PAnsiChar; ATimeout: Integer = 10000): Boolean;
var
  Pingador: TIdIcmpClient;
begin
  try
    Pingador:= TIdIcmpClient.Create(nil);
    try
      with Pingador do
      begin
        Host := AIP;
        ReceiveTimeout := ATimeout;
        Ping;
        if ReplyStatus.BytesReceived > 0 then
          Result := true
        else
          Result := false;
      end;
    finally
      Pingador.Free;
    end;
  except
    Result:= False;
  end;
end;

function Zeos_PingPort(const AIP: PAnsiChar; APort: Integer): Boolean;
var
  Pingador: TTcpClient;
begin
  try
    Pingador:= TTcpClient.Create(nil);
    try
      with Pingador do
      begin
        RemoteHost := AIP;
        RemotePort := IntToStr(APort);
        if Pingador.Connect then
        begin
          Result := true;
          Pingador.Disconnect;
        end
        else
          Result := false;
      end;
    finally
      Pingador.Free;
    end;
  except
    Result:= False;
  end;
end;

function Zeos_EnviaEMail(
  const AHost, AUserName, APassword, De, Para, Assunto, Texto: PAnsiChar;
  const AFileName1: PAnsiChar;
  const AFileName2: PAnsiChar;
  AFileName1IsHtml: Boolean;
  const AFileName3: PAnsiChar;
  const AFileName4: PAnsiChar;
  const AFileName5: PAnsiChar): Boolean;
var
  IDSmtp1: TIDSmtp;
  IDMessage1: TIDMessage;
  IdAttach: TIdAttachment;
begin
 Result:= True;
 try
   IDSmtp1:= TIDSmtp.Create(nil);
   IdMessage1:= TIdMessage.Create(nil);
   try
     IDSmtp1.Host:= AHost;
     IDSmtp1.Username:= AUserName;
     IDSmtp1.Password:= APassword;
     IDSmtp1.Connect;
     IdMessage1.From.Address := De;
     IdMessage1.Recipients.EMailAddresses := Para;
     IdMessage1.Subject := Assunto;

     if (AFileName1 <> '') and AFileName1IsHtml then
     begin
       IdMessage1.Body.LoadFromFile(AFileName1);
       IdMessage1.ContentType:= 'text/html';
       IdMessage1.ContentDisposition:= 'inline';
     end
     else
       IdMessage1.Body.Text:= Texto;

       if AFileName1 <> '' then
       begin
         IdAttach:= TIdAttachment.Create(IDMessage1.MessageParts, AFileName1);
         IdAttach.ContentDisposition:= 'attachment';
       end;

     if AFileName2 <> '' then
     begin
       IdAttach:= TIdAttachment.Create(IDMessage1.MessageParts, AFileName2);
       IdAttach.ContentDisposition:= 'attachment';
     end;

     if AFileName3 <> '' then
     begin
       IdAttach:= TIdAttachment.Create(IDMessage1.MessageParts, AFileName3);
       IdAttach.ContentDisposition:= 'attachment';
     end;

     if AFileName4 <> '' then
     begin
       IdAttach:= TIdAttachment.Create(IDMessage1.MessageParts, AFileName4);
       IdAttach.ContentDisposition:= 'attachment';
     end;

     if AFileName5 <> '' then
     begin
       IdAttach:= TIdAttachment.Create(IDMessage1.MessageParts, AFileName5);
       IdAttach.ContentDisposition:= 'attachment';
     end;

     IdSMTP1.Send(IdMessage1);
     IdSMTP1.Disconnect;
   finally
     IdSMTP1.Free;
   end;
  except
    on E: Exception do
    begin
//      Zeos_WriteAlert('Erro ao enviar email: '+ E.Message);
      Result:= False;
    end;
  end;
end;

function Zeos_EnviaEMailComAnexo(
  const Host, UserName, Password: PAnsiChar;
  Port: Integer;
  const De, Para, Assunto, Texto: PAnsiChar;
  const AFileName1: PAnsiChar;
  const AFileName2: PAnsiChar;
  ASSL: Boolean): Boolean;
//********************************************************************
//  Envia email com anexo utilizando SSL.
//  Autor: Everton Agilar
//  Data: 2007
//  Alterado: 15/03/2010 por Everton Agilar
//     - Passou a utilizar SSL3 (sslvSSLv3) em vez de SSl2 (sslvSSLv3). Alteração
//       necessária pois parou de funcionar em alguns clientes.
//     - ASSL ignorado
//     - Não retorna false se não conseguir desconectar
//********************************************************************
var
  IDSmtp1: TIDSmtp;
  IDMessage1: TIDMessage;
  IdAttach: TIdAttachment;
  IdText: TIdText;
  ssl: TIdSSLIOHandlerSocket;
begin
 Result:= False;
 try
   IDSmtp1:= TIDSmtp.Create(nil);
   IdMessage1:= TIdMessage.Create(nil);
   try
     IDSmtp1.AuthenticationType:= atLogin;
     IDSmtp1.Host:= Host;
     IDSmtp1.Username:= UserName;
     IDSmtp1.Password:= Password;
     IDSmtp1.Port:= Port;

     ssl:= TIdSSLIOHandlerSocket.Create(nil);
     ssl.SSLOptions.Method:= sslvSSLv3;
     ssl.SSLOptions.Mode := sslmClient; //sslmUnassigned;
     IDSmtp1.IOHandler:= ssl;

     IDSmtp1.ReadTimeout:= 63500;

     IdMessage1.From.Address := UserName;
     IdMessage1.Recipients.EMailAddresses := Para;
     IdMessage1.Subject := Assunto;
     IDMessage1.Priority:= mpHigh;
     IdMessage1.Headers. Values['X- Library'] := '';
     IdMessage1.ContentType := 'Multipart/Alternative';

     IdText:= TIdText.Create(IDMessage1.MessageParts, nil);
     IdText.ContentType:= 'text/plain';
     IdText.Body.Text:= Assunto;

     IdText:= TIdText.Create(IDMessage1.MessageParts, nil);
     IdText.ContentType:= 'text/html';
     IdText.Body.Text:= Texto;

     if (AFileName1 <> '') and FileExists(AFileName1) then
     begin
       IdAttach:= TIdAttachment.Create(IDMessage1.MessageParts, AFileName1);
       IdAttach.ContentDisposition:= 'attachment';
     end;

     if (AFileName2 <> '') and FileExists(AFileName2) then
     begin
       IdAttach:= TIdAttachment.Create(IDMessage1.MessageParts, AFileName2);
       IdAttach.ContentDisposition:= 'attachment';
     end;

     try
       IDSmtp1.Connect(60000);
     except
       on E: Exception do
       begin
         try
          //Zeos_WriteAlert('Erro ao enviar email: '+ E.Message);
           IDSmtp1.Connect(60000);
         except
           on E: Exception do
           begin
             //Zeos_WriteAlert('Erro ao enviar email 2° tentativa: '+ E.Message);
             Result:= False;
             Exit;
           end;
         end;
       end;
     end;
     if IDSmtp1.Connected then
     begin
       IdSMTP1.Send(IdMessage1);
       try
         IdSMTP1.Disconnect;
       except
         on E: Exception do
           //Zeos_WriteAlert('Erro ao enviar email: '+ E.Message);
       end;
       Result:= True;
     end
   finally
     IdSMTP1.Free;
   end;
  except
    on E: Exception do
    begin
      //Zeos_WriteAlert('Erro ao enviar email: '+ E.Message);
      Result:= False;
    end;
  end;
end;

function Zeos_GetIPMaquina(const ANomeMaquina: PAnsiChar; out AIP: PAnsiChar): Boolean;
//********************************************************************
// Obtém o ip de uma máquina. Se ocorrer erro retorna vazio.
// Ex.: 'desenv04' -> 192.168.0.253
// Autor: Everton de Vargas Agilar
//********************************************************************
var
  ICMP: TIdIcmpClient;
begin
  try
    ICMP:= TIdIcmpClient.Create(nil);
    try
      ICMP.Host:= StrPas(ANomeMaquina);
      ICMP.Ping;
      StrPCopy(AIP, ICMP.ReplyStatus.FromIpAddress);
      Result:= True;
    finally
      ICMP.Free;
    end;
  except
    Result:= False;
  end;
end;

procedure Zeos_GetNomeMaquina(out ANomeMaquina: PAnsiChar);
//********************************************************************
// Obtém o nome da máquina
// Autor: Everton de Vargas Agilar
//********************************************************************
var
  Reg: TRegistry;
begin
  Reg:= TRegistry.Create;
  try
    Reg.RootKey:= HKEY_LOCAL_MACHINE;
    if Reg.OpenKeyReadOnly('\System\CurrentControlSet\Control\ComputerName\ComputerName') then
      StrPCopy(ANomeMaquina, Reg.ReadString('ComputerName'))
    else
      StrPCopy(ANomeMaquina, '');
  finally
    Reg.Free;
  end;
end;

procedure Zeos_GetIPForThisComputer(out AIP: PAnsiChar);
var
  NomeMaquina: PAnsiChar;
begin
  GetMem(NomeMaquina, 100);
  Zeos_GetNomeMaquina(NomeMaquina);
  Zeos_GetIPMaquina(NomeMaquina, AIP);
  FreeMem(NomeMaquina);
end;

function Zeos_GetIpFromCaminho(const ACaminho: PAnsiChar; out AIP: PAnsiChar): Boolean;
var
  p: Integer;
  path: string;
begin
  path:= StrPas(ACaminho);
  p:= Pos(':', path);
  if (p > 0) and (Length(path) >= p+1) and (path[p+1] <> '\') then
  begin
    path:= Copy(path, 1, p-1);
    if (Pos('/', path) > 0) then
      path:= Copy(path, 1, Pos('/', path)-1);
    StrPCopy(AIP, path);
    Result:= True;
  end
  else
    Result:= False;
end;

procedure Zeos_WinSocketNameToNetBeuiName(const AWinSocketName: PAnsiChar; out ANetBeuiName: PAnsiChar);
//********************************************************************
// Converte um nome do computador do formato Winsock para o
// formata NetBeui.
// Ex.: desenv04.Polidados.com.br  -> desenv04
// Data: 02/03/04
// Autor: Everton de Vargas Agilar
//********************************************************************
var
  p: Integer;
begin
  p:= Pos('.', AWinSocketName);
  if p > 0 then
    StrPCopy(ANetBeuiName, Copy(AWinSocketName, 1, p-1))
  else
    StrPCopy(ANetBeuiName, AWinSocketName);
end;

function Zeos_ConsultaCEP(const ACEP: PAnsiChar; out ALogradouro, ABairro, ACidade, AUF: PAnsiChar): Boolean;
var
  consulta: TStringList;
  http: TIdHTTP;
begin
  try
    //Cria-se uma string List
    consulta:=TStringList.Create;
    http:= TIdHTTP.Create(nil);
    try
      //Nesta linha busca-se a informação através da url indicada
      //StrinReplace eh utilizada para substituir os caracteres & por CR
      //UrlDecode eh para eliminar caracteres de código html para acentos
      //&formato=query_string ou xml javascript
      //ele retorna para o componente em qualquer um dos formatos acima
      //Mais detalhes entre na pagina http://republicavirtual.com.br

      consulta.text:=stringreplace(http.URL.URLDecode(http.Get('http://republicavirtual.com.br/web_cep.php?cep='+ACEP+'&formato=query_string')),'&',#13#10,[rfreplaceAll]);
      //consulta vira uma matriz e fazemos o acesso aos dados...
      ALogradouro:= PAnsiChar(Trim(consulta.Values['TIPO_LOGRADOURO']+' '+consulta.Values['LOGRADOURO']));
      ABairro:= PAnsiChar(Trim(consulta.Values['BAIRRO']));
      ACidade:= PAnsiChar(Trim(consulta.Values['CIDADE']));
      AUF:= PAnsiChar(Trim(consulta.Values['UF']));
      Result:= (ALogradouro <> '') or (ABairro <> '') or (ACidade <> '') or (AUF <> '');
    finally
      http.Free;
      consulta.Free;
    end;
  except
    Result:= False;
  end;
end;

exports
  Zeos_PingPort,
  Zeos_Ping,
  Zeos_EnviaEMail,
  Zeos_EnviaEMailComAnexo,
  Zeos_GetIPMaquina,
  Zeos_GetNomeMaquina,
  Zeos_GetIPForThisComputer,
  Zeos_GetIpFromCaminho,
  Zeos_WinSocketNameToNetBeuiName,
  Zeos_ConsultaCEP;

begin
   ShortDateFormat:= 'dd/mm/yyyy';
   ShortTimeFormat:= 'hh:mm:ss';
end.
