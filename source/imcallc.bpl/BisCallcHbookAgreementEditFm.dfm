inherited BisCallcHbookAgreementEditForm: TBisCallcHbookAgreementEditForm
  Left = 424
  Top = 189
  Caption = 'BisCallcHbookAgreementEditForm'
  ClientHeight = 210
  ClientWidth = 295
  ExplicitLeft = 424
  ExplicitTop = 189
  ExplicitWidth = 303
  ExplicitHeight = 237
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 172
    Width = 295
    ExplicitTop = 172
    ExplicitWidth = 295
    inherited ButtonOk: TButton
      Left = 118
      ExplicitLeft = 118
    end
    inherited ButtonCancel: TButton
      Left = 215
      ExplicitLeft = 215
    end
  end
  inherited PanelControls: TPanel
    Width = 295
    Height = 172
    ExplicitWidth = 295
    ExplicitHeight = 172
    object LabelNum: TLabel
      Left = 62
      Top = 39
      Width = 37
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1086#1084#1077#1088':'
      FocusControl = EditNum
    end
    object LabelFirm: TLabel
      Left = 29
      Top = 66
      Width = 70
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103':'
      FocusControl = EditFirm
    end
    object LabelParent: TLabel
      Left = 48
      Top = 12
      Width = 51
      Height = 13
      Alignment = taRightJustify
      Caption = #1056#1086#1076#1080#1090#1077#1083#1100':'
      FocusControl = EditParent
    end
    object LabelVariant: TLabel
      Left = 11
      Top = 93
      Width = 88
      Height = 13
      Alignment = taRightJustify
      Caption = #1042#1072#1088#1080#1072#1085#1090' '#1088#1072#1089#1095#1077#1090#1072':'
      FocusControl = EditVariant
    end
    object LabelDateBegin: TLabel
      Left = 99
      Top = 120
      Width = 67
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072':'
      FocusControl = DateTimePickerBegin
    end
    object LabelDateEnd: TLabel
      Left = 81
      Top = 147
      Width = 85
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103':'
      FocusControl = DateTimePickerEnd
    end
    object EditNum: TEdit
      Left = 105
      Top = 36
      Width = 182
      Height = 21
      MaxLength = 100
      TabOrder = 2
    end
    object EditFirm: TEdit
      Left = 105
      Top = 63
      Width = 155
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 3
    end
    object ButtonFirm: TButton
      Left = 266
      Top = 63
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1102
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 4
    end
    object EditParent: TEdit
      Left = 105
      Top = 9
      Width = 155
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonParent: TButton
      Left = 266
      Top = 9
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1088#1086#1076#1080#1090#1077#1083#1100#1089#1082#1080#1081' '#1076#1086#1075#1086#1074#1086#1088
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 1
    end
    object EditVariant: TEdit
      Left = 105
      Top = 90
      Width = 155
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 5
    end
    object ButtonVariant: TButton
      Left = 266
      Top = 90
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1074#1072#1088#1080#1072#1085#1090' '#1088#1072#1089#1095#1077#1090#1072
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 6
    end
    object DateTimePickerBegin: TDateTimePicker
      Left = 172
      Top = 117
      Width = 88
      Height = 21
      Anchors = [akTop, akRight]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 7
    end
    object DateTimePickerEnd: TDateTimePicker
      Left = 172
      Top = 144
      Width = 88
      Height = 21
      Anchors = [akTop, akRight]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Checked = False
      TabOrder = 8
    end
  end
end