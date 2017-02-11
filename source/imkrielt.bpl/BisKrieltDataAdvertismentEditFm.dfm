inherited BisKrieltDataAdvertismentEditForm: TBisKrieltDataAdvertismentEditForm
  Left = 355
  Top = 140
  Caption = 'BisKrieltDataAdvertismentEditForm'
  ClientHeight = 364
  ClientWidth = 686
  ExplicitWidth = 694
  ExplicitHeight = 398
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 326
    Width = 686
    ExplicitTop = 326
    ExplicitWidth = 686
    inherited ButtonOk: TButton
      Left = 507
      ExplicitLeft = 507
    end
    inherited ButtonCancel: TButton
      Left = 604
      ExplicitLeft = 604
    end
  end
  inherited PanelControls: TPanel
    Width = 686
    Height = 326
    ExplicitWidth = 686
    ExplicitHeight = 326
    object LabelService: TLabel
      Left = 52
      Top = 42
      Width = 39
      Height = 13
      Alignment = taRightJustify
      Caption = #1059#1089#1083#1091#1075#1072':'
      FocusControl = EditService
    end
    object LabelName: TLabel
      Left = 14
      Top = 69
      Width = 77
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
      FocusControl = EditName
    end
    object LabelDescription: TLabel
      Left = 38
      Top = 96
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      FocusControl = MemoDescription
    end
    object LabelLink: TLabel
      Left = 49
      Top = 298
      Width = 42
      Height = 13
      Alignment = taRightJustify
      Caption = #1057#1089#1099#1083#1082#1072':'
      FocusControl = EditLink
    end
    object LabelType: TLabel
      Left = 22
      Top = 15
      Width = 69
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1080#1087' '#1088#1077#1082#1083#1072#1084#1099':'
      FocusControl = ComboBoxType
    end
    object LabelLocation: TLabel
      Left = 14
      Top = 271
      Width = 77
      Height = 13
      Alignment = taRightJustify
      Caption = #1056#1072#1089#1087#1086#1083#1086#1078#1077#1085#1080#1077':'
      FocusControl = ComboBoxLocation
    end
    object EditService: TEdit
      Left = 97
      Top = 39
      Width = 215
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
    end
    object ButtonService: TButton
      Left = 318
      Top = 39
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1091#1089#1083#1091#1075#1091
      Caption = '...'
      TabOrder = 2
    end
    object EditName: TEdit
      Left = 97
      Top = 66
      Width = 242
      Height = 21
      TabOrder = 3
    end
    object MemoDescription: TMemo
      Left = 97
      Top = 93
      Width = 242
      Height = 169
      TabOrder = 4
    end
    object EditLink: TEdit
      Left = 97
      Top = 295
      Width = 242
      Height = 21
      TabOrder = 6
    end
    object ComboBoxType: TComboBox
      Left = 97
      Top = 12
      Width = 168
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
    object ComboBoxLocation: TComboBox
      Left = 97
      Top = 268
      Width = 168
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 5
      Items.Strings = (
        #1042' '#1073#1072#1079#1077' '#1076#1072#1085#1085#1099#1093
        #1042' '#1092#1072#1081#1083#1086#1074#1086#1081' '#1089#1080#1089#1090#1077#1084#1077)
    end
    object PageControlValue: TPageControl
      Left = 345
      Top = 12
      Width = 333
      Height = 316
      ActivePage = TabSheetFlash
      Anchors = [akLeft, akTop, akRight, akBottom]
      Style = tsButtons
      TabOrder = 7
      object TabSheetPath: TTabSheet
        Caption = 'TabSheetPath'
        object GroupBoxPath: TGroupBox
          Left = 0
          Top = 0
          Width = 325
          Height = 285
          Align = alClient
          Caption = ' '#1055#1091#1090#1100' '
          TabOrder = 0
          object MemoPath: TMemo
            AlignWithMargins = True
            Left = 7
            Top = 15
            Width = 311
            Height = 263
            Margins.Left = 5
            Margins.Top = 0
            Margins.Right = 5
            Margins.Bottom = 5
            Align = alClient
            TabOrder = 0
            OnKeyUp = MemoPathKeyUp
          end
        end
      end
      object TabSheetText: TTabSheet
        Caption = 'TabSheetText'
        ImageIndex = 1
        object GroupBoxText: TGroupBox
          Left = 0
          Top = 0
          Width = 325
          Height = 285
          Align = alClient
          Caption = ' '#1058#1077#1082#1089#1090' '
          TabOrder = 0
          object MemoText: TMemo
            AlignWithMargins = True
            Left = 7
            Top = 15
            Width = 311
            Height = 263
            Margins.Left = 5
            Margins.Top = 0
            Margins.Right = 5
            Margins.Bottom = 5
            Align = alClient
            ScrollBars = ssBoth
            TabOrder = 0
            WordWrap = False
            OnKeyUp = MemoTextKeyUp
          end
        end
      end
      object TabSheetBanner: TTabSheet
        Caption = 'TabSheetBanner'
        ImageIndex = 2
        object PanelBanner: TPanel
          Left = 0
          Top = 0
          Width = 325
          Height = 229
          Align = alClient
          BevelOuter = bvNone
          Caption = #1053#1077#1090' '#1073#1072#1085#1077#1088#1072
          Color = clWindow
          ParentBackground = False
          TabOrder = 0
          OnResize = PanelBannerResize
          object ShapeBanner: TShape
            Left = 0
            Top = 0
            Width = 325
            Height = 229
            Align = alClient
            Brush.Style = bsClear
            Pen.Style = psDot
            ExplicitLeft = 32
            ExplicitTop = 40
            ExplicitWidth = 65
            ExplicitHeight = 65
          end
          object ShapeBannerFrame: TShape
            Left = 0
            Top = 0
            Width = 325
            Height = 229
            Align = alClient
            Brush.Style = bsClear
            Pen.Color = clRed
            Pen.Style = psDot
            ExplicitLeft = 8
            ExplicitTop = 16
            ExplicitWidth = 65
            ExplicitHeight = 65
          end
          object ImageBanner: TImage
            Left = 24
            Top = 27
            Width = 211
            Height = 137
            AutoSize = True
            Visible = False
          end
        end
        object PanelBannerEdit: TPanel
          Left = 0
          Top = 229
          Width = 325
          Height = 56
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 1
          object LabelBannerInfo: TLabel
            Left = 13
            Top = 3
            Width = 115
            Height = 13
            Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1073#1072#1085#1077#1088#1077':'
          end
          object ButtonBannerLoad: TButton
            Left = 0
            Top = 22
            Width = 75
            Height = 25
            Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1073#1072#1085#1077#1088
            Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
            TabOrder = 0
            OnClick = ButtonBannerLoadClick
          end
          object ButtonBannerSave: TButton
            Left = 81
            Top = 22
            Width = 75
            Height = 25
            Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1073#1072#1085#1077#1088
            Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
            Enabled = False
            TabOrder = 1
            OnClick = ButtonBannerSaveClick
          end
          object ButtonBannerClear: TButton
            Left = 162
            Top = 22
            Width = 75
            Height = 25
            Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1073#1072#1085#1077#1088
            Caption = #1054#1095#1080#1089#1090#1080#1090#1100
            Enabled = False
            TabOrder = 2
            OnClick = ButtonBannerClearClick
          end
          object ComboBoxBannerSize: TComboBox
            Left = 243
            Top = 24
            Width = 78
            Height = 21
            Hint = #1042#1099#1073#1086#1088' '#1088#1072#1079#1084#1077#1088#1072' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
            Style = csDropDownList
            Enabled = False
            ItemHeight = 13
            ItemIndex = 0
            TabOrder = 3
            Text = '200 x 60'
            OnChange = ComboBoxBannerSizeChange
            Items.Strings = (
              '200 x 60'
              '240 x 400')
          end
        end
      end
      object TabSheetFlash: TTabSheet
        Caption = 'TabSheetFlash'
        ImageIndex = 3
        object PanelFlashEdit: TPanel
          Left = 0
          Top = 229
          Width = 325
          Height = 56
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 1
          object LabelFlashInfo: TLabel
            Left = 13
            Top = 3
            Width = 107
            Height = 13
            Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1092#1083#1077#1096':'
          end
          object ButtonFlashLoad: TButton
            Left = 0
            Top = 22
            Width = 75
            Height = 25
            Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1092#1083#1077#1096
            Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
            TabOrder = 0
            OnClick = ButtonFlashLoadClick
          end
          object ButtonFlashSave: TButton
            Left = 81
            Top = 22
            Width = 75
            Height = 25
            Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1092#1083#1077#1096
            Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
            Enabled = False
            TabOrder = 1
            OnClick = ButtonFlashSaveClick
          end
          object ButtonFlashClear: TButton
            Left = 162
            Top = 22
            Width = 75
            Height = 25
            Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1092#1083#1077#1096
            Caption = #1054#1095#1080#1089#1090#1080#1090#1100
            Enabled = False
            TabOrder = 2
            OnClick = ButtonBannerClearClick
          end
          object ComboBoxFlashSize: TComboBox
            Left = 243
            Top = 24
            Width = 78
            Height = 21
            Hint = #1042#1099#1073#1086#1088' '#1088#1072#1079#1084#1077#1088#1072' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
            Style = csDropDownList
            Enabled = False
            ItemHeight = 13
            ItemIndex = 0
            TabOrder = 3
            Text = '200 x 60'
            OnChange = ComboBoxFlashSizeChange
            Items.Strings = (
              '200 x 60'
              '240 x 400')
          end
        end
        object PanelFlash: TPanel
          Left = 0
          Top = 0
          Width = 325
          Height = 229
          Align = alClient
          BevelOuter = bvNone
          Caption = #1053#1077#1090' '#1092#1083#1077#1096
          Color = clWindow
          ParentBackground = False
          TabOrder = 0
          OnResize = PanelFlashResize
          object ShapeFlash: TShape
            Left = 0
            Top = 0
            Width = 325
            Height = 229
            Align = alClient
            Brush.Style = bsClear
            Pen.Style = psDot
            ExplicitLeft = 32
            ExplicitTop = 40
            ExplicitWidth = 65
            ExplicitHeight = 65
          end
          object ShapeFlashFrame: TShape
            Left = 0
            Top = 0
            Width = 325
            Height = 229
            Align = alClient
            Brush.Style = bsClear
            Pen.Color = clRed
            Pen.Style = psDot
            ExplicitLeft = 8
            ExplicitTop = 16
            ExplicitWidth = 65
            ExplicitHeight = 65
          end
        end
      end
    end
  end
  object OpenBannerDialog: TOpenPictureDialog
    Filter = 'GIF Image (*.gif)|*.gif|JPG Image File (*.jpg)|*.jpg'
    Options = [ofEnableSizing]
    Left = 413
    Top = 79
  end
  object SaveBannerDialog: TSavePictureDialog
    Filter = 'GIF Image (*.gif)|*.gif|JPG Image File (*.jpg)|*.jpg'
    Options = [ofEnableSizing]
    Left = 517
    Top = 79
  end
  object OpenFlashDialog: TOpenDialog
    Filter = 'SWF Image (*.swf)|*.swf'
    Options = [ofEnableSizing]
    Left = 413
    Top = 143
  end
  object SaveFlashDialog: TSaveDialog
    DefaultExt = '.swf'
    Filter = 'SWF Image (*.swf)|*.swf'
    Options = [ofEnableSizing]
    Left = 517
    Top = 143
  end
end