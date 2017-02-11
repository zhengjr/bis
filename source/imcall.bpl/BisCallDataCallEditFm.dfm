inherited BisCallDataCallEditForm: TBisCallDataCallEditForm
  Left = 513
  Top = 212
  Caption = 'BisCallDataCallEditForm'
  ClientHeight = 413
  ClientWidth = 670
  ExplicitWidth = 686
  ExplicitHeight = 451
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 375
    Width = 670
    ExplicitTop = 375
    ExplicitWidth = 670
    DesignSize = (
      670
      38)
    inherited ButtonOk: TButton
      Left = 491
      ExplicitLeft = 491
    end
    inherited ButtonCancel: TButton
      Left = 587
      ExplicitLeft = 587
    end
  end
  inherited PanelControls: TPanel
    Width = 670
    Height = 375
    ExplicitWidth = 670
    ExplicitHeight = 375
    DesignSize = (
      670
      375)
    object LabelDateCreate: TLabel
      Left = 63
      Top = 287
      Width = 80
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103':'
      FocusControl = DateTimePickerCreate
    end
    object LabelDirection: TLabel
      Left = 69
      Top = 15
      Width = 71
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077':'
      FocusControl = ComboBoxDirection
      Transparent = True
    end
    object LabelCreator: TLabel
      Left = 82
      Top = 314
      Width = 61
      Height = 13
      Alignment = taRightJustify
      Caption = #1050#1090#1086' '#1089#1086#1079#1076#1072#1083':'
      FocusControl = EditCreator
    end
    object LabelDateBegin: TLabel
      Left = 404
      Top = 287
      Width = 69
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072':'
      FocusControl = DateTimePickerBegin
    end
    object LabelDateEnd: TLabel
      Left = 386
      Top = 314
      Width = 87
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103':'
      FocusControl = DateTimePickerEnd
    end
    object LabelFirm: TLabel
      Left = 73
      Top = 341
      Width = 70
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103':'
    end
    object LabelCallResult: TLabel
      Left = 348
      Top = 15
      Width = 57
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090':'
      FocusControl = ComboBoxCallResult
      Transparent = True
      ExplicitLeft = 340
    end
    object LabelTypeEnd: TLabel
      Left = 394
      Top = 341
      Width = 79
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1058#1080#1087' '#1086#1082#1086#1085#1095#1072#1085#1080#1103':'
      FocusControl = ComboBoxTypeEnd
      Transparent = True
    end
    object LabelDateFound: TLabel
      Left = 372
      Top = 260
      Width = 101
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1044#1072#1090#1072' '#1086#1073#1085#1072#1088#1091#1078#1077#1085#1080#1103':'
      FocusControl = DateTimePickerFound
    end
    object DateTimePickerCreate: TDateTimePicker
      Left = 149
      Top = 284
      Width = 88
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 2
    end
    object DateTimePickerCreateTime: TDateTimePicker
      Left = 243
      Top = 284
      Width = 74
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 3
    end
    object ComboBoxDirection: TComboBox
      Left = 146
      Top = 12
      Width = 168
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
    object EditCreator: TEdit
      Left = 149
      Top = 311
      Width = 168
      Height = 21
      MaxLength = 100
      TabOrder = 4
    end
    object DateTimePickerBegin: TDateTimePicker
      Left = 479
      Top = 284
      Width = 88
      Height = 21
      Anchors = [akTop, akRight]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 10
    end
    object DateTimePickerBeginTime: TDateTimePicker
      Left = 573
      Top = 284
      Width = 74
      Height = 21
      Anchors = [akTop, akRight]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 11
    end
    object DateTimePickerEnd: TDateTimePicker
      Left = 479
      Top = 311
      Width = 88
      Height = 21
      Anchors = [akTop, akRight]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 12
    end
    object DateTimePickerEndTime: TDateTimePicker
      Left = 573
      Top = 311
      Width = 74
      Height = 21
      Anchors = [akTop, akRight]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 13
    end
    object ComboBoxFirm: TComboBox
      Left = 149
      Top = 338
      Width = 168
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 5
    end
    object ComboBoxCallResult: TComboBox
      Left = 411
      Top = 12
      Width = 236
      Height = 21
      Style = csDropDownList
      Anchors = [akTop, akRight]
      ItemHeight = 13
      TabOrder = 6
    end
    object ComboBoxTypeEnd: TComboBox
      Left = 479
      Top = 338
      Width = 168
      Height = 21
      Style = csDropDownList
      Anchors = [akTop, akRight]
      ItemHeight = 13
      TabOrder = 14
    end
    object GroupBoxCaller: TGroupBox
      Left = 13
      Top = 39
      Width = 317
      Height = 232
      Caption = ' '#1042#1099#1079#1099#1074#1072#1102#1097#1072#1103' '#1089#1090#1086#1088#1086#1085#1072' '
      TabOrder = 1
      object LabelCaller: TLabel
        Left = 16
        Top = 23
        Width = 84
        Height = 13
        Alignment = taRightJustify
        Caption = #1059#1095#1077#1090#1085#1072#1103' '#1079#1072#1087#1080#1089#1100':'
        FocusControl = EditCaller
      end
      object LabelCallerPhone: TLabel
        Left = 52
        Top = 50
        Width = 48
        Height = 13
        Alignment = taRightJustify
        Caption = #1058#1077#1083#1077#1092#1086#1085':'
        FocusControl = EditCallerPhone
      end
      object EditCaller: TEdit
        Left = 106
        Top = 20
        Width = 169
        Height = 21
        Color = clBtnFace
        MaxLength = 100
        ReadOnly = True
        TabOrder = 0
      end
      object ButtonCaller: TButton
        Left = 281
        Top = 20
        Width = 21
        Height = 21
        Hint = #1042#1099#1073#1088#1072#1090#1100' '#1074#1099#1079#1099#1074#1072#1102#1097#1077#1075#1086
        Caption = '...'
        TabOrder = 1
      end
      object EditCallerPhone: TEdit
        Left = 106
        Top = 47
        Width = 196
        Height = 21
        MaxLength = 100
        TabOrder = 2
      end
      object GroupBoxCallerAudio: TGroupBox
        Left = 16
        Top = 74
        Width = 286
        Height = 145
        Caption = ' '#1040#1091#1076#1080#1086' '
        TabOrder = 3
        object PanelCallerAudio: TPanel
          AlignWithMargins = True
          Left = 7
          Top = 15
          Width = 272
          Height = 89
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
        end
        object PanelCallerAudioExtra: TPanel
          Left = 2
          Top = 109
          Width = 282
          Height = 34
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 1
          object CheckBoxCallerAudioSync: TCheckBox
            Left = 11
            Top = 8
            Width = 149
            Height = 17
            Hint = #1057#1080#1085#1093#1088#1086#1085#1085#1086' '#1089' '#1087#1088#1080#1085#1080#1084#1072#1102#1097#1077#1081' '#1089#1090#1086#1088#1086#1085#1086#1081
            Caption = #1057#1080#1085#1093#1088#1086#1085#1085#1086' '#1089#1086' '#1089#1084#1077#1097#1077#1085#1080#1077#1084':'
            TabOrder = 0
            OnClick = CheckBoxCallerAudioSyncClick
          end
          object EditCallerAudioOffset: TEdit
            Left = 166
            Top = 6
            Width = 38
            Height = 21
            Color = clBtnFace
            Enabled = False
            ReadOnly = True
            TabOrder = 1
            Text = '0'
          end
          object UpDownCallerAudioOffset: TUpDown
            Left = 204
            Top = 6
            Width = 17
            Height = 21
            Associate = EditCallerAudioOffset
            Enabled = False
            Max = 30000
            Increment = 10
            TabOrder = 2
            Thousands = False
          end
        end
      end
    end
    object GroupBoxAcceptor: TGroupBox
      Left = 344
      Top = 39
      Width = 317
      Height = 204
      Anchors = [akTop, akRight]
      Caption = ' '#1055#1088#1080#1085#1080#1084#1072#1102#1097#1072#1103' '#1089#1090#1086#1088#1086#1085#1072' '
      TabOrder = 7
      DesignSize = (
        317
        204)
      object LabelAcceptor: TLabel
        Left = 16
        Top = 22
        Width = 84
        Height = 13
        Alignment = taRightJustify
        Anchors = [akTop, akRight]
        Caption = #1059#1095#1077#1090#1085#1072#1103' '#1079#1072#1087#1080#1089#1100':'
        FocusControl = EditAcceptor
      end
      object LabelAcceptorPhone: TLabel
        Left = 52
        Top = 49
        Width = 48
        Height = 13
        Alignment = taRightJustify
        Anchors = [akTop, akRight]
        Caption = #1058#1077#1083#1077#1092#1086#1085':'
        FocusControl = EditAcceptorPhone
      end
      object EditAcceptor: TEdit
        Left = 106
        Top = 19
        Width = 169
        Height = 21
        Anchors = [akTop, akRight]
        Color = clBtnFace
        MaxLength = 100
        ReadOnly = True
        TabOrder = 0
      end
      object ButtonAcceptor: TButton
        Left = 281
        Top = 19
        Width = 21
        Height = 21
        Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1088#1080#1085#1080#1084#1072#1102#1097#1077#1075#1086
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 1
      end
      object EditAcceptorPhone: TEdit
        Left = 106
        Top = 46
        Width = 196
        Height = 21
        Anchors = [akTop, akRight]
        MaxLength = 100
        TabOrder = 2
      end
      object GroupBoxAcceptorAudio: TGroupBox
        Left = 16
        Top = 74
        Width = 286
        Height = 117
        Caption = ' '#1040#1091#1076#1080#1086' '
        TabOrder = 3
        object PanelAcceptorAudio: TPanel
          AlignWithMargins = True
          Left = 7
          Top = 15
          Width = 272
          Height = 95
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
        end
      end
    end
    object DateTimePickerFound: TDateTimePicker
      Left = 479
      Top = 257
      Width = 88
      Height = 21
      Anchors = [akTop, akRight]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 8
    end
    object DateTimePickerFoundTime: TDateTimePicker
      Left = 573
      Top = 257
      Width = 74
      Height = 21
      Anchors = [akTop, akRight]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 9
    end
  end
  inherited ImageList: TImageList
    Left = 440
    Top = 120
    Bitmap = {
      494C010100000400140010001000FFFFFFFFFF00FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000}
  end
  object OpenDialog: TOpenDialog
    Options = [ofEnableSizing]
    Left = 208
    Top = 64
  end
  object SaveDialog: TSaveDialog
    Options = [ofEnableSizing]
    Left = 168
    Top = 64
  end
end