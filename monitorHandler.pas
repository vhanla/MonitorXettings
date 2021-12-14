unit monitorHandler;

interface

uses
  Messages, Classes, Windows, NVAPI, Forms, Dialogs;

const
  DXVA2 = 'Dxva2.dll';

type

/// NVidia DVC Info
  NV_DISPLAY_DVC_INFO = record
    version: UINT;
    currentLevel: Integer;
    minLevel: Integer;
    maxLevel: Integer;
  end;

/// NVidia Driver info
  NV_DISPLAY_DRIVER_VERSION = record
    version: Integer;
    drvVersion: Integer;
    bldChangeListNum: Integer;
    szBuildBranchString: array[0..64] of char;
    szAdapterString: array[0..64] of char;
  end;

/// Describes a monitor's color temperature.
  PMC_COLOR_TEMPERATURE = ^TMC_COLOR_TEMPERATURE;
  TMC_COLOR_TEMPERATURE = (
    MC_COLOR_TEMPERATURE_UNKNOWN, // Unknown temperature.
    MC_COLOR_TEMPERATURE_4000K,   // 4,000 kelvins (K).
    MC_COLOR_TEMPERATURE_5000K,   // 5,000 K.
    MC_COLOR_TEMPERATURE_6500K,   // 6,500 K.
    MC_COLOR_TEMPERATURE_7500K,   // 7.500 K.
    MC_COLOR_TEMPERATURE_8200K,   // 8,200 K.
    MC_COLOR_TEMPERATURE_9300K,   // 9,300 K.
    MC_COLOR_TEMPERATURE_10000K,  // 10,000 K.
    MC_COLOR_TEMPERATURE_11500K   // 11,500 K.
  );
  MC_COLOR_TEMPERATURE = TMC_COLOR_TEMPERATURE;

/// Specifies whether to get or set the vertical or horizontal position of a
///  monitor's display area.
  PMC_POSITION_TYPE = ^TMC_POSITION_TYPE;
  TMC_POSITION_TYPE = (
    MC_HORIZONTAL_POSITION, // Horizontal position.
    MC_VERTICAL_POSITION    // Vertical position.
  );
  MC_POSITION_TYPE = TMC_POSITION_TYPE;

/// Specifies whether to get or set the width or height of a monitor's
///  display area.
  PMC_SIZE_TYPE = ^TMC_SIZE_TYPE;
  TMC_SIZE_TYPE = (
    MC_WIDTH,
    MC_HEIGHT
  );
  MC_SIZE_TYPE = TMC_SIZE_TYPE;

/// Identifies monitor display technologies.
  PMC_DISPLAY_TECHNOLOGY_TYPE = ^TMC_DISPLAY_TECHNOLOGY_TYPE;
  TMC_DISPLAY_TECHNOLOGY_TYPE = (
    MC_SHADOW_MASK_CATHODE_RAY_TUBE,    // Shadow-mask cathode ray tube (CRT).
    MC_APERTURE_GRILL_CATHODE_RAY_TUBE, // Aperture-grill CRT.
    MC_THIN_FILM_TRANSISTOR,            // Thin-film transistor (TFT) display.
    MC_LIQUID_CRYSTAL_ON_SILICON,       // Liquid crystal on silicon (LCOS) display.
    MC_PLASMA,                          // Plasma display.
    MC_ORGANIC_LIGHT_EMITTING_DIODE,    // Organic light emitting diode (LED) display.
    MC_ELECTROLUMINESCENT,              // Electroluminescent display.
    MC_MICROELECTROMECHANICAL,          // Microelectromechanical display.
    MC_FIELD_EMISSION_DEVICE            // Field emission device (FED) display.
  );
  MC_DISPLAY_TECHNOLOGY_TYPE = TMC_DISPLAY_TECHNOLOGY_TYPE;

/// Specifies whether to set or get a monitor's red, green, or blue drive.
  PMC_DRIVE_TYPE = ^TMC_DRIVE_TYPE;
  TMC_DRIVE_TYPE = (
    MC_RED_DRIVE,   // Red drive.
    MC_GREEN_DRIVE, // Green drive.
    MC_BLUE_DRIVE   // Blue drive.
  );
  MC_DRIVE_TYPE = TMC_DRIVE_TYPE;

/// Specifies whether to get or set a monitor's red, green, or blue gain.
  PMC_GAIN_TYPE = ^TMC_GAIN_TYPE;
  TMC_GAIN_TYPE = (
    MC_REG_GAIN,    // Red gain.
    MC_GREEN_GAIN,  // Green gain.
    MC_BLUE_GAIN    // Blue gain.
  );
  MC_GAIN_TYPE = TMC_GAIN_TYPE;

/// Describes a Virtual Control Panel (VCP) code type.
  PMC_VCP_CODE_TYPE = ^TMC_VCP_CODE_TYPE;
  TMC_VCP_CODE_TYPE = (
    MC_MOMENTARY,     /// Momentary VCP code. Sending a command of this type
                      ///  causes the monitor to initiate a self-timed operation
                      ///  and then revert to its original state. Examples
                      ///  include display tests and degaussing.
    MC_SET_PARAMETER  /// Set parameter VCP code. Sending a command of this
                      /// type changes some aspect of the monitor's operation.
  );
  MC_VCP_CODE_TYPE = TMC_VCP_CODE_TYPE;

function SetMonitorContrast (
  hMonitor: THandle; dwNewBrightness: DWORD): BOOL; stdcall;
  external 'Dxva2.dll' name 'SetMonitorContrast';

function GetNumberOfPhysicalMonitorsFromHMONITOR(hMonitor: THandle;
  pdwNumberOfPhysicalMonitors: PDWORD): Boolean; stdcall;
  external 'Dxva2.dll' name 'GetNumberOfPhysicalMonitorsFromHMONITOR';

function GetPhysicalMonitorsFromHMONITOR(hMonitor: THandle;
  dwPhysicalMonitorArraySizwe: DWORD; pPhysicalMonitorArray: Pointer): Boolean; stdcall;
  external 'Dxva2.dll' name 'GetPhysicalMonitorsFromHMONITOR';

function DestroyPhysicalMonitors(dwPhysicalMonitorArraySize: DWORD;
  pPhysicalMonitorArray: Pointer): Boolean; stdcall;
  external 'Dxva2.dll' name 'DestroyPhysicalMonitors';

// highlevelmonitorconfigurationapi.h

/// DegaussMonitor: Degausses a monitor. Degaussing improves a monitor's image quality and color
///  fidelity by demagnitizing the monitor.
///  Result: TRUE if succeds, FALSE if fails, more info GetLastError.
///  GetMonitorCapabilities flag dependency: MC_CAPS_DEGAUSS
///  Response time: 50ms.
///  Remark: Should not be called frequently because it won't improve quality more than expected.
function DegaussMonitor(AMonitor: THandle): BOOL; stdcall;
  external DXVA2 name 'DegaussMonitor';

/// GetMonitorBrightness:
///  Retrieves a monitor's minimum, maximum, and current brightness settings.
///  Result: TRUE if succeds, FALSE if fails, more info GetLastError.
///  GetMonitorCapabilities flag dependency: MC_CAPS_BRIGHTNESS
///  Response time: 40ms.
function GetMonitorBrightness (
  hMonitor: THandle; pdwMinimumBrightness : PDWORD;
  pdwCurrentBrightness : PDWORD; pdwMaximumBrightness : PDWORD): BOOL; stdcall;
  external 'Dxva2.dll' name 'GetMonitorBrightness';

/// GetMonitorCapabilities:
///  Retrieves the configuration capabilities of a monitor. Call this function
///  to find out which high-level monitor configuration functions are supported
///  by the monitor.
///  Result: TRUE if succeds, FALSE if fails, more info GetLastError.
///
function GetMonitorCapabilities(
  hMonitor: THandle; pdwMonitorCapabilities : PDWORD;
  pdwSupportedColorTemperatures : PDWORD
): BOOL; stdcall;
  external DXVA2 name 'GetMonitorCapabilities';

/// GetMonitorColorTemperature:
///  Retrieves a monitor's current color temperature.
function GetMonitorColorTemperature(
  hMonitor: THandle;
  pctCurrentColorTemperature: PMC_COLOR_TEMPERATURE
): BOOL; stdcall;
  external DXVA2 name 'GetMonitorColorTemperature';

/// GetMonitorContrast:
///  Retrieves a monitor's minimum, maximum, and current contrast settings.
function GetMonitorContrast (
  hMonitor: THandle; pdwMinimumBrightness : PDWORD;
  pdwCurrentBrightness : PDWORD; pdwMaximumBrightness : PDWORD): BOOL; stdcall;
  external DXVA2 name 'GetMonitorContrast';

/// GetMonitorDisplayAreaPosition:
///  Retrieves a monitor's minimum, maximum, and current horizontal or
///  vertical position.
///  Result: TRUE if succeds, FALSE if fails, more info GetLastError.
function GetMonitorDisplayAreaPosition (
  hMonitor: THandle; ptPositionType: MC_POSITION_TYPE;
  pdwMinimumPosition: PDWORD; pdwCurrentPosition: PDWORD;
  pdwMaximumPosition: PDWORD
): BOOL; stdcall;
  external DXVA2 name 'GetMonitorDisplayAreaPosition';

/// GetMonitorDisplayAreaSize:
///  Retrieves a monitor's minimum, maximum, and current width or height.
///  Result: TRUE if succeds, FALSE if fails, more info GetLastError.
function GetMonitorDisplayAreaSize (
  hMonitor: THandle; stSizeType: MC_SIZE_TYPE;
  pdwMinimumWidthOrHeight: PDWORD; pdwCurrentWidthOrHeight: PDWORD;
  pdwMaximumWidthOrHeight: PDWORD
): BOOL; stdcall;
  external DXVA2 name 'GetMonitorDisplayAreaSize';

/// GetMonitorRedGreenOrBlueDrive:
///  Retrieves a monitor's red, green, or blue drive value.
///  Result: TRUE if succeds, FALSE if fails, more info GetLastError.
function GetMonitorRedGreenOrBlueDrive (
  hMonitor: THandle; dtDriveType: MC_DRIVE_TYPE;
  pdwMinimumDrive: PDWORD; pdwCurrentDrive: PDWORD;
  pdwMaximumDrive: PDWORD
): BOOL; stdcall;
  external DXVA2 name 'GetMonitorRedGreenOrBlueDrive';

/// GetMonitorRedGreenOrBlueGain:
///  Retrieves a monitor's red, green, or blue gain value.
///  Result: TRUE if succeds, FALSE if fails, more info GetLastError.
function GetMonitorRedGreenOrBlueGain (
  hMonitor: THandle; gtGainType: MC_GAIN_TYPE;
  pdwMinimumGain: PDWORD; pdwCurrentGain: PDWORD;
  pdwMaximumGain: PDWORD
): BOOL; stdcall;
  external DXVA2 name 'GetMonitorRedGreenOrBlueGain';

/// GetMonitorTechnologyType:
///  Retrieves the type of technology used by a monitor.
///  Result: TRUE if succeds, FALSE if fails, more info GetLastError.
///  Remarks: GetMonitorCapabilites MC_CAPS_DISPLAY_TECHNOLOGY_TYPE flag
///  if absent function will fail. CRT monitors would fail surely.
function GetMonitorTechnologyType (
  hMonitor: THandle; pdtyDisplayTechnologyType: PMC_DISPLAY_TECHNOLOGY_TYPE
): BOOL; stdcall;
  external DXVA2 name 'GetMonitorTechnologyType';

/// RestoreMonitorFactoryColorDefaults:
///  Restores a monitor's color settings to their factory defaults.
///  Result: TRUE if succeds, FALSE if fails, more info GetLastError.
///  Dependency flag: GetMonitorCapabilities MC_CAPS_RESTORE_FACTORY_COLOR_DEFAULTS
///  Response time: 5 seconds to return, it is slow.
function RestoreMonitorFactoryColorDefaults (
  hMonitor: THandle
): BOOL; stdcall;
  external DXVA2 name 'RestoreMonitorFactoryColorDefaults';

/// RestoreMonitorFactoryDefaults:
///  Restores a monitor's settings to their factory defaults.
///  Result: TRUE if succeds, FALSE if fails, more info GetLastError.
///  Dependency flag: GetMonitorCapabilities MC_CAPS_RESTORE_FACTORY_DEFAULTS
///  Response time: 5 seconds to return, it is slow.
function RestoreMonitorFactoryDefaults (
  hMonitor: THandle
): BOOL; stdcall;
  external DXVA2 name 'RestoreMonitorFactoryDefaults';

/// SaveCurrentMonitorSettings:
///  Saves the current monitor settings to the display's nonvolatile storage.
///  Result: TRUE if succeds, FALSE if fails, more info GetLastError.
///  Response time: About 200 ms to return.
function SaveCurrentMonitorSettings (
  hMonitor: THandle
): BOOL; stdcall;
  external DXVA2 name 'SaveCurrentMonitorSettings';

/// SetMonitorBrightness:
///  Sets a monitor's brightness value.
///  Result: TRUE if succeds, FALSE if fails, more info GetLastError.
///  Dependency flag: GetMonitorCapabilities MC_CAPS_BRIGHTNESS
///  Response Time: 50ms
function SetMonitorBrightness (
  hMonitor: THandle; dwNewBrightness: DWORD): BOOL; stdcall;
  external 'Dxva2.dll' name 'SetMonitorBrightness';

type
  PHYSICAL_MONITOR = record
    hPhysicalMonitor: THandle;
    szPhysicalMonitorDescription: array[0..127] of Char;
  end;

//  TMonitorSetting = record
//    Id: THandle;
//    Name: array [0..127] of Char;
//    Contrast: Integer;
//    Brightness: Integer;
//  end;

  TMonitorSetting = class
  private
    FName: string;
    FVendor: string;
    FCapabilities: DWORD;
    FSupportedColorTemperatures: DWORD;
  public
    property Name: string read FName write FName;
    property Vendor: string read FVendor write FVendor;
    property Capabilities: DWORD read FCapabilities write FCapabilities;
    property SupportedColorTemperatures: DWORD read FSupportedColorTemperatures write FSupportedColorTemperatures;
  end;

  TMonitorSettings = class(TObject)
  private
    FMsgHandlerHWND: HWND;
    FItems: TArray<TMonitorSetting>;
    procedure WndMethod(var AMsg: TMessage);
  public
    constructor Create;
    destructor Destroy; override;
    property items: TArray<TMonitorSetting> read FItems write FItems;
    procedure Append(item: TMonitorSetting);
    procedure Remove(index: Integer);
    procedure Clear;
    function Count: Integer;
    procedure UpdateMonitors;
  end;


implementation



{ TMonitorSettings }

procedure TMonitorSettings.Append(item: TMonitorSetting);
begin
  SetLength(FItems, Length(FItems) + 1);
  FItems[High(FItems)] := item;
end;

procedure TMonitorSettings.Clear;
var
  LItems: TMonitorSetting;
begin
  for LItems in FItems do
    LItems.Free;
end;

function TMonitorSettings.Count: Integer;
begin
  Result := Length(FItems);
end;

constructor TMonitorSettings.Create;
begin
  inherited Create;

  UpdateMonitors;

  FMsgHandlerHWND := AllocateHWnd(WndMethod);
end;

destructor TMonitorSettings.Destroy;
var
  LItems: TMonitorSetting;
begin
  for LItems in FItems do
    LItems.Free;

  DeallocateHWnd(FMsgHandlerHWND);

  inherited;
end;

procedure TMonitorSettings.Remove(index: Integer);
var
  I: Integer;
begin
  if (Count > 0) and (index < Count) then
  begin
    FItems[index].Free;
    for I := index + 1 to Count - 1 do
      FItems[I - 1] := FItems[I];

    SetLength(FItems, Count - 1);
  end;
end;

// Updates monitor status
procedure TMonitorSettings.UpdateMonitors;
var
  LCount: Integer;
  I: Integer;
  LItem: TMonitorSetting;
  LCapabilities, LSupportedColorTemperatures: DWORD;
begin
  LCount := Screen.MonitorCount;
  Clear;
  for I := 0 to LCount - 1 do
  begin
    LItem := TMonitorSetting.Create;
    try
      GetMonitorCapabilities(Screen.Monitors[I].Handle, @LCapabilities, @LSupportedColorTemperatures);

      Append(LItem);
    finally
//      LItem.Free;
    end;
  end;
end;

procedure TMonitorSettings.WndMethod(var AMsg: TMessage);
begin
 if AMsg.msg = WM_DISPLAYCHANGE then
 begin
//  UpdateMonitors;
//  OutputDebugStringA(PAnsiChar('Hey'));
 end
 else
  AMsg.Result := DefWindowProc(FMsgHandlerHWND, AMsg.Msg, AMsg.WParam, AMsg.LParam);
end;

end.
