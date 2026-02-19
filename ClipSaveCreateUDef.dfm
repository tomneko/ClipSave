object CreateUDefForm: TCreateUDefForm
  Left = 321
  Top = 179
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #12518#12540#12470#12540#23450#32681#25991#23383#21015#12398#20316#25104
  ClientHeight = 300
  ClientWidth = 427
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 16
    Top = 104
    Width = 355
    Height = 13
    Caption = #19978#12398#12508#12479#12531#12434#25276#12375#12390#12518#12540#12470#12540#23450#32681#25991#23383#21015#12434#20316#25104#12375#12390#12367#12384#12373#12356#12290
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 16
    Top = 132
    Width = 117
    Height = 12
    Caption = #12518#12540#12470#12540#23450#32681#25991#23383#21015
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 16
    Top = 200
    Width = 346
    Height = 13
    Caption = #30906#35469#12508#12479#12531#12434#25276#12375#12390#20316#25104#12373#12428#12427#12501#12449#12452#12523#21517#30906#35469#12375#12390#12367#12384#12373#12356#12290
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 16
    Top = 236
    Width = 118
    Height = 12
    Caption = #20316#25104#12373#12428#12427#12501#12449#12452#12523#21517
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 24
    Top = 74
    Width = 30
    Height = 12
    Caption = 'Prefix'
  end
  object Label6: TLabel
    Left = 200
    Top = 74
    Width = 48
    Height = 12
    Caption = #21306#20999#25991#23383
  end
  object Panel1: TPanel
    Left = 0
    Top = 259
    Width = 427
    Height = 41
    Align = alBottom
    TabOrder = 0
    object Btn_OK: TButton
      Left = 264
      Top = 8
      Width = 75
      Height = 25
      Caption = 'OK'
      TabOrder = 0
      OnClick = Btn_OKClick
    end
    object Btn_Cancel: TButton
      Left = 344
      Top = 8
      Width = 75
      Height = 25
      Caption = #12461#12515#12531#12475#12523
      ModalResult = 2
      TabOrder = 1
    end
  end
  object Btn_Prefix: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Prefix'
    TabOrder = 1
    OnClick = Btn_PrefixClick
  end
  object Btn_Year: TButton
    Left = 168
    Top = 8
    Width = 75
    Height = 25
    Caption = #24180
    TabOrder = 2
    OnClick = Btn_YearClick
  end
  object Btn_Month: TButton
    Left = 248
    Top = 8
    Width = 75
    Height = 25
    Caption = #26376
    TabOrder = 3
    OnClick = Btn_MonthClick
  end
  object Btn_Day: TButton
    Left = 328
    Top = 8
    Width = 75
    Height = 25
    Caption = #26085
    TabOrder = 4
    OnClick = Btn_DayClick
  end
  object Btn_Hour: TButton
    Left = 88
    Top = 40
    Width = 75
    Height = 25
    Caption = #26178#38291
    TabOrder = 5
    OnClick = Btn_HourClick
  end
  object Btn_Min: TButton
    Left = 168
    Top = 40
    Width = 75
    Height = 25
    Caption = #20998
    TabOrder = 6
    OnClick = Btn_MinClick
  end
  object Btn_Sec: TButton
    Left = 248
    Top = 40
    Width = 75
    Height = 25
    Caption = #31186
    TabOrder = 7
    OnClick = Btn_SecClick
  end
  object Btn_MSec: TButton
    Left = 328
    Top = 40
    Width = 75
    Height = 25
    Caption = #12511#12522#31186
    TabOrder = 8
    OnClick = Btn_MSecClick
  end
  object Btn_Ext: TButton
    Left = 88
    Top = 8
    Width = 75
    Height = 25
    Caption = #36899#30058
    TabOrder = 9
    OnClick = Btn_ExtClick
  end
  object Edit_UDef: TEdit
    Left = 144
    Top = 128
    Width = 257
    Height = 20
    TabOrder = 10
  end
  object Btn_Confirm: TButton
    Left = 176
    Top = 160
    Width = 75
    Height = 25
    Caption = #30906#35469
    TabOrder = 11
    OnClick = Btn_ConfirmClick
  end
  object Edit_CreatedFName: TEdit
    Left = 144
    Top = 232
    Width = 257
    Height = 20
    TabOrder = 12
  end
  object Btn_Delimiter: TButton
    Left = 8
    Top = 40
    Width = 75
    Height = 25
    Caption = #21306#20999#25991#23383
    TabOrder = 13
    OnClick = Btn_DelimiterClick
  end
  object Edit_Prefix: TEdit
    Left = 64
    Top = 72
    Width = 121
    Height = 21
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 14
  end
  object CMB_Delimiter: TComboBox
    Left = 256
    Top = 72
    Width = 97
    Height = 21
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = [fsBold]
    ItemHeight = 13
    ParentFont = False
    TabOrder = 15
    Text = '.'
    Items.Strings = (
      '.'
      '-'
      '_')
  end
end
