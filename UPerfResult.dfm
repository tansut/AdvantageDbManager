object FmPerfResults: TFmPerfResults
  Left = 333
  Top = 200
  Width = 541
  Height = 518
  ActiveControl = Grid
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Performans Sonu'#231'lar'#305
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
  object RzStatusBar1: TRzStatusBar
    Left = 0
    Top = 465
    Width = 533
    Height = 19
    AutoStyle = False
    BorderInner = fsNone
    BorderOuter = fsNone
    BorderSides = [sdLeft, sdTop, sdRight, sdBottom]
    BorderWidth = 0
    FrameSides = []
    TabOrder = 0
    object RecStatus: TRzStatusPane
      Left = -1
      Top = 1
      Width = 138
      Height = 19
      Align = alLeft
      BlinkIntervalOff = 1000
      BlinkIntervalOn = 1000
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 533
    Height = 129
    Align = alTop
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 1
    object Shape1: TShape
      Left = 8
      Top = 24
      Width = 521
      Height = 99
    end
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 118
      Height = 13
      Caption = 'S'#252'reler (MiliSaniye):'
    end
    object Label2: TLabel
      Left = 16
      Top = 32
      Width = 120
      Height = 13
      Caption = 'Verilerin Yarat'#305'lmas'#305':'
      Transparent = True
    end
    object Label3: TLabel
      Left = 16
      Top = 56
      Width = 115
      Height = 13
      Caption = 'Verilerin Eklenmesi:'
      Transparent = True
    end
    object Label4: TLabel
      Left = 16
      Top = 80
      Width = 252
      Height = 13
      Caption = 'NUMARA, AD ve SOYAD '#304'ndeks Yarat'#305'lmas'#305':'
      Transparent = True
    end
    object Label5: TLabel
      Left = 16
      Top = 102
      Width = 118
      Height = 13
      Caption = 'Toplam Kay'#305't Say'#305's'#305':'
      Transparent = True
    end
    object LblCreate: TRzNumericEdit
      Left = 280
      Top = 29
      Width = 97
      Height = 19
      Color = 12320767
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentCtl3D = False
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      Text = '25.000'
      Value = 25000
      DisplayFormat = ',0;(,0)'
    end
    object LblSave: TRzNumericEdit
      Left = 280
      Top = 52
      Width = 97
      Height = 19
      Color = 12320767
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentCtl3D = False
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
      Text = '25.000'
      Value = 25000
      DisplayFormat = ',0;(,0)'
    end
    object LblIndex: TRzNumericEdit
      Left = 280
      Top = 75
      Width = 97
      Height = 19
      Color = 12320767
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentCtl3D = False
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
      Text = '25.000'
      Value = 25000
      DisplayFormat = ',0;(,0)'
    end
    object LblRecCount: TRzNumericEdit
      Left = 280
      Top = 99
      Width = 97
      Height = 19
      Color = 10813393
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentCtl3D = False
      ParentFont = False
      ReadOnly = True
      TabOrder = 3
      Text = '25.000'
      Value = 25000
      DisplayFormat = ',0;(,0)'
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 129
    Width = 533
    Height = 296
    Align = alClient
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 2
    object Grid: TDBGrid
      Left = 1
      Top = 1
      Width = 531
      Height = 294
      Align = alClient
      DataSource = DTSource
      TabOrder = 0
      TitleFont.Charset = TURKISH_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Verdana'
      TitleFont.Style = []
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 425
    Width = 533
    Height = 40
    Align = alBottom
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 3
    object Label8: TLabel
      Left = 8
      Top = 16
      Width = 70
      Height = 13
      Caption = 'Kay'#305't S'#305'ras'#305':'
    end
    object IndexCombo: TComboBox
      Left = 88
      Top = 8
      Width = 129
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 0
      Text = 'Numara'
      OnChange = IndexComboChange
      Items.Strings = (
        'Numara'
        'Ad'
        'Soyad')
    end
    object DBNavigator1: TDBNavigator
      Left = 224
      Top = 8
      Width = 240
      Height = 20
      DataSource = DTSource
      Flat = True
      TabOrder = 1
    end
  end
  object DTSource: TDataSource
    OnDataChange = DTSourceDataChange
    Left = 24
    Top = 128
  end
end
