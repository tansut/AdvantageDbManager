object FmDBSelect: TFmDBSelect
  Left = 368
  Top = 211
  Width = 266
  Height = 331
  Caption = 'Nesneleri Se'#231'iniz...'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnlDbItems: TPanel
    Left = 8
    Top = 8
    Width = 241
    Height = 257
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object lblDbItems: TLabel
      Left = 8
      Top = 8
      Width = 123
      Height = 13
      Caption = 'Veri Taban'#305' Nesneleri'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object tvDbItems: TRzCheckTree
      Left = 8
      Top = 26
      Width = 225
      Height = 223
      FrameStyle = fsStatus
      FrameVisible = True
      Indent = 19
      SelectionPen.Color = clBtnShadow
      TabOrder = 0
      MultiSelect = True
    end
  end
  object btnOk: TButton
    Left = 96
    Top = 272
    Width = 75
    Height = 25
    Caption = '&Tamam'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 174
    Top = 272
    Width = 75
    Height = 25
    Cancel = True
    Caption = #304'&ptal'
    ModalResult = 2
    TabOrder = 2
  end
end
