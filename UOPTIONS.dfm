object FmOptions: TFmOptions
  Left = 305
  Top = 170
  BorderStyle = bsDialog
  Caption = 'Tan'#305'mlar'
  ClientHeight = 357
  ClientWidth = 430
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
  object btnOK: TButton
    Left = 16
    Top = 320
    Width = 75
    Height = 25
    Caption = 'Tamam'
    Default = True
    TabOrder = 0
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 96
    Top = 320
    Width = 75
    Height = 25
    Cancel = True
    Caption = #304'ptal'
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object PG: TPageControl
    Left = 16
    Top = 8
    Width = 401
    Height = 305
    ActivePage = GeneralSheet
    TabIndex = 0
    TabOrder = 2
    object GeneralSheet: TTabSheet
      Caption = 'Genel'
      object ChkAutoVersion: TCheckBox
        Left = 16
        Top = 16
        Width = 369
        Height = 17
        Caption = 'Periyodik S'#252'r'#252'm Kontrol'#252' Yap'
        Checked = True
        State = cbChecked
        TabOrder = 0
      end
      object ChkAutoTablePath: TCheckBox
        Left = 8
        Top = 256
        Width = 361
        Height = 17
        Caption = 'Tablo dizinlerini otomatik s'#246'zl'#252'k dosyas'#305'ndan otomatik alg'#305'la'
        TabOrder = 1
        Visible = False
      end
      object ChkShowHints: TCheckBox
        Left = 16
        Top = 40
        Width = 209
        Height = 17
        Caption = 'Yard'#305'mc'#305' ip u'#231'lar'#305' g'#246'ster'
        Checked = True
        State = cbChecked
        TabOrder = 2
      end
    end
    object EnvSettings: TTabSheet
      Caption = 'Veri Taban'#305' Ortam Tan'#305'mlar'#305
      ImageIndex = 1
      object Label1: TLabel
        Left = 16
        Top = 16
        Width = 81
        Height = 13
        Caption = 'Tarih Format'#305':'
      end
      object Label2: TLabel
        Left = 16
        Top = 64
        Width = 81
        Height = 13
        Caption = 'Ondal'#305'k Say'#305's'#305
      end
      object DateFmtCombo: TComboBox
        Left = 16
        Top = 32
        Width = 145
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        Items.Strings = (
          'MM/dd/yy'
          'yy.MM.dd'
          'dd/MM/yy'
          'dd.MM.yy'
          'dd-MM-yy'
          'yy/MM/dd'
          'MM-dd-yy'
          'MM/dd/ccyy'
          'ccyy.MM.dd'
          'dd/MM/ccyy'
          'dd.MM.ccyy'
          'dd-MM-ccyy'
          'ccyy/MM/dd'
          'MM-dd-ccyy'
          'yyyy-MM-dd')
      end
      object Decimals: TUpDown
        Left = 49
        Top = 80
        Width = 16
        Height = 21
        Associate = EdDecimals
        Min = 0
        Position = 2
        TabOrder = 1
        Wrap = False
      end
      object EdDecimals: TEdit
        Left = 16
        Top = 80
        Width = 33
        Height = 21
        ReadOnly = True
        TabOrder = 2
        Text = '2'
      end
    end
  end
  object AdsSettings: TAdsSettings
    DateFormat = 'dd.MM.ccyy'
    NumDecimals = 2
    SetDelphiDate = True
    ShowDeleted = True
    AdsServerTypes = [stADS_REMOTE, stADS_AIS]
    NumCachedTables = 0
    NumCachedCursors = 25
    Left = 240
    Top = 120
  end
end
