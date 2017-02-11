object Form1: TForm1
  Left = 192
  Top = 114
  Caption = 'Sine Wave Generator'
  ClientHeight = 410
  ClientWidth = 625
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 32
    Width = 50
    Height = 13
    Caption = 'Frequency'
  end
  object Label2: TLabel
    Left = 16
    Top = 64
    Width = 40
    Height = 13
    Caption = 'Duration'
  end
  object SpinEdit1: TSpinEdit
    Left = 80
    Top = 24
    Width = 57
    Height = 22
    Increment = 50
    MaxValue = 10000
    MinValue = 50
    TabOrder = 0
    Value = 400
  end
  object SpinEdit2: TSpinEdit
    Left = 80
    Top = 56
    Width = 57
    Height = 22
    MaxValue = 10000
    MinValue = 1
    TabOrder = 1
    Value = 1
  end
  object Button1: TButton
    Left = 16
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Play'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 168
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 3
    OnClick = Button2Click
  end
  object DXAudioOut1: TDXAudioOut
    Input = StreamIn1
    OnDone = DXAudioOut1Done
    DeviceNumber = 0
    Latency = 100
    PrefetchData = True
    PollingInterval = 100
    FramesInBuffer = 24576
    SpeedFactor = 1.000000000000000000
    Left = 288
    Top = 120
  end
  object MemoryIn1: TMemoryIn
    InBitsPerSample = 16
    InChannels = 1
    InSampleRate = 8000
    RepeatCount = 1
    Left = 40
    Top = 136
  end
  object StreamOut1: TStreamOut
    Input = MemoryIn1
    Left = 120
    Top = 136
  end
  object StreamIn1: TStreamIn
    InBitsPerSample = 8
    InChannels = 1
    InSampleRate = 8000
    EndSample = -1
    Loop = False
    Seekable = False
    Left = 200
    Top = 136
  end
  object DSAudioOut1: TDSAudioOut
    Input = StreamIn1
    DeviceNumber = 0
    Calibrate = False
    Latency = 100
    SpeedFactor = 1.000000000000000000
    Left = 296
    Top = 192
  end
end