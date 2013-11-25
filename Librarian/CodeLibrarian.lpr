program CodeLibrarian;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, uMainForm, GpLists, GpStructuredStorage, uOptions, lazcontrols, uVar,
  uEvsSynhighlightersql, StrConst;

{$R *.res}

begin
  {$IFDEF DEBUG}
  SetHeapTraceOutput('Trace.htr');
  {$ENDIF}
  {$Μ+}
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TSnippetsMainFrm, SnippetsMainFrm);
  Application.CreateForm(TEvsOptionsForm, EvsOptionsForm);
  Application.Run;
end.

