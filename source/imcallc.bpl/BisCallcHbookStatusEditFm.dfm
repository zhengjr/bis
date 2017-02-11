inherited BisCallcHbookStatusEditForm: TBisCallcHbookStatusEditForm
  Left = 513
  Top = 212
  Caption = 'BisCallcHbookStatusEditForm'
  ClientHeight = 295
  ClientWidth = 316
  ExplicitLeft = 513
  ExplicitTop = 212
  ExplicitWidth = 324
  ExplicitHeight = 322
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 257
    Width = 316
    ExplicitTop = 253
    ExplicitWidth = 316
    inherited ButtonOk: TButton
      Left = 139
      ExplicitLeft = 120
    end
    inherited ButtonCancel: TButton
      Left = 236
      ExplicitLeft = 217
    end
  end
  inherited PanelControls: TPanel
    Width = 316
    Height = 257
    ExplicitLeft = 8
    ExplicitTop = 1
    ExplicitWidth = 316
    ExplicitHeight = 310
    object LabelName: TLabel
      Left = 11
      Top = 16
      Width = 79
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
      FocusControl = EditName
    end
    object LabelDescription: TLabel
      Left = 37
      Top = 43
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      FocusControl = MemoDescription
    end
    object LabelPriority: TLabel
      Left = 43
      Top = 229
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1055#1086#1088#1103#1076#1086#1082':'
      FocusControl = EditPriority
    end
    object LabelCondition: TLabel
      Left = 43
      Top = 149
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Caption = #1059#1089#1083#1086#1074#1080#1077':'
      FocusControl = MemoCondition
    end
    object LabelTableName: TLabel
      Left = 44
      Top = 122
      Width = 46
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1072#1073#1083#1080#1094#1072':'
      FocusControl = EditTableName
    end
    object EditName: TEdit
      Left = 96
      Top = 13
      Width = 209
      Height = 21
      TabOrder = 0
    end
    object MemoDescription: TMemo
      Left = 96
      Top = 40
      Width = 209
      Height = 73
      TabOrder = 1
    end
    object EditPriority: TEdit
      Left = 96
      Top = 226
      Width = 73
      Height = 21
      Anchors = [akLeft, akBottom]
      TabOrder = 4
    end
    object MemoCondition: TMemo
      Left = 96
      Top = 146
      Width = 209
      Height = 74
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssVertical
      TabOrder = 3
    end
    object EditTableName: TEdit
      Left = 96
      Top = 119
      Width = 209
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Constraints.MaxWidth = 300
      TabOrder = 2
    end
  end
end