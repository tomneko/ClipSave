object ClipSaveConfigForm: TClipSaveConfigForm
  Left = 260
  Top = 217
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'ClipSave'#12398#35373#23450
  ClientHeight = 373
  ClientWidth = 427
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 12
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 427
    Height = 339
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    ParentColor = True
    TabOrder = 0
    object PageControl1: TPageControl
      Left = 5
      Top = 5
      Width = 417
      Height = 329
      ActivePage = TabSheet1
      Align = alClient
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = #20445#23384
        object Label1: TLabel
          Left = 24
          Top = 16
          Width = 105
          Height = 12
          Caption = 'Data'#20445#23384#12487#12451#12524#12463#12488#12522
        end
        object LabelJpegQ: TLabel
          Left = 210
          Top = 68
          Width = 49
          Height = 12
          Caption = 'Jpeg'#30011#36074
          Font.Charset = SHIFTJIS_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
        end
        object Label3: TLabel
          Left = 210
          Top = 92
          Width = 161
          Height = 12
          Caption = #8251#25968#20516#12364#22823#12365#12356#12411#12393#30011#36074#12364#12424#12356
        end
        object Label2: TLabel
          Left = 216
          Top = 151
          Width = 30
          Height = 12
          Caption = 'Prefix'
        end
        object Label4: TLabel
          Left = 16
          Top = 230
          Width = 97
          Height = 12
          Caption = #12513#12514#20445#23384#12501#12449#12452#12523#21517
        end
        object RG_SaveFileNameType: TRadioGroup
          Left = 16
          Top = 143
          Width = 193
          Height = 76
          Hint = #20445#23384#12501#12449#12452#12523#21517#12398#24418#24335#12434#36984#25246#12375#12390#12367#12384#12373#12356#12290
          Caption = #20445#23384#12501#12449#12452#12523#21517
          ItemIndex = 0
          Items.Strings = (
            'yyyymmdd.nnn.Ext'
            'Prefix + yyyymmdd.nnn.Ext'
            #12518#12540#12470#12540#23450#32681)
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
          OnClick = RG_SaveImgTypeClick
        end
        object BuckupDirEdit: TEdit
          Left = 24
          Top = 32
          Width = 305
          Height = 20
          Hint = #20445#23384#20808#12487#12451#12524#12463#12488#12522#12434#25351#23450#12375#12390#12367#12384#12373#12356#12290
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          Text = 'C:\'
        end
        object BuckupDirButton: TButton
          Left = 344
          Top = 29
          Width = 41
          Height = 25
          Hint = #12487#12451#12524#12463#12488#12522#12398#36984#25246#12480#12452#12450#12525#12464#12508#12483#12463#12473#12434#34920#31034#12375#12414#12377#12290
          Caption = #21442#29031
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = BuckupDirButtonClick
        end
        object SpinEditJpegQ: TSpinEdit
          Left = 296
          Top = 64
          Width = 73
          Height = 21
          Hint = 'Jpeg'#12398#30011#36074#12391#12377#12290
          MaxValue = 100
          MinValue = 1
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          Value = 75
        end
        object RG_SaveImgType: TRadioGroup
          Left = 16
          Top = 64
          Width = 170
          Height = 71
          Hint = #12501#12449#12452#12523#24418#24335#12434#36984#25246#12375#12390#12367#12384#12373#12356#12290
          Caption = #12501#12449#12452#12523#24418#24335
          ItemIndex = 0
          Items.Strings = (
            'Jpeg'#24418#24335
            'Bmp'#24418#24335
            'Png'#24418#24335)
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          OnClick = RG_SaveImgTypeClick
        end
        object ColorModeCheck: TCheckBox
          Left = 210
          Top = 112
          Width = 172
          Height = 17
          Hint = 'Bmp'#12501#12449#12452#12523#12434'24bit'#12514#12540#12489#12395#12375#12414#12377#12290
          Caption = #24375#21046#30340#12395'24bitBMP'#12395#12377#12427
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
        end
        object Edit_Prefix: TEdit
          Left = 256
          Top = 149
          Width = 140
          Height = 20
          Hint = #20445#23384#12501#12449#12452#12523#12398#25509#38957#36766#12434#20837#21147#12375#12390#12367#12384#12373#12356#12290
          ParentShowHint = False
          ShowHint = True
          TabOrder = 6
          Text = 'Edit_Prefix'
        end
        object Edit_UDef: TEdit
          Left = 216
          Top = 199
          Width = 180
          Height = 20
          TabOrder = 7
        end
        object Btn_Create: TButton
          Left = 216
          Top = 172
          Width = 140
          Height = 25
          Hint = #12487#12451#12524#12463#12488#12522#12398#36984#25246#12480#12452#12450#12525#12464#12508#12483#12463#12473#12434#34920#31034#12375#12414#12377#12290
          Caption = #12518#12540#12470#12540#23450#32681#12398#20316#25104
          ParentShowHint = False
          ShowHint = True
          TabOrder = 8
          OnClick = Btn_CreateClick
        end
        object Edit_Memo: TEdit
          Left = 16
          Top = 248
          Width = 193
          Height = 20
          TabOrder = 9
          Text = 'ClipSaveMemo.txt'
        end
      end
      object TabSheet2: TTabSheet
        Caption = #65399#65388#65420#65439#65409#65388
        object CaptureCheck1: TCheckBox
          Left = 24
          Top = 16
          Width = 281
          Height = 17
          Hint = #12463#12522#12483#12503#12508#12540#12489#12392#36899#25658#12377#12427#12363#12375#12394#12356#12363#12434#36984#25246#12375#12390#12367#12384#12373#12356#12290
          Caption = #12463#12522#12483#12503#12508#12540#12489#12392#36899#25658#12377#12427
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = CaptureCheck1Click
        end
        object RG_CaptureType: TRadioGroup
          Left = 16
          Top = 120
          Width = 370
          Height = 89
          Hint = #12463#12522#12483#12503#12508#12540#12489#12392#36899#25658#12375#12394#12356#12392#12365#12398#12461#12515#12503#12481#12515#31684#22258#12434#35373#23450#12375#12390#12367#12384#12373#12356#12290
          Caption = #12461#12515#12503#12481#12515#12540#31684#22258#12398#35373#23450
          ItemIndex = 0
          Items.Strings = (
            #12501#12523#12473#12463#12522#12540#12531
            #12450#12463#12486#12451#12502#12454#12451#12531#12489#12454#12384#12369
            #12450#12463#12486#12451#12502#12454#12451#12531#12489#12454#12398#12463#12521#12452#12450#12531#12488#38936#22495)
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
        end
        object TextFileSaveCheck: TCheckBox
          Left = 36
          Top = 60
          Width = 281
          Height = 17
          Hint = #12463#12522#12483#12503#12508#12540#12489#12392#36899#25658#26178#12395#12289#12486#12461#12473#12488#12434#20445#23384#12375#12414#12377#12290
          Caption = #12486#12461#12473#12488#12501#12449#12452#12523#12434#20445#23384#12377#12427
          Checked = True
          ParentShowHint = False
          ShowHint = True
          State = cbChecked
          TabOrder = 2
          OnClick = TextFileSaveCheckClick
        end
        object PictureSaveCheck: TCheckBox
          Left = 36
          Top = 40
          Width = 281
          Height = 17
          Hint = #12463#12522#12483#12503#12508#12540#12489#12392#36899#25658#26178#12395#12289#30011#20687#12434#20445#23384#12375#12414#12377#12290
          Caption = #30011#20687#12434#20445#23384#12377#12427
          Checked = True
          ParentShowHint = False
          ShowHint = True
          State = cbChecked
          TabOrder = 3
        end
        object WavEnabledCheck: TCheckBox
          Left = 24
          Top = 219
          Width = 160
          Height = 17
          Caption = #12461#12515#12503#12481#12515#26178#12395#38899#12434#40180#12425#12377
          TabOrder = 4
        end
        object WavFileEdit: TEdit
          Left = 190
          Top = 217
          Width = 121
          Height = 20
          TabOrder = 5
        end
        object WavFileButton: TButton
          Left = 324
          Top = 215
          Width = 41
          Height = 25
          Hint = #12487#12451#12524#12463#12488#12522#12398#36984#25246#12480#12452#12450#12525#12464#12508#12483#12463#12473#12434#34920#31034#12375#12414#12377#12290
          Caption = #21442#29031
          ParentShowHint = False
          ShowHint = True
          TabOrder = 6
          OnClick = WavFileButtonClick
        end
        object IncludeCursorCheck: TCheckBox
          Left = 24
          Top = 239
          Width = 155
          Height = 17
          Caption = #12459#12540#12477#12523#12434#21547#12417#12427
          TabOrder = 7
        end
        object CB_AppendText: TCheckBox
          Left = 36
          Top = 80
          Width = 184
          Height = 17
          Caption = #12486#12461#12473#12488#12501#12449#12452#12523#12399#36861#35352#12377#12427
          TabOrder = 8
        end
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 339
    Width = 427
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object OKBtn: TButton
      Left = 187
      Top = 2
      Width = 75
      Height = 25
      Hint = #35373#23450#12434#20445#23384#12375#12390#12480#12452#12450#12525#12464#12508#12483#12463#12473#12434#38281#12376#12414#12377#12290
      Caption = 'OK'
      Default = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = OKBtnClick
    end
    object CancelBtn: TButton
      Left = 267
      Top = 2
      Width = 75
      Height = 25
      Hint = #35373#23450#12434#20445#23384#12379#12378#12395#12480#12452#12450#12525#12464#12508#12483#12463#12473#12434#38281#12376#12414#12377#12290
      Cancel = True
      Caption = #12461#12515#12531#12475#12523
      ModalResult = 2
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
  end
  object OpenDlg: TOpenDialog
    Left = 325
    Top = 39
  end
end
