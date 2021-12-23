unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus, UWP.Form,
  UWP.Caption, UWP.Classes, UWP.Button, UWP.Slider, UWP.Text, ComObj, ActiveX,
  UWP.QuickButton, UWP.ColorManager, ShellApi, settings, System.Actions,
  Vcl.ActnList, Registry, UWP.Panel, monitorHandler, System.ImageList,
  Vcl.ImgList, ES.BaseControls,
  ES.Switch, UWP.ListButton, Vcl.ComCtrls, madExceptVcl;

const
  WM_SHELLEVENT = WM_USER + 11;
  WM_RESIZEEVENT = WM_USER + 12;

type
  WinIsWow64 = function(aHandle: THandle; var Iret: BOOL): Winapi.Windows.BOOL; stdcall;
  
//  TUSlider = class (UCL.Slider.TUSlider)
//  private
//  //https://stackoverflow.com/questions/456488/how-to-add-mouse-wheel-support-to-a-component-descended-from-tgraphiccontrol/34463279#34463279
//    fPrevFocus: HWND;
//    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
//    procedure WMMouseMove(var Message: TWMMouseMove); message WM_MOUSEMOVE;
//  public
//    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
//    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
//    procedure MouseWheelHandler(var Message: TMessage); override;
//  published
//    property OnMouseWheel;
//    property OnMouseWheelDown;
//    property OnMouseWheelUp;
//  end;

  TVibranceInfo = record
    isInitialized: Boolean;
    activeOutput: Integer;
    defaultHandle: Integer;
    userVibranceSettingDefault: Integer;
    userVibranceSettingActive: Integer;
    szGPUName: string;
    shouldRun: Boolean;
    sleepInterval: Integer;
    displayHandles: array[0..100] of Integer; // let's assume user has a bunch of monitors xD
    affectPrimaryMonitorOnly: Boolean;
    neverChangeResolution: Boolean;
  end;

  TformMain = class(TUWPForm)
    TrayIcon1: TTrayIcon;
    PopupMenu1: TPopupMenu;
    Exit1: TMenuItem;
    Settings1: TMenuItem;
    N1: TMenuItem;
    About1: TMenuItem;
    UCaptionBar1: TUWPCaption;
    Timer1: TTimer;
    USlider1: TUWPSlider;
    UButton1: TUWPButton;
    UText1: TUWPLabel;
    UQuickButton1: TUWPQuickButton;
    UButton2: TUWPButton;
    USlider2: TUWPSlider;
    UText2: TUWPLabel;
    tmrHider: TTimer;
    ActionList1: TActionList;
    actEscape: TAction;
    tmr64HelperPersist: TTimer;
    UCaptionBar2: TUWPCaption;
    UPanel1: TUWPPanel;
    UPanel2: TUWPPanel;
    UText3: TUWPLabel;
    DarkerOverlay1: TMenuItem;
    UWPListButton1: TUWPListButton;
    UWPListButton2: TUWPListButton;
    actBlueLightToggle: TAction;
    UWPPanel1: TUWPPanel;
    UWPLabel1: TUWPLabel;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    UWPLabel2: TUWPLabel;
    MadExceptionHandler1: TMadExceptionHandler;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure USlider1Change(Sender: TObject);
    procedure UButton1Click(Sender: TObject);
    procedure UButton2Click(Sender: TObject);
    procedure USlider1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure USlider2Change(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Settings1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure tmrHiderTimer(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actEscapeExecute(Sender: TObject);
    procedure tmr64HelperPersistTimer(Sender: TObject);
    procedure USlider3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure UCaptionBar2DblClick(Sender: TObject);
    procedure USlider3MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure USlider3Change(Sender: TObject);
    procedure DarkerOverlay1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure UWPListButton1Click(Sender: TObject);
    procedure UWPListButton2Click(Sender: TObject);
    procedure actBlueLightToggleExecute(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
  protected
    { Protected declarations : known to all classes in the hierearchy}
    function GetMainTaskbarPosition:Integer;
    procedure ShowPopup;
    procedure CreateParams(var Params: TCreateParams); override;
  private
    { Private declarations : only known to the parent class }
    fPrevBrightness: Cardinal;
    fPrevContrast: Cardinal;
    FNotNVIDIA: Boolean;
    fNoFullScreenVibrance: Cardinal;
    fNoFullScreenGamma: Cardinal;

    procedure WMHotkey(var Msg: TWMHotKey); message WM_HOTKEY;
    procedure ShellEvent(var Msg: TMessage); message WM_SHELLEVENT;
    procedure ResizeEvent(var Msg: TMessage); message WM_RESIZEEVENT;
    function Is64bits: Boolean;
    procedure RunWinEvent;

    function SetDisplayGamma(AGammaValue: Byte): Boolean;
  public
    Settings: TSettings;
    { Public declarations : known externally by class users}
    procedure SetHotKey(Sender: TObject; AHotKey: TShortCut);
    function AutoStartState:Boolean;
    procedure SetAutoStart(RunWithWindows: Boolean);
    function GetScreenBrightness(monNum: Integer = 0): Integer;
  end;

var
  formMain: TformMain;
  prevRect: TRect;
  hook: NativeUInt;
  Monitors: TMonitorSettings;
  VibranceInfos: TVibranceInfo;

function RunHook(aHandle: HWND): BOOL; stdcall;
  external 'SystemHooks.dll' name 'RunHook';
function KillHook: BOOL; stdcall;
  external 'SystemHooks.dll' name 'KillHook';
implementation

{$R *.dfm}
uses frmSettings, utils, frmDarkOverlay, nvapi;

procedure SetBrightness(Timeout: Integer; Brightness: Byte);
var
  FSWbemLocator: OleVariant;
  FWMIService: OleVariant;
  FWbemObjectSet: OleVariant;
  FWbemObject: OleVariant;
  oEnum: IEnumVariant;
  iValue: LongWord;
begin
  FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  FWMIService := FSWbemLocator.ConnectServer('localhost', 'root\WMI', '', '');
  FWbemObjectSet := FWMIService.ExecQuery('SELECT * FROM WmiMonitorBrightnessMethods Where Active=True', 'WQL', $00000020);
  oEnum := IUnknown(FWbemObjectSet._NewEnum) as IEnumVARIANT;
  while oEnum.Next(1, FWbemObject, iValue) = 0 do
  begin
    FWbemObject.WmiSetBrightness(Timeout, Brightness);
    FWbemObject := Unassigned;
  end;
end;

function GetBrightness(Timeout: Integer): Integer;
var
  FSWbemLocator: OleVariant;
  FWMIService: OleVariant;
  FWbemObjectSet: OleVariant;
  FWbemObject: OleVariant;
  oEnum: IEnumVariant;
  iValue: LongWord;
begin
  FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  FWMIService := FSWbemLocator.ConnectServer('localhost', 'root\WMI', '', '');
  FWbemObjectSet := FWMIService.ExecQuery('SELECT * FROM WmiMonitorBrightnessMethods Where Active=True', 'WQL', $00000020);
  oEnum := IUnknown(FWbemObjectSet._NewEnum) as IEnumVARIANT;
  while oEnum.Next(1, FWbemObject, iValue) = 0 do
  begin
    Result := FWbemObject.Properties['CurrentBrightness'].Value;
    FWbemObject := Unassigned;
  end;
end;

procedure TformMain.About1Click(Sender: TObject);
begin
  if formSettings.SwitchToPanel(formSettings.cardAbout) then
    formSettings.Show;
end;

procedure TformMain.actBlueLightToggleExecute(Sender: TObject);
begin
  UWPListButton1Click(Sender);
end;

procedure TformMain.actEscapeExecute(Sender: TObject);
begin
  Hide;
end;

function TformMain.AutoStartState: Boolean;
var
  reg: TRegistry;
begin
  Result := False;
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CURRENT_USER;
    reg.OpenKeyReadOnly('SOFTWARE\Microsoft\Windows\CurrentVersion\Run');
    if reg.ValueExists('MonitorXettings') then
      if reg.ReadString('MonitorXettings') <> '' then
        Result := True;
    reg.CloseKey;
  finally
    reg.Free;
  end;
end;

procedure TformMain.CreateParams(var Params: TCreateParams);
begin
  inherited;

  Params.WinClassName := 'MonitorXettingsHwnd';
end;

procedure TformMain.DarkerOverlay1Click(Sender: TObject);
begin
  DarkerOverlay1.Checked := not DarkerOverlay1.Checked;
  if DarkerOverlay1.Checked then
  begin
    formDarker.Show;
  end
  else
  begin
    formDarker.Hide;
  end;
end;

procedure TformMain.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TformMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  DarkerOverlay1.Checked := False;
  formDarker.Hide;
end;

procedure TformMain.FormCreate(Sender: TObject);
var
  mons: array[0..5] of PHYSICAL_MONITOR;
  monitor: TMonitor;
  num: DWORD;
  I: Integer;
  min, max, cur: Cardinal;
//  value: MINIMIZEDMETRICS;

  res: NvAPI_Status;
begin
//  FluentEnabled := True;
  AlphaBlend := True;
  Color := clBlack;
//  value.cbSize := SizeOf(MINIMIZEDMETRICS);
//  value.iArrange := ARW_HIDE;
//  SystemParametersInfo(SPI_SETMINIMIZEDMETRICS, SizeOf(value), @value, SPIF_UPDATEINIFILE or SPIF_SENDCHANGE);
  Settings := TSettingsHandler.LoadSettings;
  SetHotKey(Sender, TextToShortCut(Settings.HotKey));

  ColorizationManager.ColorizationType := ctDark;
  UCaptionBar1.Caption := '   ' + Caption;

  Monitors := TMonitorSettings.Create;

  monitor := Screen.MonitorFromWindow(Handle);
  if GetNumberOfPhysicalMonitorsFromHMONITOR(monitor.Handle, @num) then
  begin
    if GetPhysicalMonitorsFromHMONITOR(monitor.Handle, num, @mons) then
    begin
      for I := 0 to num - 1 do
      begin
        GetMonitorBrightness(mons[I].hPhysicalMonitor, @min, @cur, @max);
        UCaptionBar1.Caption := '   ' + mons[I].szPhysicalMonitorDescription;
        USlider1.Min := min;
        USlider1.Max := max;
        USlider1.Value := cur;
        USlider1Change(Sender);
        GetMonitorContrast(mons[I].hPhysicalMonitor, @min, @cur, @max);
        USlider2.Min := min;
        USlider2.Max := max;
        USlider2.Value := cur;
        USlider2Change(Sender);
//        SetMonitorBrightness(mons[I].hPhysicalMonitor,round( min+(max-min)*(100/100)));
      end;

    end;
    DestroyPhysicalMonitors(num, @mons);
  end;

  Application.OnDeactivate := FormDeactivate;

  // Hook WH_SHELL
  RunHook(Handle);
  // Run hook helper if 64 bit Windows
  if Is64bits then
  begin
    ShellExecute(Handle, PChar('OPEN'),PChar(ExtractFilePath(ParamStr(0))+'SystemHooks64.exe'),nil,nil,SW_SHOWNOACTIVATE);
    // let's persist so if someone kills this process, we launch it again
    tmr64HelperPersist.Enabled := True;
  end
  else
  begin
    tmr64HelperPersist.Enabled := False;
    // hook winevent here since it requires to be a process similar to OS
    // otherwise it won't work
    RunWinEvent;
  end;

  // Get Vibrance status
  res := NvAPI_Initialize;
  if res <> NVAPI_OK then
    FNotNVIDIA := True;

  var dvcinfo: NV_DISPLAY_DVC_INFO;
  dvcinfo.version := SizeOf(NV_DISPLAY_DVC_INFO) or $10000;


  var gpus: TNvPhysicalGPUHandleArray;
  var gcnt: LongWord;
  var gpuname: NVAPI_SHORTSTRING;
  var gputemp: tnvgputhermalsettings;
  var gputype: NV_SYSTEM_TYPE;

  if NvAPI_EnumPhysicalGPUs(gpus, gcnt) = NVAPI_OK then
  begin
    for I := 0 to gcnt - 1 do
    begin
      if NvAPI_GPU_GetFullName(gpus[I], gpuname) = NVAPI_OK then
      begin
        //UCaptionBar1.Caption := UCaptionBar1.Caption + ' ' + gpuname;
        FillChar(gputemp, SizeOf(gputemp), 0);
        gputemp.version := NV_GPU_THERMAL_SETTINGS_VER;
        res := NvAPI_GPU_GetThermalSettings(gpus[I], 0, @gputemp);
        if res = NVAPI_OK then
        begin
          UWPLabel2.Caption := gpuname + #13#10'GPU Temp: ' + IntToStr(gputemp.sensor[0].currentTemp) + 'º C';
        end;

        if NvAPI_GPU_GetSystemType(gpus[I], gputype) = NVAPI_OK then
        begin
          if gputype = NV_SYSTEM_TYPE_UNKNOWN then
          begin
            // error
            VibranceInfos.isInitialized := False;
            UWPLabel1.Caption := 'No Vibrance';
          end
          else
          begin
            // let's continue
            var def: Cardinal := 0;
            var indx: Integer;
            var EOE: Boolean := False;
            repeat
              def := 0;
              res := NvAPI_EnumNvidiaDisplayHandle(indx, def);
              if (res <> NVAPI_OK) and (res = NVAPI_END_ENUMERATION) then
              begin
                // def = -1 error
                EOE := True; //End Of Enumeration
              end
              else
              begin
                VibranceInfos.displayHandles[indx] := def;

                if NvAPI_GetDVCInfo(def, 0, dvcinfo) = NVAPI_OK then
                begin
                  TrackBar1.Min := dvcinfo.minLevel;
                  TrackBar1.Max := dvcinfo.maxLevel;
                  TrackBar1.Position := dvcinfo.currentLevel;
                end;

                NvAPI_SetDVCLevel(def, 0, 0);

               // NvAPI_GetAssociatedNvidiaDisplayHandle(
              end;
              Inc(indx);
            until (EOE = True);
          end;
        end;

      end;
    end;
  end;

  // hide panel 1 since native access now is impossible, at least on my current monitors
  UPanel1.Visible := False;
  Height := Height - UPanel1.Height;
end;

procedure TformMain.FormDeactivate(Sender: TObject);
var
  TaskbarHandle: THandle;
begin
  TaskbarHandle := FindWindow('Shell_TrayWnd', nil);
  if TaskbarHandle <> 0 then
  begin
    if (GetForegroundWindow <> Handle)
    and (GetForegroundWindow <> TaskbarHandle) then
    Hide;
    if GetForegroundWindow = TaskbarHandle then
      tmrHider.Enabled := True;
  end;
end;

procedure TformMain.FormDestroy(Sender: TObject);
begin
  // restore vibrance
  if not FNotNVIDIA then
  begin
    NvAPI_SetDVCLevel(VibranceInfos.displayHandles[0], 0, 0);
  end;
  // restore default gamma value (128)
  SetDisplayGamma(128);

  if Is64bits then
  begin
    UnhookWinEvent(hook);
    CoUninitialize;
  end;

  KillHook;
  try
    Settings.Free;
  except

  end;

  if GlobalFindAtom('MXHOTKEY') <> 0 then
  begin
    UnregisterHotKey(Handle, GlobalFindAtom('MXHOTKEY'));
    GlobalDeleteAtom(GlobalFindAtom('MXHOTKEY'));
  end;

  if Is64bits then
  begin
    SendMessageTimeout(FindWindow('MonitorXettings64Hwnd', nil),WM_CLOSE,0,0,SMTO_NORMAL or SMTO_ABORTIFHUNG,500,0);
  end;

  Monitors.Free;
end;

procedure TformMain.FormShow(Sender: TObject);
begin
  // hide from taskbar on form show, form will not be hidden btw
  ShowWindow(Application.Handle, SW_HIDE);
end;

function TformMain.GetMainTaskbarPosition: Integer;
const ABNONE = -1;
var
  AMonitor: TMonitor;
  TaskbarHandle: THandle;
  ABData: TAppbarData;
  Res: HRESULT;
  TaskbarRect: TRect;
begin
  Result := ABNONE;
  ABData.cbSize := SizeOf(TAppbarData);
  Res := SHAppBarMessage(ABM_GETTASKBARPOS, ABData);
  if BOOL(Res) then
  begin
    // return ABE_LEFT=0, ABE_TOP, ABE_RIGHT or ABE_BOTTOM values
    Result := ABData.uEdge;
  end
  else // for some unknown this might fail, so lets do it the hard way
  begin
    TaskbarHandle := FindWindow('Shell_TrayWnd', nil);
    if TaskbarHandle <> 0 then
    begin
      AMonitor := Screen.MonitorFromWindow(TaskbarHandle);
      GetWindowRect(TaskbarHandle, TaskbarRect);
      if (AMonitor.Left = TaskbarRect.Left) and (AMonitor.Top = TaskbarRect.Top)
      and (AMonitor.Width = TaskbarRect.Width)
      then
        Result := ABE_TOP
      else if (AMonitor.Left + AMonitor.Width = TaskbarRect.Right)
      and (AMonitor.Width <> TaskbarRect.Width)
      then
        Result := ABE_RIGHT
      else if (AMonitor.Left = TaskbarRect.Left) and (AMonitor.Top + AMonitor.Height = TaskbarRect.Bottom)
      and (AMonitor.Width = TaskbarRect.Width)
      then
        Result := ABE_BOTTOM
      else
        Result := ABE_LEFT;
    end;
    // at this point, there is no Taskbar present, maybe explorer is not running
  end;
end;

function TformMain.GetScreenBrightness(monNum: Integer): Integer;
type
  TRGBALine = array[Word] of TRGBQuad;
  PRGBALine = ^TRGBALine;
var
  dc: HDC;
  bmp: HBITMAP;
  tempdc: HDC;
  gdiobj: HGDIOBJ;
  bits: prgbaline;
  bitmapinfo: TBitmapInfo;
  I: Integer;// absolute buffer;
begin
  dc := GetDC(0);
  bmp := CreateCompatibleBitmap(dc, Screen.Width, Screen.Height);
  tempdc := CreateCompatibleDC(dc);
  gdiobj := SelectObject(tempdc, bmp);

  BitBlt(tempdc, 0, 0, Screen.Width, Screen.Height, dc, 0, 0, SRCCOPY);
  //ZeroMemory(@bitmapinfo, SizeOf(TBitmapInfo));
  bitmapinfo.bmiHeader.biSize := SizeOf(BITMAPINFOHEADER);
  GetDIBits(tempdc, bmp, 0, Screen.Height, bits, bitmapinfo, DIB_RGB_COLORS);

  SelectObject(tempdc, gdiobj);
  DeleteObject(bmp);
  DeleteObject(gdiobj);
  DeleteDC(tempdc);
  DeleteDC(dc);
  //ReleaseDC(dc);
  for I := 0 to bitmapinfo.bmiHeader.biSizeImage do

end;

function TformMain.Is64bits: Boolean;
var
  HandleTo64bitprocess:  WinIsWow64;
  Iret: Winapi.Windows.BOOL;
begin
  Result := False;
  HandleTo64bitprocess := GetProcAddress(GetModuleHandle(kernel32), 'IsWow64Process');
  if Assigned(HandleTo64bitprocess) then
  begin
    if not HandleTo64bitprocess(GetCurrentProcess, Iret) then
      raise Exception.Create('Invalid Handle');
    Result := Iret;
  end;
end;

procedure TformMain.ResizeEvent(var Msg: TMessage);
var
  LHWindow: HWND;
begin
  LHWindow := GetForegroundWindow;
  if (LHWindow <> 0) and (LHWindow <> formDarker.Handle) then
  begin
    if DetectFullScreenApp(LHWindow) then
    begin
      //USlider3.Value := 220;
      //USlider2.Value := 50;
      if formSettings.chkTriggerOnFullScreen.Checked then
      begin
        TrackBar1.Position := StrToInt(formSettings.ledVibrance.Text);
        TrackBar2.Position := StrToInt(formSettings.ledGamma.Text);
      end;
      if DarkerOverlay1.Checked then
        formDarker.Hide;
    end
    else
    begin
      //USlider3.Value := 100;
      //USlider2.Value := 0;
      TrackBar1.Position := FNoFullScreenVibrance;
      TrackBar2.Position := FNoFullScreenGamma;
      if DarkerOverlay1.Checked then
      begin
        formDarker.Show;
        SendMessageTimeout(formDarker.Handle, WM_RESIZEEVENT, wParam(0), lParam(0), SMTO_ABORTIFHUNG or SMTO_NORMAL, 500, nil);
      end;
    end;
  end;
end;

procedure WinEventProc(hWinEventHook: NativeUInt; dwEvent: DWORD; handle: HWND;
  idObject, idChild: LONG; dwEventThread, dwmsEventTime: DWORD);
var
  LHWindow: HWND;
  LHFullScreen: BOOL;
  vRect: TRect;
  ParentHandle: HWND;
begin
  if (dwEvent = EVENT_OBJECT_LOCATIONCHANGE)
  or (dwEvent = EVENT_SYSTEM_FOREGROUND) then
  begin
    if GetForegroundWindow <> 0 then
    begin
      GetWindowRect(GetForegroundWindow, vRect);
      if prevRect <> vRect
      then
      begin
        prevRect := vRect;
        ParentHandle := FindWindow('MonitorXettingsHwnd', nil);
        if ParentHandle <> 0 then
            SendMessageTimeout(ParentHandle, WM_RESIZEEVENT, wParam(0), lParam(0), SMTO_ABORTIFHUNG or SMTO_NORMAL, 500, nil);
      end;
    end;
  end;
end;

procedure TformMain.RunWinEvent;
begin
  CoInitialize(nil);
  hook := SetWinEventHook(EVENT_MIN, EVENT_MAX, 0, @WinEventProc, 0, 0, WINEVENT_OUTOFCONTEXT or WINEVENT_SKIPOWNPROCESS );
  if hook = 0 then
    raise Exception.Create('Couldn''t create event hook');
end;

procedure TformMain.SetAutoStart(RunWithWindows: Boolean);
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CURRENT_USER;
    reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', False);
    if RunWithWindows then
      reg.WriteString('MonitorXettings', ParamStr(0))
    else
      if reg.ValueExists('MonitorXettings') then
        reg.DeleteValue('MonitorXettings');
    reg.CloseKey;
  finally
    reg.Free;
  end;
end;

function TformMain.SetDisplayGamma(AGammaValue: Byte): Boolean;
var
  GammaDC: HDC;
  GammaArray: array[0..2, 0..255] of Word;
  I, Value: Integer;
begin
  Result := False;
  GammaDC := GetDC(0);

  if GammaDC <> 0 then
  begin
    for I := 0 to 255 do
    begin
      Value := I * (AGammaValue + 128);
      if Value > 65535 then
        Value := 65535;
      GammaArray[0, I] := Value; // R value of I is mapped to brightness of Value
      GammaArray[1, I] := Value; // G value of I is mapped to brightness of Value
      GammaArray[2, I] := Value; // B value of I is mapped to brightness of Value
    end;
    // Note: BOOL will be converted to Boolean here.
    Result := SetDeviceGammaRamp(GammaDC, GammaArray);

    ReleaseDC(0, GammaDC);
  end;
end;

procedure TformMain.SetHotKey(Sender: TObject; AHotKey: TShortCut);
var
  key: WORD;
  modifier: Integer;
begin
  if Sender is TformMain then
    AHotKey := TextToShortCut(Settings.HotKey);
  key := AHotKey and not (scShift + scCtrl + scAlt);
  modifier := 0;
  if AHotKey and scShift <> 0 then modifier := MOD_SHIFT + MOD_NOREPEAT;
  if AHotKey and scAlt <> 0 then modifier := modifier + MOD_ALT;
  if AHotKey and scCtrl <> 0 then modifier := modifier + MOD_CONTROL;

  // re-register hotkey
  if GlobalFindAtom('MXHOTKEY') <> 0 then
  begin
    UnregisterHotKey(Handle, GlobalFindAtom('MXHOTKEY'));
    GlobalDeleteAtom(GlobalFindAtom('MXHOTKEY'));
  end;

  if not RegisterHotKey(Handle, GlobalAddAtom('MXHOTKEY'), modifier, key) then
  begin
    MessageDlg(ShortCutToText(AHotKey) + ' failed to register, try another hotkey.', mtError, [mbOK], 0);
  end
  else
  begin
    if Sender is TUWPButton then
    begin
      MessageDlg(ShortCutToText(AHotKey) + ' successfully registered.', mtInformation, [mbOK], 0);
      Settings.HotKey := ShortCutToText(AHotKey);
      TSettingsHandler.SaveSettings(formMain.Settings);
    end;
  end;
end;

procedure TformMain.Settings1Click(Sender: TObject);
begin
  formSettings.Visible := not formSettings.Visible;
end;

procedure TformMain.ShellEvent(var Msg: TMessage);
var
  title: string;
  titleLen: Integer;
  LHWindow: HWND;
begin
  LHWindow := Msg.WParam;
  if GetForegroundWindow = LHWindow then
  begin
    titleLen := GetWindowTextLength(LHWindow);
    if titleLen > 0 then
    begin
      SetLength(title, titlelen);
      GetWindowText(LHWindow, PChar(title), titleLen + 1);
      title := PChar(title);
      UCaptionBar1.Caption := title;
      TrayIcon1.Hint := title;
      //detect fullscreen
      //if not IsDirectXAppRunningFullScreen then
      begin
        if DetectFullScreenApp(LHWindow) then
        begin
          //USlider3.Value := 220;
          //USlider2.Value := 50;
          //TrackBar1.Position := 30;
        end
        else
          //USlider3.Value := 100;
          //USlider2.Value := 0;
          //TrackBar1.Position := 0;
      end;
    end;

  end;
end;

procedure TformMain.ShowPopup;
const
  ABE_NONE = -1;
  GAP = 0;
var
  TaskbarMonitor: THandle;
  TaskbarRect: TRect;
  AMonitor: TMonitor;
  CurPos: TPoint;
  LeftGap: Integer;
  TopGap: Integer;
begin
  TaskbarMonitor := FindWindow('Shell_TrayWnd', nil);
  GetCursorPos(CurPos);
  LeftGap := Width - ClientWidth;
  TopGap := Height - ClientHeight;
  if TaskbarMonitor <> 0 then
  begin
    AMonitor := Screen.MonitorFromWindow(TaskbarMonitor);
    GetWindowRect(TaskbarMonitor, TaskbarRect);
    case GetMainTaskbarPosition of
      ABE_LEFT: begin
        Left := AMonitor.Left + TaskbarRect.Width + GAP - LeftGap div 2;
        Top := CurPos.Y - Height div 2;
        end;
      ABE_TOP: begin
        Left := AMonitor.Left + AMonitor.Width - Width - GAP + LeftGap;
        Top := AMonitor.Top + TaskbarRect.Height + GAP - TopGap;
        end;
      ABE_RIGHT: begin
        Left := AMonitor.Left + AMonitor.Width - TaskbarRect.Width - Width - GAP + LeftGap div 2;
        Top := CurPos.Y - Height div 2;
        end;
      ABE_BOTTOM: begin
        Left := AMonitor.Left + AMonitor.Width - Width - GAP + LeftGap;
        Top := AMonitor.Top + AMonitor.Height - TaskbarRect.Height - Height - GAP + TopGap;
        end;
      ABE_NONE: begin
        Position := poScreenCenter;
        end;
    end;
  end;

  Visible := not Visible;
  SetForegroundWindow(Handle);
end;

procedure TformMain.Timer1Timer(Sender: TObject);
var
  changed: Boolean;
begin
//  GetScreenBrightness();
  changed := False;
  if fPrevBrightness <> USlider1.Value then
  begin
    fPrevBrightness := USlider1.Value;
    changed := True;
  end;
  if fPrevContrast <> USlider2.Value then
  begin
    changed := True;
    fPrevContrast := USlider2.Value;
  end;

  if changed then
    UButton2Click(Sender);
end;

procedure TformMain.tmr64HelperPersistTimer(Sender: TObject);
begin
  if FindWindow('MonitorXettings64Hwnd', nil) = 0 then
    ShellExecute(Handle, PChar('OPEN'),PChar(ExtractFilePath(ParamStr(0))+'SystemHooks64.exe'),nil,nil,SW_SHOWNOACTIVATE);
end;

procedure TformMain.tmrHiderTimer(Sender: TObject);
var
  TaskbarHandle: THandle;
begin
  if GetForegroundWindow = Handle then
    tmrHider.Enabled := False
  else
  begin
    TaskbarHandle := FindWindow('Shell_TrayWnd', nil);
    if TaskbarHandle <> 0 then
    begin
      if GetForegroundWindow <> TaskbarHandle then
      begin
        Hide;
        tmrHider.Enabled := False;
      end;
    end;
  end;
end;

procedure TformMain.TrackBar1Change(Sender: TObject);
begin
  NvAPI_SetDVCLevel(VibranceInfos.displayHandles[0], 0, TrackBar1.Position);
  UWPLabel1.Caption := TrackBar1.Position.ToString;
  if not DetectFullScreenApp(GetForegroundWindow) then
    fNoFullScreenVibrance := TrackBar1.Position;
end;

procedure TformMain.TrayIcon1Click(Sender: TObject);
begin
  if not Visible then
  begin
    StyleName := 'WinDark';
    ShowPopup
  end
  else
    Hide;
end;

procedure TformMain.UButton1Click(Sender: TObject);
begin

// old not working, at least not in non laptops
  try
    CoInitialize(nil);
    try
      GetBrightness(5);
    finally
      CoUninitialize;
    end;
  except
    on E:EOleException do
      ShowMessage(Format('EOleException %s %x', [E.Message, E.ErrorCode]));
    on E:Exception do
      ShowMessage(E.ClassName + ':' + E.Message);
  end;
end;

procedure TformMain.UButton2Click(Sender: TObject);
var
  mons: array[0..5] of PHYSICAL_MONITOR;
  monitor: TMonitor;
  num: DWORD;
  I: Integer;
  min, max, cur: Cardinal;
begin
  monitor := Screen.MonitorFromWindow(Handle);
  if GetNumberOfPhysicalMonitorsFromHMONITOR(monitor.Handle, @num) then
  begin
    if GetPhysicalMonitorsFromHMONITOR(monitor.Handle, num, @mons) then
    begin
      for I := 0 to num - 1 do
      begin
        GetMonitorBrightness(mons[I].hPhysicalMonitor, @min, @cur, @max);
        //ListBox1.Items.Add(FloatToStr((cur-min)/(max-min)*100));
        USlider1.Min := min;
        USlider1.Max := max;
//        USlider1.Value := cur;
        SetMonitorBrightness(mons[I].hPhysicalMonitor,round( min+(max-min)*(USlider1.Value/100)));
        SetMonitorContrast(mons[I].hPhysicalMonitor,round( min+(max-min)*(USlider2.Value/100)));
      end;
    end;
    DestroyPhysicalMonitors(num, @mons);
  end;

end;

procedure TformMain.UCaptionBar2DblClick(Sender: TObject);
begin
  SetDisplayGamma(128);
  Trackbar2.Position := 128;
  UText3.Caption := '128';
end;

procedure TformMain.USlider1Change(Sender: TObject);
begin
  UText1.Caption := 'Brightness: ' + USlider1.Value.ToString;
//  fPrevBrightness := USlider1.Value;
end;

procedure TformMain.USlider1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  UButton2Click(Sender);
end;

procedure TformMain.USlider2Change(Sender: TObject);
begin
  UText2.Caption := 'Contrast: ' + USlider2.Value.ToString;
//  fPrevContrast := USlider2.Value;
end;

procedure TformMain.USlider3Change(Sender: TObject);
begin
  SetDisplayGamma(Trackbar2.Position);
  UText3.Caption := Trackbar2.Position.ToString;
  if not DetectFullScreenApp(GetForegroundWindow) then
    fNoFullScreenGamma := TrackBar2.Position;
end;

procedure TformMain.USlider3MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SetDisplayGamma(Trackbar2.Position);
  UText3.Caption := Trackbar2.Position.ToString;
end;

procedure TformMain.USlider3MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  SetDisplayGamma(Trackbar2.Position);
  UText3.Caption := Trackbar2.Position.ToString;
end;

procedure TformMain.UWPListButton1Click(Sender: TObject);
var
  reg: TRegistry;
  buf: array of byte;
  vSize: Integer;
  I: Integer;
  J: Integer;
begin
  // TODO; check if Windows 10 is Creators Update build 15002 or newer
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CURRENT_USER;
    if reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\DefaultAccount\Current\default$windows.data.bluelightreduction.bluelightreductionstate\windows.data.bluelightreduction.bluelightreductionstate', False) then
    begin
      if reg.ValueExists('Data') then
      begin
        vSize := reg.GetDataSize('Data');
        if vSize > 0 then
        begin
          SetLength(buf, vSize);
          reg.ReadBinaryData('Data', buf[0], vSize);
          if buf[18] = $15 then // enabled
          begin
            UWPListButton1.FontIcon := '';
            UWPListButton1.Detail := 'OFF';
            // turn it off
            for I := 10 to 14 do
            begin
              if buf[I] <> $ff then
              begin
                buf[I] := buf[I] + 1;
                Break;
              end;
            end;
            buf[18] := $13;
            for I := 24 downto 23 do
              for J := I to vSize - 3 do
                buf[J] := buf[J + 1];
          end
          else if buf[18] = $13 then // disabled
          begin
            UWPListButton1.FontIcon := '';
            UWPListButton1.Detail := 'ON';
            // turn it on
            for I := 10 to 14 do
            begin
              if buf[I] <> $ff then
                begin
                  Inc(buf[I]);
                  Break;
                end;
            end;
            buf[18] := $15;
            for J := vSize - 1 downto 24 do
              buf[J] := buf[J - 1];
            for J := vSize - 1 downto 24 do
              buf[J] := buf[J - 1];
            buf[23] := $10;
            buf[24] := 0;
          end;
        end;
      end;
      // update registry
      reg.WriteBinaryData('Data', buf[0], vSize);
      reg.CloseKey;
    end;
  finally
    reg.Free;
  end;
end;

procedure TformMain.UWPListButton2Click(Sender: TObject);
begin
  ShellExecute(0, PChar('OPEN'), 'ms-settings:nightlight?activationSource=SMC-IA-4027563', nil, nil, SW_SHOWNORMAL);
end;

procedure TformMain.WMHotkey(var Msg: TWMHotKey);
var
  vMonitor: TMonitor;
begin
  if Msg.HotKey = GlobalFindAtom('MXHOTKEY') then
  begin
    if formSettings.Visible and formSettings.HotKey1.Focused then
    begin
      formSettings.HotKey1.HotKey := TextToShortCut(Settings.HotKey);
      Exit;
    end;

    vMonitor := Screen.MonitorFromWindow(Handle);
    Left := vMonitor.Left + (vMonitor.Width - Width) div 2;
    Top := vMonitor.Top + (vMonitor.Height - Height) div 2;
    if not Visible then
      Show
    else
      Hide;
    SetForegroundWindow(Handle);
  end;

end;

{ TUSlider }

//procedure TUSlider.CMMouseEnter(var Message: TMessage);
//begin
//  fPrevFocus := SetFocus(Parent.Handle);
//  MouseCapture := True;
//  inherited;
//end;
//
//function TUSlider.DoMouseWheelDown(Shift: TShiftState;
//  MousePos: TPoint): Boolean;
//begin
//  if Self.Value > Self.Min then
//  begin
//    Self.Value := Self.Value - 1;
//    //trigger changeevent
//  end;
//end;
//
//function TUSlider.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean;
//begin
//  if Self.Value < Self.Max then
//    Self.Value := Self.Value + 1;
//end;
//
//procedure TUSlider.MouseWheelHandler(var Message: TMessage);
//begin
//  Message.Result := Perform(CM_MOUSEWHEEL, Message.WParam, Message.LParam);
//  if Message.Result = 0 then
//    inherited MouseWheelHandler(Message);
//end;
//
//procedure TUSlider.WMMouseMove(var Message: TWMMouseMove);
//begin
//  if MouseCapture and not PtInRect(ClientRect, SmallPointToPoint(Message.Pos)) then
//  begin
//    MouseCapture := False;
//    SetFocus(fPrevFocus);
//  end;
//  inherited;
//end;

end.
