program MonitorXettings;

uses
  Vcl.Forms,
  Windows,
  SysUtils,
  main in 'main.pas' {Form1},
  frmSettings in 'frmSettings.pas' {formSettings},
  taskbar in 'taskbar.pas';

{$R *.res}

begin
  if CreateMutex(nil, True, '36D08603-E8AE-486C-BA20-9B27017C0D0D') = 0 then
    RaiseLastOSError;
  if GetLastError = ERROR_ALREADY_EXISTS then
    Exit;

  Application.Initialize;
  Application.MainFormOnTaskbar := False;
  Application.ShowMainForm := False;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TformSettings, formSettings);
  Application.Run;
end.
