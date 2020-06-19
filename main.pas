unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus, UCL.Form,
  UCL.CaptionBar, UCL.Classes, UCL.Button, UCL.Slider, UCL.Text, ComObj, ActiveX,
  UCL.QuickButton, UCL.ThemeManager, ShellApi, settings, System.Actions,
  Vcl.ActnList, Registry, UCL.Panel;

const
  WM_SHELLEVENT = WM_USER + 11;

type
  WinIsWow64 = function(aHandle: THandle; var Iret: BOOL): Winapi.Windows.BOOL; stdcall;
  PHYSICAL_MONITOR = record
    hPhysicalMonitor: THandle;
    szPhysicalMonitorDescription: array[0..127] of Char;
  end;

  TMonitorSetting = record
    Id: THandle;
    Name: array [0..127] of Char;
    Contrast: Integer;
    Brightness: Integer;
  end;

  TUSlider = class (UCL.Slider.TUSlider)
  private
  //https://stackoverflow.com/questions/456488/how-to-add-mouse-wheel-support-to-a-component-descended-from-tgraphiccontrol/34463279#34463279
    fPrevFocus: HWND;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure WMMouseMove(var Message: TWMMouseMove); message WM_MOUSEMOVE;
  public
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    procedure MouseWheelHandler(var Message: TMessage); override;
  published
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
  end;

  TformMain = class(TUForm)
    TrayIcon1: TTrayIcon;
    PopupMenu1: TPopupMenu;
    Exit1: TMenuItem;
    Settings1: TMenuItem;
    N1: TMenuItem;
    About1: TMenuItem;
    UCaptionBar1: TUCaptionBar;
    Timer1: TTimer;
    USlider1: TUSlider;
    UButton1: TUButton;
    UText1: TUText;
    UQuickButton1: TUQuickButton;
    UButton2: TUButton;
    USlider2: TUSlider;
    UText2: TUText;
    tmrHider: TTimer;
    ActionList1: TActionList;
    actEscape: TAction;
    tmr64HelperPersist: TTimer;
    UCaptionBar2: TUCaptionBar;
    UPanel1: TUPanel;
    UPanel2: TUPanel;
    USlider3: TUSlider;
    UText3: TUText;
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
  protected
    { Protected declarations : known to all classes in the hierearchy}
    function GetMainTaskbarPosition:Integer;
    procedure ShowPopup;
    procedure CreateParams(var Params: TCreateParams); override;
  private
    { Private declarations : only known to the parent class }
    fPrevBrightness: Cardinal;
    fPrevContrast: Cardinal;

    procedure WMHotkey(var Msg: TWMHotKey); message WM_HOTKEY;
    procedure ShellEvent(var Msg: TMessage); message WM_SHELLEVENT;
    function Is64bits: Boolean;

    function SetDisplayGamma(AGammaValue: Byte): Boolean;
  public
    Settings: TSettings;
    { Public declarations : known externally by class users}
    procedure SetHotKey(Sender: TObject; AHotKey: TShortCut);
    function AutoStartState:Boolean;
    procedure SetAutoStart(RunWithWindows: Boolean);
  end;

var
  formMain: TformMain;

function GetMonitorBrightness (
  hMonitor: THandle; var pdwMinimumBrightness : DWORD;
  var pdwCurrentBrightness : DWORD; var pdwMaximumBrightness : DWORD): BOOL; stdcall;
  external 'Dxva2.dll' name 'GetMonitorBrightness';

function SetMonitorBrightness (
  hMonitor: THandle; dwNewBrightness: DWORD): BOOL; stdcall;
  external 'Dxva2.dll' name 'SetMonitorBrightness';

function GetMonitorContrast (
  hMonitor: THandle; var pdwMinimumBrightness : DWORD;
  var pdwCurrentBrightness : DWORD; var pdwMaximumBrightness : DWORD): BOOL; stdcall;
  external 'Dxva2.dll' name 'GetMonitorContrast';

function SetMonitorContrast (
  hMonitor: THandle; dwNewBrightness: DWORD): BOOL; stdcall;
  external 'Dxva2.dll' name 'SetMonitorContrast';

function GetNumberOfPhysicalMonitorsFromHMONITOR(hMonitor: THandle;
  pdwNumberOfPhysicalMonitors: PDWORD): Boolean; stdcall;
  external 'Dxva2.dll' name 'GetNumberOfPhysicalMonitorsFromHMONITOR';

function GetPhysicalMonitorsFromHMONITOR(hMonitor: THandle;
  dwPhysicalMonitorArraySizwe: DWORD; pPhysicalMonitorArray: Pointer): Boolean; stdcall;
  external 'Dxva2.dll' name 'GetPhysicalMonitorsFromHMONITOR';

function DestroyPhysicalMonitors(dwPhysicalMonitorArraySize: DWORD;
  pPhysicalMonitorArray: Pointer): Boolean; stdcall;
  external 'Dxva2.dll' name 'DestroyPhysicalMonitors';

function RunHook(aHandle: HWND): BOOL; stdcall;
  external 'SystemHooks.dll' name 'RunHook';
function KillHook: BOOL; stdcall;
  external 'SystemHooks.dll' name 'KillHook';
implementation

{$R *.dfm}
uses frmSettings;

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

procedure TformMain.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TformMain.FormCreate(Sender: TObject);
var
  mons: array[0..5] of PHYSICAL_MONITOR;
  monitor: TMonitor;
  num: DWORD;
  I: Integer;
  min, max, cur: Cardinal;
//  value: MINIMIZEDMETRICS;
begin
//  value.cbSize := SizeOf(MINIMIZEDMETRICS);
//  value.iArrange := ARW_HIDE;
//  SystemParametersInfo(SPI_SETMINIMIZEDMETRICS, SizeOf(value), @value, SPIF_UPDATEINIFILE or SPIF_SENDCHANGE);
  Settings := TSettingsHandler.LoadSettings;
  SetHotKey(Sender, TextToShortCut(Settings.HotKey));

  ThemeManager.ThemeType := ttDark;
  UCaptionBar1.Caption := '   ' + Caption;
  monitor := Screen.MonitorFromWindow(Handle);
  if GetNumberOfPhysicalMonitorsFromHMONITOR(monitor.Handle, @num) then
  begin
    if GetPhysicalMonitorsFromHMONITOR(monitor.Handle, num, @mons) then
    begin
      for I := 0 to num - 1 do
      begin
        GetMonitorBrightness(mons[I].hPhysicalMonitor, min, cur, max);
        UCaptionBar1.Caption := '   ' + mons[I].szPhysicalMonitorDescription;
        USlider1.Min := min;
        USlider1.Max := max;
        USlider1.Value := cur;
        USlider1Change(Sender);
        GetMonitorContrast(mons[I].hPhysicalMonitor, min, cur, max);
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
    tmr64HelperPersist.Enabled := False;
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
  // restore default gamma value (128)
  SetDisplayGamma(128);

  KillHook;
  Settings.Free;

  if GlobalFindAtom('MXHOTKEY') <> 0 then
  begin
    UnregisterHotKey(Handle, GlobalFindAtom('MXHOTKEY'));
    GlobalDeleteAtom(GlobalFindAtom('MXHOTKEY'));
  end;

  if Is64bits then
  begin
    SendMessageTimeout(FindWindow('MonitorXettings64Hwnd', nil),WM_CLOSE,0,0,SMTO_NORMAL or SMTO_ABORTIFHUNG,500,0);
  end;
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
    if Sender is TUButton then
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
  title: array[0..255] of char;
  titleLen: Integer;
  LHWindow: HWND;
begin
  LHWindow := Msg.WParam;
  if GetForegroundWindow = LHWindow then
  begin
    titleLen := GetWindowTextLength(LHWindow);
    if titleLen > 0 then
    begin
      GetWindowText(LHWindow, title, titleLen + 1);
      UCaptionBar1.Caption := title;
      TrayIcon1.Hint := title;
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

procedure TformMain.TrayIcon1Click(Sender: TObject);
begin
  if not Visible then
    ShowPopup
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
        GetMonitorBrightness(mons[I].hPhysicalMonitor, min, cur, max);
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
  USlider3.Value := 128;
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

procedure TformMain.USlider3MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SetDisplayGamma(USlider3.Value);
  UText3.Caption := USlider3.Value.ToString;
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
    Show;
    SetForegroundWindow(Handle);
  end;

end;

{ TUSlider }

procedure TUSlider.CMMouseEnter(var Message: TMessage);
begin
  fPrevFocus := SetFocus(Parent.Handle);
  MouseCapture := True;
  inherited;
end;

function TUSlider.DoMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  if Self.Value > Self.Min then
  begin
    Self.Value := Self.Value - 1;
    //trigger changeevent
  end;
end;

function TUSlider.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean;
begin
  if Self.Value < Self.Max then
    Self.Value := Self.Value + 1;
end;

procedure TUSlider.MouseWheelHandler(var Message: TMessage);
begin
  Message.Result := Perform(CM_MOUSEWHEEL, Message.WParam, Message.LParam);
  if Message.Result = 0 then
    inherited MouseWheelHandler(Message);
end;

procedure TUSlider.WMMouseMove(var Message: TWMMouseMove);
begin
  if MouseCapture and not PtInRect(ClientRect, SmallPointToPoint(Message.Pos)) then
  begin
    MouseCapture := False;
    SetFocus(fPrevFocus);
  end;
  inherited;
end;

end.
