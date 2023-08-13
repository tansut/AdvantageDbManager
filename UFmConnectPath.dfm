object FmGetConnectPath: TFmGetConnectPath
  Left = 299
  Top = 180
  BorderStyle = bsDialog
  Caption = 'Advantage Veri Taban'#305'na Ba'#287'lan'
  ClientHeight = 183
  ClientWidth = 363
  Color = clBtnFace
  Font.Charset = TURKISH_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 87
    Height = 13
    Caption = 'S'#246'zl'#252'k Dosyas'#305
  end
  object SpeedButton1: TSpeedButton
    Left = 334
    Top = 23
    Width = 23
    Height = 22
    Cursor = crHandPoint
    Caption = '...'
    Flat = True
    OnClick = SpeedButton1Click
  end
  object Shape1: TShape
    Left = 8
    Top = 56
    Width = 321
    Height = 89
    Brush.Color = clBtnFace
    Shape = stRoundRect
  end
  object Shape2: TShape
    Left = 16
    Top = 48
    Width = 65
    Height = 17
    Brush.Color = clBtnFace
  end
  object Label2: TLabel
    Left = 23
    Top = 50
    Width = 49
    Height = 13
    Caption = #214'rnekler'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label3: TLabel
    Left = 24
    Top = 71
    Width = 154
    Height = 13
    Caption = 'C:\Veri Taban'#305'\Ads.add'
    Font.Charset = TURKISH_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label4: TLabel
    Left = 24
    Top = 88
    Width = 190
    Height = 13
    Caption = '\\Sunucu\Payla'#351#305'm\Ads.add'
    Font.Charset = TURKISH_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label5: TLabel
    Left = 24
    Top = 105
    Width = 230
    Height = 13
    Caption = '\\10.1.1.1:1520\root\ads\Ads.add'
    Font.Charset = TURKISH_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label6: TLabel
    Left = 24
    Top = 121
    Width = 272
    Height = 13
    Caption = '\\www.domain.com:2002\adsdb\Ads.add'
    Font.Charset = TURKISH_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object BtnOK: TButton
    Left = 8
    Top = 152
    Width = 75
    Height = 25
    Caption = 'Tamam'
    Default = True
    TabOrder = 0
    OnClick = BtnOKClick
  end
  object btnCancel: TButton
    Left = 88
    Top = 152
    Width = 75
    Height = 25
    Cancel = True
    Caption = #304'ptal'
    ModalResult = 2
    TabOrder = 1
  end
  object EdDictPath: TComboBox
    Left = 8
    Top = 24
    Width = 321
    Height = 21
    ItemHeight = 13
    TabOrder = 2
  end
  object DlgOpenDict: TAgOpenDialog
    DefaultExt = 'add'
    FileName = '*.add'
    Filter = 'Advantage Veri S'#246'zl'#252'k Dosyalar'#305'|*.add'
    Options = [ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    ShowPlacesBar = True
    Left = 330
    Top = 64
  end
end
