program MonitorXettings;

uses
  {$IFDEF DEBUG}
  FastMM4,
  {$ENDIF }
  Vcl.Forms,
  Windows,
  SysUtils,
  main in 'main.pas' {formMain},
  frmSettings in 'frmSettings.pas' {formSettings},
  taskbar in 'taskbar.pas',
  settings in 'settings.pas';

{$R *.res}

begin
  if CreateMutex(nil, True, '36D08603-E8AE-486C-BA20-9B27017C0D0D') = 0 then
    RaiseLastOSError;
  if GetLastError = ERROR_ALREADY_EXISTS then
    Exit;

  Application.Initialize;
  Application.MainFormOnTaskbar := False;
  Application.ShowMainForm := False;
  Application.CreateForm(TformMain, formMain);
  Application.CreateForm(TformSettings, formSettings);
  Application.Run;
end.
