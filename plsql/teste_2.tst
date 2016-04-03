PL/SQL Developer Test script 3.0
15
-- Created on 20/09/2010 by AGILAR 
declare 
  -- Local variables here
  i integer;
  ok boolean;
begin
  ok:= pkg_comercial.EnviaEmailPolidados('Envio de email teste');
  if ok then
     dbms_output.put_line('Email enviado com sucesso!');
  else
    dbms_output.put_line('Email não foi enviado com sucesso!');
  end if;  
       
  
end;
0
0
