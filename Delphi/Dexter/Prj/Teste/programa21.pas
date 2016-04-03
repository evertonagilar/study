program programa21;

  //********************************************************************
  // Programa: programa21
  // Objetivo: Demonstrar os operadores da linguagem Dexter
  // Autor: Everton de Vargas Agilar
  // Data: 05/08/2007
  //********************************************************************

var
  opcao: Integer;
begin
   WriteLn('Programa para demonstrar operadores da linguagem Dexter');
   WriteLn('--------------------------------------------------------');
   WriteLn('Para sair pressione Ctrl + C');
   WriteLn();
   WriteLn();
                       
   WriteLn('Analisar: (50 * (2 / 3) > 30)                  // 50 * (2 / 3) = ', 50 * (2 / 3));
    if (50 * (2 / 3) > 30) then
      WriteLn('Verdadeiro')
    else
      WriteLn('Falso');
    WriteLn();

   WriteLn('Analisar: (((50) * (2 / (3))) > 30)            // ((50) * (2 / (3))) = ', ((50) * (2 / (3))));
    if (((50) * (2 / (3))) > 30) then
      WriteLn('Verdadeiro')
    else
      WriteLn('Falso');
    WriteLn();

   WriteLn('Analisar: 50 * (2 / 3) > 30                    // ', 50 * (2 / 3), ' > 30');
    if 50 * (2 / 3) > 30 then
      WriteLn('Verdadeiro')
    else
      WriteLn('Falso');
    WriteLn();

   WriteLn('Analisar: 50 * 2 / 3 > 30                      // ', 50 * 2 / 3, ' > 30');
    if 50 * 2 / 3 > 30 then
      WriteLn('Verdadeiro')
    else
      WriteLn('Falso');
    WriteLn();

   WriteLn('Analisar: (50 * 2 / 3) > 30');
    if (50 * 2 / 3) > 30 then
      WriteLn('Verdadeiro')
    else
      WriteLn('Falso');
    WriteLn();


    WriteLn('Analisar: 1 + 2 != 3');
    if 1 + 2 != 3 then
      WriteLn('Verdadeiro')
    else
      WriteLn('Falso');
    WriteLn();

    WriteLn('Analisar: 1 + 2 <> 3');
    if 1 + 2 != 3 then
      WriteLn('Verdadeiro')
    else
      WriteLn('Falso');
    WriteLn();

    WriteLn('Analisar: 5 - 5 * 2 != 5', '                       // 5 - 5 * 2 = ', 5 - 5 * 2);
    if 5 - 5 * 2 != 5 then
      WriteLn('Verdadeiro')
    else
      WriteLn('Falso');
    WriteLn();

    WriteLn('Analisar: 1 < 2 || 3 > 4 && 1 + 1 = 2');
    if 1 < 2 || 3 > 4 && 1 + 1 = 2 then
      WriteLn('Verdadeiro')
    else
      WriteLn('Falso');
    WriteLn();

    WriteLn('Analisar: 3 > 4 && 1 + 1 = 2 || 1 < 2');
    if 3 > 4 && 1 + 1 = 2 || 1 < 2 then
      WriteLn('Verdadeiro')
    else
      WriteLn('Falso');
    WriteLn();

    WriteLn('Analisar: 3 > 4 && 1 + 1 = 2 || 1 < (2+1*2)*2+2 || 1 < 1+1');
    if 3 > 4 && 1 + 1 = 2 || 1 < (2+1*2)*2+2 || 1 < 1+1 then
      WriteLn('Verdadeiro')
    else
      WriteLn('Falso');
    WriteLn();

    WriteLn('Analisar: 3 > 4 && 1 + 1 = 2 || 11+2*2 < (2+1*2)*2+2 || 100 < 1+1');
    if 3 > 4 && 1 + 1 = 2 || 11+2*2 < (2+1*2)*2+2 || 100 < 1+1 then
      WriteLn('Verdadeiro')
    else
      WriteLn('Falso');
    WriteLn();

    WriteLn('Analisar: 3 > (4) && 1 + 1 = (2) || ((11))+2*2 < ((2+1*2)*2+(2)) || ((((100)))) < ((1)+(1))');
    if 3 > (4) && 1 + 1 = (2) || ((11))+2*2 < ((2+1*2)*2+(2)) || ((((100)))) < ((1)+(1)) then
      WriteLn('Verdadeiro')
    else
      WriteLn('Falso');
    WriteLn();

   WriteLn('Analisar: 3 > 4 and 1 + 1 = 2 && 2 = 3 or 1 < 0 or 3 <> 3 || 4 > 1');
    if 3 > 4 and 1 + 1 = 2 && 2 = 3 or 1 < 0 or 3 <> 3 || 4 > 1 then
      WriteLn('Verdadeiro')
    else
      WriteLn('Falso');
    WriteLn();

   WriteLn('Analisar: (3 < 4 && 4 < 5) && (2 != 1 + 1) && (2 <> 1 + 1) || ((50 * 2 / 3) > 30)                    // Dexter And/Or Style');
    if (3 < 4 && 4 < 5) && (2 != 1 + 1) && (2 <> 1 + 1) || (50 * 2 / 3 > 30) then
      WriteLn('Verdadeiro')
    else
      WriteLn('Falso');
    WriteLn();

   WriteLn('Analisar: (3 < 4) and (4 < 5) and (2 <> 1 + 1) and (2 <> 1 + 1) or ((50 * 2 / 3) > 30)               // Pascal And/Or Style');
    if (3 < 4) and (4 < 5) and (2 <> 1 + 1) and (2 <> 1 + 1) or (50 * 2 / 3 > 30) then
      WriteLn('Verdadeiro')
    else
      WriteLn('Falso');
    WriteLn();

   WriteLn('Analisar: 10+2*100-100/2 = 10+2*100-100/2                           // 10+2*100-100/2 = ', 10+2*100-100/2);
    if 10+2*100-100/2 = 10+2*100-100/2 then
      WriteLn('Verdadeiro')
    else
      WriteLn('Falso');
    WriteLn();

   WriteLn('1 - Analisar: 10 !< 9                       // Dexter Op. Relacional Style');
   WriteLn('2 - Analisar: 2 + 2 * 10 !> 10');
   WriteLn('3 - Analisar: 6 !>= 10');
   WriteLn('4 - Analisar: 4 * 10 !<= 40');

    if 10 !< 9 then
      WriteLn('1 - Verdadeiro')
    else
      WriteLn('1 - Falso');

    if 2 + 2 * 10 !> 10 then
      WriteLn('2 - Verdadeiro')
    else
      WriteLn('2 - Falso');

    if 6 !>= 10 then
      WriteLn('3 - Verdadeiro')
    else
      WriteLn('3 - Falso');

    if 4 * 10 !<= 40 then
      WriteLn('4 - Verdadeiro')
    else
      WriteLn('4 - Falso');
    WriteLn();

    WriteLn('--------------------------------------------------------');
    ReadLn(opcao);

    {
    if !(i > !2) && 2 = 2 then
      WriteLn('!(i > !2) && 2 = 2', ' = ', ' verdade')
    else
      WriteLn('!(i > !2) && 2 = 2', ' = ', ' falso');

    if i !> 2 then
      WriteLn('i !> 2', ' = ', ' verdade')
    else
      WriteLn('i !> 2', ' = ', ' falso');

    if i = !2 then
      WriteLn('i = !2', ' = ', ' verdade')
    else
      WriteLn('i = !2', ' = ', ' falso');

    if not (i > 2) then
      WriteLn('not (i > 2)', ' verdade')
    else
      WriteLn('not (i > 2)', ' falso');

    if i <= 2 then
      WriteLn('i <= 2', ' verdade')
    else
      WriteLn('i <= 2', ' falso');

    if !true then
      WriteLn('!true', ' verdade')
    else
      WriteLn('!true', ' falso');

    if not true then
      WriteLn('not true', ' verdade')
    else
      WriteLn('not true', ' falso')

    if i !<> 2 then
      WriteLn('i !<> 2', ' verdade')
    else
      WriteLn('i !<> 2', ' falso');
}

end.
