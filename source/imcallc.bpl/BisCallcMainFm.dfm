inherited BisCallcMainForm: TBisCallcMainForm
  Left = 403
  Top = 159
  Caption = #1050#1086#1083#1083'-'#1094#1077#1085#1090#1088
  ClientHeight = 572
  ExplicitLeft = 403
  ExplicitTop = 159
  ExplicitHeight = 599
  PixelsPerInch = 96
  TextHeight = 13
  inherited StatusBar: TStatusBar
    Top = 553
    ExplicitTop = 553
  end
  inherited ProgressBar2: TProgressBar
    TabOrder = 3
  end
  inherited ActionMainMenuBar: TActionMainMenuBar
    Height = 24
    UseSystemFont = False
    ActionManager = ActionManager
    Font.Color = clWindowText
    ExplicitHeight = 24
  end
  object ControlBar: TControlBar [4]
    Left = 0
    Top = 24
    Width = 772
    Height = 26
    Align = alTop
    AutoSize = True
    BevelEdges = []
    Color = clBtnFace
    DrawingStyle = dsGradient
    ParentBackground = False
    ParentColor = False
    TabOrder = 2
  end
  object ActionManager: TActionManager
    ActionBars = <
      item
        ActionBar = ActionMainMenuBar
      end>
    Images = ImageListMenu
    Left = 104
    Top = 152
    StyleName = 'XP Style'
    object ActionFileExit: TAction
      Caption = #1042#1099#1093#1086#1076
      Hint = #1042#1099#1093#1086#1076' '#1080#1079' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
      OnExecute = ActionFileExitExecute
    end
    object ActionWindowsCascade: TAction
      Caption = #1050#1072#1089#1082#1072#1076#1086#1084
      Hint = #1056#1072#1089#1087#1086#1083#1086#1078#1080#1090#1100' '#1086#1082#1085#1072' '#1082#1072#1089#1082#1072#1076#1086#1084
      OnExecute = ActionWindowsCascadeExecute
      OnUpdate = ActionWindowsCloseAllUpdate
    end
    object ActionWindowsVertical: TAction
      Caption = #1042#1077#1088#1090#1080#1082#1072#1083#1100#1085#1086
      Hint = #1056#1072#1089#1087#1086#1083#1086#1078#1080#1090#1100' '#1086#1082#1085#1072' '#1074#1077#1088#1090#1080#1082#1072#1083#1100#1085#1086
      OnExecute = ActionWindowsVerticalExecute
      OnUpdate = ActionWindowsCloseAllUpdate
    end
    object ActionWindowsHorizontal: TAction
      Caption = #1043#1086#1088#1080#1079#1086#1085#1090#1072#1083#1100#1085#1086
      Hint = #1056#1072#1089#1087#1086#1083#1086#1078#1080#1090#1100' '#1086#1082#1085#1072' '#1075#1086#1088#1080#1079#1086#1085#1090#1072#1083#1100#1085#1086
      OnExecute = ActionWindowsHorizontalExecute
      OnUpdate = ActionWindowsCloseAllUpdate
    end
    object ActionWindowsCloseAll: TAction
      Caption = #1047#1072#1082#1088#1099#1090#1100' '#1074#1089#1077
      Hint = #1047#1072#1082#1088#1099#1090#1100' '#1074#1089#1077' '#1086#1082#1085#1072
      OnExecute = ActionWindowsCloseAllExecute
      OnUpdate = ActionWindowsCloseAllUpdate
    end
  end
end