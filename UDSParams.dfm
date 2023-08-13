object FmQueryParams: TFmQueryParams
  Left = 304
  Top = 156
  ActiveControl = LV
  BorderStyle = bsDialog
  Caption = 'Sorgu Parametreleri'
  ClientHeight = 231
  ClientWidth = 300
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object LV: TListView
    Left = 8
    Top = 8
    Width = 281
    Height = 137
    Checkboxes = True
    Columns = <
      item
        AutoSize = True
        Caption = 'Parametre'
      end
      item
        AutoSize = True
        Caption = 'De'#287'er'
      end
      item
        AutoSize = True
        Caption = 'Veri Tipi'
      end>
    ColumnClick = False
    GridLines = True
    ReadOnly = True
    RowSelect = True
    SmallImages = ImgSmall
    TabOrder = 0
    ViewStyle = vsReport
    OnSelectItem = LVSelectItem
  end
  object edValue: TEdit
    Left = 8
    Top = 152
    Width = 185
    Height = 21
    TabOrder = 1
  end
  object CmbType: TComboBox
    Left = 200
    Top = 152
    Width = 89
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
  end
  object Button1: TButton
    Left = 8
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Tamam'
    Default = True
    ModalResult = 1
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 96
    Top = 200
    Width = 75
    Height = 25
    Cancel = True
    Caption = #304'ptal'
    ModalResult = 2
    TabOrder = 4
  end
  object Button3: TButton
    Left = 216
    Top = 200
    Width = 75
    Height = 25
    Caption = 'D'#252'zenle'
    TabOrder = 5
    OnClick = Button3Click
  end
  object ChkAutoShow: TCheckBox
    Left = 8
    Top = 176
    Width = 281
    Height = 17
    Caption = 'Parametre De'#287'erlerini Otomatik G'#246'ster'
    Checked = True
    State = cbChecked
    TabOrder = 6
  end
  object ImgSmall: TImageList
    Left = 249
    Top = 32
    Bitmap = {
      494C010101000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000008484840084848400E7E7E700000000000000
      0000000000000000000084848400848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF8C
      8C00FF8C8C0031313100313131000000000000000000000000006B6BFF006B6B
      FF000000BD000000940000000000848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF8C8C00FF8C8C00FF8C
      8C00FF8C8C003131310031313100000000006B6BFF006B6BFF006B6BFF006B6B
      FF000000BD000000BD0000009400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF8C8C00FF8C8C00FF8C
      8C00FF8C8C00313131003131310000000000003194006B6BFF006B6BFF006B6B
      FF000000BD000000BD000000BD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF8C8C00FF8C8C00FF8C
      8C00FF8C8C0031313100520000000000000000319400003194006B6BFF006B6B
      FF000000BD000000BD0000009400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF8C8C00FF8C8C00FF8C
      8C00F7F7F70031313100520000000000000000000000000000006B6BFF00F7F7
      F7000000BD000000BD0000009400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF8C8C00F7F7F700F7F7
      F700FFD6D600F7F7F700000000000000000000ADFF0000ADFF00000000006B6B
      FF00F7F7F7000000BD000000BD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7F7F700FFD6D600FFD6
      D600FFD6D6000000000000ADFF0000ADFF0000ADFF0000ADFF0000ADFF000000
      00006B6BFF00F7F7F7000000BD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFD6D600FFD6
      D6000000000000ADFF0000ADFF0000ADFF0000ADFF0000ADFF0000ADFF0000AD
      FF00000000006B6BFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFD6
      D6000000000000ADFF0000ADFF0000ADFF0000ADFF0000ADFF0000ADFF0000AD
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000ADFF0000ADFF0000ADFF00F7F7F70000ADFF0000ADFF0000AD
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000ADFF00F7F7F700F7F7F70000FFFF00F7F7F70000ADFF0000AD
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F7F7F70000FFFF0000FFFF0000FFFF0000FFFF00F7F7F70000AD
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000000000000000000000
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
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FE3C000000000000E1C2000000000000
      81010000000000008101000000000000810100000000000081C1000000000000
      83210000000000008411000000000000C80B000000000000E80F000000000000
      F80F000000000000F80F000000000000F80F000000000000FC1F000000000000
      FE7F000000000000FFFF00000000000000000000000000000000000000000000
      000000000000}
  end
end
