unit UnDexter;

//*********************************************************************
// Projeto: Interpretador Dexter
// UNIFRA - Centro Universit�rio Franciscano
// Copyright 2006/2007 - Everton de Vargas Agilar
//*********************************************************************/

{

 <program> ::= program <programname>;
               begin
               end.

 <programname> ::= <letter><letter>|<num>
 <instrucao> ::= <comando>;

}

interface

uses SysUtils, Classes, Variants, DB, ZAbstractRODataset, ZDataset, ZConnection;

const
  TamMaxPilha = 1024;
  TamMaxTblVars = 1024;
  TamMaxInt = 8;

type
  PObject = ^TObject;

  TKeyword = (kwProgram, kwBegin, kwEnd, kwVar, kwIdentificador, kwEndProgram,
    kwTerminador, kwSeparador, kwOpAtribuicao, kwOpRelacional, kwOpAdicao,
    kwOpMultiplicacao, kwAbreParenteses, kwFechaParenteses, kwNumero, kwDeclaracao,
    kwWrite, kwWriteLn, kwInteger, kwString, kwBoolean, kwIf, kwThen, kwElse,
    kwRead, kwReadLn, kwWhile, kwRepeat, kwUntil, kwDo, kwFor, kwOpBoolean, kwConcatenar,
    kwReference, kwFunction, kwProcedure, kwCreate, kwConnection,
    kwDatabase, kwProtocol, kwProtocolFirebird, kwUser, kwPassword,
    kwSelect, kwFrom, kwInto);

  TToken = class
  public
    Tipo: TKeyword;
    Value: string;
    Numero: Integer;
    Prox: TToken;
    Ant: TToken;
    Linha: Integer;

    // para instru��es de desvio
    tok_ini: TToken;
    tok_else: TToken;
    tok_do: TToken;
    tok_end: TToken;
    tem_bloco: Boolean;
    begin_level: Integer;
  end;

  TTipoVariavel = (tvIndefinido, tvString, tvInteger, tvBoolean);

  PVariavel = ^TVariavel;
  TVariavel = class
  private
    FToken: TToken;
    FNome: string;
    FValue: Variant;
    FTipo: TTipoVariavel;
    function GetInicializado: Boolean;
    function GetLinha: Integer;
  public
    constructor Create(AToken: TToken; const AValue: Variant;
      ATipo: TTipoVariavel);
    destructor Destroy; override;

    property Nome: string read FNome;
    property Value: Variant read FValue write FValue;
    property Tipo: TTipoVariavel read FTipo write FTipo;
    property Inicializado: Boolean read GetInicializado;
    property Linha: Integer read GetLinha;
  end;

  TPilha = class
  private
    FPilha: array[0..TamMaxPilha] of TObject;
    FTop: PObject;
    FCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Push(Value: TObject);
    function Pop: TObject;
    function TemItens: Boolean;
  end;

  TTabelaVariaveis = class
  private
    FList: array[0..TamMaxTblVars] of TVariavel;
    FCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(var Value: TVariavel);
    function Get(const ANomeVar: string): TVariavel;
  end;

  TFunction = class
  private
    FNome: string;
    FInit: TToken;  // a partir da posi��o begin
    FResult: TVariavel;
  public
    constructor Create;
    destructor Destroy; override;

    property Nome: string read FNome write FNome;
    property Init: TToken read FInit write FInit;
    property Result: TVariavel read FResult write FResult;
  end;

  TTabelaFunctions = class
  private
    FList: TList;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Add(var AFunction: TFunction);
    function Get(const ANome: string): TFunction;
    procedure Execute(AFunction: TFunction; AEnd: TToken);
  end;

  { TConnection }

  TProtocolConnection = (pcFirebird);

  PConnection = ^TConnection;
  TConnection = class
  private
    FConn: TZConnection;
    FNome: string;
    FProtocol: TProtocolConnection;
    FDatabase: string;
    FUser: string;
    FPassword: string;
    procedure Connect;
    procedure Disconnect;
  public
    constructor Create(
      const AConnectionName: string;
      AProtocol: TProtocolConnection;
      const ADatabase: string;
      const AUser: string;
      const APassword: string);
    destructor Destroy; override;

    property Nome: string read FNome;
    property Protocol: TProtocolConnection read FProtocol write FProtocol;
    property Database: string read FDatabase write FDatabase;
    property User: string read FUser write FUser;
    property Password: string read FPassword write FPassword;

  end;

  TTabelaConnection = class
  private
    FList: TList;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Add(var AConn: TConnection);
    function Get(const ANome: string): TConnection;
  end;

  { TAnalisadorLexico }

  TAnalisadorLexico = class
  private
    FLookahead: PChar;
    FFonte: PChar;
    FPrgSize: Integer;
    FCurToken: TToken;
    FPrjFileName: string;
    procedure LoadPrograma;
  public
    constructor Create(const APrjFileName: string);
    destructor Destroy; override;

    property PrgSize: Integer read FPrgSize;
    property PrjFileName: string read FPrjFileName;

    function GetToken: TToken;
    function GetNextToken: TToken;
    function GetIdentificador: TToken;
    function GetString: TToken;
    procedure SetCurToken(Value: TToken);

    procedure Next;
    procedure Prior;
  end;

  TInterpretador = class
  private
    FScan: TAnalisadorLexico;
    FPrgName: string;
    FPilha: TPilha;
    FVars: TTabelaVariaveis;
    FFunctions: TTabelaFunctions;
    FResult: TVariavel;
    FInFunction: Integer;
    FConnections: TTabelaConnection;

    procedure Identifica(AToken: TToken); overload;
    procedure Identifica(AKeyword: TKeyword); overload;

    function DoAtribuicao: TVariavel;
    function Expressao: Double;
    function RelExpressao: Double;
    function BoolExpressao: Double;
    function StrExpressao: string;
    procedure DoWrite(ANovaLinha: Boolean);
    procedure DoRead(ANovaLinha: Boolean);
    procedure SecaoVar;
    procedure DoInstrucao(EmBloco: Boolean = True);
    procedure DoIf;
    procedure DoWhile;
    procedure DoRepeatUntil;
    procedure DoRepeatWhile;
    procedure DoFor;
    procedure DoFunction;
    procedure DoCall(AFunction: TFunction);
    procedure DoCreateConnection;
    procedure DoCreate;
    procedure DoSelect;

    function GetPrgSize: Integer;
    function GetPrjFileName: string;
  public
    constructor Create(const APrjFileName: string);
    destructor Destroy; override;

    procedure Execute;

    property PrgSize: Integer read GetPrgSize;
    property PrgName: string read FPrgName;
    property PrjFileName: string read GetPrjFileName;
  end;

implementation

uses Math;

{ TPilha }

procedure Fatal(const AMessage: string; ALinha: Integer); overload; //inline;
begin
  WriteLn;
  WriteLn(AMessage);
  WriteLn('Linha do erro: ' + IntToStr(ALinha));
  Abort;
end;

procedure Fatal(const AMessage: string; const Args: array of const; ALinha: Integer); overload;
begin
  WriteLn;
  WriteLn(Format(AMessage, Args));
  WriteLn('Linha do erro: ' + IntToStr(ALinha));
  Abort;
end;

function KeywordToStr(Value: TKeyword): string;
begin
  case Value of
    kwProgram: Result:= 'program';
    kwBegin: Result:= 'begin';
    kwEnd: Result:= 'end';
    kwVar: Result:= 'var';
    kwEndProgram: Result:= 'end.';
    kwTerminador: Result:= ';';
    kwSeparador: Result:= ',';
    kwOpAtribuicao: Result:= ':=';
    kwAbreParenteses: Result:= '(';
    kwFechaParenteses: Result:= ')';
    kwDeclaracao: Result:= ':';
    kwWrite: Result:= 'Write';
    kwWriteLn: Result:= 'WriteLn';
    kwInteger: Result:= 'Integer';
    kwString: Result:= 'string';
    kwIf: Result:= 'if';
    kwThen: Result:= 'then';
    kwElse: Result:= 'else';
    kwDo: Result:= 'do';
    kwCreate: Result:= 'create';
    kwConnection: Result:= 'connection';
    kwDatabase: Result:= 'database';
    kwProtocol: Result:= 'protocol';
    kwUser: Result:= 'user';
    kwPassword: Result:= 'password';
    kwSelect: Result:= 'select';
    kwFrom: Result:= 'from';
    kwInto: Result:= 'into';

  end;
end;

function BoolToDouble(Value: Boolean): Double; //inline;
begin
  if Value then
    Result:= 1
  else
    Result:= 0;
end;

function DoubleToBool(Value: Double): Integer; //inline;
begin
  if Value <> 0 then
    Result:= 1
  else
    Result:= 0;
end;

constructor TPilha.Create;
begin
  inherited Create;
  FTop:= @FPilha[TamMaxPilha];
  FCount:= 0;
end;

destructor TPilha.Destroy;
begin

  inherited;
end;

procedure TPilha.Push(Value: TObject);
begin
  FTop^:= Value;
  Dec(FTop);
  Inc(FCount);
end;

function TPilha.Pop: TObject;
begin
  Inc(FTop);
  Result:= FTop^;
  Dec(FCount);
end;

function TPilha.TemItens: Boolean;
begin
  Result:= FCount > 0;
end;

{ TVariavel }

constructor TVariavel.Create(AToken: TToken;
  const AValue: Variant; ATipo: TTipoVariavel);
begin
  inherited Create;
  FToken:= AToken;
  FNome:= AToken.Value;
  FValue:= AValue;
  FTipo:= ATipo;
end;

destructor TVariavel.Destroy;
begin

  inherited;
end;

function TVariavel.GetInicializado: Boolean;
begin
  Result:= FValue <> Null;
end;

function TVariavel.GetLinha: Integer;
begin
  Result:= FToken.Linha;
end;

{ TInterpretador }

procedure TInterpretador.DoInstrucao(EmBloco: Boolean = True);
var
  tok: TToken;
  func: TFunction;
begin
  repeat
    tok:= FScan.GetNextToken;
    case tok.Tipo of
      kwEndProgram, kwEnd, kwElse, kwUntil: Break;
      kwIf: DoIf;
      kwTerminador:
      begin
        Identifica(kwTerminador);
        Continue;
      end;
      kwBegin:
      begin
        Identifica(kwBegin);
        DoInstrucao;
        Identifica(kwEnd);
      end;
      kwWhile:
      begin
        if (tok.tok_ini <> nil) and (tok.tok_ini.Tipo = kwRepeat) then
          Break
        else
          DoWhile;
      end;
      kwRepeat:
      begin
        if tok.tok_end <> nil then
        begin
          if tok.tok_end.Tipo = kwUntil then
            DoRepeatUntil
          else
            DoRepeatWhile;
        end
        else
          Fatal('Repeat sem Until ou While', tok.Linha);
      end;
      kwFor: DoFor;
      else
      begin
        if tok.Tipo = kwIdentificador then
        begin
          if tok.Prox.Tipo = kwAbreParenteses then
          begin
            func:= FFunctions.Get(tok.Value);
            if func <> nil then
            begin
              DoCall(func);
              FScan.SetCurToken(tok.Prox.Prox.Prox);
            end
            else
              Fatal('Function ou procedure nao identificado: '+ tok.Value, tok.linha);
          end
          else
            DoAtribuicao;
        end
        else if tok.Tipo = kwWrite then
          DoWrite(False)
        else if tok.Tipo = kwWriteLn then
          DoWrite(True)
        else if tok.Tipo = kwRead then
          DoRead(False)
        else if tok.Tipo = kwReadLn then
          DoRead(True)
        else if tok.Tipo = kwCreate then
          DoCreate
        else if tok.Tipo = kwSelect then
          DoSelect
        else
          Fatal('Identificador nao identificado: ' + tok.Value, tok.Linha);
        if EmBloco then
        begin
          tok:= FScan.GetNextToken;
          if tok.Tipo = kwUntil then
            Break;
          Identifica(kwTerminador);
        end;
      end;
    end;
  until not EmBloco;
end;

procedure TInterpretador.DoFunction;
var
  tok: TToken;
  func: TFunction;
  begin_level: Integer;
  IsFunction: Boolean;
begin
  while True do
  begin
    tok:= FScan.GetNextToken;
    if tok.Tipo in [kwFunction, kwProcedure] then
    begin
      IsFunction:= tok.Tipo = kwFunction;
      Identifica(tok);
      tok:= FScan.GetIdentificador;
      func:= FFunctions.Get(tok.Value);
      if func <> nil then
        Fatal('function/procedure %s redeclarado', [tok.Value], tok.Linha);
      func:= TFunction.Create;
      func.Nome:= tok.Value;
      Identifica(kwAbreParenteses);
      Identifica(kwFechaParenteses);
      if IsFunction then
      begin
        Identifica(kwDeclaracao);
        func.Result:= TVariavel.Create(tok, Null, tvIndefinido);
        tok:= FScan.GetNextToken;
        case tok.Tipo of
          kwInteger:
          begin
            Identifica(kwInteger);
            func.Result.Tipo:= tvInteger;
          end;
          kwString:
          begin
            Identifica(kwString);
            func.Result.Tipo:= tvString;
          end;
          kwBoolean:
          begin
            Identifica(kwBoolean);
            func.Result.Tipo:= tvBoolean;
          end
          else
            Fatal('Tipo de variavel invalido: ' + tok.Value, tok.Linha);
        end;
      end;
      Identifica(kwTerminador);
      Identifica(kwBegin);
      tok:= FScan.GetNextToken;
      func.Init:= tok;
      FFunctions.Add(func);
      begin_level:= 1;
      repeat
        tok:= FScan.GetToken;
        if tok.Tipo = kwBegin then
          Inc(begin_level)
        else if tok.Tipo = kwEnd then
          Dec(begin_level);
      until (tok.Tipo = kwEnd) and (begin_level = 0);
      Identifica(kwTerminador);
    end
    else
      Break;
  end;
end;

constructor TInterpretador.Create(const APrjFileName: string);
begin
  inherited Create;
  FScan:= TAnalisadorLexico.Create(APrjFileName);
  FPilha:= TPilha.Create;
  FVars:= TTabelaVariaveis.Create;
  FFunctions:= TTabelaFunctions.Create;
  FResult:= nil;
  FInFunction:= 0;
  FConnections:= TTabelaConnection.Create;
end;

destructor TInterpretador.Destroy;
begin
  FConnections.Free;
  FFunctions.Free;
  FPilha.Free;
  FVars.Free;
  FScan.Free;
  inherited;
end;

function TInterpretador.DoAtribuicao: TVariavel;
var
  Ident: TToken;
begin
  Ident:= FScan.GetIdentificador;
  Identifica(kwOpAtribuicao);
  if (FInFunction > 0) and (ident.Value = 'result') then
    Result:= FResult
  else
    Result:= FVars.Get(Ident.Value);
  case Result.Tipo of
    tvInteger: Result.Value:= BoolExpressao;
    tvString: Result.Value:= StrExpressao;
    tvBoolean: Result.Value:= DoubleToBool(BoolExpressao);
  end;
end;

procedure TInterpretador.DoCall(AFunction: TFunction);
begin
  FScan.SetCurToken(AFunction.Init);
  Inc(FInFunction);
  FResult:= AFunction.Result;
  DoInstrucao(True);
  Dec(FInFunction);
end;

procedure TInterpretador.DoIf;
var
  tok_if, tok, old_tok: TToken;
  bValue: Boolean;
  tok_else, tok_end: TToken;
  EmBloco: Boolean;
begin
  tok_if:= FScan.GetToken; // if
  tok_else:= nil;
  tok_end:= nil;
  bValue:= BoolExpressao <> 0;
  Identifica(kwThen);
  tok:= FScan.GetNextToken;
  if bValue then
  begin
    if tok.Tipo = kwIf then
    begin
      DoIf;
      tok:= FScan.GetNextToken;
      if tok.Tipo = kwElse then
      begin
        tok_end:= tok_if.tok_end;
        if tok_end <> nil then
          FScan.SetCurToken(tok_end);
        Identifica(tok_end.Tipo);
      end;
    end
    else
    begin
      EmBloco:= tok.Tipo = kwBegin;
      if EmBloco then
        Identifica(kwBegin);
      DoInstrucao(EmBloco);
      tok:= FScan.GetNextToken;
      old_tok:= tok;
      if EmBloco then
        Identifica(kwEnd);
      tok:= FScan.GetNextToken;
      if tok.Tipo = kwElse then
      begin
        if old_tok.Tipo = kwTerminador then
          Fatal('; n�o permitido antes de else', tok.Linha);
        tok_end:= tok_if.tok_end;
        if tok_end <> nil then
        begin
          FScan.SetCurToken(tok_end);
          Identifica(tok_end.Tipo);
        end;
      end
      else
        Identifica(kwTerminador);
    end;
    Exit;
  end
  else
  begin
    tok_else:= tok_if.tok_else;
    if tok_else <> nil then
    begin
      FScan.SetCurToken(tok_else);
      Identifica(kwElse);
      tok:= FScan.GetNextToken;
      if tok.Tipo = kwIf then
      begin
        DoIf;
        tok:= FScan.GetNextToken;
        if tok.Tipo = kwElse then
        begin
          tok_end:= tok_if.tok_end;
          if tok_end <> nil then
          begin
            FScan.SetCurToken(tok_end);
            Identifica(tok_end.Tipo);
          end;  
        end;
      end
      else
      begin
        EmBloco:= tok.Tipo = kwBegin;
        if EmBloco then
          Identifica(kwBegin);
        DoInstrucao(EmBloco);
        tok:= FScan.GetNextToken;
        if EmBloco then
          Identifica(kwEnd)
        else // Terminador
          Identifica(kwTerminador);
      end;
      Exit;
    end;
    tok_end:= tok_if.tok_end;
    if tok_end <> nil then
    begin
      FScan.SetCurToken(tok_end);
      Identifica(tok_end.Tipo);
    end;
  end;
end;

procedure TInterpretador.DoRead(ANovaLinha: Boolean);
var
  tok: TToken;
  V: TVariavel;
  vstr: string;
  vint: Integer;
begin
  if ANovaLinha then
    Identifica(kwReadLn)
  else
    Identifica(kwRead);
  Identifica(kwAbreParenteses);
  tok:= FScan.GetIdentificador;
  V:= FVars.Get(tok.Value);
  if V = nil then
    Fatal('Identificador nao identificado: ' + V.Value, tok.Linha);

  if ANovaLinha then
  begin
    if V.Tipo = tvInteger then
    begin
      ReadLn(vint);
      V.Value:= vint;
    end
    else if V.Tipo = tvString then
    begin
      ReadLn(vstr);
      V.Value:= vstr;
    end
    else
      Fatal('Tipo ilegal em instrucao Read/ReadLn', tok.Linha);
  end
  else
  begin
    if V.Tipo = tvInteger then
    begin
      Read(vint);
      V.Value:= vint;
    end
    else if V.Tipo = tvString then
    begin
      Read(vstr);
      V.Value:= vstr;
    end
    else
      Fatal('Tipo ilegal em instrucao Read/ReadLn', tok.Linha);
  end;
  Identifica(kwFechaParenteses);
end;

procedure TInterpretador.DoWrite(ANovaLinha: Boolean);
var
  tok: TToken;
  V: TVariavel;
  tipo: TTipoVariavel;
  func: TFunction;
begin
  if ANovaLinha then
    Identifica(kwWriteLn)
  else
    Identifica(kwWrite);
  Identifica(kwAbreParenteses);

  while True do
  begin
    tok:= FScan.GetNextToken;
    case tok.Tipo of
      kwString: Write(StrExpressao);
      kwNumero, kwBoolean, kwAbreParenteses: Write(BoolExpressao:4:2);
      kwIdentificador:
      begin
        if tok.Prox.Tipo = kwAbreParenteses then
        begin
          func:= FFunctions.Get(tok.Value);
          if func = nil then
            tipo:= tvIndefinido
          else
          begin
            if func.Result = nil then
              Fatal('Procedure nao retorna valor', tok.Linha);
            tipo:= func.Result.Tipo;
          end;
        end
        else
        begin
          if (FInFunction > 0) and (tok.Value = 'result') then
            tipo:= FResult.Tipo
          else
          begin
            V:= FVars.Get(tok.Value);
            if V <> nil then
              tipo:= V.Tipo
            else
              tipo:= tvIndefinido;
          end;
        end;
        case tipo of
          tvString: Write(StrExpressao);
          tvInteger: Write(BoolExpressao:4:2);
          tvBoolean: Write(BoolExpressao:4:2);
          tvIndefinido: Fatal('Identificador nao declarado: ' + tok.Value, tok.Linha);
        end;
      end;
    end;
    tok:= FScan.GetNextToken;
    if tok.Tipo = kwSeparador then
      Identifica(kwSeparador)
    else
      Break;
  end;
  if ANovaLinha then
    WriteLn(' ');
  Identifica(kwFechaParenteses);
end;

procedure TInterpretador.Execute;
var
  tok: TToken;
begin
  Identifica(kwProgram);
  FPrgName:= FScan.GetIdentificador.Value;
  Identifica(kwTerminador);
  repeat
    tok:= Fscan.GetNextToken;
    case tok.Tipo of
      kwVar: SecaoVar;
      kwFunction, kwProcedure: DoFunction;
      else
        Break;
    end;
  until tok.Tipo = kwBegin;
  Identifica(kwBegin);
  DoInstrucao;
  Identifica(kwEndProgram);
end;

function TInterpretador.Expressao: Double;

  function Termo: Double;

    function Fator: Double;
    var
      tok: TToken;
      V: TVariavel;
      func: TFunction;
    begin
      tok:= FScan.GetNextToken;
      if tok.Tipo = kwAbreParenteses then
      begin
        Identifica(kwAbreParenteses);
        Result:= Termo;
        Identifica(kwFechaParenteses);
      end
      else
      begin
        tok:= FScan.GetToken;
        if tok.Tipo = kwNumero then
        begin
          if Length(tok.Value) > TamMaxInt then
            Fatal('Inteiro %s muito longo!', [tok.Value], tok.Linha);
          Result:= StrToInt(tok.Value);
        end
        else if tok.Tipo = kwBoolean then
          Result:= StrToInt(tok.Value)
        else
        begin
          if tok.Prox.Tipo = kwAbreParenteses then
          begin
            func:= FFunctions.Get(tok.Value);
            if func <> nil then
            begin
              if func.Result = nil then
                Fatal('Procedure %s nao retorna valor', [tok.Value], tok.Linha);
              DoCall(func);
              FScan.SetCurToken(tok.Prox.Prox.Prox);
              if func.Result.Value = Null then
                Fatal('Function deve retornar um valor diferente de null', tok.Linha);
              Result:= func.Result.Value;
            end
            else
              Fatal('Function ou procedure nao identificado: '+ tok.Value, tok.linha);
          end
          else
          begin
            if (FInFunction > 0) and (tok.Value = 'result') then
            begin
              if FResult = nil then
                Fatal('Procedure nao possui variavel Result', tok.Linha);
              V:= FResult;
            end
            else
            begin
              V:= FVars.Get(tok.Value);
              if V <> nil then
              begin
                if not V.Inicializado then
                  Fatal('Variavel nao inicializada: ' + tok.Value, tok.Linha);
                Result:= Double(V.Value);
              end
              else
                Fatal('Variavel nao identificada: ' + tok.Value, tok.Linha);
            end;
          end;
        end;
      end;
    end;

  var
    tok: TToken;
    op: Char;
  begin
    Result:= Fator;
    tok:= FScan.GetNextToken;
    while tok.Tipo = kwOpMultiplicacao do
    begin
      op:= tok.Value[1];
      Identifica(tok);
      case op of
        '*': Result:= Result * Fator;
        '/': Result:= Result / Fator;
      end;
      tok:= FScan.GetNextToken;
    end;
  end;

var
  tok: TToken;
  op: Char;
begin
  tok:= FScan.GetNextToken;
  if tok.Tipo = kwAbreParenteses then
  begin
    Identifica(kwAbreParenteses);
    Result:= RelExpressao;
    Identifica(kwFechaParenteses);
  end
  else
  begin
    Result:= Termo;
    tok:= FScan.GetNextToken;
    while tok.Tipo = kwOpAdicao do
    begin
      op:= tok.Value[1];
      Identifica(tok);
      case op of
        '+': Result:= Result + Termo;
        '-': Result:= Result - Termo;
      end;
      tok:= FScan.GetNextToken;
    end;
  end;
end;

function TInterpretador.RelExpressao: Double;
var
  tok: TToken;
begin
  Result:= Expressao;
  tok:= FScan.GetNextToken;
  while tok.Tipo = kwOpRelacional do
  begin
    Identifica(tok.Tipo);
    if tok.Value = '=' then
      Result:= BoolToDouble(Result = RelExpressao)
    else if tok.Value = '>' then
      Result:= BoolToDouble(Result > RelExpressao)
    else if tok.Value = '<' then
      Result:= BoolToDouble(Result < RelExpressao)
    else if tok.Value = '>=' then
      Result:= BoolToDouble(Result >= RelExpressao)
    else if tok.Value = '<=' then
      Result:= BoolToDouble(Result <= RelExpressao)
    else if tok.Value = '<>' then
      Result:= BoolToDouble(Result <> RelExpressao)
    else if tok.Value = '!>' then
      Result:= BoolToDouble(Result <= RelExpressao)
    else if tok.Value = '!<' then
      Result:= BoolToDouble(Result >= RelExpressao)
    else if tok.Value = '!>=' then
      Result:= BoolToDouble(Result < RelExpressao)
    else if tok.Value = '!<=' then
      Result:= BoolToDouble(Result > RelExpressao);
    tok:= FScan.GetNextToken;
  end;
end;

function TInterpretador.BoolExpressao: Double;

  function InternalBoolExpressao(AAbriuParenteses: Boolean): Double;
  var
    tok: TToken;
    bResult: Boolean;

    procedure SkipBoolExpressao(AStopInOr: Boolean);
    var
      tok_skip: TToken;
      Parenteses_Level: Integer;
    begin
      Parenteses_Level:= 0;
      if not AStopInOr then
      begin
        while True do
        begin
          tok_skip:= FScan.GetToken;
          if tok_skip = nil then
            Fatal('Esperado expressao booleana', 1);
          if tok_skip.Tipo = kwAbreParenteses then
            Inc(Parenteses_Level)
          else if (tok_skip.Tipo in [kwTerminador, kwThen, kwDo, kwElse, kwEnd]) then
          begin
            FScan.SetCurToken(tok_skip);
            Break;
          end
          else if (tok_skip.Tipo = kwFechaParenteses) and AAbriuParenteses then
          begin
            if Parenteses_Level = 0 then
            begin
              FScan.SetCurToken(tok_skip);
              Break;
            end
            else
              Dec(Parenteses_Level);
          end;
        end;
      end
      else
      begin
        while True do
        begin
          tok_skip:= FScan.GetToken;
          if tok_skip = nil then
            Fatal('Esperado expressao booleana', 1);
          if tok_skip.Tipo = kwAbreParenteses then
            Inc(Parenteses_Level)
          else if (tok_skip.Tipo in [kwTerminador, kwThen, kwDo, kwElse, kwEnd]) or
             ((tok_skip.Tipo = kwOpBoolean) and (tok_skip.Value = '||')) then
          begin
            FScan.SetCurToken(tok_skip);
            Break;
          end
          else if (tok_skip.Tipo = kwFechaParenteses) and AAbriuParenteses then
          begin
            if Parenteses_Level = 0 then
            begin
              FScan.SetCurToken(tok_skip);
              Break;
            end
            else
              Dec(Parenteses_Level);
          end;
        end;
      end;
    end;

    procedure DoBoolExpressao;
    begin
      Result:= RelExpressao;
      tok:= FScan.GetNextToken;
      if tok.Tipo = kwOpBoolean then
      begin
        while tok.Tipo = kwOpBoolean do
        begin
          Identifica(tok.Tipo);
          if tok.Value = '&&' then
          begin
            if not bResult then
              SkipBoolExpressao(True)
            else
              bResult:= DoubleToBool(InternalBoolExpressao(AAbriuParenteses)) = 1;
          end
          else if tok.Value = '||' then
          begin
            if bResult then
              SkipBoolExpressao(False)
            else
              bResult:= DoubleToBool(InternalBoolExpressao(AAbriuParenteses)) = 1;
          end;
          tok:= FScan.GetNextToken;
        end;
        Result:= BoolToDouble(bResult);
      end;
    end;

    procedure DoAbreFechaParenteses;
    var
     op: Char;
    begin
      while tok.Tipo = kwAbreParenteses do
      begin
        Identifica(kwAbreParenteses);
        Result:= InternalBoolExpressao(True);
        bResult:= DoubleToBool(Result) = 1;
        Identifica(kwFechaParenteses);
        tok:= FScan.GetNextToken;
        while tok.Tipo = kwOpMultiplicacao do
        begin
          op:= tok.Value[1];
          Identifica(tok);
          case op of
            '*': Result:= Result * RelExpressao;
            '/': Result:= Result / RelExpressao;
          end;
          tok:= FScan.GetNextToken;
        end;

        while tok.Tipo = kwOpRelacional do
        begin
          Identifica(tok);
          if tok.Value = '=' then
            Result:= BoolToDouble(Result = RelExpressao)
          else if tok.Value = '>' then
            Result:= BoolToDouble(Result > RelExpressao)
          else if tok.Value = '<' then
            Result:= BoolToDouble(Result < RelExpressao)
          else if tok.Value = '>=' then
            Result:= BoolToDouble(Result >= RelExpressao)
          else if tok.Value = '<=' then
            Result:= BoolToDouble(Result <= RelExpressao)
          else if tok.Value = '<>' then
            Result:= BoolToDouble(Result <> RelExpressao);
          tok:= FScan.GetNextToken;
        end;

        while tok.Tipo = kwOpBoolean do
        begin
          Identifica(tok.Tipo);
          if tok.Value = '&&' then
          begin
            if not bResult then
              SkipBoolExpressao(True)
            else
              bResult:= DoubleToBool(InternalBoolExpressao(AAbriuParenteses)) = 1;
          end
          else if tok.Value = '||' then
          begin
            if bResult then
              SkipBoolExpressao(False)
            else
              bResult:= DoubleToBool(InternalBoolExpressao(AAbriuParenteses)) = 1;
          end;
          tok:= FScan.GetNextToken;
        end;
      end;
    end;

  begin
    bResult:= True;
    tok:= FScan.GetNextToken;
    if tok.Tipo = kwAbreParenteses then
      DoAbreFechaParenteses
    else if (tok.Tipo in [kwTerminador, kwThen, kwDo, kwElse, kwEnd]) then
      Exit
    else
    begin
      DoBoolExpressao;
      bResult:= DoubleToBool(Result) = 1;
    end;
  end;

begin
  Result:= InternalBoolExpressao(False);
end;

function TInterpretador.GetPrgSize: Integer;
begin
  Result:= FScan.PrgSize;
end;

function TInterpretador.GetPrjFileName: string;
begin
  Result:= FScan.PrjFileName;
end;

procedure TInterpretador.Identifica(AToken: TToken);
var
  tok: TToken;
begin
  tok:= FScan.GetToken;
  if tok.Tipo <> AToken.Tipo then
    Fatal('Erro: "%s" esperado mas "%s" encontrado', [AToken.Value, tok.Value], tok.Linha);
end;

procedure TInterpretador.Identifica(AKeyword: TKeyword);
var
  tok: TToken;
begin
  tok:= FScan.GetToken;
  if tok.Tipo <> AKeyword then
    Fatal('Erro: "%s" esperado mas "%s" encontrado', [KeywordToStr(AKeyword), tok.Value], tok.Linha);
end;

procedure TInterpretador.SecaoVar;
var
  tok: TToken;
  TokVar: TToken;
  Tipo: TTipoVariavel;
  V: TVariavel;
  QtdVars, i: Integer;
begin
  while True do
  begin
    tok:= FScan.GetNextToken;
    if tok.Tipo = kwVar then
    begin
      QtdVars:= 0;
      Identifica(kwVar);
      while True do
      begin
        TokVar:= FScan.GetIdentificador;
        tok:= FScan.GetToken;
        if tok.Tipo in [kwDeclaracao, kwSeparador] then
        begin
          V:= TVariavel.Create(TokVar, Null, tvIndefinido);
          FPilha.Push(V);
          Inc(QtdVars);
          if tok.Tipo = kwSeparador then
            Continue;
        end
        else
          Fatal('Esperado ":" mas "%s" encontrado', [tok.Value], tok.Linha);

        tok:= FScan.GetToken;
        case tok.Tipo of
          kwInteger: Tipo:= tvInteger;
          kwString: Tipo:= tvString;
          kwBoolean: Tipo:= tvBoolean;
          else
            Fatal('Tipo de variavel invalido: ' + tok.Value, tok.Linha);
        end;

        for i:= 0 to QtdVars-1 do
        begin
          V:= FPilha.Pop as TVariavel;
          V.Tipo:= Tipo;
          FVars.Add(V);
        end;
        Identifica(kwTerminador);
        QtdVars:= 0;
        tok:= FScan.GetNextToken;
        if tok.Tipo <> kwIdentificador then
          Break;
      end;
    end
    else
      Break;
  end;
end;

function TInterpretador.StrExpressao: string;
var
  tok: TToken;
  V: TVariavel;
  func: TFunction;
begin
  Result:= '';
  tok:= FScan.GetNextToken;
  if not (tok.Tipo in [kwString, kwIdentificador]) then
    Fatal('Esperado string mas %s encontrado', [tok.Value], tok.Linha);

  while tok.Tipo in [kwString, kwIdentificador] do
  begin
    if tok.Tipo = kwString then
    begin
      Result:= Result + tok.Value;
      Identifica(kwString);
    end
    else
    begin
      if tok.Prox.Tipo = kwAbreParenteses then
      begin
        func:= FFunctions.Get(tok.Value);
        if func = nil then
          Fatal('Function ou procedure nao identificado', tok.Linha);
        if func.Result = nil then
          Fatal('Procedure nao retorna valor', tok.Linha);
        if func.Result.Tipo <> tvString then
          Fatal('Function %s deve retornar um valor do tipo string', [tok.Value], tok.Linha);
        DoCall(func);
        V:= func.Result;
        FScan.SetCurToken(tok.Prox.Prox.Prox);
      end
      else
      begin
        V:= FVars.Get(tok.Value);
        if V = nil then
          Fatal('Variavel nao declarada', tok.Linha);
        Identifica(kwIdentificador);  
      end;
      Result:= Result + string(V.Value);
    end;
    tok:= FScan.GetNextToken;
    if (tok.Tipo = kwOpAdicao) and (tok.Value = '+') or (tok.Tipo = kwConcatenar) then
    begin
      Identifica(tok);
      tok:= FScan.GetNextToken;
    end;
  end;
end;

procedure TInterpretador.DoWhile;
var
  tok_while, tok_expr, tok_end, tok: TToken;
  bValue: Boolean;
  EmBloco: Boolean;
begin
  tok_while:= FScan.GetToken;
  tok_expr:= FScan.GetNextToken;
  while True do
  begin
    bValue:= BoolExpressao <> 0;
    Identifica(kwDo);
    if bValue then
    begin
      tok:= FScan.GetNextToken;
      EmBloco:= tok.Tipo = kwBegin;
      if EmBloco then
        Identifica(kwBegin);
      DoInstrucao(EmBloco);
      if EmBloco then
      begin
        Identifica(kwEnd);
        Identifica(kwTerminador);
      end
      else
      begin
        tok:= FScan.GetNextToken;
        if tok.Tipo = kwTerminador then
          Identifica(kwTerminador)
        else
          Break;
      end;
      FScan.SetCurToken(tok_expr);
    end
    else
    begin
      tok_end:= tok_while.tok_end;
      if tok_end <> nil then
      begin
        FScan.SetCurToken(tok_end);
        if tok_end.Tipo = kwEnd then
          Identifica(kwEnd);
        Identifica(kwTerminador);
        Break;
      end;
    end;
  end;
end;

procedure TInterpretador.DoRepeatUntil;
var
  tok_repeat, tok_until: TToken;
  bValue: Boolean;
begin
  while True do
  begin
    tok_repeat:= FScan.GetToken;
    DoInstrucao(True);
    Identifica(kwUntil);
    bValue:= BoolExpressao <> 0;
    Identifica(kwTerminador);
    if bValue then
      Break
    else
      FScan.SetCurToken(tok_repeat);
  end;
end;

procedure TInterpretador.DoRepeatWhile;
var
  tok_repeat, tok_while, tok: TToken;
  bValue: Boolean;
begin
  while True do
  begin
    tok_repeat:= FScan.GetToken;
    DoInstrucao(True);
    Identifica(kwWhile);
    bValue:= BoolExpressao <> 0;
    Identifica(kwTerminador);
    if not bValue then
      Break
    else
      FScan.SetCurToken(tok_repeat);
  end;
end;

procedure TInterpretador.DoFor;
var
  tok_for, tok_condicao, tok_inc, tok: TToken;
  bValue: Boolean;
  IsForC: Boolean;
  V: TVariavel;
  EmBloco: Boolean;
  i: integer;
begin
  tok_for:= FScan.GetToken;
  tok:= FScan.GetNextToken;
  IsForC:= tok.Tipo = kwAbreParenteses;
  if IsForC then
  begin
    Identifica(kwAbreParenteses);
    tok:= FScan.GetNextToken;
    if tok.Tipo <> kwIdentificador then
      Fatal('Identificador esperado mas %s encontrado', [tok.Value], tok.Linha);
    V:= DoAtribuicao;
    tok_condicao:= FScan.GetNextToken;
    bValue:= BoolExpressao = 1;
    tok_inc:= FScan.GetNextToken;
    if tok_inc.Tipo <> kwIdentificador then
      Fatal('Identificador esperado mas %s encontrado', [tok_inc.Value], tok.Linha);
    if tok_for.tok_do = nil then
      Fatal('Instrucao For sem Do', tok_for.Linha);
    FScan.SetCurToken(tok_for.tok_do);
    Identifica(kwDo);
    tok_for.tok_ini:= FScan.GetNextToken;
    while bValue do
    begin
      tok:= FScan.GetNextToken;
      EmBloco:= tok.Tipo = kwBegin;
      if EmBloco then
        Identifica(kwBegin);
      DoInstrucao(EmBloco);
      if EmBloco then
        Identifica(kwEnd);
      if tok.Tipo <> kwFor then
        Identifica(kwTerminador);
      FScan.SetCurToken(tok_inc);
      V:= DoAtribuicao;
      FScan.SetCurToken(tok_condicao);
      bValue:= BoolExpressao = 1;
      FScan.SetCurToken(tok_for.tok_ini);
    end;
    if tok_for.tok_end <> nil then
    begin
      FScan.SetCurToken(tok_for.tok_end);
      Identifica(tok_for.tok_end);
      if tok_for.tok_end.Tipo = kwEnd then
        Identifica(kwTerminador);
    end
    else
      Identifica(kwTerminador);
  end
end;

procedure TInterpretador.DoCreateConnection;
var
  Conn: TConnection;
  tokConnection: TToken;
  tokDatabase: TToken;
  tokProtocol: TToken;
  tokUser: TToken;
  tokPassword: TToken;
  Protocol: TProtocolConnection;
begin
  Identifica(kwConnection);
  tokConnection:= FScan.GetIdentificador;
  Identifica(kwDatabase);
  tokDatabase:= FScan.GetString;
  Identifica(kwProtocol);
  tokProtocol:= FScan.GetToken;
  if not (tokProtocol.Tipo in [kwProtocolFirebird]) then
    Fatal('Esterado o tipo de protocolo: Firebird', tokProtocol.Linha);
  Identifica(kwUser);
  tokUser:= FScan.GetString;
  Identifica(kwPassword);
  tokPassword:= FScan.GetString;
  case tokProtocol.Tipo of
    kwProtocolFirebird: Protocol:= pcFirebird;
  end;
  try
    Conn:= TConnection.Create(tokConnection.Value, Protocol, tokDatabase.Value, tokUser.Value, tokPassword.Value);
  except
    Fatal('Erro ao conectar '+ tokDatabase.Value, tokConnection.Linha);
  end;
  FConnections.Add(Conn);


end;

procedure TInterpretador.DoCreate;
var
  tok: TToken;
begin
  Identifica(kwCreate);
  tok:= FScan.GetNextToken;
  case tok.Tipo of
    kwConnection: DoCreateConnection;
  end;

end;

procedure TInterpretador.DoSelect;
begin
  Identifica(kwSelect);

end;

{ TTabelaVariaveis }

procedure TTabelaVariaveis.Add(var Value: TVariavel);
begin
  if Get(Value.Nome) <> nil then
    Fatal('Identificador redeclarado: ' + Value.Nome, Value.Linha);
  FList[FCount]:= Value;
  Inc(FCount);
end;

constructor TTabelaVariaveis.Create;
begin
  FCount:= 0;
end;

destructor TTabelaVariaveis.Destroy;
begin

  inherited;
end;

function TTabelaVariaveis.Get(const ANomeVar: string): TVariavel;
var
  i: Integer;
begin
  for i:= 0 to FCount-1 do
  begin
    Result:= FList[i];
    if Result.Nome = ANomeVar then Exit;
  end;
  Result:= nil;
end;

{ TAnalisadorLexico }

constructor TAnalisadorLexico.Create(const APrjFileName: string);
begin
  inherited Create;
  FPrjFileName:= APrjFileName;
  FCurToken:= nil;
  LoadPrograma;
end;

destructor TAnalisadorLexico.Destroy;
begin

  inherited;
end;

function TAnalisadorLexico.GetToken: TToken;
begin
  Result:= FCurToken;
  FCurToken:= FCurToken.Prox;
end;

function TAnalisadorLexico.GetNextToken: TToken;
begin
  Result:= FCurToken;
end;

function TAnalisadorLexico.GetIdentificador: TToken;
begin
  Result:= GetToken;
  if Result.Tipo <> kwIdentificador then
    Fatal('Declaracao esperada mas %s encontrado', [Result.Value], Result.Linha);
end;

procedure TAnalisadorLexico.LoadPrograma;
var
  CurLinha: Integer;
  Token: string;

  function GetToken: string;

    procedure SkipSpaces;
    begin
      while (FLookahead^ in [' ', #13, #10, #9]) do Inc(FLookahead);
    end;

    procedure SkipComentarios;
    begin
      // Coment�rios de linha
      if FLookahead^ = '/' then
      begin
        Inc(FLookahead);
        if FLookahead^ = '/' then
        begin
          while FLookahead^ <> #10 do
            Inc(FLookahead);
          Inc(FLookahead);
          SkipSpaces;
          SkipComentarios;
        end
        else
          Dec(FLookahead);
      end
      // Coment�rios de bloco
      else if FLookahead^ = '{' then
      begin
        while not (FLookahead^ in ['}', #0]) do
          Inc(FLookahead);
        Inc(FLookahead);
        SkipSpaces;
        SkipComentarios;
      end;
    end;

  begin
    Token:= '';
    SkipSpaces;
    SkipComentarios;
    if FLookahead^ = #0 then
    begin
      Result:= 'end.';
      Exit;
    end;
    if FLookahead^ in ['(', ')', '+', '-', '*', '/', ':', ',', ';', #39] then
    begin
      case FLookahead^ of
        ':':
        begin
          Inc(FLookahead);
          if FLookahead^ = '=' then
          begin
            Token:= ':=';
            Inc(FLookahead);
          end
          else
            Token:= ':';
        end;
        ';':
        begin
          Inc(CurLinha);
          Token:= FLookahead^;
          Inc(FLookahead);
        end;
        else
        begin
          Token:= FLookahead^;
          Inc(FLookahead);
        end;
      end;
    end
    else
    begin
      while not (FLookahead^ in [#0, ' ', #13, #10, #9, '(', ')', '+', '-', '*', '/', ':', ',', ';']) do
      begin
        Token:= Token + FLookahead^;
        Inc(FLookahead);
        if FLookahead^ in [';', '(', ')', ':', ','] then Break;
      end;
    end;
    Token:= LowerCase(Token);
    Result:= Token;
  end;

var
  Arq: file of Char;
  BytesRead: Integer;
  str, lstr: string;
  tok, tok_if, tok_repeat : TToken;
  PilhaIfs: TPilha;
  PilhaRepeat: TPilha;
  BeginLevel: Integer;
begin
  // Carrega o programa em mem�ria
  AssignFile(Arq, FPrjFileName);
  Reset(Arq);
  try
    FPrgSize:= FileSize(Arq);
    GetMem(FFonte, FPrgSize+2);
    BlockRead(Arq, FFonte^, FPrgSize, BytesRead);
    FFonte[BytesRead+1]:= #0;
    FFonte[BytesRead+2]:= #0;
    FLookahead:= FFonte;
  finally
    CloseFile(Arq);
  end;

  PilhaIfs:= TPilha.Create;
  PilhaRepeat:= TPilha.Create;
  try
    BeginLevel:= 0;

    // Cria uma lista duplamente encadeada dos tokens do programa
    CurLinha:= 1;
    FCurToken:= TToken.Create;
    FCurToken.Numero:= 0;
    FCurToken.Ant:= nil;
    FCurToken.tok_ini:= nil;
    FCurToken.tok_else:= nil;
    FCurToken.tok_end:= nil;
    FCurToken.begin_level:= 0;
    tok:= FCurToken;
    repeat
      str:= GetToken;
      lstr:= LowerCase(str);
      tok.Value:= str;
      tok.Linha:= CurLinha;
      tok.Tipo:= kwIdentificador;
      if lstr = 'program' then
        tok.Tipo:= kwProgram
      else if lstr = 'var' then
        tok.Tipo:= kwVar
      else if lstr = 'function' then
        tok.Tipo:= kwFunction
      else if lstr = 'procedure' then
        tok.Tipo:= kwProcedure
      else if lstr = 'begin' then
      begin
        tok.Tipo:= kwBegin;
        Inc(BeginLevel);
        if (tok.Ant <> nil) and (tok.Ant.Tipo in [kwThen, kwElse, kwDo]) then
        begin
          if PilhaIfs.TemItens then
          begin
            tok_if:= PilhaIfs.Pop as TToken;
            tok_if.tem_bloco:= True;
            tok_if.begin_level:= BeginLevel;
            PilhaIfs.Push(tok_if);
          end;
        end;
      end
      else if lstr = 'end' then
      begin
        tok.Tipo:= kwEnd;
        if PilhaIfs.TemItens then
        begin
          repeat
            tok_if:= PilhaIfs.Pop as TToken;
          until not PilhaIfs.TemItens or (tok_if.begin_level = BeginLevel);

          if tok_if.tem_bloco and (tok_if.begin_level = BeginLevel) then
            tok_if.tok_end:= tok;
          PilhaIfs.Push(tok_if);
        end;
        Dec(BeginLevel);
      end
      else if lstr = 'end.' then
        tok.Tipo:= kwEndProgram
      else if (Length(str) = 1) and
        (str[1] in ['=', '+', '-', '*', '/', '>', '<', '>', ',', ';', ':', '(', ')', '!']) then
      begin
        case str[1] of
          '+', '-': tok.Tipo:= kwOpAdicao;
          '*', '/': tok.Tipo:= kwOpMultiplicacao;
          '=', '>', '<': tok.Tipo:= kwOpRelacional;
          ',': tok.Tipo:= kwSeparador;
          ';':
          begin
            tok.Tipo:= kwTerminador;
            if PilhaIfs.TemItens then
            begin
              tok_if:= PilhaIfs.Pop as TToken;
              if (tok_if.Tipo = kwFor) and (tok_if.tok_do = nil) then
              begin
                PilhaIfs.Push(tok_if);
                Continue;
              end;

              if not tok_if.tem_bloco then
              begin
                tok_if.tok_end:= tok;
                while PilhaIfs.TemItens and (tok_if.Ant <> nil) and (tok_if.Ant.Tipo in [kwElse, kwDo]) do
                begin
                  tok_if:= PilhaIfs.Pop as TToken;
                  tok_if.tok_end:= tok;
                end;
              end
              else
              begin
                PilhaIfs.Push(tok_if);
                if (tok_if.tok_end <> nil) and (tok.Ant = tok_if.tok_end) then
                  PilhaIfs.Pop;
              end;
            end;
          end;
          ':': tok.Tipo:= kwDeclaracao;
          '(': tok.Tipo:= kwAbreParenteses;
          ')': tok.Tipo:= kwFechaParenteses;
        end;
      end
      else if str = ':=' then
        tok.Tipo:= kwOpAtribuicao
      else if str = '>=' then
        tok.Tipo:= kwOpRelacional
      else if str = '<=' then
        tok.Tipo:= kwOpRelacional
      else if str = '!>' then
        tok.Tipo:= kwOpRelacional
      else if str = '!<' then
        tok.Tipo:= kwOpRelacional
      else if str = '!<=' then
        tok.Tipo:= kwOpRelacional
      else if str = '!>=' then
        tok.Tipo:= kwOpRelacional
      else if (str = '<>') or (str = '!=') then
      begin
        tok.Tipo:= kwOpRelacional;
        tok.Value:= '<>';
      end
      else if str = '||' then
        tok.Tipo:= kwConcatenar
      else if str = 'write' then
        tok.Tipo:= kwWrite
      else if str = 'writeln' then
        tok.Tipo:= kwWriteLn
      else if str = 'read' then
        tok.Tipo:= kwRead
      else if str = 'readln' then
        tok.Tipo:= kwReadLn
      else if str = 'integer' then
        tok.Tipo:= kwInteger
      else if str = 'string' then
        tok.Tipo:= kwString
      else if str = 'boolean' then
        tok.Tipo:= kwBoolean
      else if str = 'true' then
      begin
        tok.Tipo:= kwBoolean;
        tok.Value:= '1';
      end
      else if str = 'false' then
      begin
        tok.Tipo:= kwBoolean;
        tok.Value:= '0';
      end
      else if str = 'if' then
      begin
        tok.Tipo:= kwIf;
        tok.tem_bloco:= False;
        PilhaIfs.Push(tok);
      end
      else if (str = 'then') or (str = 'do') then
      begin
        if str = 'then' then
          tok.Tipo:= kwThen
        else
          tok.Tipo:= kwDo;
        if PilhaIfs.TemItens then
        begin
          tok_if:= PilhaIfs.Pop as TToken;
          if tok_if.Tipo = kwWhile then
          begin
            if (tok_if.tok_ini <> nil) and (tok_if.tok_ini.Tipo = kwRepeat) then
            begin
              tok_if.tok_ini.tok_end:= nil;
              PilhaRepeat.Push(tok_if.tok_ini);
              tok_if.tok_ini:= nil;
            end;
          end
          else if tok_if.Tipo = kwFor then
            tok_if.tok_do:= tok;
          PilhaIfs.Push(tok_if);
        end;
      end
      else if str = 'else' then
      begin
        if (tok.Ant <> nil) and (tok.Ant.Tipo = kwTerminador) then
          Fatal('; nao permitido antes de else', tok.Linha);
        tok.Tipo:= kwElse;
        if PilhaIfs.TemItens then
        begin
          tok_if:= PilhaIfs.Pop as TToken;
          tok_if.tok_else:= tok;
          tok_if.tok_end:= nil;
          tok_if.tem_bloco:= False;
          PilhaIfs.Push(tok_if);
        end;
      end
      else if str = 'while' then
      begin
        tok.Tipo:= kwWhile;
        tok.tem_bloco:= False;
        PilhaIfs.Push(tok);
        if PilhaRepeat.TemItens then
        begin
          tok_repeat:= PilhaRepeat.Pop as TToken;
          tok_repeat.tok_end:= tok;
          tok.tok_ini:= tok_repeat;
        end;
      end
      else if str = 'repeat' then
      begin
        tok.Tipo:= kwRepeat;
        PilhaRepeat.Push(tok);
      end
      else if str = 'until' then
      begin
        tok.Tipo:= kwUntil;
        if PilhaRepeat.TemItens then
        begin
          tok_repeat:= PilhaRepeat.Pop as TToken;
          tok_repeat.tok_end:= tok;
        end;
      end
      else if str = 'for' then
      begin
        tok.Tipo:= kwFor;
        tok.tem_bloco:= False;
        PilhaIfs.Push(tok);
      end
      else if str = 'and' then
      begin
        tok.Tipo:= kwOpBoolean;
        tok.Value:= '&&';
      end
      else if str = 'or' then
      begin
        tok.Tipo:= kwOpBoolean;
        tok.Value:= '||';
      end
      else if str = '&&' then
        tok.Tipo:= kwOpBoolean
      else if str = '||' then
        tok.Tipo:= kwOpBoolean
      else if str = '&' then
        tok.Tipo:= kwReference
      else if (str[1] in ['0'..'9']) then
      begin
        try
          tok.Numero:= StrToInt(str);
          tok.Tipo:= kwNumero;
        except
          Fatal('Identificador invalido: '+ tok.Value, tok.Linha);
        end;
      end
      else if str[1] = #39 then
      begin
        str:= '';
        while not (FLookahead^ in [#0, #39]) do
        begin
          str:= str + FLookahead^;
          Inc(FLookahead);
        end;
        Inc(FLookahead);
        tok.Value:= str;
        tok.Tipo:= kwString;
      end
      else if str = 'create' then
        tok.Tipo:= kwCreate
      else if str = 'connection' then
        tok.Tipo:= kwConnection
      else if str = 'database' then
        tok.Tipo:= kwDatabase
      else if str = 'protocol' then
        tok.Tipo:= kwProtocol
      else if str = 'firebird' then
        tok.Tipo:= kwProtocolFirebird
      else if str = 'user' then
        tok.Tipo:= kwUser
      else if str = 'password' then
        tok.Tipo:= kwPassword
      else if str = 'select' then
        tok.Tipo:= kwSelect
      else if str = 'from' then
        tok.Tipo:= kwFrom
      else if str = 'into' then
        tok.Tipo:= kwInto;



      tok.Prox:= TToken.Create;
      tok.Prox.Numero:= 0;
      tok.Prox.Ant:= tok;
      tok:= tok.Prox;
      tok.tok_ini:= nil;
      tok.tok_else:= nil;
      tok.tok_end:= nil;
      tok.begin_level:= 0;

    until tok.Ant.Tipo = kwEndProgram;
  finally
    PilhaIfs.Free;
    PilhaRepeat.Free;
  end;
end;

procedure TAnalisadorLexico.Next;
begin
  FCurToken:= FCurToken.Prox;
end;

procedure TAnalisadorLexico.Prior;
begin
  FCurToken:= FCurToken.Ant;
end;

procedure TAnalisadorLexico.SetCurToken(Value: TToken);
begin
  FCurToken:= Value;
end;

function TAnalisadorLexico.GetString: TToken;
begin
  Result:= GetToken;
  if Result.Tipo <> kwString then
    Fatal('Esperado string mas %s encontrado', [Result.Value], Result.Linha);
end;

{ TFunction }

constructor TFunction.Create;
begin
  inherited;
  FNome:= '';
  FInit:= nil;
  FResult:= nil;
end;

destructor TFunction.Destroy;
begin
  if FResult <> nil then
    FResult.Free;
  inherited;
end;

{ TTabelaFunctions }

procedure TTabelaFunctions.Add(var AFunction: TFunction);
begin
  FList.Add(AFunction)
end;

constructor TTabelaFunctions.Create;
begin
  inherited;
  FList:= TList.Create;
end;

destructor TTabelaFunctions.Destroy;
begin
  FList.Free;
  inherited;
end;

procedure TTabelaFunctions.Execute(AFunction: TFunction; AEnd: TToken);
begin

end;

function TTabelaFunctions.Get(const ANome: string): TFunction;
var
  i: Integer;
begin
  for i:= 0 to FList.Count-1 do
  begin
    Result:= FList[i];
    if Result.Nome = ANome then
      Exit;
  end;
  Result:= nil;
end;

{ TConnection }

procedure TConnection.Connect;
begin
  FConn:= TZConnection.Create(nil);
  FConn.Database:= FDatabase;
  FConn.User:= FUser;
  FConn.Password:= FPassword;
  case FProtocol of
    pcFirebird: FConn.Protocol:= 'firebird-2.0';
  end;
  FConn.Connect;
end;

constructor TConnection.Create(
  const AConnectionName: string;
  AProtocol: TProtocolConnection;
  const ADatabase: string;
  const AUser: string;
  const APassword: string);
begin
  FNome:= AConnectionName;
  FProtocol:= AProtocol;
  FDatabase:= ADatabase;
  FUser:= AUser;
  FPassword:= APassword;
  Connect;
end;

destructor TConnection.Destroy;
begin
  Disconnect;
  inherited;
end;

procedure TConnection.Disconnect;
begin
  if FConn <> nil then
    FConn.Free;
end;

{ TTabelaConnection }

procedure TTabelaConnection.Add(var AConn: TConnection);
begin
  FList.Add(AConn);
end;

constructor TTabelaConnection.Create;
begin
  FList:= TList.Create;
end;

destructor TTabelaConnection.Destroy;
begin
  FList.Free;
  inherited;
end;

function TTabelaConnection.Get(const ANome: string): TConnection;
var
  i: Integer;
begin
  for i:= 0 to FList.Count-1 do
  begin
    Result:= FList[i];
    if Result.Nome = ANome then
      Exit;
  end;
  Result:= nil;
end;

end.
