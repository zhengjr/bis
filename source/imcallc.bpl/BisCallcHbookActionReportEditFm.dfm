inherited BisCallcHbookActionReportEditForm: TBisCallcHbookActionReportEditForm
  Left = 513
  Top = 212
  Caption = 'BisCallcHbookActionReportEditForm'
  ClientHeight = 126
  ClientWidth = 322
  ExplicitLeft = 513
  ExplicitTop = 212
  ExplicitWidth = 330
  ExplicitHeight = 153
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 88
    Width = 322
    ExplicitTop = 197
    ExplicitWidth = 495
    inherited ButtonOk: TButton
      Left = 145
      ExplicitLeft = 318
    end
    inherited ButtonCancel: TButton
      Left = 242
      ExplicitLeft = 415
    end
  end
  inherited PanelControls: TPanel
    Width = 322
    Height = 88
    ExplicitTop = 1
    ExplicitWidth = 424
    ExplicitHeight = 348
    object LabelAction: TLabel
      Left = 17
      Top = 13
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1077#1081#1089#1090#1074#1080#1077':'
      FocusControl = EditAction
    end
    object LabelReport: TLabel
      Left = 38
      Top = 40
      Width = 32
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1090#1095#1077#1090':'
      FocusControl = EditReport
    end
    object LabelPriority: TLabel
      Left = 23
      Top = 67
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1086#1088#1103#1076#1086#1082':'
      FocusControl = EditPriority
    end
    object EditAction: TEdit
      Left = 76
      Top = 10
      Width = 212
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
      ExplicitWidth = 168
    end
    object ButtonAction: TButton
      Left = 294
      Top = 10
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1076#1077#1081#1089#1090#1074#1080#1077
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 1
      ExplicitLeft = 250
    end
    object EditReport: TEdit
      Left = 76
      Top = 37
      Width = 212
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
      ExplicitWidth = 168
    end
    object ButtonReport: TButton
      Left = 294
      Top = 37
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1086#1090#1095#1077#1090
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 3
      ExplicitLeft = 250
    end
    object EditPriority: TEdit
      Left = 76
      Top = 64
      Width = 73
      Height = 21
      TabOrder = 4
    end
  end
end