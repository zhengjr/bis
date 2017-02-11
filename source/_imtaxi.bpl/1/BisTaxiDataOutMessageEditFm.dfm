inherited BisTaxiDataOutMessageEditForm: TBisTaxiDataOutMessageEditForm
  Left = 513
  Top = 212
  Caption = 'BisTaxiDataOutMessageEditForm'
  ClientHeight = 433
  ClientWidth = 363
  ExplicitWidth = 371
  ExplicitHeight = 467
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 395
    Width = 363
    ExplicitTop = 395
    ExplicitWidth = 363
    DesignSize = (
      363
      38)
    inherited ButtonOk: TButton
      Left = 184
      ExplicitLeft = 184
    end
    inherited ButtonCancel: TButton
      Left = 280
      ExplicitLeft = 280
    end
  end
  inherited PanelControls: TPanel
    Width = 363
    Height = 395
    ExplicitWidth = 363
    ExplicitHeight = 395
    DesignSize = (
      363
      395)
    object LabelRecipient: TLabel
      Left = 15
      Top = 69
      Width = 65
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1086#1083#1091#1095#1072#1090#1077#1083#1100':'
      FocusControl = EditRecipient
    end
    object LabelDateCreate: TLabel
      Left = 96
      Top = 368
      Width = 80
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103':'
      FocusControl = DateTimePickerCreate
      ExplicitTop = 345
    end
    object LabelDateOut: TLabel
      Left = 95
      Top = 287
      Width = 81
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1044#1072#1090#1072' '#1086#1090#1087#1088#1072#1074#1082#1080':'
      FocusControl = DateTimePickerOut
    end
    object LabelType: TLabel
      Left = 58
      Top = 15
      Width = 22
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1080#1087':'
      FocusControl = ComboBoxType
      Transparent = True
    end
    object LabelContact: TLabel
      Left = 33
      Top = 96
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Caption = #1050#1086#1085#1090#1072#1082#1090':'
      FocusControl = EditContact
    end
    object LabelCreator: TLabel
      Left = 115
      Top = 314
      Width = 61
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1050#1090#1086' '#1089#1086#1079#1076#1072#1083':'
      FocusControl = EditCreator
    end
    object LabelPriority: TLabel
      Left = 21
      Top = 42
      Width = 59
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1088#1080#1086#1088#1080#1090#1077#1090':'
      FocusControl = ComboBoxPriority
      Transparent = True
    end
    object LabelDescription: TLabel
      Left = 27
      Top = 174
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      FocusControl = MemoDescription
    end
    object LabelCounter: TLabel
      Left = 74
      Top = 147
      Width = 6
      Height = 13
      Alignment = taRightJustify
      Caption = '0'
    end
    object LabelDateBegin: TLabel
      Left = 107
      Top = 233
      Width = 69
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072':'
      FocusControl = DateTimePickerBegin
    end
    object LabelDateEnd: TLabel
      Left = 89
      Top = 260
      Width = 87
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103':'
      FocusControl = DateTimePickerEnd
    end
    object LabelFirm: TLabel
      Left = 106
      Top = 341
      Width = 70
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103':'
    end
    object EditRecipient: TEdit
      Left = 86
      Top = 66
      Width = 237
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 4
    end
    object DateTimePickerCreate: TDateTimePicker
      Left = 182
      Top = 365
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 18
    end
    object DateTimePickerCreateTime: TDateTimePicker
      Left = 276
      Top = 365
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 19
    end
    object ButtonRecipient: TButton
      Left = 329
      Top = 66
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103
      Caption = '...'
      TabOrder = 5
      OnClick = ButtonRecipientClick
    end
    object DateTimePickerOut: TDateTimePicker
      Left = 182
      Top = 284
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 14
    end
    object DateTimePickerOutTime: TDateTimePicker
      Left = 276
      Top = 284
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 15
    end
    object ComboBoxType: TComboBox
      Left = 86
      Top = 12
      Width = 91
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
    object EditContact: TEdit
      Left = 86
      Top = 93
      Width = 264
      Height = 21
      MaxLength = 100
      TabOrder = 6
    end
    object EditCreator: TEdit
      Left = 182
      Top = 311
      Width = 168
      Height = 21
      Anchors = [akRight, akBottom]
      MaxLength = 100
      TabOrder = 16
    end
    object ComboBoxPriority: TComboBox
      Left = 86
      Top = 39
      Width = 123
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 3
      Items.Strings = (
        #1074#1099#1089#1086#1082#1080#1081
        #1085#1086#1088#1084#1072#1083#1100#1085#1099#1081
        #1085#1080#1079#1082#1080#1081)
    end
    object MemoDescription: TMemo
      Left = 86
      Top = 174
      Width = 264
      Height = 50
      Anchors = [akLeft, akRight, akBottom]
      TabOrder = 9
    end
    object MemoText: TMemo
      Left = 86
      Top = 120
      Width = 264
      Height = 48
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssVertical
      TabOrder = 8
      OnChange = MemoTextChange
    end
    object ButtonPattern: TButton
      Left = 14
      Top = 120
      Width = 66
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1096#1072#1073#1083#1086#1085
      Caption = #1058#1077#1082#1089#1090
      TabOrder = 7
      OnClick = ButtonPatternClick
    end
    object DateTimePickerBegin: TDateTimePicker
      Left = 182
      Top = 230
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 10
    end
    object DateTimePickerBeginTime: TDateTimePicker
      Left = 276
      Top = 230
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 11
    end
    object DateTimePickerEnd: TDateTimePicker
      Left = 182
      Top = 257
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 12
    end
    object DateTimePickerEndTime: TDateTimePicker
      Left = 276
      Top = 257
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 13
    end
    object CheckBoxDelivery: TCheckBox
      Left = 189
      Top = 14
      Width = 73
      Height = 17
      Caption = #1044#1086#1089#1090#1072#1074#1082#1072
      TabOrder = 1
    end
    object CheckBoxFlash: TCheckBox
      Left = 267
      Top = 14
      Width = 61
      Height = 17
      Caption = #1060#1083#1077#1096
      TabOrder = 2
    end
    object ComboBoxFirm: TComboBox
      Left = 182
      Top = 338
      Width = 168
      Height = 21
      Style = csDropDownList
      Anchors = [akRight, akBottom]
      ItemHeight = 13
      TabOrder = 17
    end
  end
  inherited ImageList: TImageList
    Left = 32
    Top = 216
  end
  object PopupAccount: TPopupActionBar
    OnPopup = PopupAccountPopup
    Left = 40
    Top = 288
    object MenuItemAccounts: TMenuItem
      Caption = #1059#1095#1077#1090#1085#1099#1077' '#1079#1072#1087#1080#1089#1080
      OnClick = MenuItemAccountsClick
    end
    object MenuItemDrivers: TMenuItem
      Caption = #1042#1086#1076#1080#1090#1077#1083#1080
      OnClick = MenuItemDriversClick
    end
    object MenuItemClients: TMenuItem
      Caption = #1050#1083#1080#1077#1085#1090#1099
      OnClick = MenuItemClientsClick
    end
  end
end