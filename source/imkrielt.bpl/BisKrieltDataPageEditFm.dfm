inherited BisKrieltDataPageEditForm: TBisKrieltDataPageEditForm
  Left = 513
  Top = 212
  Caption = 'BisKrieltDataPageEditForm'
  ClientHeight = 200
  ClientWidth = 297
  ExplicitWidth = 305
  ExplicitHeight = 234
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 162
    Width = 297
    ExplicitTop = 162
    ExplicitWidth = 297
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
    Width = 297
    Height = 162
    ExplicitWidth = 297
    ExplicitHeight = 162
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
    object LabelAddress: TLabel
      Left = 55
      Top = 138
      Width = 35
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1040#1076#1088#1077#1089':'
      FocusControl = EditAddress
    end
    object EditName: TEdit
      Left = 96
      Top = 13
      Width = 192
      Height = 21
      TabOrder = 0
    end
    object MemoDescription: TMemo
      Left = 96
      Top = 40
      Width = 192
      Height = 89
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 1
    end
    object EditAddress: TEdit
      Left = 96
      Top = 135
      Width = 192
      Height = 21
      Anchors = [akLeft, akRight, akBottom]
      TabOrder = 2
    end
  end
end