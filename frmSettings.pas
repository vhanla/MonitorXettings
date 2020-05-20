unit frmSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UCL.Form, UCL.Classes, UCL.QuickButton,
  Vcl.ExtCtrls, UCL.CaptionBar, UCL.ListButton, UCL.Panel, Vcl.WinXPanels,
  Vcl.StdCtrls, UCL.Text, ES.BaseControls, ES.Switch, UCL.ScrollBox,
  Vcl.ComCtrls, UCL.Button, settings, Vcl.Menus;

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
    UScrollBox1: TUScrollBox;
    EsSwitch1: TEsSwitch;
    UText3: TUText;
    UText4: TUText;
    HotKey1: THotKey;
    btnSaveHotkey: TUButton;
    procedure lbAboutClick(Sender: TObject);
    procedure lbScheduleClick(Sender: TObject);
    procedure lbTriggersClick(Sender: TObject);
    procedure lbGeneralClick(Sender: TObject);
    procedure btnSaveHotkeyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EsSwitch1Click(Sender: TObject);
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
uses main;

procedure TformSettings.EsSwitch1Click(Sender: TObject);
begin
//  EsSwitch1.Checked := not EsSwitch1.Checked;
  formMain.SetAutoStart(EsSwitch1.Checked);
end;

procedure TformSettings.FormCreate(Sender: TObject);
begin
  HotKey1.HotKey := TextToShortCut(formMain.Settings.HotKey);
  EsSwitch1.Checked := formMain.AutoStartState;
end;

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

procedure TformSettings.btnSaveHotkeyClick(Sender: TObject);
begin
  formMain.SetHotKey(Sender,HotKey1.HotKey);
end;

end.
