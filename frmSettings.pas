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
  public
    { Public declarations }
  end;

var
  formSettings: TformSettings;

implementation

{$R *.dfm}

procedure TformSettings.lbAboutClick(Sender: TObject);
begin
  CardPanel1.ActiveCard := cardAbout;
end;

procedure TformSettings.lbGeneralClick(Sender: TObject);
begin
  CardPanel1.ActiveCard := cardGeneral;
end;

procedure TformSettings.lbScheduleClick(Sender: TObject);
begin
  CardPanel1.ActiveCard := cardSchedule;
end;

procedure TformSettings.lbTriggersClick(Sender: TObject);
begin
  CardPanel1.ActiveCard := cardTriggers;
end;

end.
