unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, XPMan;

type
  TForm1 = class(TForm)
    lvFileList: TListView;
    grp1: TGroupBox;
    btnAddFiles: TButton;
    btnRemoveFiles: TButton;
    grp2: TGroupBox;
    btnBrowse: TButton;
    edtOutputPath: TEdit;
    btnXor: TButton;
    xpmnfst1: TXPManifest;
    dlgOpenFiles: TOpenDialog;
    btnClear: TButton;
    dlgSaveFile: TSaveDialog;
    procedure btnAddFilesClick(Sender: TObject);
    procedure btnRemoveFilesClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure btnXorClick(Sender: TObject);
  private
    procedure xorbuffers(var buffer1: array of Byte; var buffer2: array of Byte);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

//=================================================
//
// On Add files button clicked
//
//=================================================
procedure TForm1.btnAddFilesClick(Sender: TObject);
var
  i, numExisting, fileSize, fileHandle: Cardinal;
  item: TListItem;
  filePath: string;
begin
  if dlgOpenFiles.Execute then
  begin
    numExisting := lvFileList.Items.Count;
    for i := 0 to dlgOpenFiles.Files.Count - 1 do
    begin
      filePath := dlgOpenFiles.Files[i];
      fileHandle := FileOpen(filePath, fmOpenRead);
      fileSize := GetFileSize(fileHandle, nil);
      FileClose(fileHandle);
      item := lvFileList.Items.Add;
      item.Caption := IntToStr(i + numExisting + 1);
      item.SubItems.Add(filePath);
      item.SubItems.Append(IntToStr(fileSize));
    end;
  end;

end;

//=================================================
//
// On remove selected files button click
//
//=================================================
procedure TForm1.btnRemoveFilesClick(Sender: TObject);
var
  i, j, k: Cardinal;
  removalIndices: array of Cardinal;
begin
  if lvFileList.SelCount > 0 then
  begin
    j := 0;
    k := 1;
    SetLength(removalIndices, lvFileList.SelCount);
    for i := 0 to lvFileList.Items.Count - 1 do
    begin
      if lvFileList.Items[i].Selected then
      begin
        removalIndices[j] := i;
        Inc(j);
      end
      else
      begin
        lvFileList.Items[i].Caption := IntToStr(k);
        Inc(k);
      end;  
    end;

    for i := Length(removalIndices) - 1 downto 0  do
      lvFileList.Items[removalIndices[i]].Delete;

  end;

end;

//=================================================
//
// On clear list view button click
//
//=================================================
procedure TForm1.btnClearClick(Sender: TObject);
begin
  lvFileList.Clear;
end;

//=================================================
//
// On Select output file button click
//
//=================================================
procedure TForm1.btnBrowseClick(Sender: TObject);
begin
  if dlgSaveFile.Execute then edtOutputPath.Text := dlgSaveFile.FileName;

end;

//=================================================
//
// On xor button click
//
//=================================================
procedure TForm1.btnXorClick(Sender: TObject);
var
  i, outFileSize, fsize, failed, remaining, blockSize: Cardinal;
  outfilename: string;
  outfilestrm, infilestrm: TFileStream;
  buf1, buf2: packed array [0..1023] of Byte;

begin
  if lvFileList.Items.Count = 0 then
  begin
    MessageDlg('Cannot xor files.' + #13#10 + 'Reason: File list is empty!', mtError, [mbOK], 0);
    Exit;
  end;

  outfilename := edtOutputPath.Text;

  if Length(outfilename) = 0 then
  begin
    MessageDlg('No output file provided!' + #13#10 + 'Please provide the output file path before continuing',  mtError, [mbOK], 0);
    Exit;
  end;

  outFileSize := StrToInt(lvFileList.Items[0].SubItems[1]);
  for i := 0 to lvFileList.Items.Count - 1 do
  begin
    fsize := StrToInt(lvFileList.Items[i].SubItems[1]);
    if fsize < outFileSize then outFileSize := fsize;
  end;
  MessageDlg('Output file size is ' + IntToStr(outFileSize) + #13#10 +
    'Reason: All files are not of the same size.',  mtInformation, [mbOK], 0);

  if not CopyFile(PAnsiChar(lvFileList.Items[0].SubItems[0]), PAnsiChar(outfilename), False) then
  begin
    MessageDlg('Cannot create the output file for writing' + #13#10 +
      'Check if the path exists and is writable.',  mtWarning, [mbOK], 0);
    Exit;
  end;

  outfilestrm := TFileStream.Create(outfilename, fmOpenReadWrite);
  outfilestrm.Size := outFileSize;
  failed := 0;

  for i := 1 to lvFileList.Items.Count - 1 do
  begin
    outfilestrm.Seek(0, soFromBeginning);
    try
      infilestrm := TFileStream.Create(lvFileList.Items[i].SubItems[0], fmOpenRead);
    except
      Inc(failed);
      Continue;
    end;

    remaining := outFileSize;
    blockSize := 1024;
    while remaining > 0 do
    begin
      infilestrm.ReadBuffer(buf1, blockSize);
      outfilestrm.ReadBuffer(buf2, blockSize);
      outfilestrm.Seek(-blockSize, soFromCurrent);
      xorbuffers(buf1, buf2);
      outfilestrm.WriteBuffer(buf1, blockSize);
      Dec(remaining, blockSize);
      if remaining < 1024 then blockSize := remaining;
    end;
    infilestrm.Destroy;
  end;
  outfilestrm.Destroy;

  if failed > 0 then MessageDlg('Xoring failed on ' + IntToStr(failed) + ' files',  mtWarning, [mbOK], 0)
  else MessageDlg('Xoring complete!',  mtInformation, [mbOK], 0)
end;


//=================================================
//
// XORs the two buffers
//
//=================================================
procedure TForm1.xorbuffers(var buffer1: array of Byte; var buffer2: array of Byte);
var
  i: Cardinal;
begin
  for i := 0 to Length(buffer1) - 1 do buffer1[i] := buffer1[i] xor buffer2[i];
end;

end.

