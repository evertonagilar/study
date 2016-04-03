create or replace package pkg_comercial is

  -- Author  : AGILAR
  -- Created : 14/09/2010 19:27:55
  -- Purpose : 
  
  type TSemana is table of varchar2(30) index by varchar2(30);
 
  
  
  type TCliente is record (
    id number(12),
    nome varchar2(100),
    cpf varchar2(18)       
  ); 
 
  type TListaClientes is table of TCliente;
  
  MIN_VALOR_FATURA constant pls_integer := 0;

  function getDadosSegundaViaFatura(
      vIdCliente in pls_integer,
      vCliente out TCliente) return boolean;

  procedure getListaClientes(vListaClientes out TListaClientes);

  procedure ExportaCadastroCliente;
  procedure ImportaCadastroCliente(file_name varchar2);
    
  vQtdClientes pls_integer;
  vDiasSemana TSemana;
  
  function EnviaEmailPolidados(mensagem in varchar2) return boolean;
  

end pkg_comercial;
/
create or replace package body pkg_comercial
is
  procedure ExportaCadastroCliente
  is
    cursor cliente_cursor is
      select id, nome, cpf 
      from cliente
      order by nome, cpf;
    cli cliente_cursor%rowtype;  
    arqCli utl_file.file_type;
  begin    
    open cliente_cursor;
    fetch cliente_cursor 
    into cli;
    
    arqCli := utl_file.fopen('DIR_TEMP', 'arq_cli.txt', 'w');
    
    while cliente_cursor%found loop
      utl_file.put(arqCli, lpad(cli.id, 13, ' '));
      utl_file.put(arqCli, rpad(cli.nome, 50, ' '));
      utl_file.put(arqCli, lpad(cli.cpf, 14, '0'));
      utl_file.new_line(arqCli);
      fetch cliente_cursor into cli;
    end loop;
    
    utl_file.fclose(arqCli);    
  
  exception
    when utl_file.write_error then
      raise_application_error(-20001, 'Ocorreu erro de escrita!');
    when utl_file.invalid_path then
      raise_application_error(-20002, 'Caminho inválido!');
    when utl_file.access_denied then
      raise_application_error(-20003, 'Acesso negado ao arquivo!');
    when utl_file.invalid_filename then
      raise_application_error(-20004, 'Nome do arquivo invalido!');
  end;  

  procedure ImportaCadastroCliente(file_name varchar2)
  is
    arqCli utl_file.file_type;
    linha varchar2(250);
    id cliente.id%type;
    nome cliente.nome%type;
    cpf cliente.cpf%type;
  begin
    arqCli:= utl_file.fopen('DIR_TEMP', file_name, 'R');
    
    begin
      loop
        utl_file.get_line(arqCli, linha, 250);
        
        id:= trim(substr(linha, 1, 13));
        nome:= trim(substr(linha, 14, 50));
        cpf:= trim(substr(linha, 64, 14));
        
        begin
          insert into cliente_temp(id, nome, cpf)
          values (id, nome, cpf);
        exception
          when dup_val_on_index then
            dbms_output.put_line('Cliente duplicado: '|| sqlerrm);  
        end;
      end loop;
    exception
      when no_data_found then
        null;        
    end;  
    
    commit;
    
  exception
    when utl_file.invalid_path then   
      rollback;
      raise_application_error(-20002, 'Caminho inválido!');
    when utl_file.read_error then   
      rollback; 
      raise_application_error(-20001, 'Ocorreu erro de leitura!');
  end;     


  function getDadosSegundaViaFatura(
      vIdCliente in pls_integer,
      vCliente out TCliente) return boolean
  is
  begin
    begin
      select c.id, c.nome, c. cpf 
          into vCliente
      from cliente c
      where id = vIdCliente; 
      
      return true;
    exception
      when no_data_found then
        return false; 
    end;    
  end;      

  procedure getListaClientes(vListaClientes out TListaClientes)
  is
    type TListatmp is table of Cliente%rowtype;
    listatmp TListatmp;
  begin
    -- obtém a lista de clientes
    select * 
      bulk collect into listatmp
    from cliente 
    where id < 4;
    
    -- Cria a lista se não existir
    if vListaClientes is null then
      vListaClientes:= TListaClientes();
    end if;  
    
    -- copia para vListaClientes
    for i in listatmp.first..listatmp.last loop
        vListaClientes.extend();
        vListaClientes(i):= listatmp(i);
    end loop;    
  
  end; 

  function EnviaEmailPolidados(mensagem in varchar2) return boolean
  is 
    conexao utl_smtp.connection;
    EmailServer constant varchar2(30):= '69.65.41.101';
    SenderAddress constant varchar2(40):= 'everton@polidados.com';
    ReceiverAddress constant varchar2(40):= 'everton_ti07@yahoo.com.br';
    msg varchar2(1000);
    CRLF constant varchar2(2):= chr(13) || chr(10);
  begin
    conexao:= utl_smtp.open_connection(EmailServer, 25);
    utl_smtp.helo(conexao, EmailServer);

    utl_smtp.mail(conexao, SenderAddress);
    utl_smtp.rcpt(conexao, ReceiverAddress);
    
    utl_smtp.command(conexao, 'AUTH LOGIN'); 
    utl_smtp.command(conexao,utl_raw.cast_to_varchar2(utl_encode.base64_encode(utl_raw.cast_to_raw('everton@polidados.com')))); 
    utl_smtp.command(conexao,utl_raw.cast_to_varchar2(utl_encode.base64_encode(utl_raw.cast_to_raw('*000222*')))); 
    
    msg:= 'From:' || SenderAddress || CRLF ||
          'Subject: Teste de e-mail enviado pelo servidor ORACLE' || CRLF ||
          'To:' || ReceiverAddress || CRLF ||
          '' || CRLF ||
          'Este e-mail foi enviado pelo servidor oracle xe!';
          
    utl_smtp.data(conexao, msg);
    utl_smtp.quit(conexao);
  
    return true;
    
  exception
    when utl_smtp.invalid_operation then
    begin  
      raise_application_error(-20001, 'Operação inválido ao enviar e-mail: '|| sqlcode || '-' || sqlerrm);
      return false;
    end;  
    when utl_smtp.transient_error then
    begin  
      raise_application_error(-20002, 'Transient error ao enviar e-mail: '|| sqlcode || '-' || sqlerrm);
      return false;
    end;  
    when utl_smtp.permanent_error then
    begin  
      raise_application_error(-20003, 'Erro permanent ao enviar e-mail: '|| sqlcode || '-' || sqlerrm);
      return false;
    end; 
    when others then
    begin  
      raise_application_error(-20004, 'Erro desconhecido: '|| sqlcode || '-' || sqlerrm);
      return false;
    end;  
  end;
  
  

begin
  vQtdClientes:= 100; 
  
  vDiasSemana('segunda') := 'Segunda-feira';
  vDiasSemana('terca')   := 'Terça-Feira';
  vDiasSemana('quarta')  := 'Quarta-Feira';

end pkg_comercial;
/
