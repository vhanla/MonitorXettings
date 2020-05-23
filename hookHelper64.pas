unit hookHelper64;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

const
  WM_HELPER64 = WM_USER + 64;

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

function RunHook(aHandle: HWND): BOOL; stdcall;
  external 'SystemHooks64.dll' name 'RunHook';
function KillHook: BOOL; stdcall;
  external 'SystemHooks64.dll' name 'KillHook';
implementation

{$R *.dfm}

{ TForm1 }

procedure TForm1.CreateParams(var Params: TCreateParams);
begin
  inherited;

  Params.WinClassName := 'MonitoXettings64Hwnd';
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  if FindWindow('MonitorXettingsHwnd', nil) = 0 then
  begin
    MessageDlg('MonitorXettings is not runnig!', mtError, [mbOK], 0);
    Application.Terminate;
  end;
  RunHook(Handle);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  KillHook;
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
