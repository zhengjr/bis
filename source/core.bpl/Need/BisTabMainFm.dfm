inherited BisTabMainForm: TBisTabMainForm
  Left = 0
  Top = 0
  ClientHeight = 272
  ClientWidth = 523
  Font.Name = 'Tahoma'
  ExplicitWidth = 531
  ExplicitHeight = 306
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar: TStatusBar [0]
    Left = 0
    Top = 253
    Width = 523
    Height = 19
    Panels = <
      item
        Width = 250
      end
      item
        Width = 300
      end
      item
        Width = 100
      end
      item
        Width = 100
      end>
    ExplicitLeft = -129
    ExplicitTop = 322
    ExplicitWidth = 772
  end
  object PageControl: TPageControl [1]
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 517
    Height = 247
    Align = alClient
    TabOrder = 1
  end
  inherited TrayIcon: TTrayIcon
    Left = 48
    Top = 96
  end
  inherited ImageList: TImageList
    Left = 96
    Top = 96
  end
  inherited PopupActionBar: TPopupActionBar
    Left = 160
    Top = 96
  end
  object ApplicationEvents: TApplicationEvents
    OnHint = ApplicationEventsHint
    Left = 224
    Top = 96
  end
end