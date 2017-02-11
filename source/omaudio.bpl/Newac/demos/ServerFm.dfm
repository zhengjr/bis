object ServerForm: TServerForm
  Left = 0
  Top = 0
  Caption = 'Server'
  ClientHeight = 141
  ClientWidth = 472
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
  object LabelBytesRead: TLabel
    Left = 24
    Top = 88
    Width = 65
    Height = 13
    Caption = 'BytesRead: 0'
  end
  object LabelBytesPlay: TLabel
    Left = 144
    Top = 88
    Width = 72
    Height = 13
    Caption = 'BytesPlayed: 0'
  end
  object LabelInBitsPerSample: TLabel
    Left = 282
    Top = 53
    Width = 81
    Height = 13
    Caption = 'InBitsPerSample:'
  end
  object LabelInChannels: TLabel
    Left = 305
    Top = 80
    Width = 58
    Height = 13
    Caption = 'InChannels:'
  end
  object LabelInSampleRate: TLabel
    Left = 292
    Top = 106
    Width = 71
    Height = 13
    Caption = 'InSampleRate:'
  end
  object EditIp: TEdit
    Left = 40
    Top = 13
    Width = 121
    Height = 21
    TabOrder = 0
    Text = '0.0.0.0'
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
  object CheckBoxDecompress: TCheckBox
    Left = 280
    Top = 15
    Width = 97
    Height = 17
    Caption = 'Decompress'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object ButtonPause: TButton
    Left = 187
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Pause'
    TabOrder = 5
    OnClick = ButtonPauseClick
  end
  object EditBitsPerSample: TEdit
    Left = 376
    Top = 50
    Width = 49
    Height = 21
    TabOrder = 6
    Text = '16'
  end
  object EditChannels: TEdit
    Left = 376
    Top = 77
    Width = 49
    Height = 21
    TabOrder = 7
    Text = '2'
  end
  object EditSampleRate: TEdit
    Left = 376
    Top = 103
    Width = 49
    Height = 21
    TabOrder = 8
    Text = '44100'
  end
  object TrackBar: TTrackBar
    Left = 24
    Top = 101
    Width = 238
    Height = 32
    ShowSelRange = False
    TabOrder = 9
    TickMarks = tmBoth
    TickStyle = tsManual
    OnChange = TrackBarChange
  end
end