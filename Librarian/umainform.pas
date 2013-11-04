unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ExtCtrls, SynEdit, ActnList, StdActns, Menus, Buttons, Grids, StdCtrls,
  SynEditHighlighter, SynHighlighterPas, SynHighlighterVB, SynHighlighterSQL,
  SynHighlighterPython, SynHighlighterPHP, SynHighlighterPerl,
  SynHighlighterJava, SynHighlighterBat, SynHighlighterCpp, GpStructuredStorage,
  SynHighlighterMulti, SynHighlighterJScript, uVar;

type
  { TSnippetsMainFrm }

  TSnippetsMainFrm = class(TForm)
    aclMain          : TActionList;
    actEditCopy      : TEditCopy;
    actEditCut       : TEditCut;
    actEditPaste     : TEditPaste;
    actEditUndo      : TEditUndo;
    actFileExit      : TFileExit;
    actFileOpen      : TFileOpen;
    actFolderRootNew : TAction;
    actFolderNew     : TAction;
    actDelete        : TAction;
    actExpandAll     : TAction;
    actCollapseAll   : TAction;
    actCompact       : TAction;
    actSettings      : TAction;
    actSetHighlighter: TAction;
    actSnippetNew    : TAction;
    actSnippetSave   : TAction;
    actFileNew       : TFileOpen;
    actFileImport    : TFileOpen;
    imlMain          : TImageList;
    MenuItem2        : TMenuItem;
    MenuItem3        : TMenuItem;
    mniSettings      : TMenuItem;
    mnuOptions       : TMenuItem;
    mniDelete        : TMenuItem;
    mniSepItem       : TMenuItem;
    mniSepItem6      : TMenuItem;
    mniFolderNew     : TMenuItem;
    mniFolderRootNew : TMenuItem;
    mniSnippetNew    : TMenuItem;
    mniEditNew       : TMenuItem;
    mnuMain          : TMainMenu;
    MenuItem1        : TMenuItem;
    mniFileOpen      : TMenuItem;
    mniExit          : TMenuItem;
    mniSepItem2      : TMenuItem;
    miCompact        : TMenuItem;
    mniSepItem1      : TMenuItem;
    mniNew           : TMenuItem;
    mnuFile          : TMenuItem;
    mnuEditUndo      : TMenuItem;
    mnuEditPaste     : TMenuItem;
    mnuEditCut       : TMenuItem;
    mnuEditCopy      : TMenuItem;
    mnuEdit          : TMenuItem;
    pmnuTree         : TPopupMenu;
    Splitter1        : TSplitter;
    StatusBar1       : TStatusBar;
    snEditor         : TSynEdit;
    shlPascal        : TSynFreePascalSyn;
    shlBAT           : TSynBatSyn;
    shlCPP           : TSynCppSyn;
    shlJava          : TSynJavaSyn;
    shlPerl          : TSynPerlSyn;
    shlPHP           : TSynPHPSyn;
    shlPython        : TSynPythonSyn;
    shlSQL           : TSynSQLSyn;
    shlVB            : TSynVBSyn;
    shlMultiHl       : TSynMultiSyn;
    ToolBar1         : TToolBar;
    btnFileOpen      : TToolButton;
    btnExpandAll     : TToolButton;
    btnCollapseAll   : TToolButton;
    btnSnippetNew    : TToolButton;
    btnFolderRootNew : TToolButton;
    btnFolderNew     : TToolButton;
    ToolButton1      : TToolButton;
    ToolButton4      : TToolButton;
    btnEditCopy      : TToolButton;
    btnEditCut       : TToolButton;
    btnEditPaste     : TToolButton;
    btnEditUndo      : TToolButton;
    ToolButton9      : TToolButton;
    tvData           : TTreeView;
    procedure actCollapseAllExecute   (Sender : TObject);
    procedure actCompactExecute       (Sender : TObject);
    procedure actCompactUpdate        (Sender : TObject);
    procedure actDeleteExecute        (Sender : TObject);
    procedure actDeleteUpdate         (Sender : TObject);
    procedure actEditUndoExecute      (Sender : TObject);
    procedure actEditUndoUpdate       (Sender : TObject);
    procedure actExpandAllExecute     (Sender : TObject);
    procedure actFileImportAccept     (Sender : TObject);
    procedure actFileNewAccept        (Sender : TObject);
    procedure actFileOpenAccept       (Sender : TObject);
    procedure actFolderNewExecute     (Sender : TObject);
    procedure actFolderRootNewExecute (Sender : TObject);
    procedure actSetHighlighterExecute(Sender : TObject);
    procedure actSettingsExecute      (Sender : TObject);
    procedure actSnippetNewExecute    (Sender : TObject);
    procedure actSnippetSaveExecute   (Sender : TObject);
    procedure actSnippetSaveUpdate    (Sender : TObject);
    procedure FormClose               (Sender : TObject;
                                       var CloseAction : TCloseAction);
    procedure snEditorExit            (Sender : TObject);
    procedure Splitter1Moved          (Sender : TObject);
    procedure tvDataChange            (Sender : TObject; Node : TTreeNode);
    procedure tvDataChanging          (Sender : TObject; Node : TTreeNode;
                                       var AllowChange : Boolean);

    // called when the tree view text editor finsihed editting aka renaming a node
    procedure tvDataEdited            (Sender : TObject; Node : TTreeNode; var S : string);
  private
    { private declarations }
    //FReading            : Boolean;
    FCodeLib            : IGpStructuredStorage; // library file opened.
    FShlJavaScript      : TSynCustomHighlighter;

    FAutoLoadLast       : Boolean;
    FLastLibrary        : string;
    FDefaultHighlighter : TSynCustomHighlighter;// always set to shlPascal user selectable in the future.
    FAutoExpandNodes    : Boolean;  //for ??

    function DefaultHighLighter(aFileName          : String)               : TSynCustomHighlighter;overload;
    function DefaultHighLighter(aNode              : TTreeNode)            : TSynCustomHighlighter;overload;
    function GetHighLighter    (aFileName          : string)               : TSynCustomHighlighter;overload;
    function GetHighLighter    (aNode              : TTreeNode)            : TSynCustomHighlighter;overload;
    function HighLighterTitle  (const aHighLighter : TSynCustomHighlighter): string;
    function HighLighterData   (const aHighLighter : TSynCustomHighlighter): PHighlighterData;

    function GetNodePath    (aNode        : TTreeNode)                                      : String;
    function IsFile         (aNode        : TTreeNode)                                      : Boolean;
    function IsFolder       (aNode        : TTreeNode)                                      : Boolean;
    function NewNode        (const aParent: TTreeNode; aText :String; Folder:Boolean = True): TTreeNode;
    function UniqueName     (aPath        : string;    Folder:Boolean)                      : string;
    function IsFileNameValid(aName        : string)                                         : Boolean;

    procedure BuildHighLightPopup(const aParent     : TMenuItem);
    procedure CheckMenu          (const aHighlighter: TSynCustomHighlighter);
    procedure SaveData           (const aNode: TTreeNode);
    procedure SetAutoExpandNodes (aValue     : Boolean);
    procedure SetHighlighter     (const aHighlighter: TSynCustomHighlighter; const aFile:string);
    procedure ValidateFileName   (aName      : string);// raise exception on invalid characters in the filename path must not be included.
    procedure ValidateName       (aObjectName: string);//make sure that the objectname passed is a valid filename with path.
    procedure LoadCodeLib;
    procedure LoadSettings;
    procedure SaveSettings;
    procedure SetNodeIcons(const aNode:TTreeNode);
  public
    { public declarations }
    constructor Create   (TheOwner : TComponent); override;
    destructor Destroy; override;
    procedure OpenLibrary(aName : string);
    procedure ImportLib  (const aFileName:string; const aRootFolder : string = '');
    //when true it opens all tree nodes when opening a library.
    property AutoExpandNodes : Boolean read FAutoExpandNodes write SetAutoExpandNodes;
  end;

var
  SnippetsMainFrm : TSnippetsMainFrm;

implementation
uses strutils, variants, uOptions, IniFiles;
{$R *.lfm}

resourcestring
  FolderPrefix          = 'Folder ';
  FilePrefix            = 'Snippet ';
  rsclbUniqueNameFailed = 'Unable to find unique Name';
  rsInvalidName         = 'Invalid Object name <%S>';
  rsHLPascal            = 'Pascal';
  rsHLVb                = 'Visual Basic';
  rsHLSql               = 'SQL';
  rsHLPython            = 'Python';
  rsHLPHP               = 'PHP';
  rsHLPerl              = 'Perl';
  rsHLJava              = 'Java';
  rsHLBat               = '.Bat';
  rsHLCPP               = 'C / C++';
  rsHLJavaScript        = 'JavaScript';

const
  cHighlighter        = 'Highlighter';
  tpSnippet           = 1;
  tpFolder            = 2;
  idxFolderNormal     = 9;
  idxFolderSelected   = 9;
  idxSnippetNormal    = 11;
  idxSnippetSelected  = 11;

  idxSnippetCppNormal      = 20;
  idxSnippetCppSelected    = 20;
  idxSnippetPascalNormal   = 21;
  idxSnippetPascalSelected = 21;
  idxSnippetPHPNormal      = 22;
  idxSnippetPHPSelected    = 22;
  idxSnippetPythonNormal   = 23;
  idxSnippetPythonSelected = 23;
  idxSnippetVBNormal       = 24;
  idxSnippetVBSelected     = 24;


var
  LangTitles : array[1..10] of THighlighterData =
    ((Title:rsHLPascal;     Instance:Nil;IconIndexNormal:idxSnippetPascalNormal; IconIndexSelected:idxSnippetPascalSelected),
     (Title:rsHLVb;         Instance:Nil;IconIndexNormal:idxSnippetVBNormal;     IconIndexSelected:idxSnippetVBSelected),
     (Title:rsHLSql;        Instance:Nil;IconIndexNormal:idxSnippetNormal;       IconIndexSelected:idxSnippetSelected),
     (Title:rsHLPython;     Instance:Nil;IconIndexNormal:idxSnippetPythonNormal; IconIndexSelected:idxSnippetPythonSelected),
     (Title:rsHLPHP;        Instance:Nil;IconIndexNormal:idxSnippetPHPNormal;    IconIndexSelected:idxSnippetPHPSelected),
     (Title:rsHLPerl;       Instance:Nil;IconIndexNormal:idxSnippetNormal;       IconIndexSelected:idxSnippetSelected),
     (Title:rsHLJava;       Instance:Nil;IconIndexNormal:idxSnippetNormal;       IconIndexSelected:idxSnippetSelected),
     (Title:rsHLBat;        Instance:Nil;IconIndexNormal:idxSnippetNormal;       IconIndexSelected:idxSnippetSelected),
     (Title:rsHLCPP;        Instance:Nil;IconIndexNormal:idxSnippetCppNormal;    IconIndexSelected:idxSnippetCppSelected),
     (Title:rsHLJavaScript; Instance:Nil;IconIndexNormal:idxSnippetNormal;       IconIndexSelected:idxSnippetSelected)
    );

function Languages: StringArray;
var
  vCntr : integer;
  vCount: integer;
begin
  SetLength(Result, Length(LangTitles));
  vCount := 0;
  for vCntr := low(LangTitles) to High(LangTitles) do
    if Assigned(LangTitles[vCntr].Instance) then begin
      Result[vCount] := LangTitles[vCntr].Title;
    end;
end;

function MakeFileName(const FolderName, FileName: string): string;
begin
  Result := FolderName;
  if Result = '' then
    Result := cCodeLibPathSep
  else
    Result := AddSlash(Result);
  if FileName <> '' then
  begin
    if FileName[1] = cCodeLibPathSep then
      Result := Result + Copy(FileName, 2, 9999999)
    else
      Result := Result + FileName;
  end;
end;
{ TSnippetsMainFrm }

procedure TSnippetsMainFrm.actFileOpenAccept(Sender : TObject);
var
  vFName : String;
begin
  if snEditor.Modified then begin
    SaveData(tvData.Selected);
    snEditor.Lines.Clear;
    snEditor.Modified := False;
  end;
  vFName := actFileOpen.Dialog.FileName;
  if IsStructuredStorage(vFName) then OpenLibrary(vFName);
end;

procedure TSnippetsMainFrm.actFolderNewExecute(Sender : TObject);
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
  ValidateFileName(vName);
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

procedure TSnippetsMainFrm.actFolderRootNewExecute(Sender : TObject);
var
  vNode : TTreeNode;
  vName : string;
  vPath : string;
begin
  vPath := GetNodePath(nil);
  vName := UniqueName(vPath, True);
  ValidateFileName(vName);
  ValidateName(vPath + vName);
  FCodeLib.CreateFolder(vPath+vName);
  vNode := NewNode(nil, vName);
  tvData.Selected := vNode;
end;

procedure TSnippetsMainFrm.actSetHighlighterExecute(Sender : TObject);
var
  vCntr : Integer;
begin
  if (Sender is TMenuItem) and (TMenuItem(sender).Tag <> 0) then begin
    for vCntr := 0 to tvData.SelectionCount -1 do begin
      SetHighlighter(TSynCustomHighlighter(TMenuItem(Sender).Tag),GetNodePath(tvData.Selections[vCntr]));
      SetNodeIcons(tvData.Selections[vCntr]);
    end;
  end;
end;

procedure TSnippetsMainFrm.actSettingsExecute(Sender : TObject);
var
  vFrm :TEvsOptionsForm;
begin
  vFrm := TEvsOptionsForm.Create(Nil);
  try
    vFrm.ShowModal;
  finally
    vFrm.Free;
  end;
end;

procedure TSnippetsMainFrm.actSnippetNewExecute(Sender : TObject);
var
  vNode : TTreeNode;
  vPath : string;
  vName : string;
  vStrm : TStream;
begin
  vNode := tvData.Selected;
  while (vNode <> nil) and (not IsFolder(vNode)) do
    vNode := vNode.Parent;
  vPath := GetNodePath(vNode);
  vName := UniqueName(vPath, False);
  vStrm := FCodeLib.OpenFile(vPath+vName, fmCreate);
  vStrm.Free;
  vNode := NewNode(vNode,vName, False);
  tvData.Selected := vNode;
end;

procedure TSnippetsMainFrm.actFileNewAccept(Sender : TObject);
begin
  FCodeLib.Initialize(actFileNew.Dialog.FileName, fmCreate);
  LoadCodeLib;
end;

procedure TSnippetsMainFrm.actExpandAllExecute(Sender : TObject);
var
  vNode: TTreeNode;
begin
  vNode := tvData.Items.GetFirstNode;
  while vNode <> nil do begin
    vNode.Expand(True);
    vNode := vNode.GetNextSibling;
  end;
end;

procedure TSnippetsMainFrm.actFileImportAccept(Sender : TObject);
var
  vFName : string;
begin
  vFName := actFileImport.Dialog.FileName;
  vFName := ExtractFileNameOnly(vFName);
  ImportLib(actFileImport.Dialog.FileName, cCodeLibPathSep + vFName);
end;

procedure TSnippetsMainFrm.actCollapseAllExecute(Sender : TObject);
var
  vNode: TTreeNode;
begin
  vNode := tvData.Items.GetFirstNode;
  while vNode <> nil do begin
    vNode.Collapse(True);
    vNode := vNode.GetNextSibling;
  end;
end;

procedure TSnippetsMainFrm.actCompactExecute(Sender : TObject);
begin
  if Assigned(FCodeLib) and FCodeLib.IsInitialized then FCodeLib.Compact;
end;

procedure TSnippetsMainFrm.actCompactUpdate(Sender : TObject);
begin
  actCompact.Enabled := (FCodeLib <> nil) and FCodeLib.IsInitialized;
end;

procedure TSnippetsMainFrm.actDeleteExecute(Sender : TObject);
var
  vPath   : string;
  vName   : string;
  vNode   : TTreeNode;
  vChoice : Integer;
begin
  if tvData.Selected <> nil then begin
    vPath := GetNodePath(tvData.Selected);
    ValidateName(vPath);
    vChoice := MessageDlg('Delete ' + IfThen(IsFolder(tvData.Selected),Trim(FolderPrefix), Trim(FilePrefix)),
                          'Are you sure you want to delete ' + tvData.Selected.Text +' ?',
                          mtConfirmation,mbYesNoCancel, 0);
    if vChoice in [mrNo, mrCancel] then begin
      Exit;
    end;
    FCodeLib.Delete(vPath);
    vNode := tvData.Selected;
    tvData.Selected := vNode.GetPrevVisible;
    if tvData.Selected = nil then tvData.Selected := vNode.GetNextVisible;
    vNode.Delete;
  end;
end;

procedure TSnippetsMainFrm.actDeleteUpdate(Sender : TObject);
begin
  actDelete.Enabled := tvData.Selected <> nil;
end;

procedure TSnippetsMainFrm.actEditUndoExecute(Sender : TObject);
begin
  if snEditor.CanUndo then snEditor.Undo;
end;

procedure TSnippetsMainFrm.actEditUndoUpdate(Sender : TObject);
begin
  actEditUndo.Enabled := snEditor.CanUndo;
end;

procedure TSnippetsMainFrm.actSnippetSaveExecute(Sender : TObject);
begin
  if snEditor.Modified then SaveData(tvData.Selected);
end;

procedure TSnippetsMainFrm.actSnippetSaveUpdate(Sender : TObject);
begin
  actSnippetSave.Enabled := snEditor.Modified;
end;

procedure TSnippetsMainFrm.FormClose(Sender : TObject; var CloseAction : TCloseAction);
begin
  if snEditor.Modified then SaveData(tvData.Selected);
end;

procedure TSnippetsMainFrm.snEditorExit(Sender : TObject);
begin
  if snEditor.Modified then SaveData(tvData.Selected);
end;

procedure TSnippetsMainFrm.Splitter1Moved(Sender : TObject);
begin
  StatusBar1.Panels[0].Width := tvData.Width+1;
end;

procedure TSnippetsMainFrm.tvDataChange(Sender : TObject; Node : TTreeNode);
var
  vFile : String;
  vStrm : TStream;
begin
  if IsFile(Node) then begin
    vFile := GetNodePath(Node);
    vStrm := FCodeLib.OpenFile(vFile,fmOpenReadWrite);
    try
      snEditor.Lines.LoadFromStream(vStrm);
    finally
      vStrm.Free;
    end;
  end else begin
    snEditor.ClearAll;
  end;
  snEditor.Highlighter := GetHighLighter(vFile);
  CheckMenu(snEditor.Highlighter);
  StatusBar1.Panels[1].Text := HighLighterTitle(snEditor.Highlighter);
end;

procedure TSnippetsMainFrm.tvDataChanging(Sender : TObject; Node : TTreeNode;
  var AllowChange : Boolean);
begin
  if snEditor.Modified then begin
    SaveData(Node);
  end;
end;

procedure TSnippetsMainFrm.tvDataEdited(Sender : TObject; Node : TTreeNode;
  var S : string);
var
  vTmp : string;
begin
  if not IsFileNameValid(S) then begin s := node.Text; exit; end;
  if CompareText(S, Node.Text) = 0 then Exit;
  vTmp := GetNodePath(Node.Parent);
  if FCodeLib.FileExists(vTmp+Node.Text) then begin
    FCodeLib.Move(vTmp+Node.Text, vTmp+S);
  end;
  if FCodeLib.FolderExists(vTmp+Node.Text) then begin
    FCodeLib.Move(vTmp+Node.Text, vTmp+S);
  end;
end;

function TSnippetsMainFrm.GetNodePath(aNode : TTreeNode) : String;
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

function TSnippetsMainFrm.IsFolder(aNode : TTreeNode) : Boolean;
begin
  if Assigned(aNode) then Result := Integer(aNode.Data) = tpFolder
  else Result := False;
end;

function TSnippetsMainFrm.IsFile(aNode : TTreeNode) : Boolean;
begin
  if Assigned(aNode) then
   Result := Integer(aNode.Data) = tpSnippet
  else Result:= False;
end;

procedure TSnippetsMainFrm.SetAutoExpandNodes(aValue : Boolean);
begin
  if FAutoExpandNodes = aValue then Exit;
  FAutoExpandNodes := aValue;
end;

function TSnippetsMainFrm.UniqueName(aPath : String; Folder : Boolean) : string;
var
  vCnt : Cardinal = 0;
  vTmp : string   = '';
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

function TSnippetsMainFrm.IsFileNameValid(aName : string) : Boolean;
begin
  Result := not ((Pos('/',aName) > 0) or (Pos('\',aName) > 0) or (aName = ''));
end;

function IfThen(aCondition : Boolean; const TrueResult : Pointer; const FalseResult : Pointer = nil) : Pointer; overload;
begin
  if aCondition then Result := TrueResult else Result := FalseResult;
end;

function IfThen(aCondition : Boolean; const TrueResult : Integer; const FalseResult : Integer = 0) : Integer; overload;
begin
  if aCondition then Result := TrueResult else Result := FalseResult;
end;

function TSnippetsMainFrm.NewNode(const aParent : TTreeNode; aText : String;
  Folder : Boolean) : TTreeNode;
begin
  Result := tvData.Items.AddChild(aParent, aText);
  if Folder then begin
    Result.Data          := Pointer(tpFolder);
    //Result.ImageIndex    := idxFolderNormal;
    //Result.SelectedIndex := idxFolderSelected;
  end else begin
    Result.Data          := Pointer(tpSnippet);
    //Result.ImageIndex    := idxSnippetNormal;
    //Result.SelectedIndex := idxSnippetSelected;
  end;
  SetNodeIcons(Result);
end;

function TSnippetsMainFrm.HighLighterTitle(const aHighLighter: TSynCustomHighlighter): string;
var
  vCntr : Integer;
begin
  Result := '';
  for vCntr := low(LangTitles) to High(LangTitles) do
    if LangTitles[vCntr].Instance = aHighLighter then begin
      Result := LangTitles[vCntr].Title;
      Break;
    end;
end;

procedure TSnippetsMainFrm.ValidateName(aObjectName : String);
begin
  if (aObjectName ='') or (aObjectName[1] <> cCodeLibPathSep) then
    raise Exception.CreateFmt(rsInvalidName, [aObjectName]);
end;

procedure TSnippetsMainFrm.ValidateFileName(aName : string);
begin
  if (Pos('/',aName) > 0) then raise Exception.Create('</> is an invalid character');
  if (Pos('\',aName) > 0) then raise Exception.Create('<\> is an invalid character');
  if aName = '' then raise Exception.Create('Name must be at least 1 character long');
end;

procedure TSnippetsMainFrm.OpenLibrary(aName : String);
begin
  FCodeLib := Nil;
  FCodeLib := CreateStorage;
  FCodeLib.Initialize(aName, fmOpenReadWrite or fmShareExclusive);
  LoadCodeLib;
  FLastLibrary := aName;
  if FAutoExpandNodes then actExpandAllExecute(actExpandAll);
end;

procedure TSnippetsMainFrm.SaveData(const aNode : TTreeNode);
var
  vFname : String  = '';
  vStrm  : TStream = nil;
begin
  if not IsFile(aNode) then Exit;
  ValidateFileName(aNode.Text);
  vFName := GetNodePath(aNode);
  ValidateName(vFname);
  if not FCodeLib.FileExists(vFname) then vStrm := FCodeLib.OpenFile(vFname, fmCreate)
  else vStrm := FCodeLib.OpenFile(vFname, fmOpenReadWrite);
  try
    snEditor.Lines.SaveToStream(vStrm);
    snEditor.Modified := False;
  finally
    vStrm.Free;
  end;
end;

procedure TSnippetsMainFrm.SetHighlighter(const aHighlighter : TSynCustomHighlighter; const aFile : string);
begin
  FCodeLib.GetFileInfo(aFile).SetAttribute(cHighlighter,aHighlighter.Name);
  snEditor.Highlighter := aHighlighter;
end;


constructor TSnippetsMainFrm.Create(TheOwner : TComponent);
begin
  inherited Create(TheOwner);
  FCodeLib := Nil;
  FShlJavaScript          := TSynJScriptSyn.Create(Self);
  FShlJavaScript.IdentifierAttribute.Foreground := clNone;
  FShlJavaScript.CommentAttribute.Foreground := $00A2A2A2;
  FShlJavaScript.KeywordAttribute.Foreground := clNavy;
  //FShlJavaScript.NumberAttribute.ForeGround  := $004080FF;
  FShlJavaScript.StringAttribute.ForeGround  := $003FB306;
  FShlJavaScript.SymbolAttribute.ForeGround  := $00A25151;
  //FShlJavaScript.VariableAttribute.ForeGround  := clNavy;

  LangTitles[01].Instance := shlPascal;
  LangTitles[02].Instance := shlVB;
  LangTitles[03].Instance := shlSQL;
  LangTitles[04].Instance := shlPython;
  LangTitles[05].Instance := shlPHP;
  LangTitles[06].Instance := shlPerl;
  LangTitles[07].Instance := shlJava;
  LangTitles[08].Instance := shlBAT;
  LangTitles[09].Instance := shlCPP;
  LangTitles[10].Instance := FShlJavaScript;
  BuildHighLightPopup(pmnuTree.Items);
  FDefaultHighlighter := shlPascal;
  LoadSettings;
  if FAutoLoadLast and (FLastLibrary <> '') then OpenLibrary(FLastLibrary)
  //else FCodeLib := CreateStorage
  ;
end;

destructor TSnippetsMainFrm.Destroy;
begin
  FShlJavaScript.Free;
  FCodeLib := nil;
  inherited Destroy;
end;

procedure TSnippetsMainFrm.LoadCodeLib;
  procedure LoadNodeFolder(aNode:TTreeNode);
  var
    vNode           : TTreeNode;
    vFolders,vFiles : TStringList;
    vCnt            : Integer;
    vPath           : string;
  begin
    vFolders := TStringList.Create;
    vFiles   := TStringList.Create;
    try
      vPath := GetNodePath(aNode);
      FCodeLib.FolderNames(vPath, vFolders);
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
      vFiles.Free;
    end;
  end;

begin
  tvData.Items.BeginUpdate;
  try
    tvData.Items.Clear;
    tvData.SortType := stNone;
    LoadNodeFolder(nil);
    tvData.Selected := nil;
    snEditor.ClearAll;
  finally
    tvData.SortType := stText;
    tvData.Items.EndUpdate;
  end;
end;

procedure TSnippetsMainFrm.LoadSettings;
var
  vFname:string;
  vConfig:TIniFile;
begin
  vFname := uVar.ConfigFileName;
  vConfig := TIniFile.Create(vFname);
  try
    FAutoLoadLast        := vConfig.ReadBool('General','LoadLast',False);
    FLastLibrary         := vConfig.ReadString('General','Library','');
    FDefaultHighlighter  := TSynCustomHighlighter(FindComponent(vConfig.ReadString('General', 'DefaultHighLighter', 'shlPascal')));

    if FAutoLoadLast and (FLastLibrary <> '') then OpenLibrary(FLastLibrary);
  finally
    vConfig.Free;
  end;
end;

procedure TSnippetsMainFrm.SaveSettings;
var
  vFname:string;
  vConfig:TIniFile;
begin
  vFname := uVar.ConfigFileName;
  vConfig := TIniFile.Create(vFname);
  vConfig.WriteBool  ('General', 'LoadLast',           FAutoLoadLast);
  vConfig.WriteString('General', 'Library',            FLastLibrary);
  vConfig.WriteString('General', 'DefaultHighLighter', FDefaultHighlighter.Name);
end;

procedure TSnippetsMainFrm.SetNodeIcons(const aNode : TTreeNode);
var
  vHL     : TSynCustomHighlighter;
  vHLData : PHighlighterData;
begin
  vHL     := GetHighLighter(aNode);
  vHLData := HighLighterData(vHL);
  if IsFile(aNode) and Assigned(vHLData) then begin   // there is not way that the vHLData will not be assigned but just in case I scrud up somewhere
    aNode.ImageIndex    := vHLData^.IconIndexNormal;
    aNode.SelectedIndex := vHLData^.IconIndexSelected;
  end else begin
    if IsFolder(aNode) then begin
      aNode.ImageIndex    := idxFolderNormal;
      aNode.SelectedIndex := idxFolderSelected;
    end else begin
     aNode.ImageIndex    := idxSnippetNormal;
     aNode.SelectedIndex := idxSnippetSelected;
    end;
  end;
end;

function TSnippetsMainFrm.HighLighterData(const aHighLighter: TSynCustomHighlighter): PHighlighterData;
var
  vCntr : Integer;
begin
  Result := nil;
  for vCntr := low(LangTitles) to High(LangTitles) do
    if LangTitles[vCntr].Instance = aHighLighter then begin
      Result := @LangTitles[vCntr];
      Break;
    end;
end;

procedure TSnippetsMainFrm.BuildHighLightPopup(const aParent : TMenuItem);
var
  vCntr : Integer;
  vMni  : TMenuItem;
begin
  aParent.Clear;
  for vCntr := Low(LangTitles) to High(LangTitles) do begin
    if LangTitles[vCntr].Instance <> nil then begin
      vMni           := TMenuItem.Create(Self);
      vMni.Caption   := LangTitles[vCntr].Title;
      vMni.Tag       := PtrUInt(LangTitles[vCntr].Instance);
      vMni.OnClick   := @actSetHighlighterExecute;
      vMni.AutoCheck := True;
      vMni.RadioItem := True;
      vMni.GroupIndex:= 1;
      vMni.Checked   := (LangTitles[vCntr].Instance = FDefaultHighlighter);
      aParent.Add(vMni);
    end;
  end;
end;

procedure TSnippetsMainFrm.CheckMenu(const aHighlighter : TSynCustomHighlighter);
var
  vCntr : Integer;
begin
  for vCntr := 0 to pmnuTree.Items.Count -1 do begin
    if (pmnuTree.Items[vCntr].Tag = PtrInt(aHighlighter)) and (not pmnuTree.Items[vCntr].Checked) then begin
      pmnuTree.Items[vCntr].Checked := True;
      Break;
    end;
  end;
end;

function TSnippetsMainFrm.DefaultHighLighter(aNode : TTreeNode) : TSynCustomHighlighter;
begin
  Result := DefaultHighLighter(GetNodePath(aNode));
end;

function TSnippetsMainFrm.DefaultHighLighter(aFileName : String) : TSynCustomHighlighter;
begin
  Result := shlPascal;
end;

function TSnippetsMainFrm.GetHighLighter(aNode : TTreeNode) : TSynCustomHighlighter;
begin
  Result := GetHighLighter(GetNodePath(aNode));
end;

function TSnippetsMainFrm.GetHighLighter(aFileName : string) : TSynCustomHighlighter;
var
  vTmp : string;
  vFN  : string;
  vCmp : TComponent;
  function Highlighter(const aFName:string):TSynCustomHighlighter;
  begin
    Result := Nil;
    vTmp := FCodeLib.GetFileInfo(aFName).GetAttribute(cHighlighter);
    vCmp := FindComponent(vTmp);
    if (vCmp is TSynCustomHighlighter) then Result := TSynCustomHighlighter(vCmp);
  end;
begin
  vFN := aFileName;
  Result := Highlighter(vFN);
  while (Result = nil) do begin
   vFN := FCodeLib.ParentFolder(vFN);
   Result := Highlighter(vFN);
   if ((vFN = '') or (vFN = '/')) and (Result = nil) then Result := FDefaultHighlighter;
  end;
end;

procedure TSnippetsMainFrm.ImportLib(const aFileName : string; const aRootFolder : string);
const
  cDelim = cCodeLibPathSep;
  function InclPathDel(inStr:String):string;
  begin
    Result:=inStr;
    if Result[Length(Result)] <> cDelim then Result := Result + cDelim;
  end;

var
  vFromLib, vToLib : IGpStructuredStorage;
  vBckCurs         : TCursor;
  procedure ImportFolder(aSourceFolder, aDestFolder:string);
  var
    vFolders, vFiles : TStringList;
    vFrom,    vTo    : TStream;
    vCnt             : Integer;
    vNewFolder       : string;
  begin
    vFolders := TStringList.Create;
    vFiles   := TStringList.Create;
    try
      aSourceFolder := InclPathDel(aSourceFolder);
      vFromLib.FolderNames(aSourceFolder, vFolders);
      for vCnt := 0 to vFolders.Count -1 do begin
        vNewFolder := InclPathDel(aDestFolder) + vFolders[vCnt];
        vToLib.CreateFolder(vNewFolder);
        ImportFolder(aSourceFolder + vFolders[vCnt] +cDelim, vNewFolder);
      end;
      vFromLib.FileNames(aSourceFolder, vFiles);
      aDestFolder := InclPathDel(aDestFolder);
      for vCnt := 0 to vFiles.Count -1 do begin
        vFrom      := vFromLib.OpenFile(aSourceFolder+vFiles[vCnt], fmOpenReadWrite);
        vTo        := vToLib.OpenFile(aDestFolder+vFiles[vCnt], fmCreate);
        try
          vTo.CopyFrom(vFrom, 0);
        finally
          vFrom.Free;
          vTo.Free;
        end;
      end;
    finally
      vFolders.Free;
      vFiles.Free;
    end;
  end;

begin
  Enabled := False;
  vBckCurs := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    vFromLib := CreateStorage;
    vFromLib.Initialize(aFileName, fmOpenReadWrite or fmShareExclusive);
    vToLib := FCodeLib;
    if vToLib.FolderExists(aRootFolder) then
      raise Exception.CreateFmt('Folder %S already exists in code library',[aRootFolder]);
    ImportFolder('/', aRootFolder);
    LoadCodeLib;
  finally
    Screen.Cursor := vBckCurs;
    Enabled := True;
  end;
end;

end.

