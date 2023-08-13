object FmPerformans: TFmPerformans
  Left = 365
  Top = 368
  ActiveControl = EdRecCount
  BorderStyle = bsDialog
  Caption = 'Performans Demosu'
  ClientHeight = 188
  ClientWidth = 499
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
  object Label1: TLabel
    Left = 32
    Top = 8
    Width = 462
    Height = 39
    Caption = 
      'Advantage Performans Demosu "Numara, Ad, Soyad, Maas" alanlar'#305'na' +
      ' sahip bir '#13#10'tabloya istedi'#287'iniz kadar kay'#305't eklenmesini ve tabl' +
      'o bilgilerinin g'#246'sterimini i'#231'ermektedir.'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 16
    Top = 120
    Width = 67
    Height = 13
    Caption = 'Kay'#305't Say'#305's'#305
  end
  object Shape1: TShape
    Left = 16
    Top = 56
    Width = 473
    Height = 49
    Shape = stRoundRect
  end
  object Label3: TLabel
    Left = 72
    Top = 64
    Width = 379
    Height = 26
    Caption = 
      #220'cretsiz s'#252'r'#252'm olan Yerel Sunucu ile yap'#305'lan bu testin amac'#305' '#13#10'A' +
      'dvantage'#39#305'n sa'#287'lad'#305#287#305' y'#252'ksek performans'#305' sizlere g'#246'sterebilmekti' +
      'r.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Image1: TImage
    Left = 8
    Top = 8
    Width = 16
    Height = 16
    AutoSize = True
    Picture.Data = {
      07544269746D617036030000424D360300000000000036000000280000001000
      000010000000010018000000000000030000120B0000120B0000000000000000
      0000FFFFFFFFFFFFFFFFFFF9FCF9E3F1E3C1E0C1A2D1A28FC78F8FC78FA2D1A2
      C1E0C1E3F1E3F9FCF9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3F9F3BEDFBE509D
      50046604005700005500006300007800048B0450B150BEDFBEF3F9F3FFFFFFFF
      FFFFFFFFFFF3F9F3AED7AE187418004E00004900005300006100007300008800
      009F0000B00018AD18AED7AEF3F9F3FFFFFFF9FCF9BEDFBE187418004700004C
      00005C0000700000850000980000AA0000BC0000D00000E10018BE18BEDFBEF9
      FCF9E3F1E3509D50004D00004C00006000007C00009A0000B20000C20000CF00
      00DE0000EF0003FD0310E81056C156E3F1E3C1E0C1046504004800005B00007B
      0000A10000C10000D70000E40000ED0000F9000AFD0A1CFD1C2BFD2B20C120C1
      E0C1A2D1A2005400004F00006C0000960000C00000DE0000EF0000F60000FD00
      0BFD0B1DFD1D31FD3143FE4339DF39A2D1A28FC78F004E00005900007D0000AC
      0000D40000EE0000F90000FD0007FD0715FD152BFD2B44FE4458FE585AF55A8F
      C78F8FC78F005600006400008B0000B90000DE0000F40000FD0003FD030CFD0C
      1EFD1E39FD3955FE556AFE6A6BF56B8FC78FA2D1A200690000730000980000C2
      0000E50000F90004FD040BFD0B18FD182EFD2E4CFE4C69FE697CFE7C61DF61A2
      D1A2C1E0C1047E0400860000A60000CC0000ED0004FD0410FD101BFD1B2CFD2C
      45FE4563FE637CFE7C8BFE8B4AC14AC1E0C1E3F1E350AC5000980000B70000D8
      0000F90011FD1122FD2232FD3246FE4660FE6079FE798DFE8D7CE97C6CC16CE3
      F1E3F9FCF9BEDFBE18A31800C60000E70007FD0721FD2136FD364AFE4A60FE60
      76FE768AFE8A8DF78D54BF54BEDFBEF9FCF9FFFFFFF3F9F3AED7AE18B31800E4
      0014FD142EFD2E46FE465BFE5B70FE7082FE8277E97753BF53AED7AEF3F9F3FF
      FFFFFFFFFFFFFFFFF3F9F3BEDFBE51C15114C11429DE2948F5485AF55A57DF57
      45C1456BC16BBEDFBEF3F9F3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9FCF9E3F1
      E3C1E0C1A2D1A28FC78F8FC78FA2D1A2C1E0C1E3F1E3F9FCF9FFFFFFFFFFFFFF
      FFFF}
    Transparent = True
  end
  object EdRecCount: TRzNumericEdit
    Left = 88
    Top = 112
    Width = 145
    Height = 21
    TabOrder = 0
    Text = '25.000'
    OnChange = EdRecCountChange
    Value = 25000
    DisplayFormat = ',0;(,0)'
  end
  object btnGo: TButton
    Left = 240
    Top = 112
    Width = 105
    Height = 25
    Caption = #304#351'leme Ba'#351'la'
    Default = True
    TabOrder = 1
    OnClick = btnGoClick
  end
  object mmText: TMemo
    Left = 16
    Top = 145
    Width = 473
    Height = 17
    TabStop = False
    BevelEdges = []
    BorderStyle = bsNone
    Color = clBtnFace
    Ctl3D = False
    Font.Charset = TURKISH_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    Lines.Strings = (
      'mmText')
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 2
  end
  object RzStatusBar1: TRzStatusBar
    Left = 0
    Top = 169
    Width = 499
    Height = 19
    AutoStyle = False
    ShowSizeGrip = False
    BorderInner = fsNone
    BorderOuter = fsNone
    BorderSides = [sdLeft, sdTop, sdRight, sdBottom]
    BorderWidth = 0
    FrameSides = []
    TabOrder = 3
    object PBar: TRzProgressBar
      Left = 169
      Top = 1
      Width = 331
      Height = 19
      Align = alClient
      BackColor = clBtnFace
      BorderInner = fsStatus
      BorderOuter = fsNone
      BorderWidth = 1
      InteriorOffset = 0
      PartsComplete = 0
      Percent = 0
      TotalParts = 0
      Visible = False
    end
    object Status: TRzStatusPane
      Left = -1
      Top = 1
      Width = 170
      Height = 19
      Align = alLeft
      BlinkIntervalOff = 1000
      BlinkIntervalOn = 1000
      Caption = 'Haz'#305'r'
    end
  end
  object DbConn: TAdsConnection
    IsConnected = False
    AdsServerTypes = [stADS_LOCAL]
    LoginPrompt = False
    Username = 'AdsSys'
    Compression = ccAdsCompressionNotSet
    Left = 432
    Top = 24
  end
  object PersonsTable: TAdsTable
    DatabaseName = 'DbConn'
    IndexDefs = <
      item
        Name = 'ADINDEX'
        Fields = 'AD'
      end>
    SequencedLevel = slExact
    StoreActive = True
    AdsConnection = DbConn
    FieldDefs = <
      item
        Name = 'NUMARA'
        DataType = ftAutoInc
      end
      item
        Name = 'AD'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'SOYAD'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'MAAS'
        DataType = ftCurrency
      end>
    StoreDefs = True
    Exclusive = True
    TableName = 'PERSONS'
    Left = 464
    Top = 24
    object PersonsTableNUMARA: TAutoIncField
      DisplayLabel = 'Numara'
      FieldName = 'NUMARA'
    end
    object PersonsTableAD: TStringField
      DisplayLabel = 'Ad'
      FieldName = 'AD'
      Size = 30
    end
    object PersonsTableSOYAD: TStringField
      DisplayLabel = 'Soyad'
      FieldName = 'SOYAD'
      Size = 30
    end
    object PersonsTableMAAS: TCurrencyField
      DisplayLabel = 'Maa'#351
      DisplayWidth = 20
      FieldName = 'MAAS'
    end
  end
end
