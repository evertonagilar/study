unit HuffmannUtils;

interface

uses SysUtils, Classes;

type
  TCaracter = class
  private
    FTop: TCaracter;
    FProbalidade: Real;
    FEsq: TCaracter;
    FDir: TCaracter;
    FCaracter: Char;
    FBit: Byte;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    property Probalidade: Real read FProbalidade write FProbalidade;
    property Top: TCaracter read FTop write FTop;
    property Esq: TCaracter read FEsq write FEsq;
    property Dir: TCaracter read FDir write FDir;
    property Caracter: Char read FCaracter write FCaracter;
    property Bit: Byte read FBit write FBit;
  end;

function HuffmannCode(const S: string): string;

implementation

function GetStringOfUniqueChars(const S: string): string;
var
  i: Integer;
  ch: Char;
begin
  Result:= '';
  for i:= 1 to Length(S) do
  begin
    ch:= S[i];
    if Pos(ch, Result) = 0 then
      Result:= Result + ch;
  end;
end;

function getQtdChar(ch: Char; const S: string): Integer;
var
  i: Integer;
begin
  Result:= 0;
  for i:= 1 to Length(S) do
  begin
    if ch = S[i] then
      Inc(Result);
  end;
end;

function SortCompare(Item1, Item2: Pointer): Integer;
begin
  if TCaracter(Item1).Probalidade = TCaracter(Item2).Probalidade then
    Result:= 0
  else if TCaracter(Item1).Probalidade > TCaracter(Item2).Probalidade then
    Result:= 1
  else
    Result:= -1;
end;

function HuffmannCode(const S: string): string;
var
  i: Integer;
  List, List2: TList;
  unique_str: string;
  ch: Char;
  C, C2, C3: TCaracter;

  function getCodigo(Ch: Char): string;
  var
    p: TCaracter;
    i: Integer;
  begin
    p:= nil;
    for i:= 0 to List2.Count-1 do
    begin
      if TCaracter(List2[i]).Caracter = Ch then
      begin
        p:= TCaracter(List2[i]);
        Break;
      end;
    end;

    Result:= '';
    while (p.Top <> nil) do
    begin
      Result:= IntToStr(p.Bit) + Result;
      p:= p.Top;
    end;
  end;

begin
  Result:= '';
  List:= TList.Create;
  List2:= TList.Create;
  try
    // Cria a lista de caracteres com suas respectivas probalidades
    unique_str:= GetStringOfUniqueChars(S);
    for i:= 1 to Length(unique_str) do
    begin
      ch:= unique_str[i];
      C:= TCaracter.Create;
      C.Probalidade:= getQtdChar(ch, S) / Length(S);
      C.Caracter:= ch;
      C.Top:= nil;
      List.Add(C);
      List2.Add(C);
    end;
    List.Sort(@SortCompare);

    if List.Count = 1 then
    begin
      Result:= '1';
      Exit;
    end;  

    // Monta a árvore de probalidades
    for i:= 1 to List.Count-1 do
    begin
      C:= List[0];
      C2:= List[1];
      C3:= TCaracter.Create;
      C3.Probalidade:= C.Probalidade + C2.Probalidade;
      C3.Esq:= C;
      C.Bit:= 0;
      C.Top:= C3;
      C3.Dir:= C2;
      C2.Bit:= 1;
      C2.Top:= C3;
      List.Add(C3);
      List.Remove(C);
      List.Remove(C2);
      List.Sort(@SortCompare);
    end;

    for i:= 1 to Length(unique_str) do
     WriteLn(unique_str[i] + ' = ' + getCodigo(unique_str[i]));

    // Retorna o código de huffmann
    for i:= 1 to Length(S) do
    begin
      ch:= S[i];
      Result:= Result + getCodigo(ch);
    end;

  finally
    List.Free;
    List2.Free;
  end;
end;

{ TCaracter }

constructor TCaracter.Create;
begin
  FProbalidade:= 0;
  FTop:= nil;
  FEsq:= nil;
  FDir:= nil;
  FCaracter:= #0;
  FBit:= 0;
end;

destructor TCaracter.Destroy;
begin
  inherited;
end;


end.
