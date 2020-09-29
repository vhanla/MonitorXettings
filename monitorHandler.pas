unit monitorHandler;

interface

uses
  Messages, Classes, Windows;

type

  TMonitorSettings = class(TObject)
  private
    FMsgHandlerHWND: HWND;
    procedure WndMethod(var AMsg: TMessage);
  public
    constructor Create;
    destructor Destroy; override;
  end;

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

{ TMonitorSettings }

constructor TMonitorSettings.Create;
begin
  inherited Create;

  FMsgHandlerHWND := AllocateHWnd(WndMethod);
end;

destructor TMonitorSettings.Destroy;
begin
  DeallocateHWnd(FMsgHandlerHWND);
  inherited;
end;

procedure TMonitorSettings.WndMethod(var AMsg: TMessage);
begin
// if AMsg.msg = WM_
//else
  AMsg.Result := DefWindowProc(FMsgHandlerHWND, AMsg.Msg, AMsg.WParam, AMsg.LParam);
end;

end.
