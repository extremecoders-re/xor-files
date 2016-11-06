object Form1: TForm1
  Left = 832
  Top = 122
  BorderStyle = bsToolWindow
  Caption = 'XOR Files - github.com/extremecoders-re/xor-files'
  ClientHeight = 454
  ClientWidth = 494
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  PixelsPerInch = 96
  TextHeight = 13
  object grp1: TGroupBox
    Left = 8
    Top = 16
    Width = 473
    Height = 313
    Caption = 'Input Files'
    TabOrder = 0
    object lvFileList: TListView
      Left = 16
      Top = 24
      Width = 441
      Height = 233
      Columns = <
        item
          Caption = '#'
          MaxWidth = 30
          Width = 30
        end
        item
          AutoSize = True
          Caption = 'Path'
          MinWidth = 250
        end
        item
          Caption = 'Size'
          MinWidth = 50
          Width = 100
        end>
      ColumnClick = False
      GridLines = True
      MultiSelect = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
    end
    object btnAddFiles: TButton
      Left = 16
      Top = 272
      Width = 129
      Height = 25
      Caption = 'Add Files'
      TabOrder = 1
      OnClick = btnAddFilesClick
    end
    object btnRemoveFiles: TButton
      Left = 176
      Top = 272
      Width = 137
      Height = 25
      Caption = 'Remove Selected Files'
      TabOrder = 2
      OnClick = btnRemoveFilesClick
    end
    object btnClear: TButton
      Left = 344
      Top = 272
      Width = 115
      Height = 25
      Caption = 'Remove All'
      TabOrder = 3
      OnClick = btnClearClick
    end
  end
  object grp2: TGroupBox
    Left = 8
    Top = 344
    Width = 473
    Height = 57
    Caption = 'Output File'
    TabOrder = 1
    object btnBrowse: TButton
      Left = 376
      Top = 24
      Width = 81
      Height = 25
      Caption = 'Browse'
      TabOrder = 0
      OnClick = btnBrowseClick
    end
    object edtOutputPath: TEdit
      Left = 8
      Top = 24
      Width = 353
      Height = 21
      TabOrder = 1
    end
  end
  object btnXor: TButton
    Left = 8
    Top = 416
    Width = 473
    Height = 25
    Caption = 'XOR It!'
    TabOrder = 2
    OnClick = btnXorClick
  end
  object xpmnfst1: TXPManifest
    Left = 464
  end
  object dlgOpenFiles: TOpenDialog
    Filter = 'All Files|*.*'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofFileMustExist, ofEnableSizing]
    Title = 'Browse for files...'
    Left = 416
  end
  object dlgSaveFile: TSaveDialog
    Title = 'Browse for output file'
    Left = 368
  end
end
