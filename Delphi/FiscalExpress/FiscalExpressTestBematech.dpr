// Uncomment the following directive to create a console application
// or leave commented to create a GUI application... 
// {$APPTYPE CONSOLE}

program FiscalExpressTestBematech;

uses
  ShareMem,
  TestFramework {$IFDEF LINUX},
  QForms,
  QGUITestRunner {$ELSE},
  Forms,
  GUITestRunner {$ENDIF},
  TextTestRunner,
  TestBematech in 'dunit\TestBematech.pas',
  UnTestImpInt in 'dunit\UnTestImpInt.pas';

{$R *.RES}

begin
  Application.Initialize;
  GUITestRunner.RunRegisteredTests;
  Application.Title := 'Casos de Teste Impressora Bematech :: Por Everton Agilar Atualizado em 28/12/2009';
  GUITestRunner.RunRegisteredTests;

end.

