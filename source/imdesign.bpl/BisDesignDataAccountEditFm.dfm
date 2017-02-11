inherited BisDesignDataAccountEditForm: TBisDesignDataAccountEditForm
  Left = 0
  Top = 255
  Caption = 'BisDesignDataAccountEditForm'
  ClientHeight = 454
  ClientWidth = 549
  ExplicitWidth = 557
  ExplicitHeight = 488
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 416
    Width = 549
    ExplicitTop = 416
    ExplicitWidth = 549
    inherited ButtonOk: TButton
      Left = 369
      ExplicitLeft = 369
    end
    inherited ButtonCancel: TButton
      Left = 466
      ExplicitLeft = 466
    end
  end
  inherited PanelControls: TPanel
    Width = 549
    Height = 416
    ExplicitWidth = 549
    ExplicitHeight = 416
    object LabelUserName: TLabel
      Left = 46
      Top = 13
      Width = 34
      Height = 13
      Alignment = taRightJustify
      Caption = #1051#1086#1075#1080#1085':'
      FocusControl = EditUserName
    end
    object LabelDescription: TLabel
      Left = 15
      Top = 213
      Width = 65
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077':'
      FocusControl = MemoDescription
      ExplicitTop = 229
    end
    object LabelPassword: TLabel
      Left = 39
      Top = 40
      Width = 41
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1072#1088#1086#1083#1100':'
      FocusControl = EditPassword
    end
    object LabelSurname: TLabel
      Left = 32
      Top = 186
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1060#1072#1084#1080#1083#1080#1103':'
      FocusControl = EditSurname
      ExplicitTop = 202
    end
    object LabelName: TLabel
      Left = 211
      Top = 186
      Width = 23
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1048#1084#1103':'
      FocusControl = EditName
      ExplicitTop = 202
    end
    object LabelPatronymic: TLabel
      Left = 349
      Top = 186
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1054#1090#1095#1077#1089#1090#1074#1086':'
      FocusControl = EditPatronymic
      ExplicitTop = 202
    end
    object LabelPhone: TLabel
      Left = 32
      Top = 269
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1058#1077#1083#1077#1092#1086#1085':'
      FocusControl = EditPhone
      ExplicitTop = 285
    end
    object LabelEmail: TLabel
      Left = 354
      Top = 269
      Width = 35
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1055#1086#1095#1090#1072':'
      FocusControl = EditEmail
      ExplicitTop = 285
    end
    object LabelFirm: TLabel
      Left = 10
      Top = 296
      Width = 70
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103':'
      FocusControl = EditFirm
      ExplicitTop = 312
    end
    object LabelDateCreate: TLabel
      Left = 14
      Top = 323
      Width = 66
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076'-'#1103':'
      FocusControl = DateTimePickerCreate
      ExplicitTop = 338
    end
    object LabelJobTitle: TLabel
      Left = 328
      Top = 296
      Width = 61
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100':'
      FocusControl = EditJobTitle
      ExplicitTop = 312
    end
    object LabelPhoneInternal: TLabel
      Left = 202
      Top = 269
      Width = 64
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1042#1085#1091#1090#1088#1077#1085#1085#1080#1081':'
      FocusControl = EditPhoneInternal
      ExplicitTop = 285
    end
    object LabelRoles: TLabel
      Left = 51
      Top = 64
      Width = 28
      Height = 13
      Alignment = taRightJustify
      Caption = #1056#1086#1083#1080':'
      FocusControl = CheckListBoxRoles
    end
    object EditUserName: TEdit
      Left = 86
      Top = 10
      Width = 195
      Height = 21
      TabOrder = 0
    end
    object MemoDescription: TMemo
      Left = 86
      Top = 210
      Width = 454
      Height = 50
      Anchors = [akLeft, akRight, akBottom]
      ScrollBars = ssVertical
      TabOrder = 8
    end
    object EditPassword: TEdit
      Left = 86
      Top = 37
      Width = 195
      Height = 21
      PasswordChar = '*'
      TabOrder = 1
    end
    object EditSurname: TEdit
      Left = 86
      Top = 183
      Width = 116
      Height = 21
      Anchors = [akLeft, akBottom]
      TabOrder = 5
    end
    object EditName: TEdit
      Left = 240
      Top = 183
      Width = 100
      Height = 21
      Anchors = [akLeft, akBottom]
      TabOrder = 6
    end
    object EditPatronymic: TEdit
      Left = 408
      Top = 183
      Width = 132
      Height = 21
      Anchors = [akLeft, akRight, akBottom]
      TabOrder = 7
    end
    object EditPhone: TEdit
      Left = 86
      Top = 266
      Width = 107
      Height = 21
      Anchors = [akLeft, akBottom]
      TabOrder = 9
    end
    object EditEmail: TEdit
      Left = 395
      Top = 266
      Width = 145
      Height = 21
      Anchors = [akLeft, akRight, akBottom]
      Constraints.MaxHeight = 300
      TabOrder = 11
    end
    object EditFirm: TEdit
      Left = 86
      Top = 293
      Width = 204
      Height = 21
      Anchors = [akLeft, akBottom]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 12
    end
    object ButtonFirm: TButton
      Left = 296
      Top = 293
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1102
      Anchors = [akLeft, akBottom]
      Caption = '...'
      TabOrder = 13
    end
    object CheckBoxProfile: TCheckBox
      Left = 266
      Top = 322
      Width = 253
      Height = 17
      Hint = #1057#1086#1079#1076#1072#1090#1100' '#1087#1088#1086#1092#1080#1083#1100' '#1076#1083#1103' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1103
      Anchors = [akLeft, akBottom]
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1087#1088#1086#1092#1080#1083#1100' '#1076#1083#1103' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1103
      Checked = True
      State = cbChecked
      TabOrder = 17
      OnClick = CheckBoxProfileClick
    end
    object GroupBoxDB: TGroupBox
      Left = 328
      Top = 47
      Width = 154
      Height = 54
      Anchors = [akTop, akRight]
      Caption = ' '#1041#1072#1079#1072' '#1076#1072#1085#1085#1099#1093' '
      Enabled = False
      TabOrder = 3
      Visible = False
      object LabelDbUserName: TLabel
        Left = 22
        Top = 21
        Width = 93
        Height = 13
        Alignment = taRightJustify
        Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' '#1041#1044':'
        Enabled = False
        FocusControl = EditDbUserName
      end
      object LabelDbPassword: TLabel
        Left = 57
        Top = 48
        Width = 58
        Height = 13
        Alignment = taRightJustify
        Caption = #1055#1072#1088#1086#1083#1100' '#1041#1044':'
        Enabled = False
        FocusControl = EditDbPassword
      end
      object EditDbUserName: TEdit
        Left = 121
        Top = 18
        Width = 116
        Height = 21
        Color = clBtnFace
        Enabled = False
        TabOrder = 0
      end
      object EditDbPassword: TEdit
        Left = 121
        Top = 45
        Width = 116
        Height = 21
        Color = clBtnFace
        Enabled = False
        PasswordChar = '*'
        TabOrder = 1
      end
    end
    object DateTimePickerCreate: TDateTimePicker
      Left = 86
      Top = 320
      Width = 88
      Height = 21
      Anchors = [akLeft, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Checked = False
      TabOrder = 15
    end
    object DateTimePickerCreateTime: TDateTimePicker
      Left = 180
      Top = 320
      Width = 74
      Height = 21
      Anchors = [akLeft, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 16
    end
    object PanelPhoto: TPanel
      Left = 287
      Top = 10
      Width = 253
      Height = 167
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelOuter = bvNone
      Caption = #1053#1077#1090' '#1092#1086#1090#1086#1075#1088#1072#1092#1080#1080
      Color = clWindow
      ParentBackground = False
      TabOrder = 4
      DesignSize = (
        253
        167)
      object ShapePhoto: TShape
        Left = 0
        Top = 0
        Width = 253
        Height = 167
        Align = alClient
        Brush.Style = bsClear
        Pen.Style = psDot
        ExplicitWidth = 189
        ExplicitHeight = 132
      end
      object ImagePhoto: TImage
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 247
        Height = 161
        Align = alClient
        Center = True
        PopupMenu = PopupActionBarPhoto
        Proportional = True
        Stretch = True
        ExplicitLeft = 0
        ExplicitTop = -80
        ExplicitWidth = 181
        ExplicitHeight = 131
      end
      object ButtonPhoto: TButton
        Left = 171
        Top = 135
        Width = 75
        Height = 25
        Hint = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1092#1086#1090#1086#1075#1088#1072#1092#1080#1077#1081
        Anchors = [akRight, akBottom]
        Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077
        TabOrder = 0
        OnClick = ButtonPhotoClick
      end
    end
    object EditJobTitle: TEdit
      Left = 395
      Top = 293
      Width = 145
      Height = 21
      Anchors = [akLeft, akRight, akBottom]
      Constraints.MaxHeight = 300
      TabOrder = 14
    end
    object EditPhoneInternal: TEdit
      Left = 272
      Top = 266
      Width = 73
      Height = 21
      Anchors = [akLeft, akBottom]
      TabOrder = 10
    end
    object GroupBoxLock: TGroupBox
      Left = 86
      Top = 347
      Width = 453
      Height = 52
      Anchors = [akLeft, akRight, akBottom]
      Caption = '                              '
      TabOrder = 18
      DesignSize = (
        453
        52)
      object LabelDateLock: TLabel
        Left = 19
        Top = 23
        Width = 30
        Height = 13
        Alignment = taRightJustify
        Caption = #1044#1072#1090#1072':'
        Enabled = False
        FocusControl = DateTimePickerLock
      end
      object LabelReasonLock: TLabel
        Left = 232
        Top = 23
        Width = 47
        Height = 13
        Alignment = taRightJustify
        Caption = #1055#1088#1080#1095#1080#1085#1072':'
        Enabled = False
        FocusControl = EditReasonLock
      end
      object CheckBoxLocked: TCheckBox
        Left = 13
        Top = 0
        Width = 87
        Height = 17
        Caption = #1041#1083#1086#1082#1080#1088#1086#1074#1082#1072
        TabOrder = 0
        OnClick = CheckBoxLockedClick
      end
      object DateTimePickerLock: TDateTimePicker
        Left = 55
        Top = 20
        Width = 88
        Height = 21
        Date = 39507.457070671300000000
        Time = 39507.457070671300000000
        Checked = False
        Enabled = False
        TabOrder = 1
      end
      object DateTimePickerLockTime: TDateTimePicker
        Left = 149
        Top = 20
        Width = 74
        Height = 21
        Date = 39507.457070671300000000
        Time = 39507.457070671300000000
        Enabled = False
        Kind = dtkTime
        TabOrder = 2
      end
      object EditReasonLock: TEdit
        Left = 285
        Top = 20
        Width = 158
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        Enabled = False
        TabOrder = 3
      end
    end
    object CheckListBoxRoles: TCheckListBox
      Left = 86
      Top = 64
      Width = 195
      Height = 113
      Margins.Left = 5
      Margins.Right = 5
      Margins.Bottom = 5
      OnClickCheck = CheckListBoxRolesClickCheck
      Anchors = [akLeft, akTop, akBottom]
      ItemHeight = 13
      TabOrder = 2
    end
  end
  inherited ImageList: TImageList
    Left = 152
    Top = 128
  end
  object PopupActionBarPhoto: TPopupActionBar
    OnPopup = PopupActionBarPhotoPopup
    Left = 197
    Top = 72
    object MenuItemLoadPhoto: TMenuItem
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1092#1086#1090#1086#1075#1088#1072#1092#1080#1102
      OnClick = MenuItemLoadPhotoClick
    end
    object MenuItemSavePhoto: TMenuItem
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1092#1086#1090#1086#1075#1088#1072#1092#1080#1102
      OnClick = MenuItemSavePhotoClick
    end
    object MenuItemClearPhoto: TMenuItem
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1092#1086#1090#1086
      OnClick = MenuItemClearPhotoClick
    end
  end
  object OpenPictureDialog: TOpenPictureDialog
    Options = [ofEnableSizing]
    Left = 157
    Top = 72
  end
  object SavePictureDialog: TSavePictureDialog
    Options = [ofEnableSizing]
    Left = 117
    Top = 72
  end
end