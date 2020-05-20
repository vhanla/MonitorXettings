unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus, UCL.Form,
  UCL.CaptionBar, UCL.Classes, UCL.Button, UCL.Slider, UCL.Text, ComObj, ActiveX,
  UCL.QuickButton, UCL.ThemeManager, ShellApi;

type
  PHYSICAL_MONITOR = record
    hPhysicalMonitor: THandle;
    szPhysicalMonitorDescription: array[0..127] of Char;
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

  TForm1 = class(TUForm)
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
  protected
    { Protected declarations : known to all classes in the hierearchy}
    function GetMainTaskbarPosition:Integer;
    procedure ShowPopup;
  private
    { Private declarations : only known to the parent class }
    fPrevBrightness: Cardinal;
    fPrevContrast: Cardinal;
  public
    { Public declarations : known externally by class users}
  end;

var
  Form1: TForm1;

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

procedure TForm1.About1Click(Sender: TObject);
begin
  if formSettings.SwitchToPanel(formSettings.cardAbout) then
    formSettings.Show;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  mons: array[0..5] of PHYSICAL_MONITOR;
  monitor: TMonitor;
  num: DWORD;
  I: Integer;
  min, max, cur: Cardinal;
begin
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
end;

procedure TForm1.FormDeactivate(Sender: TObject);
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

procedure TForm1.FormShow(Sender: TObject);
begin
  // hide from taskbar on form show, form will not be hidden btw
  ShowWindow(Application.Handle, SW_HIDE);
end;

function TForm1.GetMainTaskbarPosition: Integer;
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

procedure TForm1.Settings1Click(Sender: TObject);
begin
  formSettings.Visible := not formSettings.Visible;
end;

procedure TForm1.ShowPopup;
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

procedure TForm1.Timer1Timer(Sender: TObject);
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

procedure TForm1.tmrHiderTimer(Sender: TObject);
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

procedure TForm1.TrayIcon1Click(Sender: TObject);
begin
  if not Visible then
    ShowPopup
  else
    Hide;
end;

procedure TForm1.UButton1Click(Sender: TObject);
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

procedure TForm1.UButton2Click(Sender: TObject);
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

procedure TForm1.USlider1Change(Sender: TObject);
begin
  UText1.Caption := 'Brightness: ' + USlider1.Value.ToString;
//  fPrevBrightness := USlider1.Value;
end;

procedure TForm1.USlider1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  UButton2Click(Sender);
end;

procedure TForm1.USlider2Change(Sender: TObject);
begin
  UText2.Caption := 'Contrast: ' + USlider2.Value.ToString;
//  fPrevContrast := USlider2.Value;
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
