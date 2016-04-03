program sql1;


var conn1 as connection;
var conn2 as connection;
begin
  WriteLn('Programa Teste SQL1');


  // Cria a conexão
  create connection conn1
  database 'c:\poligestor\db\poligestor.fdb'
  protocol oracle
  user 'sysdba'
  password 'masterkey';

  create connection conn2
  database 'c:\poligestor\db\poligestor.fdb'
  protocol mysql
  user 'sysdba'
  password 'masterkey';


  select conn1.estoque.descricao,
         conn1.aliquota.descricao,
         conn2.estoque 
  from conn1.estoque join conn1.aliquota
    on conn1.estoque.idaliquota = conn1.aliquota.id
  into vDescricao;







end.