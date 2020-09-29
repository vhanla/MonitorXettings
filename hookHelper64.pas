unit hookHelper64;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, ActiveX;

const
  WM_HELPER64 = WM_USER + 64;
  WM_RESIZEEVENT = WM_USER + 12;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    procedure GetMessage(var Msg: TMessage); message WM_HELPER64;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  prevRect: TRect;
  hook: NativeUInt;

function RunHook(aHandle: HWND): BOOL; stdcall;
  external 'SystemHooks64.dll' name 'RunHook';
function KillHook: BOOL; stdcall;
  external 'SystemHooks64.dll' name 'KillHook';
implementation

{$R *.dfm}

{ TForm1 }

procedure WinEventProc(hWinEventHook: NativeUInt; dwEvent: DWORD; handle: HWND;
  idObject, idChild: LONG; dwEventThread, dwmsEventTime: DWORD);
var
  LHWindow: HWND;
  LHFullScreen: BOOL;
  vRect: TRect;
  ParentHandle: HWND;
begin
  //if dwEvent = EVENT_SYSTEM_MOVESIZEEND then
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
//        if DetectFullScreenApp then
//          Form1.Memo1.Lines.Add('FullScreen enter');
      end;
    end;

  end;
end;


procedure TForm1.CreateParams(var Params: TCreateParams);
begin
  inherited;

  Params.WinClassName := 'MonitorXettings64Hwnd';
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  if FindWindow('MonitorXettingsHwnd', nil) = 0 then
  begin
    MessageDlg('MonitorXettings is not runnig!', mtError, [mbOK], 0);
    Application.Terminate;
  end;
  CoInitialize(nil);
  hook := SetWinEventHook(EVENT_MIN, EVENT_MAX, 0, @WinEventProc, 0, 0, WINEVENT_OUTOFCONTEXT or WINEVENT_SKIPOWNPROCESS );
  if hook = 0 then
    raise Exception.Create('Couldn''t create event hook');
  RunHook(Handle);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  KillHook;
  UnhookWinEvent(hook);
  CoUninitialize;
end;

procedure TForm1.GetMessage(var Msg: TMessage);
begin

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if FindWindow('MonitorXettingsHwnd', nil) = 0 then
    Close;
end;

end.
