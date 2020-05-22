library SystemHooks;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  Windows,
  Classes;

const
  MemMapFile = 'MonitorXettings';
  WM_USER = $0400;
  WM_COPYDATA = $004A;
  WM_SHELLEVENT = WM_USER + 11;

type
  PDLLGlobal = ^TDLLGLobal;
  TDLLGlobal = packed record
    HookHandle: HHOOK;
  end;

var
  GlobalData: PDLLGlobal;
  MMF: THandle;
  OwnerHandle: HWND;

{$R *.res}
function ShellProc(nCode: Integer; wParam: WPARAM; lParam: LPARAM): HRESULT; stdcall;
var
  LHWindow: HWND;
  LHFullScreen: BOOL;
  vRect: PRect;
  ParentHandle: HWND;
begin

  if nCode < 0 then
  begin
    Result := CallNextHookEx(GlobalData^.HookHandle, nCode, wParam, lParam);
    Exit;
  end
  else
  begin

    case nCode of
      // a top level window has been activated
      HSHELL_WINDOWACTIVATED:
      begin
  //      if IsWindow(LHWindow) then
        begin
          ParentHandle := FindWindow('MonitorXettingsHwnd', nil);
          if ParentHandle <> 0 then
            SendMessageTimeout(ParentHandle, WM_SHELLEVENT, wParam, lParam, SMTO_ABORTIFHUNG or SMTO_NORMAL, 500, nil);
        end;
      end;
      // a window is being maximized or minimized
      HSHELL_GETMINRECT:
      begin
  //      LHWindow := wParam; // its handle
  //      vRect := @lParam; // its rect pointer
  //      SendMessageTimeout(OwnerHandle, WM_SHELLEVENT, wParam, lParam, SMTO_ABORTIFHUNG or SMTO_NORMAL, 500, nil);
      end;
    end;
  end;

  Result := CallNextHookEx(GlobalData^.HookHandle, nCode, wParam, lParam);
end;

function RunHook(AHandle: HWND):BOOL; stdcall;
begin

  Result := False;
  OwnerHandle := AHandle;
  GlobalData^.HookHandle := SetWindowsHookEx(WH_SHELL, @ShellProc, HInstance, 0);

  if GlobalData^.HookHandle = INVALID_HANDLE_VALUE then Exit;
  Result := True;

end;

function KillHook:BOOL; stdcall;
begin

  Result := False;
  if (GlobalData <> nil) and (GlobalData^.HookHandle <> INVALID_HANDLE_VALUE) then
  begin
    Result := UnhookWindowsHookEx(GlobalData^.HookHandle);
    if not Result then // try once more
      Result := UnhookWindowsHookEx(GlobalData^.HookHandle);
  end;

end;

procedure CreateGlobalHeap;
begin

  MMF := CreateFileMapping(INVALID_HANDLE_VALUE, nil, PAGE_READWRITE, 0, SizeOf(TDLLGlobal), MemMapFile);

  if MMF = 0 then Exit;

  GlobalData := MapViewOfFile(MMF, FILE_MAP_ALL_ACCESS, 0, 0, SizeOf(TDLLGlobal));
  if GlobalData = nil then
    CloseHandle(MMF);

end;

procedure DeleteGlobalHeap;
begin

  if GlobalData <> nil then UnmapViewOfFile(GlobalData);

  if MMF <> INVALID_HANDLE_VALUE then CloseHandle(MMF);

end;

procedure DLLEntry(dwReason: DWORD);
begin

  case dwReason of
    DLL_PROCESS_ATTACH: CreateGlobalHeap;
    DLL_PROCESS_DETACH: DeleteGlobalHeap;
  end;

end;

exports
  RunHook,
  KillHook;

begin

  DllProc := @DllEntry;
  DLLEntry(DLL_PROCESS_ATTACH);

end.
