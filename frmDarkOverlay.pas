unit frmDarkOverlay;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

const
  WM_RESIZEEVENT = WM_USER + 12;

type
  TformDarker = class(TForm)
    Shape1: TShape;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure ResizeEvent(var Msg: TMessage); message WM_RESIZEEVENT;
  public
    { Public declarations }
  end;

var
  formDarker: TformDarker;

implementation

uses
  DwmApi;

{$R *.dfm}

procedure TformDarker.FormCreate(Sender: TObject);
var
  res: Integer;
begin
  DoubleBuffered := True;
  Shape1.Pen.Style := psClear;
  BorderStyle := bsNone;
  Color := clBlack;
  WindowState := wsMaximized;
  FormStyle := fsStayOnTop;
  AlphaBlend := True;
  AlphaBlendValue := 200;
  TransparentColor := True;
  TransparentColorValue := clWhite;
  Shape1.Visible := True;
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_TRANSPARENT or WS_EX_TOOLWINDOW);
  if DwmCompositionEnabled then
    DwmSetWindowAttribute(Handle, DWMWA_EXCLUDED_FROM_PEEK or DWMWA_FLIP3D_POLICY, @res, SizeOf(Integer));
end;

procedure TformDarker.FormShow(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TformDarker.ResizeEvent(var Msg: TMessage);
var
  r,s: TRect;
  fw: HWND;
begin
  fw := GetForegroundWindow;
  if fw <> 0 then
  begin
    if IsWindow(fw) then
    begin
      GetWindowRect(fw, s);
      Winapi.Windows.GetClientRect(fw, r);
//      case BorderStyle of
//        bsSingle:
//          Result := GetSystemMetrics(SM_CYFIXEDFRAME);
//
//        bsDialog, bsToolWindow:
//          Result := GetSystemMetrics(SM_CYDLGFRAME);
//
//        bsSizeable, bsSizeToolWin:
//          Result := GetSystemMetrics(SM_CYSIZEFRAME) +
//                    GetSystemMetrics(SM_CXPADDEDBORDER);
//        else
//          Result := 0;
//      end;
      Shape1.Left := s.Left + (s.Width - r.Width) div 2;
      Shape1.Top := s.Top + (GetSystemMetrics(SM_CYFIXEDFRAME)) div 2;
      Shape1.Width := r.Width;
      if GetWindowLong(fw, GWL_STYLE) and WS_CAPTION <> WS_CAPTION then
        Shape1.Height := s.Height
      else
        Shape1.Height := s.Height - (GetSystemMetrics(SM_CYSIZEFRAME) + GetSystemMetrics(SM_CXPADDEDBORDER));
    end;
  end;
end;

end.
