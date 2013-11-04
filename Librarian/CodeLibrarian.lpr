program CodeLibrarian;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, uMainForm, GpLists, GpStructuredStorage, uOptions, lazcontrols, uVar;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TSnippetsMainFrm, SnippetsMainFrm);
  Application.CreateForm(TEvsOptionsForm, EvsOptionsForm);
  Application.Run;
end.

