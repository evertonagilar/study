PL/SQL Developer Test script 3.0
15
-- Created on 14/09/2010 by AGILAR 
declare 
  -- Local variables here
  i integer;
  vResult boolean;
  MeuCliente pkg_comercial.TCliente;
begin
  vResult:= pkg_comercial.getDadosSegundaViaFatura(vIdCliente => 1,  vCliente => MeuCliente);
  if vResult then
    dbms_output.put_line('encontrado!');
    dbms_output.put_line(MeuCliente.nome || ' CPF: ' || MeuCliente.cpf);
  else
    dbms_output.put_line('não encontrado!');
  end if;  
end;
0
0
