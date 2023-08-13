object MgtForm: TMgtForm
  Left = 317
  Top = 283
  HelpContext = 1
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Veri Taban'#305' Sunucusu Y'#246'netimi'
  ClientHeight = 445
  ClientWidth = 547
  Color = clBtnFace
  Font.Charset = TURKISH_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object poMainPage: TPageControl
    Left = 8
    Top = 40
    Width = 529
    Height = 377
    ActivePage = OpenFiles
    MultiLine = True
    TabIndex = 3
    TabOrder = 0
    OnChange = MainPageChange
    object DataInfo: TTabSheet
      Caption = 'Veritaban'#305' Bilgileri'
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 521
        Height = 331
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object poDInfoGrid: TXStringGrid
          Left = 22
          Top = 28
          Width = 483
          Height = 269
          DefaultColWidth = 72
          DefaultRowHeight = 32
          RowCount = 8
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          FixedLineColor = clBlack
          Columns = <
            item
              HeaderFont.Charset = DEFAULT_CHARSET
              HeaderFont.Color = clNavy
              HeaderFont.Height = -11
              HeaderFont.Name = 'MS Sans Serif'
              HeaderFont.Style = [fsBold]
              HeaderAlignment = taCenter
              Color = clBtnFace
              Width = 81
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
            end
            item
              HeaderFont.Charset = DEFAULT_CHARSET
              HeaderFont.Color = clNavy
              HeaderFont.Height = -11
              HeaderFont.Name = 'MS Sans Serif'
              HeaderFont.Style = []
              Color = clInfoBk
              Width = 76
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clMaroon
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              Editor = EditCellEditor1
            end
            item
              HeaderFont.Charset = DEFAULT_CHARSET
              HeaderFont.Color = clNavy
              HeaderFont.Height = -11
              HeaderFont.Name = 'MS Sans Serif'
              HeaderFont.Style = []
              Color = clInfoBk
              Width = 117
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clMaroon
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              Editor = EditCellEditor1
            end
            item
              HeaderFont.Charset = DEFAULT_CHARSET
              HeaderFont.Color = clNavy
              HeaderFont.Height = -11
              HeaderFont.Name = 'MS Sans Serif'
              HeaderFont.Style = []
              Color = clInfoBk
              Width = 112
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clMaroon
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              Editor = EditCellEditor1
            end
            item
              HeaderFont.Charset = DEFAULT_CHARSET
              HeaderFont.Color = clNavy
              HeaderFont.Height = -11
              HeaderFont.Name = 'MS Sans Serif'
              HeaderFont.Style = []
              Color = clInfoBk
              Width = 72
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clMaroon
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              Editor = EditCellEditor1
            end>
          MultiLine = False
          ImmediateEditMode = False
          ColWidths = (
            81
            76
            117
            112
            72)
          RowHeights = (
            32
            32
            32
            32
            32
            32
            32
            32)
        end
      end
    end
    object InstallInfo: TTabSheet
      Caption = 'Kurulum Bilgileri'
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 521
        Height = 331
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object Label4: TLabel
          Left = 24
          Top = 32
          Width = 83
          Height = 13
          Caption = 'Lisans Sahibi :'
        end
        object Label5: TLabel
          Left = 24
          Top = 63
          Width = 90
          Height = 13
          Caption = 'Seri Numaras'#305' :'
        end
        object Label7: TLabel
          Left = 24
          Top = 93
          Width = 94
          Height = 13
          Caption = 'Kullan'#305'c'#305' Say'#305's'#305' :'
        end
        object Label8: TLabel
          Left = 24
          Top = 124
          Width = 83
          Height = 13
          Caption = 'ADS S'#252'r'#252'm'#252' :'
        end
        object Label9: TLabel
          Left = 24
          Top = 154
          Width = 93
          Height = 13
          Caption = 'Kurulum Tarihi :'
        end
        object Label10: TLabel
          Left = 24
          Top = 185
          Width = 120
          Height = 13
          Caption = 'Kullan'#305'm Son Tarihi :'
        end
        object Label1: TLabel
          Left = 24
          Top = 215
          Width = 77
          Height = 13
          Caption = 'Log Giri'#351'leri :'
        end
        object Label2: TLabel
          Left = 24
          Top = 246
          Width = 111
          Height = 13
          Caption = 'ANSI Karakter Set:'
        end
        object Label3: TLabel
          Left = 24
          Top = 276
          Width = 107
          Height = 13
          Caption = 'OEM Karakter Set:'
        end
        object poEvalDate: TPanel
          Left = 159
          Top = 182
          Width = 185
          Height = 20
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clInfoBk
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object poInitDate: TPanel
          Left = 159
          Top = 152
          Width = 185
          Height = 20
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clInfoBk
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object poADSRev: TPanel
          Left = 159
          Top = 122
          Width = 185
          Height = 20
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clInfoBk
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object poUserOpt: TPanel
          Left = 159
          Top = 92
          Width = 185
          Height = 20
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clInfoBk
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
        object poSerialNum: TPanel
          Left = 159
          Top = 62
          Width = 185
          Height = 20
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clInfoBk
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
        end
        object poRegTo: TPanel
          Left = 159
          Top = 32
          Width = 185
          Height = 20
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clInfoBk
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
        end
        object poLogEntries: TPanel
          Left = 159
          Top = 212
          Width = 185
          Height = 20
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clInfoBk
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
        end
        object poANSISet: TPanel
          Left = 159
          Top = 242
          Width = 185
          Height = 20
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clInfoBk
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
        end
        object poOEMSet: TPanel
          Left = 159
          Top = 272
          Width = 185
          Height = 20
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clInfoBk
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 8
        end
      end
    end
    object ConnUsers: TTabSheet
      Caption = 'Ba'#287'l'#305' Kullan'#305'c'#305'lar'
      object Panel1: TPanel
        Left = 0
        Top = 8
        Width = 513
        Height = 129
        Caption = 'Panel1'
        TabOrder = 0
        object poStrGrdConUser: TStringGrid
          Left = 1
          Top = 1
          Width = 511
          Height = 127
          Hint = 'Right Click to Disconnect Selected User'
          Align = alClient
          Color = clInfoBk
          ColCount = 4
          DefaultRowHeight = 17
          FixedCols = 0
          RowCount = 2
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
          ParentShowHint = False
          PopupMenu = pmDisconUser
          ScrollBars = ssVertical
          ShowHint = True
          TabOrder = 0
          ColWidths = (
            43
            251
            64
            64)
        end
      end
      object Panel3: TPanel
        Left = 0
        Top = 136
        Width = 377
        Height = 65
        Caption = 'Panel3'
        TabOrder = 1
        object poStrGrdOpenLck: TStringGrid
          Left = 1
          Top = 1
          Width = 375
          Height = 63
          Align = alClient
          Color = clInfoBk
          ColCount = 1
          DefaultColWidth = 20
          DefaultRowHeight = 17
          FixedCols = 0
          RowCount = 2
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
          ScrollBars = ssVertical
          TabOrder = 0
          ColWidths = (
            205)
        end
      end
      object Panel5: TPanel
        Left = 376
        Top = 136
        Width = 137
        Height = 65
        Caption = 'Panel5'
        TabOrder = 2
        object poRgUserOpenType: TRadioGroup
          Left = 1
          Top = 1
          Width = 135
          Height = 63
          Align = alClient
          Caption = 'A'#231#305'k Dosya T'#252'rleri'
          ItemIndex = 0
          Items.Strings = (
            'A'#231#305'k Tablolar'
            'A'#231#305'k '#304'ndeksler')
          TabOrder = 0
        end
      end
      object Panel6: TPanel
        Left = 0
        Top = 207
        Width = 513
        Height = 113
        Caption = 'Panel6'
        TabOrder = 3
        object poStrGrdOpenData: TStringGrid
          Left = 1
          Top = 1
          Width = 511
          Height = 111
          Align = alClient
          Color = clInfoBk
          ColCount = 2
          DefaultColWidth = 300
          DefaultRowHeight = 17
          FixedCols = 0
          RowCount = 2
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
          ScrollBars = ssVertical
          TabOrder = 0
          ColWidths = (
            30
            478)
        end
      end
    end
    object OpenFiles: TTabSheet
      Caption = 'A'#231#305'k Dosyalar'
      object Panel8: TPanel
        Left = 0
        Top = 183
        Width = 521
        Height = 122
        TabOrder = 0
        object poStrGrdUserFile: TStringGrid
          Left = 1
          Top = 8
          Width = 519
          Height = 113
          Align = alBottom
          Color = clInfoBk
          ColCount = 2
          DefaultRowHeight = 17
          FixedCols = 0
          RowCount = 2
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
          ScrollBars = ssVertical
          TabOrder = 0
          ColWidths = (
            40
            468)
        end
      end
      object Panel9: TPanel
        Left = 0
        Top = 66
        Width = 521
        Height = 116
        TabOrder = 1
        object poStrGrdOpenFiles: TStringGrid
          Left = 1
          Top = 8
          Width = 519
          Height = 107
          Align = alBottom
          Color = clInfoBk
          ColCount = 2
          DefaultRowHeight = 17
          FixedCols = 0
          RowCount = 2
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
          ScrollBars = ssVertical
          TabOrder = 0
          OnClick = RgOpenFileTypeClick
          ColWidths = (
            40
            468)
        end
      end
      object Panel10: TPanel
        Left = 0
        Top = 0
        Width = 521
        Height = 65
        Align = alTop
        TabOrder = 2
        object poRgOpenFileType: TRadioGroup
          Left = 1
          Top = 1
          Width = 512
          Height = 63
          Align = alLeft
          Caption = 'A'#231#305'k Dosya T'#252'rleri'
          Columns = 2
          ItemIndex = 0
          Items.Strings = (
            'A'#231#305'k Talolar'
            'A'#231#305'k '#304'ndeksler')
          TabOrder = 0
          OnClick = RgOpenFileTypeClick
        end
      end
    end
    object ConfigParam: TTabSheet
      Caption = 'Uygulama Parametreleri'
      object poConfigPageCtl: TPageControl
        Left = 0
        Top = 0
        Width = 521
        Height = 331
        ActivePage = NotAffectMem
        Align = alClient
        TabIndex = 1
        TabOrder = 0
        object AffectMem: TTabSheet
          Caption = 'Etkin Haf'#305'za'
          object Panel12: TPanel
            Left = 0
            Top = 0
            Width = 513
            Height = 303
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            object Label13: TLabel
              Left = 16
              Top = 48
              Width = 93
              Height = 13
              Caption = 'Ba'#287'lant'#305' Say'#305's'#305' :'
            end
            object Label14: TLabel
              Left = 16
              Top = 82
              Width = 140
              Height = 13
              Caption = #199'al'#305#351'ma Alanlar'#305' Say'#305's'#305' :'
            end
            object Label15: TLabel
              Left = 16
              Top = 116
              Width = 78
              Height = 13
              Caption = 'Tablo Say'#305's'#305' :'
            end
            object Label16: TLabel
              Left = 16
              Top = 150
              Width = 86
              Height = 13
              Caption = #304'ndeks Say'#305's'#305' :'
            end
            object Label17: TLabel
              Left = 16
              Top = 182
              Width = 68
              Height = 13
              Caption = 'Kilit Say'#305's'#305' :'
            end
            object Label19: TLabel
              Left = 16
              Top = 218
              Width = 123
              Height = 13
              Caption = #199'oklu '#304#351'letim Say'#305's'#305' :'
            end
            object Label23: TLabel
              Left = 384
              Top = 16
              Width = 80
              Height = 13
              Caption = 'Haf'#305'za (Bytes)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold, fsUnderline]
              ParentFont = False
            end
            object Label12: TLabel
              Left = 308
              Top = 252
              Width = 51
              Height = 13
              Caption = 'Toplam :'
            end
            object poNumWorkThread: TPanel
              Left = 200
              Top = 215
              Width = 113
              Height = 18
              BevelInner = bvLowered
              BevelOuter = bvLowered
              Color = clInfoBk
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clMaroon
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
            end
            object poNumDataLocks: TPanel
              Left = 200
              Top = 181
              Width = 113
              Height = 18
              BevelInner = bvLowered
              BevelOuter = bvLowered
              Color = clInfoBk
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clMaroon
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
            end
            object poNumIndexes: TPanel
              Left = 200
              Top = 148
              Width = 113
              Height = 18
              BevelInner = bvLowered
              BevelOuter = bvLowered
              Color = clInfoBk
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clMaroon
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 2
            end
            object poNumTables: TPanel
              Left = 200
              Top = 114
              Width = 113
              Height = 18
              BevelInner = bvLowered
              BevelOuter = bvLowered
              Color = clInfoBk
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clMaroon
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 3
            end
            object poNumWork: TPanel
              Left = 200
              Top = 81
              Width = 113
              Height = 18
              BevelInner = bvLowered
              BevelOuter = bvLowered
              Color = clInfoBk
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clMaroon
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 4
            end
            object poNumConn: TPanel
              Left = 200
              Top = 47
              Width = 113
              Height = 18
              BevelInner = bvLowered
              BevelOuter = bvLowered
              Color = clInfoBk
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clMaroon
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 5
            end
            object poMemNumConn: TPanel
              Left = 360
              Top = 47
              Width = 137
              Height = 18
              BevelInner = bvLowered
              BevelOuter = bvLowered
              Color = clInfoBk
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clMaroon
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 6
            end
            object poMemNumWork: TPanel
              Left = 360
              Top = 81
              Width = 137
              Height = 18
              BevelInner = bvLowered
              BevelOuter = bvLowered
              Color = clInfoBk
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clMaroon
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 7
            end
            object poMemNumTables: TPanel
              Left = 360
              Top = 114
              Width = 137
              Height = 18
              BevelInner = bvLowered
              BevelOuter = bvLowered
              Color = clInfoBk
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clMaroon
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 8
            end
            object poMemNumIndexes: TPanel
              Left = 360
              Top = 148
              Width = 137
              Height = 18
              BevelInner = bvLowered
              BevelOuter = bvLowered
              Color = clInfoBk
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clMaroon
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 9
            end
            object poMemNumDataLocks: TPanel
              Left = 360
              Top = 181
              Width = 137
              Height = 18
              BevelInner = bvLowered
              BevelOuter = bvLowered
              Color = clInfoBk
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clMaroon
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 10
            end
            object poMemNumWorkThead: TPanel
              Left = 360
              Top = 215
              Width = 137
              Height = 18
              BevelInner = bvLowered
              BevelOuter = bvLowered
              Color = clInfoBk
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clMaroon
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 11
            end
            object poTotalMemUsed: TPanel
              Left = 360
              Top = 249
              Width = 137
              Height = 18
              BevelInner = bvLowered
              BevelOuter = bvLowered
              Color = clInfoBk
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clMaroon
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 12
            end
          end
        end
        object NotAffectMem: TTabSheet
          Caption = 'Etkin Olmayan Haf'#305'za'
          object Panel13: TPanel
            Left = 0
            Top = 0
            Width = 513
            Height = 303
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            object Label27: TLabel
              Left = 32
              Top = 34
              Width = 216
              Height = 13
              Caption = 'Maksimum Hata Log Miktar'#305' (KBytes):'
            end
            object Label28: TLabel
              Left = 32
              Top = 71
              Width = 94
              Height = 13
              Caption = 'Hata Log Dizini :'
            end
            object Label29: TLabel
              Left = 32
              Top = 109
              Width = 160
              Height = 13
              Caption = 'Semaphore Ba'#287'lant'#305' Dizini :'
            end
            object Label30: TLabel
              Left = 32
              Top = 146
              Width = 188
              Height = 13
              Caption = #304#351'lem Grubu Log Dosyas'#305' Dizini :'
            end
            object Label42: TLabel
              Left = 32
              Top = 184
              Width = 44
              Height = 13
              Caption = 'IP Port:'
            end
            object Label6: TLabel
              Left = 32
              Top = 222
              Width = 78
              Height = 13
              Caption = 'Internet Port:'
            end
            object poTranLogFile: TPanel
              Left = 248
              Top = 143
              Width = 249
              Height = 20
              BevelInner = bvLowered
              BevelOuter = bvLowered
              Color = clInfoBk
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clMaroon
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
            end
            object poSemFilePath: TPanel
              Left = 248
              Top = 106
              Width = 249
              Height = 20
              BevelInner = bvLowered
              BevelOuter = bvLowered
              Color = clInfoBk
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clMaroon
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
            end
            object poLogPath: TPanel
              Left = 248
              Top = 68
              Width = 249
              Height = 20
              BevelInner = bvLowered
              BevelOuter = bvLowered
              Color = clInfoBk
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clMaroon
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 2
            end
            object poSizeErrorLog: TPanel
              Left = 248
              Top = 31
              Width = 249
              Height = 20
              BevelInner = bvLowered
              BevelOuter = bvLowered
              Color = clInfoBk
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clMaroon
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 3
            end
            object poIPRecv: TPanel
              Left = 248
              Top = 181
              Width = 249
              Height = 20
              BevelInner = bvLowered
              BevelOuter = bvLowered
              Color = clInfoBk
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clMaroon
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 4
            end
            object poInternetPort: TPanel
              Left = 248
              Top = 219
              Width = 249
              Height = 20
              BevelInner = bvLowered
              BevelOuter = bvLowered
              Color = clInfoBk
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clMaroon
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 5
            end
          end
        end
      end
    end
    object CommStat: TTabSheet
      Caption = 'Haberle'#351'me '#304'statistikleri'
      object Panel14: TPanel
        Left = 0
        Top = 0
        Width = 521
        Height = 331
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object Label31: TLabel
          Left = 16
          Top = 24
          Width = 164
          Height = 13
          Caption = 'Toplam Al'#305'nan Paket Say'#305's'#305' :'
        end
        object Label32: TLabel
          Left = 16
          Top = 51
          Width = 115
          Height = 13
          Caption = 'Check-Sum Hatas'#305' :'
        end
        object Label33: TLabel
          Left = 16
          Top = 77
          Width = 160
          Height = 13
          Caption = 'S'#305'rad'#305#351#305'nda Gelen Paketler :'
        end
        object Label34: TLabel
          Left = 16
          Top = 104
          Width = 157
          Height = 13
          Caption = 'S'#305'rad'#305#351#305'nda Gelen '#304'stekler :'
        end
        object Label35: TLabel
          Left = 16
          Top = 131
          Width = 168
          Height = 13
          Caption = 'Packet Owner Not Logged In:'
        end
        object Label36: TLabel
          Left = 16
          Top = 150
          Width = 160
          Height = 26
          Caption = 'Sunucu Taraf'#305'ndan Yap'#305'lan  '#13#10'Ba'#287'lant'#305' Kesilmeleri :'
        end
        object Label37: TLabel
          Left = 16
          Top = 184
          Width = 161
          Height = 13
          Caption = 'Kald'#305'r'#305'lan Eksik Ba'#287'lant'#305'lar :'
        end
        object Label38: TLabel
          Left = 16
          Top = 211
          Width = 109
          Height = 13
          Caption = 'Ge'#231'ersiz Paketler :'
        end
        object Label39: TLabel
          Left = 16
          Top = 237
          Width = 101
          Height = 13
          Caption = 'RecvFrom Errors:'
        end
        object Label40: TLabel
          Left = 16
          Top = 264
          Width = 87
          Height = 13
          Caption = 'SendTo Errors:'
        end
        object Label41: TLabel
          Left = 377
          Top = 33
          Width = 125
          Height = 13
          Caption = 'Toplam Paketlerin Y'#252'zdesi'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object poTotalPacketRcv: TPanel
          Left = 232
          Top = 22
          Width = 129
          Height = 20
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clInfoBk
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object poCheckSum: TPanel
          Left = 232
          Top = 49
          Width = 129
          Height = 20
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clInfoBk
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object poPacketOutSeq: TPanel
          Left = 232
          Top = 76
          Width = 129
          Height = 20
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clInfoBk
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object poReqOutSeq: TPanel
          Left = 232
          Top = 103
          Width = 129
          Height = 20
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clInfoBk
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
        object poOwnerNotLog: TPanel
          Left = 232
          Top = 130
          Width = 129
          Height = 20
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clInfoBk
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
        end
        object poServerInitDiscon: TPanel
          Left = 232
          Top = 156
          Width = 129
          Height = 20
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clInfoBk
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
        end
        object poRemovePartCon: TPanel
          Left = 232
          Top = 183
          Width = 129
          Height = 20
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clInfoBk
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
        end
        object poInvalidPacket: TPanel
          Left = 232
          Top = 210
          Width = 129
          Height = 20
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clInfoBk
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
        end
        object poRecvError: TPanel
          Left = 232
          Top = 237
          Width = 129
          Height = 20
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clInfoBk
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 8
        end
        object poSendError: TPanel
          Left = 232
          Top = 264
          Width = 129
          Height = 20
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clInfoBk
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 9
        end
        object poPercentError: TPanel
          Left = 376
          Top = 49
          Width = 129
          Height = 20
          BevelInner = bvLowered
          BevelOuter = bvLowered
          Color = clInfoBk
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 10
        end
        object mbResetStat: TButton
          Left = 392
          Top = 288
          Width = 121
          Height = 25
          Caption = #304'statistikleri Yenile'
          TabOrder = 11
          OnClick = ResetStatClick
        end
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 426
    Width = 547
    Height = 19
    Panels = <
      item
        Text = #199'ALI'#350'MA S'#220'RES'#304':'
        Width = 110
      end
      item
        Alignment = taCenter
        Width = 200
      end
      item
        Text = #304#350'LEMLER:'
        Width = 70
      end
      item
        Alignment = taCenter
        Width = 50
      end>
    SimplePanel = False
    SizeGrip = False
  end
  object poServerPanel: TPanel
    Left = 0
    Top = 0
    Width = 547
    Height = 35
    Align = alTop
    Caption = '0'
    TabOrder = 2
    object Label11: TLabel
      Left = 5
      Top = 12
      Width = 88
      Height = 13
      Caption = 'Sunucu S'#252'r'#252'c'#252's'#252':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object sbConnectServer: TSpeedButton
      Left = 348
      Top = 8
      Width = 26
      Height = 21
      Cursor = crHandPoint
      Hint = 
        '\\Sunucu\Payla'#351#305'm'#13#10'\\Sunucu\Volume '#13#10'x:\'#13#10'\\IP Adresi'#13#10'\\IP Adre' +
        'si:Port'
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333333333333333FF33333333333330003FF3FFFFF3333777003000003333
        300077F777773F333777E00BFBFB033333337773333F7F33333FE0BFBF000333
        330077F3337773F33377E0FBFBFBF033330077F3333FF7FFF377E0BFBF000000
        333377F3337777773F3FE0FBFBFBFBFB039977F33FFFFFFF7377E0BF00000000
        339977FF777777773377000BFB03333333337773FF733333333F333000333333
        3300333777333333337733333333333333003333333333333377333333333333
        333333333333333333FF33333333333330003333333333333777333333333333
        3000333333333333377733333333333333333333333333333333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = sbConnectServerClick
    end
    object imgConnectedServer: TImage
      Left = 395
      Top = 7
      Width = 21
      Height = 23
      Picture.Data = {
        07544269746D6170F6050000424DF60500000000000036000000280000001500
        0000170000000100180000000000C00500000000000000000000000000000000
        0000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        0000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        0000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        0000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000
        000000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        0000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000000000
        000000000000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        0000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000000000
        BFBFBF000000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        0000FF8000FF8000FF8000FF8000FF800000FFFFFF8000FF800000FFFF000000
        00000000000000FFFFFF8000FF800000FFFFFF8000FF8000FF8000FF8000FF80
        0000FF8000FF8000FF8000FF8000FF8000FF800000FFFF00FFFF00FFFF000000
        00FFFF00000000FFFF00FFFF00FFFFFF8000FF8000FF8000FF8000FF8000FF80
        0000FF8000FF8000FF8000FF8000FF8000FF800000FFFF00FFFF00FFFF000000
        FFFFFF00000000FFFF00FFFF00FFFFFF8000FF8000FF8000FF8000FF8000FF80
        0000FF8000FF8000FF8000FF8000FF800000FFFF00FFFF00FFFF000000FFFFFF
        7F7F7FFFFFFF00000000FFFF00FFFF00FFFFFF8000FF8000FF8000FF8000FF80
        0000FF8000FF8000FF8000FF8000FF800000FFFF00FFFF000000FFFFFF00FFFF
        7F7F7F00FFFFFFFFFF00000000FFFF00FFFFFF8000FF8000FF8000FF8000FF80
        0000FF8000FF8000FF800000FFFF00FFFF00FFFF00FFFF00000000FFFFFFFFFF
        7F7F7FFFFFFF00FFFF00000000FFFF00FFFF00FFFF00FFFFFF8000FF8000FF80
        0000FF8000FF8000FF8000FF8000FF800000FFFF00FFFF000000FFFFFF00FFFF
        FFFFFF00FFFFFFFFFF00000000FFFF00FFFFFF8000FF8000FF8000FF8000FF80
        0000FF8000FF8000FF8000FF8000FF800000FFFF00FFFF00FFFF000000FFFFFF
        00FFFFFFFFFF00000000FFFF00FFFF00FFFFFF8000FF8000FF8000FF8000FF80
        0000FF8000FF8000FF8000FF8000FF8000FF800000FFFF00FFFF00FFFF000000
        00000000000000FFFF00FFFF00FFFFFF8000FF8000FF8000FF8000FF8000FF80
        0000FF8000FF8000FF8000FF8000FF8000FF800000FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFFFF8000FF8000FF8000FF8000FF8000FF80
        0000FF8000FF8000FF8000FF8000FF800000FFFFFF8000FF800000FFFF00FFFF
        00FFFF00FFFF00FFFFFF8000FF800000FFFFFF8000FF8000FF8000FF8000FF80
        0000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000
        00FFFFFF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        0000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000
        00FFFFFF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        0000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        0000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        0000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        0000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000
        FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF80
        0000}
      Visible = False
    end
    object lbConnectedServerType: TLabel
      Left = 424
      Top = 10
      Width = 63
      Height = 13
      Caption = 'NETWARE'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      Visible = False
    end
    object cbServer: TComboBox
      Left = 113
      Top = 8
      Width = 233
      Height = 21
      Hint = 
        '\\Sunucu\Payla'#351#305'm'#13#10'\\Sunucu\Volume '#13#10'x:\'#13#10'\\IP Adresi'#13#10'\\IP Adre' +
        'si:Port'
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnChange = ServerBoxChange
      OnClick = cbServerClick
      OnKeyDown = FormKeyDown
      OnKeyPress = cbServerKeyPress
    end
  end
  object Timer1: TTimer
    Interval = 5000
    OnTimer = Timer1Timer
    Left = 8
    Top = 360
  end
  object pmDisconUser: TPopupMenu
    OnPopup = pmDisconUserPopup
    Left = 56
    Top = 360
    object DisconUser: TMenuItem
      Caption = 'Kullan'#305'c'#305'n'#305'n Ba'#287'lant'#305's'#305'n'#305' Kes'
      OnClick = DisconUserClick
    end
  end
  object EditCellEditor1: TEditCellEditor
    hasElipsis = False
    Left = 112
    Top = 344
  end
end
