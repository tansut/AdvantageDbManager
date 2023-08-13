object fmMigTool: TfmMigTool
  Left = 374
  Top = 313
  BorderStyle = bsDialog
  Caption = 'Advantage Veri Taban'#305' D'#246'n'#252#351't'#252'r'#252'c'#252's'#252
  ClientHeight = 316
  ClientWidth = 426
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
  object pnHeader: TPanel
    Left = 0
    Top = 0
    Width = 426
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Image1: TImage
      Left = 16
      Top = 16
      Width = 16
      Height = 16
      AutoSize = True
      Picture.Data = {
        07544269746D617036030000424D360300000000000036000000280000001000
        000010000000010018000000000000030000120B0000120B0000000000000000
        0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFC0A890604830604830
        604830604830604830604830FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFC0B0A0FFFFFFFFF8F0FFE8E0F0D8C0F0D0B0604830FF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFD0B0A0FFFFFFE0C8C0
        D0C0B0C0B0A0F0D8C0604830FF00FFFF00FFFF00FFFF00FFFF00FFC0A8906048
        30604830604830D0B8A0FFFFFFFFFFFFFFFFFFFFF8F0FFE8E0604830FF00FFFF
        00FFFF00FFFF00FFFF00FFC0B0A0FFFFFFFFF8F0FFE8E0F0A890F0A880F0A070
        E09070E08860E08050D06830FF00FFFF00FFFF00FFFF00FFFF00FFD0B0A0FFFF
        FFE0C8C0D0C0B0F0A890FFC0A0FFC0A0FFB890F0A070F09860D06830FF00FFFF
        00FFFF00FFFF00FFFF00FFD0B8A0FFFFFFFFFFFFFFFFFFF0A890F0A880F0A070
        E09070E08860E08050E07840FF00FFFF00FFFF00FFFF00FFFF00FFF0A890F0A8
        80F0A070E09070E08860E08050D06830FF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFF0A890FFC0A0FFC0A0FFB890F0A070F09860D06830
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFF0A890F0A8
        80F0A070E09070E08860E08050E07840FF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFBDC3AEB06040AC9374FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFC1CAB6C08060E09870B07050AB8D6A
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFBFCD
        BCE09870F0B8A0F0A880E09870B06840AA9473FF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFCCC6B5E09870F0C8B0F0C8B0F0B8A0F0A890E09060
        B06840A99372FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFF0A880F0B0
        90F0B090F0A890E0A080E0A080E09870D08060B068409FA18BFF00FFFF00FFFF
        00FF}
      Transparent = True
    end
    object Label1: TLabel
      Left = 43
      Top = 19
      Width = 176
      Height = 14
      Caption = 'Advantage Veri Alma Arac'#305
      Font.Charset = TURKISH_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object pnMain: TPanel
    Left = 0
    Top = 49
    Width = 426
    Height = 226
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object nbPages: TNotebook
      Left = 0
      Top = 0
      Width = 426
      Height = 226
      Align = alClient
      PageIndex = 1
      TabOrder = 0
      object TPage
        Left = 0
        Top = 0
        Caption = 'selectdb'
        object pnSelectDB: TPanel
          Left = 0
          Top = 0
          Width = 426
          Height = 226
          Align = alClient
          BevelInner = bvLowered
          BevelOuter = bvNone
          TabOrder = 0
          object Label2: TLabel
            Left = 36
            Top = 42
            Width = 427
            Height = 13
            Caption = 
              'Advantage veri taban'#305'na d'#246'n'#252#351't'#252'rmek istedi'#287'iniz veri taban'#305' t'#252'r'#252 +
              'n'#252' se'#231'iniz'
          end
          object GroupBox1: TGroupBox
            Left = 36
            Top = 58
            Width = 353
            Height = 143
            TabOrder = 0
            object rbBDE: TRadioButton
              Left = 24
              Top = 17
              Width = 215
              Height = 17
              Caption = 'Borland Veri Taban'#305' Motoru (BDE)'
              Checked = True
              TabOrder = 0
              TabStop = True
              OnClick = LvTablesClear
            end
            object rbStd: TRadioButton
              Left = 24
              Top = 41
              Width = 300
              Height = 17
              Caption = 'Standart Veri Tabanlar'#305' (Dbase / Paradox / Text)'
              TabOrder = 1
              OnClick = LvTablesClear
            end
            object rbADO: TRadioButton
              Left = 24
              Top = 66
              Width = 249
              Height = 17
              Caption = 'ADO Veri Tabanlar'#305
              TabOrder = 2
              OnClick = LvTablesClear
            end
            object rbOracle: TRadioButton
              Left = 24
              Top = 90
              Width = 249
              Height = 17
              Caption = 'Oracle Veri Taban'#305
              TabOrder = 3
              OnClick = LvTablesClear
            end
            object rbXML: TRadioButton
              Left = 24
              Top = 115
              Width = 249
              Height = 17
              Caption = 'XML'
              TabOrder = 4
              OnClick = LvTablesClear
            end
          end
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'tables'
        object pnTables: TPanel
          Left = 0
          Top = 56
          Width = 426
          Height = 170
          Align = alBottom
          BevelInner = bvLowered
          BevelOuter = bvNone
          TabOrder = 0
          object Label4: TLabel
            Left = 18
            Top = 8
            Width = 233
            Height = 13
            Caption = 'D'#246'n'#252#351't'#252'rmek istedi'#287'iniz tablolar'#305' se'#231'iniz.'
          end
          object BtSelectAll: TSpeedButton
            Left = 394
            Top = 103
            Width = 24
            Height = 25
            Cursor = crHandPoint
            Hint = 'T'#252'm'#252'n'#252' Se'#231
            Flat = True
            Glyph.Data = {
              0A040000424D0A04000000000000420000002800000016000000160000000100
              100003000000C8030000100B0000100B00000000000000000000007C0000E003
              00001F000000524A292521042104210421042104210421042104210421042104
              21042104210421040000000000000821524A4A29D65A5A6B7B6F7B6F7B6F7B6F
              7B6F7B6F5A6B5A6B5A6B5A6B5A6B5A6B3967396739675A6B7B6F945229254208
              5A6B9646F329F325F225D225D225D121B121B021B021901D8F1D8F1D8F1D6E1D
              6E1D6E1912367B6F0000630C7B6F142A132AF325F225D225D225D125B121B021
              B0218F218F1D8F1D6E1D6E1D6E196D196E1D5A6B0000630C7B6F142E132A132A
              F325F225D225D225553A964696469646D1258F1D8F1D6E1D6E196E196E1D3967
              2104630C7B6F342E142A142A132AF325F2257C6BFF7FFF7FFF7FD852553E9021
              8F1D8F1D6E1D6E1D6E1D39672104630C7B6F352E342E142A142A132A5B67FF7F
              FF7FFF7FFF7FBD739646B12590218F1D8F1D6E1D8F1D3967210484109C73352E
              352E342E142A5B67FF7FFF7FFF7F9C73FF7FFF7FD74E3336B02190218F1D8F1D
              8F1D5A6B210484109C735632352E352E7B67FF7FFF7FFF7F7546D02DFF7FFF7F
              5B679646D125B02190218F1D8F1D5A6B210484109C73563256323A5FFF7FFF7F
              FF7FB74AD2254C19BD73FF7FFF7FD84E3436B021B021B021B0215A6B21048410
              9C735636D1257B6BFF7FFF7FD74A142A142A6D1D7446FF7FFF7F5B67B74AB121
              B021B021B0215A6B21048410BD777736B0251236B64E9746352E342E142AB125
              4C19BD73FF7FFF7FB74A3432B121B121B1215A6B21048410BD7777363532F229
              132E5632352E352E342E142A6D1D7546FF7FFF7F3B639646D125B121D1215A6B
              21048410BD77973A77367736563256325632352E352E342ED125AF25FF7FFF7F
              DE77B74A3436D125D1257B6F21048410BD77983A773677367736563256325632
              352E352E142A6D1DD752FF7FFF7F5B639746D225D2257B6F21048410BD77983A
              983A973677367736563656325632352E352EB025AF25FF7FFF7FDE77B74A132E
              D2257B6F21048410DE7BB93E983A983A783A77367736563656325632352E142E
              6D1D195FFF7FFF7F19579642F3257B6F21048410DE7BB93EB93E983A983A783A
              77367736563656325632352EB021F131FF7FFF7F9C6BF329F3257B6F21048410
              DE7BB942B93EB93E983A983A783A77367736563656325632142A6D1D6D1D8F21
              142A132A132A9C7321048410FF7F3B57D942B93EB93E983A983A983A77367736
              7636563256325532352E352E342E142A96467B6F21046B2D1863FF7FDE7BDE7B
              DE7BDE7BBD77BD77BD77BD779C739C739C739C739C737B6F7B6F7B6F9C73D65A
              AD35F75EEF3D8410841084108410841084108410841084108410841084108410
              630C630C630C630C4208EF3DF75E}
            Margin = 0
            OnClick = BtSelectAllClick
          end
          object BtDeselectAll: TSpeedButton
            Left = 394
            Top = 135
            Width = 24
            Height = 25
            Cursor = crHandPoint
            Hint = 'Hi'#231'birini Se'#231'me'
            Flat = True
            Glyph.Data = {
              0E060000424D0E06000000000000360000002800000016000000160000000100
              180000000000D8050000100B0000100B000000000000000000009797974A4948
              0B0A090F0E0D12110E1815111C19131E1A15211D16231D16211D161E1A131B18
              1214130E100E0C0E0D0A09090605050404040402020240404097979700005656
              56B3B2B1D6D5D2DFDCD9DAD7D1D8D3CCD5CEC4D2CABECFC6B8CDC3B5CCC3B5CD
              C4B6CDC5BACDC7BDCECAC4CFCCC7CFCDCBD0CFCED3D3D3DEDEDEA2A2A2494949
              0000131211D5D4D1B5A388A081529F81519F8051A18154A18255A18255A18255
              9F82549C7F52977A4F91764B8A6F468369417B623C775E3A72593592836EDEDE
              DE02020200001E1D1BDBD8D3A68757A38656A38556A58657A78859A98A5BA98B
              5CAA8B5DA98B5CA7895AA385589D805394784D8A6F4680683F79603A725B3872
              5936D2D2D20404040000272420D8D4CCA9895AA88A5AAA8B5BAC8D5DAE8E5EB0
              9061B19162B49566B59769B59769B5976BAB8D5FA18356967A4FEFEBE5A08C6F
              786039765D39D0D0D006060500002F2A25D6CFC3AD8E5EAD8D5DB49667E2D6C2
              E0D3C0B39565B69768B69768B69768B79869B69768B49567AF9265F9F7F4FFFF
              FFECE8E17E65407A623BD0CECE0707050000373128D4CBBCB09160BA9C6FE0D2
              BCFCFBFAFFFFFFDAC9B0B59567B59565B59565B59565B59666B9996EFBF9F7FF
              FFFFFFFFFFFFFFFF866A4480663FD0CFCC09090700003F382DD2C6B4B29362B3
              9364C5AA82FFFFFFFFFFFFFFFFFFDDCFB9B59565B59565B59565BD9F74FBFAF7
              FFFFFFFFFFFFFFFFFFE1D9CC8C7149856B43D1CDC90C0B080000463D31D0C2AC
              B49464B39363B59565C1A57CFFFFFFFFFFFFFDFDFDE0D2BDB59566BD9F74FCFB
              F9FFFFFFFFFFFFFFFFFFE4DACB9F815593764C8A6F46D0CDC70F0E0B00004D43
              34CEBFA6B49564B59564B79869B69768C0A57CFFFFFFFFFFFFFEFDFDE3D9C7FA
              F7F4FFFFFFFFFFFFFFFFFFE4D8C7AE8E60A5875A9A7D5090754BD1CBC314120E
              00004F4535CEBEA4B59665B09162B79869B69667B69666BDA176FFFFFFFFFFFF
              FFFEFEF3EEE6FCFBF9FFFFFFE4D9C7B69666B09061A98A5B9F8154967A4DCFC9
              BF1916110000504636CFBFA5B79767AF9162B49465B59565B59565B59565C6AE
              8AFFFFFFFFFFFFFFFFFFF5F1EADECFBAB69666B69666B39465AC8D5EA385589C
              7E51CFC5B9211D1600004D4435D2C3AAB79867B49464B49464B59565B59565C8
              AF8CFEFDFCEFE8DFFEFDFCFFFFFFFFFFFFE7DDCEB69669B69768B59668AF8F60
              A88A5BA08456CEC2B22B251A0000484033D7C9B5BA9A6AB79767B69665B59565
              C8AF8CFEFDFCFFFFFFFFFFFFF0EAE0FAF8F5FFFFFFFFFFFFECE4D8B8986AB696
              67B39466AD8D5EA68859CBBDAA332B1E0000413A30DDD2C3BD9D6DBA9969B898
              67CCB594FEFEFDFFFFFFFFFFFFFFFFFFDDCEB8B99C70F3EEE7FFFFFFFFFFFFED
              E5D8B79768B59667B09060AA8A5BC9BBA43A312300003A352EE4DCD1C1A171BD
              9D6BD1BC9BFEFEFDFFFFFFFFFFFFFFFFFFD9C9B1B39363B39363B89C71F2ECE3
              FFFFFFFFFFFFEEE7DDB59768B29364AC8C5DC9B9A13F35260000332F2AEBE5DE
              C6A675C2A271FFFFFFFFFFFFFFFFFFFFFFFFDBCBB3B59565B49464B39363B393
              63B99B70EDE5DAFFFFFFFFFFFFE5DCD0BDA27AAD8E5ECABAA23E342600002D2B
              29F0EEE9CAAA78C7A676F3EDE2FFFEFEFFFFFFDBC9AEBA9A69B89868B59565B4
              9463B49464B19263B99D72E8DFD2FFFFFFFFFFFFCFC2AFAC8D5DCCBDA73B3224
              0000282726F5F3F1CFAE7FCBAA78CBAB7DF7F2EADECCB1C19F6FBC9C6CBA9A69
              B79767B59565B49564B29263B09162B69A6FE4DBCED1C5B4A3875CAB8C5CD1C5
              B2342D200000201F1FF9F9F7DFC8ABD0B081CCAC7CD6BE9AC7A776C4A372C1A0
              70BD9E6DBA9A6AB79767B69666B49565B49464B49464B39363B29262AF8F5FB6
              9E7AD1C8B92822190000585757C3C2C2FAF9F9F7F6F5F4F4F3F3F2F1F2F0EEEF
              EDEBEBEAE5E7E3DDE2DBD2DAD0C2D3C5B1CCBBA1C7B496C5B092C6B194C8B79C
              CDBFAAD7CCBDB3ACA27370690000BDBDBD7F7F7F1E1E1E252525262626272626
              2625252725252827262B29253430293D362D483F325347375D4F3B5F503B5D4F
              3B534735453C2E312B21807B75B9B7B30000}
            Margin = 0
            OnClick = BtDeselectAllClick
          end
          object LvTables: TAdvListView
            Left = 19
            Top = 24
            Width = 366
            Height = 137
            Columns = <
              item
                Caption = 'gec'
                Width = 1
              end
              item
                Caption = 'D'#246'n'#252#351't'#252'r'
                MaxWidth = 60
                MinWidth = 60
                Width = 60
              end
              item
                Caption = 'Tablo Ad'#305
                MaxWidth = 283
                MinWidth = 283
                Width = 283
              end>
            ColumnClick = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            GridLines = True
            HoverTime = -1
            OwnerDraw = True
            ReadOnly = True
            RowSelect = True
            ParentFont = False
            SmallImages = ImgSmall
            TabOrder = 0
            ViewStyle = vsReport
            OnMouseDown = LvTablesMouseDown
            AutoHint = False
            ClipboardEnable = False
            ColumnSize.Save = False
            ColumnSize.Stretch = False
            ColumnSize.Storage = stInifile
            FilterTimeOut = 500
            PrintSettings.FooterSize = 0
            PrintSettings.HeaderSize = 0
            PrintSettings.Time = ppNone
            PrintSettings.Date = ppNone
            PrintSettings.DateFormat = 'dd/mm/yyyy'
            PrintSettings.PageNr = ppNone
            PrintSettings.Title = ppNone
            PrintSettings.Font.Charset = DEFAULT_CHARSET
            PrintSettings.Font.Color = clWindowText
            PrintSettings.Font.Height = -11
            PrintSettings.Font.Name = 'MS Sans Serif'
            PrintSettings.Font.Style = []
            PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
            PrintSettings.HeaderFont.Color = clWindowText
            PrintSettings.HeaderFont.Height = -11
            PrintSettings.HeaderFont.Name = 'MS Sans Serif'
            PrintSettings.HeaderFont.Style = []
            PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
            PrintSettings.FooterFont.Color = clWindowText
            PrintSettings.FooterFont.Height = -11
            PrintSettings.FooterFont.Name = 'MS Sans Serif'
            PrintSettings.FooterFont.Style = []
            PrintSettings.Borders = pbNoborder
            PrintSettings.BorderStyle = psSolid
            PrintSettings.Centered = False
            PrintSettings.RepeatHeaders = False
            PrintSettings.LeftSize = 0
            PrintSettings.RightSize = 0
            PrintSettings.ColumnSpacing = 0
            PrintSettings.RowSpacing = 0
            PrintSettings.Orientation = poPortrait
            PrintSettings.FixedWidth = 0
            PrintSettings.FixedHeight = 0
            PrintSettings.UseFixedHeight = False
            PrintSettings.UseFixedWidth = False
            PrintSettings.FitToPage = fpNever
            PrintSettings.PageNumSep = '/'
            HTMLHint = False
            HTMLSettings.Width = 100
            HeaderHotTrack = False
            HeaderDragDrop = False
            HeaderFlatStyle = False
            HeaderOwnerDraw = True
            HeaderHeight = 13
            HeaderFont.Charset = DEFAULT_CHARSET
            HeaderFont.Color = clWindowText
            HeaderFont.Height = -11
            HeaderFont.Name = 'MS Sans Serif'
            HeaderFont.Style = []
            SelectionRTFKeep = False
            ScrollHint = False
            SelectionColor = clHighlight
            SelectionTextColor = clHighlightText
            SizeWithForm = False
            SortDirection = sdAscending
            SortShow = True
            SortIndicator = siLeft
            SubImages = True
            SubItemEdit = False
            SubItemSelect = False
            VAlignment = vtaCenter
            ItemHeight = 20
            SaveHeader = False
            LoadHeader = False
            ReArrangeItems = False
            DetailView.Visible = False
            DetailView.Column = 0
            DetailView.Font.Charset = DEFAULT_CHARSET
            DetailView.Font.Color = clBlue
            DetailView.Font.Height = -11
            DetailView.Font.Name = 'MS Sans Serif'
            DetailView.Font.Style = []
            DetailView.Height = 16
            DetailView.Indent = 0
            DetailView.SplitLine = False
          end
        end
        object nbOpenDB: TNotebook
          Left = 0
          Top = 0
          Width = 426
          Height = 56
          Align = alClient
          PageIndex = 1
          TabOrder = 1
          object TPage
            Left = 0
            Top = 0
            Caption = 'Alias'
            object pnAlias: TPanel
              Left = 0
              Top = 0
              Width = 426
              Height = 56
              Align = alClient
              BevelInner = bvLowered
              BevelOuter = bvNone
              TabOrder = 0
              object Label5: TLabel
                Left = 104
                Top = 8
                Width = 254
                Height = 13
                Caption = 'D'#246'n'#252#351't'#252'rmek istedi'#287'iniz veri taban'#305'n'#305' se'#231'iniz'
              end
              object cbAlias: TComboBox
                Left = 104
                Top = 24
                Width = 201
                Height = 21
                Style = csDropDownList
                ItemHeight = 0
                TabOrder = 0
                OnChange = cbAliasChange
              end
            end
          end
          object TPage
            Left = 0
            Top = 0
            Caption = 'Path'
            object pnPath: TPanel
              Left = 0
              Top = 0
              Width = 426
              Height = 56
              Align = alClient
              BevelInner = bvLowered
              BevelOuter = bvNone
              TabOrder = 0
              object lbStdXML: TLabel
                Left = 64
                Top = 8
                Width = 357
                Height = 13
                Caption = 'D'#246'n'#252#351't'#252'rmek istedi'#287'iniz veri taban'#305'n'#305'n bulundu'#287'u dizini se'#231'iniz'
              end
              object dirDB: TDirectoryEdit
                Left = 97
                Top = 24
                Width = 232
                Height = 21
                NumGlyphs = 1
                TabOrder = 0
                OnChange = dirDBChange
              end
            end
          end
          object TPage
            Left = 0
            Top = 0
            Caption = 'ADO'
            object pnADO: TPanel
              Left = 0
              Top = 0
              Width = 426
              Height = 56
              Align = alClient
              BevelInner = bvLowered
              BevelOuter = bvNone
              TabOrder = 0
              object Label10: TLabel
                Left = 40
                Top = 8
                Width = 418
                Height = 13
                Caption = 
                  'D'#246'n'#252#351't'#252'rmek istedi'#287'iniz veri taban'#305' i'#231'in ADO Ba'#287'lant'#305' dizinini o' +
                  'lu'#351'turunuz'
              end
              object edADOConn: TComboEdit
                Left = 54
                Top = 27
                Width = 313
                Height = 22
                ButtonHint = 'Olu'#351'tur'
                DirectInput = False
                Glyph.Data = {
                  36050000424D3605000000000000360400002800000010000000100000000100
                  080000000000000100000000000000000000000100000001000000000000355B
                  3500344D34007AAD7A0079AC79003B4E3B0082A88200787E7800028205000585
                  0A001C5F1F00205C23002F72320009A2120008870F002F5832003B643E000B8B
                  17000FA81D0024792C000F8E1D001A7724002870300015AE2900129124001187
                  2100236B2C00478F5000159429002B963D001AB335001BB4370017972E002399
                  3A002AA141001A99330020B9400021BA42002DAC460030B04A0021BA430034B7
                  51003FBA5A0026BF4C0027C04D0027C04E0028B14B0044CD670046CF69002CC5
                  57002CC558002BBA540047D6700053E27C002DC65A0033C6600032CB630031C7
                  610031C6600033CC650035CE68003AD36D0040D9730041DA740042D8720046DF
                  790047DD77004CE57F0051EA840052EB850057F08A005CF58F0062FB95007C7C
                  7C007474740067676700616161005E5E5E005959590053535300525252000000
                  0000000000000000000000000000000000000000000000000000000000000000
                  0000000000000000000000000000000000000000000000000000000000000000
                  0000000000000000000000000000000000000000000000000000000000000000
                  0000000000000000000000000000000000000000000000000000000000000000
                  0000000000000000000000000000000000000000000000000000000000000000
                  0000000000000000000000000000000000000000000000000000000000000000
                  0000000000000000000000000000000000000000000000000000000000000000
                  0000000000000000000000000000000000000000000000000000000000000000
                  0000000000000000000000000000000000000000000000000000000000000000
                  0000000000000000000000000000000000000000000000000000000000000000
                  0000000000000000000000000000000000000000000000000000000000000000
                  0000000000000000000000000000000000000000000000000000000000000000
                  0000000000000000000000000000000000000000000000000000000000000000
                  0000000000000000000000000000000000000000000000000000000000000000
                  0000000000000000000000000000000000000000000000000000000000000000
                  0000000000000000000000000000000000000000000000000000000000000000
                  0000000000000000000000000000000000000000000000000000000000000000
                  0000000000000000000000000000000000000000000000000000000000000000
                  0000000000000000000000000000000000000000000000000000000000000000
                  0000000000000000000000000000000000000000000000000000000000000000
                  0000000000000000000000000000000000000000000000000000000000000000
                  0000000000000000000000000000000000000000000000000000484848484848
                  4848484848484848484848484848484848484A4A484848484848484848484848
                  48482A0F4E484848484848484848484848482F350F4C48484848484848494848
                  4848294830024E484848484819104E484806404748134E484848484823330B50
                  491D454647274E48484848481C38330A153F434546264C48484848481C363833
                  393F41434522484848484848182B36383C3D3F413F1648484848484811252B36
                  383C3D3F21484848484848480E1E252B36383C2E054848484848484809171E25
                  2B3138391A504848484848480912171E252B313839164E4848484848080D1217
                  1E252B3138391B48484848480903030303030303030303484848}
                NumGlyphs = 1
                TabOrder = 0
                OnButtonClick = edADOConnButtonClick
                OnChange = edADOConnChange
              end
            end
          end
          object TPage
            Left = 0
            Top = 0
            Caption = 'Oracle'
            object pnOracle: TPanel
              Left = 0
              Top = 0
              Width = 426
              Height = 56
              Align = alClient
              BevelInner = bvLowered
              BevelOuter = bvNone
              TabOrder = 0
              object Label11: TLabel
                Left = 64
                Top = 8
                Width = 322
                Height = 13
                Caption = 'D'#246'n'#252#351't'#252'rmek istedi'#287'iniz Oracle veri taban'#305'na ba'#287'lan'#305'n'#305'z.'
              end
              object btnOraConn: TButton
                Left = 160
                Top = 25
                Width = 75
                Height = 24
                Caption = 'Ba'#287'lan'
                TabOrder = 0
                OnClick = btnOraConnClick
              end
            end
          end
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'seladvdb'
        object pnSelAdvDB: TPanel
          Left = 0
          Top = 0
          Width = 426
          Height = 226
          Align = alClient
          BevelInner = bvLowered
          BevelOuter = bvNone
          TabOrder = 0
          object Label7: TLabel
            Left = 28
            Top = 32
            Width = 409
            Height = 13
            Caption = 
              'D'#246'n'#252#351't'#252'rece'#287'iniz verileri ekleyece'#287'iniz Advantage Veri Taban'#305'n'#305' ' +
              'se'#231'iniz'
          end
          object cbAdvAlias: TComboBox
            Left = 80
            Top = 99
            Width = 233
            Height = 21
            Style = csDropDownList
            ItemHeight = 0
            TabOrder = 0
            OnChange = cbAdvAliasChange
          end
          object rbAlias: TRadioButton
            Left = 120
            Top = 69
            Width = 65
            Height = 17
            Caption = 'Rumuz'
            Checked = True
            TabOrder = 1
            TabStop = True
            OnClick = rbAliasClick
          end
          object rbPath: TRadioButton
            Left = 208
            Top = 69
            Width = 65
            Height = 17
            Caption = 'Dizin'
            TabOrder = 2
            OnClick = rbPathClick
          end
          object edAdvPath: TFilenameEdit
            Left = 80
            Top = 99
            Width = 233
            Height = 21
            Filter = 'Advantage Veri S'#246'zl'#252'k Dosyalar'#305'|*.add'
            DirectInput = False
            NumGlyphs = 1
            TabOrder = 3
            Visible = False
            OnChange = edAdvPathChange
          end
          object btnNewDB: TButton
            Left = 136
            Top = 136
            Width = 135
            Height = 25
            Caption = 'Yeni Veri Taban'#305' Yarat'
            TabOrder = 4
            OnClick = btnNewDBClick
          end
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'migrate'
        object pnMigrate: TPanel
          Left = 0
          Top = 0
          Width = 426
          Height = 226
          Align = alClient
          BevelInner = bvLowered
          BevelOuter = bvNone
          TabOrder = 0
          object Label8: TLabel
            Left = 96
            Top = 8
            Width = 276
            Height = 13
            Caption = 'Advantage Tablolar'#305'n'#305'n yarat'#305'laca'#287#305' dizini se'#231'iniz'
          end
          object dirAdvTable: TDirectoryEdit
            Left = 96
            Top = 32
            Width = 232
            Height = 21
            NumGlyphs = 1
            TabOrder = 0
          end
          object GroupBox2: TGroupBox
            Left = 96
            Top = 64
            Width = 233
            Height = 121
            Caption = 'D'#246'n'#252#351't'#252'rme '#350'ekli'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            object rbMigAll: TRadioButton
              Left = 16
              Top = 29
              Width = 185
              Height = 17
              Caption = 'Tablo yap'#305'lar'#305'n'#305' ve verileri aktar'
              Checked = True
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              TabStop = True
            end
            object rbMigTable: TRadioButton
              Left = 16
              Top = 46
              Width = 185
              Height = 17
              Caption = 'Sadece tablo yap'#305'lar'#305'n'#305' aktar'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
            end
            object rbMigData: TRadioButton
              Left = 16
              Top = 64
              Width = 209
              Height = 17
              Caption = 'Sadece verileri var olan tabloya aktar'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 2
            end
            object chkIndex: TCheckBox
              Left = 16
              Top = 94
              Width = 97
              Height = 17
              Caption = #304'ndexleri yarat'
              Checked = True
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              State = cbChecked
              TabOrder = 3
            end
          end
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'status'
        object pnStatus: TPanel
          Left = 0
          Top = 0
          Width = 426
          Height = 226
          Align = alClient
          BevelInner = bvLowered
          BevelOuter = bvNone
          TabOrder = 0
          object lblAck: TLabel
            Left = 20
            Top = 11
            Width = 264
            Height = 16
            Caption = 'D'#246'n'#252#351't'#252'rme i'#351'lemi ger'#231'ekle'#351'tiriliyor ...'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label9: TLabel
            Left = 20
            Top = 128
            Width = 120
            Height = 13
            Caption = 'D'#246'n'#252#351't'#252'rme Durumu'
          end
          object lblCustom: TLabel
            Left = 20
            Top = 168
            Width = 4
            Height = 13
          end
          object pbAll: TProgressBar
            Left = 20
            Top = 144
            Width = 385
            Height = 17
            Min = 0
            Max = 100
            TabOrder = 0
          end
          object pbCustom: TProgressBar
            Left = 20
            Top = 184
            Width = 385
            Height = 17
            Min = 0
            Max = 100
            TabOrder = 1
          end
          object lvStatus: TListView
            Left = 20
            Top = 29
            Width = 385
            Height = 97
            Columns = <
              item
                Caption = 'Yap'#305'lan '#304#351'lemler'
                MaxWidth = 380
                MinWidth = 380
                Width = 380
              end>
            ReadOnly = True
            SmallImages = ilStatus
            TabOrder = 2
            ViewStyle = vsReport
          end
        end
      end
    end
  end
  object pnFooter: TPanel
    Left = 0
    Top = 275
    Width = 426
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object btnNext: TButton
      Left = 352
      Top = 8
      Width = 65
      Height = 25
      Caption = #304'leri  >>'
      TabOrder = 0
      OnClick = btnNextClick
    end
    object btnPrev: TButton
      Left = 280
      Top = 8
      Width = 65
      Height = 25
      Caption = '<<  Geri'
      TabOrder = 1
      Visible = False
      OnClick = btnPrevClick
    end
    object btnClose: TButton
      Left = 8
      Top = 8
      Width = 65
      Height = 25
      Cancel = True
      Caption = 'Kapat'
      TabOrder = 2
      OnClick = btnCloseClick
    end
    object btnHelp: TButton
      Left = 82
      Top = 8
      Width = 65
      Height = 25
      Caption = 'Yard'#305'm'
      TabOrder = 3
      OnClick = btnHelpClick
    end
  end
  object SessionBDE: TSession
    SessionName = 'SessionBDE'
    Left = 168
    Top = 200
  end
  object AdvDictionary: TAdsDictionary
    AdsServerTypes = []
    IsConnected = False
    LoginPrompt = True
    Left = 240
    Top = 200
  end
  object BDETable: TTable
    SessionName = 'SessionBDE'
    Left = 184
    Top = 200
  end
  object AdvTable: TAdsTable
    StoreActive = True
    AdsConnection = AdsConn
    Left = 272
    Top = 200
  end
  object AdsConn: TAdsConnection
    IsConnected = False
    AdsServerTypes = []
    LoginPrompt = True
    Compression = ccAdsCompressionNotSet
    Left = 256
    Top = 200
  end
  object ilStatus: TImageList
    Left = 344
    Top = 56
    Bitmap = {
      494C010103000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000006300000031000000630000003100008484840084848400848484008484
      8400848484008484840084848400848484000000000000000000000000000000
      000000000000000000000000000000000000846B5A008C6B5A00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000636363006363
      6300000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000031
      00000063000000CE0000009C0000006300000031000084848400848484008484
      8400848484008484840084848400848484000000000000000000000000000000
      0000000000000000000000000000946B4A00CE9C6B00AD7B4A00846B5A000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006363CE000000FF003131
      9C00636363000000000000000000000000000000000000000000000000000000
      00006363CE003100CE0000000000000000000000000000000000006300000063
      000000CE0000009C000000CE0000009C0000009C000000310000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000946B4A00CEAD8400FFF7C60094634200846B5A000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006363FF000000CE000000
      FF00313163006363630000000000000000000000000000000000000000003131
      CE000000CE006331CE00000000000000000000000000000000000031000000CE
      0000009C0000009C0000009C000000CE0000009C000000310000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000947363008C634A00E7CEAD00FFDEB500FFDEB500AD846300522908006B42
      3100846B5A000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000009C63FF003100
      CE006331FF0063636300000000000000000000000000000000003131CE003100
      CE006363CE00000000000000000000000000000000000031000000CE0000009C
      000000FF000000FF000000CE0000009C0000009C000000630000006300000000
      0000000000000000000000000000000000000000000000000000BDA59C00BDA5
      9C00D6B59C00E7CEAD00FFE7C600FFEFC600FFFFD600FFD6B500DEBD9400AD8C
      63005A291000846B5A0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006363
      FF003100CE006331CE006363630000000000000000003131CE000000CE006331
      CE00000000000000000000000000000000000000000000310000009C0000009C
      000063FF630000FF0000009C000000CE0000009C0000009C0000003100000000
      00000000000000000000000000000000000000000000CEB5A500EFDEC600EFDE
      C600FFEFCE00FFDEB500C6734A00EF946300DE8C5A00DEA57B00FFE7C600FFD6
      B500D6B59400734229008C6B6300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00009C63FF003100CE006331CE00636363003131CE003100CE006363CE000000
      00000000000000000000000000000000000000630000009C000000CE000063FF
      630000FF000000FF000000630000009C000000CE0000009C0000009C00000031
      000000000000000000000000000000000000CEBDA500EFDEC600EFDEC600FFF7
      D600FFEFCE00FFFFE700B58463007B0000008C290000F7E7C600FFEFCE00FFE7
      C600FFD6B500DEBD9C005A291000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000006363FF000000CE003100CE000000CE0063639C00000000000000
      0000000000000000000000000000000000000031000000FF000000FF00009CFF
      9C0063FF6300003100000000000000310000009C0000009C0000009C00000031
      000000000000000000000000000000000000C6B5A500EFDEC600FFF7D600FFF7
      D600FFE7CE00FFFFF700CEB594006B000000A55A310000000000FFE7CE00FFE7
      C600FFEFCE00FFE7C600AD8C6B0094736B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000003131FF003100CE006331CE0063639C00000000000000
      000000000000000000000000000000000000000000000031000000FF000000FF
      00009CFF9C0000310000000000000031000000CE0000009C0000009C0000009C
      000000630000000000000000000000000000CEBDAD00FFEFD600FFF7DE00FFF7
      D600FFF7D60000000000CEAD940073000000A552310000000000FFEFCE00FFE7
      CE00FFEFCE00FFEFD600E7CEAD008C6B5A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000003131CE000000CE006331CE003100CE006331CE00636363000000
      0000000000000000000000000000000000000000000000000000003100000031
      0000003100000000000000000000000000000031000000CE0000009C000000CE
      000000310000000000000000000000000000CEC6B500FFF7E700FFF7EF00FFEF
      DE00FFF7DE0000000000D6C6AD0073000000A55A310000000000FFF7D600FFEF
      D600FFF7D600FFF7DE00EFDEC600846B5A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00003131CE003100CE006363CE0000000000000000003100CE006331FF006363
      9C00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000630000009C000000CE0000009C
      0000009C0000003100000000000000000000D6C6BD00FFFFEF00FFFFEF00FFF7
      E700FFFFF700EFE7DE008C391800630000008C39210000000000FFF7DE00FFEF
      D600FFEFDE00FFFFE700F7DECE00947B73000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000003131
      CE000000CE006331CE00000000000000000000000000000000003131CE000000
      FF00633163000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000310000009C0000009C
      0000009C0000003100000000000000000000DED6CE00F7F7EF0000000000FFFF
      EF0000000000E7DECE00B5948400BDA59C00C6ADA50000000000FFF7EF00FFEF
      DE00FFFFEF0000000000E7CEB500947B73000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000003131CE003100
      CE006363CE000000000000000000000000000000000000000000000000006331
      CE000000FF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000031000000CE0000009C
      00009CFF9C0000FF0000006300000000000000000000E7E7E700000000000000
      0000FFFFF7000000000000000000FFCEA500FFFFF70000000000FFFFEF00FFFF
      EF000000000000000000AD948400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000003131FF000000CE003131
      CE00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000003100009CFF
      9C0000FF000000FF0000003100000000000000000000F7EFE700EFEFEF000000
      000000000000000000008C524A005A0000009C42290000000000000000000000
      000000000000D6BDAD0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000003100CE006331FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000063000000FF
      000000FF00000031000000630000000000000000000000000000F7EFE700FFF7
      F7000000000000000000D6CECE0063424200C6B5AD0000000000000000000000
      0000EFDED6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000031
      0000003100000031000000000000000000000000000000000000000000000000
      0000EFE7DE00F7F7EF00000000000000000000000000FFFFF700DECEC6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFF000FF3F0000CFFFE000FE1F0000
      87F3C03FFC1F000083E3C03FF0070000C3C7801FC0030000E18F801F80010000
      F01F000F00010000F83F020F00400000FC3F820704400000F81FC70704400000
      F18FFF0300400000E3C7FF8328440000C7E7FF81B64D00008FFFFFC19C7B0000
      9FFFFFC1CC770000FFFFFFE3F39F000000000000000000000000000000000000
      000000000000}
  end
  object ADOConn: TADOConnection
    LoginPrompt = False
    Left = 48
    Top = 160
  end
  object ADOTable: TADOTable
    Connection = ADOConn
    Left = 80
    Top = 160
  end
  object OraSession: TOracleSession
    Cursor = crHourGlass
    DesignConnection = False
    ConnectAs = caNormal
    ThreadSafe = False
    Preferences.FloatPrecision = 0
    Preferences.IntegerPrecision = 0
    Preferences.SmallIntPrecision = -1
    Preferences.UseOCI7 = False
    Preferences.ConvertCRLF = True
    Preferences.TrimStringFields = True
    Preferences.MaxStringFieldSize = 0
    Preferences.ZeroDateIsNull = True
    Preferences.NullLOBIsEmpty = False
    Pooling = spNone
    MTSOptions = [moImplicit, moUniqueServer]
    Connected = False
    RollbackOnDisconnect = False
    NullValue = nvUnAssigned
    SQLTrace = stUnchanged
    OptimizerGoal = ogUnchanged
    IsolationLevel = ilUnchanged
    BytesPerCharacter = bc1Byte
    Left = 48
    Top = 200
  end
  object OraLogon: TOracleLogon
    Session = OraSession
    Retries = 2
    Options = [ldAuto, ldDatabase, ldDatabaseList]
    AliasDropDownCount = 8
    HistorySize = 6
    HistoryWithPassword = False
    Caption = 'Oracle Veritaban'#305' Ba'#287'lant'#305's'#305
    Left = 48
    Top = 360
  end
  object OraQuery: TOracleQuery
    Session = OraSession
    ReadBuffer = 25
    Optimize = True
    Debug = False
    Cursor = crDefault
    StringFieldsOnly = False
    Threaded = False
    ThreadSynchronized = True
    Left = 72
    Top = 200
  end
  object OraDataSet: TOracleDataSet
    ReadBuffer = 25
    Optimize = True
    Debug = False
    StringFieldsOnly = False
    SequenceField.ApplyMoment = amOnPost
    OracleDictionary.EnforceConstraints = False
    OracleDictionary.UseMessageTable = False
    OracleDictionary.DefaultValues = False
    OracleDictionary.DynamicDefaults = False
    OracleDictionary.FieldKinds = False
    OracleDictionary.DisplayFormats = False
    OracleDictionary.RangeValues = False
    OracleDictionary.RequiredFields = True
    QBEDefinition.SaveQBEValues = True
    QBEDefinition.AllowFileWildCards = True
    QBEDefinition.QBEFontColor = clNone
    QBEDefinition.QBEBackgroundColor = clNone
    Cursor = crDefault
    ReadOnly = False
    LockingMode = lmCheckImmediate
    QueryAllRecords = True
    CountAllRecords = False
    RefreshOptions = []
    CommitOnPost = True
    CachedUpdates = False
    QBEMode = False
    Session = OraSession
    DesignActivation = False
    Active = False
    Left = 120
    Top = 160
  end
  object ImgSmall: TImageList
    Left = 379
    Top = 72
    Bitmap = {
      494C010103000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000006300000031000000630000003100008484840084848400848484008484
      8400848484008484840084848400848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000636363006363
      6300000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000031
      00000063000000CE0000009C0000006300000031000084848400848484008484
      8400848484008484840084848400848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008C8C8C00948C8C00948C
      8C00948C8C00948C8C00948C8C00948C8C00948C8C00948C8C00948C8C008C8C
      8C008C8C8C008C8C8C008C8C8C0000000000000000006363CE000000FF003131
      9C00636363000000000000000000000000000000000000000000000000000000
      00006363CE003100CE0000000000000000000000000000000000006300000063
      000000CE0000009C000000CE0000009C0000009C000000310000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B56B4200B56B4200B56B
      4200C67B3100C67B3100C67B3100C67B3100C67B3100C67B3100C67B3100C67B
      3100C67B3100D69473007342290000000000000000006363FF000000CE000000
      FF00313163006363630000000000000000000000000000000000000000003131
      CE000000CE006331CE00000000000000000000000000000000000031000000CE
      0000009C0000009C0000009C000000CE0000009C000000310000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7D69C00CEDEE700CEDE
      E700CEDEE700CEDEE700CEDEE700CEDEE700CEDEE700CEDEE700CEDEE700CEDE
      E700CEDEE700CEDEE700947B6B000000000000000000000000009C63FF003100
      CE006331FF0063636300000000000000000000000000000000003131CE003100
      CE006363CE00000000000000000000000000000000000031000000CE0000009C
      000000FF000000FF000000CE0000009C0000009C000000630000006300000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EFBD8C00CEEFFF00DEF7
      FF00DEF7FF00DEF7FF00DEF7FF00DEF7FF00DEF7FF00DEF7FF00DEF7FF00DEF7
      FF00DEF7FF00CEDEE70094736300000000000000000000000000000000006363
      FF003100CE006331CE006363630000000000000000003131CE000000CE006331
      CE00000000000000000000000000000000000000000000310000009C0000009C
      000063FF630000FF0000009C000000CE0000009C0000009C0000003100000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E7BD8400CEEFFF00948C
      8C00A5ADB500948C8C00A5ADB500948C8C00A5ADB500948C8C00A5ADB500948C
      8C00A5ADB500CEDEE70094736300000000000000000000000000000000000000
      00009C63FF003100CE006331CE00636363003131CE003100CE006363CE000000
      00000000000000000000000000000000000000630000009C000000CE000063FF
      630000FF000000FF000000630000009C000000CE0000009C0000009C00000031
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E7BD8400D6F7FF00DEF7
      FF00DEF7FF00DEF7FF00DEF7FF00DEF7FF00DEF7FF00DEF7FF00DEF7FF00DEF7
      FF00DEF7FF00C6D6DE0094736300000000000000000000000000000000000000
      0000000000006363FF000000CE003100CE000000CE0063639C00000000000000
      0000000000000000000000000000000000000031000000FF000000FF00009CFF
      9C0063FF6300003100000000000000310000009C0000009C0000009C00000031
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E7BD8400D6F7FF00948C
      8C00A5ADB500948C8C00A5ADB500948C8C00A5ADB500948C8C00A5ADB500948C
      8C00A5ADB500F7FFFF0094735A00000000000000000000000000000000000000
      000000000000000000003131FF003100CE006331CE0063639C00000000000000
      000000000000000000000000000000000000000000000031000000FF000000FF
      00009CFF9C0000310000000000000031000000CE0000009C0000009C0000009C
      0000006300000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EFC68C00D6F7FF00DEF7
      FF00DEF7FF00DEF7FF00DEF7FF00DEF7FF00DEF7FF00DEF7FF00DEF7FF00DEF7
      FF00DEF7FF000000000094735200000000000000000000000000000000000000
      0000000000003131CE000000CE006331CE003100CE006331CE00636363000000
      0000000000000000000000000000000000000000000000000000003100000031
      0000003100000000000000000000000000000031000000CE0000009C000000CE
      0000003100000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EFC68C00D6F7FF00948C
      8C00A5ADB500948C8C00A5ADB500948C8C00A5ADB500948C8C00A5ADB500948C
      8C00A5ADB5000000000094735A00000000000000000000000000000000000000
      00003131CE003100CE006363CE0000000000000000003100CE006331FF006363
      9C00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000630000009C000000CE0000009C
      0000009C00000031000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EFC69400DEFFFF00D6EF
      F700D6EFF700D6EFF700D6EFF700D6F7FF00DEF7FF00DEF7FF00DEF7FF00DEF7
      FF00DEF7F7000000000094735A00000000000000000000000000000000003131
      CE000000CE006331CE00000000000000000000000000000000003131CE000000
      FF00633163000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000310000009C0000009C
      0000009C00000031000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BD6B1800BD732100BD73
      2100BD732100BD732100BD732100BD732100BD732100BD732100C67B3100C67B
      2900BD7B3100A5846B00845218000000000000000000000000003131CE003100
      CE006363CE000000000000000000000000000000000000000000000000006331
      CE000000FF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000031000000CE0000009C
      00009CFF9C0000FF000000630000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E7841000E7841800E784
      1000E7841000E77B0800E7841000E7841000E77B0800E77B0000E7841000EF84
      1000E7841800CE844A00AD8C630000000000000000003131FF000000CE003131
      CE00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000003100009CFF
      9C0000FF000000FF000000310000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000003100CE006331FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000063000000FF
      000000FF00000031000000630000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000031
      0000003100000031000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFF0000000FFFFCFFFE0000000
      800187F3C03F0000800183E3C03F00008001C3C7801F00008001E18F801F0000
      8001F01F000F00008001F83F020F00008001FC3F820700008005F81FC7070000
      8005F18FFF0300008005E3C7FF8300008001C7E7FF81000080018FFFFFC10000
      FFFF9FFFFFC10000FFFFFFFFFFE3000000000000000000000000000000000000
      000000000000}
  end
  object csXML: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 136
    Top = 40
  end
end
