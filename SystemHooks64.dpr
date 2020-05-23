program SystemHooks64;

uses
  Vcl.Forms,
  Winapi.Windows,
  SysUtils,
  hookHelper64 in 'hookHelper64.pas' {Form1};

{$R *.res}

begin
  if CreateMutex(nil, True,'{C46E065E-6508-4829-A7FE-008AADC4C4A8}') = 0 then
    RaiseLastOSError;

  if GetLastError = ERROR_ALREADY_EXISTS then
    Exit;


  Application.Initialize;
  Application.MainFormOnTaskbar := False;
  Application.ShowMainForm := False;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
