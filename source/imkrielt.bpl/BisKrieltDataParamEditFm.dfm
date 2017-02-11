inherited BisKrieltDataParamEditForm: TBisKrieltDataParamEditForm
  Left = 513
  Top = 212
  Caption = 'BisKrieltDataParamEditForm'
  ClientHeight = 236
  ClientWidth = 339
  ExplicitWidth = 347
  ExplicitHeight = 270
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 198
    Width = 339
    ExplicitTop = 199
    ExplicitWidth = 351
    inherited ButtonOk: TButton
      Left = 159
      ExplicitLeft = 171
    end
    inherited ButtonCancel: TButton
      Left = 256
      ExplicitLeft = 268
    end
  end
  inherited PanelControls: TPanel
    Width = 339
    Height = 198
    ExplicitWidth = 351
    ExplicitHeight = 199
    object LabelName: TLabel
      Left = 13
      Top = 16
      Width = 77
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
    object LabelParamType: TLabel
      Left = 68
      Top = 119
      Width = 22
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1058#1080#1087':'
      FocusControl = ComboBoxParamType
    end
    object LabelMaxLength: TLabel
      Left = 229
      Top = 119
      Width = 36
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1044#1083#1080#1085#1072':'
      FocusControl = EditMaxLength
    end
    object LabelSorting: TLabel
      Left = 25
      Top = 147
      Width = 65
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072':'
      FocusControl = ComboBoxSorting
    end
    object LabelDefault: TLabel
      Left = 13
      Top = 174
      Width = 77
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102':'
      FocusControl = EditDefault
    end
    object EditName: TEdit
      Left = 96
      Top = 13
      Width = 230
      Height = 21
      TabOrder = 0
    end
    object MemoDescription: TMemo
      Left = 96
      Top = 40
      Width = 230
      Height = 70
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 1
    end
    object ComboBoxParamType: TComboBox
      Left = 96
      Top = 116
      Width = 122
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akRight, akBottom]
      ItemHeight = 0
      TabOrder = 2
    end
    object EditMaxLength: TEdit
      Left = 270
      Top = 116
      Width = 56
      Height = 21
      Anchors = [akRight, akBottom]
      TabOrder = 3
    end
    object ComboBoxSorting: TComboBox
      Left = 96
      Top = 144
      Width = 122
      Height = 21
      Hint = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1087#1088#1080' '#1101#1082#1089#1087#1086#1088#1090#1077
      Style = csDropDownList
      Anchors = [akLeft, akRight, akBottom]
      ItemHeight = 13
      TabOrder = 4
      Items.Strings = (
        #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
        #1055#1086' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1102
        #1055#1086' '#1087#1086#1088#1103#1076#1082#1091)
    end
    object CheckBoxLocked: TCheckBox
      Left = 229
      Top = 147
      Width = 97
      Height = 17
      Anchors = [akRight, akBottom]
      Caption = #1047#1072#1073#1083#1086#1082#1080#1088#1086#1074#1072#1085
      TabOrder = 5
    end
    object EditDefault: TEdit
      Left = 96
      Top = 171
      Width = 230
      Height = 21
      Anchors = [akLeft, akBottom]
      TabOrder = 6
    end
  end
end