object F_Memo: TF_Memo
  Left = 334
  Top = 258
  BorderStyle = bsDialog
  Caption = #12513#12514#12434#30331#37682
  ClientHeight = 453
  ClientWidth = 632
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 632
    Height = 41
    Align = alTop
    TabOrder = 1
    object BTN_Commit: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = #30331#37682
      ModalResult = 1
      TabOrder = 0
    end
    object BTN_Cancel: TButton
      Left = 88
      Top = 8
      Width = 75
      Height = 25
      Caption = #12461#12515#12531#12475#12523
      ModalResult = 2
      TabOrder = 1
    end
  end
  object MEMO: TMemo
    Left = 0
    Top = 41
    Width = 632
    Height = 412
    Align = alClient
    ImeMode = imOpen
    ScrollBars = ssVertical
    TabOrder = 0
  end
end
