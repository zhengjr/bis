inherited BisKrieltDataAccountSubscriptionEditForm: TBisKrieltDataAccountSubscriptionEditForm
  Left = 495
  Top = 201
  Caption = 'BisKrieltDataAccountSubscriptionEditForm'
  ClientHeight = 187
  ClientWidth = 346
  ExplicitWidth = 354
  ExplicitHeight = 221
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 149
    Width = 346
    ExplicitTop = 149
    ExplicitWidth = 346
    inherited ButtonOk: TButton
      Left = 167
      ExplicitLeft = 167
    end
    inherited ButtonCancel: TButton
      Left = 263
      ExplicitLeft = 263
    end
  end
  inherited PanelControls: TPanel
    Width = 346
    Height = 149
    ExplicitWidth = 346
    ExplicitHeight = 149
    object LabelSubscription: TLabel
      Left = 47
      Top = 13
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1086#1076#1087#1080#1089#1082#1072':'
      FocusControl = EditSubscription
    end
    object LabelAccount: TLabel
      Left = 16
      Top = 40
      Width = 84
      Height = 13
      Alignment = taRightJustify
      Caption = #1059#1095#1077#1090#1085#1072#1103' '#1079#1072#1087#1080#1089#1100':'
      FocusControl = EditAccount
    end
    object LabelAccessType: TLabel
      Left = 33
      Top = 67
      Width = 67
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1080#1087' '#1076#1086#1089#1090#1091#1087#1072':'
      FocusControl = ComboBoxAccessType
    end
    object LabelDateBegin: TLabel
      Left = 31
      Top = 94
      Width = 69
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072':'
      FocusControl = DateTimePickerBegin
    end
    object LabelDateEnd: TLabel
      Left = 13
      Top = 121
      Width = 87
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103':'
      FocusControl = DateTimePickerEnd
    end
    object EditSubscription: TEdit
      Left = 106
      Top = 10
      Width = 203
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonSubscription: TButton
      Left = 315
      Top = 10
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1086#1076#1087#1080#1089#1082#1091
      Caption = '...'
      TabOrder = 1
    end
    object EditAccount: TEdit
      Left = 106
      Top = 37
      Width = 203
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object ButtonAccount: TButton
      Left = 315
      Top = 37
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1091#1095#1077#1090#1085#1091#1102' '#1079#1072#1087#1080#1089#1100' ('#1088#1086#1083#1100')'
      Caption = '...'
      TabOrder = 3
    end
    object ComboBoxAccessType: TComboBox
      Left = 106
      Top = 64
      Width = 203
      Height = 21
      Style = csDropDownList
      ItemHeight = 0
      TabOrder = 4
    end
    object DateTimePickerBegin: TDateTimePicker
      Left = 106
      Top = 91
      Width = 88
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 5
    end
    object DateTimePickerEnd: TDateTimePicker
      Left = 106
      Top = 118
      Width = 88
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Checked = False
      TabOrder = 6
    end
  end
end