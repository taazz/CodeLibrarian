unit uVar;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SynEditHighlighter;

const
  cCodeLibPathSep     = '/';

type
  PHighlighterData = ^THighlighterData;
  THighlighterData = record
    Title             : string;
    Instance          : TSynCustomHighlighter;
    IconIndexNormal,
    IconIndexSelected : integer;
  end;

  StringArray = array of string;

function ConfigFileName         : string;
function AddSlash(aItem:string) : string;
function ApplicationFolder      : string; inline;

implementation
uses Forms;

function AddSlash(aItem:string):string;
var
  vTmp : array of string;
begin
  if aItem[Length(aItem)] <> cCodeLibPathSep then Result := aItem + cCodeLibPathSep else Result := aItem;
end;


function CreateAppConfigDir:string;
begin
  Result := GetAppConfigDir(False);
  if not DirectoryExists(Result) then
    if not ForceDirectories(Result) then Result := '';/// else vDir := '';
end;

function ConfigFileName : string;
var
  vFn : string;
begin
  vFn := ChangeFileExt(Application.ExeName,'.cfg');
  if FileExists(vFn) then //in case of portable make sure that the config is at the same directory as the program.
    Result := vFn
  else begin
    Result := CreateAppConfigDir;
    Result := IncludeTrailingPathDelimiter(Result) + ExtractFileName(vFn);
  end;
end;

function EvosiVendorName : String;
begin
  Result := 'Evosi';
end;

function ApplicationFolder : string; inline;
begin
  Result := ExtractFilePath(Application.ExeName);
end;

initialization
  OnGetVendorName := @EvosiVendorName;
end.

