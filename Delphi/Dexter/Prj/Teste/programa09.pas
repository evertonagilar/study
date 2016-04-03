program programa09;

  //********************************************************************
  //
  // Programa: programa09
  // Objetivo: Demonstração do compilador Dexter com os recursos da linguagem.
  //
  // Data: 07/07/2007
  //
  //********************************************************************

var
  opcao: Integer;
  continua: Boolean;

procedure PrintMenu();
begin
  WriteLn('Programa para demonstrar o compilador Dexter');
  WriteLn('---------------------------------------------');
  WriteLn();
  WriteLn('               *** Controle de Estoque ***');
  WriteLn('               ---------------------------');
  WriteLn('               1 - Cadastro de Produtos');
  WriteLn('               2 - Cadastro de Grupos');
  WriteLn('               3 - Cadastro de Clientes');
  WriteLn('               4 - Cadastro de Fornecedores');
  WriteLn('               5 - Movimentos');
  WriteLn('               6 - Relatorios');
  WriteLn('               7 - Configuracao');
  WriteLn('               8 - Sair');
end;

function GetOpcao(): Integer;
begin
  Write('Opcao: ');
  ReadLn(opcao);
  WriteLn();
  Result:= opcao;
end;

begin
  continua:= true;
  while continua do
  begin
    PrintMenu();
    opcao:= GetOpcao();
    if opcao = 1 then
      WriteLn('Cadastro de produtos')
    else if opcao = 2 then
      WriteLn('Cadastro de Grupos')
    else if opcao = 3 then
      WriteLn('Cadastro de Clientes')
    else if opcao = 4 then
    begin
      WriteLn('Cadastro de Fornecedores');
    end
    else if opcao = 5 then
      WriteLn('Movimentos')
    else if opcao = 6 then
      WriteLn('Relatorios')
    else if opcao = 7 then
    begin
      WriteLn('Configuracao');

    end
    else if opcao = 8 then
    begin
      WriteLn('Sair');
      continua:= false;
    end;
  end;
end.

