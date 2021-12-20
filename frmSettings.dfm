object formSettings: TformSettings
  Left = 0
  Top = 0
  Caption = 'Settings'
  ClientHeight = 403
  ClientWidth = 558
  Color = clBtnFace
  CustomTitleBar.Control = TitleBarPanel1
  CustomTitleBar.Enabled = True
  CustomTitleBar.Height = 31
  CustomTitleBar.BackgroundColor = 14051691
  CustomTitleBar.ForegroundColor = clWhite
  CustomTitleBar.InactiveBackgroundColor = clWhite
  CustomTitleBar.InactiveForegroundColor = 10066329
  CustomTitleBar.ButtonForegroundColor = clWhite
  CustomTitleBar.ButtonBackgroundColor = 14051691
  CustomTitleBar.ButtonHoverForegroundColor = 65793
  CustomTitleBar.ButtonHoverBackgroundColor = 14650510
  CustomTitleBar.ButtonPressedForegroundColor = 65793
  CustomTitleBar.ButtonPressedBackgroundColor = 15515327
  CustomTitleBar.ButtonInactiveForegroundColor = 10066329
  CustomTitleBar.ButtonInactiveBackgroundColor = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  GlassFrame.Enabled = True
  GlassFrame.Top = 31
  OldCreateOrder = False
  StyleElements = [seFont, seClient]
  StyleName = 'Windows10'
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object UCaptionBar1: TUWPCaption
    Left = 0
    Top = 0
    Width = 558
    Caption = '   Settings'
    Color = 14051691
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Accelerated = True
    CustomBackColor.Enabled = False
    CustomBackColor.Color = 15921906
    CustomBackColor.LightColor = 15921906
    CustomBackColor.DarkColor = 2829099
    ExplicitTop = -2
    object UQuickButton1: TUWPQuickButton
      Left = 513
      Top = 0
      CustomBackColor.Enabled = False
      CustomBackColor.Color = clBlack
      CustomBackColor.LightColor = 13619151
      CustomBackColor.DarkColor = 3947580
      ButtonStyle = qbsQuit
      Caption = #57610
      Align = alRight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe MDL2 Assets'
      Font.Style = []
      ParentFont = False
      ExplicitLeft = 344
      ExplicitTop = 16
    end
  end
  object UPanel1: TUWPPanel
    Left = 0
    Top = 62
    Width = 177
    Height = 341
    Align = alLeft
    Color = 15132390
    TabOrder = 1
    CustomBackColor.Enabled = False
    CustomBackColor.Color = 15132390
    CustomBackColor.LightColor = 15132390
    CustomBackColor.DarkColor = 2039583
    ExplicitTop = 32
    ExplicitHeight = 371
    object lbGeneral: TUWPListButton
      Left = 0
      Top = 0
      Width = 177
      Height = 41
      Align = alTop
      Caption = 'General'
      TabOrder = 0
      OnClick = lbGeneralClick
      IconFont.Charset = DEFAULT_CHARSET
      IconFont.Color = clWindowText
      IconFont.Height = -16
      IconFont.Name = 'Segoe MDL2 Assets'
      IconFont.Style = []
      CustomBackColor.Enabled = False
      CustomBackColor.LightNone = 15132390
      CustomBackColor.LightHover = 13619151
      CustomBackColor.LightPress = 12105912
      CustomBackColor.LightSelectedNone = 127
      CustomBackColor.LightSelectedHover = 103
      CustomBackColor.LightSelectedPress = 89
      CustomBackColor.DarkNone = 2039583
      CustomBackColor.DarkHover = 3487029
      CustomBackColor.DarkPress = 5000268
      CustomBackColor.DarkSelectedNone = 89
      CustomBackColor.DarkSelectedHover = 103
      CustomBackColor.DarkSelectedPress = 127
      FontIcon = #57621
      Detail = ''
    end
    object lbTriggers: TUWPListButton
      Left = 0
      Top = 41
      Width = 177
      Height = 41
      Align = alTop
      Caption = 'Triggers'
      TabOrder = 1
      OnClick = lbTriggersClick
      IconFont.Charset = DEFAULT_CHARSET
      IconFont.Color = clWindowText
      IconFont.Height = -16
      IconFont.Name = 'Segoe MDL2 Assets'
      IconFont.Style = []
      CustomBackColor.Enabled = False
      CustomBackColor.LightNone = 15132390
      CustomBackColor.LightHover = 13619151
      CustomBackColor.LightPress = 12105912
      CustomBackColor.LightSelectedNone = 127
      CustomBackColor.LightSelectedHover = 103
      CustomBackColor.LightSelectedPress = 89
      CustomBackColor.DarkNone = 2039583
      CustomBackColor.DarkHover = 3487029
      CustomBackColor.DarkPress = 5000268
      CustomBackColor.DarkSelectedNone = 89
      CustomBackColor.DarkSelectedHover = 103
      CustomBackColor.DarkSelectedPress = 127
      FontIcon = #59893
      Detail = ''
    end
    object lbSchedule: TUWPListButton
      Left = 0
      Top = 82
      Width = 177
      Height = 41
      Align = alTop
      Caption = 'Schedule'
      TabOrder = 2
      OnClick = lbScheduleClick
      IconFont.Charset = DEFAULT_CHARSET
      IconFont.Color = clWindowText
      IconFont.Height = -16
      IconFont.Name = 'Segoe MDL2 Assets'
      IconFont.Style = []
      CustomBackColor.Enabled = False
      CustomBackColor.LightNone = 15132390
      CustomBackColor.LightHover = 13619151
      CustomBackColor.LightPress = 12105912
      CustomBackColor.LightSelectedNone = 127
      CustomBackColor.LightSelectedHover = 103
      CustomBackColor.LightSelectedPress = 89
      CustomBackColor.DarkNone = 2039583
      CustomBackColor.DarkHover = 3487029
      CustomBackColor.DarkPress = 5000268
      CustomBackColor.DarkSelectedNone = 89
      CustomBackColor.DarkSelectedHover = 103
      CustomBackColor.DarkSelectedPress = 127
      FontIcon = #60870
      Detail = ''
    end
    object lbAbout: TUWPListButton
      Left = 0
      Top = 300
      Width = 177
      Height = 41
      Align = alBottom
      Caption = 'About'
      TabOrder = 3
      OnClick = lbAboutClick
      IconFont.Charset = DEFAULT_CHARSET
      IconFont.Color = clWindowText
      IconFont.Height = -16
      IconFont.Name = 'Segoe MDL2 Assets'
      IconFont.Style = []
      CustomBackColor.Enabled = False
      CustomBackColor.LightNone = 15132390
      CustomBackColor.LightHover = 13619151
      CustomBackColor.LightPress = 12105912
      CustomBackColor.LightSelectedNone = 127
      CustomBackColor.LightSelectedHover = 103
      CustomBackColor.LightSelectedPress = 89
      CustomBackColor.DarkNone = 2039583
      CustomBackColor.DarkHover = 3487029
      CustomBackColor.DarkPress = 5000268
      CustomBackColor.DarkSelectedNone = 89
      CustomBackColor.DarkSelectedHover = 103
      CustomBackColor.DarkSelectedPress = 127
      FontIcon = #59267
      Detail = ''
      ExplicitTop = 330
    end
    object UWPListButton1: TUWPListButton
      Left = 0
      Top = 123
      Width = 177
      Height = 41
      Align = alTop
      Caption = 'Monitors'
      TabOrder = 4
      IconFont.Charset = DEFAULT_CHARSET
      IconFont.Color = clWindowText
      IconFont.Height = -16
      IconFont.Name = 'Segoe MDL2 Assets'
      IconFont.Style = []
      CustomBackColor.Enabled = False
      CustomBackColor.LightNone = 15132390
      CustomBackColor.LightHover = 13619151
      CustomBackColor.LightPress = 8947848
      CustomBackColor.LightSelectedNone = 127
      CustomBackColor.LightSelectedHover = 103
      CustomBackColor.LightSelectedPress = 89
      CustomBackColor.DarkNone = 2039583
      CustomBackColor.DarkHover = 3487029
      CustomBackColor.DarkPress = 5000268
      CustomBackColor.DarkSelectedNone = 89
      CustomBackColor.DarkSelectedHover = 103
      CustomBackColor.DarkSelectedPress = 127
      FontIcon = #59380
      Detail = 'Detail'
    end
  end
  object CardPanel1: TCardPanel
    Left = 177
    Top = 62
    Width = 381
    Height = 341
    Align = alClient
    ActiveCard = cardTriggers
    BevelOuter = bvNone
    Caption = 'CardPanel1'
    Color = clWhite
    ParentBackground = False
    TabOrder = 2
    ExplicitTop = 32
    ExplicitHeight = 371
    object cardGeneral: TCard
      Left = 0
      Top = 0
      Width = 381
      Height = 341
      Caption = 'cardGeneral'
      CardIndex = 0
      TabOrder = 0
      ExplicitHeight = 371
      object UScrollBox1: TUWPScrollBox
        Left = 0
        Top = 0
        Width = 381
        Height = 341
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        Align = alClient
        Color = 15132390
        ParentColor = False
        TabOrder = 0
        AniSet.AniKind = akOut
        AniSet.AniFunctionKind = afkQuintic
        AniSet.DelayStartTime = 0
        AniSet.Duration = 120
        AniSet.Step = 11
        CustomBackColor.Enabled = False
        CustomBackColor.Color = 15132390
        CustomBackColor.LightColor = 15132390
        CustomBackColor.DarkColor = 2039583
        MaxScrollCount = 8
        ExplicitHeight = 371
        object UText3: TUWPLabel
          Left = 24
          Top = 32
          Width = 70
          Height = 13
          Caption = 'Run at startup'
        end
        object UText4: TUWPLabel
          Left = 24
          Top = 82
          Width = 78
          Height = 13
          Caption = 'Bring Up HotKey'
        end
        object EsSwitch1: TEsSwitch
          Left = 24
          Top = 51
          Width = 44
          Height = 20
          TabOrder = 1
          OnClick = EsSwitch1Click
        end
        object btnSaveHotkey: TUWPButton
          Left = 24
          Top = 142
          Width = 129
          Accelerated = True
          CustomBackColor.Enabled = False
          CustomBackColor.LightNone = 13421772
          CustomBackColor.LightHover = 13421772
          CustomBackColor.LightPress = 10066329
          CustomBackColor.LightSelectedNone = 13421772
          CustomBackColor.LightSelectedHover = 13421772
          CustomBackColor.LightSelectedPress = 10066329
          CustomBackColor.DarkNone = 3355443
          CustomBackColor.DarkHover = 3355443
          CustomBackColor.DarkPress = 6710886
          CustomBackColor.DarkSelectedNone = 3355443
          CustomBackColor.DarkSelectedHover = 3355443
          CustomBackColor.DarkSelectedPress = 6710886
          CustomBorderColor.Enabled = False
          CustomBorderColor.LightNone = 13421772
          CustomBorderColor.LightHover = 8026746
          CustomBorderColor.LightPress = 10066329
          CustomBorderColor.LightSelectedNone = 8026746
          CustomBorderColor.LightSelectedHover = 8026746
          CustomBorderColor.LightSelectedPress = 10066329
          CustomBorderColor.DarkNone = 3355443
          CustomBorderColor.DarkHover = 8750469
          CustomBorderColor.DarkPress = 6710886
          CustomBorderColor.DarkSelectedNone = 8750469
          CustomBorderColor.DarkSelectedHover = 8750469
          CustomBorderColor.DarkSelectedPress = 6710886
          Caption = 'Save/Apply Hotkey'
          OnClick = btnSaveHotkeyClick
        end
        object Hotkey1: TUWPHotkey
          Left = 24
          Top = 104
          Width = 329
          CustomBackColor.Enabled = False
          CustomBackColor.Color = clWhite
          CustomBackColor.LightColor = clWhite
          CustomBackColor.DarkColor = clBlack
          CustomBorderColor.Enabled = False
          CustomBorderColor.LightNone = 10066329
          CustomBorderColor.LightHover = 6710886
          CustomBorderColor.LightPress = 14120960
          CustomBorderColor.LightSelectedNone = 14120960
          CustomBorderColor.LightSelectedHover = 14120960
          CustomBorderColor.LightSelectedPress = 14120960
          CustomBorderColor.DarkNone = 6710886
          CustomBorderColor.DarkHover = 10066329
          CustomBorderColor.DarkPress = 14120960
          CustomBorderColor.DarkSelectedNone = 14120960
          CustomBorderColor.DarkSelectedHover = 14120960
          CustomBorderColor.DarkSelectedPress = 14120960
          HotKey = 32833
          TabOrder = 3
        end
      end
    end
    object cardTriggers: TCard
      Left = 0
      Top = 0
      Width = 381
      Height = 341
      Caption = 'cardTriggers'
      CardIndex = 1
      TabOrder = 1
      ExplicitHeight = 371
      object UText5: TUWPLabel
        Left = 24
        Top = 24
        Width = 334
        Height = 13
        Caption = 
          'List of windows by process to trigger custom brightness and cont' +
          'rast:'
      end
      object chkTriggerOnFullScreen: TCheckBox
        Left = 24
        Top = 65
        Width = 161
        Height = 17
        Caption = 'On Full Screen Apps'
        TabOrder = 0
      end
      object ledVibrance: TLabeledEdit
        Left = 48
        Top = 102
        Width = 89
        Height = 21
        EditLabel.Width = 169
        EditLabel.Height = 13
        EditLabel.Caption = 'Vibrance (min 0, max 63, default 0)'
        NumbersOnly = True
        TabOrder = 1
        Text = '0'
      end
      object ledGamma: TLabeledEdit
        Left = 48
        Top = 143
        Width = 89
        Height = 21
        EditLabel.Width = 185
        EditLabel.Height = 13
        EditLabel.Caption = 'Gamma: (min 0, max 255, default 128)'
        NumbersOnly = True
        TabOrder = 2
        Text = '128'
      end
    end
    object cardSchedule: TCard
      Left = 0
      Top = 0
      Width = 381
      Height = 341
      Caption = 'cardSchedule'
      CardIndex = 2
      TabOrder = 2
      ExplicitHeight = 371
    end
    object cardAbout: TCard
      Left = 0
      Top = 0
      Width = 381
      Height = 341
      Caption = 'cardAbout'
      CardIndex = 3
      TabOrder = 3
      ExplicitHeight = 371
      object UText1: TUWPLabel
        Left = 16
        Top = 14
        Width = 165
        Height = 19
        Caption = 'Monitor Settings X v1.0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object UText2: TUWPLabel
        Left = 16
        Top = 55
        Width = 170
        Height = 13
        Caption = 'Author: Victor Alberto Gil <vhanla>'
      end
    end
    object cardMonitors: TCard
      Left = 0
      Top = 0
      Width = 381
      Height = 341
      Caption = 'cardMonitors'
      CardIndex = 4
      TabOrder = 4
      ExplicitHeight = 371
    end
  end
  object TitleBarPanel1: TTitleBarPanel
    Left = 0
    Top = 32
    Width = 558
    Height = 30
    CustomButtons = <>
  end
end
