inherited BisTaxiDataFirmDiscountEditForm: TBisTaxiDataFirmDiscountEditForm
  Left = 513
  Top = 212
  Caption = 'BisTaxiDataFirmDiscountEditForm'
  ClientHeight = 138
  ClientWidth = 297
  ExplicitWidth = 305
  ExplicitHeight = 172
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 100
    Width = 297
    ExplicitTop = 100
    ExplicitWidth = 297
    inherited ButtonOk: TButton
      Left = 118
      ExplicitLeft = 118
    end
    inherited ButtonCancel: TButton
      Left = 214
      ExplicitLeft = 214
    end
  end
  inherited PanelControls: TPanel
    Width = 297
    Height = 100
    ExplicitWidth = 297
    ExplicitHeight = 100
    object LabelFirm: TLabel
      Left = 14
      Top = 18
      Width = 41
      Height = 13
      Alignment = taRightJustify
      Caption = #1050#1083#1080#1077#1085#1090':'
      FocusControl = EditFirm
    end
    object LabelDiscount: TLabel
      Left = 13
      Top = 45
      Width = 42
      Height = 13
      Alignment = taRightJustify
      Caption = #1057#1082#1080#1076#1082#1072':'
      FocusControl = EditDiscount
    end
    object LabelPriority: TLabel
      Left = 136
      Top = 72
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1086#1088#1103#1076#1086#1082':'
      FocusControl = EditPriority
    end
    object EditFirm: TEdit
      Left = 61
      Top = 15
      Width = 197
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonFirm: TButton
      Left = 264
      Top = 15
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1102
      Caption = '...'
      TabOrder = 1
    end
    object EditDiscount: TEdit
      Left = 61
      Top = 42
      Width = 197
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 2
    end
    object ButtonDiscount: TButton
      Left = 264
      Top = 42
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1089#1082#1080#1076#1082#1091
      Caption = '...'
      TabOrder = 3
    end
    object EditPriority: TEdit
      Left = 190
      Top = 69
      Width = 68
      Height = 21
      Constraints.MaxWidth = 300
      TabOrder = 4
    end
  end
end