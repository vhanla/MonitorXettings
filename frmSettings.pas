unit frmSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UCL.Form, UCL.Classes, UCL.QuickButton,
  Vcl.ExtCtrls, UCL.CaptionBar, UCL.ListButton, UCL.Panel, Vcl.WinXPanels,
  Vcl.StdCtrls, UCL.Text;

type
  TformSettings = class(TUForm)
    UCaptionBar1: TUCaptionBar;
    UQuickButton1: TUQuickButton;
    UPanel1: TUPanel;
    lbGeneral: TUListButton;
    lbTriggers: TUListButton;
    lbSchedule: TUListButton;
    lbAbout: TUListButton;
    CardPanel1: TCardPanel;
    cardGeneral: TCard;
    cardTriggers: TCard;
    cardSchedule: TCard;
    cardAbout: TCard;
    UText1: TUText;
    UText2: TUText;
    procedure lbAboutClick(Sender: TObject);
    procedure lbScheduleClick(Sender: TObject);
    procedure lbTriggersClick(Sender: TObject);
    procedure lbGeneralClick(Sender: TObject);
  private
    { Private declarations }
    fLockedPanel: Boolean; // lock to switch, maybe some changes needs saving before that
    { Public declarations }
  public
    { Public declarations }
    function SwitchToPanel(Panel: TCard): Boolean;
  end;

var
  formSettings: TformSettings;

implementation

{$R *.dfm}

procedure TformSettings.lbAboutClick(Sender: TObject);
begin
  SwitchToPanel(cardAbout);
end;

procedure TformSettings.lbGeneralClick(Sender: TObject);
begin
  SwitchToPanel(cardGeneral);
end;

procedure TformSettings.lbScheduleClick(Sender: TObject);
begin
  SwitchToPanel(cardSchedule);
end;

procedure TformSettings.lbTriggersClick(Sender: TObject);
begin
  SwitchToPanel(cardTriggers);
end;

function TformSettings.SwitchToPanel(Panel: TCard): Boolean;
begin
  Result := False;
  if not fLockedPanel then
  begin
    CardPanel1.ActiveCard := Panel;
    Result := True;
  end;
end;

end.
