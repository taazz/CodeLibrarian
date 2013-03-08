unit testGpStructuredStorage1;

{$MODE Delphi}

interface

uses
  {LCLIntf, LCLType, LMessages,}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, FileUtil,
  GpStructuredStorage;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnFullTest             : TButton;
    btnTestBigAndSmall      : TButton;
    btnTestAttributes       : TButton;
    btnTestCompacting       : TButton;
    btnTestEnumerating      : TButton;
    btnTestExceptions       : TButton;
    btnTestExists           : TButton;
    btnTestFlatFileSystem   : TButton;
    btnTestFolders          : TButton;
    btnTestFragmentedFiles  : TButton;
    btnTestMovingAndDeleting: TButton;
    btnTestStorageCreation  : TButton;
    btnTestTruncation       : TButton;
    cbCreation : TCheckBox;
    cbFlatFileSystem : TCheckBox;
    cbCompact : TCheckBox;
    cbExceptions : TCheckBox;
    cbBigAndSmall : TCheckBox;
    cbFragmentedFiles : TCheckBox;
    cbFolders : TCheckBox;
    cbTruncation : TCheckBox;
    cbExists : TCheckBox;
    cbEnumerating : TCheckBox;
    cbMoveAndDelete : TCheckBox;
    cbAttributes : TCheckBox;
    lbLog                   : TListBox;
    procedure btnFullTestClick(Sender: TObject);
    procedure btnTestAttributesClick(Sender: TObject);
    procedure btnTestBigAndSmallClick(Sender: TObject);
    procedure btnTestCompactingClick(Sender: TObject);
    procedure btnTestEnumeratingClick(Sender: TObject);
    procedure btnTestExceptionsClick(Sender: TObject);
    procedure btnTestExistsClick(Sender: TObject);
    procedure btnTestFlatFileSystemClick(Sender: TObject);
    procedure btnTestFoldersClick(Sender: TObject);
    procedure btnTestFragmentedFilesClick(Sender: TObject);
    procedure btnTestMovingAndDeletingClick(Sender: TObject);
    procedure btnTestStorageCreationClick(Sender: TObject);
    procedure btnTestTruncationClick(Sender: TObject);
    procedure cbAttributesChange(Sender : TObject);
    procedure cbBigAndSmallChange(Sender : TObject);
    procedure cbCompactChange(Sender : TObject);
    procedure cbCreationChange(Sender : TObject);
    procedure cbEnumeratingChange(Sender : TObject);
    procedure cbExceptionsChange(Sender : TObject);
    procedure cbExistsChange(Sender : TObject);
    procedure cbFlatFileSystemChange(Sender : TObject);
    procedure cbFoldersChange(Sender : TObject);
    procedure cbFragmentedFilesChange(Sender : TObject);
    procedure cbMoveAndDeleteChange(Sender : TObject);
    procedure cbTruncationChange(Sender : TObject);
  private
    FChanging : Boolean;
    function  CreateAttrSnapshot(iInfo: IGpStructuredFileInfo): string;
    function  CreateSnapshot(storage: IGpStructuredStorage): string;
    function  Expect(fnResult, value: boolean): boolean; overload;
    function  Expect(fnResult, value: string): boolean; overload;
    function  FileSize(const fileName: string): integer;
    procedure Log(const msg: string);
    procedure TestFile(storage: IGpStructuredStorage; const fileName: string;
      write: boolean; sizeFactor: integer = 1); overload;
    procedure TestFile(strFile: TStream; write: boolean; sizeFactor: integer); overload;
    function  TestGSSAttributes: boolean;
    function  TestGSSBigAndSmall: boolean;
    function  TestGSSCompacting: boolean;
    function  TestGSSCreation: boolean;
    function  TestGSSEnumerating: boolean;
    function  TestGSSExceptions: boolean;
    function  TestGSSExists: boolean;
    function  TestGSSFlatFileSystem: boolean;
    function  TestGSSFolders: boolean;
    function  TestGSSFragmentedFiles: boolean;
    function  TestGSSMovingAndDeleting: boolean;
    function  TestGSSTruncation: boolean;
    function AnycheckEnabled:Boolean;
  end;

var
  Form1: TForm1;

implementation

const
  CStorageFile = 'test.stg';

{$R *.lfm}

procedure TForm1.btnFullTestClick(Sender: TObject);
begin
  lbLog.Items.Clear;
  if cbCreation.Checked        then if not TestGSSCreation          then Exit;
  if cbFlatFileSystem.Checked  then if not TestGSSFlatFileSystem    then Exit;
  if cbBigAndSmall.Checked     then if not TestGSSBigAndSmall       then Exit;
  if cbFragmentedFiles.Checked then if not TestGSSFragmentedFiles   then Exit;
  if cbFolders.Checked         then if not TestGSSFolders           then Exit;
  if cbTruncation.Checked      then if not TestGSSTruncation        then Exit;
  if cbExists.Checked          then if not TestGSSExists            then Exit;
  if cbEnumerating.Checked     then if not TestGSSEnumerating       then Exit;
  if cbMoveAndDelete.Checked   then if not TestGSSMovingAndDeleting then Exit;
  if cbAttributes.Checked      then if not TestGSSAttributes        then Exit;
  if cbCompact.Checked         then if not TestGSSCompacting        then Exit;
  if cbExceptions.Checked      then if not TestGSSExceptions        then Exit;
  Log('*** OK ***');
end; { TForm1.btnFullTestClick }

procedure TForm1.btnTestAttributesClick(Sender: TObject);
begin
  if TestGSSAttributes then
    Log('*** OK ***');
end; { TForm1.btnTestAttributesClick }

procedure TForm1.btnTestBigAndSmallClick(Sender: TObject);
begin
  if TestGSSBigAndSmall then
    Log('*** OK ***');
end; { TForm1.btnTesrtBigAndSmallClick }

procedure TForm1.btnTestCompactingClick(Sender: TObject);
begin
  if TestGSSCompacting then
    Log('*** OK ***');
end; { TForm1.btnTestCompactingClick }

procedure TForm1.btnTestEnumeratingClick(Sender: TObject);
begin
  if TestGSSEnumerating then
    Log('*** OK ***');
end; { TForm1.btnTestEnumeratingClick }

procedure TForm1.btnTestExceptionsClick(Sender: TObject);
begin
  if TestGSSExceptions then
    Log('*** OK ***');
end; { TForm1.btnTestExceptionsClick }

procedure TForm1.btnTestExistsClick(Sender: TObject);
begin
  if TestGSSExists then
    Log('*** OK ***');
end; { TForm1.btnTestExistsClick }

procedure TForm1.btnTestFlatFileSystemClick(Sender: TObject);
begin
  if TestGSSFlatFileSystem then
    Log('*** OK ***');
end; { TForm1.btnTestFlatFileSystemClick }

procedure TForm1.btnTestFoldersClick(Sender: TObject);
begin
  if TestGSSFolders then
    Log('*** OK ***');
end; { TForm1.btnTestFoldersClick }

procedure TForm1.btnTestFragmentedFilesClick(Sender: TObject);
begin
  if TestGSSFragmentedFiles then
    Log('*** OK ***');
end; { TForm1.btnTestFragmentedFilesClick }

procedure TForm1.btnTestMovingAndDeletingClick(Sender: TObject);
begin
  if TestGSSMovingAndDeleting then
    Log('*** OK ***');
end; { TForm1.btnTestMovingAndDeletingClick }

procedure TForm1.btnTestStorageCreationClick(Sender: TObject);
begin
  if TestGSSCreation then
    Log('*** OK ***');
end; { TForm1.btnTestStorageCreationClick }

procedure TForm1.btnTestTruncationClick(Sender: TObject);
begin
  if TestGSSTruncation then
    Log('*** OK ***');
end; { TForm1.btnTestTruncationClick }

procedure TForm1.cbAttributesChange(Sender : TObject);
begin
  if FChanging then Exit;
  FChanging := true;
  try
    btnTestAttributes.Enabled := cbAttributes.Checked;
    btnFullTest.Enabled := AnycheckEnabled;
  finally
    FChanging := False;
  end;
end;

procedure TForm1.cbBigAndSmallChange(Sender : TObject);
begin
  if FChanging then Exit;
  FChanging := true;
  try
    btnTestBigAndSmall.Enabled := cbBigAndSmall.Checked;
    btnFullTest.Enabled := AnycheckEnabled;
  finally
    FChanging := False;
  end;
end;

procedure TForm1.cbCompactChange(Sender : TObject);
begin
  if FChanging then Exit;
  FChanging := true;
  try
    btnTestCompacting.Enabled := cbCompact.Checked;
    btnFullTest.Enabled := AnycheckEnabled;
  finally
    FChanging := False;
  end;
end;

procedure TForm1.cbCreationChange(Sender : TObject);
begin
  if FChanging then Exit;
  FChanging := true;
  try
    btnTestStorageCreation.Enabled := cbCreation.Checked;
    btnFullTest.Enabled := AnycheckEnabled;
  finally
    FChanging := False;
  end;
end;

procedure TForm1.cbEnumeratingChange(Sender : TObject);
begin
  if FChanging then Exit;
  FChanging := true;
  try
    btnTestEnumerating.Enabled := cbEnumerating.Checked;
    btnFullTest.Enabled := AnycheckEnabled;
  finally
    FChanging := False;
  end;
end;

procedure TForm1.cbExceptionsChange(Sender : TObject);
begin
  if FChanging then Exit;
  FChanging := true;
  try
    btnTestExceptions.Enabled := cbExceptions.Checked;
    btnFullTest.Enabled := AnycheckEnabled;
  finally
    FChanging := False;
  end;
end;

procedure TForm1.cbExistsChange(Sender : TObject);
begin
  if FChanging then Exit;
  FChanging := true;
  try
    btnTestExists.Enabled := cbExists.Checked;
    btnFullTest.Enabled := AnycheckEnabled;
  finally
    FChanging := False;
  end;
end;

procedure TForm1.cbFlatFileSystemChange(Sender : TObject);
begin
  if FChanging then Exit;
  FChanging := true;
  try
    btnTestFlatFileSystem.Enabled := cbFlatFileSystem.Checked;
    btnFullTest.Enabled := AnycheckEnabled;
  finally
    FChanging := False;
  end;
end;

procedure TForm1.cbFoldersChange(Sender : TObject);
begin
  if FChanging then Exit;
  FChanging := true;
  try
    btnTestFolders.Enabled := cbFolders.Checked;
    btnFullTest.Enabled := AnycheckEnabled;
  finally
    FChanging := False;
  end;
end;

procedure TForm1.cbFragmentedFilesChange(Sender : TObject);
begin
  if FChanging then Exit;
  FChanging := true;
  try
    btnTestFragmentedFiles.Enabled := cbFragmentedFiles.Checked;
    btnFullTest.Enabled := AnycheckEnabled;
  finally
    FChanging := False;
  end;
end;

procedure TForm1.cbMoveAndDeleteChange(Sender : TObject);
begin
  if FChanging then Exit;
  FChanging := true;
  try
    btnTestMovingAndDeleting.Enabled := cbMoveAndDelete.Checked;
    btnFullTest.Enabled := AnycheckEnabled;
  finally
    FChanging := False;
  end;
end;

procedure TForm1.cbTruncationChange(Sender : TObject);
begin
  if FChanging then Exit;
  FChanging := true;
  try
    btnTestTruncation.Enabled := cbTruncation.Checked;
    btnFullTest.Enabled := AnycheckEnabled;
  finally
    FChanging := False;
  end;
end;

function TForm1.CreateAttrSnapshot(iInfo : IGpStructuredFileInfo) : string;
var
  attrEnum  : TStringList;
  iAttr     : integer;
begin
  Result := '';
  attrEnum := TStringList.Create;
  try
    iInfo.AttributeNames(attrEnum);
    Result := Result + IntToStr(attrEnum.Count) + ':';
    for iAttr := 0 to attrEnum.Count-1 do 
      Result := Result + attrEnum[iAttr] + '=' + iInfo.Attribute[attrEnum[iAttr]] + ';';
  finally FreeAndNil(attrEnum); end;
end; { TForm1.CreateAttrSnapshot }

function TForm1.CreateSnapshot(storage : IGpStructuredStorage) : string;

  function Descend(const folderName: string): string;
  var
    files  : TStringList;
    folders: TStringList;
    iEntry : integer;
  begin
    Result := folderName + '/:';
    folders := TStringList.Create;
    try
      storage.FolderNames(folderName, folders);
      for iEntry := 0 to folders.Count-1 do
        Result := Result + folders[iEntry] + '/:';
      files := TStringList.Create;
      try
        storage.FileNames(folderName, files);
        for iEntry := 0 to files.Count-1 do
          Result := Result + files[iEntry] + ':';
      finally FreeAndNil(files); end;
      for iEntry := 0 to folders.Count-1 do
        Result := Result + Descend(folderName + '/' + folders[iEntry]);
    finally FreeAndNil(folders); end;
  end; { Descend }

begin
  Result := Descend('');
end; { TForm1.CreateSnapshot }

function TForm1.Expect(fnResult, value: boolean): boolean;
const
  CBool: array [false..true] of string = ('False', 'True');
begin
  if fnResult = value then
    Result := true
  else begin
    Log(Format('Invalid result. Expected %s, got %s.', [CBool[fnResult], CBool[value]]));
    Result := false;
  end;
end; { TForm1.Expect }

function TForm1.Expect(fnResult, value: string): boolean;
begin
  if fnResult = value then
    Result := true
  else begin
    Log(Format('Invalid result. Expected %s, got %s.', [fnResult, value]));
    Result := false;
  end;
end; { TForm1.Expect }

function TForm1.FileSize(const fileName: string): integer;
var
  f: file;
begin
  AssignFile(f, fileName);
  Reset(f, 1);
  try
    Result := System.FileSize(f);
  finally CloseFile(f); end;
end; { TForm1.FileSize }

procedure TForm1.Log(const msg: string);
begin
  lbLog.ItemIndex := lbLog.Items.Add(msg);
end; { TForm1.Log }

procedure TForm1.TestFile(storage : IGpStructuredStorage; const fileName : string;
  write : boolean; sizeFactor : integer);
var
  strFile: TStream;
begin
  try
  strFile := storage.OpenFile(fileName, fmCreate);
  try
    TestFile(strFile, write, sizeFactor);
  finally FreeAndNil(strFile); end;
  Application.ProcessMessages;
  except
    on E:Exception do begin
      storage := nil;
      raise;
    end;
  end;
end; { TForm1.TestFile }

procedure TForm1.TestFile(strFile: TStream; write: boolean; sizeFactor: integer);
var
  dataSize: integer;
  iTest   : integer;
  test    : integer;
  testOK  : integer;
begin
  if write then begin
    strFile.Position := 0;
    for dataSize := 2 to 4 do
      for iTest := 0 to 1024*sizeFactor do begin
        try
          strFile.Write(iTest, dataSize);
        except
          on E: Exception do begin
            Log(Format('%d/%d: %s', [dataSize, iTest, E.Message]));
            raise;
          end;
        end;
      end;
    strFile.Size := strFile.Position;
  end;
  strFile.Position := 0;
  for dataSize := 2 to 4 do 
    for iTest := 0 to 1024*sizeFactor do begin
      try
        testOK := 0;
        Move(iTest, testOK, dataSize);
        test := 0;
        strFile.Read(test, dataSize);
        if test <> testOK then
          raise Exception.CreateFmt('Invalid data at %d/%d.', [dataSize, iTest]);
      except
        on E: Exception do begin
          Log(Format('%d/%d: %s', [dataSize, iTest, E.Message]));
          raise;
        end;
      end;
    end;
end; { TForm1.TestFile }

function TForm1.TestGSSAttributes: boolean;
const
  CAttrSnapshot = '2:42=9*6;9*6=42;';
var
  iFolderInfo: IGpStructuredFileInfo;
  storage    : IGpStructuredStorage;
begin
  Result := false;
  Log('Testing attributes');
  try
    storage := CreateStorage;
    storage.Initialize(CStorageFile, fmCreate);
    storage.FileInfo[''].Attribute['attr'] := 'Written by Gp';
    if not Expect(storage.FileInfo[''].Attribute['attr'], 'Written by Gp') then Exit;
    {<2006-09-17, Gp: test case added}
    //FileInfo[''] is equivalent to FileInfo[/']
    if not Expect(storage.FileInfo['/'].Attribute['attr'], 'Written by Gp') then Exit;
    storage.FileInfo['/'].Attribute['attr'] := 'root attrib';
    if not Expect(storage.FileInfo['/'].Attribute['attr'], 'root attrib') then Exit;
    {>}
    TestFile(storage, '/normal.dat', true, -1);
    storage.FileInfo['/normal.dat'].Attribute['42'] := '6*9';
    if not Expect(storage.FileInfo['/normal.dat'].Attribute['42'], '6*9') then Exit;
    storage.Move('/normal.dat', '/folder/test.dat');
    storage.Move('/folder/test.dat', '/folder/test2.dat');
    if not Expect(storage.FileInfo['/folder/test2.dat'].Attribute['42'], '6*9') then Exit;
    storage.Move('/folder/test2.dat', '/normal.dat');
    if not Expect(storage.FileInfo['/normal.dat'].Attribute['42'], '6*9') then Exit;
    storage.Delete('/normal.dat');
    TestFile(storage, '/normal.dat', true);
    if not Expect(storage.FileInfo['/normal.dat'].Attribute['42'], '') then Exit;
    storage.FileInfo['/normal.dat'].Attribute['42'] := '6*9';
    storage.FileInfo['/normal.dat'].Attribute['6*9'] := '42';
    if not Expect(storage.FileInfo['/normal.dat'].Attribute['42'], '6*9') then Exit;
    if not Expect(storage.FileInfo['/normal.dat'].Attribute['6*9'], '42') then Exit;
    iFolderInfo := storage.FileInfo['/folder'];
    iFolderInfo.Attribute['42'] := '9*6';
    iFolderInfo.Attribute['9*6'] := '42';
    if not Expect(iFolderInfo.Attribute['42'], '9*6') then Exit;
    if not Expect(iFolderInfo.Attribute['9*6'], '42') then Exit;
    if not Expect(CreateAttrSnapshot(iFolderInfo), CAttrSnapshot) then Exit;
    iFolderInfo := nil;
    if not Expect(storage.FileInfo['/folder'].Attribute['42'], '9*6') then Exit;
    if not Expect(storage.FileInfo['/folder'].Attribute['9*6'], '42') then Exit;
    storage := CreateStorage;
    storage.Initialize(CStorageFile, fmOpenRead);
    iFolderInfo := storage.FileInfo['/folder']; 
    if not Expect(iFolderInfo.Attribute['42'], '9*6') then Exit;
    if not Expect(iFolderInfo.Attribute['9*6'], '42') then Exit;
    if not Expect(CreateAttrSnapshot(iFolderInfo), CAttrSnapshot) then Exit;
    iFolderInfo := nil;
    if not Expect(storage.FileInfo['/folder'].Attribute['42'], '9*6') then Exit;
    if not Expect(storage.FileInfo['/folder'].Attribute['9*6'], '42') then Exit;
    Result := true;
  except
    on E: Exception do begin
      Log('  '+E.Message);
      storage := nil;
      iFolderInfo := nil;
    end;
  end;
end; { TForm1.TestGSSAttributes }

function TForm1.TestGSSBigAndSmall: boolean;
var
  storage: IGpStructuredStorage;
begin
  Result := false;
  Log('Testing big and small files');
  try
    storage := CreateStorage;
    storage.Initialize(CStorageFile, fmCreate);
    // 0 bytes
    TestFile(storage, '/small.dat', true, -1);
    TestFile(storage, '/small2.dat', true, -1);
    TestFile(storage, '/small2.dat', true);
    // cross the 257-block boundary, cross also 64K test value boundary
    TestFile(storage, '/large.dat', true, 64);
    storage := CreateStorage;
    storage.Initialize(CStorageFile, fmOpenRead);
    TestFile(storage, '/small.dat', false, -1);
    TestFile(storage, '/small2.dat', false);
    TestFile(storage, '/large.dat', false, 64);
    Result := true;
  except
    on E: Exception do
      Log('  '+E.Message);
  end;
end; { TForm1.TestGSSBigAndSmall }

function TForm1.TestGSSCompacting: boolean;
var
  storage: IGpStructuredStorage;
begin 
  Result := false;
  Log('Testing compacting');
  try
    storage := CreateStorage;
    storage.Initialize(CStorageFile, fmCreate);
    // create fragmented file
    TestFile(storage, '/firstfile.dat', true);
    TestFile(storage, '/folder/secondfile.dat', true);
    TestFile(storage, '/firstfile.dat', true, 2);
    TestFile(storage, '/folder/secondfile.dat', true);
    TestFile(storage, '/firstfile.dat', false, 2);
    TestFile(storage, '/folder/secondfile.dat', true, -1);
    TestFile(storage, '/firstfile.dat', true, 3);
    TestFile(storage, '/folder/secondfile.dat', true);
    storage.FileInfo[''].Attribute['signature'] := 'Written by Gp';
    storage.FileInfo['/firstfile.dat'].Attribute['42'] := '6*9';
    storage.FileInfo['/folder/secondfile.dat'].Attribute['42'] := '6*9';
    storage.FileInfo['/folder'].Attribute['6*9'] := '42';
    storage := CreateStorage;
    storage.Initialize(CStorageFile, fmOpenRead);
    TestFile(storage, '/firstfile.dat', false, 3);
    TestFile(storage, '/folder/secondfile.dat', false);
    if not Expect(storage.FileInfo[''].Attribute['signature'], 'Written by Gp') then Exit;
    if not Expect(storage.FileInfo['/firstfile.dat'].Attribute['42'], '6*9') then Exit;
    if not Expect(storage.FileInfo['/folder/secondfile.dat'].Attribute['42'], '6*9') then Exit;
    if not Expect(storage.FileInfo['/folder'].Attribute['6*9'], '42') then Exit;
    storage := CreateStorage;
    storage.Initialize(CStorageFile, fmOpenReadWrite);
    TestFile(storage, '/firstfile.dat', false, 3);
    TestFile(storage, '/folder/secondfile.dat', false);
    if not Expect(storage.FileInfo[''].Attribute['signature'], 'Written by Gp') then Exit;
    if not Expect(storage.FileInfo['/firstfile.dat'].Attribute['42'], '6*9') then Exit;
    if not Expect(storage.FileInfo['/folder/secondfile.dat'].Attribute['42'], '6*9') then Exit;
    if not Expect(storage.FileInfo['/folder'].Attribute['6*9'], '42') then Exit;
    storage.Compact;
    TestFile(storage, '/firstfile.dat', false, 3);
    TestFile(storage, '/folder/secondfile.dat', false);
    if not Expect(storage.FileInfo[''].Attribute['signature'], 'Written by Gp') then Exit;
    if not Expect(storage.FileInfo['/firstfile.dat'].Attribute['42'], '6*9') then Exit;
    if not Expect(storage.FileInfo['/folder/secondfile.dat'].Attribute['42'], '6*9') then Exit;
    if not Expect(storage.FileInfo['/folder'].Attribute['6*9'], '42') then Exit;
    storage := CreateStorage;
    storage.Initialize(CStorageFile, fmOpenReadWrite);
    TestFile(storage, '/firstfile.dat', false, 3);
    TestFile(storage, '/folder/secondfile.dat', false);
    if not Expect(storage.FileInfo[''].Attribute['signature'], 'Written by Gp') then Exit;
    if not Expect(storage.FileInfo['/firstfile.dat'].Attribute['42'], '6*9') then Exit;
    if not Expect(storage.FileInfo['/folder/secondfile.dat'].Attribute['42'], '6*9') then Exit;
    if not Expect(storage.FileInfo['/folder'].Attribute['6*9'], '42') then Exit;
    TestFile(storage, '/firstfile.dat', true, 4);
    TestFile(storage, '/folder/secondfile.dat', true, 4);
    storage.FileInfo[''].Attribute['signature'] := 'it is i';
    storage.FileInfo['/firstfile.dat'].Attribute['6*9'] := '42';
    storage.FileInfo['/folder/secondfile.dat'].Attribute['6*9'] := '42';
    storage.FileInfo['/folder'].Attribute['42'] := '6*9';
    if not Expect(storage.FileInfo[''].Attribute['signature'], 'it is i') then Exit;
    if not Expect(storage.FileInfo['/firstfile.dat'].Attribute['6*9'], '42') then Exit;
    if not Expect(storage.FileInfo['/folder/secondfile.dat'].Attribute['6*9'], '42') then Exit;
    if not Expect(storage.FileInfo['/folder'].Attribute['42'], '6*9') then Exit;
    Result := true;
  except
    on E: Exception do
      Log('  '+E.Message);
  end;
end; { TForm1.TestGSSCompacting }

function TForm1.TestGSSCreation: boolean;
var
  storage: IGpStructuredStorage;
begin
  Result := false;
  Log('Testing storage creation');
  try
    DeleteFileUTF8(CStorageFile); { *Converted from DeleteFile*  }
    storage := CreateStorage;
    storage.Initialize(CStorageFile, fmCreate);
    storage := nil;
    storage := CreateStorage;
    storage.Initialize(CStorageFile, fmOpenRead);
    storage := CreateStorage;
    storage.Initialize(CStorageFile, fmOpenRead);
    Result := true;
  except
    on E: Exception do
      Log('  '+E.Message);
  end;
end; { TForm1.TestGSSCreation }

function TForm1.TestGSSEnumerating: boolean;
const
  CSnapshot =
    '/:firstfolder/:secondfolder/:firstfile.dat:secondfile.dat:/firstfolder/:'+
    'firstfile.dat:secondfile.dat:/secondfolder/:firstsubfolder/:secondsubfolder/:'+
    '/secondfolder/firstsubfolder/:/secondfolder/secondsubfolder/:firstfile.dat:'+
    'secondfile.dat:';
var
  storage: IGpStructuredStorage;
begin
  Result := false;
  Log('Testing file/folder enumeration');
  try
    storage := CreateStorage;
    storage.Initialize(CStorageFile, fmCreate);
    TestFile(storage, '/firstfile.dat', true, -1);
    TestFile(storage, '/secondfile.dat', true, -1);
    TestFile(storage, '/firstfolder/firstfile.dat', true, -1);
    TestFile(storage, '/firstfolder/secondfile.dat', true, -1);
    storage.CreateFolder('/secondfolder/firstsubfolder');
    TestFile(storage, '/secondfolder/secondsubfolder/firstfile.dat', true, -1);
    TestFile(storage, '/secondfolder/secondsubfolder/secondfile.dat', true, -1);
    if not Expect(CreateSnapshot(storage), CSnapshot) then Exit;
    Result := true;
  except
    on E: Exception do
      Log('  '+E.Message);
  end;
end; { TForm1.TestGSSEnumerating }

function TForm1.TestGSSExceptions: boolean;
var
  fileInfo: IGpStructuredFileInfo;
  storage : IGpStructuredStorage;
  strFile : TStream;
begin
  Result := false;
  Log('Testing exceptions');
  DeleteFileUTF8(CStorageFile); { *Converted from DeleteFile*  }
  storage := CreateStorage;
  storage.Initialize(CStorageFile, fmCreate);
  {<2006-10-20, Gp: test case added}
  //when killing a folder with open files, GpStructuredStorage should raise an exception
  try
    strFile := storage.OpenFile('/f1/f2/test.txt', fmCreate);
    try
      storage.Delete('/f1/f2');
      Log('No exception?');
    finally FreeAndNil(strFile); end;
    Exit;
  except end;
  try
    strFile := storage.OpenFile('/f1/f2/test.txt', fmCreate);
    try
      storage.Delete('/f1');
      Log('No exception?');
    finally FreeAndNil(strFile); end;
    Exit;
  except end;
  {>}
  try
    TestFile(storage, '/', true);
    Log('No exception?');
    Exit;
  except end;
  try
    storage.CreateFolder('/firstdir');
    TestFile(storage, '/firstdir', true);
    Log('No exception?');
    Exit;
  except end;
  try
    TestFile(storage, '/firstdir/', true);
    Exit;
  except end;
  try
    TestFile(storage, '/firstfile.dat', true, -1);
    TestFile(storage, '/firstfile.dat/firstfile.dat', true);
    Log('No exception?');
    Exit;
  except end;
  try
    storage.CreateFolder('/firstdir');
    Log('No exception?');
    Exit;
  except end;
  try
    fileInfo := storage.FileInfo['/firstfile.dat'];
    storage := nil;
    fileInfo.Attribute['test'] := 'test';
    Log('No exception?');
    Exit;
  except end;
  Result := true;
end; { TForm1.TestGSSExceptions }

function TForm1.TestGSSExists: boolean;
var
  storage: IGpStructuredStorage;
begin
  Result := false;
  Log('Testing file/folder existance');
  try
    storage := CreateStorage;
    storage.Initialize(CStorageFile, fmCreate);
    TestFile(storage, '/firstfile.dat', true, -1);
    TestFile(storage, '/secondfile.dat', true, -1);
    TestFile(storage, '/firstfolder/firstfile.dat', true, -1);
    TestFile(storage, '/firstfolder/secondfile.dat', true, -1);
    storage.CreateFolder('/secondfolder/firstsubfolder');
    TestFile(storage, '/secondfolder/secondsubfolder/firstfile.dat', true, -1);
    TestFile(storage, '/secondfolder/secondsubfolder/secondfile.dat', true, -1);
    if not Expect(storage.FileExists('/firstfile.dat') { *Converted from FileExists*  }, true) then Exit;
    if not Expect(storage.FileExists('/secondfile.dat') { *Converted from FileExists*  }, true) then Exit;
    if not Expect(storage.FileExists('/thirdfile.dat') { *Converted from FileExists*  }, false) then Exit;
    if not Expect(storage.FileExists('/firstfolder/firstfile.dat') { *Converted from FileExists*  }, true) then Exit;
    if not Expect(storage.FileExists('/firstfolder/secondfile.dat') { *Converted from FileExists*  }, true) then Exit;
    if not Expect(storage.FileExists('/firstfolder/thirdfile.dat') { *Converted from FileExists*  }, false) then Exit;
    if not Expect(storage.FileExists('/secondfolder/firstfile.dat') { *Converted from FileExists*  }, false) then Exit;
    if not Expect(storage.FileExists('/secondfolder/secondsubfolder/firstfile.dat') { *Converted from FileExists*  }, true) then Exit;
    if not Expect(storage.FileExists('/secondfolder/secondsubfolder/firstfile.dat') { *Converted from FileExists*  }, true) then Exit;
    if not Expect(storage.FileExists('/') { *Converted from FileExists*  }, false) then Exit;
    if not Expect(storage.FileExists('/firstfolder') { *Converted from FileExists*  }, false) then Exit;
    if not Expect(storage.FileExists('/firstfolder/') { *Converted from FileExists*  }, false) then Exit;
    if not Expect(storage.FileExists('/secondfolder/firstsubfolder') { *Converted from FileExists*  }, false) then Exit;
    if not Expect(storage.FileExists('/secondfolder/firstsubfolder/') { *Converted from FileExists*  }, false) then Exit;
    if not Expect(storage.FolderExists('/'), true) then Exit;
    if not Expect(storage.FolderExists('/firstfolder'), true) then Exit;
    if not Expect(storage.FolderExists('/firstfolder/'), true) then Exit;
    if not Expect(storage.FolderExists('/secondfolder/firstsubfolder'), true) then Exit;
    if not Expect(storage.FolderExists('/secondfolder/firstsubfolder/'), true) then Exit;
    if not Expect(storage.FolderExists('/secondfolder/secondsubfolder'), true) then Exit;
    if not Expect(storage.FolderExists('/secondfolder/secondsubfolder/'), true) then Exit;
    if not Expect(storage.FolderExists('/firstfile.dat'), false) then Exit;
    if not Expect(storage.FolderExists('/firstfolder/firstfile.dat'), false) then Exit;
    Result := true;
  except
    on E: Exception do
      Log('  '+E.Message);
  end;
end; { TForm1.TestGSSExists }

function TForm1.TestGSSFlatFileSystem: boolean;
var
  storage: IGpStructuredStorage;
begin
  Result := false;
  Log('Testing flat file system');
  try
    storage := CreateStorage;
    storage.Initialize(CStorageFile, fmCreate);
    TestFile(storage, '/firstfile.dat', true);
    TestFile(storage, '/secondfile.dat', true);
    storage := nil;
    storage := CreateStorage;
    storage.Initialize(CStorageFile, fmOpenRead);
    TestFile(storage, '/secondfile.dat', false);
    TestFile(storage, '/firstfile.dat', false);
    Result := true;
  except
    on E: Exception do begin
      Log('  '+E.Message);
      storage := Nil;
    end;
  end;
end; { TForm1.TestGSSFlatFileSystem }

function TForm1.TestGSSFolders: boolean;
var
  storage: IGpStructuredStorage;
begin
  Result := false;
  Log('Testing folders');
  try
    storage := CreateStorage;
    storage.Initialize(CStorageFile, fmCreate);
    TestFile(storage, '/firstdir/firstfile.dat', true);
    TestFile(storage, '/firstdir/secondfile.dat', true);
    TestFile(storage, '/seconddir/firstfile.dat', true);
    TestFile(storage, '/seconddir/secondfile.dat', true);
    TestFile(storage, '/firstdir/firstsubdir/firstfile.dat', true);
    TestFile(storage, '/firstdir/secondsubdir/firstfile.dat', true);
    TestFile(storage, '/firstdir/firstsubdir/secondfile.dat', true);
    TestFile(storage, '/firstdir/secondsubdir/secondfile.dat', true);
    storage.CreateFolder('/thirddir');
    storage.CreateFolder('/firstdir/thirdsubdir/');
    storage := CreateStorage;
    storage.Initialize(CStorageFile, fmOpenRead);
    TestFile(storage, '/firstdir/firstfile.dat', false);
    TestFile(storage, '/firstdir/secondfile.dat', false);
    TestFile(storage, '/seconddir/firstfile.dat', false);
    TestFile(storage, '/seconddir/secondfile.dat', false);
    TestFile(storage, '/firstdir/firstsubdir/firstfile.dat', false);
    TestFile(storage, '/firstdir/secondsubdir/firstfile.dat', false);
    TestFile(storage, '/firstdir/firstsubdir/secondfile.dat', false);
    TestFile(storage, '/firstdir/secondsubdir/secondfile.dat', false);
    if not Expect(storage.FolderExists('/thirddir'), true) then
      Exit;
    if not Expect(storage.FolderExists('/firstdir/thirdsubdir/'), true) then
      Exit;
    Result := true;
  except
    on E: Exception do
      Log('  '+E.Message);
  end;
end; { TForm1.TestGSSFragmentedFiles }

function TForm1.TestGSSFragmentedFiles: boolean;
var
  storage: IGpStructuredStorage;
begin
  Result := false;
  Log('Testing fragmented files');
  try
    storage := CreateStorage;
    storage.Initialize(CStorageFile, fmCreate);
    TestFile(storage, '/firstfile.dat', true);
    TestFile(storage, '/secondfile.dat', true);
    TestFile(storage, '/firstfile.dat', true, 2);
    TestFile(storage, '/secondfile.dat', true);
    TestFile(storage, '/firstfile.dat', false, 2);
    TestFile(storage, '/secondfile.dat', true, -1);
    TestFile(storage, '/firstfile.dat', true, 3);
    TestFile(storage, '/secondfile.dat', true);
    storage := CreateStorage;
    storage.Initialize(CStorageFile, fmOpenRead);
    TestFile(storage, '/firstfile.dat', false, 3);
    TestFile(storage, '/secondfile.dat', false);
    Result := true;
  except
    on E: Exception do
      Log('  '+E.Message);
  end;
end; { TForm1.TestGSSFragmentedFiles }

function TForm1.TestGSSMovingAndDeleting: boolean;
const
  CSnapshot1 =
    '/:firstdir/:seconddir/:firstfile.dat:secondfile.dat:/firstdir/:firstsubdir/:'+
    'secondsubdir/:firstfile.dat:secondfile.dat:/firstdir/firstsubdir/:firstfile.dat:'+
    'secondfile.dat:/firstdir/secondsubdir/:firstfile.dat:secondfile.dat:/seconddir/:'+
    'firstfile.dat:secondfile.dat:';
  CSnapshot2 =
    '/:firstdir3/:seconddir/:firstfile.dat:secondfile.dat:copy_of_firstfile.dat:'+
    '/firstdir3/:secondsubdir/:firstfile.dat:secondfile.dat:/firstdir3/secondsubdir/:'+
    'firstfile.dat:secondfile.dat:/seconddir/:copy_of_first/:firstfile.dat:'+
    'secondfile.dat:/seconddir/copy_of_first/:secondfile.dat:';
  CSnapshot3 =
    '/:firstdir/:seconddir/:firstfile.dat:secondfile.dat:/firstdir/:secondsubdir/:'+
    'firstsubdir/:firstfile.dat:secondfile.dat:/firstdir/secondsubdir/:firstfile.dat:'+
    'secondfile.dat:/firstdir/firstsubdir/:secondfile.dat:firstfile.dat:/seconddir/:'+
    'firstfile.dat:secondfile.dat:';
  CSnapshot4 =
    '/:seconddir/:firstfile.dat:secondfile.dat:/seconddir/:';
var
  storage: IGpStructuredStorage;
begin
  Result := false;
  Log('Testing moving and deleting');
  try
    storage := CreateStorage;
    storage.Initialize(CStorageFile, fmCreate);
    TestFile(storage, '/firstfile.dat', true, -1);
    TestFile(storage, '/secondfile.dat', true, -1);
    TestFile(storage, '/firstdir/firstfile.dat', true, -1);
    TestFile(storage, '/firstdir/secondfile.dat', true, -1);
    TestFile(storage, '/seconddir/firstfile.dat', true, -1);
    TestFile(storage, '/seconddir/secondfile.dat', true, -1);
    TestFile(storage, '/firstdir/firstsubdir/firstfile.dat', true, -1);
    TestFile(storage, '/firstdir/secondsubdir/firstfile.dat', true, -1);
    TestFile(storage, '/firstdir/firstsubdir/secondfile.dat', true, -1);
    TestFile(storage, '/firstdir/secondsubdir/secondfile.dat', true, -1);
    if not Expect(CreateSnapshot(storage), CSnapshot1) then Exit;
    storage.Move('/firstdir', '/firstdir2');
    storage.Move('/firstdir2/', '/firstdir3/');
    storage.Move('/firstdir3/firstsubdir', '/seconddir/copy_of_first');
    storage.Move('/seconddir/copy_of_first/firstfile.dat', '/copy_of_firstfile.dat');
    if not Expect(CreateSnapshot(storage), CSnapshot2) then Exit;
    storage.Move('/firstdir3', '/firstdir');
    storage.Move('/seconddir/copy_of_first', '/firstdir/firstsubdir');
    storage.Move('/copy_of_firstfile.dat', '/firstdir/firstsubdir/firstfile.dat');
    if not Expect(CreateSnapshot(storage), CSnapshot3) then Exit;
    storage.Delete('/firstdir/');
    storage.Delete('/seconddir/firstfile.dat');
    storage.Delete('/seconddir/secondfile.dat');
    storage.Delete('/seconddir/firstsubdir');
    if not Expect(CreateSnapshot(storage), CSnapshot4) then Exit;
    //attribute deletion bug, fixed in 1.06b:
    storage.CreateFolder('/Folder 6');
    storage.CreateFolder('/Folder 6/Folder 1');
    storage.FileInfo['/Folder 6/Folder 1'].Attribute['test'] := 'test';
    storage.Delete('/Folder 6/Folder 1');
    storage.OpenFile('/Folder 6/Snippet 1', fmCreate).Free;
    storage.FileInfo['/Folder 6/Snippet 1'].Attribute['test'] := 'test';
    storage.Delete('/Folder 6');
    if not Expect(CreateSnapshot(storage), CSnapshot4) then Exit;
    Result := true;
  except
    on E: Exception do
      Log('  '+E.Message);
  end;
end; { TForm1.TestGSSMovingAndDeleting }

function TForm1.TestGSSTruncation: boolean;
var
  storage: IGpStructuredStorage;
begin
  Result := false;
  Log('Testing storage truncation');
  try
    storage := CreateStorage;
    storage.Initialize(CStorageFile, fmCreate);
    TestFile(storage, '/secondfile.dat', true);
    TestFile(storage, '/firstfile.dat', true, 2);
    TestFile(storage, '/small.dat', true, -1);
    TestFile(storage, '/small2.dat', true);
    TestFile(storage, '/large.dat', true, 30);
    storage := nil;
    if FileSize(CStorageFile) <> 322569 then begin
      Log('Invalid storage size');
      Exit;
    end;
    storage := CreateStorage;
    storage.Initialize(CStorageFile, fmOpenReadWrite);
    TestFile(storage, '/large.dat', true);
    storage := nil;
    if FileSize(CStorageFile) <> 55296 then begin
      Log('Invalid storage size');
      Exit;
    end;
    storage := CreateStorage;
    storage.Initialize(CStorageFile, fmOpenReadWrite);
    TestFile(storage, '/secondfile.dat', false);
    TestFile(storage, '/firstfile.dat', false, 2);
    TestFile(storage, '/small.dat', false, -1);
    TestFile(storage, '/small2.dat', false);
    TestFile(storage, '/large.dat', false);
    TestFile(storage, '/secondfile.dat', true, 2);
    TestFile(storage, '/firstfile.dat', true, 1);
    TestFile(storage, '/large.dat', true, 2);
    Result := true;
  except
    on E: Exception do
      Log('  '+E.Message);
  end;
end; { TForm1.TestGSSTruncation }

function TForm1.AnycheckEnabled : Boolean;
begin
  Result := cbCreation.Checked or cbFlatFileSystem.Checked or cbCompact.Checked or
            cbExceptions.Checked or cbBigAndSmall.Checked or cbFragmentedFiles.Checked or
            cbFolders.Checked or cbTruncation.Checked or cbExists.Checked or
            cbEnumerating.Checked or cbMoveAndDelete.Checked or cbAttributes.Checked;
end;

end.

