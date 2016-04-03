
 {******************************************************************}
 { Trabalho de Estrutura de Dados                                   }
 { Inser��o e Remo��o de dados de uma ABP                           }
 {                                                                  }
 { Alunos: Everton de Vargas Agilar                                 }
 {         Juliano                                                  }
 {                                                                  }
 { Sistemas de Informa��o - Noturno                                 }
 {******************************************************************}


program Trabalho;

uses SysUtils;

{$AppType Console}

type
  PElemento = ^Elemento;
  Elemento = record
    valor: Integer;
    esq: PElemento;
    dir: PElemento;
  end;

function Inserir(arv: PElemento; valor: Integer): PElemento;
var
  novo: PElemento;
begin
  New(novo);
  novo^.valor:= valor;
  novo^.esq:= nil;
  novo^.dir:= nil;

  if arv = nil then
    Inserir:= novo
  else
  begin
    if valor > arv^.valor then
    begin
      if arv^.dir <> nil then
        Inserir(arv^.dir, valor)
      else
        arv^.dir:= novo;
    end
    else if valor < arv^.valor then
    begin
      if arv^.esq <> nil then
        Inserir(arv^.esq, valor)
      else
        arv^.esq:= novo;
    end;

    Inserir:= arv;
  end;
end;

function Busca(arv: PElemento; valor: Integer): PElemento;
begin
  Busca:= nil;
  if arv <> nil then
  begin
    if valor = arv^.valor then
      Busca:= arv
    else if (valor > arv^.valor) and (arv^.dir <> nil) then
      Busca:= Busca(arv^.dir, valor)
    else if (valor < arv^.valor) and (arv^.esq <> nil) then
      Busca:= Busca(arv^.esq, valor);
  end;
end;

function BuscaNoENoAnterior(arv: PElemento; valor: Integer; var NoAnt: PElemento): PElemento;
begin
  BuscaNoENoAnterior:= nil;
  if arv <> nil then
  begin
    if valor = arv^.valor then
      BuscaNoENoAnterior:= arv
    else if (valor > arv^.valor) and (arv^.dir <> nil) then
    begin
      BuscaNoENoAnterior:= BuscaNoENoAnterior(arv^.dir, valor, arv);
      NoAnt:= arv;
    end
    else if (valor < arv^.valor) and (arv^.esq <> nil) then
    begin
      BuscaNoENoAnterior:= BuscaNoENoAnterior(arv^.esq, valor, arv);
      NoAnt:= arv;
    end;
  end;
end;

function MaiorNo(No: PElemento; var NoAnt: PElemento): PElemento;
begin
  NoAnt:= nil;
  while No <> nil do
  begin
    if No^.dir <> nil then
    begin
      NoAnt:= No;
      No:= No^.dir;
    end
    else
      Break;
  end;
  MaiorNo:= No;
end;

procedure Remover(arv: PElemento; valor: Integer);
var
  no, noAnt, p: PElemento;
begin
  if arv <> nil then
  begin
    noAnt:= nil;
    no:= BuscaNoENoAnterior(arv, valor, noAnt);
    if no <> nil then
    begin
      // 1� caso: Se o n� � uma folha
      // Temos que remover a folha e fazer com que o n� anterior aponte para nil
      if (No^.esq = nil) and (no^.dir = nil) then
      begin
        if no^.valor > noAnt^.valor then
          noAnt^.dir:= nil
        else
          noAnt^.esq:= nil;
        Dispose(no);
      end
      else
      begin
        // 2� Caso: O n� n�o � folha e possui apenas uma sub-�rvore
        // Nesse caso temos que promover a sub-�rvore � posi��o do n� a ser excluido
        if (no^.esq = nil) xor (no^.dir = nil) then
        begin
          // Obt�m a sub�rvore a ser promovida
          if no^.dir <> nil then
            p:= no^.dir
          else
            p:= no^.esq;

          if noAnt <> nil then
          begin
            // Insere na posi��o do n� a ser excluido
            if no^.valor < noAnt^.valor then
              noAnt^.esq:= p
            else
              noAnt^.dir:= p;
            Dispose(no);
          end
          else
          begin
            no^.valor:= p^.valor;
            if no^.dir <> nil then
              no^.dir:= p^.dir
            else
              no^.esq:= p^.esq;
          end;
        end
        else
        begin
          // 3�: Excluir um n� que possui as duas subchaves
          // Nesse caso temos que substituir o conte�do do n�
          // a ser exclu�do pelo conte�do do n� da subarvore
          // da esquerda que possui o maior valor. Logo
          // a seguir a chave promovida � excluida.
          p:= MaiorNo(No^.esq, noAnt);
          No^.valor:= p^.valor;
          if no^.esq = p then
            No^.esq:= p^.esq
          else
          begin
            if noAnt <> nil then
            begin
              if p^.valor > NoAnt^.valor then
                NoAnt^.dir:= nil
              else
                NoAnt^.esq:= nil;
            end;
          end;
          Dispose(p);
        end;
      end;
    end;
  end;
end;

procedure Posfixado(arv: PElemento);
begin
  if arv <> nil then
  begin
    if arv^.esq <> nil then
      Posfixado(arv^.esq);
    if arv^.dir <> nil then
      Posfixado(arv^.dir);
    Writeln(arv^.valor, ' ');
  end;
end;

procedure Prefixado(arv: PElemento);
begin
  if arv <> nil then
  begin
    Writeln(arv^.valor, ' ');
    if arv^.esq <> nil then
      Posfixado(arv^.esq);
    if arv^.dir <> nil then
      Posfixado(arv^.dir);
  end;
end;

procedure Central(arv: PElemento);
begin
  if arv <> nil then
  begin
    if arv^.esq <> nil then
      Posfixado(arv^.esq);
    Writeln(arv^.valor, ' ');
    if arv^.dir <> nil then
      Posfixado(arv^.dir);
  end;    
end;

var
  key: Char;
  arv: PElemento;
  no, NoAnt: PElemento;
begin
  WriteLn('Trabalho de Estrutura de Dados - Excluir No Arvore Binaria Busca');
  WriteLn('Alunos: Everton de Vargas Agilar ');
  WriteLn('        Juliano');

  arv:= nil;

  // Inserindo dados
  arv:= Inserir(arv, 10);
  arv:= Inserir(arv, 15);
  arv:= Inserir(arv, 20);
  arv:= Inserir(arv, 5);
  arv:= Inserir(arv, 3);
  arv:= Inserir(arv, 13);
  arv:= Inserir(arv, 14);
  arv:= Inserir(arv, 50);
  arv:= Inserir(arv, 51);
  arv:= Inserir(arv, 1);


  WriteLn('Prefixado:');
  Prefixado(arv);

  WriteLn;
  WriteLn('Central:');
  Central(arv);

  WriteLn;
  WriteLn('Posfixado:');
  Posfixado(arv);

  // Removendo dados
  Remover(arv, 15);
  Remover(arv, 13);
  Remover(arv, 14);
  Remover(arv, 50);
  Remover(arv, 10);
  Remover(arv, 1);
  Remover(arv, 5);
  Remover(arv, 3);

  ReadLn(key);

end.
