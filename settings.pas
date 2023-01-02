unit settings;

interface

uses
  Classes, SysUtils, Rest.Json, Generics.Collections, Registry;

type

  TAppTrigger = class
  private
    fExecutable: string;
    fClassName: string;
    fCaption: string;
    fPartialCaption: Boolean;
    fEnabled: Boolean;
    fBrightness: Integer;
    fContrast: Integer;
    fFullScreenOnly: Boolean;
  public
    constructor Create(const aExecutable, aClassName, aCaption: string);
    destructor Destroy(); override;
  published
    property Executable: string read fExecutable write fExecutable;
    property ClassName: string read fClassName write fClassName;
    property Caption: string read fCaption write fCaption;
    property PartialCaption: Boolean read fPartialCaption write fPartialCaption;
    property Enabled: Boolean read fEnabled write fEnabled;
    property Brightness: Integer read fBrightness write fBrightness;
    property Contrast: Integer read fContrast write fContrast;
  end;

  TAppTriggers = class
  private
    fDefault: Extended;
    fItems: TArray<TAppTrigger>;
  public
    destructor Destroy; override;
    procedure Append(aItem: TAppTrigger);
    procedure Remove(aIndex: Integer);
    function Count: Integer;
  published
    property default: Extended read fDefault write fDefault;
    property Items: TArray<TAppTrigger> read fItems write fItems;
  end;

  TSettings = class(TObject)
  private
    fAppTriggers: TAppTriggers;
    fAutoRun: Boolean;
    fHotKey: string;
    fOverlayHotkey: string;
    fDefBrightness: Integer;
    fDefContrast: Integer;
    fDefVibrance: Integer;
    fDefGamma: Integer;  // single monitor only
    fFullBrightness: Integer;
    fFullContrast: Integer;
    fFullVibrance: Integer;
    fFullGamma: Integer;
    fFullSettings: Boolean; // single monitor only
    fOverlayOpacity: Integer;
    procedure SetAutorun(aEnable: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
  published
    property Autorun: Boolean read fAutoRun write SetAutorun;
    property HotKey: string read fHotKey write fHotKey;
    property OverlayHotkey: string read fOverlayHotkey write fOverlayHotkey;
    property DefaultBrightness: Integer read fDefBrightness write fDefBrightness;
    property DefaultContrast: Integer read fDefContrast write fDefContrast;
    property DefaultVibrance: Integer read fDefVibrance write fDefVibrance;
    property DefaultGamma: Integer read fDefGamma write fDefGamma;
    property FullscreenBrightness: Integer read fFullBrightness write fFullBrightness;
    property FullscreenContrast: Integer read fFullContrast write fFullContrast;
    property FullscreenVibrance: Integer read fFullVibrance write fFullVibrance;
    property FullscreenGamma: Integer read fFullGamma write fFullGamma;
    property FullscreenSettingsOn: Boolean read fFullSettings write fFullSettings;
    property OverlayOpacity: Integer read fOverlayOpacity write fOverlayOpacity;
  end;

  TSettingsHandler = class(TObject)
  public
    class function LoadSettings(fSettings: String = ''): TSettings;
    class procedure SaveSettings(aSettings: TSettings; fSettings: String = '');
  end;

implementation

{ TSettingsHandler }

class function TSettingsHandler.LoadSettings(fSettings: String): TSettings;
var
  strings: TStrings;
begin
  strings := TStringList.Create;
  try
    if fSettings = '' then
      fSettings := ExtractFilePath(ParamStr(0)) + 'settings.json';

    if FileExists(fSettings) then
    begin
      strings.LoadFromFile(fSettings);
      Result := TJson.JsonToObject<TSettings>(strings.Text);
    end
    else
    begin
      Result := TSettings.Create;
    end;
  finally
    strings.Free;
  end;
end;

class procedure TSettingsHandler.SaveSettings(aSettings: TSettings;
  fSettings: String);
var
  strings: TStrings;
  json: String;
begin
  if fSettings = '' then
    fSettings := ExtractFilePath(ParamStr(0)) + 'settings.json';

  strings := TStringList.Create;
  try
    json := TJson.ObjectToJsonString(aSettings);
    strings.Add(json);
    strings.SaveToFile(fSettings);
  finally
    strings.Free;
  end;
end;

{ TSettings }

constructor TSettings.Create;
begin
  inherited; // invoke inherit
  fAppTriggers := TAppTriggers.Create;
end;

destructor TSettings.Destroy;
begin
  fAppTriggers.Free;

  inherited;
end;

procedure TSettings.SetAutorun(aEnable: Boolean);
begin

end;

{ TAppTrigger }

constructor TAppTrigger.Create(const aExecutable, aClassName, aCaption: string);
begin
  fExecutable := aExecutable;
  fClassName := aClassName;
  fCaption := aCaption;
  fEnabled := True;
  fPartialCaption := False;
  fContrast := 0;
  fBrightness := 0;
  fFullScreenOnly := False;
end;

destructor TAppTrigger.Destroy;
begin

  inherited;
end;

{ TAppTriggers }

procedure TAppTriggers.Append(aItem: TAppTrigger);
begin
  SetLength(fItems, Length(fItems) + 1);
  fItems[High(fItems)] := aItem;
end;

function TAppTriggers.Count: Integer;
begin
  Result := Length(fItems);
end;

destructor TAppTriggers.Destroy;
var
  vItem: TAppTrigger;
begin
  for vItem in fItems do
    vItem.Free;

  inherited;
end;

procedure TAppTriggers.Remove(aIndex: Integer);
var
  I: Integer;
begin
  if (Count > 0) and (aIndex < Count) then
  begin
    fItems[aIndex].Free;
    for I := aIndex + 1 to Count - 1 do
      fItems[I - 1] := fItems[I];

    SetLength(fItems, Count - 1);
  end;
end;

end.
