object FmAutoInc: TFmAutoInc
  Left = 498
  Top = 376
  BorderStyle = bsDialog
  Caption = 'Otomatik Artan Say'#305' Y'#246'netimi'
  ClientHeight = 250
  ClientWidth = 305
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
  object BtnOK: TButton
    Left = 8
    Top = 216
    Width = 75
    Height = 25
    Caption = 'Tamam'
    Default = True
    TabOrder = 0
    OnClick = BtnOKClick
  end
  object BtnCancel: TButton
    Left = 88
    Top = 216
    Width = 75
    Height = 25
    Cancel = True
    Caption = #304'ptal'
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 289
    Height = 41
    Caption = 'Tablo Ad'#305
    TabOrder = 2
    object LblTable: TLabel
      Left = 16
      Top = 18
      Width = 55
      Height = 13
      Caption = 'LblTable'
      Font.Charset = TURKISH_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 49
    Width = 289
    Height = 80
    Caption = 'Alan'
    TabOrder = 3
    object Label4: TLabel
      Left = 8
      Top = 16
      Width = 273
      Height = 28
      AutoSize = False
      Caption = 
        'Belirtilen alan otomatik artan say'#305' tipinde de'#287'ilse bu tipe d'#246'n'#252 +
        #351't'#252'r'#252'lecektir.'
      WordWrap = True
    end
    object CmbField: TComboBox
      Left = 8
      Top = 48
      Width = 145
      Height = 21
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ItemHeight = 13
      ParentFont = False
      TabOrder = 0
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 129
    Width = 289
    Height = 80
    Caption = 'De'#287'er'
    TabOrder = 4
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 273
      Height = 33
      AutoSize = False
      Caption = 'Alan'#305'n hangi de'#287'erden ba'#351'lamas'#305' gerekti'#287'ini belirtiniz.'
      WordWrap = True
    end
    object EdValue: TEdit
      Left = 8
      Top = 52
      Width = 145
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      Text = '0'
    end
  end
end
