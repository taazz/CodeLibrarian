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
    actFolderRootNew : TAction;
    actFolderNew : TAction;
    actDelete : TAction;
    actExpandAll : TAction;
    actCollapseAll : TAction;
    actSnippetNew : TAction;
    actSnippetSave : TAction;
    actFileNew : TFileOpen;
    imlMain : TImageList;
    mnuMain : TMainMenu;
    MenuItem1 : TMenuItem;
    mniSepItem4 : TMenuItem;
    mniNewLibrary : TMenuItem;
    mniSepItem3 : TMenuItem;
    mniFileOpen : TMenuItem;
    mniExit : TMenuItem;
    mniSepItem2 : TMenuItem;
    miCompact : TMenuItem;
    mniSepItem1 : TMenuItem;
    mniDelete : TMenuItem;
    mniSnippetNew : TMenuItem;
    mniFolderNew : TMenuItem;
    mniRootFolderNew : TMenuItem;
    mniNew : TMenuItem;
    mnuFile : TMenuItem;
    mnuEditUndo : TMenuItem;
    mnuEditPaste : TMenuItem;
    mnuEditCut : TMenuItem;
    mnuEditCopy : TMenuItem;
    mnuEdit : TMenuItem;
    Splitter1 : TSplitter;
    StatusBar1 : TStatusBar;
    snEditor : TSynEdit;
    shlPascal : TSynFreePascalSyn;
    ToolBar1 : TToolBar;
    btnFileOpen : TToolButton;
    btnExpandAll : TToolButton;
    btnCollapseAll : TToolButton;
    ToolButton12 : TToolButton;
    btnSnippetNew : TToolButton;
    btnFolderRootNew : TToolButton;
    btnFolderNew : TToolButton;
    ToolButton4 : TToolButton;
    btnEditCopy : TToolButton;
    btnEditCut : TToolButton;
    btnEditPaste : TToolButton;
    btnEditUndo : TToolButton;
    ToolButton9 : TToolButton;
    tvData : TTreeView;
    procedure actCollapseAllExecute(Sender : TObject);
    procedure actDeleteExecute(Sender : TObject);
    procedure actDeleteUpdate(Sender : TObject);
    procedure actExpandAllExecute(Sender : TObject);
    procedure actFileNewAccept(Sender : TObject);
    procedure actFileOpenAccept(Sender : TObject);
    procedure actFolderNewExecute(Sender : TObject);
    procedure actFolderRootNewExecute(Sender : TObject);
    procedure actSnippetSaveExecute(Sender : TObject);
    procedure actSnippetSaveUpdate(Sender : TObject);
    procedure snEditorExit(Sender : TObject);
    procedure tvDataChange(Sender : TObject; Node : TTreeNode);
    procedure tvDataChanging(Sender : TObject; Node : TTreeNode;
      var AllowChange : Boolean);
    procedure tvDataEdited(Sender : TObject; Node : TTreeNode; var S : string
      );
  private
    { private declarations }
    FCodeLib : IGpStructuredStorage;
    function GetNodePath(aNode:TTreeNode):String;
    function IsFolder(aNode:TTreeNode):Boolean;
    function IsFile(aNode:TTreeNode):Boolean;
    function UniqueName(aPath:String;Folder:Boolean):string;
    function NewNode(const aParent:TTreeNode; aText:String; Folder:Boolean = True):TTreeNode;
    procedure ValidateName(aName:String);
    procedure OpenLibrary(aName:String);
    //procedure MoveToEndOfFolders(aNode:TTreeNode);
  public
    { public declarations }
    procedure Test;

    constructor Create(TheOwner : TComponent); override;

    Procedure LoadCodeLib;
  end;

var
  MainFrm : TMainFrm;

implementation
uses strutils;
{$R *.lfm}

resourcestring
  FolderPrefix = 'Folder ';
  FilePrefix = 'Snippet ';
  rsclbUniqueNameFailed = 'Unable to find unique Name';
  rsInvalidName = 'Invalid Object name <%S>';

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
  if FCodeLib.IsStructuredStorage(vFName) then OpenLibrary(vFName);
  LoadCodeLib;
end;

procedure TMainFrm.actFolderNewExecute(Sender : TObject);
var
  vNode : TTreeNode;
  vPath : string;
  vName : string;
begin
  vNode := tvData.Selected;
  while IsFile(vNode) and (vNode<>nil) do
    vNode := vNode.Parent;
  vPath := GetNodePath(vNode);
  vName := UniqueName(GetNodePath(vNode), True);
  ValidateName(vPath + vName);
  FCodeLib.CreateFolder(vPath + vName);
  tvData.Items.BeginUpdate;
  try
    tvData.Selected := Nil;
    vNode := NewNode(vNode, vName);
    tvData.Selected := vNode;
  finally
    tvData.items.EndUpdate;
  end;
end;

procedure TMainFrm.actFolderRootNewExecute(Sender : TObject);
var
  vNode : TTreeNode;
  vName : string;
  vPath : string;
begin
  vPath := GetNodePath(nil);
  vName := UniqueName(vPath, True);
  ValidateName(vPath + vName);
  FCodeLib.CreateFolder(vPath+vName);
  vNode := NewNode(nil, vName);
  tvData.Selected := vNode;
end;

procedure TMainFrm.actFileNewAccept(Sender : TObject);
begin
  FCodeLib.Initialize(actFileNew.Dialog.FileName, fmCreate);
  LoadCodeLib;
end;

procedure TMainFrm.actExpandAllExecute(Sender : TObject);
var
  vNode: TTreeNode;
begin
  vNode := tvData.Items.GetFirstNode;
  while vNode <> nil do begin
    vNode.Expand(True);
    vNode := vNode.GetNextSibling;
  end;
end;

procedure TMainFrm.actCollapseAllExecute(Sender : TObject);
var
  vNode: TTreeNode;
begin
  vNode := tvData.Items.GetFirstNode;
  while vNode <> nil do begin
    vNode.Collapse(True);
    vNode := vNode.GetNextSibling;
  end;
end;

procedure TMainFrm.actDeleteExecute(Sender : TObject);
var
  vPath : string;
  vName : string;
  vNode : TTreeNode;
begin
  if tvData.Selected <> nil then begin
    vPath := GetNodePath(tvData.Selected);
    ValidateName(vPath);
    FCodeLib.Delete(vPath);
    vNode:=tvData.Selected;
    tvData.Selected := vNode.GetPrevVisible;
    tvData.Items.Delete(vNode);
    tvData.Selected := tvData.;
  end;
end;

procedure TMainFrm.actDeleteUpdate(Sender : TObject);
begin
  actDelete.Enabled := tvData.Selected <> nil;
end;

procedure TMainFrm.actSnippetSaveExecute(Sender : TObject);
var
  vFname : String  = '';
  vStrm  : TStream = nil;
begin
  vFname := GetNodePath(tvData.Selected);
  if not FCodeLib.FileExists(vFname) then vStrm := FCodeLib.OpenFile(vFname, fmCreate) else vStrm := FCodeLib.OpenFile(vFname, fmOpenReadWrite);
  try
    snEditor.Lines.SaveToStream(vStrm);
  finally
    vStrm.Free;
  end;
end;

procedure TMainFrm.actSnippetSaveUpdate(Sender : TObject);
begin
  actSnippetSave.Enabled := snEditor.Modified;
end;

procedure TMainFrm.snEditorExit(Sender : TObject);
begin
  //if snEditor.Modified then actSnippetSave(Nil);
end;

procedure TMainFrm.tvDataChange(Sender : TObject; Node : TTreeNode);
var
  vFile : String;
  vStrm : TStream;
begin
  if IsFile(Node) then begin
    vFile := GetNodePath(Node);
    vStrm := FCodeLib.OpenFile(vFile,fmOpenReadWrite);
    try
      snEditor.Lines.LoadFromStream(vStrm)
    finally
      vStrm.Free;
    end;
  end;// else snEditor.ClearAll;
end;

procedure TMainFrm.tvDataChanging(Sender : TObject; Node : TTreeNode;
  var AllowChange : Boolean);
var
  vTmp : TStream;
begin
  if snEditor.Modified and IsFile(Node) then begin
    vTmp := FCodeLib.OpenFile(GetNodePath(Node), fmOpenReadWrite);
    try
      snEditor.Lines.SaveToStream(vTmp);
    finally
      vTmp.Free;
    end;
  end;
end;

procedure TMainFrm.tvDataEdited(Sender : TObject; Node : TTreeNode;
  var S : string);
var
  vTmp : string;
begin
  if CompareText(S, Node.Text) = 0 then Exit;
  vTmp := GetNodePath(Node.Parent);
  if FCodeLib.FileExists(vTmp+Node.Text) then begin
    FCodeLib.Move(vTmp+Node.Text, vTmp+S);
  end;
  if FCodeLib.FolderExists(vTmp+Node.Text) then begin
    FCodeLib.Move(vTmp+Node.Text, vTmp+S);
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

function TMainFrm.IsFolder(aNode : TTreeNode) : Boolean;
begin
  Result := Integer(aNode.Data) = tpFolder;
end;

function TMainFrm.IsFile(aNode : TTreeNode) : Boolean;
begin
  Result := Integer(aNode.Data) = tpSnippet;
end;

function TMainFrm.UniqueName(aPath : String; Folder : Boolean) : string;
var
  vCnt : UInt32 =0;
  vTmp : string = '';
begin
  Result := IfThen(Folder, FolderPrefix, FilePrefix);
  While True do begin
    inc(vCnt);
    vTmp := Result + IntToStr(vCnt);
    if not (FCodeLib.FolderExists(aPath + vTmp) or FCodeLib.FileExists(aPath + vTmp)) then begin
      Result := vTmp;
      Exit;
    end;
    if vCnt = 0 then raise Exception.Create(rsclbUniqueNameFailed); //searched all the range of uint32 and hit 0 again.
  end;
end;
function IfThen(aCondition : Boolean; const TrueResult : Pointer; const FalseResult : Pointer = nil) : Pointer; overload;
begin
  if aCondition then Result := TrueResult else Result := FalseResult;
end;

function IfThen(aCondition : Boolean; const TrueResult : Integer; const FalseResult : Integer = 0) : Integer; overload;
begin
  if aCondition then Result := TrueResult else Result := FalseResult;
end;

function TMainFrm.NewNode(const aParent : TTreeNode; aText : String;
  Folder : Boolean) : TTreeNode;
begin
  Result               := tvData.Items.AddChild(aParent, aText);
  Result.Data          := IfThen(Folder, Pointer(tpFolder), Pointer(tpSnippet));
  Result.ImageIndex    := IfThen(Folder, 9, 11);
  Result.SelectedIndex := IfThen(Folder, 9, 11);
end;

procedure TMainFrm.ValidateName(aName : String);
begin
  if (aName ='') or (aName[1] <> CodeLibPathSep) then
    raise Exception.CreateFmt(rsInvalidName, [aName]);
end;

procedure TMainFrm.OpenLibrary(aName : String);
begin
  FCodeLib := Nil;
  FCodeLib := CreateStorage;
  FCodeLib.Initialize(aName, fmOpenReadWrite or fmShareExclusive);
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
    vFolders,vFiles : TStringList;
    vCnt            : Integer;
    vPath           : string;
    vSum            : Integer;
  begin
    vFolders := TStringList.Create;
    vFiles   := TStringList.Create;
    try
      vPath := GetNodePath(aNode);
      FCodeLib.FolderNames(vPath,vFolders);
      vSum := vFolders.Count;
      for vCnt := 0 to vFolders.Count -1 do begin
        vNode := NewNode(aNode, vFolders[vCnt]);
        LoadNodeFolder(vNode);
      end;
      FCodeLib.FileNames(vPath, VFiles);
      for vCnt := 0 to vFiles.Count -1 do begin
        vNode := NewNode(aNode, vFiles[vCnt], False);
      end;
    finally
      vFolders.Free;
      VFiles.Free;
    end;
  end;

begin
  tvData.Items.BeginUpdate;
  try
    tvData.Items.Clear;
    tvData.SortType := stNone;
    LoadNodeFolder(nil);
    tvData.Selected := nil;
  finally
    tvData.SortType := stText;
    tvData.Items.EndUpdate;
  end;
end;

end.

