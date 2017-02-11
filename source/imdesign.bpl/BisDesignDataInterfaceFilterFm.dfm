inherited BisDesignDataInterfaceFilterForm: TBisDesignDataInterfaceFilterForm
  Left = 513
  Top = 212
  Caption = 'BisDesignDataInterfaceFilterForm'
  ClientHeight = 261
  ClientWidth = 359
  ExplicitWidth = 367
  ExplicitHeight = 295
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 223
    Width = 359
    ExplicitTop = 278
    ExplicitWidth = 369
    inherited ButtonOk: TButton
      Left = 180
      ExplicitLeft = 190
    end
    inherited ButtonCancel: TButton
      Left = 276
      ExplicitLeft = 286
    end
  end
  inherited PanelControls: TPanel
    Width = 359
    Height = 223
    ExplicitTop = -1
    ExplicitWidth = 359
    ExplicitHeight = 223
    object LabelName: TLabel
      Left = 18
      Top = 43
      Width = 77
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
      FocusControl = EditName
    end
    object LabelDescription: TLabel
      Left = 42
      Top = 70
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      FocusControl = MemoDescription
    end
    object LabelType: TLabel
      Left = 9
      Top = 16
      Width = 86
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1080#1087' '#1080#1085#1090#1077#1088#1092#1077#1081#1089#1072':'
      FocusControl = ComboBoxType
    end
    object LabelModuleName: TLabel
      Left = 52
      Top = 165
      Width = 43
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1052#1086#1076#1091#1083#1100':'
      FocusControl = ComboBoxModuleName
    end
    object LabelModuleInterface: TLabel
      Left = 35
      Top = 192
      Width = 60
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1048#1085#1090#1077#1088#1092#1077#1081#1089':'
      FocusControl = ComboBoxModuleInterface
    end
    object EditName: TEdit
      Left = 101
      Top = 40
      Width = 247
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
    end
    object MemoDescription: TMemo
      Left = 101
      Top = 67
      Width = 247
      Height = 89
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 2
    end
    object ComboBoxType: TComboBox
      Left = 101
      Top = 13
      Width = 166
      Height = 21
      Style = csDropDownList
      ItemHeight = 0
      TabOrder = 0
    end
    object ComboBoxModuleName: TComboBox
      Left = 101
      Top = 162
      Width = 247
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akRight, akBottom]
      ItemHeight = 0
      Sorted = True
      TabOrder = 3
    end
    object ComboBoxModuleInterface: TComboBox
      Left = 101
      Top = 189
      Width = 247
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akRight, akBottom]
      ItemHeight = 0
      Sorted = True
      TabOrder = 4
    end
  end
end