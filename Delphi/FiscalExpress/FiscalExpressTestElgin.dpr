// Uncomment the following directive to create a console application
// or leave commented to create a GUI application... 
// {$APPTYPE CONSOLE}

program FiscalExpressTestElgin;

uses
  TestFramework {$IFDEF LINUX},
  QForms,
  QGUITestRunner {$ELSE},
  Forms,
  GUITestRunner {$ENDIF},
  TextTestRunner,
  TestElgin in 'dunit\TestElgin.pas',
  UnTestImpInt in 'dunit\UnTestImpInt.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title:= 'Casos de Teste Impressora Elgin';

{$IFDEF LINUX}
  QGUITestRunner.RunRegisteredTests;
{$ELSE}
  if System.IsConsole then
    TextTestRunner.RunRegisteredTests
  else
    GUITestRunner.RunRegisteredTests;
{$ENDIF}

end.

 