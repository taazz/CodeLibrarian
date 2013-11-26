unit uOptions;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, DividerBevel, ExtCtrls;

type
  //NOTE 1 : LCL has a very nusty behavior with the combo boxies.
  //         If you have a combo box's list open and you press enter
  //         first the combo box closes and then the form receives the enter key and
  //         executing the default button. Enabling the form's keypreview property
  //         does not help at all. This makes me feel vary uneasy so I use the
  //         asynchronous call trick to stop closing the dialog when a combo list is open.

  TEvsOptionsForm = class(TForm)
    cbAutoLoad : TCheckBox;
    cbShowCaptions : TCheckBox;
    cbAutoExpand : TCheckBox;
    cmbDefaultLang : TComboBox;
    DividerBevel1 : TDividerBevel;
    Label1 : TLabel;
    btnOK : TSpeedButton;
    btnCancel : TSpeedButton;
    Label2 : TLabel;
    lblShowToolbarCaptions : TLabel;
    Panel1 : TPanel;
    rbLevel1 : TRadioButton;
    rbAll : TRadioButton;
    procedure btnCancelClick(Sender : TObject);
    procedure btnOKClick(Sender : TObject);
    procedure cbAutoExpandChange(Sender : TObject);
    procedure cmbDefaultLangCloseUp(Sender : TObject);
    procedure cmbDefaultLangDropDown(Sender : TObject);
    procedure FormKeyPress(Sender : TObject; var Key : char);
    procedure Label2Click(Sender : TObject);
    procedure lblShowToolbarCaptionsClick(Sender : TObject);
  private
    { private declarations }
    FComboOpen : TCustomComboBox;
    procedure ComboClose(Data: PtrInt);
    function GetAutoExpand : Boolean;
    function GetAutoExpandAll : Boolean;
    function GetAutoLoadLastLibrary : Boolean;
    function GetDefaultLangIndex : Integer;
    function GetDefaultLanguage : String;
    function GetShowToolbarCaptions : Boolean;
    procedure SetAutoExpand(aValue : Boolean);
    procedure SetAutoExpandAll(aValue : Boolean);
    procedure SetAutoLoadLastLibrary(aValue : Boolean);
    procedure SetDefaultLangIndex(aValue : Integer);
    procedure SetDefaultLanguage(aValue : String);
    procedure SetShowToolbarCaptions(aValue : Boolean);
  public
    constructor Create(aOwner:TComponent);override;

    procedure SetSupportedLanguages(const aLangArray : array of string);
    property DefaultLanguageIndex : Integer read GetDefaultLangIndex    write SetDefaultLangIndex;
    property DefaultLanguage      : String  read GetDefaultLanguage     write SetDefaultLanguage;
    property AutoLoadLastLibrary  : Boolean read GetAutoLoadLastLibrary write SetAutoLoadLastLibrary;
    property ShowToolbarCaptions  : Boolean read GetShowToolbarCaptions write SetShowToolbarCaptions;
    property AutoExpand           : Boolean read GetAutoExpand          write SetAutoExpand;
    property AutoExpandAll        : Boolean read GetAutoExpandAll       write SetAutoExpandAll;
  end;

var
  EvsOptionsForm : TEvsOptionsForm;

implementation

{$R *.lfm}

{ TEvsOptionsForm }

procedure TEvsOptionsForm.btnOKClick(Sender : TObject);
begin
  ModalResult := mrOK;
end;

procedure TEvsOptionsForm.cbAutoExpandChange(Sender : TObject);
begin
  rbAll.Enabled    := TCheckBox(Sender).Checked;
  rbLevel1.Enabled := TCheckBox(Sender).Checked;
end;

procedure TEvsOptionsForm.cmbDefaultLangCloseUp(Sender : TObject);
begin
  Application.QueueAsyncCall(@ComboClose,PtrUInt(Sender));//note1
end;

procedure TEvsOptionsForm.cmbDefaultLangDropDown(Sender : TObject);
begin
  FComboOpen := TCustomComboBox(Sender);//note1
end;

procedure TEvsOptionsForm.FormKeyPress(Sender : TObject; var Key : char);
begin
  if Assigned(FComboOpen) then Exit;
  if Key = #13 then btnOKClick(btnOK);
  if Key = #27 then btnCancelClick(btnCancel);
end;

procedure TEvsOptionsForm.Label2Click(Sender : TObject);
begin
  cbAutoLoad.Checked := not cbAutoLoad.Checked;
end;

procedure TEvsOptionsForm.lblShowToolbarCaptionsClick(Sender : TObject);
begin
  cbShowCaptions.Checked := not cbShowCaptions.Checked;
end;

procedure TEvsOptionsForm.ComboClose(Data : PtrInt);
begin
  FComboOpen := nil;//note1
end;

function TEvsOptionsForm.GetAutoExpand : Boolean;
begin
  Result := cbAutoExpand.Checked;
end;

function TEvsOptionsForm.GetAutoExpandAll : Boolean;
begin
  Result := rbAll.Checked;
end;

function TEvsOptionsForm.GetAutoLoadLastLibrary : Boolean;
begin
  Result := cbAutoLoad.Checked;
end;

function TEvsOptionsForm.GetDefaultLangIndex : Integer;
begin
  Result := cmbDefaultLang.ItemIndex;
end;

function TEvsOptionsForm.GetDefaultLanguage : String;
begin
  Result := cmbDefaultLang.Text;
end;

function TEvsOptionsForm.GetShowToolbarCaptions : Boolean;
begin
  result := cbShowCaptions.Checked
end;

procedure TEvsOptionsForm.SetAutoExpand(aValue : Boolean);
begin
  cbAutoExpand.Checked := aValue;
end;

procedure TEvsOptionsForm.SetAutoExpandAll(aValue : Boolean);
begin
  rbLevel1.Checked := not aValue;     rbAll.Checked := aValue;
end;

procedure TEvsOptionsForm.SetAutoLoadLastLibrary(aValue : Boolean);
begin
  cbAutoLoad.Checked := aValue;
end;

procedure TEvsOptionsForm.SetDefaultLangIndex(aValue : Integer);
begin
  cmbDefaultLang.ItemIndex := aValue;
end;

procedure TEvsOptionsForm.SetDefaultLanguage(aValue : String);
begin
  //cmbDefaultLang.ItemIndex := cmbDefaultLang.Items.IndexOf(aValue);
  cmbDefaultLang.Text := aValue;
end;

procedure TEvsOptionsForm.SetShowToolbarCaptions(aValue : Boolean);
begin
  cbShowCaptions.Checked := aValue;
end;

procedure TEvsOptionsForm.SetSupportedLanguages(const aLangArray : array of string);
var
  vCntr : Integer;
begin
  cmbDefaultLang.Items.Clear;
  for vCntr := Low(aLangArray) to High(aLangArray) do begin
    cmbDefaultLang.Items.Add(aLangArray[vCntr]);
  end;
end;

constructor TEvsOptionsForm.Create(aOwner : TComponent);
begin
  inherited Create(aOwner);
  FComboOpen := nil;
end;

procedure TEvsOptionsForm.btnCancelClick(Sender : TObject);
begin
  ModalResult := mrCancel;
end;

end.

