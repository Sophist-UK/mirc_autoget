object fMain: TfMain
  Left = 192
  Top = 231
  Width = 774
  Height = 534
  Caption = 'AutoGet 8'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Shell Dlg 2'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object barMain: TJvOutlookBar
    Left = 0
    Top = 0
    Width = 89
    Height = 481
    Align = alLeft
    Pages = <
      item
        Buttons = <>
        ButtonSize = olbsLarge
        Caption = 'Queues'
        DownFont.Charset = DEFAULT_CHARSET
        DownFont.Color = clWindowText
        DownFont.Height = -11
        DownFont.Name = 'MS Shell Dlg 2'
        DownFont.Style = []
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'MS Shell Dlg 2'
        Font.Style = []
        ParentColor = True
        TopButtonIndex = 0
      end
      item
        Buttons = <>
        ButtonSize = olbsLarge
        Caption = 'Lists'
        DownFont.Charset = DEFAULT_CHARSET
        DownFont.Color = clWindowText
        DownFont.Height = -11
        DownFont.Name = 'MS Shell Dlg 2'
        DownFont.Style = []
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'MS Shell Dlg 2'
        Font.Style = []
        ParentColor = True
        TopButtonIndex = 0
      end
      item
        Buttons = <>
        ButtonSize = olbsLarge
        Caption = 'Options'
        DownFont.Charset = DEFAULT_CHARSET
        DownFont.Color = clWindowText
        DownFont.Height = -11
        DownFont.Name = 'MS Shell Dlg 2'
        DownFont.Style = []
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'MS Shell Dlg 2'
        Font.Style = []
        ParentColor = True
        TopButtonIndex = 0
      end>
    TabOrder = 0
  end
  object StatusBar: TJvStatusBar
    Left = 0
    Top = 481
    Width = 766
    Height = 19
    Panels = <>
  end
  object MainPage: TPageControl
    Left = 89
    Top = 0
    Width = 677
    Height = 481
    Align = alClient
    TabOrder = 1
  end
end
