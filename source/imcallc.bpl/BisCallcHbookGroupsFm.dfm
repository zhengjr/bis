inherited BisCallcHbookGroupsForm: TBisCallcHbookGroupsForm
  Left = 578
  Top = 229
  Caption = #1043#1088#1091#1087#1087#1099
  ClientHeight = 343
  ClientWidth = 412
  Constraints.MinHeight = 370
  Constraints.MinWidth = 400
  ExplicitLeft = 578
  ExplicitTop = 229
  ExplicitWidth = 420
  ExplicitHeight = 370
  PixelsPerInch = 96
  TextHeight = 13
  inherited StatusBar: TStatusBar
    Top = 324
    Width = 412
    ExplicitTop = 324
    ExplicitWidth = 392
  end
  inherited PanelFrame: TPanel
    Width = 412
    Height = 188
    ExplicitWidth = 392
    ExplicitHeight = 188
  end
  inherited PanelButton: TPanel
    Top = 286
    Width = 412
    TabOrder = 2
    ExplicitTop = 286
    ExplicitWidth = 392
    inherited ButtonOk: TButton
      Left = 236
      ExplicitLeft = 216
    end
    inherited ButtonCancel: TButton
      Left = 332
      ExplicitLeft = 312
    end
  end
  object PanelControls: TPanel [3]
    Left = 0
    Top = 188
    Width = 412
    Height = 98
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 1
    ExplicitWidth = 392
    object GroupBoxControls: TGroupBox
      Left = 3
      Top = 3
      Width = 406
      Height = 92
      Align = alClient
      Caption = ' '#1054#1087#1080#1089#1072#1085#1080#1077' '
      TabOrder = 0
      ExplicitWidth = 386
      object PanelDescription: TPanel
        Left = 2
        Top = 15
        Width = 402
        Height = 75
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 5
        TabOrder = 0
        ExplicitWidth = 382
        object DBMemoDescription: TDBMemo
          Left = 5
          Top = 5
          Width = 392
          Height = 65
          Align = alClient
          Color = clBtnFace
          DataField = 'DESCRIPTION'
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
          ExplicitWidth = 372
        end
      end
    end
  end
end