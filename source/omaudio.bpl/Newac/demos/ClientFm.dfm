object ClientForm: TClientForm
  Left = 0
  Top = 0
  Caption = 'Client'
  ClientHeight = 136
  ClientWidth = 710
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 16
    Width = 10
    Height = 13
    Caption = 'IP'
  end
  object Label2: TLabel
    Left = 176
    Top = 16
    Width = 20
    Height = 13
    Caption = 'Port'
  end
  object LabelBytesSent: TLabel
    Left = 24
    Top = 88
    Width = 62
    Height = 13
    Caption = 'BytesSent: 0'
  end
  object LabelInBitsPerSample: TLabel
    Left = 282
    Top = 53
    Width = 90
    Height = 13
    Caption = 'InBitsPerSample: 0'
  end
  object LabelInChannels: TLabel
    Left = 282
    Top = 80
    Width = 67
    Height = 13
    Caption = 'InChannels: 0'
  end
  object LabelInSampleRate: TLabel
    Left = 282
    Top = 106
    Width = 80
    Height = 13
    Caption = 'InSampleRate: 0'
  end
  object EditIp: TEdit
    Left = 40
    Top = 13
    Width = 121
    Height = 21
    TabOrder = 0
    Text = '127.0.0.1'
  end
  object EditPort: TEdit
    Left = 202
    Top = 13
    Width = 55
    Height = 21
    TabOrder = 1
    Text = '8888'
  end
  object ButtonStart: TButton
    Left = 24
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 2
    OnClick = ButtonStartClick
  end
  object ButtonStop: TButton
    Left = 105
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 3
    OnClick = ButtonStopClick
  end
  object EditSize: TEdit
    Left = 282
    Top = 13
    Width = 47
    Height = 21
    TabOrder = 4
    Text = '1024'
  end
  object CheckBoxCompress: TCheckBox
    Left = 335
    Top = 15
    Width = 74
    Height = 17
    Caption = 'Compress'
    Checked = True
    State = cbChecked
    TabOrder = 5
  end
  object ButtonPause: TButton
    Left = 187
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Pause'
    TabOrder = 6
    OnClick = ButtonPauseClick
  end
  object EditBitsPerSample: TEdit
    Left = 416
    Top = 50
    Width = 49
    Height = 21
    TabOrder = 7
    Text = '0'
  end
  object EditChannels: TEdit
    Left = 416
    Top = 77
    Width = 49
    Height = 21
    TabOrder = 8
    Text = '0'
  end
  object EditSampleRate: TEdit
    Left = 416
    Top = 103
    Width = 49
    Height = 21
    TabOrder = 9
    Text = '0'
  end
  object CheckBoxConvert: TCheckBox
    Left = 415
    Top = 15
    Width = 97
    Height = 17
    Caption = 'Convert'
    Checked = True
    State = cbChecked
    TabOrder = 10
    OnClick = CheckBoxConvertClick
  end
  object ProgressBar: TProgressBar
    Left = 24
    Top = 107
    Width = 238
    Height = 17
    TabOrder = 11
  end
end