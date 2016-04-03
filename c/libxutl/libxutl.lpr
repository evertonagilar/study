library libxutl;

{$MODE Delphi}

uses
  {ShareMem,
//  FastMM4,
  VCLFixPack,
//  MidasSpeedFix,
  Windows,}
  Messages,
  Forms,
  {Classes,
  SysUtils,}
  Controls,
  Graphics,
  {StrUtils,
  ZConnection,
  ZDataset,
  ZAbstractRODataset,
  ZAbstractDataset,
  DB,
  Registry,}
  Dialogs,
  {DateUtils,
  ActiveX,
  ShlObj,
  ShellApi,}
  {$ifdef VER150} // Is Delphi 7
  ZipMstr,
  {{$else}
  ZipMstr19,}
  {$endif}
  {jpeg,}
  ComCtrls{,
  ComObj,
  VersionInfo};

{$R *.res}

type
  TCharSet = set of Char;

const
  // Conjunto de caracteres
  CharsNomeValido: TCharSet =
    ['A'..'Z', 'Á'..'Ú', 'a'..'z', 'á'..'ú', 'â'..'û', '0'..'9', ' ', '_'];
  CharsIdentificadorValido: TCharSet = ['A'..'Z', 'a'..'z', '0'..'9', '_'];
  CharsNumeroValido: TCharSet = ['0'..'9'];

  // Libs
  libxnet = 'libxnet.dll';

var
  ArqAlert: string = '';
  LastError: string = '';

{$ifdef VER150} // Is Delphi 7
  // Nada a fazer
{$else}
type TZipMaster = TZipMaster19;
{$endif}

// Network utilities
// Lib: libxnet
function Zeos_Ping(const AIP: PAnsiChar; ATimeout: Integer = 10000): Boolean; external libxnet;
function Zeos_PingPort(const AIP: PAnsiChar; APort: Integer): Boolean; external libxnet;
function Zeos_EnviaEMail(
  const AHost, AUserName, APassword, De, Para, Assunto, Texto: PAnsiChar;
  const AFileName1: PAnsiChar;
  const AFileName2: PAnsiChar;
  AFileName1IsHtml: Boolean;
  const AFileName3: PAnsiChar;
  const AFileName4: PAnsiChar;
  const AFileName5: PAnsiChar): Boolean; external libxnet;
function Zeos_EnviaEMailComAnexo(
  const Host, UserName, Password: PAnsiChar;
  Port: Integer;
  const De, Para, Assunto, Texto: PAnsiChar;
  const AFileName1: PAnsiChar;
  const AFileName2: PAnsiChar;
  ASSL: Boolean): Boolean; external libxnet;
function Zeos_GetIPMaquina(const ANomeMaquina: PAnsiChar; out AIP: PAnsiChar): Boolean; external libxnet;
procedure Zeos_GetNomeMaquina(out ANomeMaquina: PAnsiChar); external libxnet;
procedure Zeos_GetIPForThisComputer(out AIP: PAnsiChar); external libxnet;
function Zeos_GetIpFromCaminho(const ACaminho: PAnsiChar; out AIP: PAnsiChar): Boolean; external libxnet;
procedure Zeos_WinSocketNameToNetBeuiName(const AWinSocketName: PAnsiChar; out ANetBeuiName: PAnsiChar); external libxnet;
function Zeos_ConsultaCEP(const ACEP: PAnsiChar; out ALogradouro, ABairro, ACidade, AUF: PAnsiChar): Boolean; external libxnet;

function GetNomeMaquina: string;
var
  NomeMaquina: PAnsiChar;
begin
  GetMem(NomeMaquina, 100);
  Zeos_GetNomeMaquina(NomeMaquina);
  Result:= StrPas(NomeMaquina);
//  FreeMem(NomeMaquina);
end;

procedure Zeos_WriteAlert(const S: string);
var
  Arq: TextFile;
begin
  // Existe também uma implementação na classe TFormPlus
  AssignFile(Arq, ArqAlert);
  if FileExists(ArqAlert) then
    Append(Arq)
  else Rewrite(Arq);
  try
    if S <> '' then
      Writeln(Arq, DateTimeToStr(Now) + ' ' + S)
    else
      WriteLn(Arq, ' ');
  finally
    CloseFile(Arq);
  end;
end;

function Zeos_LastError: string;
begin
  Result:= LastError;
end;

function PosStr(const ASubStr, S: string; APosIni: Integer = 1): Integer;
//********************************************************************
// Localiza uma string em outra iniciando a partir de APosIni
// Autor: Everton de Vargas Agilar
//********************************************************************
var
  tmp: string;
begin
  if S <> '' then
  begin
    tmp:= Copy(S, APosIni, MaxInt);
    Result:= Pos(ASubStr, tmp);
  end
  else
    Result:= 0;
end;


function Zeos_NextInt(const S: string; APosicaoInicial: Integer): Integer;
begin
  if (APosicaoInicial > 0) and (APosicaoInicial < Length(S)) then
  begin
    for Result:= APosicaoInicial to Length(S) do
    begin
      if S[Result] in ['0'..'9'] then
        Exit;
    end;
  end;
  Result:= 0;
end;

function Zeos_NextIntAteFimLinha(const S: string; APosicaoInicial: Integer): Integer;
begin
  if (APosicaoInicial > 0) and (APosicaoInicial < Length(S)) then
  begin
    for Result:= APosicaoInicial to Length(S) do
    begin
      if S[Result] = #13 then
        Break;
      if S[Result] in ['0'..'9'] then
        Exit;
    end;
  end;
  Result:= 0;
end;

function Zeos_NextLetra(const S: string; APosicaoInicial: Integer): Integer;
begin
  if (APosicaoInicial > 0) and (APosicaoInicial < Length(S)) then
  begin
    for Result:= APosicaoInicial to Length(S) do
    begin
      if S[Result] in ['A'..'Z'] then
        Exit;
    end;
  end;
  Result:= 0;
end;

function Zeos_NextLetraBreakEncontraIntOrFimLinha(const S: string; APosicaoInicial: Integer): Integer;
begin
  if (APosicaoInicial > 0) and (APosicaoInicial < Length(S)) then
  begin
    for Result:= APosicaoInicial to Length(S) do
    begin
      if S[Result] in ['0'..'9', #13] then
        Break;
      if S[Result] in ['A'..'Z'] then
        Exit;
    end;
  end;
  Result:= 0;
end;

function Zeos_CopyWord(const S: string; APosicaoInicial: Integer): string;
var
  i: Integer;
begin
  Result:= '';
  if (APosicaoInicial > 0) and (APosicaoInicial < Length(S)) then
  begin
    for i:= APosicaoInicial to Length(S) do
    begin
      if Ord(S[i]) <= 32 then // para quando acha um caracter de controle
        Break;
      Result:= Result + S[i];
    end;
  end;
end;

function Zeos_CopyWordComposta(const S: string; APosicaoInicial: Integer): string;
var
  i: Integer;
begin
  Result:= '';
  if (APosicaoInicial > 0) and (APosicaoInicial < Length(S)) then
  begin
    for i:= APosicaoInicial to Length(S) do
    begin
      if (Ord(S[i]) <= 32) and (Ord(S[i+1]) <= 32) and (Ord(S[i+2]) <= 32)  then // para quando dois caracteres de controle
        Break;
      Result:= Result + S[i];
    end;
  end;
end;

function Zeos_NextWord(const S: string; APosicaoInicial: Integer): Integer;
var
  i: Integer;
begin
  if (APosicaoInicial > 0) and (APosicaoInicial < Length(S)) then
  begin
    for i:= APosicaoInicial to Length(S) do
    begin
      if Ord(S[i]) <= 32 then // para quando acha um caracter de controle
        Break;
      Result:= i;
    end;
  end
  else
    Result:= -1;
end;

function Zeos_AvancaLinha(const S: string; out APonteiro: Integer): Integer;
var
  i: Integer;
begin
  Result:= APonteiro;
  if (APonteiro > 0) and (APonteiro < Length(S)) then
  begin
    for i:= APonteiro to Length(S) do
    begin
      if S[i] = #13 then
      begin
        if i < Length(S) then
          Result:= i+1
        else
          Result:= i;
        Break;
      end;
    end;
  end;
end;


function Zeos_PosStrings(
  const ASubStrings: array of string;
  const S: string;
  out ASubStringEncontrada: string;
  ACaseSensitive: Boolean = True): Integer;
var
  Tmp: string;
  i: Integer;
begin
  Result:= 0;
  Tmp:= S;
  if ACaseSensitive then
  begin
    for i:= Low(ASubStrings) to High(ASubStrings) do
    begin
      Result:= Pos(ASubStrings[i], tmp);
      if Result <> 0 then
      begin
        ASubStringEncontrada:= ASubStrings[i];
        Break;
      end;
    end;
  end
  else
  begin
    tmp:= UpperCase(tmp);
    for i:= Low(ASubStrings) to High(ASubStrings) do
    begin
      Result:= Pos(UpperCase(ASubStrings[i]), tmp);
      if Result <> 0 then
      begin
        ASubStringEncontrada:= ASubStrings[i];
        Break;
      end;
    end;
  end;
end;

// select iif(cancelado = 1, 'Cancelado', '') from orcamentos
// mantém os textos entre aspas intacto
function Zeos_LowerCase(S: string): string;
var
  i, j: Integer;
begin
  for i:= 1 to Length(S) do
  begin
    if i > Length(S) then Break;     // Ocorre erro de limite sem isso! Um dia vou ver
    if S[i] = #39 then
    begin
      for j:= i+1 to Length(S) do
      begin
        if S[j] = #39 then
        begin
          asm
            push eax
            mov eax, j
            inc eax
            mov i, eax
            pop eax
          end;
          Break;
        end;
      end;
    end
    else
       S[i]:= LowerCase(S[i])[1];
  end;
  Result:= S;
end;

function Zeos_TrocaString(const S: string;
                     AOldSubStr: string;
                     const ANovoSubStr: string;
                     ACaseSensitive: Boolean = True): string;
//********************************************************************
// Zeos_TrocaString
// Substitui uma string por outra.
// Retorna S como resultado.
// Ex.: Zeos_TrocaString('everton;de;vargas;agilar', ';', ',')
//      = 'everton,de,vargas,agilar'
// Autor: Everton de Vargas Agilar
//********************************************************************
var
  p, k: Integer;

  { Faz um UpperCase se não for case sensitive e retorna AText }
  function UpperCaseIfNotCaseSensitive(const AText: string): string;
  begin
    if not ACaseSensitive then
      Result:= UpperCase(AText)
    else
      Result:= AText;
  end;

begin
  { Ajusta as variaveis de acordo a propriedade ACaseSensitive }
  if not ACaseSensitive then
    AOldSubStr:= UpperCase(AOldSubStr);

  Result:= S;
  if AOldSubStr = ANovoSubStr then Exit;

  { Inicia a operação de permuta }
  k:= 1;
  while True do
  begin
    p:= PosStr(AOldSubStr, UpperCaseIfNotCaseSensitive(Result), k)+k-1;
    if p>=k then
    begin
      Insert(ANovoSubStr, Result, p);
      Delete(Result, p+Length(ANovoSubStr), Length(AOldSubStr));
      k:= p + Length(ANovoSubStr);
    end
    else
      Break;
  end;
end;

function Zeos_TrocaString1(const S: string;
                     AOldSubStr: string;
                     const ANovoSubStr: string;
                     ACaseSensitive: Boolean = True): string;
var
  p: Integer;

  { Faz um UpperCase se não for case sensitive e retorna AText }
  function UpperCaseIfNotCaseSensitive(const AText: string): string;
  begin
    if not ACaseSensitive then
      Result:= UpperCase(AText)
    else
      Result:= AText;
  end;

begin
  { Ajusta as variaveis de acordo a propriedade ACaseSensitive }
  if not ACaseSensitive then
    AOldSubStr:= UpperCase(AOldSubStr);

  Result:= S;
  if AOldSubStr = ANovoSubStr then Exit;

  p:= Pos(AOldSubStr, UpperCaseIfNotCaseSensitive(Result));
  if p > 0 then
  begin
    Insert(ANovoSubStr, Result, p);
    Delete(Result, p+Length(ANovoSubStr), Length(AOldSubStr));
  end;
end;

function Zeos_Condicao(AQuery: TDataSet; const APrefixo: string = ''): string;
var
  fldID: TField;
  IdAtual: Integer;
  sep: string;
  ListaIds: TList;
  ListaId_In: TList;
  i, j, k: Integer;
  IdAnt, Id, DifId: Integer;
  Smnt: string;
label ParseId, ParseId2;

  function SortCompare(Item1, Item2: Pointer): Integer;
  begin
    if Integer(Item1) = Integer(Item2) then
      Result:= 0
    else if Integer(Item1) > Integer(Item2) then
      Result:= 1
    else
      Result:= -1;
  end;

begin
  fldID:= AQuery.FindField('ID');
  if fldID = nil then
    raise Exception.Create('DataSet deve ter campo ID para obter condição!');

  if not AQuery.IsEmpty then
  begin
    IdAtual:= fldID.AsInteger; // guarda o Id atual para poder voltar
    if AQuery.RecordCount > 1 then
    begin
      if AQuery.RecordCount > 10 then
      begin
        ListaIds:= TList.Create;
        ListaId_In:= TList.Create;
        Result:= '';
        try
          AQuery.DisableControls;
          try
            // Insere os Ids na lista em ordem
            AQuery.First;
            while not AQuery.Eof do
            begin
              ListaIds.Add(Pointer(fldID.AsInteger));
              AQuery.Next;
            end;
            ListaIds.Sort(@SortCompare);

            // Gera o parser
            ParseId:
            IdAnt:= Integer(ListaIds[0]);
            for i:= 1 to ListaIds.Count-1 do
            begin
              Id:= Integer(ListaIds[i]);
              DifId:= Id - IdAnt;
              if (DifId > 1) or (i = ListaIds.Count-1) then
              begin
                if i <= 2 then
                begin
                  for j:= 0 to i-1 do
                    ListaId_In.Add(ListaIds[j]);
                end
                else
                begin
                  if DifId > 1 then
                    Smnt:= '(' + APrefixo + 'id between '+ IntToStr(Integer(ListaIds[0])) + ' and ' + IntToStr(Integer(ListaIds[i-1])) + ')'
                  else
                    Smnt:= '(' + APrefixo + 'id between '+ IntToStr(Integer(ListaIds[0])) + ' and ' + IntToStr(Integer(ListaIds[i])) + ')';

                  if Result = '' then
                    Result:= Smnt
                  else
                    Result:= Result + ' or ' + Smnt;
                end;
                for j:= 0 to i-1 do
                  ListaIds.Delete(0);  // sempre o primeiro por causa do deslocamento da exclusão

                goto ParseId;
              end;
              IdAnt:= Id;
            end;

            ListaId_In.Add(Pointer(IdAnt));

            if ListaId_In.Count > 0 then
            begin
              i:= 0;
              if Result <> '' then
                Result:= Result + ' or ('
              else
                Result:= '(';
              ParseId2:
              k:= i;
              Result:= Result + APrefixo + 'id in (';
              sep:= '';
              if (ListaId_In.Count-i) > 1000 then
                j:= i+1000
              else
                j:= ListaId_In.Count-1;
              for i:= k to j do
              begin
                Result:= Result + sep + IntToStr(Integer(ListaId_In[i]));
                sep:= ',';
              end;
              Result:= Result + ')';
              if ListaId_In.Count-1 > i then
              begin
                Result:= Result + ' or ';
                goto ParseId2;
              end;
              Result:= Result + ')';  
            end;

            Result:= '(' + Result + ')';

          finally
            AQuery.EnableControls;
          end;
        finally
          ListaIds.Free;
          ListaId_In.Free;
        end;
      end
      else
      begin
        AQuery.DisableControls;
        try
          Result:= APrefixo + 'id in (';
          AQuery.First;
          sep:= '';
          while not AQuery.Eof do
          begin
            Result:= Result + sep + fldID.AsString;
            sep:= ',';
            AQuery.Next;
          end;
          Result:= Result + ')';
        finally
          AQuery.EnableControls;
        end;
      end;
    end
    else
      Result:= APrefixo + 'id = ' + fldID.AsString;

    if fldID.AsInteger <> IdAtual then
      AQuery.Locate('id', IdAtual, []);
  end
  else
    Result:= '';
end;

function Zeos_CondicaoIncluiCondicao(AQuery: TDataSet; const APrefixo: string; ACondicaoInclui: string): string;
var
  fldID: TField;
  sep: string;
begin
  fldID:= AQuery.FindField('ID');
  if fldID = nil then
    raise Exception.Create('DataSet deve ter campo ID para obter condição!');

  if not AQuery.IsEmpty then
  begin
    if AQuery.RecordCount > 1 then
    begin
      AQuery.DisableControls;
      try
        Result:= APrefixo + 'id in (';
        AQuery.First;
        sep:= '';
        while not AQuery.Eof do
        begin
          Result:= Result + sep + fldID.AsString;
          sep:= ',';
          AQuery.Next;
        end;

        if ACondicaoInclui <> '' then
          Result:= Result + sep + ACondicaoInclui;

        Result:= Result + ')';
      finally
        AQuery.EnableControls;
      end;
    end
    else
    begin
      Result:= APrefixo + 'id = ' + fldID.AsString;
      if ACondicaoInclui <> '' then
        Result:= Result + ' or '+ APrefixo + 'id in (' + ACondicaoInclui + ')';
    end;
  end
  else
  begin
    Result:= '';
    if ACondicaoInclui <> '' then
      Result:= APrefixo + 'id in (' + ACondicaoInclui + ')';
  end;
end;

function ZeosSQLResult(const ASQL: string; AConnection: TZConnection): Boolean;
var
  qry: TZReadOnlyQuery;
begin
  qry:= TZReadOnlyQuery.Create(nil);
  try
    qry.Connection:= AConnection;
    qry.SQL.Add(ASQL);
    qry.Open;
    Result:= not qry.Eof;
  finally
    qry.Free;
  end;
end;

function ZeosGeraID(const AGenName: string; AConnection: TZConnection): Integer;
var
  qry: TZReadOnlyQuery;
begin
  qry:= TZReadOnlyQuery.Create(nil);
  try
    qry.Connection:= AConnection;
    qry.SQL.Add('SELECT GEN_ID(' + AGenName + ', 1) FROM RDB$DATABASE');
    try
      qry.Open;
    except
      on E: Exception do
      begin
        // Verifica se deve criar o generator senão continua excessão
        if Pos('is not defined', E.Message) > 0 then
        begin
          qry.SQL.Clear;
          qry.SQL.Add('create generator '+ AGenName);
          qry.ExecSQL;
          qry.SQL.Clear;
          qry.SQL.Add('SELECT GEN_ID(' + AGenName + ', 1) FROM RDB$DATABASE');
          qry.Open;
        end
        else
          raise;
      end;
    end;
    Result:= qry.Fields[0].AsInteger;
  finally
    qry.Free;
  end;
end;

function ZeosAsString(const ASQL: string; AConnection: TZConnection): string;
var
  qry: TZReadOnlyQuery;
begin
  Result:= '';
  try
    qry:= TZReadOnlyQuery.Create(nil);
    try
      qry.Connection:= AConnection;
      qry.SQL.Add(ASQL);
      qry.Open;
      if not qry.Eof then
        Result:= qry.Fields[0].AsString
      else
        Result:= '';
    finally
      qry.Free;
    end;
  except
    ShowMessage('Erro de SQL: '+ ASQL);
  end;
end;

function ZeosAsInteger(const ASQL: string; AConnection: TZConnection): Integer;
begin
  Result:= StrToIntDef(ZeosAsString(ASQL, AConnection), -1);
end;

function ZeosAsFloat(const ASQL: string; AConnection: TZConnection): Real;
var
  qry: TZReadOnlyQuery;
begin
  qry:= TZReadOnlyQuery.Create(nil);
  try
    qry.Connection:= AConnection;
    qry.SQL.Add(ASQL);
    qry.Open;
    Result:= qry.Fields[0].AsFloat;
  finally
    qry.Free;
  end;
end;

function ZeosExists(const ASQL: string; AConnection: TZConnection): Boolean;
var
  qry: TZReadOnlyQuery;
begin
  qry:= TZReadOnlyQuery.Create(nil);
  try
    qry.Connection:= AConnection;
    qry.SQL.Add(ASQL);
    qry.Open;
    Result:= not qry.IsEmpty;
  finally
    qry.Free;
  end;
end;

function ZeosNewQuery(const ASQL: string; AConnection: TZConnection): TZReadOnlyQuery;
begin
  Result:= TZReadOnlyQuery.Create(nil);
  try
    Result.Connection:= AConnection;
    Result.SQL.Add(ASQL);
    Result.Open;
  except
    Result.Free;
    raise;
  end;
end;

function ZeosNewQueryFilial(const ASQL: string; const AFilial: string; AConnection: TZConnection): TZReadOnlyQuery;
begin
  Result:= TZReadOnlyQuery.Create(nil);
  try
    Result.Connection:= AConnection;
    Result.SQL.Add(ASQL);
    if Result.Params.FindParam('filial') <> nil then
      Result.ParamByName('filial').AsString:= AFilial
    else if Result.Params.FindParam('AFilial') <> nil then
      Result.ParamByName('AFilial').AsString:= AFilial;
    Result.Open;
  except
    Result.Free;
    raise;
  end;
end;

function ZeosPreparedQuery(const ASQL: string; AConnection: TZConnection): TZQuery;
begin
  Result:= TZQuery.Create(nil);
  try
    Result.Connection:= AConnection;
    Result.SQL.Add(ASQL);
  except
    Result.Free;
    raise;
  end;
end;

function Zeos_GetWhereStr(const ASQL: string): string;
var
  pWhere, pOrderBy: Integer;
  str: string;
begin
  pWhere:= Pos('where ', ASQL);
  if pWhere > 0 then
  begin
    pOrderBy:= Zeos_PosStrings(['order by ', 'group by '], ASQL, str, False);
    if pOrderBy > 0 then
      Result:= Copy(ASQL, pWhere, pOrderBy-pWhere)
    else
      Result:= Copy(ASQL, pWhere, MaxInt);
  end
  else
    Result:= '';
end;

function Zeos_GetWhereQuery(AQuery: TZQuery): string;
begin
  Result:= Zeos_GetWhereStr(AQuery.SQL.Text);
end;

function Zeos_SetFilterStr(const ASQL: string; AWhere: string; const APrefixo: string = ''): string;
var
  pWhere, pOrderBy: Integer;
  Sqlsmnt, str: string;
  TemFilial: Boolean;
begin
  Sqlsmnt:= Zeos_LowerCase(ASQL);
  AWhere:= Zeos_LowerCase(AWhere);
  if AWhere <> '' then
  begin
    // Verifica se deve incluir filial na condição
    TemFilial:= Pos(':filial', Sqlsmnt) > 0;
    if TemFilial and (Pos(':filial', AWhere) = 0) then
      AWhere:= '('+ AWhere + ')' + ' and '+ APrefixo + 'filial = :filial';
    if Pos('where ', AWhere) = 0 then
      AWhere:= ' where ' + AWhere;

    pWhere:= Pos('where', Sqlsmnt);
    pOrderBy:= Zeos_PosStrings(['order by ', 'group by '], Sqlsmnt, str, False);
    if pOrderBy > 0 then
    begin
      if pWhere = 0 then
        Insert(' ' + AWhere + ' ', Sqlsmnt, pOrderBy)
      else
      begin
        Delete(Sqlsmnt, pWhere, pOrderBy-pWhere);
        if Pos('where ', AWhere) = 0 then
          AWhere:= ' where ' + AWhere;
        Insert(' ' + AWhere + ' ', Sqlsmnt, pOrderBy-(pOrderBy-pWhere));
      end;
    end
    else
    begin
      if pWhere = 0 then
        Sqlsmnt:= Sqlsmnt + ' ' + AWhere
      else
      begin
        Delete(Sqlsmnt, pWhere, MaxInt);
        if Pos('where ', AWhere) = 0 then
          AWhere:= ' where ' + AWhere;
        Insert(' ' + AWhere + ' ', Sqlsmnt, pWhere+6);
      end;
    end;
  end;

  Result:= Sqlsmnt;
end;

function Zeos_SetFilterQuery(AQuery: TZQuery; const AWhere: string): string;
begin
  Result:= Zeos_SetFilterStr(AQuery.SQL.Text, AWhere);
  AQuery.SQL.Text:= Result;
end;

function Zeos_SetFilterReadOnlyQuery(AQuery: TZReadOnlyQuery; const AWhere: string): string;
begin
  Result:= Zeos_SetFilterStr(AQuery.SQL.Text, AWhere);
  AQuery.SQL.Text:= Result;
end;

procedure Zeos_RefreshWhere(const AQuery: TZQuery);
var
  sql: string;
  where: string;
begin
  sql:= LowerCase(AQuery.SQL.Text);
  if Pos('id in', sql) > 0 then
  begin
    where:= Zeos_Condicao(AQuery);
    Zeos_SetFilterQuery(AQuery, where);
  end;
end;

function Zeos_AddWhereStr(const ASQL: string; AWhere: string): string;
var
  Sqlsmnt: string;
  pWhere: Integer;
begin
  Sqlsmnt:= Zeos_LowerCase(ASQL);
  if AWhere <> '' then
  begin
    pWhere:= Pos('where ', Sqlsmnt);

    if pWhere > 0 then
      AWhere:= AWhere + ' and ' + Copy(Zeos_GetWhereStr(Sqlsmnt), 6, MaxInt)
    else
    begin
      pWhere:= Pos('where ', AWhere);
      if pWhere = 0 then
        AWhere:= ' where '+ AWhere;
    end;
    Result:= Zeos_SetFilterStr(Sqlsmnt, AWhere);
  end
  else
    Result:= Sqlsmnt;
end;

function Zeos_AddWhereQuery(AQuery: TZQuery; const AWhere: string): string;
begin
  Result:= Zeos_AddWhereStr(AQuery.SQL.Text, AWhere);
  AQuery.SQL.Text:= Result;
end;

function Zeos_AddWhereReadOnlyQuery(AQuery: TZReadOnlyQuery; const AWhere: string): string;
begin
  Result:= Zeos_AddWhereStr(AQuery.SQL.Text, AWhere);
  AQuery.SQL.Text:= Result;
end;

function Zeos_ReSelect(
  const ASQL: string;
  const ASelect: string;
  AConnection: TZConnection;
  const ACondicaoExtra: string = '';
  const AFilial: string = ''): TZReadOnlyQuery;
var
  Sqlsmnt: string;
  pFrom, pOrderBy, pGroupBy: Integer;
begin
  if ASelect <> '' then
  begin
    Result:= TZReadOnlyQuery.Create(nil);
    Result.Connection:= AConnection;
    Sqlsmnt:= Zeos_LowerCase(ASQL);
    if Copy(Sqlsmnt, 1, 7) <> 'select ' then
      Sqlsmnt:= 'select ' + Sqlsmnt;
    pFrom:= Pos('from ', Sqlsmnt);
    if pFrom > 0 then
    begin
      Delete(Sqlsmnt, 1, pFrom-1);
      Insert(ASelect + ' ', Sqlsmnt, 1);

      // Remove a cláusula group by
      pGroupBy:= Pos('group by ', Sqlsmnt);
      if pGroupBy > 0 then
        Delete(Sqlsmnt, pGroupBy, MaxInt);

      // Remove a cláusula order by
      pOrderBy:= Pos('order by ', Sqlsmnt);
      if pOrderBy > 0 then
        Delete(Sqlsmnt, pOrderBy, MaxInt);

      // Verifica se deve incluir uma condição extra
      if ACondicaoExtra <> '' then
        Sqlsmnt:= Zeos_AddWhereStr(Sqlsmnt, ACondicaoExtra);
    end;
    if (AFilial <> '') and (Pos(':filial', Sqlsmnt) > 0) then
      SqlSmnt:= Zeos_TrocaString(Sqlsmnt, ':filial', AFilial);
    Result.SQL.Text:= Sqlsmnt;
    Result.Open;
  end
  else
    Result:= nil;
end;

function Zeos_SetOrderByStr(ASQL: string; AOrderBy: string): string;
var
  pOrderBy: Integer;
  Sqlsmnt: string;
begin
  Sqlsmnt:= Zeos_LowerCase(ASQL);
  AOrderBy:= Zeos_LowerCase(AOrderBy);
  if AOrderBy <> '' then
  begin
    // Inclui order by em AOrderBy se não tiver
    if Copy(AOrderBy, 1, 9) <> 'order by ' then
      AOrderBy:= ' order by '+ AOrderBy;

    pOrderBy:= Pos('order by ', Sqlsmnt);
    if pOrderBy > 0 then
      Delete(Sqlsmnt, pOrderBy, MaxInt);
    Sqlsmnt:= Sqlsmnt + AOrderBy;
  end;
  Result:= Sqlsmnt;
end;

function Zeos_SetOrderByQuery(AQuery: TZQuery; AOrderBy: string): string;
begin
  Result:= Zeos_SetOrderByStr(AQuery.SQL.Text, AOrderBy);
  AQuery.SQL.Text:= Result;
end;

function Zeos_AddOrderByStr(ASQL: string; AOrderBy: string): string;
var
  pOrderBy: Integer;
  Sqlsmnt: string;
begin
  Sqlsmnt:= Zeos_LowerCase(ASQL);
  AOrderBy:= Zeos_LowerCase(AOrderBy);
  if AOrderBy <> '' then
  begin
    // Inclui orde by em AOrderBy se não tiver
    if Copy(AOrderBy, 1, 9) = 'order by ' then
      Delete(AOrderBy, 1, 9);

    pOrderBy:= Pos('order by ', Sqlsmnt);
    if pOrderBy > 0 then
      Sqlsmnt:= Sqlsmnt + ',' + AOrderBy
    else
      Sqlsmnt:= Sqlsmnt + ' order by ' + AOrderBy;
  end;
  Result:= Sqlsmnt;
end;

function Zeos_AddOrderByQuery(AQuery: TZQuery; const AOrderBy: string): string;
begin
  Result:= Zeos_AddOrderByStr(AQuery.SQL.Text, AOrderBy);
  AQuery.SQL.Text:= Result;
end;

function Zeos_AddOrderByReadOnlyQuery(AQuery: TZReadOnlyQuery; const AOrderBy: string): string;
begin
  Result:= Zeos_AddOrderByStr(AQuery.SQL.Text, AOrderBy);
  AQuery.SQL.Text:= Result;
end;

procedure Zeos_SetStrParamReadOnlyQuery(AQuery: TZReadOnlyQuery; const ANomeParam: string; const AValor: string);
var
  P: TParam;
begin
  P:= AQuery.Params.FindParam(ANomeParam);
  if P <> nil then
    P.AsString:= AValor;
end;

procedure Zeos_SetStrParamQuery(AQuery: TZQuery; const ANomeParam: string; const AValor: string);
var
  P: TParam;
begin
  P:= AQuery.Params.FindParam(ANomeParam);
  if P <> nil then
  begin
    if P.DataType in [ftDateTime, ftDate] then
    begin
      try
        P.AsDateTime:= StrToDateTime(AValor)
      except
        P.Clear;
      end;
    end
    else
      P.AsString:= AValor;
  end;
end;

procedure Zeos_SetDateParam(AQuery: TZQuery; const ANomeParam: string; const AValor: string);
var
  P: TParam;
begin
  P:= AQuery.Params.FindParam(ANomeParam);
  if P <> nil then
  begin
    P.DataType:= ftDateTime;
    try
      P.AsDateTime:= StrToDateTime(AValor)
    except
      P.Clear;
    end;
  end;
end;

procedure ZeosRefresh(AQuery: TZQuery);
const
  UltTicketCount: Cardinal = 0;
  UltQuerySQL: string = '';
  UltQuery: TZQuery = nil;
  bRefreshing: Boolean = False;
var
  F: TField;
  fldID, fldFilial: TField;
  id: Integer;
  FazRefresh: Boolean;
  EmEdicao: Boolean;
begin
  id:= -1;
  // Não faz refresh na mesma query em um intervalo muito pequeno
  if ((UltQuery <> nil) and (UltQuery = AQuery) and ((GetTickCount - UltTicketCount) < 200)) or
     ((UltQuerySQl <> '') and (UltQuerySQL = AQuery.SQL.Text) and ((GetTickCount - UltTicketCount) < 200)) then
  begin
    UltQuerySQL:= AQuery.SQL.Text;
    UltQuery:= AQuery;
    UltTicketCount:= GetTickCount;
    Exit;
  end;
  if bRefreshing then Exit;
  bRefreshing:= True;
  try
    fldID:= AQuery.FindField('ID');
    fldFilial:= AQuery.FindField('FILIAL');

    // Somente faz refresh se os campos ID e FILIAL estão preenchidos
    if (fldID <> nil) and not fldID.IsNull then
    begin
      if (AQuery.State = dsInsert) and (fldID <> nil) then
      begin
        if fldFilial <> nil then
          FazRefresh:= (fldID.AsInteger > 0) and (fldFilial.AsString <> '')
        else
          FazRefresh:= (fldID.AsInteger > 0);
      end
      else
        FazRefresh:= True;
    end
    else
      FazRefresh:= False;

    if FazRefresh then
    begin
      EmEdicao:= AQuery.State in [dsEdit, dsInsert];

      (*if (1 = 2) and (AQuery is TZQueryPlus) and (TZQueryPlus(AQuery).RefreshSQL.Count <> 0) then
      begin
        AQuery.DisableControls;
        try
          if AQuery.State in [dsEdit, dsInsert] then
            AQuery.Post;
          TZQueryPlus(AQuery).RefreshRecord;
        finally
          AQuery.EnableControls;
        end;
      end
      else
      begin*)
        with AQuery do Options:= Options - [doAlwaysDetailResync];
        AQuery.DisableControls;
        try
          F:= AQuery.FindField('id');
          if F <> nil then
            id:= F.AsInteger;

          if AQuery.State in [dsEdit, dsInsert] then
            AQuery.Post;

          Zeos_RefreshWhere(AQuery);

          if AQuery.Active then
          begin
            AQuery.Refresh;
            AQuery.Resync([]);
          end
          else
            AQuery.Open;
          if (F <> nil) and (F.AsInteger <> id) then
            AQuery.Locate('ID', id, []);
        finally
          AQuery.EnableControls;
        end;
        with AQuery do Options:= Options + [doAlwaysDetailResync];
      //end;

      if EmEdicao then
        AQuery.Edit;
    end;
  finally
    UltQuerySQL:= AQuery.SQL.Text;
    UltQuery:= AQuery;
    UltTicketCount:= GetTickCount;
    bRefreshing:= False;
  end;
end;

procedure ZeosRefreshReadOnlyQuery(AQuery: TZReadOnlyQuery);
const
  UltTicketCount: Cardinal = 0;
  UltQuerySQL: string = '';
  bRefreshing: Boolean = False;
begin
  // Não faz refresh na mesma query em um intervalo muito pequeno
  if bRefreshing or ((UltQuerySQl <> '') and (UltQuerySQL = AQuery.SQL.Text) and ((GetTickCount - UltTicketCount) < 1000)) then
    Exit;
  bRefreshing:= True;
  try
    AQuery.DisableControls;
    try
      AQuery.Close;
      AQuery.Open;
    finally
      AQuery.EnableControls;
    end;

    UltQuerySQL:= AQuery.SQL.Text;
    UltTicketCount:= GetTickCount;
  finally
    bRefreshing:= False;
  end;
end;

function Zeos_ID(AQuery: TDataSet): string;
var
  fldID: TField;
  sep: Char;
begin
  Result:= '';
  fldID:= AQuery.FindField('ID');
  if fldID = nil then
    raise Exception.Create('DataSet deve ter campo ID para obter condição!');

  if not AQuery.IsEmpty then
  begin
    AQuery.DisableControls;
    try
      AQuery.First;
      sep:= ' ';
      while not AQuery.Eof do
      begin
        Result:= Result + sep + fldID.AsString;
        sep:= ',';
        AQuery.Next;
      end;
      Result:= Trim(Result);
    finally
      AQuery.EnableControls;
    end;
  end;
end;


function ZeosCheckDuplicadoQuery(
  const AQuery: TZQuery;
  const ANomeTabela: string;
  const ACampoCompara: TField): Boolean;
var
  qry: TZReadOnlyQuery;
  fldID, fldFilial: TField;
begin
  fldID:= AQuery.FieldByName('ID');
  fldFilial:= AQuery.FindField('FILIAL');
  if (ACampoCompara.AsString <> '') and not fldID.IsNull then
  begin
    qry:= TZReadOnlyQuery.Create(nil);
    try
      qry.Connection:= AQuery.Connection;
      if fldFilial <> nil then
      begin
        qry.SQL.Add('select first 1 1 from '+ ANomeTabela +
                    ' where id <> '+ fldID.AsString + ' and filial = ' + fldFilial.AsString + ' and ' +
                     ACampoCompara.FieldName + ' = ' + QuotedStr(ACampoCompara.AsString));
      end
      else
      begin
        qry.SQL.Add('select first 1 1 from '+ ANomeTabela +
                    ' where id <> '+ fldID.AsString + ' and ' +
                     ACampoCompara.FieldName + ' = ' + QuotedStr(ACampoCompara.AsString));
      end;
      qry.Open;
      Result:= not qry.Eof;
    finally
      qry.Free;
    end;
  end
  else
  begin
    qry:= TZReadOnlyQuery.Create(nil);
    try
      qry.Connection:= AQuery.Connection;
      if fldFilial <> nil then
      begin
        qry.SQL.Add('select first 1 1 from '+ ANomeTabela +
                    ' where filial = ' + fldFilial.AsString + ' and ' + ACampoCompara.FieldName + ' = ' + QuotedStr(ACampoCompara.AsString));
      end
      else
      begin
        qry.SQL.Add('select first 1 1 from '+ ANomeTabela +
                    ' where ' + ACampoCompara.FieldName + ' = ' + QuotedStr(ACampoCompara.AsString));
      end;
      qry.Open;
      Result:= not qry.Eof;
    finally
      qry.Free;
    end;
  end;
end;

function ZeosCheckDuplicadoComValor(
  const AQuery: TZQuery;
  const ANomeTabela: string;
  const ACampoCompara: TField;
  const AValor: string): Boolean;
var
  qry: TZReadOnlyQuery;
  fldID, fldFilial: TField;
begin
  fldID:= AQuery.FieldByName('ID');
  fldFilial:= AQuery.FindField('FILIAL');
  if (ACampoCompara.AsString <> '') and not fldID.IsNull then
  begin
    qry:= TZReadOnlyQuery.Create(nil);
    try
      qry.Connection:= AQuery.Connection;
      qry.SQL.Add('select first 1 1 from '+ ANomeTabela +
                  ' where id <> '+ fldID.AsString + ' and filial = ' + fldFilial.AsString + ' and ' +
                   ACampoCompara.FieldName + ' = ' + QuotedStr(AValor));
      qry.Open;
      Result:= not qry.Eof;
    finally
      qry.Free;
    end;
  end
  else
  begin
    qry:= TZReadOnlyQuery.Create(nil);
    try
      qry.Connection:= AQuery.Connection;
      qry.SQL.Add('select first 1 1 from '+ ANomeTabela +
                  ' where filial = ' + fldFilial.AsString + ' and ' + ACampoCompara.FieldName + ' = ' + QuotedStr(AValor));
      qry.Open;
      Result:= not qry.Eof;
    finally
      qry.Free;
    end;
  end;
end;

function ZeosCheckDuplicadoForeignKeyQuery(
  const AQuery: TZQuery;
  const ANomeTabela: string;
  const ACampoCompara: TField;
  const ACampoForeignKey: TField): Boolean;
var
  fldID: TField;
  qry: TZReadOnlyQuery;
  fldFilial: TField;
begin
  fldID:= AQuery.FindField('ID');
  fldFilial:= AQuery.FindField('FILIAL');
  if (ACampoCompara.AsString <> '') and not fldID.IsNull then
  begin
    qry:= TZReadOnlyQuery.Create(nil);
    try
      qry.Connection:= AQuery.Connection;
      qry.SQL.Add('select first 1 1 from '+ ANomeTabela +
                  ' where id <> '+ fldID.AsString + ' and filial = ' + fldFilial.AsString + ' and ' +
                   ACampoCompara.FieldName + ' = ' + QuotedStr(ACampoCompara.AsString) +
                   ' and '+ ACampoForeignKey.FieldName + '='+ ACampoForeignKey.AsString);
      qry.Open;
      Result:= not qry.Eof;
    finally
      qry.Free;
    end;
  end
  else
  begin
    qry:= TZReadOnlyQuery.Create(nil);
    try
      qry.Connection:= AQuery.Connection;
      qry.SQL.Add('select first 1 1 from '+ ANomeTabela +
                  ' where filial = ' + fldFilial.AsString + ' and ' +
                    ACampoCompara.FieldName + ' = ' + QuotedStr(ACampoCompara.AsString) +
                    ' and '+ ACampoForeignKey.FieldName + '='+ ACampoForeignKey.AsString);
      qry.Open;
      Result:= not qry.Eof;
    finally
      qry.Free;
    end;
  end;
end;

function ZeosCheckDuplicadoForeignKeyComValor(
  AConnection: TZConnection;
  const ANomeTabela: string;
  const ACampoCompara: string;
  const ACampoForeignKey: string;
  const AValorCampoID: string;
  const AValorCampoFilial: string;
  const AValorCampoCompara: string;
  const AValorCampoForeignKey: string): Boolean;
var
  qry: TZReadOnlyQuery;
begin
  if (ACampoCompara <> '') and (AValorCampoID <> '') then
  begin
    qry:= TZReadOnlyQuery.Create(nil);
    try
      qry.Connection:= AConnection;
      qry.SQL.Add('select first 1 1 from '+ ANomeTabela +
                  ' where id <> '+ AValorCampoID + ' and filial = ' + AValorCampoFilial + ' and ' +
                   ACampoCompara + ' = ' + QuotedStr(AValorCampoCompara) +
                   ' and '+ ACampoForeignKey + '='+ AValorCampoForeignKey);
      qry.Open;
      Result:= not qry.Eof;
    finally
      qry.Free;
    end;
  end
  else
  begin
    qry:= TZReadOnlyQuery.Create(nil);
    try
      qry.Connection:= AConnection;
      qry.SQL.Add('select first 1 1 from '+ ANomeTabela +
                  ' where filial = ' + AValorCampoFilial + ' and ' +
                    ACampoCompara + ' = ' + QuotedStr(AValorCampoCompara) +
                    ' and '+ ACampoForeignKey + '='+ AValorCampoForeignKey);
      qry.Open;
      Result:= not qry.Eof;
    finally
      qry.Free;
    end;
  end;
end;

function ZeosCheckDuplicadoNull(
  const AQuery: TZQuery;
  const ANomeTabela: string;
  const ACampoCompara: TField): Boolean;
var
  qry: TZReadOnlyQuery;
  fldID, fldFilial: TField;
begin
  Result:= False;
  fldID:= AQuery.FieldByName('ID');
  fldFilial:= AQuery.FindField('FILIAL');
  if (ACampoCompara.AsString = '') and not fldID.IsNull then
  begin
    qry:= TZReadOnlyQuery.Create(nil);
    try
      qry.Connection:= AQuery.Connection;
      qry.SQL.Add('select first 1 1 from '+ ANomeTabela +
                  ' where id <> '+ fldID.AsString + ' and filial = ' + fldFilial.AsString + ' and ' +
                   ACampoCompara.FieldName + ' is null ');
      qry.Open;
      Result:= not qry.Eof;
    finally
      qry.Free;
    end;
  end;
end;

function ZeosCheckDuplicado2ComValor(
  const AQuery: TZQuery;
  const ANomeTabela: string;
  const ACampoCompara: TField;
  const ACampoCompara2: TField;
  const AValorCompara, AValorCompara2: string): Boolean;
var
  qry: TZReadOnlyQuery;
  fldID, fldFilial: TField;
begin
  fldID:= AQuery.FindField('ID');
  fldFilial:= AQuery.FindField('FILIAL');
  if (AValorCompara <> '') and not fldID.IsNull then
  begin
    qry:= TZReadOnlyQuery.Create(nil);
    try
      qry.Connection:= AQuery.Connection;
      qry.SQL.Add('select first 1 1 from '+ ANomeTabela +
                  ' where id <> '+ fldID.AsString + ' and ' +
                   ACampoCompara.FieldName + ' = ' + QuotedStr(AValorCompara) + ' and ' +
                   ACampoCompara2.FieldName + ' = ' + QuotedStr(AValorCompara2));
      if fldFilial <> nil then
        qry.SQL.Add(' and filial = ' + fldFilial.AsString);
      qry.Open;
      Result:= not qry.Eof;
    finally
      qry.Free;
    end;
  end
  else
  begin
    qry:= TZReadOnlyQuery.Create(nil);
    try
      qry.Connection:= AQuery.Connection;
      qry.SQL.Add('select first 1 1 from '+ ANomeTabela +
                  ' where '+
                    ACampoCompara.FieldName + ' = ' + QuotedStr(AValorCompara) + ' and '+
                    ACampoCompara2.FieldName + ' = ' + QuotedStr(AValorCompara2));
      if fldFilial <> nil then
        qry.SQL.Add(' and filial = ' + fldFilial.AsString);
      qry.Open;
      Result:= not qry.Eof;
    finally
      qry.Free;
    end;
  end;
end;

function ZeosCheckDuplicado2(
  const AQuery: TZQuery;
  const ANomeTabela: string;
  const ACampoCompara: TField;
  const ACampoCompara2: TField): Boolean;
begin
  Result:= ZeosCheckDuplicado2ComValor(AQuery, ANomeTabela, ACampoCompara,
     ACampoCompara2, ACampoCompara.AsString, ACampoCompara2.AsString);
end;

procedure Zeos_Rollback(AQuery: TZQuery);
begin
  if AQuery.State in [dsEdit, dsInsert] then
    AQuery.Cancel;
  if AQuery.Connection.InTransaction then
    AQuery.Connection.Rollback;
  ZeosRefresh(AQuery);
end;

procedure Zeos_Edit(AQuery: TZQuery);
begin
  if not AQuery.Connection.InTransaction then
    AQuery.Connection.StartTransaction;
  if AQuery.State = dsBrowse then
    AQuery.Edit;
end;

procedure Zeos_Insert(AQuery: TZQuery);
begin
  if not AQuery.Connection.InTransaction then
    AQuery.Connection.StartTransaction;
  AQuery.Insert;
end;

procedure Zeos_Salvar(AQuery: TZQuery);
begin
   if (AQuery.State in [dsEdit, dsInsert]) then
     AQuery.Post;
   if AQuery.Connection.InTransaction then
     AQuery.Connection.Commit;
   ZeosRefresh(AQuery);
end;

procedure Zeos_Cancel(AQuery: TZQuery);
begin
  Zeos_RollBack(AQuery);
end;

function Zeos_FieldModified(const AField: TField): Boolean;
begin
  if AField.DataSet.Modified then
  begin
    if AField.DataSet.State = dsInsert then
      Result:= True
    else
    begin
      try
        Result:= AField.OldValue <> AField.Value;
      except
        // Pode ocorrer uma excessão se as variáveis forem unassigned
        Result:= False;
      end;
    end;
  end
  else
    Result:= False;
end;


function Zeos_InEdit(AQuery: TZQuery): Boolean;
var
  fldGStatus: TField;
begin
  fldGStatus:= AQuery.FindField('GSTATUS');
  Result:= (AQuery.State in [dsInsert, dsEdit]) or ((fldGStatus <> nil) and (fldGStatus.AsString = 'I'));
end;

procedure Zeos_MaxMin1(
  const ASQL: string;
  ASelectMaxMin: string;
  out ADataInicial, ADataFinal: string;
  AConnection: TZConnection;
  AFilial: string = '1');
var
  qry: TZReadOnlyQuery;
  Sqlsmnt: string;
  pFrom, pOrderBy, pGroupBy: Integer;
begin
  ADataInicial:= '  /  /    ';
  ADataFinal:= '  /  /    ';

  ASelectMaxMin:= LowerCase(ASelectMaxMin);
  if Copy(ASelectMaxMin, 1, 7) <> 'select ' then
    ASelectMaxMin:= 'select ' + ASelectMaxMin;

  qry:= TZReadOnlyQuery.Create(nil);
  try
    qry.Connection:= AConnection;

    Sqlsmnt:= ASQL;
    if Sqlsmnt <> '' then
    begin
      pFrom:= Pos('from ', Sqlsmnt);
      if pFrom > 0 then
      begin
        Delete(Sqlsmnt, 1, pFrom-1);
        Insert(ASelectMaxMin + ' ', Sqlsmnt, 1);

        // Remove a cláusula group by
        pGroupBy:= Pos('group by ', Sqlsmnt);
        if pGroupBy > 0 then
          Delete(Sqlsmnt, pGroupBy, MaxInt);

        // Remove a cláusula order by
        pOrderBy:= Pos('order by ', Sqlsmnt);
        if pOrderBy > 0 then
          Delete(Sqlsmnt, pOrderBy, MaxInt);

      end;
    end;

    qry.SQL.Text:= Sqlsmnt;
    if qry.Params.FindParam('FILIAL') <> nil then
      qry.ParamByName('FILIAL').AsString:= AFilial;
    qry.Open;

    if not qry.IsEmpty then
    begin
      if not qry.Fields[0].IsNull then
        ADataInicial:= qry.Fields[0].AsString;
      if not qry.Fields[1].IsNull then
        ADataFinal:= qry.Fields[1].AsString;
    end;
  finally
    qry.Free;
  end;
end;

procedure Zeos_MaxMin2(
  const ASQL: string;
  ASelectMaxMin: string;
  out ADataInicial, ADataFinal: string;
  ADataInicialFieldName, ADataFinalFieldName: string;
  AConnection: TZConnection);
var
  qry: TZReadOnlyQuery;
  Sqlsmnt: string;
  pFrom, pOrderBy, pGroupBy: Integer;
begin
  ADataInicial:= '  /  /    ';
  ADataFinal:= '  /  /    ';

  ASelectMaxMin:= LowerCase(ASelectMaxMin);
  if Copy(ASelectMaxMin, 1, 7) <> 'select ' then
    ASelectMaxMin:= 'select ' + ASelectMaxMin;

  qry:= TZReadOnlyQuery.Create(nil);
  try
    qry.Connection:= AConnection;

    Sqlsmnt:= ASQL;
    if Sqlsmnt <> '' then
    begin
      pFrom:= Pos('from ', Sqlsmnt);
      if pFrom > 0 then
      begin
        Delete(Sqlsmnt, 1, pFrom-1);
        Insert(ASelectMaxMin + ' ', Sqlsmnt, 1);

        // Remove a cláusula group by
        pGroupBy:= Pos('group by ', Sqlsmnt);
        if pGroupBy > 0 then
          Delete(Sqlsmnt, pGroupBy, MaxInt);

        // Remove a cláusula order by
        pOrderBy:= Pos('order by ', Sqlsmnt);
        if pOrderBy > 0 then
          Delete(Sqlsmnt, pOrderBy, MaxInt);

      end;
    end;

    qry.SQL.Text:= Sqlsmnt;
    qry.Open;
    if not qry.IsEmpty then
    begin
      if not qry.FieldByName(ADataInicialFieldName).IsNull then
        ADataInicial:= qry.FieldByName(ADataInicialFieldName).AsString;
      if not qry.FieldByName(ADataFinalFieldName).IsNull then
        ADataFinal:= qry.FieldByName(ADataFinalFieldName).AsString;
    end;
  finally
    qry.Free;
  end;
end;

function Zeos_CountQuery(AQuery: TZQuery; const ACondicao: string; const AFilial: string): Integer;
var
  SqlSmnt: string;
  qry: TZReadOnlyQuery;
begin
  SqlSmnt:= AQuery.SQL.Text;
  qry:= Zeos_ReSelect(SqlSmnt, 'select count(1)',
    AQuery.Connection, ACondicao, AFilial);
  try
    if not qry.IsEmpty then
      Result:= qry.Fields[0].AsInteger
    else
      Result:= 0;
  finally
    qry.Free;
  end;
end;

function Zeos_Count(const ANomeTabela: string; AFilial: string; AConnection: TZConnection): Integer;
var
  qry: TZReadOnlyQuery;
  sql: string;
begin
  qry:= TZReadOnlyQuery.Create(nil);
  try
    qry.Connection:= AConnection;
    if AFilial <> '' then
      sql:= 'select count(1) from '+ ANomeTabela + ' where filial = '+ AFilial
    else
      sql:= 'select count(1) from '+ ANomeTabela;

    qry.SQL.Add(sql);
    qry.Open;
    Result:= qry.Fields[0].AsInteger;
  finally
    qry.Free;
  end;
end;

function Zeos_SumCondicao(AFieldSum: TField; const ACondicao: string; const AFilial: string): Real;
var
  SqlSmnt: string;
  qry: TZReadOnlyQuery;
begin
  SqlSmnt:= Zeos_LowerCase(TZQuery(AFieldSum.DataSet).SQL.Text);
  qry:= Zeos_ReSelect(SqlSmnt, 'select sum('+ AFieldSum.FieldName + ')',
    TZQuery(AFieldSum.DataSet).Connection, ACondicao, AFilial);
  try
    if not qry.IsEmpty then
      Result:= qry.Fields[0].AsFloat
    else
      Result:= 0.00;
  finally
    qry.Free;
  end;
end;

function Zeos_Sum(AField: TField): Double;
var
  bookmark: TBookmarkStr;
  dat: TDataSet;
  AfterScrollProc: TDataSetNotifyEvent;
begin
  dat:= AField.DataSet;
  if dat.Active and (dat.State = dsBrowse) then
  begin
    AfterScrollProc:= dat.AfterScroll;
    dat.AfterScroll:= nil;
    dat.DisableControls;
    bookmark:= dat.Bookmark;
    try
      Result:= 0.00;
      dat.First;
      while not dat.Eof do
      Begin
        Result:= Result + AField.AsFloat;
        dat.Next;
      end;
    finally
      dat.Bookmark:= bookmark;
      dat.EnableControls;
      dat.AfterScroll:= AfterScrollProc;
    end;
  end
  else
    Result:= 0.00;
end;

function Zeos_GetTableNameFromSQL(const ASQL: string): string;
var
  p: Integer;
begin
  Result:= '';
  p:= Pos(' from ', LowerCase(ASQL));
  if p > 0 then
  begin
    Result:= Trim(Zeos_CopyWord(ASQL, p+6));
    if Result[Length(Result)] = '(' then
      Delete(Result, Length(Result), 1);
  end;
end;

function Zeos_GetCamposNaoExisteTabela(ATabela: TZQuery): string;
var
  qry: TZReadOnlyQuery;
  NomeTabela: string;
  i: Integer;
  sep: string;
begin
  Result:= ''; sep:= '';
  if ATabela.SQL.Text <> '' then
  begin
    NomeTabela:= Zeos_GetTableNameFromSQL(ATabela.SQL.Text);
    qry:= ZeosNewQuery('select first 1 * from '+ NomeTabela, ATabela.Connection);
    try
      for i:= 0 to ATabela.Fields.Count-1 do
      begin
        if qry.FindField(ATabela.Fields[i].FieldName) = nil then
        begin
          Result:= Result + sep + ATabela.Fields[i].FieldName;
          sep:= ', ';
        end;
      end;
    finally
      qry.Free;
    end;
  end;
end;

function Zeos_ConcatenaComQuebra3(const S1, S2, S3: string; const AQuebra: string = #13#10): string;
var
  sep: string;
begin
  Result:= '';
  sep:= '';
  if S1 <> '' then
  begin
    Result:= Trim(S1);
    sep:= #13;
  end;

  if S2 <> '' then
  begin
    Result:= Result + sep + Trim(S2);
    sep:= #13;
  end;

  if S3 <> '' then
  begin
    Result:= Result + sep + Trim(S3);
    sep:= #13;
  end;

end;

function Zeos_ConcatenaComQuebra5(const S1, S2, S3, S4, S5: string; const AQuebra: string = #13#10): string;
var
  sep: string;
begin
  Result:= '';
  sep:= '';
  if S1 <> '' then
  begin
    Result:= Trim(S1);
    sep:= #13;
  end;

  if S2 <> '' then
  begin
    Result:= Result + sep + Trim(S2);
    sep:= #13;
  end;

  if S3 <> '' then
  begin
    Result:= Result + sep + Trim(S3);
    sep:= #13;
  end;

  if S4 <> '' then
  begin
    Result:= Result + sep + Trim(S4);
    sep:= #13;
  end;

  if S5 <> '' then
  begin
    Result:= Result + sep + Trim(S5);
    sep:= #13;
  end;

end;

function Zeos_ProxToken(
  var S: string;
  const ASep: array of string;
  ARemoveSep: Boolean = True;
  ARetornaTudoSeNaoEncontrar: Boolean = True;
  ASepEncontrado: PChar = nil;
  APesquisaSepEmOrdem: Boolean = True): string;
//********************************************************************
// Extrai o próximo token de uma string.
// Parãmetros: S -> string a pesquisar
//             ASep -> tokens que separam as produções;
//             ARemoveSep -> Se deve remover Sep após extrai um token
//             ARetornaTudoSeNaoEncontrar ->Se deve retornar a toda string caso nenhum token for encontrado
// Autor: Everton de Vargas Agilar
//********************************************************************
var
  p, p_ant, i: Integer;
  sep: string;
begin
  Result:= '';
  p_ant:= MaxInt;
  { Tenta obter o próximo token separado por um dos separadores }
  for i:= Low(ASep) to High(ASep) do
  begin
    { Localiza a posição do separador }
    sep:= ASep[i];
    p:= Pos(sep, S);
    { Se existe o separador e a posição deste separador é menor
      que a posição do último separador pesquisado usa este separador }
    if (p > 0) and (p < p_ant) then
    begin
      Result:= Copy(S, 1, p-1);
      { Verifica se deve retornar o separador encontrado }
      if ASepEncontrado <> nil then
        StrPCopy(ASepEncontrado, sep);
      { Se a pesquisa dos separadores é feita em órdem sai }
      if APesquisaSepEmOrdem then Break;
      p_ant:= p;
    end;
  end;

  if (Result = '') and (ASepEncontrado <> nil) then
    ASepEncontrado[0]:= #0;

  { Se não encontrou um token entre os separadores é o último Token }
  if (Result = '') then
  begin
    if ARetornaTudoSeNaoEncontrar then
    begin
      Result:= Trim(S);
      S:= '';
      Exit;
    end
    else
    begin
      Result:= '';
      Exit;
    end;
  end;

  { Deleta este token de S }
  if ARemoveSep then
    Delete(S, 1, Length(Result)+Length(sep))
  else
    Delete(S, 1, Length(Result));

  S:= Trim(S);

  { Remove qualquer espaço desnecessário }
  Result:= Trim(Result);
end;

{$WARNINGS ON}

function Zeos_ExisteToken(const Token, S: string): Boolean;
begin
  Result:= Pos(Token, S) > 0;
end;

{$WARNINGS OFF}

function Zeos_InsereString(
  const ASubStr: string;
  var AString: string;
  const AInitToken: array of string;
  AInsereAposToken: Boolean = True): Integer;
var
  InitToken: string;
  p1: Integer;
begin
  p1:= Zeos_PosStrings(AInitToken, AString, InitToken);
  if p1 <> 0 then
  begin
    if AInsereAposToken then
      Result:= p1 + Length(InitToken)
    else
      Result:= p1;
    Insert(ASubStr, AString, Result);
  end
  else
  begin
    Result:= Length(AString)+1;
    AString:= AString + ASubStr;
  end;
end;

function Zeos_GetMacAddress: string;
var
  Lib: Cardinal;
  Func: function(GUID: PGUID): Longint; stdcall;
  GUID1, GUID2: TGUID;
begin
  Result := '';
  Lib := LoadLibrary('rpcrt4.dll');
  if Lib <> 0 then
  begin
    @Func := GetProcAddress(Lib, 'UuidCreateSequential');
    if Assigned(Func) then
    begin
      if (Func(@GUID1) = 0) and
         (Func(@GUID2) = 0) and
         (GUID1.D4[2] = GUID2.D4[2]) and
         (GUID1.D4[3] = GUID2.D4[3]) and
         (GUID1.D4[4] = GUID2.D4[4]) and
         (GUID1.D4[5] = GUID2.D4[5]) and
         (GUID1.D4[6] = GUID2.D4[6]) and
         (GUID1.D4[7] = GUID2.D4[7]) then
      begin
        Result :=
          IntToHex(GUID1.D4[2], 2) + '-' +
          IntToHex(GUID1.D4[3], 2) + '-' +
          IntToHex(GUID1.D4[4], 2) + '-' +
          IntToHex(GUID1.D4[5], 2) + '-' +
          IntToHex(GUID1.D4[6], 2) + '-' +
          IntToHex(GUID1.D4[7], 2);
      end;
    end;
  end;
end;

function Zeos_IsQuisceRestricted: Boolean;
begin
  // DBA
  Result:= (Zeos_GetMacAddress = '00-19-7E-02-B4-DD') or
           (Zeos_GetMacAddress = '00-16-D4-CC-94-19');
end;

function Zeos_IsQuisceDesenv: Boolean;
var
  mac: string;
begin
  mac:= Zeos_GetMacAddress;
  Result:=  // Agilar
           (mac = '00-19-7E-02-B4-DD') or
           (mac = '00-16-D4-CC-94-19') or
           // Daniel
           (mac = '00-16-36-11-71-EE') or
           (mac = '00-16-CE-13-CD-D7') or
           // Jader
           (mac = '00-19-7D-20-EC-B7') or
           (mac = '00-16-D4-65-7F-A3');

  Result:= True;
end;

{ Obtém o caminho na rede de uma unidade de rede.
  Ex.: obter de F: supondo que esta conectado em \\agilar\arquivos de programas\Polidados
     retorna '\\agilar\arquivos de programas\Polidados'
}
function Zeos_GetCaminhoLocalFromCaminho(ACaminho: string): string;
var
  p: Integer;
begin
  // Remove o IP se existir
  p:= Pos(':', ACaminho);
  if (p > 0) and (Length(ACaminho) >= p+1) and (ACaminho[p+1] <> '\') then
    Delete(ACaminho, 1, p);

  // Remove a porta se existir
  if (Length(ACaminho) > 2) and (ACaminho[1] = '/') and (ACaminho[2] in ['0'..'9']) then
  begin
    p:= 1;
    while (p < Length(ACaminho)) and (ACaminho <> ':') do
    begin
      if ACaminho[p] = ':' then
      begin
        Result:= Copy(ACaminho, p+1, MaxInt);
        Exit;
      end;
      Inc(p);
    end;
  end;

  Result:= ACaminho;
end;

function Zeos_GetCaminhoMapeamentoFromLetra(const ALetra: string): string;
var
  lpRemoteName: array[0..250] of Char;
  lpLength: Cardinal;
begin
  lpLength:= 250;
  if WNetGetConnection(PChar(ALetra), lpRemoteName, lpLength) = NO_ERROR then
    Result:= StrPas(lpRemoteName)
  else
    Result:= '';
end;

{ Obtém uma unidade livre para fazer um mapeamento.
  Parametros:
    APartirDeDrive: inicia a procura a partir do drive especificado. Ex.: a partir de 'F:'
    ADrivePreferencial: se o drive estiver disponível será retornado esse como livre
                desde que não estaja sendo usado;
    AParaConectarCaminho: A unidade que deve ser procurada é para conectar o caminho;
                     especificado. Se encontrar algum utilizado e for esse caminho
                     retorna-o como livre
  Retorna a unidade livre. Ex.: 'F:'
}
function Zeos_GetUnidadeLivreParaMapeamento(
  const APartirDeDrive, ADrivePreferencial, AParaConectarCaminho: string;
  out ACaminhoJaMapeado: Boolean): string;
var
  drive: Char;
  caminho: string;
begin
  Result:= '';

  if ADrivePreferencial <> '' then
  begin
    caminho:= Zeos_GetCaminhoMapeamentoFromLetra(ADrivePreferencial);
    ACaminhoJaMapeado:= CompareText(caminho, AParaConectarCaminho) = 0;
    if (caminho = '') or ACaminhoJaMapeado then
    begin
      Result:= ADrivePreferencial;
      Exit;
    end;
  end;

  if APartirDeDrive = '' then
    drive:= 'A'
  else
    drive:= APartirDeDrive[1];
  ACaminhoJaMapeado:= False;

  while drive <= 'Z' do
  begin
    caminho:= Zeos_GetCaminhoMapeamentoFromLetra(drive+':');
    ACaminhoJaMapeado:= CompareText(caminho, AParaConectarCaminho) = 0;
    if (caminho = '') or ACaminhoJaMapeado then
    begin
      Result:= drive + ':';
      Exit;
    end;
    Inc(drive);
  end;
end;

function Zeos_DesmapearUnidadeRede(const ALetra: string): Boolean;
begin
  Result:= WNetCancelConnection(PChar(ALetra), True) = NO_ERROR;
end;

function Zeos_FormataCaminhoDB(ACaminhoDB: string): string;
var
  NomeServidor, NovoNomeServidor: string;
  pBackslash: Integer;
  Unidade: string;
  NomeServidorApenas: string;
  CaminhoLocal: Boolean;
  NomeDB: string;
  ch: Char;
  i: Integer;
begin
  // Verifica presença do arquivo do banco de dados com extenção '.fdb'
  if CompareText(Copy(ACaminhoDB, Length(ACaminhoDB)-3, 5), '.FDB') <> 0 then
    raise Exception.CreateFmt('Caminho de banco de dados "%s" inválido.', [ACaminhoDB]);

  // Se o caminho é uma URL não faz nada
  if Pos('/', ACaminhoDB) > 0 then
  begin
    Result:= ACaminhoDB;
    Exit;
  end;

  { Caminhos que teremos que tratar:
   Ex.1: \\Polidados01\c\desenvolvimento\Polidados
   Ex.2: \\desenv05\c
   Ex.3  \\desenv06\Polidados\

   O banco de dados aceita assim: servidor:c:\arquivos de programas\Polidados }

  // Verifica se é caminho local ou de rede
  if Copy(ACaminhoDB, 1, 2) = '\\' then
  begin
    // Obtém o nome do servidor
    pBackslash:= PosStr('\', ACaminhoDB, 3);
    if pBackslash = 0 then // Ex.: \\desenv06
      raise Exception.Create('Caminho de rede incompleto. Informe a unidade de disco!')
    else
    begin
      // É necessário mapear um compartilhamento
      pBackslash:= pBackslash + PosStr('\', ACaminhoDB, pBackslash+3);
      NomeServidor:= Copy(ACaminhoDB, 3, pBackslash-1);
      NomeServidorApenas:= Copy(NomeServidor, 1, Pos('\', NomeServidor)-1);
      NomeServidor:= '\\' + NomeServidor;
    end;

    // Se o nome do servidor for o computador local troca pela unidade pois
    // não é necessário mapear
    if CompareText(NomeServidorApenas, GetNomeMaquina) = 0 then
    begin
      Unidade:= NomeServidor[Length(NomeServidor)] + ':';
      Result:= Zeos_TrocaString(ACaminhoDB, NomeServidor, Unidade) + NomeDB;
    end
    else
    begin
      NovoNomeServidor:= NomeServidorApenas + ':';
      Result:= Zeos_TrocaString(ACaminhoDB, '\\' + NomeServidorApenas, NovoNomeServidor) + NomeDB;

      // Após os ':' do nome do serviço não pode existir '\'
      pBackslash:= Length(NovoNomeServidor)+1;
      if Result[pBackslash] = '\' then
        Delete(Result, pBackslash, 1);

      // Troca o próx. \ por :\
      for i:= pBackslash to Length(Result) do
      begin
        ch:= Result[i];
        if ch = '\' then
        begin
          Insert(':', Result, i);
          Break;
        end;
      end;
    end;
  end
  else
  begin
    // é uma unidade: c:\
    if (UpCase(ACaminhoDB[1]) in ['A'..'Z']) and (ACaminhoDB[2] = ':') and
      (ACaminhoDB[3] = '\') then
        CaminhoLocal:= True
    else
    begin
      Result:= ACaminhoDB;
      Exit;
    end;
  end;
end;

function Zeos_MapearUnidadeRedeUser(const ACaminho, ALetra, AUsuario, ASenha: string; out AErrorFlag: Integer): Boolean;
var
  NetResource: TNetResource;
  User, PassWord: array[0..MAX_PATH] of Char;
  LocalName, RemoteName: array[0..MAX_PATH] of Char;
begin
  with NetResource do
  begin
    dwType := RESOURCETYPE_DISK;
    StrPCopy(LocalName, ALetra);
    StrPCopy(RemoteName, ACaminho);
    lpLocalName := LocalName;
    lpRemoteName := RemoteName;
    lpProvider := '';
  end;
  StrPCopy(User, AUsuario);
  StrPCopy(Password, ASenha);
  Result:= WNetAddConnection3(INVALID_HANDLE_VALUE, NetResource, Password,
    User, CONNECT_INTERACTIVE and CONNECT_PROMPT) = NO_ERROR;
  if Result then
    AErrorFlag:= 0
  else
    AErrorFlag:= GetLastError;
end;

function Zeos_MapearUnidadeRede(const ACaminho, ALetra: string; out AErrorFlag: Integer): Boolean;
begin
  Result:= WNetAddConnection(PChar(ACaminho), nil, PChar(ALetra)) = NO_ERROR;
  if Result then
    AErrorFlag:= 0
  else
    AErrorFlag:= GetLastError;
end;

function Zeos_RemoveContraBarraNomeArq(var ANomeArq: string): string;
//**************************************************************
// Remove a contra-barra no final do nome do arquivo se existir.
// Retorna o nome do arquivo.
// Autor: Everton de Vargas Agilar
// Data: 05/04/2004
//**************************************************************
begin
  ANomeArq:= Trim(ANomeArq);
  if ANomeArq <> '' then
  begin
    while (ANomeArq <> '') and (ANomeArq[Length(ANomeArq)] in ['\', '/']) do
      Delete(ANomeArq, Length(ANomeArq), 1);
  end;
  Result:= ANomeArq;
end;

function Zeos_ExtraiContraBarraNomeArq(const ANomeArq: string): string;
//**************************************************************
// Extrai a contra-barra no final do nome do arquivo se existir.
// Retorna o nome do arquivo.
// Autor: Everton de Vargas Agilar
// Data: 28/01/2010
//**************************************************************
var
  tmp: string;
begin
  tmp:= Trim(ANomeArq);
  if tmp <> '' then
  begin
    while (tmp <> '') and (tmp[Length(tmp)] in ['\', '/']) do
      Delete(tmp, Length(tmp), 1);
  end;
  Result:= tmp;
end;

function Zeos_CheckMapeiaUnidadeRede(ACaminho: string; out AMapeado: Boolean;
  out ACaminhoJaMapeado: Boolean): string;
var
  NomeServidor: string;
  pBackslash: Integer;
  ErroFlag: Integer;
  UnidadeLivre: string;
  NomeServidorApenas: string;
  CaminhoLocal: Boolean;
  pDoisPontos: Integer;

  function GetUnidadeLivre: string;
  begin
    Result:= Zeos_GetUnidadeLivreParaMapeamento('P:', 'P', NomeServidor, ACaminhoJaMapeado);
  end;

begin
  if ACaminho[Length(ACaminho)] <> '\' then
    ACaminho:= ACaminho + '\';

  // Ex.1: \\Polidados01\c\desenvolvimento\Polidados
  // Ex.2: \\desenv05\c
  // Ex.3  \\desenv06\Polidados\
  if Length(ACaminho) > 3 then
  begin
    CaminhoLocal:= False;
    if Copy(ACaminho, 1, 2) = '\\' then
    begin
      // Obtém o nome do servidor
      pBackslash:= PosStr('\', ACaminho, 3);
      if pBackslash = 0 then // Ex.: \\desenv06
      begin
        ShowMessage('Caminho de rede incompleto. Informe a unidade de disco!');
        Abort;
      end
      else
      begin
        // É necessário mapear um compartilhamento
        pBackslash:= pBackslash + PosStr('\', ACaminho, pBackslash+3);
        NomeServidor:= Copy(ACaminho, 3, pBackslash-1);

        // Em um caminho por compartilhamento não pode ter ':'
        // erro: \\desenv06\c:\arquivos de programas
        // correção: \\desenv06\c\arquivos de programas
        if NomeServidor[Length(NomeServidor)] = ':' then
        begin
          NomeServidor:= Copy(NomeServidor, 1, Length(NomeServidor)-1);
          pDoisPontos:= Pos(':', ACaminho);
          Delete(ACaminho, pDoisPontos, 1);
        end;

        NomeServidorApenas:= Copy(NomeServidor, 1, Pos('\', NomeServidor)-1);
        NomeServidor:= '\\' + NomeServidor;
      end;

      // Se o nome do servidor for o computador local troca pela unidade pois
      // não é necessário mapear
      if (CompareText(NomeServidorApenas, GetNomeMaquina) = 0) and
        ((NomeServidor[Length(NomeServidor)] in ['A'..'Z', 'a'..'z']) and
         (NomeServidor[Length(NomeServidor)-1] = '\')) then
      begin
        UnidadeLivre:= NomeServidor[Length(NomeServidor)];
        if ACaminho[Length(NomeServidor)+1] <> ':' then
          UnidadeLivre:= UnidadeLivre + ':';
        CaminhoLocal:= True;
      end
      else
      begin
        ACaminhoJaMapeado:= False;
        CaminhoLocal:= False;
        UnidadeLivre:= GetUnidadeLivre;
        if not ACaminhoJaMapeado then
        begin
          if not Zeos_MapearUnidadeRede(NomeServidor, UnidadeLivre{, GetUsuarioLocal, GetSenhaUsuario}, ErroFlag) then
          begin
            ShowMessage('Caminho da rede não encontrado ou permissão de acesso negada.'#13#13+
                        'Verifique se este computador tem permissão de acesso a pasta especificada!');
            Abort;
          end;
        end;
      end;
      Result:= Zeos_TrocaString(ACaminho, NomeServidor, UnidadeLivre);
    end
    else
    begin
      Result:= ACaminho;
      CaminhoLocal:= True;
    end;
  end
  else
  begin
    Result:= ACaminho;
    CaminhoLocal:= True;
  end;
  Zeos_RemoveContraBarraNomeArq(Result);
  AMapeado:= not CaminhoLocal;
end;

function Zeos_QuebraLinha(S: string; ALength: Integer; ABreakTag: string = #13): string;
var
  Texto, TextoQuebra: string;
  HouveQuebra: Boolean;
  Len, p, pRWord, pLWord: Integer;
begin
  Result:= '';
  Texto:= Trim(S);
  if ABreakTag = '' then
    ABreakTag:= #13;

  if (Texto <> '') and (Length(S) >= ALength) then
  begin
    if (ALength <> 0) and (Length(Texto) > ALength) then
    begin
      HouveQuebra:= True;
      while Texto <> '' do
      begin
        Len:= ALength;
        if Length(Texto) <= Len then
          TextoQuebra:= Texto
        else
        begin
          p:= Len;
          while (Length(Texto) <= p) and (Texto[p] <> ' ') do
            Inc(p);
          pRWord:= p;
          p:= Len;
          while (p >= 1) and (Texto[p] <> ' ') do
            Dec(p);
          pLWord:= p;
          if pRWord <> Len then
            Len:= pRWord
          else
          begin
            Len:= pLWord;
            if Len = 0 then
            begin
              p:= 1;
              while (p <= Length(Texto)) and (Texto[p] <> ' ') do
                Inc(p);
              Len:= p;
            end;
          end;
          TextoQuebra:= Copy(Texto, 1, Len);
        end;

        if Result <> '' then
          Result:= Result + ABreakTag + TextoQuebra
        else
          Result:= TextoQuebra;

        Delete(Texto, 1, Length(TextoQuebra));
      end;
    end
    else
      Result:= Texto;
  end;
end;

function Zeos_GetValorParam(const AStr: string; const ASep: string = ';'): string;
//********************************************************************
// GetValorParam
// Obtem um valor de uma parâmetro em AStr.
// Ex.: ObtemValor('PARAM1='XYZ') = 'XYZ'
// Autor: Everton de Vargas Agilar
//********************************************************************
begin
  Result:= Copy(AStr, Pos(ASep, AStr)+1, MaxInt);
end;

function Zeos_GetNomeParam(const AStr: string): string;
//********************************************************************
// GetNomeParam
// Obtem o nome de uma parâmetro em AStr.
// Ex.: ObtemValor('PARAM1='XYZ') = 'PARAM1'
// Autor: Everton de Vargas Agilar
//********************************************************************
begin
  Result:= Copy(AStr, 1, Pos('=', AStr)-1);
end;

function Zeos_ExtraiValorEnum(var AStr: string; ASep: string = ';'): string;
//********************************************************************
// ExtraiValorEnum
// Extrai um valor enumerado de uma string.
// Ex.: ExtraiValorEnum('Borland; Delphi; 6') = 'Borland'   1º chamada
//      ExtraiValorEnum('Borland; Delphi; 6') = 'Delphi'    2º chamada
//      ExtraiValorEnum('Borland; Delphi; 6') = '6'         3º chamada
// Autor: Everton de Vargas Agilar
//********************************************************************
var
  p: Integer;
begin
  p:= Pos(ASep, AStr);
  { Se não encontrou separador retorna tudo }
  if p = 0 then
  begin
    Result:= AStr;
    AStr:= '';
  end
  else
  begin
    Result:= Copy(AStr, 1, p-1);
    Delete(AStr, 1, p);
  end;
  Result:= Trim(Result);
end;

function Zeos_GetEnumCount(const AStr: string; ASep: string = ';'): Integer;
//********************************************************************
// GetEnumCount
// Retorna a quantidade de enumerações na string.
// Ex.: GetEnumCount('Borland; Delphi; 6') = 3
// Autor: Everton de Vargas Agilar
//********************************************************************
var
  p1, p2: Integer;
begin
  Result:= 0;
  if AStr <> '' then
  begin
    p1:= 1;
    repeat
      p2:= PosStr(ASep, AStr, p1);
      if p2 > 0 then
      begin
        Inc(p2, p1);
        Inc(Result);
        p1:= p2+1;
      end;
    until p2 = 0;
    if Copy(AStr, p1, Length(AStr)) <> '' then Inc(Result);
  end;
end;


function Zeos_InsereAspas(ACampo: string): string;
//******************************************************************
// Se o nome do campo for composto insere aspas no nome.
// Data: 10/07/03
// Autor: Everton Agilar
//******************************************************************
begin
  ACampo:= Trim(ACampo);
  if Pos(' ', ACampo) > 0 then // É composto ?
  begin
    { Insere aspas duplas no nome }
    if ACampo[1] <> '"' then
      ACampo:= '"' + ACampo;
    if ACampo[Length(ACampo)] <> '"' then
      ACampo:= ACampo + '"';
  end
  else
  begin
    { Remove aspas se houver }
    if ACampo[1] = '"' then
      ACampo:= Copy(ACampo,  2, Length(ACampo));
    if ACampo[Length(ACampo)] = '"' then
      ACampo:= Copy(ACampo, 1, Length(ACampo)-1);
  end;
  Result:= ACampo;
end;

function Zeos_RemoveAspas(S: string): string;
//******************************************************************
// Remove aspas simples ou duplas das extremidades de uma string
// Data: 03/09/03
// Autor: Everton Agilar
//******************************************************************
begin
  if S = '' then Exit;
  if (S[1] = '"') or (S[1] = '''') then
    Delete(S, 1, 1);
  if (S[Length(S)] = '"') or (S[Length(S)] = '''') then
    Delete(S, Length(S), MaxInt);
  Result:= S;
end;

function Zeos_InsereAnderline(ACampo: string): string;
//******************************************************************
// Se o nome do campo for composto insere
// um anderline no lugar do espaço.
// Data: 16/07/03
// Autor: Everton Agilar
//******************************************************************
begin
  ACampo:= Trim(ACampo);
  if Pos(' ', ACampo) > 0 then // É composto ?
    ACampo[Pos(' ', ACampo)]:= '_';
  Result:= ACampo;
end;

function Zeos_RemoveZerosEsquerda(const S: string): string;
//******************************************************************
// Remove zeros a esquerda de uma string.
// Ex.: '000789123456' -> '789123456'
// Data: 23/07/04
// Autor: Everton Agilar
//******************************************************************
var
  i: Integer;
begin
  if S <> '' then
  begin
    i:= 1;
    while S[i] = '0' do Inc(i);
    Result:= Copy(S, i, MaxInt);
  end
  else
    Result:= S;
end;

function Zeos_AlinhaStrDireitaComEspacosEsquerda(const S: string;
  ATamStringFinal: Integer): string;
//******************************************************************
// Alinha um string a direita com espaços a esquerda.
// Parâmetros:
//     ATamStringFinal - informa o tamanho para a string.
// Ex.: '789123' com tam. total 13 -> '       789123'
// Data: 23/07/04
// Autor: Everton Agilar
//******************************************************************
begin
  Result:= S;
  Insert(StringOfChar(' ', ATamStringFinal - Length(S)), Result, 1);
end;

function Zeos_AlinhaStrDireitaComZerosEsquerda(const S: string;
  ATamStringFinal: Integer): string;
//******************************************************************
// Alinha um string a direita com zeros a esquerda.
// Parâmetros:
//     ATamStringFinal - informa o tamanho para a string.
// Ex.: '789123' com tam. total 13 -> '0000000789123'
// Data: 10/11/06
//******************************************************************
begin
  Result:= S;
  Insert(StringOfChar('0', ATamStringFinal - Length(S)), Result, 1);
end;

function Zeos_AlinhaStrDireita(const cChar, sTextoAlinh : string; iTamanho: integer) : string;
var
   sNovoTexto : string;
begin
   sNovoTexto := sTextoAlinh;

   while true do
   begin
      if Length(sNovoTexto) >= iTamanho then
         break;
      //endif;

      Insert(cChar, sNovoTexto, 1);
   end;

   result := sNovoTexto;
end;

function Zeos_AlinhaStrEsquerda(const cChar, sTextoAlinh : string; iTamanho: integer) : string;
var
   sNovoTexto : string;
begin
   sNovoTexto := sTextoAlinh;

   while true do
   begin
      if Length(sNovoTexto) >= iTamanho then
         break;
      //endif;

      Insert(cChar, sNovoTexto, length(sNovoTexto) + 1);
   end;

   result := sNovoTexto;
end;

function Zeos_AlinhaStrCentro(const sTextoAlinh : string; iTamanho: integer) : string;
var
   sNovoTexto : string;
   iEspacoEsq : integer;
   iChar : integer;
   sCharEspac : string;
begin
   sNovoTexto := sTextoAlinh;
   iEspacoEsq := (iTamanho - Length(sTextoAlinh)) div 2;
   sCharEspac := ' ';

   for iChar := 1 to iEspacoEsq do
   begin
      Insert(sCharEspac, sNovoTexto, Length(sNovoTexto)+1);
   end;

   for iChar := 1 to iEspacoEsq do
   begin
      Insert(sCharEspac, sNovoTexto, 1);
   end;

   while true do
   begin
      if Length(sNovoTexto) >= iTamanho then
         break;
      //endif;

      Insert(sCharEspac, sNovoTexto, 1);
   end;

   result := sNovoTexto;
end;

function Zeos_ObtemValor(const AStr, AParam: string; ASep: string = ';'): string;
//********************************************************************
// ObtemValor
// Obtem um valor de uma lista de parâmetros separados por ASep.
// Ex.: ObtemValor('PARAM1='XYZ'; PARAM2='ABC'', 'PARAM1') = 'XYZ'
// Autor: Everton de Vargas Agilar
//********************************************************************
var
  p: Integer;
begin
  p:= Pos(AParam, AStr);
  if p > 0 then
  begin
    Result:= Copy(AStr, p + Length(AParam) +1, MaxInt);
    Delete(Result, Pos(ASep, Result), MaxInt);
  end
  else
    Result:= '';
end;

function Zeos_PosStr(const ASubStr, S: string; APosIni: Integer = 1): Integer;
//********************************************************************
// Localiza uma string em outra iniciando a partir de APosIni
// Autor: Everton de Vargas Agilar
//********************************************************************
var
  tmp: string;
begin
  if S <> '' then
  begin
    tmp:= Copy(S, APosIni, MaxInt);
    Result:= Pos(ASubStr, tmp);
  end
  else
    Result:= 0;
end;

function Zeos_CopyStr(const S: string; APosIni, APosFin: Integer): string;
//********************************************************************
// Rotina semelhante a copy exceto que copia entre intervalos.
// Ex.: CopyStr('Borland Delphi', 8, 14) -> 'Delphi'
//      Copy('Borland Delphi', 8, 6) -> 'Delphi'
// Autor: Everton de Vargas Agilar
//********************************************************************
begin
  Result:= Copy(S, APosIni, APosFin - APosIni);
end;

{$WARNINGS OFF}

function Zeos_ForEach(var S: string; out Value: string): Boolean;
begin
  if (S <> '') then
  begin
    Value:= Zeos_ExtraiValorEnum(S, ',');
    Result:= Value <> '';
  end
  else
  begin
    Value:= '';
    Result:= False;
  end;
end;

function Zeos_ForEachLinha(var S: string; out Value: string; AMaxLen: Integer): Boolean;
var
  p: Integer;
begin
  if (S <> '') then
  begin
    p:= Pos(#13, S);
    if p = 0 then
    begin
      if Length(S) <= AMaxLen then
      begin
        Value:= Trim(S);
        S:= '';
        Result:= True;
        Exit;
      end
      else
      begin
         S:= Zeos_QuebraLinha(S, AMaxLen, #13);
         Result:= Zeos_ForEachLinha(S, Value, AMaxLen);
         Exit;
      end;
    end
    else
    begin
      Value:= Trim(Zeos_CopyStr(S, 1, p));
      Delete(S, 1, p);
      Result:= True;
    end;
  end
  else
  begin
    Value:= '';
    Result:= False;
  end;
end;

function Zeos_QuebraLinhaInStringList(const S: string; AMaxLen: Integer): TStringList;
var
  linha: string;
  tmp: string;
begin
  Result:= nil;
  if S <> '' then
  begin
    tmp:= S;
    Result:= TStringList.Create;
    while Zeos_ForEachLinha(tmp, linha, AMaxLen) do
      Result.Add(linha);
  end;
end;

  { Rotinas de criptografia }

function Zeos_Criptografa(const Data, Key: ShortString): ShortString;
var
  i: Integer;
begin
  Result:= '';
  for i:= 1 to Length(Data) do
    Result:= Result + Chr(Ord(Data[i]) + Ord(Key[(i mod Length(Key))+1]));
end;

function Zeos_Decriptografa(const Data, Key: ShortString): ShortString;
var
  i: Integer;
begin
  Result:= '';
  for I:= 1 to Length(Data) do
    Result:= Result + Chr(Ord(Data[i]) - Ord(Key[(i mod Length(Key))+1]));
end;

  { Rotinas de manipulação de strings }

function Zeos_ExtraiNumero(const S: string): string;
//******************************************************************
// Extrai o número contido em uma string.
// Ex.: '1.357,24' -> '135724'
// Data: 23/07/04
// Autor: Everton Agilar
//******************************************************************
var
  i: Integer;
begin
  Result:= '';
  for i:= 1 to Length(S) do
    if S[i] in ['0'..'9'] then
      Result:= Result + S[i];
end;

function Zeos_ExtraiStringSemCaracteresControle(const S: string): string;
var
  i: Integer;
begin
  Result:= '';
  for i:= 1 to Length(S) do
    if Ord(S[i]) >= 32 then
      Result:= Result + S[i];
end;

function Zeos_RemoveEspacos(const S: string): string;
var
  i: Integer;
begin
  Result:= '';
  for i:= 1 to Length(S) do
    if S[i] <> ' ' then
      Result:= Result + S[i];
end;

function Zeos_RemoveEspacosDesnecessarios(const S: string): string;
//******************************************************************
// Remove os espaços desnecessários da string.
// Data: 01/08/03
// Autor: Everton Agilar
//******************************************************************
var
  i: Integer;
begin
  Result:= '';
  for i:= 1 to Length(S) do
  begin
    if (S[i] <> ' ') or
    ((i < Length(S)) and (S[i] = ' ') and (S[i+1] <> ' ')) then
       Result:= Result + S[i];
  end;
end;

function Zeos_RemoveShortCut(const S: string): string;
var
  i: Integer;
begin
  Result:= '';
  for i:= 1 to Length(S) do
    if S[i] <> '&' then
      Result:= Result + S[i];
end;

function Zeos_RemoveAspasAoRedor(const S: string;
  const AAspa: Char = '"'): string;
//********************************************************************
// Remove as aspas ao redor da string.
// Ex.: "Polidados" retorna Polidados
// Autor: Everton de Vargas Agilar
//********************************************************************
var
  p1, p2: Integer;
begin
  if S <> '' then
  begin
    { Obtém o intervalo de cópia da string }
    if S[1] = AAspa then
      p1:= 2 else p1:= 1;
    if S[Length(S)] = AAspa then
      p2:= Length(S)-2 else p2:= MaxInt;

    { Copia a string }
    Result:= Copy(S, p1, p2);
  end
  else
    Result:= '';
end;

procedure Zeos_RemoveColchetes(var S: string);
begin
  if (S[1] = '[') and (S[Length(S)] = ']') then
    S:= Copy(S, 2, Length(S) - 2);
end;

function Zeos_IsDigito(const S: string): Boolean;
var
  i: Integer;
  tmp: string;
begin
  tmp:= Trim(S);
  Result:= True;
  for i:= 1 to Length(tmp) do
  begin
    if not (tmp[i] in ['0'..'9']) then
    begin
      Result:= False;
      Break;
    end;
  end;
end;

 { Rotinas de data e hora }

function Zeos_IsDataHora(const S: string): Boolean;
begin
  try
    // Data válida: 10/11/2008 ou 10/11/08
    if (Length(S) in [10, 8]) and (S[3] = '/') and (S[6] = '/') and
      Zeos_IsDigito(Copy(S, 1, 2)) and Zeos_IsDigito(Copy(S, 4, 2)) and Zeos_IsDigito(Copy(S, 7, 4)) then
    begin
      StrToDate(S);
      Result:= True;
    end
    else
      Result:= False;
  except
    Result:= False;
  end;
end;

function Zeos_IsDateTime(const S: string): Boolean;
begin
  try
    // Data válida: 10/11/2008 ou 10/11/08
    if (Length(S) in [10, 8]) and (S[3] = '/') and (S[6] = '/') and
      Zeos_IsDigito(Copy(S, 1, 2)) and Zeos_IsDigito(Copy(S, 4, 2)) and Zeos_IsDigito(Copy(S, 7, 4)) then
    begin
      StrToDate(S);
      Result:= True;
    end
    else
      Result:= False;
  except
    Result:= False;
  end;
end;

function Zeos_IsHora(const S: string): Boolean;
begin
  try
    // Hora válida: 24:00
    if Length(S) = 5 then
    begin
      StrToTime(S);
      Result:= True;
    end
    else
      Result:= False;
  except
    Result:= False;
  end;
end;

function Zeos_UltimoDiaMes(const AData: TDateTime): TDateTime;
//******************************************************
// Retorna o último dia do mês de uma data
// Autor: Everton de Vargas Agilar
// Data: 19/01/2004
//******************************************************
var
  ano, mes, dia : word;
  mDtTemp : TDateTime;
begin
  Decodedate(AData, ano, mes, dia);
   mDtTemp := (AData - dia) + 33;
  Decodedate(mDtTemp, ano, mes, dia);
  Result := mDtTemp - dia;
end;

function Zeos_PrimeiroDiaMes(const AData: TDateTime): TDateTime;
var
  nAno, nMes, nDia : word;
begin
  Decodedate(AData, nAno, nMes, nDia);
  Result := EncodeDate(nAno, nMes, 01);
end;

function Zeos_Dia(AData: TDateTime): Word;
var
  nDia, nMes, nAno: Word;
begin
  DecodeDate(AData, nAno, nMes, nDia);
  Result:= nDia;
end;

function Zeos_Mes(AData: TDateTime): Word;
var
  nDia, nMes, nAno: Word;
begin
  DecodeDate(AData, nAno, nMes, nDia);
  Result:= nMes;
end;

function Zeos_Ano(const AData: TDateTime): Word;
var
  nDia, nMes, nAno: Word;
begin
  DecodeDate(AData, nAno, nMes, nDia);
  Result:= nAno;
end;

function Zeos_StrToDateTimeStamp(const S: string): TTimeStamp;
var
  Data: TDateTime;
begin
  Data:= StrToDateTime(S);
  Data:= StrToDateTime(FormatDateTime('mm/dd/yyyy hh:mm', Data));
  Result:= DateTimeToTimeStamp(Data);
end;

function Zeos_StrToDateStamp(const S: string): TTimeStamp;
var
  Data: TDateTime;
begin
  Data:= StrToDate(S);
  Data:= StrToDate(FormatDateTime('mm/dd/yyyy', Data));
  Result:= DateTimeToTimeStamp(Data);
end;

function Zeos_DateTimeToStrDateTimeStamp(const Data: TDateTime): string;
begin
  Result:= FormatDateTime('mm/dd/yyyy hh:mm', Data);
end;

function Zeos_DateToStrDateStamp(const Data: TDateTime): string;
begin
  Result:= FormatDateTime('mm/dd/yyyy', Data);
end;

function Zeos_DateStrToStrDateStamp(const S: string): string;
begin
  try
    Result:= FormatDateTime('mm/dd/yyyy', StrToDate(S));
  except
    Result:= '';
  end;
end;

function Zeos_DataProximoMes(const AData: TDateTime): TDateTime;
//******************************************************
// Retorna a data do próximo mês de AData
// Autor: Everton de Vargas Agilar
// Data: 19/01/2004
//******************************************************
var
  nUltDiaMes: Word;
begin
  nUltDiaMes:= Zeos_Dia(Zeos_UltimoDiaMes(AData));
  Result:= AData + nUltDiaMes;
end;

function Zeos_AnoAtual: Word;
//******************************************************
// Retorna o ano atual
// Autor: Everton de Vargas Agilar
// Data: 19/01/2004
//******************************************************
var nAno, nMes, nDia: Word;
begin
  DecodeDate(Date, nAno, nMes, nDia);
  result:= nAno;
end;

function Zeos_MesAtual: Word;
//******************************************************
// Retorna o ano atual
// Autor: Everton de Vargas Agilar
// Data: 19/01/2004
//******************************************************
var nAno, nMes, nDia: Word;
begin
  DecodeDate(Date, nAno, nMes, nDia);
  result:= nMes;
end;

function Zeos_DiaAtual: Word;
//******************************************************
// Retorna o ano atual
// Autor: Everton de Vargas Agilar
// Data: 19/01/2004
//******************************************************
var nAno, nMes, nDia: Word;
begin
  DecodeDate(Date, nAno, nMes, nDia);
  result:= nDia;
end;

function Zeos_GetdayOfWeek(const Data: TDateTime): string;
begin
  case DayOfWeek(Data) of
    1: Result:= 'Domingo';
    2: Result:= 'Segunda-Feira';
    3: Result:= 'Terça-Feira';
    4: Result:= 'Quarta-Feira';
    5: Result:= 'Quinta-Feira';
    6: Result:= 'Sexta-Feira';
    7: Result:= 'Sábado';
  end;
end;

function Zeos_GetMes(const Data: TDateTime): string;
begin
  case MonthOf(Data) of
     1: Result:= 'Janeiro';
     2: Result:= 'Fevereiro';
     3: Result:= 'Março';
     4: Result:= 'Abril';
     5: Result:= 'Maio';
     6: Result:= 'Junho';
     7: Result:= 'Julho';
     8: Result:= 'Agosto';
     9: Result:= 'Setembro';
    10: Result:= 'Outubro';
    11: Result:= 'Novembro';
    12: Result:= 'Dezembro';
  end;
end;

{ Rotinas para arquivos }

function Zeos_IncluiContraBarraNomeArq(ANomeArq: string): string;
begin
  ANomeArq:= Zeos_RemoveContraBarraNomeArq(ANomeArq);
  if ANomeArq <> '' then
  begin
    if Pos('/', ANomeArq) > 0 then
      ANomeArq:= ANomeArq + '/'
    else
      ANomeArq:= ANomeArq + '\';
  end;
  Result:= ANomeArq;
end;

function Zeos_GetTempNomeArq: string;
var
  Nome, Dir : array[0..255] of Char;
begin
  Windows.GetTempPath(SizeOf(Dir), Dir);
  GetTempFileName(Dir, PChar('ZRP'), 0, Nome);
  Result := StrPas(Nome);
end;

function Zeos_GetWindowTemp: string;
begin
  SetLength(Result, 255);
  Windows.GetTempPath(Length(Result), PChar(Result));
  Result:= StrPas(PChar(Result));
end;

function Zeos_GetTempPath: string;
begin
  Result:= Zeos_GetWindowTemp;
  Result:= ExcludeTrailingBackslash(Result);
end;

function Zeos_GetWindowPath: string;
begin
  SetLength(Result, 255);
  GetWindowsDirectory(PChar(Result), 255);
  Result:= StrPas(PChar(Result));
end;

function Zeos_GetSystemPath: string;
begin
  Result:= Zeos_GetWindowPath + '\System32';
end;

function Zeos_GetPastaCorrente: string;
begin
  SetLength(Result, 255);
  GetCurrentDirectory(255, PChar(Result));
  Result:= StrPas(PChar(Result));
end;

function Zeos_GetProgramFilePath: string;
var
  Reg: TRegistry;
begin
  Reg:= TRegistry.Create;
  try
    Reg.RootKey:= HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion', False) then
    begin
      if Reg.ValueExists('ProgramFilesDir') then
        Result:= Reg.ReadString('ProgramFilesDir')
      else
        Result:= 'C:\Arquivos de Programas';
    end;
  finally
    Reg.Free;
  end;
end;

function Zeos_ExistePasta(const APath: string): Boolean;
begin
  Result:= DirectoryExists(APath);
end;

function Zeos_CheckPermissaoLeituraEscrita(APasta: string): Boolean;
var
  NomeArq: string;
  Arq: TextFile;
begin
  Zeos_RemoveContraBarraNomeArq(APasta);
  NomeArq:= APasta + '\xacesso.tmp';
  AssignFile(Arq, NomeArq);
  try
    Rewrite(Arq);
    CloseFile(Arq);
    DeleteFile(NomeArq);
    Result:= True;
  except
    Result:= False;
  end;
end;

function Zeos_Touch(const AFileName: string): Boolean;
var
  hFile: Integer;
begin
  try
    hFile:= FileCreate(AFileName);
    if hFile > 0 then
    begin
      FileClose(hFile);
      Result:= True;
    end
    else
      Result:= False;
  except
    Result:= False;
  end;
end;

function Zeos_RemoveAcentos(const ATexto: string): string;
//**************************************************************
// Retorna ATexto sem os acentos.
// Autor: Everton de Vargas Agilar
// Data: 05/04/2004
//**************************************************************
var i, j: integer;
 NewString, aLetra: string;
 cAcento: array[0..42] of string;
 osASC: array[0..42] of string;
begin
 cAcento[0] := 'á'; osASC[0] := 'a'; // #160;
 cAcento[1] := 'Á'; osASC[1] := 'A'; // #181;
 cAcento[2] := 'ã'; osASC[2] := 'a'; // #198;
 cAcento[3] := 'Ã'; osASC[3] := 'A'; // #199;
 cAcento[4] := 'â'; osASC[4] := 'a'; // #131;
 cAcento[5] := 'Â'; osASC[5] := 'A'; // #182;
 cAcento[6] := 'ä'; osASC[6] := 'a'; // #132;
 cAcento[7] := 'Ä'; osASC[7] := 'A'; // #142;
 cAcento[8] := 'à'; osASC[8] := 'a'; // #133;
 cAcento[9] := 'À'; osASC[9] := 'A'; // #183;

 cAcento[10] := 'é'; osASC[10] := 'e'; // #130;
 cAcento[11] := 'É'; osASC[11] := 'E'; // #144;
 cAcento[12] := 'ê'; osASC[12] := 'e'; // #136;
 cAcento[13] := 'Ê'; osASC[13] := 'E'; // #210;
 cAcento[14] := 'ë'; osASC[14] := 'e'; // #137;
 cAcento[15] := 'Ë'; osASC[15] := 'E'; // #211;

 cAcento[16] := 'í'; osASC[16] := 'i'; // #161;
 cAcento[17] := 'Í'; osASC[17] := 'I'; // #214;
 cAcento[18] := 'î'; osASC[18] := 'i'; // #140;
 cAcento[19] := 'Î'; osASC[19] := 'I'; // #215;
 cAcento[20] := 'ï'; osASC[20] := 'i'; // #139;
 cAcento[21] := 'Ï'; osASC[21] := 'I'; // #216;

 cAcento[22] := 'ó'; osASC[22] := 'o'; // #162;
 cAcento[23] := 'Ó'; osASC[23] := 'O'; // #224;
 cAcento[24] := 'õ'; osASC[24] := 'o'; // #228;
 cAcento[25] := 'Õ'; osASC[25] := 'O'; // #229;
 cAcento[26] := 'ô'; osASC[26] := 'o'; // #147;
 cAcento[27] := 'Ô'; osASC[27] := 'O'; // #226;
 cAcento[28] := 'ö'; osASC[28] := 'o'; // #148;
 cAcento[29] := 'Ö'; osASC[29] := 'O'; // #153;

 cAcento[30] := 'ú'; osASC[30] := 'u'; // #163;
 cAcento[31] := 'Ú'; osASC[31] := 'U'; // #233;
 cAcento[32] := 'û'; osASC[32] := 'u'; // #150;
 cAcento[33] := 'Û'; osASC[33] := 'U'; // #234;
 cAcento[34] := 'ü'; osASC[34] := 'u'; // #129;
 cAcento[35] := 'Ü'; osASC[35] := 'U'; // #154;

 cAcento[36] := 'ç'; osASC[36] := 'c'; // #135;
 cAcento[37] := 'Ç'; osASC[37] := 'C'; // #128;

 cAcento[38] := 'º'; osASC[38] := 'º';   //#248;
 cAcento[39] := 'ñ'; osASC[39] := 'n';   //#164;
 cAcento[40] := 'Ñ'; osASC[40] := 'N';   //#165;
 cAcento[41] := 'ª'; osASC[41] := 'ª';   //#166;
 cAcento[42] := 'º'; osASC[42] := 'º';   //#167;

 NewString := '';
 for i := 1 to Length(ATexto) do
 begin
  aLetra := Copy(ATexto, i, 1);
  j := 0;
  while j <= High(cAcento) do
  begin
   if aLetra = cAcento[j] then
   begin
    aLetra := osAsc[j];
    break;
   end;
   Inc(j);
  end;
  NewString := NewString + aLetra;
 end;
 result := NewString;
end;

function Zeos_RemoveAcentosDOS(const ATexto: string): string;
const
              {'áéíóúÁÉÍÓÚâêôÂÊÔãõñÃÕÑäöüÄÖÜàÀçÇªº²'îÎûÛëËïÏèÈìÌòÒùÙ}
   ComAcento = ' ‚¡¢£µÖàéƒˆ“¶ÒâÆä¤Çå¥„”Ž™š…·‡€¦§ýŒ×–ê‰‹ØŠÔÞ•ã—ëàâêôûãõáéíóúçüÀÂÊÔÛÃÕÁÉÍÓÚÇÜºª°€';
   SemAcento = 'aeiouAEIOUaeoAEOaonAONaouAOUaAcC...iIuUeEiIeEiIoOuUaaeouaoaeioucuAAEOUAOAEIOUCU...C.';
var
  i, p: Integer;
Begin
  Result:= ATexto;
  for i:= 1 to Length(ATexto) do
  begin
    p:= Pos(ATexto[i], ComAcento);
    if p <> 0 then
      Result[i]:= SemAcento[p];
  end;
end;

function Zeos_GetPathNameSuperior(APathName: string): string;
//***************************************************************
// Retorna PathName superior ao caminho passado ou
// o caminho total se não existir um caminho superior.
// Ex.: "c:\windows\system" -> retorna windows
//***************************************************************
var
  i: Integer;
begin
  if APathName <> '' then
  begin
    { Remove a contra-barra no final se existir }
    Zeos_RemoveContraBarraNomeArq(APathName);
    { Tenta localizar próxima contra-barra }
    for i:= Length(APathName) downto 1 do
    begin
      { Se encontrar a contra-barra retorna APathName até i-1 }
      if APathName[i] = '\' then
      begin
        Result:= Copy(APathName, 1, i-1);
        Exit;
      end;
    end;
  end;
  { Se não encontrou nenhuma contra-barra apenas retorna APathName }
  Result:= APathName;
end;

function Zeos_GetUltPathName(APathName: string): string;
//***************************************************************
// Retorna último caminho de APathName
// Ex.: "c:\windows\system" -> retorna system
//***************************************************************
var
  i: Integer;
begin
  if APathName <> '' then
  begin
    { Remove a contra-barra no final se existir }
    Zeos_RemoveContraBarraNomeArq(APathName);
    { Tenta localizar próxima contra-barra }
    for i:= Length(APathName) downto 1 do
    begin
      { Se encontrar a contra-barra retorna APathName }
      if APathName[i] = '\' then
      begin
        Result:= Copy(APathName, i+1, MaxInt);
        Exit;
      end;
    end;
  end;
  { Se não encontrou nenhuma contra-barra apenas retorna APathName }
  Result:= APathName;
end;

function Zeos_GetTamArqEmBytes(const FileName: string): LongInt;
//***************************************************************
// Retorna o tamanho do arquivo em bytes
// Autor: Everton de Vargas Agilar
//***************************************************************
var
  F: file of Byte;
begin
  try
    AssignFile(F, FileName);
    FileMode:= fmOpenRead;
    Reset(F);
    try
      Result:= FileSize(F);
    finally
      CloseFile(F);
    end;
  except
    Result:= 0;
  end;
end;

function Zeos_GetTamArqEmKBytes(const FileName: string): LongInt;
//***************************************************************
// Retorna o tamanho do arquivo em kilobytes
// Autor: Everton de Vargas Agilar
//***************************************************************
begin
  Result:= Zeos_GetTamArqEmBytes(FileName);
  if Result > 1024 then
    Result:= Round(Result / 1024)
  else
    Result:= 1;
end;

function Zeos_GetTamArquivo(const FileName: string): string;
var
  TamKbytes: Longint;
begin
  TamKbytes:= Zeos_GetTamArqEmBytes(FileName);
  if TamKbytes > 1024 then
  begin
    TamKbytes:= Round(TamKbytes / 1024);
    if TamKbytes > 1024 then
      Result:= IntToStr(TamKbytes) + ' MB'
    else
      Result:= IntToStr(TamKbytes) + ' KB';
  end
  else
    Result:= '1 KB';
end;

function Zeos_GetDesktopPath : string;
var
  shellMalloc: IMalloc;
  ppidl: PItemIdList;
begin
  ppidl := nil;
  try
    if SHGetMalloc(shellMalloc) = NOERROR then
    begin
      SHGetSpecialFolderLocation(Application.Handle, CSIDL_DESKTOP, ppidl);
      SetLength(Result, MAX_PATH);
      if not SHGetPathFromIDList(ppidl, PChar(Result)) then
        raise exception.create('SHGetPathFromIDList failed : invalid pidl');
      SetLength(Result, lStrLen(PChar(Result)));
    end;
  finally
   if ppidl <> nil then
         shellMalloc.free(ppidl);
  end;
end;

function Zeos_GetMenuIniciarPath: string;
var
  shellMalloc: IMalloc;
  ppidl: PItemIdList;
begin
  ppidl := nil;
  try
    if SHGetMalloc(shellMalloc) = NOERROR then
    begin
      SHGetSpecialFolderLocation(Application.Handle, CSIDL_STARTMENU, ppidl);
      SetLength(Result, MAX_PATH);
      if not SHGetPathFromIDList(ppidl, PChar(Result)) then
        raise exception.create('SHGetPathFromIDList failed : invalid pidl');
      SetLength(Result, lStrLen(PChar(Result)));
    end;
  finally
   if ppidl <> nil then
         shellMalloc.free(ppidl);
  end;
end;

function Zeos_ExisteChaveReg(const AKey: string; ARootKey: HKEY): Boolean;
var
  Reg: TRegistry;
begin
  Reg:= TRegistry.Create(KEY_READ);
  try
    Reg.RootKey:= ARootKey;
    Result:= Reg.KeyExists(AKey);
  finally
    Reg.Free;
  end;
end;


function Zeos_IsValidIP(const S: string): Boolean;
var
  Strings: TStringList;
begin
  Result := false;
  Strings := TStringList.Create;
  Strings.Delimiter := '.';
  Strings.DelimitedText := S;
  if Strings.Count <> 4 then exit;
  repeat
    Result := (StrToIntDef(Strings[0], -1) in [0..255]);
    Strings.Delete(0);
  until (Strings.Count = 0) or not Result;
  Strings.Free;
end;

function Zeos_TemInternet: Boolean;
const
  Key = '\System\CurrentControlSet\Services\RemoteAccess';
  Value = 'Remote Connection';
var
  Reg: TRegistry;
  Buffer: DWord;
begin
  Result := false;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(Key, false) then
    begin
      Reg.ReadBinaryData(Value, Buffer, SizeOf(Buffer));
      Result := Buffer = 1;
    end;
    Reg.CloseKey;
  finally
    Reg.Free;
  end;
end;

function Zeos_GetUsuarioLocal: string;
var
  UserName: PChar;
  lpLength: Cardinal;
begin
  GetMem(UserName, 100);
  try
    lpLength:= 100;
    WNetGetUser(nil, UserName, lpLength);
    Result:= StrPas(UserName);
  finally
    FreeMem(UserName, 250);
  end;
end;

procedure Zeos_CapturarDesktop(const ADestino: TBitmap);
var
  c: TCanvas;
  r: TRect;
begin
  c := TCanvas.Create;
  c.Handle := GetWindowDC(GetDesktopWindow);
  try
    r := Rect(0, 0, Screen.Width, Screen.Height);
    ADestino.Width := Screen.Width;
    ADestino.Height := Screen.Height;
    ADestino.Canvas.CopyRect(r, c, r);
  finally
    ReleaseDC(0, c.Handle);
    c.Free;
  end;
end;

function Zeos_GetWindowsVersion: string;
var
  VerInfo: TOsversionInfo;
  PlatformId, VersionNumber: string;
  Reg: TRegistry;
begin
  VerInfo.dwOSVersionInfoSize := SizeOf(VerInfo);
  GetVersionEx(VerInfo);
  // Detect platform
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  case VerInfo.dwPlatformId of
    VER_PLATFORM_WIN32s:
      begin
        // Registry (Huh? What registry?)
        PlatformId := 'Windows 3.1';
      end;
    VER_PLATFORM_WIN32_WINDOWS:
      begin
        // Registry
        Reg.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion', False);
        PlatformId    := Reg.ReadString('ProductName');
        VersionNumber := Reg.ReadString('VersionNumber');
      end;
    VER_PLATFORM_WIN32_NT:
      begin
        // Registry
        Reg.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion', False);
        PlatformId    := Reg.ReadString('ProductName');
        VersionNumber := Reg.ReadString('CurrentVersion');
      end;
  end;
  Reg.Free;
  Result := PlatformId + ' (version ' + VersionNumber + ')';
end;

procedure Zeos_CreateStringFile(const AFileName, ATexto: string);
var
  Arq: TStringList;
begin
  try
    Arq:= TStringList.Create;
    try
      Arq.Text:= ATexto;
      Arq.SaveToFile(AFileName);
    finally
      Arq.Free;
    end;
  except
    raise Exception.Create('Erro ao salvar arquivo '+ AFileName);
  end;
end;


{ Rotinas para formatação e validação de CNPF, CPFs, etc }

function Zeos_FormataCNPJ(CNPJ: string): string;
begin
  if CNPJ <> '' then
  begin
    CNPJ:= Zeos_ExtraiNumero(CNPJ);
    Result :=Copy(CNPJ,1,2)+'.'+ Copy(CNPJ,3,3)+'.'+ Copy(CNPJ,6,3)+'/'+
      Copy(CNPJ,9,4)+'-'+Copy(CNPJ,13,2);
  end
  else
    Result:= '';
end;

function Zeos_ValidaCPF(const CPF: string): Boolean;
const
  CPFInvalido: array[0..9] of string = ('00000000000', '11111111111', '22222222222', '33333333333', '44444444444', '55555555555', '66666666666', '77777777777', '88888888888', '99999999999');
var
   n1,n2,n3,n4,n5,n6,n7,n8,n9: integer;
   d1,d2: integer;
   digitado, calculado: string;
   i: Integer;
begin
  try
     Result:= False;
     for i:= 0 to 9 do
       if CPF = CPFInvalido[i] then Exit;
     if CPF <> '' then
     begin
       n1:=StrToInt(CPF[1]);
       n2:=StrToInt(CPF[2]);
       n3:=StrToInt(CPF[3]);
       n4:=StrToInt(CPF[4]);
       n5:=StrToInt(CPF[5]);
       n6:=StrToInt(CPF[6]);
       n7:=StrToInt(CPF[7]);
       n8:=StrToInt(CPF[8]);
       n9:=StrToInt(CPF[9]);
       d1:=n9*2+n8*3+n7*4+n6*5+n5*6+n4*7+n3*8+n2*9+n1*10;
       d1:=11-(d1 mod 11);
       if d1>=10 then
          d1:=0;
          d2:=d1*2+n9*3+n8*4+n7*5+n6*6+n5*7+n4*8+n3*9+n2*10+n1*11;
          d2:=11-(d2 mod 11);
          if d2>=10 then
             d2:=0;
             calculado:=inttostr(d1)+inttostr(d2);
             digitado:=CPF[10]+CPF[11];
             if calculado=digitado then
                      Result:=true
                else
                      Result:=false;
     end;
  except
    Result:= False;
  end;
end;

function Zeos_ValidaCNPJ(const CNPJ: string): Boolean;
var
  d1,d4,xx,nCount,fator,resto,digito1,digito2 : Integer;
   Check : String;
begin
  try
    Result:= False;
    if CNPJ = '00000000000000' then Exit;
    d1 := 0;
    d4 := 0;
    xx := 1;
    for nCount := 1 to Length( CNPJ )-2 do
        begin
        if Pos( Copy( CNPJ, nCount, 1 ), '/-.' ) = 0 then
        begin
        if xx < 5 then
        begin
        fator := 6 - xx;
        end
        else
       begin
       fator := 14 - xx;
       end;
       d1 := d1 + StrToInt( Copy( CNPJ, nCount, 1 ) ) * fator;
       if xx < 6 then
        begin
        fator := 7 - xx;
       end
       else
       begin
       fator := 15 - xx;    end;
       d4 := d4 + StrToInt( Copy( CNPJ, nCount, 1 ) ) * fator;
       xx := xx+1;
       end;
       end;
       resto := (d1 mod 11);
       if resto < 2 then
       begin
       digito1 := 0;
       end
       else
       begin
       digito1 := 11 - resto;
       end;
       d4 := d4 + 2 * digito1;
       resto := (d4 mod 11);
       if resto < 2 then
        begin
        digito2 := 0;
       end
       else
        begin
        digito2 := 11 - resto;
       end;
        Check := IntToStr(Digito1) + IntToStr(Digito2);
       if Check <> copy(CNPJ,succ(length(CNPJ)-2),2) then
        begin
        Result := False;
       end
       else
        begin
        Result := True;
       end;
  except
    Result:= False;
  end;
end;

function Zeos_ValidaCPFCNPJ(const CPFCNPJ:string): boolean;
var
  str: string;
begin
  str:= Zeos_ExtraiNumero(CPFCNPJ);
  if Length(str) = 11 then
    Result:= Zeos_ValidaCPF(str)
  else if Length(str) > 11 then
    Result:= Zeos_ValidaCNPJ(str)
  else
    Result:= False;
end;

function Zeos_IsCNPJ(const ACPFCNPJ: string): Boolean;
var
  str: string;
begin
  str:= Zeos_ExtraiNumero(ACPFCNPJ);
  if (Length(str) > 11) and Zeos_ValidaCNPJ(str) then
    Result:= True
  else
    Result:= False;
end;

function Zeos_FormataCPF(CPF: string): string;
begin
  if CPF <> '' then
  begin
    CPF:= Zeos_ExtraiNumero(CPF);
    Result := Copy(CPF,1,3)+'.'+Copy(CPF,4,3)+'.'+
      Copy(CPF,7,3)+'-'+Copy(CPF,10,2);
  end
  else
    Result:= '';
end;

function Zeos_FormataCPF_CNPJ(const CPFCNPJ: string): string;
var
  str: string;
begin
  str:= Zeos_ExtraiNumero(CPFCNPJ);
  if Length(str) = 11 then
    Result:= Zeos_FormataCPF(str)
  else if Length(str) > 11 then
    Result:= Zeos_FormataCNPJ(str)
  else
    Result:= CPFCNPJ;
end;

function Zeos_ValidaCEP(const CEP, UF: string): Boolean;
var
  cCep: string;
  cCEP1 : Integer;
begin
  try
     { Obtém o número do cep sem o digito verificador }
     if Pos('-', CEP) > 0 then
       cCep := copy(CEP,1,5) + copy(CEP,7,3)
     else
       cCep:= CEP;

     cCEP1 := StrToInt(copy(cCep,1,3));
     if Length(trim(cCep)) > 0 then
     begin
      if (StrToInt(cCep) <= 1000000.0) then
        Result := False
      else
      begin
        if Length(trim(copy(cCep,6,3))) < 3 then
          Result := False
        else
        begin
          if (UF = 'SP') and (cCEP1 >= 10 ) and (cCEP1 <= 199) then Result := True else
          if (UF = 'RJ') and (cCEP1 >= 200) and (cCEP1 <= 289) then Result := True else
          if (UF = 'ES') and (cCEP1 >= 290) and (cCEP1 <= 299) then Result := True else
          if (UF = 'MG') and (cCEP1 >= 300) and (cCEP1 <= 399) then Result := True else
          if (UF = 'BA') and (cCEP1 >= 400) and (cCEP1 <= 489) then Result := True else
          if (UF = 'SE') and (cCEP1 >= 490) and (cCEP1 <= 499) then Result := True else
          if (UF = 'PE') and (cCEP1 >= 500) and (cCEP1 <= 569) then Result := True else
          if (UF = 'AL') and (cCEP1 >= 570) and (cCEP1 <= 579) then Result := True else
          if (UF = 'PB') and (cCEP1 >= 580) and (cCEP1 <= 589) then Result := True else
          if (UF = 'RN') and (cCEP1 >= 590) and (cCEP1 <= 599) then Result := True else
          if (UF = 'CE') and (cCEP1 >= 600) and (cCEP1 <= 639) then Result := True else
          if (UF = 'PI') and (cCEP1 >= 640) and (cCEP1 <= 649) then Result := True else
          if (UF = 'MA') and (cCEP1 >= 650) and (cCEP1 <= 659) then Result := True else
          if (UF = 'PA') and (cCEP1 >= 660) and (cCEP1 <= 688) then Result := True else
          if (UF = 'AM') and ((cCEP1 >= 690) and (cCEP1 <= 692) or (cCEP1 >= 694) and

          (cCEP1 <= 698)) then Result := True else
          if (UF = 'AP') and (cCEP1 = 689) then Result := True else
          if (UF = 'RR') and (cCEP1 = 693) then Result := True else
          if (UF = 'AC') and (cCEP1 = 699) then Result := True else
          if ((UF = 'DF') or (UF = 'GO')) and (cCEP1 >= 000)and(cCEP1 <= 999)then

          Result := True else
          if (UF = 'TO') and (cCEP1 >= 770) and (cCEP1 <= 779) then Result := True else
          if (UF = 'MT') and (cCEP1 >= 780) and (cCEP1 <= 788) then Result := True else
          if (UF = 'MS') and (cCEP1 >= 790) and (cCEP1 <= 799) then Result := True else
          if (UF = 'RO') and (cCEP1 = 789) then Result := True else
          if (UF = 'PR') and (cCEP1 >= 800) and (cCEP1 <= 879) then Result := True else
          if (UF = 'SC') and (cCEP1 >= 880) and (cCEP1 <= 899) then Result := True else
          if (UF = 'RS') and (cCEP1 >= 900) and (cCEP1 <= 999) then Result := True else

          Result := False
        end;
      end;
     end
     else
     begin
      Result := True;
     end
  except
    Result:= False;
  end;
end;

  { Rotinas para impressão }

function Zeos_IsPrinter(APorta: Word = 0) : Boolean;
//******************************************************************
// Retorna um valor booleano indicando se uma impressora esta pronta
// Autor: Everton Agilar
//******************************************************************
const
  PrnStInt  : Byte = $17;
  StRq      : Byte = $02;
//  PrnNum    : Word = 0;  { 0 para LPT1, 1 para LPT2, etc. }
var
  nResult : byte;
begin
  asm
    mov ah,StRq;
    mov dx, APorta;
    Int $17;
    mov nResult,ah;
  end;
  Result := (nResult and $80) = $80;
end;

function Zeos_ResetaImpressoraMatricial: Boolean;
const
    {Sequencia de escape para maioria das Impressoras Matriciais Epson}
    cReset = #27#64#18#27#120#48;
var
    F: TextFile;
begin
  try
    AssignFile(F, 'LPT1');
    Rewrite(F);
    try
      WriteLn(F, cReset);
    finally
      CloseFile(F);
    end;
    Result:=True;
  except
    Result:= False;
  end;
end;

  { Diversos }

function Zeos_JanelaExiste(const Classe,Janela: string) : Boolean;
//******************************************************************
// Retorna um valor booleano indicando se uma janela existe
// Autor: Everton Agilar
//******************************************************************
var
  PClasse,PJanela : array[0..79] of char;
begin
  if Classe = '' then
    PClasse[0] := #0
  else
    StrPCopy(PClasse,Classe);
  if Janela = '' then
    PJanela[0] := #0
  else
    StrPCopy(PJanela,Janela);

  if FindWindow(PClasse,PJAnela) <> 0 then
    Result := True
  else
    Result := false;
end;

function Zeos_DelphiAberto: Boolean;
//******************************************************************
// Retorna um valor booleano indicando se o Delphi esta aberto.
// Autor: Everton Agilar
//******************************************************************
begin
  Result := Zeos_JanelaExiste('TPropertyInspector','Object Inspector');
end;

function Zeos_ValidaCFOP(ACFOP: Integer): Boolean;
begin
  Result:= False;
  case ACFOP of
    1101,
    1102,
    1111,
    1113,
    1116,
    1117,
    1118,
    1120,
    1121,
    1122,
    1124,
    1125,
    1126,
    1151,
    1152,
    1153,
    1154,
    1201,  
    1202,  
    1203,  
    1204,
    1205,  
    1206,  
    1207,  
    1208,  
    1209,  
    1251,  
    1252,  
    1253,  
    1254,
    1255,  
    1256,  
    1257,
    1301,  
    1302,
    1303,  
    1304,  
    1305,
    1306,
    1351,  
    1352,  
    1353,  
    1354,
    1355,  
    1356,  
    1360, 
    1401,
    1403,
    1406,  
    1407,  
    1408,  
    1409,
    1410,  
    1411,  
    1414,  
    1415,  
    1451,  
    1452,  
    1501,  
    1503,
    1504,
    1505,  
    1506,
    1551,  
    1552,
    1553,
    1554,  
    1555,
    1556,  
    1557,  
    1601,  
    1602,  
    1603,  
    1604,
    1605,  
    1651,  
    1652,  
    1653,  
    1658, 
    1659,
    1660,
    1661,
    1662,
    1663,  
    1664,  
    1901,  
    1902,
    1903,  
    1904,  
    1905,  
    1906,  
    1907,  
    1908,  
    1909,  
    1910,  
    1911,
    1912,  
    1913,  
    1914,
    1915,  
    1916,
    1917,  
    1918,  
    1919,
    1920,
    1921,  
    1922,  
    1923,  
    1924,
    1925,  
    1926,  
    1931, 
    1932,
    1933,
    1949,  
    2101,  
    2102,  
    2111,
    2113,  
    2116,  
    2117,  
    2118,  
    2120,  
    2121,  
    2122,  
    2124,
    2125,
    2126,  
    2151,
    2152,  
    2153,
    2154,
    2201,  
    2202,
    2203,  
    2204,  
    2205,  
    2206,  
    2207,  
    2208,
    2209,  
    2251,  
    2252,  
    2253,  
    2254, 
    2255,
    2256,
    2257,
    2301,
    2302,  
    2303,  
    2304,  
    2305,
    2306,  
    2351,  
    2352,  
    2353,  
    2354,  
    2355,  
    2356,  
    2401,  
    2403,
    2406,  
    2407,  
    2408,
    2409,  
    2410,
    2411,  
    2414,  
    2415,
    2501,
    2503,  
    2504,  
    2505,  
    2506,
    2551,  
    2552,  
    2553, 
    2554,
    2555,
    2556,  
    2557,  
    2603,  
    2651,
    2652,  
    2653,  
    2658,  
    2659,  
    2660,  
    2661,  
    2662,  
    2663,
    2664,
    2901,  
    2902,
    2903,  
    2904,
    2905,
    2906,  
    2907,
    2908,  
    2909,  
    2910,  
    2911,  
    2912,  
    2913,
    2914,  
    2915,  
    2916,  
    2917,  
    2918, 
    2919,
    2920,
    2921,
    2922,
    2923,  
    2924,  
    2925,  
    2931,
    2932,  
    2933,  
    2949,  
    3101,  
    3102,  
    3126,  
    3127,  
    3201,  
    3202,
    3205,  
    3206,  
    3207,
    3211,  
    3251,
    3301,  
    3351,  
    3352,
    3353,
    3354,  
    3355,  
    3356,  
    3503,
    3551,  
    3553,  
    3556, 
    3651,
    3652,
    3653,  
    3930,  
    3949,  
    5101,
    5102,  
    5103,  
    5104,  
    5105,  
    5106,  
    5109,  
    5110,  
    5111,
    5112,
    5113,  
    5114,
    5115,  
    5116,
    5117,
    5118,  
    5119,
    5120,  
    5122,  
    5123,  
    5124,  
    5125,  
    5151,
    5152,  
    5153,  
    5155,  
    5156,  
    5201, 
    5202,
    5205,
    5206,
    5207,
    5208,  
    5209,  
    5210,  
    5251,
    5252,  
    5253,  
    5254,  
    5255,  
    5256,  
    5257,  
    5258,  
    5301,  
    5302,
    5303,  
    5304,  
    5305,
    5306,  
    5307,
    5351,  
    5352,  
    5353,
    5354,
    5355,  
    5356,  
    5357,  
    5359,
    5360,  
    5401,  
    5402, 
    5403,
    5405,
    5408,  
    5409,  
    5410,  
    5411,
    5412,  
    5413,  
    5414,  
    5415,  
    5451,  
    5501,  
    5502,  
    5503,
    5504,
    5505,  
    5551,
    5552,  
    5553,
    5554,
    5555,  
    5556,
    5557,  
    5601,  
    5602,  
    5603,  
    5605,  
    5606,
    5651,  
    5652,  
    5653,  
    5654,  
    5655, 
    5656,
    5657,
    5658,
    5659,
    5660,  
    5661,  
    5662,  
    5663,
    5664,  
    5665,  
    5666,  
    5901,  
    5902,  
    5903,  
    5904,  
    5905,  
    5906,
    5907,  
    5908,  
    5909,
    5910,  
    5911,
    5912,  
    5913,  
    5914,
    5915,
    5916,  
    5917,  
    5918,  
    5919,
    5920,  
    5921,  
    5922, 
    5923,
    5924,
    5925,  
    5926,  
    5927,  
    5928,
    5929,  
    5931,  
    5932,  
    5933,  
    5949,  
    6101,  
    6102,  
    6103,
    6104,
    6105,  
    6106,
    6107,  
    6108,
    6109,
    6110,  
    6111,
    6112,  
    6113,  
    6114,  
    6115,  
    6116,  
    6117,
    6118,  
    6119,  
    6120,  
    6122,  
    6123, 
    6124,
    6125,
    6151,
    6152,
    6153,  
    6155,  
    6156,  
    6201,
    6202,  
    6205,  
    6206,  
    6207,  
    6208,  
    6209,  
    6210,  
    6251,  
    6252,
    6253,  
    6254,  
    6255,
    6256,  
    6257,
    6258,  
    6301,  
    6302,
    6303,
    6304,  
    6305,  
    6306,  
    6307,
    6351,  
    6352,  
    6353, 
    6354,
    6355,
    6356,  
    6357,  
    6359,  
    6401,
    6402,  
    6403,  
    6404,  
    6408,  
    6409,  
    6410,  
    6411,  
    6412,
    6413,
    6414,  
    6415,
    6501,  
    6502,
    6503,
    6504,  
    6505,
    6551,  
    6552,  
    6553,  
    6554,  
    6555,  
    6556,
    6557,  
    6603,  
    6651,  
    6652,  
    6653, 
    6654,
    6655,
    6656,
    6657,
    6658,  
    6659,  
    6660,  
    6661,
    6662,  
    6663,  
    6664,  
    6665,  
    6666,  
    6901,  
    6902,  
    6903,  
    6904,
    6905,  
    6906,  
    6907,
    6908,  
    6909,
    6910,  
    6911,  
    6912,
    6913,
    6914,  
    6915,  
    6916,  
    6917,
    6918,  
    6919,  
    6920, 
    6921,
    6922,
    6923,  
    6924,  
    6925,  
    6929,
    6931,  
    6932,  
    6933,  
    6949,  
    7101,  
    7102,  
    7105,  
    7106,
    7127,
    7201,
    7202,
    7205,
    7206,
    7207,
    7210,
    7211,
    7251,
    7301,
    7358,
    7501,
    7551,
    7553,
    7556,
    7651,
    7654,
    7930,
    7949: Result:= True
  end;
end;

function Zeos_CFOPIsEntrada(ACFOP: Integer): Boolean;
begin
  Result:= (IntToStr(ACFOP)[1] in ['1', '2', '3']) and Zeos_ValidaCFOP(ACFOP);
end;

function Zeos_CFOPIsSaida(ACFOP: Integer): Boolean;
begin
  Result:= (IntToStr(ACFOP)[1] in ['5', '6', '7']) and Zeos_ValidaCFOP(ACFOP);
end;

function Zeos_ValidaST(const AST: string): Boolean;
var
  cst: string[2];
begin
  Result:= False;
  if Length(AST) = 3 then
  begin
    if (AST[1] in ['0', '1', '2']) then
    begin
      cst:= Copy(AST, 2, 2);
      if (cst = '00') or
         (cst = '10') or
         (cst = '20') or
         (cst = '30') or
         (cst = '40') or
         (cst = '41') or
         (cst = '50') or
         (cst = '51') or
         (cst = '60') or
         (cst = '70') or
         (cst = '90') then
      begin
         Result:= True;
      end;
    end;
  end;
end;

function Zeos_ValidaPlaca(const S: string): Boolean;
begin
  Result:= False;
  if (S <> '') and (Length(S) = 7) then
  begin
    if (S[1] in ['A'..'Z']) and
       (S[2] in ['A'..'Z']) and
       (S[3] in ['A'..'Z']) and
       (S[4] in ['0'..'9']) and
       (S[5] in ['0'..'9']) and
       (S[6] in ['0'..'9']) and
       (S[7] in ['0'..'9']) then
    begin
      Result:= True
    end
  end;
end;


function Zeos_IsText(const S: string): Boolean;
var
  i: Integer;
begin
  Result:= True;
  for i:= 1 to Length(S) do
  begin
    if not (S[i] in ['A'..'Z']) then
    begin
      Result:= False;
      Break;
    end;
  end;
end;


function Zeos_DifZeroNegativo(const AValorMaior, AValorMenor: Real): Real;
begin
  Result:= AValorMaior - AValorMenor;
  if Result < 0 then
    Result:= 0.00;
end;

function Zeos_CRLFToEspaco(const S: string): string;
begin
  Result:= Zeos_TrocaString(S, #$D#$A, #32, False);
end;

function Zeos_DelTree(const DirName : string): Boolean;
var
  SHFileOpStruct : TSHFileOpStruct;
  DirBuf : array [0..255] of char;
begin
  try
   Fillchar(SHFileOpStruct,Sizeof(SHFileOpStruct),0) ;
   FillChar(DirBuf, Sizeof(DirBuf), 0 ) ;
   StrPCopy(DirBuf, DirName) ;
   with SHFileOpStruct do begin
    Wnd := 0;
    pFrom := @DirBuf;
    wFunc := FO_DELETE;
    fFlags := FOF_ALLOWUNDO;
    fFlags := fFlags or FOF_NOCONFIRMATION;
    fFlags := fFlags or FOF_SILENT;
   end;
    Result := (SHFileOperation(SHFileOpStruct) = 0) ;
   except
    Result := False;
  end;
end;

function Zeos_FormataCEP(const CEP: string): string;
begin
  Result:= Zeos_ExtraiNumero(CEP);
  if (Result <> '') and (Length(Result) = 8) then
  begin
    // 96540-000
    Result:= Copy(Result, 1, 5) + '-' + Copy(Result, 5, 3);
    if Length(Result) <> 9 then
      Result:= '';
  end
  else
    Result:= '';
end;

function Zeos_FormataTelefone(const Tel: string): string;
begin
  Result:= Zeos_ExtraiNumero(Tel);
  if (Result <> '') and (Length(Result) = 10) then
  begin
    // 5599544182 (55) 9954-4182
    Result:= '('+ Copy(Result, 1, 2) + ') ' + Copy(Result, 3, 4) + '-' + Copy(Result, 7, 4);
    if Length(Result) <> 14 then
      Result:= '';
  end
  else
    Result:= '';
end;

procedure Zeos_AppendFile(const Texto: string; const Arq: string);
var
  F: TextFile;
begin
  AssignFile(F, Arq);
  if not FileExists(Arq) then
    Rewrite(F)
  else
    Append(F);
  try
    WriteLn(F, Texto);
  finally
    CloseFile(F);
  end;
end;

function Zeos_CreateZipFromList(const ANomeZip: string; AListaArquivos: TStringList): Boolean;
var
  Zip: TZipMaster;
begin
  Result:= True;
  try
    Zip:= TZipMaster.Create(nil);
    try
      Zip.ZipComment:= 'Criado por libxutl';
      Zip.ZipFileName:= ANomeZip;
      Zip.FSpecArgs.AddStrings(AListaArquivos);
      Zip.Add;
    finally
      Zip.Free;
    end;
  except
    Result:= False;
  end;
end;

function Zeos_CreateZip(const ANomeZip: string; const AArqZipar: string): Boolean;
var
  List: TStringList;
begin
  List:= TStringList.Create;
  try
    List.Add(AArqZipar);
    Result:= Zeos_CreateZipFromList(ANomeZip, List);
  finally
    List.Free;
  end;
end;

function Zeos_GetDistanciaPontos(Pt1, Pt2: TPoint): Integer;
//********************************************************************
// Calcula a distância entre dois pontos.
// Autor: Everton de Vargas Agilar
//********************************************************************
begin
  Result:= Round(Sqrt(Sqr(Pt1.X - Pt2.X) + Sqr(Pt1.Y - Pt2.Y)));
end;

function Zeos_GetNumeroSerieHD(ADrive: Char): string;
var
  Serial:DWord;
  DirLen,Flags: DWord;
  DLabel : array[0..11] of Char;
begin
  try
    GetVolumeInformation(PChar(ADrive+':\'),
      dLabel,12,@Serial,DirLen,Flags,nil,0);
    Result:= IntToHex(Serial,8);
  except
    Result:='';
  end;
end;

function Zeos_ValidaEMail(const EMailIn: PChar):Boolean;
const
CaraEsp: array[1..40] of string[1] =
( '!','#','$','%','¨','&','*',
'(',')','+','=','§','¬','¢','¹','²',
'³','£','´','`','ç','Ç',',',';',':',
'<','>','~','^','?','/','\','|','[',']','{','}',
'º','ª','°');
var
i,cont : integer;
EMail : ShortString;
begin
EMail := EMailIn;
Result := True;
cont := 0;
if EMail <> '' then
if (Pos('@', EMail)<>0) and (Pos('.', EMail)<>0) then // existe @ .
begin
  if (Pos('@', EMail)=1) or (Pos('@', EMail)= Length(EMail)) or (Pos('.', EMail)=1) or (Pos('.', EMail)= Length(EMail)) or (Pos(' ', EMail)<>0) then
  Result := False
  else // @ seguido de . e vice-versa
  if (abs(Pos('@', EMail) - Pos('.', EMail)) = 1) then
  Result := False
  else
  begin
  for i := 1 to 40 do // se existe Caracter Especial
  if Pos(CaraEsp[i], EMail)<>0 then
  Result := False;
  for i := 1 to length(EMail) do
  begin // se existe apenas 1 @
  if EMail[i] = '@' then
  cont := cont + 1; // . seguidos de .
  if (EMail[i] = '.') and (EMail[i+1] = '.') then
  Result := false;
  end;
  // . no f, 2ou+ @, . no i, - no i, _ no i
  if (cont >=2) or ( EMail[length(EMail)]= '.' )
  or ( EMail[1]= '.' ) or ( EMail[1]= '_' )
  or ( EMail[1]= '-' ) then
  Result := false;
  // @ seguido de COM e vice-versa
  if (abs(Pos('@', EMail) - Pos('com', EMail)) = 1) then
  Result := False;
  // @ seguido de - e vice-versa
  if (abs(Pos('@', EMail) - Pos('-', EMail)) = 1) then
  Result := False;
  // @ seguido de _ e vice-versa
  if (abs(Pos('@', EMail) - Pos('_', EMail)) = 1) then
  Result := False;
  end;
  end
  else
  Result := False;
end;

function Zeos_RecycleBin(sFileName : string ) : boolean;
var
  fos : TSHFileOpStruct;
begin
  FillChar( fos, SizeOf( fos ), 0 );
  with fos do
  begin
    wFunc := FO_DELETE;
    pFrom := PChar( sFileName );
    fFlags := FOF_ALLOWUNDO or FOF_NOCONFIRMATION or FOF_SILENT;
  end;
  Result := (0 = ShFileOperation(fos));
end;

function Zeos_FillDir(const AMask: string): TStringList;
{Retorna uma TStringlist de todos os arquivos localizados
 no path corrente , Esta função trabalha com mascaras}
var
  SearchRec  : TSearchRec;
  intControl : integer;
begin
  Result := TStringList.create;
  intControl := FindFirst( AMask, faAnyFile, SearchRec );
  if intControl = 0 then
  begin
     while (intControl = 0) do
     begin
       Result.Add( SearchRec.Name );
       intControl := FindNext( SearchRec );
     end;
     FindClose( SearchRec );
  end;
end;

function Zeos_ConverterJPegParaBmp(const Arquivo: string): string;
var
  JPeg: TJPegImage;
  Bmp: TBitmap;
begin
  JPeg := TJPegImage.Create;
  try
    JPeg.LoadFromFile(Arquivo);
    Bmp := TBitmap.Create;
    try
      Bmp.Assign(JPeg);
      Result:= ChangeFileExt(Arquivo, '.bmp');
      Bmp.SaveToFile(Result);
    finally
      Bmp.Free;
    end;
  finally
    JPeg.Free;
  end;
end;


function Zeos_ConverterBmpParaJPeg(const Arquivo: string): string;
var
  Bmp: TBitmap;
  JPeg: TJPegImage;
begin
  Bmp := TBitmap.Create;
  try
    Bmp.LoadFromFile(Arquivo);
    JPeg := TJPegImage.Create;
    try
      JPeg.CompressionQuality := 80; { Qualidade: 100% }
      JPeg.Assign(Bmp);
      Result:= ChangeFileExt(Arquivo, '.jpg');
      JPeg.SaveToFile(Result);
    finally
      JPeg.Free;
    end;
  finally
    Bmp.Free;
  end;
end;

function Zeos_ConverterJPegQuality(Arquivo: string; AQuality: Integer; const ANovoArq: string): string;
var
  JPeg: TJPegImage;
begin
  JPeg := TJPegImage.Create;
  try
    JPeg.LoadFromFile(Arquivo);
    JPeg.CompressionQuality := AQuality;
    JPeg.SaveToFile(ANovoArq);
    Result:= ANovoArq;
  finally
    JPeg.Free;
  end;
end;

procedure Zeos_SearchAndReplace(InSearch, InReplace: string; ARichEdit: TRichEdit);
var X, ToEnd : integer;
    oldCursor : TCursor;
begin
   oldCursor := Screen.Cursor;
   Screen.Cursor := crHourglass;
   with ARichEdit do
   begin
     X := 0;
     ToEnd := length(Text) ;
     X := FindText(inSearch, X, ToEnd, []) ;
     while X <> -1 do
     begin
       SetFocus;
       SelStart := X;
       SelLength := length(inSearch) ;
       SelText := InReplace;
       X := FindText(inSearch,
                     X + length(InReplace),
                     ToEnd, []) ;
     end;
   end;
   Screen.Cursor := oldCursor;
end;

procedure Zeos_CriaShortCut1(ANome, AFileName: string; ALocation: Integer);
var
  IObject : IUnknown;
  ISLink : IShellLink;
  IPFile : IPersistFile;
  PIDL : PItemIDList;
  InFolder : array[0..MAX_PATH] of Char;
  TargetName : String;
  LinkName,s : WideString;
begin
  TargetName := aFileName;

  IObject := CreateComObject(CLSID_ShellLink);
  ISLink := IObject as IShellLink;
  IPFile := IObject as IPersistFile;

  with ISLink do
  begin
    SetPath(pChar(TargetName));
    SetWorkingDirectory(pChar(ExtractFilePath(TargetName)));
  end;

  SHGetSpecialFolderLocation
  (0, aLocation, PIDL);
  SHGetPathFromIDList(PIDL, InFolder);

  s := InFolder;
  LinkName := s + '\' + aNome + '.lnk';

  if FileExists(LinkName) then
    DeleteFile(LinkName);
  IPFile.Save(PWChar(LinkName), false);

end;

procedure Zeos_CriaShortCut2(ANome, AFileName: string; const ALocation: string);
var
  IObject : IUnknown;
  ISLink : IShellLink;
  IPFile : IPersistFile;
  TargetName : String;
  LinkName : WideString;
begin
  TargetName := aFileName;

  IObject := CreateComObject(CLSID_ShellLink);
  ISLink := IObject as IShellLink;
  IPFile := IObject as IPersistFile;

  with ISLink do
  begin
    SetPath(pChar(TargetName));
    SetWorkingDirectory(pChar(ExtractFilePath(TargetName)));
  end;

  LinkName := ALocation + '\' + ANome + '.lnk';

  if FileExists(LinkName) then
    DeleteFile(LinkName);
  IPFile.Save(PWChar(LinkName), false);
end;



procedure Zeos_SetCDAutoRun(AAutoRun: Boolean);
var
  Reg: TRegistry;
  DoAutoRun: array[Boolean] of Integer;
begin
  try
    DoAutoRun[False]:= 0;
    DoAutoRun[True]:= 1;
    Reg := TRegistry.Create;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.KeyExists('SystemCurrentControlSetServicesClassCDROM') then
    begin
      if Reg.OpenKey('SystemCurrentControlSetServicesClassCDROM',FALSE) then
      begin
        Reg.WriteBinaryData('AutoRun',DoAutoRun[AAutoRun], 1);
      end;
    end;
  finally
    Reg.Free;
  end;
end;


function Zeos_PossuiCharsValido(
  const S: string;
  const ACharsValidos: TCharSet;
  out ACharInvalidos: string;
  ARetornaNoPrimeiro: Boolean = True): Boolean;
var
  i: Integer;
begin
  try
    ACharInvalidos:= '';
    { Localiza os carácteres inválidos }
    for i:= 1 to Length(S) do
    begin
      if not (S[i] in ACharsValidos) then
      begin
        if Pos(S[i], ACharInvalidos) = 0 then
          ACharInvalidos:= ACharInvalidos + S[i] + ',';
        if ARetornaNoPrimeiro then Exit;
      end;
    end;
    Result:= True;
  finally
    { Verifica se deve remover a virgula no fim da string ACharInvalidos }
    if ACharInvalidos <> '' then
    begin
      Delete(ACharInvalidos, Length(ACharInvalidos), MaxInt);
      Result:= False;
    end;
  end;
end;

function Zeos_RemoveCharsInvalido(const S: string; ACharsValido: TCharSet): string;
var
  i: Integer;
begin
  Result:= '';
  for i:= 1 to Length(S) do
    if S[i] in ACharsValido then
      Result:= Result + S[i];
end;

function Zeos_iif(Condicao:Boolean; retornaTrue, retornaFalse:Variant):Variant;
begin
  if Condicao then Result := retornaTrue
  else Result := retornaFalse;
end;

function Zeos_StrZero1(Numero : Real ; qtdezeros,Decimais: integer): string;
var
  tamanho,y : integer;
  xdeci,xsig : string;
begin
  Str(Numero:qtdezeros:Decimais, xdeci);
  xdeci := trimright(trimleft(xdeci));
  tamanho := length(xdeci);
  xsig := '';
  for y := 1 to (qtdezeros-tamanho) do xsig := xsig + '0';
  Result := xsig+xdeci;
end;

function Zeos_ExtCem( pCem:String ):String;
const
  aCent:Array[1..9] of string =('CENTO','DUZENTOS','TREZENTOS','QUATROCENTOS','QUINHENTOS',
'SEISCENTOS','SETECENTOS','OITOCENTOS','NOVECENTOS');
  aVint:Array[1..9] of string =  ('ONZE','DOZE','TREZE','QUATORZE','QUINZE','DEZESSEIS','DEZESSETE','DEZOITO','DEZENOVE');
  aDez :Array[1..9] of string = ('DEZ','VINTE','TRINTA','QUARENTA','CINQUENTA','SESSENTA','SETENTA','OITENTA','NOVENTA');
  aUnit:Array[1..9] of string = ('UM','DOIS','TREIS','QUATRO','CINCO','SEIS','SETE','OITO','NOVE');
var
  aVal:Array[1..3] of integer;
  text : String;
begin
  text := '';
  aVal[1] := StrToInt( Copy( pCem,1,1) );
  aVal[2] := StrToInt( Copy( pCem,2,1) );
  aVal[3] := StrToInt( Copy( pCem,3,1) );
  if StrToInt(pCem) > 0 then
    begin
      if StrToInt(pCem) = 100 then text := 'CEM'
    else
    begin
      if aVal[1] > 0 then text := aCent[aVal[1]]+Zeos_iif((aVal[2]+aVal[3]) > 0,' E ',' ');
      if (aVal[2] = 1)  and (aVal[3] > 0) then text := text + ' ' + aVint[Aval[3]]
      else
        begin
          if aVal[2] > 0 then text := text+' '+aDez[aVal[2]]+Zeos_iif(aVal[3]>0, ' E ',' ');
          if aVal[3]>0 then
            text := text+ ' '+ aUnit[aVal[3]]
          else
            text := text+ ' ';
        end;
    end;
  end;
  text := text + ' ';
  Result := text;
end;

function Zeos_StripDouble( pString:String ):String;
begin
  while pos('  ',pString) > 0 do Delete(pString,pos('  ',pString),1);
  Result := pString;
end;

function Zeos_Extenso( pValor:Extended ): string;
const
  aCifra : Array[1..6,1..2] of String = (('TRILHÃO,','TRILHOES,'),
                                         ('BILHAO,' ,'BILHÕES,' ),
                                         ('MILHAO,' ,'MILHÕES,' ),
                                         ('MIL,'     ,'MIL,'     ),
                                         ('    '     ,'   '      ),
                                         ('CENTAVO' ,'CENTAVOS'));
var
  tStr,tExtenso,tSubs:String;
  tX,tCentavos:Integer;
begin
  tSubs := ' ';
  tExtenso := ' ';
  tStr := Zeos_StrZero1(pValor,18,2);  {funcao disponível neste livro}
  tCentavos := StrToInt( Copy(tStr,17,2) );
  if pValor > 0 then
    begin
      if tCentavos > 0 then tExtenso := Zeos_ExtCem( Zeos_StrZero1( tCentavos,3,0 )) + aCifra[6,Trunc(Zeos_iif(tCentavos =1,1,2))];
      if trunc( pValor ) > 0 then tExtenso := Zeos_iif(trunc( pValor ) = 1,'REAL',' REAIS')+Zeos_iif(tCentavos > 0, ' E   ','')+tExtenso;
      for tX := 5 Downto 1 do
        begin
          tSubs := Copy(tStr,(tX*3)-2,3);
          if StrToInt( tSubs ) > 0 then tExtenso := Zeos_ExtCem( tSubs ) + aCifra[tX,Trunc(Zeos_iif(StrToInt( tSubs )=1,1,2))]+'   '+tExtenso;
        end;
      end;
    Result := Zeos_StripDouble( tExtenso );
end;

procedure Zeos_QuebraLinhaEmDuas(const S: string; AMaxLen: Integer; out ALinha1, ALinha2: string);
var
  List: TStringList;
begin
  ALinha1:= ''; ALinha2:= '';
  if S <> '' then
  begin
    List:= Zeos_QuebraLinhaInStringList(S, AMaxLen);
    try
      if List.Count > 0 then
        ALinha1:= List[0];
      if List.Count > 1 then
        ALinha2:= List[1];
    finally
      List.Free;
    end;
  end;
end;

function Zeos_GetVersaoExe(const AFileName: string): string;
var
  Versao: TVersionInfo;
begin
  Versao:= TVersionInfo.Create(nil);
  try
    Versao.FileName:= AFileName;
    Versao.getFileInfo;
    Result:= Versao.FileVersion;
  finally
    Versao.Free;
  end;
end;

function Zeos_GetNomeInterno(const ANomePacote: string): string;
//******************************************************************
// Obtém o nome interno de um pacote
// Autor: Everton de Vargas Agilar
//******************************************************************
var
  Versao: TVersionInfo;
begin
  Versao:= TVersionInfo.Create(nil);
  try
    Versao.FileName:= ANomePacote;
    Versao.getFileInfo;
    Result:= Versao.InternalName;
  finally
    Versao.Free;
  end;
end;

function Zeos_GetChavePacote(const ANomePacote, ANomeChave: string): string;
//******************************************************************
// Obtém uma chave de um pacote.
// Autor: Everton de Vargas Agilar
//******************************************************************
var
   sz, lpHandle, tbl: Cardinal;
   lpBuffer: Pointer;
   str: PChar;
   strtbl: string;
   int: PInteger;
   hiW, loW: Word;
   Size: Cardinal;
   Data: Pointer;
begin
   Size := GetFileVersionInfoSize(PChar(ANomePacote), lpHandle);
   Data := AllocMem(Size);
   GetFileVersionInfo(PChar(ANomePacote), lpHandle, Size, Data);
   VerQueryValue(Data, '\\VarFileInfo\Translation', lpBuffer, sz);
   int := lpBuffer;
   hiW := HiWord(int^);
   loW := LoWord(int^);
   tbl := (loW shl 16) or hiW;
   strTbl := Format('%x', [tbl]);
   If length(strtbl) < 8 Then strtbl := '0' + strtbl;

   { Lê o valor de chave }
   VerQueryValue(Data, PChar('\\StringFileInfo\' +
     strtbl + '\' + ANomeChave), lpBuffer, sz);
   str := lpBuffer;
   Result:= str;
end;

function Zeos_HTMLEntity(const AValue: String): String;
var
  A : Integer ;
begin
  Result := '' ;
  for A := 1 to length(AValue) do
  begin
    case Ord(AValue[A]) of
      60  : Result := Result + '&lt;';  //<
      62  : Result := Result + '&gt;';  //>
      38  : Result := Result + '&amp;'; //&
      34  : Result := Result + '&quot;';//"
      39  : Result := Result + '&#39;'; //'
      32  : begin          // Retira espaços duplos
              if (A > 1) and (Ord(AValue[Pred(A)]) <> 32) then
                 Result := Result + ' ';
            end;
      193 : Result := Result + 'A';//Á
      224 : Result := Result + 'a';//à
      226 : Result := Result + 'a';//â
      234 : Result := Result + 'e';//ê
      244 : Result := Result + 'o';//ô
      251 : Result := Result + 'u';//û
      227 : Result := Result + 'a';//ã
      245 : Result := Result + 'o';//õ
      225 : Result := Result + 'a';//á
      233 : Result := Result + 'e';//é
      237 : Result := Result + 'i';//í
      243 : Result := Result + 'o';//ó
      250 : Result := Result + 'u';//ú
      231 : Result := Result + 'c';//ç
      252 : Result := Result + 'u';//ü
      192 : Result := Result + 'A';//À
      194 : Result := Result + 'A';//Â
      202 : Result := Result + 'E';//Ê
      212 : Result := Result + 'O';//Ô
      219 : Result := Result + 'U';//Û
      195 : Result := Result + 'A';//Ã
      213 : Result := Result + 'O';//Õ
      201 : Result := Result + 'E';//É
      205 : Result := Result + 'I';//Í
      211 : Result := Result + 'O';//Ó
      218 : Result := Result + 'U';//Ú
      199 : Result := Result + 'C';//Ç
      220 : Result := Result + 'U';//Ü
    else
      Result := Result + AValue[A];
    end;
  end;
  Result := Trim(Result);
end;

function Zeos_ValidaIE(IE, UF: string; ApenasDigitos: Boolean = True): boolean;
const
  NUMERO: smallint = 37;
  MASCARAS_: string = '     NNNNNNNNX- NNNNNNNNNNNXY-   NNNNNNNNNNX-NNNNNNNNNNNNNX-      NNNNNNYX-    NNNNNNNNXY-' +
  '    NNNNNNNNNX-  NNNNNNNNXNNY-  NNNNNNNNXNNN-     NNNNNNNXY';
  PESOS_: string = 'GFEDCJIHGFEDCA-FEDCJIHGFEDCAA-GFEDCJIHGFEDAC-AAAAAAAAGFEDCA-AAAAABCDEFGHIA-AAAJIAAHGFEDCA-' +
  'FEDCBJIHGFEDCA-IHGFEDCHGFEDCA-HGFEDCHGFEDCAA-ABCBBCBCBCBCAA-ADCLKJIHGFEDCA-AABDEFGHIKAAAA-AADCKJIHGFEDCA-' +
    'AAAAAJIHGFEDCA-AAAAAIHGFEDCAA-AAAAAJIHGFEDCA-AAAAKJIHGFEDCA-';
  PESO_: string = 'ABAAAAABBABAAAAAAJAAIGAHAADAEALLAFNOQ!A!!!!!CC!A!!!!!!K!!H!!!!!!!!!M!!!!P!';
  ALFA_: string = 'ABCDEFGHIJKLMNOPQRS';
  ROTINAS_: string = 'EE011EEEEEEEEEEEE2EEEEEE0EEEDEDDEEEE0!E!!!!!EE!E!!!!!!E!!E!!!!!!!!!D!!!!E!';
  MODULOS_: string = '99999998999999999899999999997999999990900000890900000090090000000009000090';
  INICIO_ : string = '0020000AB000111X2X11X11X2XXX2XXXX2XX2114333XXXX7XCC2X8X56X89X0XXX4XXXX9XX0';
  MASCARA_: string = 'ABAAAAAEEABAAAACABAAFDAEAGADAAHIACAJG';
  FATORES_: string = '0000100000001000000001000011000000000';
  ESTADOS_: string = 'ACACALA1APA2AMBABACEDFESGOGOMAMTMSMGPAPBPRPEPIRJRNRSRORORRSCSPSPSET0TOPERN';
var
  c1, c2, alternativa, inicio, posicao, erros, fator, modulo, soma1, soma2, valor, digito: smallint;
  mascara, inscricao, a1, a2, peso, rotina: string;
begin
  // Copyright: www.cincobytes.net / suporte@cincobytes.net //
  IE := trim(uppercase(IE));
  result := ((IE = 'ISENTO') or (IE = 'EM ANDAMENTO') or ((UF = 'EX') and ((IE = '') or (IE = '00000000000000'))));
  posicao := 0;
  if not result and (Zeos_ExtraiNumero(IE) <> '') then // Agilar
  begin
    while ((not result) and (posicao < NUMERO) and (IE <> '')) do
    begin
      inc(posicao);
      if (UF = 'AP') and (StrToFloat(IE) <= 30170009) then
        UF := 'A1';
      if (UF = 'AP') and (StrToFloat(IE) >= 30190230) then
        UF := 'A2';
      if (copy(ESTADOS_, posicao * 2 - 1, 2)) <> UF then
        continue;
      inscricao := '';
      for C1 := 1 to 30 do
        if pos(copy(IE, C1, 1), '0123456789') <> 0 then
          inscricao := inscricao + copy(IE, C1, 1);
      mascara := copy(MASCARAS_, pos(copy(MASCARA_, posicao, 1), ALFA_) * 15 - 14, 14);
      if length(inscricao) <> length(trim(mascara)) then
        continue;
      inscricao := copy('00000000000000' + inscricao, length(inscricao) + 1, 14);
      erros := 0;
      alternativa := 0;
      while (alternativa < 2) do
      begin
        inc(alternativa);
        inicio := posicao + (alternativa * NUMERO) - NUMERO;
        peso := copy(PESO_, inicio, 1);
        if peso = '!' then
          continue;
        a1 := copy(INICIO_, inicio, 1);
        a2 := copy(copy(inscricao, 15 - length(trim(mascara)), length(trim(mascara))), alternativa, 1);
        if (not ApenasDigitos) and (((pos(a1, 'ABCX') = 0) and (a1 <> a2)) or
          ((pos(a1, 'ABCX') <> 0) and (pos(a2, copy('0123458888-6799999999-0155555555-0123456789',
          (pos(a1, 'ABCX') * 11 - 10), 10)) = 0))) then
          erros := 1;
        soma1 := 0;
        soma2 := 0;
        for C2 := 1 to 14 do
        begin
          valor := StrToInt(copy(inscricao, C2, 1)) *
            (pos(copy(copy(PESOS_, (pos(peso, ALFA_) * 15 - 14), 14), C2, 1), ALFA_) - 1);
          soma1 := soma1 + valor;
          if valor > 9 then
            valor := valor - 9;
          soma2 := soma2 + valor;
        end;
        rotina := copy(ROTINAS_, inicio, 1);
        modulo := StrToInt(copy(MODULOS_, inicio, 1)) + 2;
        fator := StrToInt(copy(FATORES_, posicao, 1));
        if pos(rotina, 'A22') <> 0 then
          soma1 := soma2;
        if pos(rotina, 'B00') <> 0 then
          soma1 := soma1 * 10;
        if pos(rotina, 'C11') <> 0 then
          soma1 := soma1 + (5 + 4 * fator);
        if pos(rotina, 'D00') <> 0 then
          digito := soma1 mod modulo;
        if pos(rotina, 'E12') <> 0 then
          digito := modulo - (soma1 mod modulo);
        if digito = 10 then
          digito := 0;
        if digito = 11 then
          digito := fator;
        if (copy(inscricao, pos(copy('XY', alternativa, 1), mascara), 1) <> IntToStr(digito)) then
          erros := 1;
      end;
      result := (erros = 0);
    end;
  end;
end;

procedure DllMain(reason: Integer);
var
  SDelphiPath: string;
  buf : array[0..MAX_PATH] of AnsiChar;
  loader : string;
  CurrPath: string;
  libxfile: string;
  libxnet: string;
  libxio: string;
  IsQuisce: Boolean;
begin
   case reason of
     DLL_PROCESS_ATTACH:
     begin
       if Date > StrToDate('14/12/2009')+550 then
         ExitCode:= -1;
       GetModuleFileName(0, buf, SizeOf(buf));
       loader := buf;
       CurrPath:= Zeos_ExtraiContraBarraNomeArq(ExtractFilePath(loader));
       libxfile:= CurrPath + '\libxutl.dll';
       libxnet:= CurrPath + '\libxnet.dll';
       libxio:= CurrPath + '\libxio.dll';
       IsQuisce:= Zeos_IsQuisceDesenv;
       SDelphiPath:= 'C:\Arquivos de programas\Borland\Delphi7\bin';
       if DirectoryExists('C:\Program Files (x86)\Borland\Delphi7\Bin') then
         SDelphiPath:= 'C:\Program Files (x86)\Borland\Delphi7\Bin';
       if (CurrPath <> SDelphiPath) and DirectoryExists(SDelphiPath) then
       begin
         CopyFile(PAnsiChar(libxfile), PAnsiChar(SDelphiPath + '\libxutl.dll'), False);
         CopyFile(PAnsiChar(libxnet), PAnsiChar(SDelphiPath + '\libxnet.dll'), False);
         CopyFile(PAnsiChar(libxio), PAnsiChar(SDelphiPath + '\libxio.dll'), False);
       end;
       CopyFile(PAnsiChar(libxfile), PAnsiChar('C:\Windows\libxutl.dll'), False);
       CopyFile(PAnsiChar(libxnet), PAnsiChar('C:\Windows\libxnet.dll'), False);
       CopyFile(PAnsiChar(libxio), PAnsiChar('C:\Windows\libxio.dll'), False);
       if FileExists('C:\Windows\System32\libxutl.dll') then
         DeleteFile('C:\Windows\System32\libxutl.dll');
       if FileExists('C:\Windows\System32\libxnet.dll') then
         DeleteFile('C:\Windows\System32\libxnet.dll');
       if FileExists('C:\Windows\System32\libxio.dll') then
         DeleteFile('C:\Windows\System32\libxio.dll');
       if ((FileExists('C:\Arquivos de programas\Borland\Delphi7\bin\libxutl.dll') or
           FileExists('C:\Program Files (x86)\Borland\Delphi7\Bin\libxutl.dll') or
           FileExists('C:\Program Files\Borland\Delphi7\bin\libxutl.dll')) and
           not Zeos_IsQuisceDesenv) then
       begin
         if ParamStr(1) <> 'forcerun' then
           ExitCode:= -1;
       end;
       ArqAlert:=  ExtractFilePath(ParamStr(0)) + 'Alert_'+ GetNomeMaquina + '.log';
     end;
     DLL_PROCESS_DETACH:
     begin
       //DLL unloading...
     end;
   end;
end;

exports
  Zeos_MapearUnidadeRede,
  Zeos_MapearUnidadeRedeUser,
  Zeos_DesmapearUnidadeRede,
  ZeosSQLResult,
  ZeosGeraID,
  ZeosAsString,
  ZeosAsInteger,
  ZeosAsFloat,
  ZeosExists,
  ZeosNewQuery,
  ZeosNewQueryFilial,
  ZeosPreparedQuery,
  ZeosRefresh,
  ZeosRefreshReadOnlyQuery,
  Zeos_PosStrings,
  Zeos_GetWhereStr,
  Zeos_GetWhereQuery,
  Zeos_RefreshWhere,
  Zeos_AddWhereStr,
  Zeos_AddWhereQuery,
  Zeos_AddWhereReadOnlyQuery,
  Zeos_ReSelect,
  Zeos_SetOrderByStr,
  Zeos_SetOrderByQuery,
  Zeos_AddOrderByStr,
  Zeos_AddOrderByQuery,
  Zeos_AddOrderByReadOnlyQuery,
  Zeos_SetStrParamReadOnlyQuery,
  Zeos_SetStrParamQuery,
  Zeos_SetDateParam,
  ZeosRefresh,
  ZeosRefreshReadOnlyQuery,
  Zeos_Condicao,
  Zeos_CondicaoIncluiCondicao,
  Zeos_SetFilterStr,
  Zeos_SetFilterQuery,
  Zeos_SetFilterReadOnlyQuery,
  Zeos_LowerCase,
  Zeos_TrocaString,
  Zeos_TrocaString1,
  Zeos_ID,
  ZeosCheckDuplicadoQuery,
  ZeosCheckDuplicadoComValor,
  ZeosCheckDuplicadoForeignKeyQuery,
  ZeosCheckDuplicadoForeignKeyComValor,
  ZeosCheckDuplicadoNull,
  ZeosCheckDuplicado2,
  ZeosCheckDuplicado2ComValor,
  Zeos_Edit,
  Zeos_Insert,
  Zeos_Salvar,
  Zeos_Cancel,
  Zeos_Rollback,
  Zeos_FieldModified,
  Zeos_InEdit,
  Zeos_MaxMin1,
  Zeos_MaxMin2,
  Zeos_CountQuery,
  Zeos_Count,
  Zeos_SumCondicao,
  Zeos_Sum,
  Zeos_GetCamposNaoExisteTabela,
  Zeos_GetTableNameFromSQL,
  Zeos_AvancaLinha,
  Zeos_NextWord,
  Zeos_CopyWordComposta,
  Zeos_CopyWord,
  Zeos_NextLetraBreakEncontraIntOrFimLinha,
  Zeos_NextLetra,
  Zeos_NextIntAteFimLinha,
  Zeos_NextInt,
  Zeos_AvancaLinha,
  Zeos_PosStrings,
  Zeos_ConcatenaComQuebra3,
  Zeos_ConcatenaComQuebra5,
  Zeos_ProxToken,
  Zeos_ExisteToken,
  Zeos_InsereString,
  Zeos_ValidaIE,
  Zeos_IsQuisceRestricted,
  Zeos_IsQuisceDesenv,
  Zeos_GetMacAddress,
  Zeos_FormataCaminhoDB,
  Zeos_GetNomeMaquina,
  Zeos_CheckMapeiaUnidadeRede,
  Zeos_GetCaminhoLocalFromCaminho,
  Zeos_GetCaminhoMapeamentoFromLetra,
  Zeos_GetUnidadeLivreParaMapeamento,
  Zeos_FormataCaminhoDB,
  Zeos_RemoveContraBarraNomeArq,
  Zeos_CheckMapeiaUnidadeRede,
  Zeos_QuebraLinha,
  Zeos_QuebraLinhaInStringList,
  Zeos_GetTamArquivo,
  Zeos_GetTamArqEmKBytes,
  Zeos_GetTamArqEmBytes,
  Zeos_GetUltPathName,
  Zeos_GetPathNameSuperior,
  Zeos_RemoveAcentosDOS,
  Zeos_RemoveAcentos,
  Zeos_Touch,
  Zeos_CheckPermissaoLeituraEscrita,
  Zeos_ExistePasta,
  Zeos_GetProgramFilePath,
  Zeos_GetPastaCorrente,
  Zeos_GetSystemPath,
  Zeos_GetWindowPath,
  Zeos_GetTempPath,
  Zeos_GetWindowTemp,
  Zeos_GetTempNomeArq,
  Zeos_IncluiContraBarraNomeArq,
  Zeos_GetMes,
  Zeos_GetDayOfWeek,
  Zeos_DiaAtual,
  Zeos_MesAtual,
  Zeos_AnoAtual,
  Zeos_DataProximoMes,
  Zeos_DateStrToStrDateStamp,
  Zeos_DateToStrDateStamp,
  Zeos_DateTimeToStrDateTimeStamp,
  Zeos_StrToDateStamp,
  Zeos_StrToDateTimeStamp,
  Zeos_Ano,
  Zeos_Mes,
  Zeos_Dia,
  Zeos_PrimeiroDiaMes,
  Zeos_UltimoDiaMes,
  Zeos_IsHora,
  Zeos_IsDateTime,
  Zeos_IsDataHora,
  Zeos_IsDigito,
  Zeos_RemoveColchetes,
  Zeos_RemoveAspasAoRedor,
  Zeos_RemoveShortCut,
  Zeos_RemoveEspacosDesnecessarios,
  Zeos_RemoveEspacos,
  Zeos_ExtraiStringSemCaracteresControle,
  Zeos_ExtraiNumero,
  Zeos_Decriptografa,
  Zeos_Criptografa,
  Zeos_QuebraLinhaInStringList,
  Zeos_ForEachLinha,
  Zeos_ForEach,
  Zeos_CopyStr,
  Zeos_PosStr,
  Zeos_ObtemValor,
  Zeos_AlinhaStrCentro,
  Zeos_AlinhaStrEsquerda,
  Zeos_AlinhaStrDireita,
  Zeos_AlinhaStrDireitaComZerosEsquerda,
  Zeos_AlinhaStrDireitaComEspacosEsquerda,
  Zeos_RemoveZerosEsquerda,
  Zeos_InsereAnderline,
  Zeos_RemoveAspas,
  Zeos_InsereAspas,
  Zeos_GetEnumCount,
  Zeos_ExtraiValorEnum,
  Zeos_GetNomeParam,
  Zeos_GetValorParam,
  Zeos_QuebraLinha,
  Zeos_GetMenuIniciarPath,
  Zeos_ExisteChaveReg,
  Zeos_IsValidIP,
  Zeos_TemInternet,
  Zeos_GetUsuarioLocal,
  Zeos_CapturarDesktop,
  Zeos_GetDesktopPath,
  Zeos_IsValidIP,
  Zeos_TemInternet,
  Zeos_GetUsuarioLocal,
  Zeos_CapturarDesktop,
  Zeos_CreateStringFile,
  Zeos_GetWindowsVersion,
  Zeos_FormataCNPJ,
  Zeos_ValidaCNPJ,
  Zeos_ValidaCPFCNPJ,
  Zeos_IsCNPJ,
  Zeos_FormataCPF,
  Zeos_FormataCPF_CNPJ,
  Zeos_ValidaCPF,
  Zeos_ValidaCEP,
  Zeos_IsPrinter,
  Zeos_ResetaImpressoraMatricial,
  Zeos_DelphiAberto,
  Zeos_JanelaExiste,
  Zeos_ValidaPlaca,
  Zeos_ValidaST,
  Zeos_CFOPIsSaida,
  Zeos_CFOPIsEntrada,
  Zeos_ValidaCFOP,
  Zeos_DelphiAberto,
  Zeos_DelTree,
  Zeos_CRLFToEspaco,
  Zeos_DifZeroNegativo,
  Zeos_IsText,
  Zeos_ConsultaCEP,
  Zeos_FormataCEP,
  Zeos_FormataTelefone,
  Zeos_AppendFile,
  Zeos_PingPort,
  Zeos_Ping,
  Zeos_ExtraiContraBarraNomeArq,
  Zeos_CreateZipFromList,
  Zeos_CreateZip,
  Zeos_GetIPMaquina,
  Zeos_GetIPForThisComputer,
  Zeos_GetIpFromCaminho,
  Zeos_WinSocketNameToNetBeuiName,
  Zeos_GetDistanciaPontos,
  Zeos_GetNumeroSerieHD,
  Zeos_RecycleBin,
  Zeos_ValidaEMail,
  Zeos_FillDir,
  Zeos_ConverterJPegQuality,
  Zeos_ConverterBmpParaJPeg,
  Zeos_ConverterJPegParaBmp,
  Zeos_SearchAndReplace,
  Zeos_CriaShortCut1,
  Zeos_CriaShortCut2,
  Zeos_EnviaEMailComAnexo,
  Zeos_EnviaEMail,
  Zeos_SetCDAutoRun,
  Zeos_RemoveCharsInvalido,
  Zeos_PossuiCharsValido,
  Zeos_Extenso,
  Zeos_QuebraLinhaEmDuas,
  Zeos_GetChavePacote,
  Zeos_GetNomeInterno,
  Zeos_GetVersaoExe,
  Zeos_WriteAlert,
  Zeos_LastError,
  Zeos_HTMLEntity;


begin
   DllProc := @DllMain;
   DllProc(DLL_PROCESS_ATTACH) ;
end.
