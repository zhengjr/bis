inherited BisKrieltDataQuestionEditForm: TBisKrieltDataQuestionEditForm
  Left = 513
  Top = 212
  Caption = 'BisKrieltDataQuestionEditForm'
  ClientHeight = 333
  ClientWidth = 431
  ExplicitWidth = 439
  ExplicitHeight = 367
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 295
    Width = 431
    ExplicitTop = 295
    ExplicitWidth = 431
    inherited ButtonOk: TButton
      Left = 252
      ExplicitLeft = 252
    end
    inherited ButtonCancel: TButton
      Left = 349
      ExplicitLeft = 349
    end
  end
  inherited PanelControls: TPanel
    Width = 431
    Height = 295
    ExplicitWidth = 431
    ExplicitHeight = 295
    object LabelConsultant: TLabel
      Left = 23
      Top = 147
      Width = 70
      Height = 13
      Alignment = taRightJustify
      Caption = #1050#1086#1085#1089#1091#1083#1100#1090#1072#1085#1090':'
      FocusControl = ComboBoxConsultant
    end
    object LabelSubject: TLabel
      Left = 65
      Top = 120
      Width = 28
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1077#1084#1072':'
    end
    object LabelDateCreate: TLabel
      Left = 13
      Top = 39
      Width = 80
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103':'
      FocusControl = DateTimePickerCreate
    end
    object LabelName: TLabel
      Left = 70
      Top = 66
      Width = 23
      Height = 13
      Alignment = taRightJustify
      Caption = #1048#1084#1103':'
      FocusControl = EditName
    end
    object LabelContact: TLabel
      Left = 46
      Top = 93
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Caption = #1050#1086#1085#1090#1072#1082#1090':'
      FocusControl = EditContact
    end
    object LabelText: TLabel
      Left = 60
      Top = 175
      Width = 33
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1077#1082#1089#1090':'
      FocusControl = MemoText
    end
    object LabelNum: TLabel
      Left = 58
      Top = 12
      Width = 35
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1086#1084#1077#1088':'
      FocusControl = EditNum
    end
    object EditSubject: TEdit
      Left = 99
      Top = 117
      Width = 208
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 5
    end
    object ButtonSubject: TButton
      Left = 313
      Top = 117
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1090#1077#1084#1091
      Caption = '...'
      TabOrder = 6
    end
    object ComboBoxConsultant: TComboBox
      Left = 99
      Top = 144
      Width = 235
      Height = 21
      Style = csDropDownList
      ItemHeight = 0
      TabOrder = 7
    end
    object DateTimePickerCreate: TDateTimePicker
      Left = 99
      Top = 36
      Width = 88
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Checked = False
      TabOrder = 1
    end
    object DateTimePickerCreateTime: TDateTimePicker
      Left = 193
      Top = 36
      Width = 74
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 2
    end
    object EditName: TEdit
      Left = 99
      Top = 63
      Width = 171
      Height = 21
      TabOrder = 3
    end
    object EditContact: TEdit
      Left = 99
      Top = 90
      Width = 208
      Height = 21
      TabOrder = 4
    end
    object MemoText: TMemo
      Left = 99
      Top = 172
      Width = 318
      Height = 116
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssVertical
      TabOrder = 8
    end
    object EditNum: TEdit
      Left = 99
      Top = 9
      Width = 88
      Height = 21
      TabOrder = 0
    end
  end
  inherited ImageList: TImageList
    Left = 304
    Top = 16
  end
end