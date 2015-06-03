program CodeLibrarian;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  sysutils,
  Forms, lazcontrols, uMainForm, GpLists, GpStructuredStorage, uOptions,
  uVar, uEvsSynhighlightersql, StrConst;

{$R *.res}

  {.$Μ+}
begin
  {$IFDEF DEBUG}
  SetHeapTraceOutput(ChangeFileExt(Application.ExeName, '.htr'));
  {$ENDIF}
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TSnippetsMainFrm, SnippetsMainFrm);
  Application.CreateForm(TEvsOptionsForm, EvsOptionsForm);
  Application.Run;
end.

