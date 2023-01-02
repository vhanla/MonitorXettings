object formMain: TformMain
  Left = 0
  Top = 0
  AlphaBlendValue = 200
  BorderIcons = []
  Caption = 'I'
  ClientHeight = 349
  ClientWidth = 551
  Color = clBtnFace
  CustomTitleBar.Height = 1
  CustomTitleBar.SystemHeight = False
  CustomTitleBar.ShowCaption = False
  CustomTitleBar.ShowIcon = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  StyleElements = [seFont, seClient]
  StyleName = 'WinDark'
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  OnShow = FormShow
  TextHeight = 13
  object UPanel1: TPanel
    Left = 0
    Top = 41
    Width = 551
    Height = 137
    Align = alTop
    Color = 15132390
    TabOrder = 0
    object UText1: TUWPLabel
      AlignWithMargins = True
      Left = 9
      Top = 9
      Width = 538
      Height = 13
      Margins.Left = 8
      Margins.Top = 8
      Align = alTop
      Caption = 'UText1'
      ExplicitWidth = 35
    end
    object UText2: TUWPLabel
      AlignWithMargins = True
      Left = 9
      Top = 57
      Width = 538
      Height = 13
      Margins.Left = 8
      Margins.Top = 8
      Align = alTop
      Caption = 'UText1'
      ExplicitWidth = 35
    end
    object tbContrast: TTrackBar
      Left = 1
      Top = 73
      Width = 549
      Height = 24
      Align = alTop
      Max = 100
      Position = 23
      ShowSelRange = False
      TabOrder = 0
      TickStyle = tsNone
      OnChange = tbContrastChange
    end
    object tbBrightness: TTrackBar
      Left = 1
      Top = 25
      Width = 549
      Height = 24
      Margins.Top = 8
      Align = alTop
      Max = 100
      Position = 16
      ShowSelRange = False
      TabOrder = 1
      TickStyle = tsNone
      OnChange = tbBrightnessChange
    end
  end
  object UPanel2: TPanel
    Left = 0
    Top = 242
    Width = 551
    Height = 104
    Align = alTop
    Color = 15132390
    TabOrder = 1
    object UText3: TUWPLabel
      AlignWithMargins = True
      Left = 9
      Top = 9
      Width = 538
      Height = 13
      Margins.Left = 8
      Margins.Top = 8
      Align = alTop
      Caption = '128'
      ExplicitWidth = 18
    end
    object UWPLabel2: TUWPLabel
      Left = 348
      Top = 58
      Width = 54
      Height = 13
      Caption = 'UWPLabel2'
    end
    object UWPListButton1: TUWPListButton
      Left = 550
      Top = 58
      Width = 153
      Height = 31
      Caption = 'Night Light'
      TabOrder = 0
      Visible = False
      OnClick = UWPListButton1Click
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
      ImageIndex = 0
      FontIcon = #61580
      Detail = 'ON'
    end
    object btnAutoLevel: TUWPListButton
      Left = 9
      Top = 58
      Width = 152
      Height = 31
      Caption = 'Auto Level'
      TabOrder = 1
      OnClick = btnAutoLevelClick
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
      ImageIndex = 0
      FontIcon = #59315
      Detail = 'ON'
      SelectMode = smToggle
    end
    object tbGamma: TTrackBar
      Left = 1
      Top = 25
      Width = 549
      Height = 27
      Align = alTop
      Max = 255
      Position = 128
      ShowSelRange = False
      TabOrder = 2
      TickStyle = tsNone
      OnChange = USlider3Change
      OnTracking = tbGammaTracking
    end
    object chkFullTrigger: TUWPListButton
      Left = 176
      Top = 58
      Width = 153
      Height = 31
      Caption = 'Fullscreen'
      TabOrder = 3
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
      ImageIndex = 0
      FontIcon = #60535
      Detail = 'ON'
      SelectMode = smToggle
    end
  end
  object UWPPanel1: TPanel
    Left = 0
    Top = 178
    Width = 551
    Height = 64
    Align = alTop
    Color = 15132390
    TabOrder = 2
    object UWPLabel1: TUWPLabel
      AlignWithMargins = True
      Left = 9
      Top = 9
      Width = 538
      Height = 13
      Margins.Left = 8
      Margins.Top = 8
      Align = alTop
      Caption = 'Vibrance:'
      ExplicitWidth = 45
    end
    object tbVibrance: TTrackBar
      Left = 1
      Top = 25
      Width = 549
      Height = 24
      Margins.Left = 8
      Align = alTop
      ShowSelRange = False
      TabOrder = 0
      TickStyle = tsNone
      OnChange = tbVibranceChange
    end
  end
  object Button1: TButton
    Left = 270
    Top = 352
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 3
    Visible = False
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 32
    Top = 352
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 4
    Visible = False
    OnClick = Button2Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 551
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 5
    object selNormal: TUWPListButton
      Left = 0
      Top = 0
      Width = 185
      Height = 41
      Align = alLeft
      Caption = 'Normal Windows'
      TabOrder = 0
      OnClick = selNormalClick
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
      FontIcon = #62892
      Detail = ''
      SelectMode = smSelect
      Selected = True
    end
    object selFullscreen: TUWPListButton
      Left = 185
      Top = 0
      Width = 208
      Height = 41
      Align = alLeft
      Caption = 'Fullscreen Windows'
      TabOrder = 1
      OnClick = selFullscreenClick
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
      FontIcon = #60535
      Detail = ''
      SelectMode = smSelect
    end
    object btnSaveCustom: TUWPListButton
      Left = 393
      Top = 0
      Width = 152
      Height = 41
      Align = alLeft
      Caption = 'Save Custom '
      TabOrder = 2
      OnClick = btnSaveCustomClick
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
      FontIcon = #59214
      Detail = ''
    end
  end
  object TrayIcon1: TTrayIcon
    PopupMenu = PopupMenu1
    Visible = True
    OnClick = TrayIcon1Click
    Left = 216
    Top = 104
  end
  object PopupMenu1: TPopupMenu
    Left = 344
    object Settings1: TMenuItem
      Caption = '&Settings'
      OnClick = Settings1Click
    end
    object DarkerOverlay1: TMenuItem
      Caption = '&Darker Overlay'
      OnClick = DarkerOverlay1Click
    end
    object About1: TMenuItem
      Caption = '&About'
      OnClick = About1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Exit1: TMenuItem
      Caption = 'E&xit'
      OnClick = Exit1Click
    end
  end
  object Timer1: TTimer
    Interval = 250
    OnTimer = Timer1Timer
    Left = 88
    Top = 120
  end
  object tmrHider: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tmrHiderTimer
    Left = 424
  end
  object ActionList1: TActionList
    Left = 152
    object actEscape: TAction
      Caption = 'actEscape'
      ShortCut = 27
      OnExecute = actEscapeExecute
    end
    object actBlueLightToggle: TAction
      Caption = 'actBlueLightToggle'
      ShortCut = 66
      OnExecute = actBlueLightToggleExecute
    end
  end
  object tmr64HelperPersist: TTimer
    Interval = 3000
    OnTimer = tmr64HelperPersistTimer
    Left = 256
  end
  object MadExceptionHandler1: TMadExceptionHandler
    Left = 192
    Top = 192
  end
end
