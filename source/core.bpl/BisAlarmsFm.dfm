inherited BisAlarmsForm: TBisAlarmsForm
  ActiveControl = Memo
  AlphaBlend = True
  AlphaBlendValue = 200
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSizeToolWin
  Caption = #1054#1087#1086#1074#1077#1097#1077#1085#1080#1077
  ClientHeight = 224
  ClientWidth = 302
  TransparentColorValue = clBtnFace
  Constraints.MaxHeight = 350
  Constraints.MaxWidth = 500
  Constraints.MinHeight = 250
  Constraints.MinWidth = 310
  FormStyle = fsStayOnTop
  OnResize = FormResize
  ExplicitWidth = 318
  ExplicitHeight = 258
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel: TBevel
    Left = 0
    Top = 56
    Width = 302
    Height = 3
    Align = alTop
    Shape = bsTopLine
    ExplicitLeft = 208
    ExplicitTop = 72
    ExplicitWidth = 50
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 205
    Width = 302
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Width = 150
      end>
  end
  object PanelCaption: TPanel
    Left = 0
    Top = 0
    Width = 302
    Height = 56
    Align = alTop
    BevelOuter = bvNone
    Color = clWindow
    ParentBackground = False
    TabOrder = 1
    DesignSize = (
      302
      56)
    object Image: TImage
      Left = 12
      Top = 12
      Width = 32
      Height = 32
      Center = True
      Transparent = True
    end
    object LabelCaption: TLabel
      Left = 53
      Top = 3
      Width = 244
      Height = 49
      Anchors = [akLeft, akTop, akRight, akBottom]
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      WordWrap = True
    end
  end
  object Memo: TMemo
    AlignWithMargins = True
    Left = 5
    Top = 64
    Width = 292
    Height = 98
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 6
    Align = alClient
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 2
    WantReturns = False
    WordWrap = False
    OnChange = MemoChange
    OnClick = MemoClick
  end
  object GridPanel: TGridPanel
    Left = 0
    Top = 168
    Width = 302
    Height = 37
    Align = alBottom
    BevelOuter = bvLowered
    ColumnCollection = <
      item
        Value = 49.358540309368950000
      end
      item
        SizeStyle = ssAbsolute
        Value = 200.000000000000000000
      end
      item
        Value = 50.641459690631050000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = PanelLeft
        Row = 0
      end
      item
        Column = 1
        Control = PanelNavigator
        Row = 0
      end
      item
        Column = 2
        Control = PanelRight
        Row = 0
      end>
    RowCollection = <
      item
        SizeStyle = ssAuto
      end>
    TabOrder = 3
    object PanelLeft: TPanel
      Left = 1
      Top = 1
      Width = 49
      Height = 41
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
    end
    object PanelNavigator: TPanel
      Left = 50
      Top = 1
      Width = 200
      Height = 41
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object LabeCounter: TLabel
        Left = 52
        Top = 11
        Width = 96
        Height = 13
        Align = alCustom
        Alignment = taCenter
        Anchors = [akLeft, akTop, akRight, akBottom]
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object BitBtnPrior: TBitBtn
        Left = 6
        Top = 5
        Width = 40
        Height = 25
        Hint = #1055#1088#1077#1076#1099#1076#1091#1097#1077#1077
        Align = alCustom
        Anchors = [akLeft, akBottom]
        Caption = '<<'
        TabOrder = 0
        OnClick = BitBtnPriorClick
      end
      object BitBtnNext: TBitBtn
        Left = 154
        Top = 5
        Width = 40
        Height = 25
        Hint = #1057#1083#1077#1076#1091#1102#1097#1077#1077
        Align = alCustom
        Anchors = [akRight, akBottom]
        Caption = '>>'
        TabOrder = 1
        OnClick = BitBtnNextClick
      end
    end
    object PanelRight: TPanel
      Left = 250
      Top = 1
      Width = 51
      Height = 41
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
    end
  end
end