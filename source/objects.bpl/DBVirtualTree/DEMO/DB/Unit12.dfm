object Form12: TForm12
  Left = 316
  Top = 129
  Caption = 'Form12'
  ClientHeight = 664
  ClientWidth = 905
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 24
    Top = 224
    Width = 873
    Height = 169
    BevelOuter = bvNone
    Caption = 'Panel1'
    Color = 15465214
    ParentBackground = False
    TabOrder = 0
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 39
    Width = 873
    Height = 162
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object DBNavigator1: TDBNavigator
    Left = 640
    Top = 8
    Width = 240
    Height = 25
    DataSource = DataSource1
    TabOrder = 2
  end
  object Panel2: TPanel
    Left = 24
    Top = 416
    Width = 873
    Height = 193
    BevelOuter = bvNone
    Caption = 'Panel2'
    TabOrder = 3
  end
  object CheckBox1: TCheckBox
    Left = 32
    Top = 639
    Width = 97
    Height = 17
    Caption = 'Indicator'
    TabOrder = 4
    OnClick = CheckBox1Click
  end
  object CheckBox2: TCheckBox
    Left = 152
    Top = 639
    Width = 97
    Height = 17
    Caption = 'ListView'
    TabOrder = 5
    OnClick = CheckBox2Click
  end
  object CheckBox3: TCheckBox
    Left = 248
    Top = 639
    Width = 97
    Height = 17
    Caption = 'Buttons'
    TabOrder = 6
    OnClick = CheckBox3Click
  end
  object Button1: TButton
    Left = 504
    Top = 631
    Width = 75
    Height = 25
    Caption = 'Refresh'
    TabOrder = 7
    OnClick = Button1Click
  end
  object CheckBox4: TCheckBox
    Left = 360
    Top = 639
    Width = 97
    Height = 17
    Caption = 'Numbers'
    TabOrder = 8
    OnClick = CheckBox4Click
  end
  object Edit1: TEdit
    Left = 609
    Top = 635
    Width = 121
    Height = 21
    TabOrder = 9
    Text = 'Edit1'
  end
  object Button2: TButton
    Left = 736
    Top = 632
    Width = 75
    Height = 25
    Caption = 'Post'
    TabOrder = 10
    OnClick = Button2Click
  end
  object DataSource1: TDataSource
    Left = 352
    Top = 32
  end
  object ADOConnection1: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=SQLOLEDB.1;Persist Security Info=False;User ID=sa;Initi' +
      'al Catalog=CALLCENTER;Data Source=2003s-callcent'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 352
    Top = 88
  end
  object ADOQuery1: TADOQuery
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM S_FIRMS'
      'ORDER BY PARENT_ID ASC')
    Left = 312
    Top = 144
  end
  object ImageList1: TImageList
    Left = 472
    Top = 64
    Bitmap = {
      494C010103000500040010001000FFFFFFFFFF00FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
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
      0000000000000000000000000000000000000000000000000000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000000000000000000000000000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      800080808000808080000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000FFFFFF0000FF
      FF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FF
      FF00C0C0C00000FFFF008080800000000000000000000000000080808000FFFF
      FF0000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0
      C00000FFFF00808080000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000FFFFFF00C0C0
      C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0
      C00000FFFF00C0C0C00080808000000000000000000080808000FFFFFF0000FF
      FF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FF
      FF00C0C0C000000000008080800000000000000000000000000080808000FFFF
      FF00808080008080800080808000FFFFFF00808080008080800080808000FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000FFFFFF0000FF
      FF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FF
      FF00C0C0C00000FFFF0080808000000000000000000080808000FFFFFF00C0C0
      C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0
      C00080808000000000008080800000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000FFFFFF00C0C0
      C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0
      C00000FFFF00C0C0C000808080000000000080808000FFFFFF00C0C0C00000FF
      FF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FF
      FF0000000000808080008080800000000000000000000000000080808000FFFF
      FF0080808000808080008080800080808000FFFFFF008080800080808000FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000FFFFFF0000FF
      FF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FF
      FF00C0C0C00000FFFF00808080000000000080808000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      800000000000C0C0C0008080800000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000FFFFFF00C0C0
      C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0
      C00000FFFF00C0C0C00080808000000000008080800080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      80008080800000FFFF008080800000000000000000000000000080808000FFFF
      FF00808080008080800080808000FFFFFF008080800080808000FFFFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000FFFFFF0000FF
      FF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FF
      FF00C0C0C00000FFFF0080808000000000000000000080808000FFFFFF00C0C0
      C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0
      C00000FFFF00C0C0C0008080800000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0080808000000000000000000080808000FFFFFF0000FF
      FF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF008080800000000000000000000000000080808000FFFF
      FF0080808000808080008080800080808000FFFFFF008080800080808000FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008080800000FFFF00C0C0
      C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF0080808000808080008080
      8000808080008080800080808000000000000000000080808000FFFFFF00C0C0
      C00000FFFF00C0C0C00000FFFF00C0C0C000FFFFFF0080808000808080008080
      800080808000808080008080800000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000008080800000FF
      FF00C0C0C00000FFFF00C0C0C00000FFFF008080800000000000000000000000
      000000000000000000000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080800000000000000000000000
      000000000000000000000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000808080008080800080808000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000808080008080800080808000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080000000000000000000000000000000000000000000000000000000
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
      000000000000000000000000FFFFFF00FFFFFFFFFFFF0000FFFFFFFFE0030000
      C000E000C00300008000C000C00300008000C000C003000080008000C0030000
      80008000C003000080000000C003000080000000C003000080000000C0030000
      80008000C003000080008000C003000080018001C0030000C07FC07FC0030000
      E0FFE0FFC0070000FFFFFFFFFFFF0000}
  end
  object ActionList1: TActionList
    Left = 592
    Top = 72
    object Action1: TAction
      Caption = 'Action1'
    end
  end
  object XPColorMap1: TXPColorMap
    HighlightColor = 14410210
    BtnSelectedColor = clBtnFace
    UnusedColor = 14410210
    Left = 224
    Top = 128
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DataSetProvider1'
    Left = 472
    Top = 136
  end
  object DataSetProvider1: TDataSetProvider
    DataSet = ADOQuery1
    Left = 584
    Top = 128
  end
  object ADOQuery2: TADOQuery
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM S_ACCOUNT_ROLES')
    Left = 384
    Top = 144
  end
end