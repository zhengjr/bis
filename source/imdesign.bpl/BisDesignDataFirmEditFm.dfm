inherited BisDesignDataFirmEditForm: TBisDesignDataFirmEditForm
  Left = 424
  Top = 189
  ActiveControl = EditSmallName
  Caption = 'BisDesignDataFirmEditForm'
  ClientHeight = 468
  ClientWidth = 632
  Constraints.MinHeight = 495
  Constraints.MinWidth = 640
  ExplicitWidth = 640
  ExplicitHeight = 502
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 430
    Width = 632
    ExplicitTop = 430
    ExplicitWidth = 632
    inherited ButtonOk: TButton
      Left = 453
      ExplicitLeft = 453
    end
    inherited ButtonCancel: TButton
      Left = 549
      ExplicitLeft = 549
    end
  end
  inherited PanelControls: TPanel
    Width = 632
    Height = 430
    ExplicitWidth = 632
    ExplicitHeight = 430
    object LabelSmallName: TLabel
      Left = 9
      Top = 39
      Width = 122
      Height = 13
      Alignment = taRightJustify
      Caption = #1050#1088#1072#1090#1082#1086#1077' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
      FocusControl = EditSmallName
    end
    object LabelFullName: TLabel
      Left = 15
      Top = 66
      Width = 116
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1086#1083#1085#1086#1077' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
      FocusControl = EditFullName
    end
    object LabelInn: TLabel
      Left = 441
      Top = 66
      Width = 25
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1048#1053#1053':'
      FocusControl = EditInn
    end
    object LabelPaymentAccount: TLabel
      Left = 46
      Top = 120
      Width = 85
      Height = 13
      Alignment = taRightJustify
      Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090':'
      FocusControl = EditPaymentAccount
    end
    object LabelBank: TLabel
      Left = 103
      Top = 93
      Width = 28
      Height = 13
      Alignment = taRightJustify
      Caption = #1041#1072#1085#1082':'
      FocusControl = EditBank
    end
    object LabelCorrAccount: TLabel
      Left = 368
      Top = 120
      Width = 59
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1050#1086#1088#1088'. '#1089#1095#1077#1090':'
      FocusControl = EditCorrAccount
    end
    object LabelPhone: TLabel
      Left = 83
      Top = 324
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1058#1077#1083#1077#1092#1086#1085':'
      FocusControl = EditPhone
    end
    object LabelFirmType: TLabel
      Left = 377
      Top = 39
      Width = 89
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1080#1087' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1080':'
      FocusControl = ComboBoxFirmType
    end
    object LabelFax: TLabel
      Left = 281
      Top = 324
      Width = 29
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1060#1072#1082#1089':'
      FocusControl = EditFax
    end
    object LabelEmail: TLabel
      Left = 461
      Top = 324
      Width = 35
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1055#1086#1095#1090#1072':'
      FocusControl = EditEmail
    end
    object LabelSite: TLabel
      Left = 102
      Top = 356
      Width = 29
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1057#1072#1081#1090':'
      FocusControl = EditSite
    end
    object LabelOkonh: TLabel
      Left = 270
      Top = 351
      Width = 40
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1054#1050#1054#1053#1061':'
      FocusControl = EditOkonh
    end
    object LabelOkpo: TLabel
      Left = 402
      Top = 351
      Width = 34
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1054#1050#1055#1054':'
      FocusControl = EditOkpo
    end
    object LabelKpp: TLabel
      Left = 521
      Top = 351
      Width = 25
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1050#1055#1055':'
      FocusControl = EditKpp
    end
    object LabelDirector: TLabel
      Left = 77
      Top = 378
      Width = 54
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1044#1080#1088#1077#1082#1090#1086#1088':'
      FocusControl = EditDirector
    end
    object LabelAccountant: TLabel
      Left = 379
      Top = 378
      Width = 57
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1041#1091#1093#1075#1072#1083#1090#1077#1088':'
      FocusControl = EditAccountant
    end
    object LabelBik: TLabel
      Left = 442
      Top = 93
      Width = 24
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1041#1048#1050':'
      FocusControl = EditBik
    end
    object LabelParent: TLabel
      Left = 78
      Top = 12
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1056#1086#1076#1080#1090#1077#1083#1100':'
      FocusControl = EditParent
    end
    object LabelContactFace: TLabel
      Left = 218
      Top = 405
      Width = 92
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1050#1086#1085#1090#1072#1082#1090#1085#1086#1077' '#1083#1080#1094#1086':'
      FocusControl = EditContactFace
    end
    object EditSmallName: TEdit
      Left = 137
      Top = 36
      Width = 230
      Height = 21
      MaxLength = 100
      TabOrder = 2
      OnExit = EditSmallNameExit
    end
    object EditFullName: TEdit
      Left = 137
      Top = 63
      Width = 290
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      MaxLength = 100
      TabOrder = 4
    end
    object EditInn: TEdit
      Left = 472
      Top = 63
      Width = 150
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 100
      TabOrder = 5
    end
    object EditPaymentAccount: TEdit
      Left = 137
      Top = 117
      Width = 191
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      MaxLength = 100
      TabOrder = 8
    end
    object EditBank: TEdit
      Left = 137
      Top = 90
      Width = 290
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      MaxLength = 100
      TabOrder = 6
    end
    object EditCorrAccount: TEdit
      Left = 433
      Top = 117
      Width = 189
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 100
      TabOrder = 9
    end
    object EditPhone: TEdit
      Left = 137
      Top = 321
      Width = 120
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 100
      TabOrder = 12
    end
    object EditFax: TEdit
      Left = 316
      Top = 321
      Width = 120
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 100
      TabOrder = 13
    end
    object EditEmail: TEdit
      Left = 502
      Top = 321
      Width = 120
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 100
      TabOrder = 14
    end
    object EditSite: TEdit
      Left = 137
      Top = 348
      Width = 120
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 100
      TabOrder = 15
    end
    object EditOkonh: TEdit
      Left = 316
      Top = 348
      Width = 68
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 100
      TabOrder = 16
    end
    object EditOkpo: TEdit
      Left = 442
      Top = 348
      Width = 61
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 100
      TabOrder = 17
    end
    object EditKpp: TEdit
      Left = 552
      Top = 348
      Width = 70
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 100
      TabOrder = 18
    end
    object EditDirector: TEdit
      Left = 137
      Top = 375
      Width = 233
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 100
      TabOrder = 19
    end
    object EditAccountant: TEdit
      Left = 442
      Top = 375
      Width = 180
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 100
      TabOrder = 20
    end
    object EditBik: TEdit
      Left = 472
      Top = 90
      Width = 150
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 100
      TabOrder = 7
    end
    object EditParent: TEdit
      Left = 137
      Top = 9
      Width = 201
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonParent: TButton
      Left = 344
      Top = 9
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1088#1086#1076#1080#1090#1077#1083#1100#1089#1082#1091#1102' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1102
      Caption = '...'
      TabOrder = 1
    end
    object EditContactFace: TEdit
      Left = 316
      Top = 402
      Width = 306
      Height = 21
      Anchors = [akTop, akRight]
      MaxLength = 100
      TabOrder = 21
    end
    object GroupBoxLegalAddress: TGroupBox
      Left = 137
      Top = 145
      Width = 485
      Height = 80
      Anchors = [akLeft, akTop, akRight]
      Caption = ' '#1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1081' '#1072#1076#1088#1077#1089': '
      TabOrder = 10
      object LabelStreetLegal: TLabel
        Left = 46
        Top = 24
        Width = 35
        Height = 13
        Alignment = taRightJustify
        Caption = #1059#1083#1080#1094#1072':'
        FocusControl = EditStreetLegal
      end
      object LabelIndexLegal: TLabel
        Left = 353
        Top = 51
        Width = 41
        Height = 13
        Alignment = taRightJustify
        Caption = #1048#1085#1076#1077#1082#1089':'
        FocusControl = EditIndexLegal
      end
      object LabelHouseLegal: TLabel
        Left = 18
        Top = 51
        Width = 63
        Height = 13
        Alignment = taRightJustify
        Caption = #1044#1086#1084'/'#1082#1086#1088#1087#1091#1089':'
        FocusControl = EditHouseLegal
      end
      object LabelFlatLegal: TLabel
        Left = 175
        Top = 51
        Width = 82
        Height = 13
        Alignment = taRightJustify
        Caption = #1050#1074#1072#1088#1090#1080#1088#1072'/'#1086#1092#1080#1089':'
        FocusControl = EditFlatLegal
      end
      object EditStreetLegal: TEdit
        Left = 87
        Top = 21
        Width = 357
        Height = 21
        Color = clBtnFace
        MaxLength = 100
        ReadOnly = True
        TabOrder = 0
      end
      object ButtonStreetLegal: TButton
        Left = 450
        Top = 21
        Width = 21
        Height = 21
        Hint = #1042#1099#1073#1088#1072#1090#1100' '#1091#1083#1080#1094#1091
        Caption = '...'
        TabOrder = 1
      end
      object EditIndexLegal: TEdit
        Left = 400
        Top = 48
        Width = 70
        Height = 21
        MaxLength = 100
        TabOrder = 4
      end
      object EditHouseLegal: TEdit
        Left = 87
        Top = 48
        Width = 70
        Height = 21
        MaxLength = 100
        TabOrder = 2
      end
      object EditFlatLegal: TEdit
        Left = 263
        Top = 48
        Width = 70
        Height = 21
        MaxLength = 100
        TabOrder = 3
      end
    end
    object GroupBoxPostAddress: TGroupBox
      Left = 137
      Top = 231
      Width = 485
      Height = 80
      Anchors = [akLeft, akTop, akRight]
      Caption = ' '#1055#1086#1095#1090#1086#1074#1099#1081' '#1072#1076#1088#1077#1089': '
      TabOrder = 11
      object LabelStreetPost: TLabel
        Left = 46
        Top = 24
        Width = 35
        Height = 13
        Alignment = taRightJustify
        Caption = #1059#1083#1080#1094#1072':'
        FocusControl = EditStreetPost
      end
      object LabelIndexPost: TLabel
        Left = 353
        Top = 51
        Width = 41
        Height = 13
        Alignment = taRightJustify
        Caption = #1048#1085#1076#1077#1082#1089':'
        FocusControl = EditIndexPost
      end
      object LabelHousePost: TLabel
        Left = 18
        Top = 51
        Width = 63
        Height = 13
        Alignment = taRightJustify
        Caption = #1044#1086#1084'/'#1082#1086#1088#1087#1091#1089':'
        FocusControl = EditHousePost
      end
      object LabelFlatPost: TLabel
        Left = 175
        Top = 51
        Width = 82
        Height = 13
        Alignment = taRightJustify
        Caption = #1050#1074#1072#1088#1090#1080#1088#1072'/'#1086#1092#1080#1089':'
        FocusControl = EditFlatPost
      end
      object EditStreetPost: TEdit
        Left = 87
        Top = 21
        Width = 357
        Height = 21
        Color = clBtnFace
        MaxLength = 100
        ReadOnly = True
        TabOrder = 0
      end
      object ButtonStreetPost: TButton
        Left = 450
        Top = 21
        Width = 21
        Height = 21
        Hint = #1042#1099#1073#1088#1072#1090#1100' '#1091#1083#1080#1094#1091
        Caption = '...'
        TabOrder = 1
      end
      object EditIndexPost: TEdit
        Left = 400
        Top = 48
        Width = 70
        Height = 21
        MaxLength = 100
        TabOrder = 4
      end
      object EditHousePost: TEdit
        Left = 87
        Top = 48
        Width = 70
        Height = 21
        MaxLength = 100
        TabOrder = 2
      end
      object EditFlatPost: TEdit
        Left = 263
        Top = 48
        Width = 70
        Height = 21
        MaxLength = 100
        TabOrder = 3
      end
    end
    object ComboBoxFirmType: TComboBox
      Left = 472
      Top = 36
      Width = 150
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 3
    end
  end
end