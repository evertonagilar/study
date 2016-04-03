program huffmann;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  HuffmannUtils in 'HuffmannUtils.pas';

var
  texto: string;
  Key: Char;

begin
  WriteLn('Implementacao do Algoritmo de Huffman em Delphi/Pascal');
  WriteLn('Aluno: Everton de Vargas Agilar');
  WriteLn('------------------------------------------');

  Write('Entre com um texto: ');
  Readln(texto);

  WriteLn('Resultado: '+ HuffmannCode(texto));

  WriteLn(#13#10'Pressione qualquer tecla para sair...'); Read(Key);
end.
