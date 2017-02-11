inherited BisCallcHbookDealEditForm: TBisCallcHbookDealEditForm
  Left = 440
  Top = 228
  Caption = 'BisCallcHbookDealEditForm'
  ClientHeight = 372
  ClientWidth = 593
  ExplicitLeft = 440
  ExplicitTop = 228
  ExplicitWidth = 601
  ExplicitHeight = 399
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 334
    Width = 593
    ExplicitTop = 130
    ExplicitWidth = 297
    inherited ButtonOk: TButton
      Left = 416
      ExplicitLeft = 120
    end
    inherited ButtonCancel: TButton
      Left = 513
      ExplicitLeft = 217
    end
  end
  inherited PanelControls: TPanel
    Width = 593
    Height = 334
    ExplicitTop = -6
    ExplicitWidth = 593
    ExplicitHeight = 335
    object LabelDealNum: TLabel
      Left = 31
      Top = 16
      Width = 64
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1086#1084#1077#1088' '#1076#1077#1083#1072':'
      FocusControl = EditDealNum
    end
    object LabelDebtor: TLabel
      Left = 45
      Top = 43
      Width = 50
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1086#1083#1078#1085#1080#1082':'
      FocusControl = EditDebtor
    end
    object LabelDateIssue: TLabel
      Left = 411
      Top = 16
      Width = 79
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072' '#1087#1077#1088#1077#1076#1072#1095#1080':'
      FocusControl = DateTimePickerIssue
    end
    object LabelAccountNum: TLabel
      Left = 27
      Top = 97
      Width = 68
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1086#1084#1077#1088' '#1089#1095#1077#1090#1072':'
      FocusControl = EditAccountNum
    end
    object LabelArrearPeriod: TLabel
      Left = 352
      Top = 97
      Width = 41
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1077#1088#1080#1086#1076':'
      FocusControl = EditArrearPeriod
    end
    object LabelInitialDebt: TLabel
      Left = 461
      Top = 97
      Width = 29
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1086#1083#1075':'
      FocusControl = EditInitialDebt
    end
    object LabelDateClose: TLabel
      Left = 411
      Top = 309
      Width = 81
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1044#1072#1090#1072' '#1079#1072#1082#1088#1099#1090#1080#1103':'
      FocusControl = DateTimePickerClose
    end
    object LabelAgreement: TLabel
      Left = 188
      Top = 16
      Width = 91
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1086#1075#1086#1074#1086#1088' '#1082#1083#1080#1077#1085#1090#1072':'
      FocusControl = EditAgreement
    end
    object LabelPlan: TLabel
      Left = 396
      Top = 70
      Width = 29
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1083#1072#1085':'
      FocusControl = EditPlan
    end
    object LabelGroup: TLabel
      Left = 387
      Top = 43
      Width = 38
      Height = 13
      Alignment = taRightJustify
      Caption = #1043#1088#1091#1087#1087#1072':'
      FocusControl = EditGroup
    end
    object LabelDebtInformation: TLabel
      Left = 26
      Top = 124
      Width = 69
      Height = 26
      Alignment = taRightJustify
      Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1076#1086#1083#1075#1091':'
      WordWrap = True
    end
    object LabelGuarantors: TLabel
      Left = 33
      Top = 229
      Width = 62
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1055#1086#1088#1091#1095#1080#1090#1077#1083#1080':'
      FocusControl = MemoGuarantors
    end
    object LabelDebtorNum: TLabel
      Left = 8
      Top = 70
      Width = 87
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1086#1084#1077#1088' '#1076#1086#1075#1086#1074#1086#1088#1072':'
      FocusControl = EditDebtorNum
    end
    object LabelDebtorDate: TLabel
      Left = 202
      Top = 70
      Width = 79
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072' '#1076#1086#1075#1086#1074#1086#1088#1072':'
      FocusControl = DateTimePickerDebtorDate
    end
    object EditDealNum: TEdit
      Left = 101
      Top = 13
      Width = 79
      Height = 21
      TabOrder = 0
    end
    object EditDebtor: TEdit
      Left = 101
      Top = 40
      Width = 247
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 4
    end
    object ButtonDebtor: TButton
      Left = 354
      Top = 40
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1076#1086#1083#1078#1085#1080#1082#1072
      Caption = '...'
      TabOrder = 5
    end
    object DateTimePickerIssue: TDateTimePicker
      Left = 496
      Top = 13
      Width = 88
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 3
    end
    object EditAccountNum: TEdit
      Left = 101
      Top = 94
      Width = 235
      Height = 21
      TabOrder = 12
    end
    object EditArrearPeriod: TEdit
      Left = 399
      Top = 94
      Width = 49
      Height = 21
      TabOrder = 13
    end
    object EditInitialDebt: TEdit
      Left = 496
      Top = 94
      Width = 88
      Height = 21
      TabOrder = 14
    end
    object DateTimePickerClose: TDateTimePicker
      Left = 498
      Top = 306
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Checked = False
      TabOrder = 17
    end
    object EditAgreement: TEdit
      Left = 285
      Top = 13
      Width = 91
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 1
    end
    object ButtonAgreement: TButton
      Left = 382
      Top = 13
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1076#1086#1075#1086#1074#1086#1088
      Caption = '...'
      TabOrder = 2
    end
    object EditPlan: TEdit
      Left = 431
      Top = 67
      Width = 126
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 10
    end
    object ButtonPlan: TButton
      Left = 563
      Top = 67
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1083#1072#1085
      Caption = '...'
      TabOrder = 11
    end
    object EditGroup: TEdit
      Left = 431
      Top = 40
      Width = 126
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 6
    end
    object ButtonGroup: TButton
      Left = 563
      Top = 40
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1075#1088#1091#1087#1087#1091
      Caption = '...'
      TabOrder = 7
    end
    object MemoDebtInformation: TMemo
      Left = 101
      Top = 121
      Width = 483
      Height = 99
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssVertical
      TabOrder = 15
    end
    object MemoGuarantors: TMemo
      Left = 101
      Top = 226
      Width = 483
      Height = 74
      Anchors = [akLeft, akRight, akBottom]
      ScrollBars = ssVertical
      TabOrder = 16
    end
    object EditDebtorNum: TEdit
      Left = 101
      Top = 67
      Width = 90
      Height = 21
      TabOrder = 8
    end
    object DateTimePickerDebtorDate: TDateTimePicker
      Left = 287
      Top = 67
      Width = 88
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Checked = False
      TabOrder = 9
    end
  end
end