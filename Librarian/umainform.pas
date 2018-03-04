{ ╔═════════════════════════════════════════════════════════════════════════════╗
  ║                 Copyright© 2012-2015 EVOSI® all rights reserved             ║
  ╠═════════════════════════════════════════════════════════════════════════════╣
  ║    ▄▄▄▄▄▄▄▄▄▄▄  ▄               ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄    ║
  ║   ▐░░░░░░░░░░░▌▐░▌             ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌   ║
  ║   ▐░█▀▀▀▀▀▀▀▀▀  ▐░▌           ▐░▌ ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀  ▀▀▀▀█░█▀▀▀▀    ║
  ║   ▐░█▄▄▄▄▄▄▄▄▄    ▐░▌       ▐░▌   ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄▄▄      ▐░▌        ║
  ║   ▐░░░░░░░░░░░▌    ▐░▌     ▐░▌    ▐░▌       ▐░▌▐░░░░░░░░░░░▌     ▐░▌        ║
  ║   ▐░█▀▀▀▀▀▀▀▀▀      ▐░▌   ▐░▌     ▐░▌       ▐░▌ ▀▀▀▀▀▀▀▀▀█░▌     ▐░▌        ║
  ║   ▐░█▄▄▄▄▄▄▄▄▄        ▐░▐░▌       ▐░█▄▄▄▄▄▄▄█░▌ ▄▄▄▄▄▄▄▄▄█░▌ ▄▄▄▄█░█▄▄▄▄    ║
  ║   ▐░░░░░░░░░░░▌        ▐░▌        ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌   ║
  ║    ▀▀▀▀▀▀▀▀▀▀▀          ▀          ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀    ║
  ╚═════════════════════════════════════════════════════════════════════════════╝}

unit uMainForm;

{$mode objfpc}{$H+}
{ TODO  -JKOZ
    0001 : Extend the supported languages.
        01 : Assembly
        02 : C#

    0002 : Add Customizable Highlighter so the end users can define their own highlighters.
    0003 : Add Filtering
           Filtering is a simple mask matching a piece of text to the file name or the code.
        01 : At the name.
        02 : At the code.
    0004 : Add full text search capabilities.
    0005 : extend the attributes to support
        01 : Language specific features
        02 : Operating system.
             The same concept as the tags and categories below a small database in the settings folder with all the
             information and a small ID at the file attributes.
        03 : Rating.
             a simple number from 0 unrated to 10 top rated. No floats only integers.
        04 : Tags.
        05 : categories.
             tags and categories are the same concept both need to be library wide settings and once keyed in the need
             to be remembered and ready to be used at any time from anywhere. So instead of having them directly on the
             file I'll create a small database in a settings directory at the root folder.
    0006 : Add hidden folders and files those are suppose to be all the files that either have the attribute hidden set
           or the name starts with a dot character like linux.
    0007 : A unique ID (autonumber) to be used to link various files together as one snippet.
    0008 : Add support for attachements extra files that are needed or required from the code could be attached on the
           file it self.
           Attachments can be either inside a hidden directory or be hidden files them selfs in the same directory as
           the snippet. It would probably be better to have all the attachments in one place so when a new file is
           inserted then it can be checked against the existing database and avoid duplicates. }
interface

uses
  Classes,   SysUtils, FileUtil, Forms,    Controls, Graphics, Dialogs, ComCtrls,
  ExtCtrls,  SynEdit,  ActnList, StdActns, Menus,    Buttons,  //Grids,   StdCtrls, FileCtrl,
  uVar, GpStructuredStorage,
  SynEditHighlighter,  SynHighlighterPas,     SynHighlighterVB,   SynHighlighterSQL, SynHighlighterPython,
  SynHighlighterPHP,   SynHighlighterPerl,    SynHighlighterJava, SynHighlighterBat, SynHighlighterCpp,
  SynHighlighterMulti, SynHighlighterJScript, SynHighlighterAny,  SynHighlighterAsm, SynHighlighterCS,
  synhighlighterunixshellscript, TreeFilterEdit;

type
  { TSnippetsMainFrm }

  TSnippetsMainFrm = class(TForm)
    aclMain           :TActionList;
    actEditCopy       :TEditCopy;
    actEditCut        :TEditCut;
    actEditPaste      :TEditPaste;
    actEditUndo       :TEditUndo;
    actFileExit       :TFileExit;
    actFileOpen       :TFileOpen;
    actFolderRootNew  :TAction;
    actFolderNew      :TAction;
    actDelete         :TAction;
    actExpandAll      :TAction;
    actCollapseAll    :TAction;
    actCompact        :TAction;
    actSettings       :TAction;
    actSetHighlighter :TAction;
    actSnippetNew     :TAction;
    actSnippetSave    :TAction;
    actFileNew        :TFileOpen;
    actFileImport     :TFileOpen;
    imlMain           :TImageList;
    mnuMain           :TMainMenu;
    MenuItem2         :TMenuItem;
    MenuItem3         :TMenuItem;
    mniSettings       :TMenuItem;
    mnuOptions        :TMenuItem;
    mniDelete         :TMenuItem;
    mniSepItem        :TMenuItem;
    mniSepItem6       :TMenuItem;
    mniFolderNew      :TMenuItem;
    mniFolderRootNew  :TMenuItem;
    mniSnippetNew     :TMenuItem;
    mniEditNew        :TMenuItem;
    MenuItem1         :TMenuItem;
    mniFileOpen       :TMenuItem;
    mniExit           :TMenuItem;
    mniSepItem2       :TMenuItem;
    miCompact         :TMenuItem;
    mniSepItem1       :TMenuItem;
    mniNew            :TMenuItem;
    mnuFile           :TMenuItem;
    mnuEditUndo       :TMenuItem;
    mnuEditPaste      :TMenuItem;
    mnuEditCut        :TMenuItem;
    mnuEditCopy       :TMenuItem;
    mnuEdit           :TMenuItem;
    Panel1            :TPanel;
    pmnuTree          :TPopupMenu;
    shlSqlOracle      :TSynSQLSyn;
    shlSqlInterbase   :TSynSQLSyn;
    shlSqlMsSql2000   :TSynSQLSyn;
    shlSqlMySQL       :TSynSQLSyn;
    Splitter1         :TSplitter;
    StatusBar1        :TStatusBar;
    snEditor          :TSynEdit;
    shlPascal         :TSynFreePascalSyn;
    shlBAT            :TSynBatSyn;
    shlCPP            :TSynCppSyn;
    shlJava           :TSynJavaSyn;
    shlPerl           :TSynPerlSyn;
    shlPHP            :TSynPHPSyn;
    shlPython         :TSynPythonSyn;
    shlSQL            :TSynSQLSyn;
    shlVB             :TSynVBSyn;
    shlMultiHl        :TSynMultiSyn;
    shlShellScript    :TSynUNIXShellScriptSyn;
    SynAnySyn1        :TSynAnySyn;
    ToolBar1          :TToolBar;
    btnFileOpen       :TToolButton;
    btnExpandAll      :TToolButton;
    btnCollapseAll    :TToolButton;
    btnSnippetNew     :TToolButton;
    btnFolderRootNew  :TToolButton;
    btnFolderNew      :TToolButton;
    ToolButton1       :TToolButton;
    ToolButton2       :TToolButton;
    ToolButton3       :TToolButton;
    ToolButton4       :TToolButton;
    btnEditCopy       :TToolButton;
    btnEditCut        :TToolButton;
    btnEditPaste      :TToolButton;
    btnEditUndo       :TToolButton;
    ToolButton5       :TToolButton;
    ToolButton9       :TToolButton;
    TreeFilterEdit1   :TTreeFilterEdit;
    tvData            :TTreeView;
    procedure actCollapseAllExecute   (Sender :TObject);
    procedure actCompactExecute       (Sender :TObject);
    procedure actCompactUpdate        (Sender :TObject);
    procedure actDeleteExecute        (Sender :TObject);
    procedure actDeleteUpdate         (Sender :TObject);
    procedure actEditUndoExecute      (Sender :TObject);
    procedure actEditUndoUpdate       (Sender :TObject);
    procedure actExpandAllExecute     (Sender :TObject);
    procedure actFileImportAccept     (Sender :TObject);
    procedure actFileNewAccept        (Sender :TObject);
    procedure actFileOpenAccept       (Sender :TObject);
    procedure actFolderNewExecute     (Sender :TObject);
    procedure actFolderRootNewExecute (Sender :TObject);
    procedure actSetHighlighterExecute(Sender :TObject);
    procedure actSettingsExecute      (Sender :TObject);
    procedure actSnippetNewExecute    (Sender :TObject);
    procedure actSnippetSaveExecute   (Sender :TObject);
    procedure actSnippetSaveUpdate    (Sender :TObject);
    procedure FormClose               (Sender :TObject; var CloseAction : TCloseAction);
    procedure pmnuTreePopup           (Sender :TObject);
    procedure snEditorExit            (Sender :TObject);
    procedure Splitter1Moved          (Sender :TObject);
    procedure tvDataChange            (Sender :TObject; Node :TTreeNode);
    procedure tvDataChanging          (Sender :TObject; Node :TTreeNode; var AllowChange :Boolean);
    procedure tvDataCompare           (Sender :TObject; Node1, Node2 :TTreeNode; var Compare : Integer);
    procedure tvDataDragDrop          (Sender, Source :TObject; X, Y :Integer);
    procedure tvDataDragOver          (Sender, Source :TObject; X, Y :Integer; State :TDragState; var Accept :Boolean);
    // called when the tree view text editor finsihed editting aka renaming a node
    procedure tvDataEdited            (Sender :TObject; Node  :TTreeNode; var S  :string);
    procedure tvDataEditingEnd        (Sender :TObject; Node  :TTreeNode; Cancel :Boolean);
    procedure tvDataMouseDown         (Sender :TObject; Button:TMouseButton; Shift :TShiftState; X, Y :Integer);
    procedure tvDataStartDrag         (Sender :TObject; var DragObject :TDragObject);
  private
    { private declarations }
    FCodeLib            :IGpStructuredStorage; // library file opened.
    FAutoLoadLast       :Boolean;
    FLastLibrary        :string;
    FDefaultHighlighter :TSynCustomHighlighter;// always set to shlPascal user selectable in the future.
    FAutoExpandNodes    :Boolean;
    FAutoExpandAll      :Boolean;

    function GetHighLighter    (aFileName          :string)               :TSynCustomHighlighter;overload;
    function GetHighLighter    (aNode              :TTreeNode)            :TSynCustomHighlighter;overload;
    function HighLighterTitle  (const aHighLighter :TSynCustomHighlighter):string;
    function HighLighterData   (const aHighLighter :TSynCustomHighlighter):PHighlighterData;

    function GetNodePath    (aNode         :TTreeNode):String;
    function IsFile         (aNode         :TTreeNode):Boolean;
    function IsFolder       (aNode         :TTreeNode):Boolean;
    function NewNode        (const aParent :TTreeNode; aText  :String; Folder :Boolean = True):TTreeNode;
    function UniqueName     (aPath         :string;    Folder :Boolean):string;
    function IsFileNameValid(aName         :string):Boolean;

    procedure BuildHighLightPopup(const aParent     :TMenuItem);
    procedure CheckMenu          (const aHighlighter:TSynCustomHighlighter);
    procedure SaveData           (const aNode       :TTreeNode);
    procedure SetAutoExpandNodes (aValue            :Boolean);
    procedure SetHighlighter     (const aHighlighter:TSynCustomHighlighter; const aFile:string);
    procedure ValidateFileName   (aName             :string);// raise exception on invalid characters in the filename path must not be included.
    procedure ValidateName       (aObjectName       :string);//make sure that the objectname passed is a valid filename with path.
    procedure SetShowToolBarCaptions(const aValue:Boolean);
    procedure LoadCodeLib;
    procedure LoadSettings;
    procedure SaveSettings;
    procedure SetNodeIcons         (const aNode   :TTreeNode; Recursive :Boolean=False);
    procedure SetDefaultHighLighter(const aTitle  :string);
    procedure ResetChildIcons      (const aParent :TTreeNode; const Recursive :Boolean = False);
    procedure ExpandTreeNodes      (const aAll    :Boolean = False);
    procedure CollapseTreeNodes    (const aAll    :Boolean = False);
    procedure ImportComponentSuite (const aDir    :String);
    procedure CreateLibrary        (const aFileName:string);
  public
    { public declarations }
    constructor Create (TheOwner :TComponent); override;
    destructor  Destroy; override;
    procedure   OpenLibrary(aName :string);
    procedure   ImportLib (const aFileName :string; const aRootFolder :string = '');
    //when true it opens all tree nodes when opening a library.
    property AutoExpandNodes : Boolean read FAutoExpandNodes write SetAutoExpandNodes;
  end;

var
  SnippetsMainFrm : TSnippetsMainFrm;

implementation
uses
  strutils, variants, uOptions, IniFiles, uEvsSynhighlightersql, StrConst
  , SynHighlighterDOT, SynHighlighterInno, SynHighlighterCobol, SynHighlighterEiffel
  , SynHighlighterFortran, SynHighlighterRuby, SynHighlighterIDL, SynHighlighterHaskell
  , SynHighlighterFoxpro, SynHighlighterProlog, SynHighlighterLua
  //, SynHighlighterM3
  , SynHighlighterTclTk
  ;
{$R *.lfm}

resourcestring
  FolderPrefix           = 'Folder ';
  FilePrefix             = 'Snippet ';
  rsclbUniqueNameFailed  = 'Unable to find unique Name';
  rsInvalidName          = 'Invalid Object name <%S>';
  rsHLNone               = 'None';
  rsHLPascal             = 'Pascal';
  rsHLVb                 = 'Visual Basic';
  rsHLSql                = 'Generic SQL';
  rsHLPython             = 'Python';
  rsHLPHP                = 'PHP';
  rsHLPerl               = 'Perl';
  rsHLJava               = 'Java';
  rsHLBat                = '.Bat';
  rsHLCPP                = 'C / C++';
  rsHLJavaScript         = 'JavaScript';
  rsHLFirebird           = 'Firebird Dialect';
  rsHLOracleSql          = 'Oracle Dialect';
  rsHLPostgreSQL         = 'Postgres Dialect';
  rsHLMySQL              = 'MySQL Dialect';
  rsHLMsSQL              = 'MsSQL Dialect';
  rsHLASM                = 'Assembly';
  rsHLCS                 = 'C#';
  rsHLSQLite             = 'SQLite';
  rsHLRuby               = 'Ruby';
  rsHLInno               = 'Inno Script';
  rsHLCobol              = 'Cobol';
  rsHLFortran            = 'Fortran';
  rsHLHaskell            = 'Haskell';
  rsHLEiffel             = 'Eiffel';
  rsHLIdl                = 'IDL';
  rsHLFoxPro             = 'FoxPro';
  rsHLDOT                = 'DOT Graph';
  rsHLLua                = 'Lua Script';
  rsHLTclTk              = 'Tcl/TK';

  rsHLProlog             = 'Prolog';
  rsHLMod3               = 'Modula 3';



  rsHLSTesting           = 'Convreted Test';

  rsFileExists           = 'The file %S already exists in the disk. Do you want to replace it?';

const
  cHighlighter        = 'Highlighter';
  cSQLSubMenuStart    = 25;
  tpSnippet           = 1;
  tpFolder            = 2;
  idxFolderNormal     = 9;
  idxFolderSelected   = 9;
  idxSnippetNormal    = 11;
  idxSnippetSelected  = 11;

  idxSnippetCppNormal         = 20;
  idxSnippetCppSelected       = 20;
  idxSnippetPascalNormal      = 21;
  idxSnippetPascalSelected    = 21;
  idxSnippetPHPNormal         = 22;
  idxSnippetPHPSelected       = 22;
  idxSnippetPythonNormal      = 23;
  idxSnippetPythonSelected    = 23;
  idxSnippetVBNormal          = 24;
  idxSnippetVBSelected        = 24;
  idxSnippetPerlNormal        = 25;
  idxSnippetPerlSelected      = 25;
  idxSnippetSqlNormal         = 26;
  idxSnippetSqlSelected       = 26;
  idxSnippetJavaNormal        = 27;
  idxSnippetJavaSelected      = 27;
  idxSnippetJScriptNormal     = 28;
  idxSnippetJScriptSelected   = 28;
  idxSnippetBatNormal         = 29;
  idxSnippetBatSelected       = 29;
  idxSnippetFireBirdNormal    = 32;
  idxSnippetFirebirdSelected  = 32;
  idxSnippetMsSQLNormal       = 33;
  idxSnippetMsSQLSelected     = 33;
  idxSnippetMySQLNormal       = 34;
  idxSnippetMySQLSelected     = 34;
  idxSnippetPostgresNormal    = 35;
  idxSnippetPostgresSelected  = 35;
  idxSnippetOracleNormal      = 36;
  idxSnippetOracleSelected    = 36;
  idxSnippetAsmNormal         = 37;
  idxSnippetAsmSelected       = 37;
  idxSnippetCSNormal          = 38;
  idxSnippetCSSelected        = 38;
  idxSnippetSqliteNormal      = 39;
  idxSnippetSqliteSelected    = 39;
  idxSnippetCombolNormal      = 44;
  idxSnippetCombolSelected    = 44;
  idxSnippetInnoNormal        = 45;
  idxSnippetInnoSelected      = 45;
  idxSnippetRubyNormal        = 46;
  idxSnippetRubySelected      = 46;
  idxSnippetFortranNormal     = 47;
  idxSnippetFortranSelected   = 47;
  idxSnippetHaskelNormal      = 48;
  idxSnippethaskelSelected    = 48;
  idxSnippetFoxProNormal      = 49;
  idxSnippetFoxProSelected    = 49;
  idxSnippetDotNormal         = 50;
  idxSnippetDotSelected       = 50;
  idxSnippetEiffelNormal      = 51;
  idxSnippetEiffelSelected    = 51;
  idxSnippetIDLNormal         = 52;
  idxSnippetIDLSelected       = 52;
  idxSnippetLuaNormal         = 53;
  idxSnippetLuaSelected       = 53;
  idxSnippetTclTkNormal       = 54;
  idxSnippetTclTkSelected     = 54;

type

  { TEvsScreenCursor }

  IEvsCursor = interface(IUnknown)
    ['{8B120895-793E-41C8-A4A6-3867F306A1FE}']
  end;

  TEvsScreenCursor = class(TInterfacedObject, IEvsCursor)
  private
    FOldCursor :TCursor;
  public
    constructor Create(aNewCursor:TCursor);
    destructor Destroy; override;
  end;

function ChangeCursor(aCursor:TCursor):IEvsCursor;
begin
  Result := TEvsScreenCursor.Create(aCursor);
end;

var

  LangTitles : array[0..31] of THighlighterData =
{00}    ((Title:rsHLNone;       Instance:Nil; IconIndexNormal:idxSnippetNormal;         IconIndexSelected:idxSnippetSelected),
{01}     (Title:rsHLPascal;     Instance:Nil; IconIndexNormal:idxSnippetPascalNormal;   IconIndexSelected:idxSnippetPascalSelected),
{02}     (Title:rsHLVb;         Instance:Nil; IconIndexNormal:idxSnippetVBNormal;       IconIndexSelected:idxSnippetVBSelected),
{03}     (Title:rsHLPython;     Instance:Nil; IconIndexNormal:idxSnippetPythonNormal;   IconIndexSelected:idxSnippetPythonSelected),
{04}     (Title:rsHLPHP;        Instance:Nil; IconIndexNormal:idxSnippetPHPNormal;      IconIndexSelected:idxSnippetPHPSelected),
{05}     (Title:rsHLPerl;       Instance:Nil; IconIndexNormal:idxSnippetPerlNormal;     IconIndexSelected:idxSnippetPerlSelected),
{06}     (Title:rsHLJava;       Instance:Nil; IconIndexNormal:idxSnippetJavaNormal;     IconIndexSelected:idxSnippetJavaSelected),
{07}     (Title:rsHLBat;        Instance:Nil; IconIndexNormal:idxSnippetBatNormal;      IconIndexSelected:idxSnippetBatSelected),
{08}     (Title:rsHLCPP;        Instance:Nil; IconIndexNormal:idxSnippetCppNormal;      IconIndexSelected:idxSnippetCppSelected),
{09}     (Title:rsHLJavaScript; Instance:Nil; IconIndexNormal:idxSnippetJScriptNormal;  IconIndexSelected:idxSnippetJScriptSelected),
{10}     (Title:rsHLCS;         Instance:Nil; IconIndexNormal:idxSnippetCSNormal;       IconIndexSelected:idxSnippetCSSelected),
{11}     (Title:rsHLASM;        Instance:Nil; IconIndexNormal:idxSnippetAsmNormal;      IconIndexSelected:idxSnippetAsmSelected),
{12}     (Title:rsHLRuby;       Instance:Nil; IconIndexNormal:idxSnippetRubyNormal;     IconIndexSelected:idxSnippetRubySelected),
{13}     (Title:rsHLInno;       Instance:Nil; IconIndexNormal:idxSnippetNormal;         IconIndexSelected:idxSnippetSelected),
{14}     (Title:rsHLCobol;      Instance:Nil; IconIndexNormal:idxSnippetCombolNormal;   IconIndexSelected:idxSnippetCombolSelected),
{15}     (Title:rsHLFortran;    Instance:Nil; IconIndexNormal:idxSnippetFortranNormal;  IconIndexSelected:idxSnippetFortranSelected),
{16}     (Title:rsHLHaskell;    Instance:Nil; IconIndexNormal:idxSnippetHaskelNormal;   IconIndexSelected:idxSnippetHaskelSelected),
{17}     (Title:rsHLEiffel;     Instance:Nil; IconIndexNormal:idxSnippetEiffelNormal;   IconIndexSelected:idxSnippetEiffelSelected),
{18}     (Title:rsHLIdl;        Instance:Nil; IconIndexNormal:idxSnippetIDLNormal;      IconIndexSelected:idxSnippetIDLSelected),
{19}     (Title:rsHLFoxPro;     Instance:Nil; IconIndexNormal:idxSnippetFoxProNormal;   IconIndexSelected:idxSnippetFoxProSelected),
{20}     (Title:rsHLDOT;        Instance:Nil; IconIndexNormal:idxSnippetDotNormal;      IconIndexSelected:idxSnippetDotSelected),
{21}     (Title:rsHLLua;        Instance:Nil; IconIndexNormal:idxSnippetLuaNormal;      IconIndexSelected:idxSnippetLuaSelected),
{22}     (Title:rsHLTclTk;      Instance:Nil; IconIndexNormal:idxSnippetTclTkNormal;    IconIndexSelected:idxSnippetTclTkSelected),
{23}     (Title:rsHLProlog;     Instance:Nil; IconIndexNormal:idxSnippetTclTkNormal;    IconIndexSelected:idxSnippetTclTkSelected),
{24}     (Title:rsHLMod3;       Instance:Nil; IconIndexNormal:idxSnippetTclTkNormal;    IconIndexSelected:idxSnippetTclTkSelected),
     /// SQL HighLighters make sure they are the last ones in the array.
{25}     (Title:rsHLSql;        Instance:Nil; IconIndexNormal:idxSnippetSqlNormal;      IconIndexSelected:idxSnippetSqlSelected),
{26}     (Title:rsHLFirebird;   Instance:Nil; IconIndexNormal:idxSnippetFireBirdNormal; IconIndexSelected:idxSnippetFirebirdSelected),
{27}     (Title:rsHLOracleSql;  Instance:Nil; IconIndexNormal:idxSnippetOracleNormal;   IconIndexSelected:idxSnippetOracleSelected),
{28}     (Title:rsHLPostgreSQL; Instance:Nil; IconIndexNormal:idxSnippetPostgresNormal; IconIndexSelected:idxSnippetPostgresSelected),
{29}     (Title:rsHLMySQL;      Instance:Nil; IconIndexNormal:idxSnippetMySQLNormal;    IconIndexSelected:idxSnippetMySQLSelected),
{30}     (Title:rsHLMsSQL;      Instance:Nil; IconIndexNormal:idxSnippetMsSQLNormal;    IconIndexSelected:idxSnippetMsSQLSelected),
{31}     (Title:rsHLSQLite;     Instance:Nil; IconIndexNormal:idxSnippetSqliteNormal;   IconIndexSelected:idxSnippetSqliteSelected)
    );

function Languages: StringArray;
var
  vCntr  :integer;
  vCount :integer;
  vTest  :TIniFile;
begin
  SetLength(Result, Length(LangTitles));
  vCount := 0;
  for vCntr := low(LangTitles) to High(LangTitles) do
    if Assigned(LangTitles[vCntr].Instance) then begin
      Result[vCount] := LangTitles[vCntr].Title;
      inc(vCount);
    end;
  SetLength(Result, vCount);
end;

function LanguageTitle(const aHighlighter:TSynCustomHighlighter):string;
var
  vCntr : Integer;
begin
  Result := '';
  if Assigned(aHighlighter) then begin
    for vCntr := low(LangTitles) to High(LangTitles) do begin
      if LangTitles[vCntr].Instance = aHighlighter then begin
        Result := LangTitles[vCntr].Title;
        Exit;
      end;
    end;
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

{ TEvsScreenCursor }

constructor TEvsScreenCursor.Create(aNewCursor :TCursor);
begin
  inherited Create;
  FOldCursor := Screen.Cursor;
  Screen.Cursor := aNewCursor;
end;

destructor TEvsScreenCursor.Destroy;
begin
  Screen.Cursor := FOldCursor;
  inherited Destroy;
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
    tvData.AlphaSort;
    vNode.MakeVisible;
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
  tvData.BeginUpdate;
  try
    vNode := NewNode(nil, vName);
    tvData.Selected := vNode;
    tvData.AlphaSort;
    vNode.MakeVisible;
  finally
    tvData.EndUpdate;
  end;
end;

procedure TSnippetsMainFrm.actSetHighlighterExecute(Sender : TObject);
var
  vCntr : Integer;
begin
  if (Sender is TMenuItem) and (TMenuItem(sender).Tag <> 0) then begin
    for vCntr := 0 to tvData.SelectionCount -1 do begin
      SetHighlighter(TSynCustomHighlighter(TMenuItem(Sender).Tag),GetNodePath(tvData.Selections[vCntr]));
      SetNodeIcons(tvData.Selections[vCntr]);
      if IsFolder(tvData.Selections[vCntr]) then ResetChildIcons(tvData.Selections[vCntr], True);
    end;
  end;
end;

procedure TSnippetsMainFrm.actSettingsExecute(Sender : TObject);
var
  vFrm : TEvsOptionsForm;
begin
  vFrm := TEvsOptionsForm.Create(Nil);
  try
    vFrm.SetSupportedLanguages(Languages);
    vFrm.DefaultLanguage     := LanguageTitle(FDefaultHighlighter);
    vFrm.AutoLoadLastLibrary := FAutoLoadLast;
    vFrm.ShowToolbarCaptions := ToolBar1.ShowCaptions;
    vFrm.AutoExpand          := FAutoExpandNodes;
    vFrm.AutoExpandAll       := FAutoExpandAll;
    if vFrm.ShowModal = mrOK then begin
      SetDefaultHighLighter(vFrm.DefaultLanguage);
      FAutoLoadLast := vFrm.AutoLoadLastLibrary;
      SetShowToolBarCaptions(vFrm.ShowToolbarCaptions);
      FAutoExpandNodes := vFrm.AutoExpand;
      FAutoExpandAll   := vFrm.AutoExpandAll;
      SaveSettings;
    end;
  finally
    vFrm.Free
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
  // if the file exists and the user decides not to overwrite it make sure that
  // the current environment is not changed
  if FileExistsUTF8(actFileNew.Dialog.FileName) then begin
    if MessageDlg('New library', Format(rsFileExists, [actFileNew.Dialog.FileName]), mtInformation, [mbYes, mbCancel], 0, mbCancel) <> mrYes then begin
      Exit;
    end;
  end; //user has opted to create the new library no matter what.
  CreateLibrary(actFileNew.Dialog.FileName);
end;

procedure TSnippetsMainFrm.actExpandAllExecute(Sender : TObject);
begin
  ExpandTreeNodes(True)
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
begin
  CollapseTreeNodes(True);
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
    if vChoice = mrYes then begin
      FCodeLib.Delete(vPath);
      if FCodeLib.FileExists(vPath) then raise Exception.Create('unable to delete file'+LineEnding+vPath);
      FCodeLib.Compact;
      vNode := tvData.Selected;
      tvData.Selected := vNode.GetPrevVisible;
      if tvData.Selected = nil then tvData.Selected := vNode.GetNextVisible;
      vNode.Delete;
    end;
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

procedure TSnippetsMainFrm.pmnuTreePopup(Sender : TObject);
begin
  CheckMenu(GetHighLighter(tvData.Selected));
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
  snEditor.ClearAll;
  if IsFile(Node) then begin
    vFile := GetNodePath(Node);
    vStrm := FCodeLib.OpenFile(vFile,fmOpenReadWrite);
    try
      snEditor.Enabled := True;
      snEditor.Lines.LoadFromStream(vStrm);
    finally
      vStrm.Free;
    end;
  end else begin
    snEditor.Lines.Clear;
    snEditor.Enabled := False;
  end;
  snEditor.Highlighter := GetHighLighter(vFile);
  CheckMenu(snEditor.Highlighter);
  StatusBar1.Panels[0].Text := HighLighterTitle(snEditor.Highlighter);
end;

procedure TSnippetsMainFrm.tvDataChanging(Sender : TObject; Node : TTreeNode; var AllowChange : Boolean);
begin
  if snEditor.Modified then begin
    SaveData(Node);
  end;
end;

procedure TSnippetsMainFrm.tvDataCompare(Sender : TObject; Node1, Node2 : TTreeNode; var Compare : Integer);
var
  vStr1, vStr2 : string;
begin
  if IsFolder(Node1) then vStr1 := #32+Node1.Text else vStr1:= #33+Node1.Text;
  if IsFolder(Node2) then vStr2 := #32+Node2.Text else vStr2:= #33+Node2.Text;
  Compare := CompareText(vStr1, vStr2);
end;

procedure TSnippetsMainFrm.tvDataDragDrop(Sender, Source: TObject; X, Y: Integer);
  function vSender:TTreeview;inline;
  begin
    Result := TTreeView(Sender);
  end;

begin
  /// after the drop is made we have to check the following.
  /// 1) is the droped node a folder or a snipet node.
  /// 2) is the target node outside the selected nodes childrent if it is not
  ///    then scream a curse and exit. Other wise start the move operation.
  /// 3) complete the move operation and exit.
  /// The move operation has the following steps.
  ///  1) select all the files and subfiles of the dragged node.
  ///  2) move them inside the library container first.
  ///  3) move the dragged node as child of the dropped node.

end;

procedure TSnippetsMainFrm.tvDataDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := (Source = Sender);
end;

procedure TSnippetsMainFrm.tvDataEdited(Sender : TObject; Node : TTreeNode;
  var S : string);
var
  vTmp : string;

begin
  if not IsFileNameValid(S) then begin
    s := Node.Text;
    {$IFDEF EVS_Abort}Abort{$ELSE }Exit{$ENDIF};
  end;
  if CompareText(S, Node.Text) = 0 then
      {$IFDEF EVS_Abort}Abort{$ELSE }Exit{$ENDIF};
  vTmp := GetNodePath(Node.Parent);
  if FCodeLib.FileExists(vTmp+Node.Text)   then begin
    FCodeLib.Move(vTmp+Node.Text, vTmp+S);
    Exit;
  end;
  if FCodeLib.FolderExists(vTmp+Node.Text) then FCodeLib.Move(vTmp+Node.Text, vTmp+S);
end;

procedure TSnippetsMainFrm.tvDataEditingEnd(Sender : TObject; Node : TTreeNode; Cancel : Boolean);
begin
  if Cancel then Exit;
  tvData.BeginUpdate;//Bounds;
  try
    //Node.Parent.AlphaSort;
    tvData.AlphaSort;
    Node.MakeVisible;
  finally
    tvData.EndUpdate;
  end;
end;

procedure TSnippetsMainFrm.tvDataMouseDown(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then tvData.BeginDrag(False, 5);//5 pixel error threshold for double clicking selecting and everything else that might be needed.
end;

procedure TSnippetsMainFrm.tvDataStartDrag(Sender: TObject;var DragObject: TDragObject);
begin
  /// make sure that you create the appropriate data to pass around and avoid using the the treeview after that.
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
  Result := False;
  if Assigned(aNode) then Result := Integer(aNode.Data) = tpFolder
end;

function TSnippetsMainFrm.IsFile(aNode : TTreeNode) : Boolean;
begin
  Result:= False;
  if Assigned(aNode) then Result := Integer(aNode.Data) = tpSnippet
end;

procedure TSnippetsMainFrm.SetAutoExpandNodes(aValue : Boolean);
begin
  if FAutoExpandNodes = aValue then Exit;
  FAutoExpandNodes := aValue;
end;

function TSnippetsMainFrm.UniqueName(aPath :string; Folder :Boolean) :string;
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
  Result := True ;
  Result := not ((Pos('/',aName) > 0) or (Pos('\',aName) > 0) or (aName = '') or (aName[1] = '.'));
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
  if Folder then
    Result.Data := Pointer(tpFolder)
  else
    Result.Data := Pointer(tpSnippet);
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

procedure TSnippetsMainFrm.ValidateName(aObjectName :string);
begin
  if (aObjectName ='') or (aObjectName[1] <> cCodeLibPathSep) then
    raise Exception.CreateFmt(rsInvalidName, [aObjectName]);
end;

procedure TSnippetsMainFrm.SetShowToolBarCaptions(const aValue : Boolean);
begin
  ToolBar1.AutoSize := True;
  ToolBar1.ShowCaptions := aValue;
  if aValue then begin
    ToolBar1.ButtonHeight := 36;
  end else begin
    ToolBar1.ButtonHeight := 22;
  end;
end;

procedure TSnippetsMainFrm.ValidateFileName(aName : string);
begin
  if (Pos('/',aName) > 0) then raise Exception.Create('</> is an invalid character');
  if (Pos('\',aName) > 0) then raise Exception.Create('<\> is an invalid character');
  if (aName[1] = '.')     then raise Exception.Create('<.> Name can''t start with a dot.');
  if aName = '' then raise Exception.Create('Name must be at least 1 character long');
end;

procedure TSnippetsMainFrm.OpenLibrary(aName :string);
begin
  FCodeLib := Nil;
  FCodeLib := CreateStorage;
  FCodeLib.Initialize(aName, fmOpenReadWrite or fmShareExclusive);
  LoadCodeLib;
  if not FCodeLib.FileExists('/.Settings') then FCodeLib.CreateFolder('/.Settings');
  FLastLibrary := aName;
  if FAutoExpandNodes then ExpandTreeNodes(FAutoExpandAll);
  StatusBar1.Panels[1].Text := aName;
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
var
  vTmp : string;
begin
  if Assigned(aHighlighter) then vTmp := aHighlighter.Name else vTmp := '';
  FCodeLib.GetFileInfo(aFile).SetAttribute(cHighlighter,vTmp);
  snEditor.Highlighter := aHighlighter;
end;

constructor TSnippetsMainFrm.Create(TheOwner : TComponent);
//{24}     (Title:rsHLMod3;      Instance:Nil; IconIndexNormal:idxSnippetTclTkNormal;    IconIndexSelected:idxSnippetTclTkSelected),
  function Mod3Highlighter : TSynCustomHighlighter;
  begin
    Result := nil;
    //Result := TSynM3Syn.Create(Self);
    //Result.Name := 'shlM3';
    //TSynM3Syn(Result).IdentifierAttribute.Foreground := clNone;
    //TSynM3Syn(Result).CommentAttribute.Foreground    := $00A2A2A2;
    //TSynM3Syn(Result).KeywordAttribute.Foreground    := clNavy;
    //TSynM3Syn(Result).NumberAttri.ForeGround         := $004080FF;
    //TSynM3Syn(Result).StringAttribute.ForeGround     := $003FB306;
    //TSynM3Syn(Result).SymbolAttribute.ForeGround     := $00A25151;
  end;

  // Testing and debugging
  function LUAHighlighter    : TSynCustomHighlighter;
  begin
    Result := nil;
    Result := TSynLuaSyn.Create(Self);
    Result.Name := 'shlLua';
    TSynLuaSyn(Result).IdentifierAttribute.Foreground := clNone;
    TSynLuaSyn(Result).CommentAttribute.Foreground    := $00A2A2A2;
    TSynLuaSyn(Result).KeywordAttribute.Foreground    := clNavy;
    TSynLuaSyn(Result).NumberAttri.ForeGround         := $004080FF;
    TSynLuaSyn(Result).StringAttribute.ForeGround     := $003FB306;
    TSynLuaSyn(Result).SymbolAttribute.ForeGround     := $00A25151;
  end;

  function TCLTKHighlighter  : TSynCustomHighlighter;
  begin
    Result := nil;
    Result := TSynTclTkSyn.Create(Self);
    Result.Name := 'shlTCLTK';
    TSynTclTkSyn(Result).IdentifierAttribute.Foreground := clNone;
    TSynTclTkSyn(Result).CommentAttribute.Foreground    := $00A2A2A2;
    TSynTclTkSyn(Result).KeywordAttribute.Foreground    := clNavy;
    TSynTclTkSyn(Result).NumberAttri.ForeGround         := $004080FF;
    TSynTclTkSyn(Result).StringAttribute.ForeGround     := $003FB306;
    TSynTclTkSyn(Result).SymbolAttribute.ForeGround     := $00A25151;
  end;

  function PrologHighlighter : TSynCustomHighlighter;
  begin
    Result := nil;
    Result := TSynPrologSyn.Create(Self);
    Result.Name := 'shlProlog';
    TSynPrologSyn(Result).IdentifierAttribute.Foreground := clNone;
    TSynPrologSyn(Result).CommentAttribute.Foreground    := $00A2A2A2;
    TSynPrologSyn(Result).KeywordAttribute.Foreground    := clNavy;
    TSynPrologSyn(Result).NumberAttri.ForeGround         := $004080FF;
    TSynPrologSyn(Result).StringAttribute.ForeGround     := $003FB306;
    //TSynPrologSyn(Result).SymbolAttribute.ForeGround     := $00A25151;
  end;

  function DOTHighlighter : TSynCustomHighlighter;
  begin
    Result := nil;
    Result := TSynDOTSyn.Create(Self);
    Result.Name := 'shlDOT';
    TSynDOTSyn(Result).IdentifierAttribute.Foreground := clNone;
    TSynDOTSyn(Result).CommentAttribute.Foreground    := $00A2A2A2;
    TSynDOTSyn(Result).KeywordAttribute.Foreground    := clNavy;
    //TSynDOTSyn(Result).NumberAttri.ForeGround         := $004080FF;
    TSynDOTSyn(Result).StringAttribute.ForeGround     := $003FB306;
    TSynDOTSyn(Result).SymbolAttribute.ForeGround     := $00A25151;
  end;

  function InnoHighlighter : TSynCustomHighlighter;
  begin
    Result := nil;
    Result := TSynInnoSyn.Create(Self);
    Result.Name := 'shlInno';
    TSynInnoSyn(Result).IdentifierAttribute.Foreground := clNone;
    TSynInnoSyn(Result).CommentAttribute.Foreground    := $00A2A2A2;
    TSynInnoSyn(Result).KeywordAttribute.Foreground    := clNavy;
    TSynInnoSyn(Result).NumberAttri.ForeGround         := $004080FF;
    TSynInnoSyn(Result).StringAttribute.ForeGround     := $003FB306;
    TSynInnoSyn(Result).SymbolAttribute.ForeGround     := $00A25151;
  end;

  function CobolHighlighter : TSynCustomHighlighter;
  begin
    Result := nil;
    Result := TSynCobolSyn.Create(Self);
    Result.Name := 'shlCobol';
    TSynCobolSyn(Result).IdentifierAttribute.Foreground := clNone;
    TSynCobolSyn(Result).CommentAttribute.Foreground    := $00A2A2A2;
    TSynCobolSyn(Result).KeywordAttribute.Foreground    := clNavy;
    TSynCobolSyn(Result).NumberAttri.ForeGround         := $004080FF;
    TSynCobolSyn(Result).StringAttribute.ForeGround     := $003FB306;
    //TSynCobolSyn(Result).SymbolAttribute.ForeGround     := $00A25151;
  end;

  function EiffelHighlighter : TSynCustomHighlighter;
  begin
    Result := nil;
    Result := TSynEiffelSyn.Create(Self);
    Result.Name := 'shlEiffel';
    TSynEiffelSyn(Result).IdentifierAttribute.Foreground := clNone;
    TSynEiffelSyn(Result).CommentAttribute.Foreground    := $00A2A2A2;
    TSynEiffelSyn(Result).KeywordAttribute.Foreground    := clNavy;
    //TSynEiffelSyn(Result).NumberAttri.ForeGround         := $004080FF;
    TSynEiffelSyn(Result).StringAttribute.ForeGround     := $003FB306;
    //TSynEiffelSyn(Result).SymbolAttribute.ForeGround     := $00A25151;
  end;

  function FortranHighlighter : TSynCustomHighlighter;
  begin
    Result := nil;
    Result := TSynFortranSyn.Create(Self);
    Result.Name := 'shlFortran';
    TSynFortranSyn(Result).IdentifierAttribute.Foreground := clNone;
    TSynFortranSyn(Result).CommentAttribute.Foreground    := $00A2A2A2;
    TSynFortranSyn(Result).KeywordAttribute.Foreground    := clNavy;
    TSynFortranSyn(Result).NumberAttri.ForeGround         := $004080FF;
    TSynFortranSyn(Result).StringAttribute.ForeGround     := $003FB306;
    TSynFortranSyn(Result).SymbolAttribute.ForeGround     := $00A25151;
  end;

  function RubyHighlighter : TSynCustomHighlighter;
  begin
    Result := nil;
    Result := TSynRubySyn.Create(Self);
    Result.Name := 'shlRuby';
    TSynRubySyn(Result).IdentifierAttribute.Foreground := clNone;
    TSynRubySyn(Result).CommentAttribute.Foreground    := $00A2A2A2;
    TSynRubySyn(Result).KeywordAttribute.Foreground    := clNavy;
    TSynRubySyn(Result).NumberAttri.ForeGround         := $004080FF;
    TSynRubySyn(Result).StringAttribute.ForeGround     := $003FB306;
    //TSynRubySyn(Result).SymbolAttribute.ForeGround     := $00A25151;
  end;

  function IDLHighlighter : TSynCustomHighlighter;
  begin
    Result := nil;
    Result := TSynIdlSyn.Create(Self);
    Result.Name := 'shlIDL';
    TSynIdlSyn(Result).IdentifierAttribute.Foreground := clNone;
    TSynIdlSyn(Result).CommentAttribute.Foreground    := $00A2A2A2;
    TSynIdlSyn(Result).KeywordAttribute.Foreground    := clNavy;
    TSynIdlSyn(Result).NumberAttri.ForeGround         := $004080FF;
    TSynIdlSyn(Result).StringAttribute.ForeGround     := $003FB306;
    TSynIdlSyn(Result).SymbolAttribute.ForeGround     := $00A25151;
  end;

  function HaskellHighlighter : TSynCustomHighlighter;
  begin
    Result := nil;
    Result := TSynHaskellSyn.Create(Self);
    Result.Name := 'shlHaskell';
    TSynHaskellSyn(Result).IdentifierAttribute.Foreground := clNone;
    TSynHaskellSyn(Result).CommentAttribute.Foreground    := $00A2A2A2;
    TSynHaskellSyn(Result).KeywordAttribute.Foreground    := clNavy;
    TSynHaskellSyn(Result).NumberAttri.ForeGround         := $004080FF;
    TSynHaskellSyn(Result).StringAttribute.ForeGround     := $003FB306;
    //TSynHaskellSyn(Result).SymbolAttribute.ForeGround     := $00A25151;
  end;

  function FoxProHighlighter : TSynCustomHighlighter;
  begin
    Result := nil;
    Result := TSynFoxproSyn.Create(Self);
    Result.Name := 'shlFoxPro';
    TSynFoxproSyn(Result).IdentifierAttribute.Foreground := clNone;
    TSynFoxproSyn(Result).CommentAttribute.Foreground    := $00A2A2A2;
    TSynFoxproSyn(Result).KeywordAttribute.Foreground    := clNavy;
    TSynFoxproSyn(Result).NumberAttri.ForeGround         := $004080FF;
    TSynFoxproSyn(Result).StringAttribute.ForeGround     := $003FB306;
    TSynFoxproSyn(Result).SymbolAttribute.ForeGround     := $00A25151;
  end;

  // working and used in the program.
  function SQLiteHighlighter : TSynCustomHighlighter;
  begin
    Result      := nil;
    Result      := TEvsSynSQLSyn.Create(Self);
    Result.Name := 'shlSQLiteSQL';
    Result.Tag  := cSQLSubMenuStart+6;
    Result.Assign(shlSQL);
    TEvsSynSQLSyn(Result).SQLDialect := sqlSQLite;
  end;

  function PostgreSQLHighlighter : TSynCustomHighlighter;
  begin
    Result      := nil;
    Result      := TEvsSynSQLSyn.Create(Self);
    Result.Name := 'shlPostgreSQL';
    Result.Tag  := cSQLSubMenuStart+3;
    Result.Assign(shlSQL);
    TEvsSynSQLSyn(Result).SQLDialect := sqlPostgres;
  end;

  function CSharpHighlighter : TSynCustomHighlighter;
  begin
    Result := nil;
    Result := TSynCSSyn.Create(Self);
    Result.Name := 'shlCSharp';
    TSynCSSyn(Result).IdentifierAttribute.Foreground := clNone;
    TSynCSSyn(Result).CommentAttribute.Foreground    := $00A2A2A2;
    TSynCSSyn(Result).KeywordAttribute.Foreground    := clNavy;
    TSynCSSyn(Result).NumberAttri.ForeGround         := $004080FF;
    TSynCSSyn(Result).StringAttribute.ForeGround     := $003FB306;
    TSynCSSyn(Result).SymbolAttribute.ForeGround     := $00A25151;
  end;

  function JavaScriptHighlighter : TSynCustomHighlighter;
  begin
    Result := TSynJScriptSyn.Create(Self);
    Result.Name := 'shlJavaScript';
    TSynJScriptSyn(Result).IdentifierAttribute.Foreground := clNone;
    TSynJScriptSyn(Result).CommentAttribute.Foreground    := $00A2A2A2;
    TSynJScriptSyn(Result).KeywordAttribute.Foreground    := clNavy;
    TSynJScriptSyn(Result).NumberAttri.ForeGround         := $004080FF;
    TSynJScriptSyn(Result).StringAttribute.ForeGround     := $003FB306;
    TSynJScriptSyn(Result).SymbolAttribute.ForeGround     := $00A25151;
  end;

  function AssemblyHighlighter : TSynCustomHighlighter;
  begin
    Result := TSynAsmSyn.Create(Self);
    Result.Name := 'shlAsm';
    TSynAsmSyn(Result).IdentifierAttribute.Foreground := clNone;
    TSynAsmSyn(Result).CommentAttribute.Foreground    := $00A2A2A2;
    TSynAsmSyn(Result).KeywordAttribute.Foreground    := clNavy;
    TSynAsmSyn(Result).NumberAttri.ForeGround         := $004080FF;
    TSynAsmSyn(Result).StringAttribute.ForeGround     := $003FB306;
    TSynAsmSyn(Result).SymbolAttribute.ForeGround     := $00A25151;
    //TSynAsmSyn(Result).VariableAttribute.ForeGround   := clNavy;
  end;

begin
  inherited Create(TheOwner);
  FCodeLib := Nil;
  LangTitles[01].Instance     := shlPascal;
  LangTitles[02].Instance     := shlVB;
  LangTitles[03].Instance     := shlPython;
  LangTitles[04].Instance     := shlPHP;
  LangTitles[05].Instance     := shlPerl;
  LangTitles[06].Instance     := shlJava;
  LangTitles[07].Instance     := shlBAT;
  LangTitles[08].Instance     := shlCPP;
  LangTitles[09].Instance     := JavaScriptHighlighter;
  LangTitles[09].Instance.Tag := 09;
  LangTitles[10].Instance     := CSharpHighlighter;
  LangTitles[10].Instance.Tag := 10;
  LangTitles[11].Instance     := AssemblyHighlighter;
  LangTitles[11].Instance.Tag := 11;

  LangTitles[12].Instance     := RubyHighlighter;
  LangTitles[12].Instance.Tag := 12;
  LangTitles[13].Instance     := InnoHighlighter;
  LangTitles[13].Instance.Tag := 13;
  LangTitles[14].Instance     := CobolHighlighter;
  LangTitles[14].Instance.Tag := 14;
  LangTitles[15].Instance     := FortranHighlighter;
  LangTitles[15].Instance.Tag := 15;
  LangTitles[16].Instance     := HaskellHighlighter;
  LangTitles[16].Instance.Tag := 16;
  LangTitles[17].Instance     := EiffelHighlighter;
  LangTitles[17].Instance.Tag := 17;
  LangTitles[18].Instance     := IDLHighlighter;
  LangTitles[18].Instance.Tag := 18;
  LangTitles[19].Instance     := FoxProHighlighter;
  LangTitles[19].Instance.Tag := 19;
  LangTitles[20].Instance     := DOTHighlighter;
  LangTitles[20].Instance.Tag := 20;

  LangTitles[21].Instance     := LUAHighlighter;
  LangTitles[21].Instance.Tag := 21;
  LangTitles[22].Instance     := TCLTKHighlighter;
  LangTitles[22].Instance.Tag := 22;
  LangTitles[23].Instance     := PrologHighlighter;
  LangTitles[23].Instance.Tag := 23;
  //LangTitles[24].Instance     := Mod3Highlighter;
  //LangTitles[24].Instance.Tag := 24;

  LangTitles[cSQLSubMenuStart].Instance := shlSQL;
  LangTitles[cSQLSubMenuStart+1].Instance := shlSqlInterbase;
  LangTitles[cSQLSubMenuStart+2].Instance := shlSqlOracle;
  LangTitles[cSQLSubMenuStart+3].Instance := PostgreSQLHighlighter;
  LangTitles[cSQLSubMenuStart+4].Instance := shlSqlMySQL;
  LangTitles[cSQLSubMenuStart+5].Instance := shlSqlMsSql2000;
  LangTitles[cSQLSubMenuStart+6].Instance := SQLiteHighlighter;

  BuildHighLightPopup(pmnuTree.Items);
  tvData.PopupMenu    := pmnuTree;
  FDefaultHighlighter := shlPascal;
  LoadSettings;
  if FAutoLoadLast and (FLastLibrary <> '') then OpenLibrary(FLastLibrary);
  snEditor.Lines.Clear;
end;

destructor TSnippetsMainFrm.Destroy;
begin
  SaveSettings;
  FCodeLib := nil;
  inherited Destroy;
end;

procedure TSnippetsMainFrm.LoadCodeLib;
  procedure LoadNodeFolder(aNode:TTreeNode);
  var
    vNode     : TTreeNode;
    vFolders,
    vFiles    : TStringList;
    vCnt      : Integer;
    vPath     : string;
  begin
    vFolders := TStringList.Create;
    vFiles   := TStringList.Create;
    try
      vPath := GetNodePath(aNode);
      FCodeLib.FolderNames(vPath, vFolders);
      for vCnt := 0 to vFolders.Count -1 do begin {names starting with a dot are to be invinsible to the end user.}
        if vFolders[vCnt][1] <> '.' then vNode := NewNode(aNode, vFolders[vCnt]);
        LoadNodeFolder(vNode);
      end;
      FCodeLib.FileNames(vPath, VFiles);
      for vCnt := 0 to vFiles.Count -1 do begin
        if vFiles[vCnt][1] <> '.' then vNode := NewNode(aNode, vFiles[vCnt], False);
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
    tvData.SortType := stBoth;
    tvData.Items.EndUpdate;
  end;
end;

procedure TSnippetsMainFrm.LoadSettings;
var
  vFname       : string;
  vConfig      : TIniFile;
  vShowCaption : Boolean;
  vLastLib     : string;
begin
  vFname := uVar.ConfigFileName;
  vConfig := TIniFile.Create(vFname);
  try
    FAutoLoadLast        := vConfig.ReadBool  ('General', 'LoadLast',     False);
    //FLastLibrary         := vConfig.ReadString('General', 'Library',      '');
    vLastLib             := vConfig.ReadString('General', 'Library',      '');
    FLastLibrary         := CreateAbsolutePath(vLastLib, ApplicationFolder);
    FAutoExpandNodes     := vConfig.ReadBool  ('General', 'AutoExpand',   False);
    FAutoExpandAll       := vConfig.ReadBool  ('General', 'AllNodes',     True);
    vShowCaption         := vConfig.ReadBool  ('ToolBar', 'ShowCaptions', True);
    SetShowToolBarCaptions(vConfig.ReadBool   ('ToolBar', 'ShowCaptions', True));
    FDefaultHighlighter  := TSynCustomHighlighter(FindComponent(vConfig.ReadString('General', 'DefaultHighLighter', 'shlPascal')));
    tvData.Width         := vConfig.ReadInteger('General', 'TreeWidth',    280);
  finally
    vConfig.Free;
  end;
end;

procedure TSnippetsMainFrm.SaveSettings;
var
  vFname   : string;
  vConfig  : TIniFile;
  vLastLib : string;
begin
  vFname := uVar.ConfigFileName;
  vConfig := TIniFile.Create(vFname);
  try
    vConfig.WriteBool   ('General', 'LoadLast',           FAutoLoadLast);
    vConfig.WriteBool   ('ToolBar', 'ShowCaptions',       ToolBar1.ShowCaptions);
    vConfig.WriteBool   ('General', 'AutoExpand',         FAutoExpandNodes);
    vConfig.WriteBool   ('General', 'AllNodes',           FAutoExpandAll);
    vLastLib := CreateRelativePath(FLastLibrary, ApplicationFolder);
    vConfig.WriteString ('General', 'Library',            vLastLib);
    vConfig.WriteString ('General', 'DefaultHighLighter', FDefaultHighlighter.Name);
    vConfig.WriteInteger('General', 'TreeWidth',          tvData.Width);
  finally
    vConfig.Free;
  end;
end;

function FindDataModule(const aClass:TClass):TDataModule;
var
  vCntr : Integer;
begin
  Result := nil;
  for vCntr := 0 to Screen.DataModuleCount -1 do begin
    if Screen.DataModules[vCntr].ClassType = aClass then begin
      Result := Screen.DataModules[vCntr];
      Break;
    end;
  end;
end;

function FindForm(const aClass:TClass):TForm;
var
  vCntr : Integer;
begin
  Result := nil;
  for vCntr := 0 to Screen.FormCount -1 do begin
    if Screen.Forms[vCntr].ClassType = aClass then begin
      Result := Screen.Forms[vCntr];
      Break;
    end;
  end;
end;

procedure TSnippetsMainFrm.SetNodeIcons(const aNode : TTreeNode; Recursive:Boolean=False);
  procedure DoRecursive;
  var
    vNode   : TTreeNode;
  begin
    if Recursive and aNode.HasChildren then begin
      vNode:= aNode.GetFirstChild;
      repeat
        SetNodeIcons(vNode, Recursive);
        vNode := vNode.GetNextSibling;
      until vNode = Nil;
    end;
  end;

var
  vHL     : TSynCustomHighlighter;
  vHLData : PHighlighterData;
begin
  vHL     := GetHighLighter(aNode);
  vHLData := HighLighterData(vHL);
  if IsFile(aNode) and Assigned(vHLData) then begin   // there is not way that the vHLData will not be assigned but just in case I fucked up somewhere
    aNode.ImageIndex    := vHLData^.IconIndexNormal;
    aNode.SelectedIndex := vHLData^.IconIndexSelected;
  end else begin
    if IsFolder(aNode) then begin
      aNode.ImageIndex    := idxFolderNormal;
      aNode.SelectedIndex := idxFolderSelected;
      //DoRecursive;
    end else begin
     aNode.ImageIndex    := idxSnippetNormal;
     aNode.SelectedIndex := idxSnippetSelected;
    end;
  end;
end;

procedure TSnippetsMainFrm.SetDefaultHighLighter(const aTitle : string);
var
  vCntr : Integer;
begin
  for vCntr := Low(LangTitles) to High(LangTitles) do begin
    if CompareText(LangTitles[vCntr].Title, aTitle) = 0 then begin
      FDefaultHighlighter := LangTitles[vCntr].Instance;
    end;
  end;
end;

procedure TSnippetsMainFrm.ResetChildIcons(const aParent :TTreeNode; const Recursive :Boolean);
var
  aNode :TTreeNode;
begin
  SetNodeIcons(aParent);
  if aParent.HasChildren then begin
    aNode := aParent.GetFirstChild;
    while aNode <> nil do begin
      SetNodeIcons(aNode);
      if aNode.HasChildren and Recursive then ResetChildIcons(aNode);
      aNode := aNode.GetNextSibling;
    end;
  end;
end;

procedure TSnippetsMainFrm.ExpandTreeNodes(const aAll : Boolean);
var
  vNode: TTreeNode;
begin
  vNode := tvData.Items.GetFirstNode;
  while vNode <> nil do begin
    vNode.Expand(aAll);
    vNode := vNode.GetNextSibling;
  end;
end;

procedure TSnippetsMainFrm.CollapseTreeNodes(const aAll : Boolean);
var
  vNode: TTreeNode;
begin
  vNode := tvData.Items.GetFirstNode;
  while vNode <> nil do begin
    vNode.Collapse(aAll);
    vNode := vNode.GetNextSibling;
  end;
end;

procedure TSnippetsMainFrm.ImportComponentSuite(const aDir :String);
begin
  // import all the files in a directory and its sub directorires as a subtree in the selected folder.
  // If no folder is selected use the focused node parent if no node is focused or selected then create
  // a new root level folder for the suit. If the folder name is in coflict with an existing name add some
  // kind of autoinc at the end of the name to allow us to import the damn thing if the user does not like
  // it he can always edit the name after the import to something more to his taste.
  // The idea is that importing is to never fail for not matter what and to never miss any files.

  //there are a couple of things that need to taken in to account.
  //1) what happens with no source/text files eg compressed rar/zip/tar/gz/bzip2 etc
  //2) what happens with pdfs/html etc.
end;

procedure TSnippetsMainFrm.CreateLibrary(const aFileName :string);
begin
  FCodeLib := CreateStorage;
  FCodeLib.Initialize(aFileName, fmCreate);
  LoadCodeLib;
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
  vCntr   : Integer;
  vMni    : TMenuItem;
  vSQLMni : TMenuItem;
begin
  aParent.Clear;
  for vCntr := Low(LangTitles) to cSQLSubMenuStart - 1 do begin
    if LangTitles[vCntr].Instance <> nil then begin
      vMni            := TMenuItem.Create(Self);
      vMni.Caption    := LangTitles[vCntr].Title;
      vMni.Tag        := PtrUInt(LangTitles[vCntr].Instance);
      vMni.OnClick    := @actSetHighlighterExecute;
      vMni.AutoCheck  := True;
      vMni.RadioItem  := True;
      vMni.GroupIndex := 1;
      vMni.Checked    := (LangTitles[vCntr].Instance = FDefaultHighlighter);
      aParent.Add(vMni);
    end;
  end;
  vSQLMni := TMenuItem.Create(Self);
  vSQLMni.Caption := 'SQL';
  vSQLMni.AutoCheck  := True;
  vSQLMni.RadioItem  := True;
  vSQLMni.GroupIndex := 1;
  aParent.Add(vSQLMni);
  for vCntr := cSQLSubMenuStart to High(LangTitles) do begin
    if LangTitles[vCntr].Instance <> nil then begin
      vMni            := TMenuItem.Create(Self);
      vMni.Caption    := LangTitles[vCntr].Title;
      vMni.Tag        := PtrUInt(LangTitles[vCntr].Instance);
      vMni.OnClick    := @actSetHighlighterExecute;
      vMni.AutoCheck  := True;
      vMni.RadioItem  := True;
      vMni.GroupIndex := 2;
      vMni.Checked    := (LangTitles[vCntr].Instance = FDefaultHighlighter);
      vSQLMni.Add(vMni);
    end;
  end;
end;

procedure TSnippetsMainFrm.CheckMenu(const aHighlighter : TSynCustomHighlighter);
var
  vCntr : Integer;
begin
  for vCntr := 0 to pmnuTree.Items.Count -2 do begin
    if (pmnuTree.Items[vCntr].Tag = PtrInt(aHighlighter)) then begin
      pmnuTree.Items[vCntr].Checked := True;
      Exit;
    end;
  end;
  // if reached here then an sql dialect is selected.
  pmnuTree.Items[pmnuTree.Items.Count -1].Checked := True;
  for vCntr := 0 to pmnuTree.Items[pmnuTree.Items.Count -1].Count -1 do begin
    if (pmnuTree.Items[pmnuTree.Items.Count -1].Items[vCntr].Tag = PtrInt(aHighlighter)) and (not pmnuTree.Items[pmnuTree.Items.Count -1].Items[vCntr].Checked) then begin
      pmnuTree.Items[pmnuTree.Items.Count -1].Items[vCntr].Checked := True;
      Break;
    end;
  end;
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
  vBckCurs         : IEvsCursor;

  procedure CopyAttributes(aFrom, aTo:String); //attributes are used to keep info like language and in the future, Supported OS, Required Library, etc.
  var
    vAttrCntr  :Integer;
    vAttrNames :TStringList;
    vAttrib    :string;
  begin
    vAttrNames := TStringList.Create;
    try
      vFromLib.GetFileInfo(aFrom).AttributeNames(vAttrNames);
      for vAttrCntr := 0 to vAttrNames.Count -1 do begin
        vAttrib := vFromLib.GetFileInfo(aFrom).GetAttribute(vAttrNames[vAttrCntr]);
        vToLib.GetFileInfo(aTo).SetAttribute(vAttrNames[vAttrCntr], vAttrib);
      end;
    finally
      vAttrNames.Free;
    end;
  end;

  procedure CopyAttributes(aFrom, aTo:String); //attributes are used to keep info like language and in the future, Supported OS, Required Library, etc.
  var
    vAttrCntr:Integer;
    vAttrNames:TStringList;
  begin
    vFromLib.GetFileInfo(aFrom).AttributeNames(vAttrNames);
    for vAttrCntr := 0 to vAttrNames.Count -1 do begin
      vToLib.GetFileInfo(aTo).SetAttribute(vAttrNames.Strings[vAttrCntr],vFromLib.GetFileInfo(aFrom).GetAttribute(vAttrNames.Strings[vAttrCntr]));
    end;
  end;

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
<<<<<<< HEAD
        CopyAttributes(vNewFolder, InclPathDel(aSourceFolder) + vFolders[vCnt]);
=======
        CopyAttributes(vNewFolder, vNewFolder);
>>>>>>> 747aae165a283c89228d908bb5cbe9c7cd942bda
        ImportFolder(aSourceFolder + vFolders[vCnt] +cDelim, vNewFolder);
      end;
      vFromLib.FileNames(aSourceFolder, vFiles);
      aDestFolder := InclPathDel(aDestFolder);
      for vCnt := 0 to vFiles.Count -1 do begin
        vFrom := vFromLib.OpenFile(aSourceFolder+vFiles[vCnt], fmOpenReadWrite);
        vTo   := vToLib.OpenFile(aDestFolder+vFiles[vCnt], fmCreate);
        try
          vTo.CopyFrom(vFrom, 0);
        finally
          vFrom.Free;
          vTo.Free;
        end;
        CopyAttributes(aSourceFolder+vFiles[vCnt], aDestFolder+vFiles[vCnt]);
      end;
    finally
      vFolders.Free;
      vFiles.Free;
    end;
  end;

begin
  vBckCurs := ChangeCursor(crHourGlass);
  Enabled := False;
  try
    vFromLib := CreateStorage;
    vFromLib.Initialize(aFileName, fmOpenReadWrite or fmShareExclusive);
    vToLib := FCodeLib;
<<<<<<< HEAD
    if vToLib.FolderExists(aRootFolder) then //need to change this bhavior the root folder will act only as a host it makes no sense to have a non existing host.
=======
    if vToLib.FolderExists(aRootFolder) then
>>>>>>> 747aae165a283c89228d908bb5cbe9c7cd942bda
      raise Exception.CreateFmt('Folder %S already exists in the library',[aRootFolder]);
    ImportFolder('/', aRootFolder);
    LoadCodeLib;
  finally
    Enabled := True;
  end;
end;

end.


