inherited BisAudioTextForm: TBisAudioTextForm
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = #1054#1079#1074#1091#1095#1082#1072' '#1090#1077#1082#1089#1090#1072
  ClientHeight = 316
  ClientWidth = 528
  FormStyle = fsStayOnTop
  ExplicitWidth = 544
  ExplicitHeight = 350
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar: TStatusBar
    Left = 0
    Top = 297
    Width = 528
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object GroupBoxAudio: TGroupBox
    Left = 8
    Top = 133
    Width = 283
    Height = 157
    Anchors = [akLeft, akBottom]
    Caption = ' '#1040#1091#1076#1080#1086' '
    TabOrder = 1
    object PanelAudio: TPanel
      AlignWithMargins = True
      Left = 7
      Top = 15
      Width = 269
      Height = 90
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
    end
    object PanelOptions: TPanel
      AlignWithMargins = True
      Left = 7
      Top = 110
      Width = 269
      Height = 40
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      object LabelGap: TLabel
        Left = 3
        Top = 13
        Width = 67
        Height = 13
        Alignment = taRightJustify
        Caption = #1055#1088#1086#1084#1077#1078#1091#1090#1086#1082':'
        FocusControl = EditGap
      end
      object EditGap: TEdit
        Left = 76
        Top = 10
        Width = 34
        Height = 21
        Hint = #1055#1088#1086#1084#1077#1078#1091#1090#1086#1082' '#1084#1077#1078#1076#1091' '#1086#1073#1088#1072#1079#1094#1072#1084#1080
        TabOrder = 0
        Text = '0'
        OnChange = EditGapChange
      end
      object UpDownGap: TUpDown
        Left = 110
        Top = 10
        Width = 17
        Height = 21
        Associate = EditGap
        Min = -999
        Max = 999
        TabOrder = 1
        Thousands = False
      end
      object TrackBarSpeed: TTrackBar
        Left = 133
        Top = 0
        Width = 132
        Height = 32
        Hint = #1057#1082#1086#1088#1086#1089#1090#1100
        Max = 100
        Min = 1
        PageSize = 10
        Frequency = 10
        Position = 50
        ShowSelRange = False
        TabOrder = 2
        TickMarks = tmTopLeft
        OnChange = TrackBarSpeedChange
      end
    end
  end
  object GroupBoxText: TGroupBox
    Left = 8
    Top = 4
    Width = 512
    Height = 128
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = ' '#1058#1077#1082#1089#1090' '
    TabOrder = 0
    object PanelText: TPanel
      AlignWithMargins = True
      Left = 7
      Top = 15
      Width = 498
      Height = 106
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object MemoText: TMemo
        Left = 0
        Top = 0
        Width = 498
        Height = 106
        Align = alClient
        TabOrder = 0
        OnChange = MemoTextChange
        OnKeyDown = MemoTextKeyDown
      end
    end
  end
  object GroupBoxPhrases: TGroupBox
    Left = 297
    Top = 133
    Width = 224
    Height = 157
    Anchors = [akLeft, akRight, akBottom]
    Caption = ' '#1060#1088#1072#1079#1099' '
    TabOrder = 2
    object PanelSamples: TPanel
      AlignWithMargins = True
      Left = 7
      Top = 15
      Width = 210
      Height = 135
      Margins.Left = 5
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object TreeView: TTreeView
        Left = 0
        Top = 0
        Width = 210
        Height = 135
        Align = alClient
        HideSelection = False
        Images = ImageList
        Indent = 19
        ReadOnly = True
        RightClickSelect = True
        TabOrder = 0
        ExplicitLeft = 48
        ExplicitTop = 40
        ExplicitWidth = 121
        ExplicitHeight = 97
      end
    end
  end
  object ImageList: TImageList
    Left = 160
    Top = 32
    Bitmap = {
      494C010105003400340010001000FFFFFFFFFF00FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
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
      000000000000000000000000000000000000000000000000000000000000D395
      7000CC835700C9764600CA7B4E00CB7B4E00CA7B4E00CA7B4E00CB7B4E00CB81
      5500CD865C000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CB82
      5600FCF3EC00FAF1E800FAF0E700FBF1E900FBF2EA00FBF2EA00FBF2EB00FDF4
      EE00CC8358000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CF82
      5300EFF1E700FFE9D900FFEADB00FFE9D900FFE7D700FFE5D200FFE2CB00EFF2
      E800CE8156000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CD85
      5500FBF5EE00FFE9D900FFEADB00FFE9D900FFE7D700FFE5D200FFE2CB00FBF6
      EF00CD8456000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CA84
      5200FFF7F100FFE9D900FFEADB00FFE9D900FFE7D700FFE5D200FFE2CB00FFF7
      F100CC8656000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E4BA
      9100FFF7F000FFE7D500FDE7D600FDE6D400FCE4D000FBE3CB00FADCC200FEF3
      E800CD8757000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E4BB
      9100FFF7F200FEE7D500FEE7D500FDE5D100FAE0CA00F9DEC400F7D9BC00FDF2
      E700CD8858000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E4BB
      9200FEF7F100FCE5D200FCE4D100FBE2CC00F9DDC400F6D7BB00F3D1AF00FAEF
      E400CD8859000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E4BB
      9200FEF6F000FCE2CD00FCE3CD00FADFC800F7D9BC00F5E9DD00FAF3EB00FBF8
      F300CB8454000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E4BB
      9300FEF5ED00FCDEC500FBE0C700F9DCC200F5D3B400FEF9F300FAE2C400ECC1
      9300DDB496000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E5BE
      9600FFFFFE00FDF3E900FDF3EA00FCF2E800FAEFE300FAF2E700EABB8800DEAA
      8800FCF8F6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000EAC3
      9D00E6BF9600E4BB9200E4BB9200D3A47200D2A27200D4A57600E2BDA200FDFA
      F900000000000000000000000000000000000000000000000000000000000000
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
      0000000000000000000080808000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080000000FF0000008000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080000000FFFF00008000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000080
      8000008080000080800000808000008080000080800000808000008080000080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000080000000FF000000FF00000080000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080000000FFFF0000FFFF000080000080808000000000000000
      00000000000000000000000000000000000000000000A2CAEE0076B2E6003E91
      DC00338CDA00338CDA00338CDA00338CDA00338CDA00338CDA00338CDA00338C
      DA00338BDA00388FDA0085B9E90000000000000000000000000000FFFF000000
      0000008080000080800000808000008080000080800000808000008080000080
      8000008080000000000000000000000000000000000000000000000000000000
      0000000000000080000000FF000000FF000000FF000000800000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080000000FFFF0000FFFF0000FFFF0000800000808080000000
      000000000000000000000000000000000000000000004799DD00DEF1FB00A8DE
      F5009EDBF40096DAF3008ED8F30086D7F3007FD4F20079D3F20072D2F1006CD0
      F10069CFF100C3EBF9003F95DC00000000000000000000000000FFFFFF0000FF
      FF00000000000080800000808000008080000080800000808000008080000080
      8000008080000080800000000000000000000000000000000000000000000000
      0000000000000080000000FF000000FF000000FF000000FF0000008000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000080000000FFFF0000FFFF0000FFFF0000FFFF00008000008080
      800000000000000000000000000000000000000000003B97DC00EFFAFE00A1E9
      F90091E5F80081E1F70072DEF60063DAF50054D7F40047D3F30039D0F2002ECD
      F10026CBF000CAF2FB003B97DC0000000000000000000000000000FFFF00FFFF
      FF0000FFFF000000000000808000008080000080800000808000008080000080
      8000008080000080800000808000000000000000000000000000000000000000
      0000000000000080000000FF000000FF000000FF000000FF000000FF00000080
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000080000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000080
      000080808000000000000000000000000000000000003B9DDB00F2FAFD00B3ED
      FA00A4E9F90095E6F80085E2F70076DEF60065DBF50057D7F40049D4F3003BD1
      F20030CEF100CCF2FB003B9BDC00000000000000000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080000000FF000000FF000000FF000000FF000000FF000000FF
      0000008000008080800000000000000000000000000000000000000000000000
      0000000000000080000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000800000808080000000000000000000000000003AA3DB00F6FCFE00C8F2
      FC00B9EFFB00ACECFA009CE8F9008BE3F7007CE0F6006CDCF6005DD9F5004FD6
      F40044D3F300D0F3FC003BA2DC0000000000000000000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF00000080000000000000000000000000000000000000000000000000
      0000000000000080000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF00008000000000000000000000000000003BA8DB00FEFFFF00F8FD
      FF00F6FDFF00F5FCFF00F3FCFE00D8F6FC0094E6F80085E3F70076DFF60068DB
      F5005CD8F400D7F4FC003BA7DC00000000000000000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080000000FF000000FF000000FF000000FF000000FF000000FF
      0000008000000000000000000000000000000000000000000000000000000000
      0000000000000080000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF00008000000000000000000000000000000000000039ADDB00E8F6FB0094D4
      EF0088CEEE0073C1E900C9E9F600F2FCFE00F3FCFE00F2FCFE00F0FCFE00EFFB
      FE00EEFBFE00FEFFFF003CAEDC0000000000000000000000000000FFFF00FFFF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080000000FF000000FF000000FF000000FF000000FF00000080
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000080
      0000000000000000000000000000000000000000000040AFDC00F1FAFD0094DE
      F50093DCF40081D5F2006ACAED006CCBEA0085D3EF0080D2EF007AD0EF0076CF
      EE0072CFEE00E9F7FB003DB2DC00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080000000FF000000FF000000FF000000FF0000008000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080000000FFFF0000FFFF0000FFFF0000FFFF00008000000000
      0000000000000000000000000000000000000000000041B4DD00F7FCFE008EE4
      F80091DEF5009FE0F500ACE1F600EFFBFE00F4FDFE00F3FCFE00F1FCFE00EFFB
      FE00EEFBFE00FBFEFF0058BDE100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080000000FF000000FF000000FF000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080000000FFFF0000FFFF0000FFFF0000800000000000000000
      000000000000000000000000000000000000000000003BB5DB00FDFEFE00FEFF
      FF00FEFEFF00FDFEFF00FEFFFF00EAF7FB006EC9E5006FC9E4006FC9E4006FC9
      E4007DCFE70084D1E800BAE5F300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080000000FF000000FF00000080000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080000000FFFF0000FFFF000080000000000000000000000000
      0000000000000000000000000000000000000000000059C2E00061C3E20063C4
      E30063C4E30063C4E30062C4E30056C0E000EDF9FC00F3FBFD00F3FBFD00F3FB
      FD00F3FBFD00F3FBFD00FCFEFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080000000FF0000008000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080000000FFFF00008000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000000000000000000000
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
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF00FFFF000000000000FFFF000000000000
      E007000000000000E007000000000000E007000000000000E007000000000000
      E007000000000000E007000000000000E007000000000000E007000000000000
      E007000000000000E007000000000000E007000000000000E00F000000000000
      FFFF000000000000FFFF000000000000FFFFFCFFFCFFFFFF800FF87FF87FFFFF
      8007F83FF83F80018003F81FF81F80018001F80FF80F80018000F807F8078001
      8000F803F8038001800FF803F8038001800FF807F8078001800FF80FF80F8001
      C7F8F81FF81F8001FFFCF83FF83F8001FFBAF87FF87F8001FFC7F8FFF8FFFFFF
      FFFFFDFFFDFFFFFFFFFFFFFFFFFFFFFF}
  end
  object ActionList: TActionList
    Images = ImageList
    Left = 104
    Top = 28
    object ActionLoad: TAction
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1092#1072#1081#1083' '#1080#1084#1087#1086#1088#1090#1072
      ImageIndex = 0
    end
    object ActionImport: TAction
      Caption = #1048#1084#1087#1086#1088#1090' '#1074#1089#1077#1093
      Hint = #1048#1084#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1074#1089#1077
      ImageIndex = 1
    end
    object ActionConnection: TAction
      Caption = '...'
      Hint = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1103
    end
    object ActionImportCurrent: TAction
      Caption = #1048#1084#1087#1086#1088#1090' '#1090#1077#1082#1091#1097#1077#1081
      Hint = #1048#1084#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1090#1077#1082#1091#1097#1091#1102' '#1079#1072#1087#1080#1089#1100
      ImageIndex = 2
    end
    object ActionInfo: TAction
      Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103
      Hint = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1080#1084#1087#1086#1088#1090#1091
    end
  end
  object Popup: TPopupActionBar
    Images = ImageList
    Left = 216
    Top = 38
    object N1: TMenuItem
      Action = ActionLoad
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object N2: TMenuItem
      Action = ActionImport
    end
    object N6: TMenuItem
      Action = ActionImportCurrent
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object N8: TMenuItem
      Action = ActionInfo
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object N4: TMenuItem
      Action = ActionConnection
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099
    end
  end
  object Timer: TTimer
    Enabled = False
    Interval = 750
    OnTimer = TimerTimer
    Left = 40
    Top = 40
  end
end