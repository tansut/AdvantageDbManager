object FmDBObjectEditor: TFmDBObjectEditor
  Left = 428
  Top = 241
  BorderStyle = bsDialog
  Caption = 'FmDBObjectEditor'
  ClientHeight = 418
  ClientWidth = 417
  Color = clBtnFace
  Font.Charset = TURKISH_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object BtnOk: TButton
    Left = 176
    Top = 384
    Width = 75
    Height = 25
    Caption = 'Tamam'
    Default = True
    TabOrder = 0
    OnClick = BtnOkClick
  end
  object btnCancel: TButton
    Left = 256
    Top = 384
    Width = 75
    Height = 25
    Cancel = True
    Caption = #304'ptal'
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object btnHelp: TButton
    Left = 336
    Top = 384
    Width = 75
    Height = 25
    Caption = 'Yard'#305'm'
    TabOrder = 2
    OnClick = btnHelpClick
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 401
    Height = 369
    ActivePage = tsGeneral
    TabIndex = 0
    TabOrder = 3
    object tsGeneral: TTabSheet
      Caption = 'Genel'
    end
  end
  object btnApply: TButton
    Left = 8
    Top = 384
    Width = 75
    Height = 25
    Caption = '&Uygula'
    TabOrder = 4
    OnClick = btnApplyClick
  end
end
