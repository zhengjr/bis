inherited BisDBTableViewForm: TBisDBTableViewForm
  Left = 424
  Top = 218
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1090#1072#1073#1083#1080#1094
  ClientHeight = 323
  ClientWidth = 602
  Constraints.MinHeight = 350
  Constraints.MinWidth = 310
  Position = poScreenCenter
  ExplicitLeft = 424
  ExplicitTop = 218
  ExplicitWidth = 610
  ExplicitHeight = 350
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 288
    Width = 602
    TabOrder = 1
    OnClick = PanelButtonClick
    ExplicitTop = 288
    ExplicitWidth = 602
    inherited ButtonOk: TButton
      Left = 443
      Top = 6
      ModalResult = 1
      ExplicitLeft = 443
      ExplicitTop = 6
    end
    inherited ButtonCancel: TButton
      Left = 524
      Top = 6
      ExplicitLeft = 524
      ExplicitTop = 6
    end
    object ButtonLoad: TButton
      Left = 6
      Top = 6
      Width = 75
      Height = 25
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      TabOrder = 2
      OnClick = ButtonLoadClick
    end
    object ButtonSave: TButton
      Left = 88
      Top = 6
      Width = 75
      Height = 25
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      TabOrder = 3
      OnClick = ButtonSaveClick
    end
    object ButtonClear: TButton
      Left = 170
      Top = 6
      Width = 75
      Height = 25
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      TabOrder = 4
      OnClick = ButtonClearClick
    end
  end
  object PanelGrid: TPanel
    Left = 0
    Top = 0
    Width = 602
    Height = 288
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 0
    object DBGrid: TDBGrid
      Left = 3
      Top = 3
      Width = 596
      Height = 282
      Align = alClient
      DataSource = DataSource
      Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgConfirmDelete, dgCancelOnExit]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnDrawColumnCell = DBGridDrawColumnCell
    end
  end
  object DataSource: TDataSource
    Left = 64
    Top = 80
  end
  object OpenDialog: TOpenDialog
    Filter = 'All files (*.*)|*.*'
    Options = [ofEnableSizing]
    Left = 72
    Top = 160
  end
  object SaveDialog: TSaveDialog
    Filter = 'All files (*.*)|*.*'
    Options = [ofEnableSizing]
    Left = 144
    Top = 160
  end
end