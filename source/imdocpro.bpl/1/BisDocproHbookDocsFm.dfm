inherited BisDocproHbookDocsForm: TBisDocproHbookDocsForm
  Left = 485
  Top = 245
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099
  ClientHeight = 323
  ClientWidth = 527
  ExplicitLeft = 485
  ExplicitTop = 245
  ExplicitWidth = 535
  ExplicitHeight = 350
  PixelsPerInch = 96
  TextHeight = 13
  inherited StatusBar: TStatusBar
    Top = 304
    Width = 527
    ExplicitTop = 304
    ExplicitWidth = 442
  end
  inherited PanelFrame: TPanel
    Width = 527
    Height = 184
    ExplicitWidth = 442
    ExplicitHeight = 168
  end
  inherited PanelButton: TPanel
    Top = 266
    Width = 527
    TabOrder = 2
    ExplicitTop = 266
    ExplicitWidth = 442
    inherited ButtonOk: TButton
      Left = 351
      ExplicitLeft = 266
    end
    inherited ButtonCancel: TButton
      Left = 447
      ExplicitLeft = 362
    end
  end
  object PanelControls: TPanel [3]
    Left = 0
    Top = 184
    Width = 527
    Height = 82
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 1
    ExplicitWidth = 442
    object GroupBoxControls: TGroupBox
      Left = 3
      Top = 3
      Width = 521
      Height = 76
      Align = alClient
      Caption = ' '#1054#1087#1080#1089#1072#1085#1080#1077' '
      TabOrder = 0
      ExplicitLeft = 1
      ExplicitTop = 0
      ExplicitWidth = 436
      ExplicitHeight = 92
      object PanelDescription: TPanel
        Left = 2
        Top = 15
        Width = 517
        Height = 59
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 5
        TabOrder = 0
        ExplicitWidth = 432
        ExplicitHeight = 75
        object DBMemoDescription: TDBMemo
          Left = 5
          Top = 5
          Width = 507
          Height = 49
          Align = alClient
          Color = clBtnFace
          DataField = 'DESCRIPTION'
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
          ExplicitWidth = 422
          ExplicitHeight = 65
        end
      end
    end
  end
end