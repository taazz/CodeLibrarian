unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ExtCtrls, SynEdit, SynHighlighterPas, ActnList, StdActns, Menus,
  GpStructuredStorage;

type

  { TMainFrm }

  TMainFrm = class(TForm)
    aclMain : TActionList;
    actEditCopy : TEditCopy;
    actEditCut : TEditCut;
    actEditPaste : TEditPaste;
    actEditUndo : TEditUndo;
    actFileExit : TFileExit;
    actFileOpen : TFileOpen;
    imlMain : TImageList;
    MainMenu1 : TMainMenu;
    mnuFileOpen : TMenuItem;
    mnuExit : TMenuItem;
    mnuSepItem2 : TMenuItem;
    mnuCompact : TMenuItem;
    MnuSepItem1 : TMenuItem;
    MnuDelete : TMenuItem;
    mnuSnippetNew : TMenuItem;
    mnuFolderNew : TMenuItem;
    mnuRootFolderNew : TMenuItem;
    mnuNew : TMenuItem;
    mnuFile : TMenuItem;
    mnuEditUndo : TMenuItem;
    mnuEditPaste : TMenuItem;
    mnuEditCut : TMenuItem;
    mnuEditCopy : TMenuItem;
    mnuEdit : TMenuItem;
    dlgOpen : TOpenDialog;
    Splitter1 : TSplitter;
    StatusBar1 : TStatusBar;
    SynEdit1 : TSynEdit;
    SynPasSyn1 : TSynPasSyn;
    ToolBar1 : TToolBar;
    TreeView1 : TTreeView;
    procedure actFileOpenAccept(Sender : TObject);
    procedure TreeView1Change(Sender : TObject; Node : TTreeNode);
  private
    { private declarations }
    FCodeLib : IGpStructuredStorage;
    function GetNodePath(aNode:TTreeNode):String;
  public
    { public declarations }
    procedure Test;

    constructor Create(TheOwner : TComponent); override;

    Procedure LoadCodeLib;
  end;

var
  MainFrm : TMainFrm;

implementation

{$R *.lfm}
const
  CodeLibPathSep = '/';
  tpSnippet      = 1;
  tpFolder       = 2;

function addSlash(aItem:string):string;
begin
  if aItem[Length(aItem)] <> '/' then Result := aItem+'/' else Result := aItem;
end;

function MakeFileName(const FolderName, FileName: string): string;
begin
  Result := FolderName;
  if Result = '' then
    Result := CodeLibPathSep
  else
    Result := AddSlash(Result);
  if FileName <> '' then
  begin
    if FileName[1] = CodeLibPathSep then
      Result := Result + Copy(FileName, 2, 9999999)
    else
      Result := Result + FileName;
  end;
end;
{ TMainFrm }

procedure TMainFrm.actFileOpenAccept(Sender : TObject);
var
  vFName : String;
begin
  vFName := actFileOpen.Dialog.FileName;
  if FCodeLib.IsStructuredStorage(vFName) then FCodeLib.Initialize(vFName, fmOpenReadWrite or fmShareExclusive);
  LoadCodeLib;
end;

procedure TMainFrm.TreeView1Change(Sender : TObject; Node : TTreeNode);
var
  vFile : String;
  vStrm : TStream;
begin
  if Integer(Node.Data) = tpSnippet then begin
    vFile := GetNodePath(Node);
    vStrm := FCodeLib.OpenFile(vFile,fmOpenReadWrite);
    try
      SynEdit1.Lines.LoadFromStream(vStrm)
    finally
      vStrm.Free;
    end;
  end;
end;

function TMainFrm.GetNodePath(aNode : TTreeNode) : String;
var
  vNode : TTreeNode;
begin
  Result := '/';
  if not Assigned(aNode)then Exit;
  vNode := aNode;
  While vNode <> nil do begin
    Result :=  '/' + vNode.Text + Result;
    vNode  := vNode.Parent;
  end;
  if Integer(aNode.Data) = tpSnippet then SetLength(Result, Length(Result) - 1);
end;

procedure TMainFrm.Test;
begin
  canvas.brush.Style := bsSolid;
end;

constructor TMainFrm.Create(TheOwner : TComponent);
begin
  inherited Create(TheOwner);
  FCodeLib := CreateStorage;
end;

procedure TMainFrm.LoadCodeLib;
  procedure LoadNodeFolder(aNode:TTreeNode);
  var
    vNode           : TTreeNode;
    vFolders,VFiles : TStringList;
    vCnt            : Integer;
    vPath           : string;
  begin
    vFolders := TStringList.Create;
    VFiles   := TStringList.Create;
    try
      vPath := GetNodePath(aNode);
      vFolders.Clear;
      FCodeLib.FolderNames(vPath,vFolders);
      for vCnt := 0 to vFolders.Count -1 do begin
        vNode := TreeView1.Items.AddChild(aNode,vFolders[vCnt]);
        vNode.ImageIndex := 9;
        vNode.SelectedIndex := 9;
        vNode.Data := Pointer(tpFolder);
        LoadNodeFolder(vNode);
      end;
      FCodeLib.FileNames(vPath, VFiles);
      for vCnt := 0 to VFiles.Count -1 do begin
        vNode := TreeView1.Items.AddChild(aNode, VFiles[vCnt]);
        vNode.ImageIndex := 11;
        vNode.SelectedIndex := 11;
        vNode.Data := Pointer(tpSnippet);
      end;
    finally
      vFolders.Free;
      VFiles.Free;
    end;
  end;

begin
  TreeView1.Items.BeginUpdate;
  try
    TreeView1.SortType := stNone;
    LoadNodeFolder(nil);
    TreeView1.Selected := nil;
  finally
    TreeView1.SortType := stText;
    TreeView1.Items.EndUpdate;
  end;
end;

end.

