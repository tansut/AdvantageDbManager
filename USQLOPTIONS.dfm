object FmSQLOptions: TFmSQLOptions
  Left = 401
  Top = 243
  BorderStyle = bsDialog
  Caption = 'SQL Tan'#305'mlar'#305
  ClientHeight = 249
  ClientWidth = 336
  Color = clBtnFace
  Font.Charset = TURKISH_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object ChkRequestLive: TCheckBox
    Left = 16
    Top = 16
    Width = 305
    Height = 17
    Caption = 'Canl'#305' Sonu'#231' K'#252'mesi (RequestLive)'
    TabOrder = 0
  end
  object BtnOK: TButton
    Left = 8
    Top = 216
    Width = 75
    Height = 25
    Caption = 'Tamam'
    Default = True
    TabOrder = 1
    OnClick = BtnOKClick
  end
  object btnCancel: TButton
    Left = 88
    Top = 216
    Width = 75
    Height = 25
    Cancel = True
    Caption = #304'ptal'
    TabOrder = 2
    OnClick = btnCancelClick
  end
end
