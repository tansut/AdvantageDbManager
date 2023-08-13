object FmDataOperations: TFmDataOperations
  Left = 393
  Top = 216
  BorderStyle = bsDialog
  Caption = #304#351'lem Devam Ediyor ...'
  ClientHeight = 119
  ClientWidth = 262
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object pgcMain: TPageControl
    Left = 0
    Top = 0
    Width = 262
    Height = 119
    ActivePage = pgIslem
    Align = alClient
    TabOrder = 0
    object pgADTVeri: TTabSheet
      Caption = 'pgADTVeri'
      TabVisible = False
      object RzLabel1: TRzLabel
        Left = 114
        Top = 2
        Width = 24
        Height = 16
        Caption = '--->'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBtnFace
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Blinking = True
        BlinkColor = clRed
        BlinkIntervalOff = 1000
        BlinkIntervalOn = 1000
        FrameSides = []
      end
      object lbKaynak: TRzLabel
        Left = 4
        Top = 3
        Width = 101
        Height = 16
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'lbKaynak'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        BlinkIntervalOff = 1000
        BlinkIntervalOn = 1000
        FrameSides = []
        TextStyle = tsRaised
      end
      object lbHedef: TRzLabel
        Left = 142
        Top = 3
        Width = 101
        Height = 16
        AutoSize = False
        Caption = 'lbKaynak'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 8404992
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        BlinkIntervalOff = 1000
        BlinkIntervalOn = 1000
        FrameSides = []
        TextStyle = tsRaised
      end
      object AlanGrup: TRzRadioGroup
        Left = 37
        Top = 24
        Width = 183
        Height = 57
        Alignment = taCenter
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clFuchsia
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        GroupStyle = gsStandard
        ItemFont.Charset = DEFAULT_CHARSET
        ItemFont.Color = clBlue
        ItemFont.Height = -11
        ItemFont.Name = 'MS Sans Serif'
        ItemFont.Style = []
        ItemHeight = 15
        ItemIndex = 0
        Items.Strings = (
          'Alan isimlerine g'#246're e'#351'le'#351'tir'
          'Alan s'#305'ras'#305'na g'#246're e'#351'le'#351'tir')
        ParentFont = False
        TabOrder = 0
      end
      object BtAktar: TButton
        Left = 170
        Top = 87
        Width = 51
        Height = 22
        Caption = 'Aktar'
        Default = True
        TabOrder = 2
        OnClick = BtAktarClick
      end
      object btAdtCancel: TButton
        Left = 114
        Top = 87
        Width = 51
        Height = 22
        Caption = #304'ptal'
        Default = True
        TabOrder = 1
        OnClick = btAdtCancelClick
      end
    end
    object pgIslem: TTabSheet
      Caption = 'pgIslem'
      ImageIndex = 1
      TabVisible = False
      object lbmsg: TRzLabel
        Left = 16
        Top = 7
        Width = 99
        Height = 18
        Caption = 'Veri '#199#305'k'#305'l'#305'yor...'
        Font.Charset = TURKISH_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Blinking = True
        BlinkColor = clRed
        BlinkIntervalOff = 1000
        BlinkIntervalOn = 1000
        FrameSides = []
        FlyByColor = clBtnHighlight
        ShadowColor = 10930928
        ShadowDepth = 4
        TextStyle = tsRaised
      end
      object JobProgBar: TRzProgressBar
        Left = 19
        Top = 35
        Height = 17
        BorderWidth = 0
        InteriorOffset = 0
        PartsComplete = 0
        Percent = 0
        TotalParts = 0
      end
      object BtCancel: TButton
        Left = 82
        Top = 62
        Width = 55
        Height = 25
        Caption = #304'ptal Et'
        Default = True
        TabOrder = 0
        OnClick = BtCancelClick
      end
    end
  end
  object ImpFile: TOpenDialog
    DefaultExt = 'xml;avd'
    Filter = 'XML Dosya|*.xml|Advantage Veri Dosyas'#305'|*.avd'
    Left = 176
    Top = 8
  end
  object ExpFile: TSaveDialog
    DefaultExt = 'xml;avd'
    Filter = 
      'XML Dosya|*.xml|Advantage Veri Dosyas'#305'|*.avd|Advantage Tablosu|*' +
      '.ADT'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 216
    Top = 8
  end
end
