object fmActiveXList: TfmActiveXList
  Left = 393
  Top = 168
  BorderStyle = bsDialog
  Caption = 'ActiveX AEP Listesi'
  ClientHeight = 316
  ClientWidth = 322
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lbActiveX: TListBox
    Left = 0
    Top = 0
    Width = 322
    Height = 273
    Align = alTop
    ItemHeight = 13
    Sorted = True
    TabOrder = 0
  end
  object BtnOk: TButton
    Left = 150
    Top = 283
    Width = 75
    Height = 25
    Caption = 'Tamam'
    Default = True
    TabOrder = 1
    OnClick = BtnOkClick
  end
  object btnCancel: TButton
    Left = 239
    Top = 283
    Width = 75
    Height = 25
    Cancel = True
    Caption = #304'ptal'
    TabOrder = 2
    OnClick = btnCancelClick
  end
end
