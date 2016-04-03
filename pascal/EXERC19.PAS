program Exerc19;

uses CRT;

const
  ValorConbustivel = 0.90;

var
  KMInicioDia: Real;
  KMFimDia: Real;
  LitrosConbustivelGasto: Real;
  ValorTotalRecebido: Real;
  ConsumoMedio: Real;
  LucroLiquido: Real;

begin
  ClrScr;
  WriteLn('Programa para calcular rendimento do carro');
  WriteLn('------------------------------------------------');

  WriteLn('Dados para calcular rendimento:');
  Write('Marcacao odometro (KM) inicio do dia: ');
  ReadLn(KMInicioDia);
  Write('Marcacao odometro (KM) fim do dia: ');
  ReadLn(KMFimDia);
  Write('Litros de combustivel gasto: ');
  ReadLn(LitrosConbustivelGasto);
  Write('Valor total recebido passageiros: ');
  ReadLn(ValorTotalRecebido);

  ConsumoMedio:= (KMFimDia - KMInicioDia) / ValorConbustivel;
  LucroLiquido:= ValorTotalRecebido - ((KMFimDia - KMInicioDia) * ValorConbustivel);

  WriteLn;
  WriteLn('Rendimento calculado:');
  WriteLn('Consumo Medio: ', ConsumoMedio:4:2, ' Km/L');
  WriteLn('Lucro liquido: R$ ', LucroLiquido:4:2);

  WriteLn;
  WriteLn('Pressione qualquer tecla para terminar...');
  ReadKey;

end.
