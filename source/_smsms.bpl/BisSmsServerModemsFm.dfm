inherited BisSmsServerModemsForm: TBisSmsServerModemsForm
  Left = 0
  Top = 0
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1084#1086#1076#1077#1084#1086#1074
  ClientHeight = 437
  ClientWidth = 358
  Font.Name = 'Tahoma'
  ExplicitWidth = 364
  ExplicitHeight = 469
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 402
    Width = 358
    TabOrder = 1
    ExplicitTop = 402
    ExplicitWidth = 358
    inherited ButtonOk: TButton
      Left = 191
      TabOrder = 1
      OnClick = ButtonOkClick
      ExplicitLeft = 191
    end
    inherited ButtonCancel: TButton
      Left = 273
      TabOrder = 2
      ExplicitLeft = 273
    end
    object ButtonSave: TButton
      Left = 8
      Top = 2
      Width = 75
      Height = 25
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      TabOrder = 0
      OnClick = ButtonSaveClick
    end
  end
  object PanelControls: TPanel
    Left = 0
    Top = 0
    Width = 358
    Height = 402
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object GroupBoxModem: TGroupBox
      Left = 8
      Top = 7
      Width = 339
      Height = 103
      Caption = ' '#1052#1086#1076#1077#1084' '
      TabOrder = 0
      object LabelComport: TLabel
        Left = 38
        Top = 21
        Width = 29
        Height = 13
        Alignment = taRightJustify
        Caption = #1055#1086#1088#1090':'
        FocusControl = ComboBoxComport
      end
      object LabelBaudRate: TLabel
        Left = 15
        Top = 48
        Width = 52
        Height = 13
        Alignment = taRightJustify
        Caption = #1057#1082#1086#1088#1086#1089#1090#1100':'
        FocusControl = ComboBoxBaudRate
      end
      object LabelDatabits: TLabel
        Left = 189
        Top = 48
        Width = 72
        Height = 13
        Alignment = taRightJustify
        Caption = #1041#1080#1090#1099' '#1076#1072#1085#1085#1099#1093':'
        FocusControl = ComboBoxDatabits
      end
      object LabelStopbits: TLabel
        Left = 15
        Top = 75
        Width = 84
        Height = 13
        Alignment = taRightJustify
        Caption = #1057#1090#1086#1087#1086#1074#1099#1077' '#1073#1080#1090#1099':'
        FocusControl = ComboBoxStopbits
      end
      object LabelParitybits: TLabel
        Left = 177
        Top = 75
        Width = 52
        Height = 13
        Alignment = taRightJustify
        Caption = #1063#1077#1090#1085#1086#1089#1090#1100':'
        FocusControl = ComboBoxParitybits
      end
      object ComboBoxComport: TComboBox
        Left = 73
        Top = 18
        Width = 93
        Height = 21
        Hint = #1055#1086#1089#1083#1077#1076#1086#1074#1072#1090#1077#1083#1100#1085#1099#1081' '#1087#1086#1088#1090', '#1085#1072' '#1082#1086#1090#1086#1088#1086#1084' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085' '#1084#1086#1076#1077#1084
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        OnChange = ComboBoxComportChange
      end
      object CheckBoxEnabled: TCheckBox
        Left = 172
        Top = 20
        Width = 74
        Height = 17
        Hint = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1080#1077' '#1087#1086#1088#1090#1072
        Caption = #1042#1082#1083#1102#1095#1077#1085
        TabOrder = 1
        OnClick = CheckBoxEnabledClick
      end
      object ComboBoxBaudRate: TComboBox
        Left = 73
        Top = 45
        Width = 93
        Height = 21
        Hint = #1057#1082#1086#1088#1086#1089#1090#1100' '#1086#1087#1088#1086#1089#1072' '#1084#1086#1076#1077#1084#1072
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 3
        Items.Strings = (
          #1040#1074#1090#1086
          '110'
          '300'
          '600'
          '1200'
          '2400'
          '4800'
          '9600'
          '14400'
          '19200'
          '38400'
          '56000'
          '57600'
          '115200'
          '128000'
          '256000')
      end
      object ComboBoxDatabits: TComboBox
        Left = 267
        Top = 45
        Width = 61
        Height = 21
        Hint = #1041#1080#1090#1099' '#1076#1072#1085#1085#1099#1093' '#1084#1086#1076#1077#1084#1072
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 4
        Items.Strings = (
          '5'
          '6'
          '7'
          '8')
      end
      object ComboBoxStopbits: TComboBox
        Left = 105
        Top = 72
        Width = 61
        Height = 21
        Hint = #1057#1090#1086#1087#1086#1074#1099#1077' '#1073#1080#1090#1099' '#1084#1086#1076#1077#1084#1072
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 5
        Items.Strings = (
          '1'
          '1,5'
          '2')
      end
      object ComboBoxParitybits: TComboBox
        Left = 235
        Top = 72
        Width = 93
        Height = 21
        Hint = #1063#1077#1090#1085#1086#1089#1090#1100' '#1076#1072#1085#1085#1099#1093' '#1084#1086#1076#1077#1084#1072
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 6
        Items.Strings = (
          #1085#1077#1090
          #1085#1077#1095#1077#1090#1085#1099#1081
          #1095#1077#1090#1085#1099#1081
          #1084#1072#1088#1082#1077#1088
          #1087#1088#1086#1073#1077#1083)
      end
      object ButtonTest: TButton
        Left = 267
        Top = 18
        Width = 61
        Height = 21
        Hint = #1058#1077#1089#1090' '#1084#1086#1076#1077#1084#1072
        Caption = #1058#1077#1089#1090
        TabOrder = 2
        OnClick = ButtonTestClick
      end
    end
    object GroupBoxGeneral: TGroupBox
      Left = 8
      Top = 116
      Width = 339
      Height = 79
      Caption = ' '#1054#1073#1097#1080#1077' '
      TabOrder = 1
      object LabelInterval: TLabel
        Left = 18
        Top = 49
        Width = 87
        Height = 13
        Alignment = taRightJustify
        Caption = #1048#1085#1090#1077#1088#1074#1072#1083' ('#1084#1089#1077#1082'):'
        FocusControl = EditInterval
      end
      object LabelMode: TLabel
        Left = 15
        Top = 22
        Width = 36
        Height = 13
        Alignment = taRightJustify
        Caption = #1056#1077#1078#1080#1084':'
        FocusControl = ComboBoxMode
      end
      object LabelStorages: TLabel
        Left = 176
        Top = 22
        Width = 61
        Height = 13
        Alignment = taRightJustify
        Caption = #1061#1088#1072#1085#1080#1083#1080#1097#1077':'
        FocusControl = ComboBoxStorages
      end
      object LabelTimeout: TLabel
        Left = 183
        Top = 49
        Width = 84
        Height = 13
        Alignment = taRightJustify
        Caption = #1058#1072#1081#1084'-'#1072#1091#1090' ('#1084#1089#1077#1082'):'
        FocusControl = EditTimeout
      end
      object EditInterval: TEdit
        Left = 111
        Top = 46
        Width = 55
        Height = 21
        Hint = #1048#1085#1090#1077#1088#1074#1072#1083' '#1086#1087#1088#1086#1089#1072' '#1084#1086#1076#1077#1084#1072
        TabOrder = 2
      end
      object ComboBoxMode: TComboBox
        Left = 57
        Top = 19
        Width = 109
        Height = 21
        Hint = #1056#1077#1078#1080#1084' '#1088#1072#1073#1086#1090#1099' '#1089#1077#1088#1074#1077#1088#1072
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        Items.Strings = (
          #1042#1089#1077' '#1089#1086#1086#1073#1097#1077#1085#1080#1103
          #1042#1093#1086#1076#1103#1097#1080#1077
          #1048#1089#1093#1086#1076#1103#1097#1080#1077)
      end
      object ComboBoxStorages: TComboBox
        Left = 243
        Top = 19
        Width = 85
        Height = 21
        Hint = #1061#1088#1072#1085#1080#1083#1080#1097#1077' '#1084#1086#1076#1077#1084#1072' (SM-'#1089#1080#1084#1082#1072#1088#1090#1072', ME-'#1087#1072#1084#1103#1090#1100')'
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 1
        Items.Strings = (
          'ME'
          'SM'
          'ME;SM')
      end
      object EditTimeout: TEdit
        Left = 273
        Top = 46
        Width = 55
        Height = 21
        Hint = #1042#1088#1077#1084#1103' '#1080#1089#1090#1077#1095#1077#1085#1080#1103' '#1086#1078#1080#1076#1072#1085#1080#1103' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1072' '#1082#1086#1084#1072#1085#1076
        TabOrder = 3
      end
    end
    object GroupBoxRestrict: TGroupBox
      Left = 66
      Top = 313
      Width = 281
      Height = 79
      Caption = ' '#1055#1088#1080#1074#1103#1079#1082#1072' '
      TabOrder = 2
      object LabelImei: TLabel
        Left = 15
        Top = 23
        Width = 60
        Height = 13
        Alignment = taRightJustify
        Caption = 'IMEI-'#1085#1086#1084#1077#1088':'
        FocusControl = EditImei
      end
      object LabelImsi: TLabel
        Left = 15
        Top = 50
        Width = 60
        Height = 13
        Alignment = taRightJustify
        Caption = 'IMSI-'#1085#1086#1084#1077#1088':'
        FocusControl = EditImsi
      end
      object EditImei: TEdit
        Left = 81
        Top = 20
        Width = 189
        Height = 21
        Hint = #1055#1088#1080#1074#1103#1079#1082#1072' '#1082' '#1091#1085#1080#1082#1072#1083#1100#1085#1086#1084#1091' '#1085#1086#1084#1077#1088#1091' '#1089#1080#1084#1082#1072#1088#1090#1099
        TabOrder = 0
      end
      object EditImsi: TEdit
        Left = 81
        Top = 47
        Width = 189
        Height = 21
        Hint = #1055#1088#1080#1074#1103#1079#1082#1072' '#1082' '#1091#1085#1080#1082#1072#1083#1100#1085#1086#1084#1091' '#1085#1086#1084#1077#1088#1091' '#1084#1086#1076#1077#1084#1072
        TabOrder = 1
      end
    end
    object GroupBoxOutgoing: TGroupBox
      Left = 8
      Top = 201
      Width = 339
      Height = 106
      Caption = ' '#1048#1089#1093#1086#1076#1103#1097#1080#1077' '#1089#1086#1086#1073#1097#1077#1085#1080#1103' '
      TabOrder = 3
      object LabelMaxcount: TLabel
        Left = 24
        Top = 24
        Width = 64
        Height = 13
        Alignment = taRightJustify
        Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086':'
        FocusControl = EditMaxcount
      end
      object LabelPeriod: TLabel
        Left = 174
        Top = 24
        Width = 42
        Height = 13
        Alignment = taRightJustify
        Caption = #1055#1077#1088#1080#1086#1076':'
        FocusControl = EditPeriod
      end
      object LabelUnknownSender: TLabel
        Left = 18
        Top = 51
        Width = 140
        Height = 13
        Alignment = taRightJustify
        Caption = #1053#1077#1080#1079#1074#1077#1089#1090#1085#1099#1081' '#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1100':'
        FocusControl = EditUnknownSender
      end
      object LabelUnknownCode: TLabel
        Left = 65
        Top = 78
        Width = 93
        Height = 13
        Alignment = taRightJustify
        Caption = #1053#1077#1080#1079#1074#1077#1089#1090#1085#1099#1081' '#1082#1086#1076':'
        FocusControl = EditUnknownCode
      end
      object EditMaxcount: TEdit
        Left = 94
        Top = 21
        Width = 61
        Height = 21
        Hint = #1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1086#1077' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1089#1086#1086#1073#1097#1077#1085#1080#1081' '#1085#1072' '#1086#1090#1087#1088#1072#1074#1082#1091' '#1079#1072' '#1086#1076#1080#1085' '#1088#1072#1079
        TabOrder = 0
      end
      object EditPeriod: TEdit
        Left = 222
        Top = 21
        Width = 69
        Height = 21
        Hint = #1055#1077#1088#1080#1086#1076' '#1076#1077#1081#1089#1090#1074#1080#1103' '#1080#1089#1093#1086#1076#1103#1097#1077#1075#1086' '#1089#1086#1086#1073#1097#1077#1085#1080#1103' '#1089' '#1084#1086#1084#1077#1085#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103
        TabOrder = 1
      end
      object EditUnknownSender: TEdit
        Left = 164
        Top = 48
        Width = 164
        Height = 21
        Hint = #1054#1090#1074#1077#1090' '#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1102' '#1074' '#1089#1083#1091#1095#1072#1077' '#1086#1090#1089#1091#1090#1089#1090#1074#1080#1103' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103' '#1074' '#1073#1072#1079#1077' '#1076#1072#1085#1085#1099#1093
        TabOrder = 2
      end
      object EditUnknownCode: TEdit
        Left = 164
        Top = 75
        Width = 164
        Height = 21
        Hint = #1054#1090#1074#1077#1090' '#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1102' '#1074' '#1089#1083#1091#1095#1072#1077' '#1086#1090#1089#1091#1090#1089#1090#1074#1080#1103' '#1082#1086#1076#1072' '#1074' '#1073#1072#1079#1077' '#1076#1072#1085#1085#1099#1093
        TabOrder = 3
      end
    end
  end
end
