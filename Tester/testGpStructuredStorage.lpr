program testGpStructuredStorage;

{$MODE Delphi}

uses
  Forms, Interfaces,
  testGpStructuredStorage1 in 'testGpStructuredStorage1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
