inherited BisKrieltObjectsFrame: TBisKrieltObjectsFrame
  Height = 177
  ExplicitHeight = 177
  inherited PanelData: TPanel
    Height = 148
    ExplicitHeight = 148
    inherited GridPattern: TDBGrid
      Height = 117
    end
    object PanelRefresh: TPanel
      Left = 0
      Top = 117
      Width = 450
      Height = 31
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object LabelMinute: TLabel
        Left = 238
        Top = 8
        Width = 22
        Height = 13
        Caption = #1084#1080#1085'.'
        Enabled = False
      end
      object CheckBoxRefresh: TCheckBox
        Left = 7
        Top = 7
        Width = 154
        Height = 17
        Caption = #1040#1074#1090#1086#1086#1073#1085#1086#1074#1083#1077#1085#1080#1077' '#1082#1072#1078#1076#1099#1077':'
        TabOrder = 0
        OnClick = CheckBoxRefreshClick
      end
      object EditMinute: TEdit
        Left = 167
        Top = 6
        Width = 50
        Height = 21
        Enabled = False
        TabOrder = 1
        Text = '5'
      end
      object UpDownMinute: TUpDown
        Left = 217
        Top = 6
        Width = 15
        Height = 21
        Associate = EditMinute
        Enabled = False
        Min = 1
        Max = 30
        Position = 5
        TabOrder = 2
        Thousands = False
        OnChanging = UpDownMinuteChanging
      end
    end
  end
  inherited DataSource: TDataSource
    Left = 248
    Top = 56
  end
  object TimerRefresh: TTimer
    Enabled = False
    OnTimer = TimerRefreshTimer
    Left = 320
    Top = 56
  end
  object TrayIcon: TTrayIcon
    BalloonHint = #1055#1088#1086#1074#1077#1088#1100#1090#1077' '#1087#1086#1089#1090#1091#1087#1080#1074#1096#1080#1077' '#1086#1073#1098#1103#1074#1083#1077#1085#1080#1103
    BalloonTitle = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103
    BalloonFlags = bfInfo
    OnDblClick = TrayIconDblClick
    Left = 384
    Top = 56
  end
end