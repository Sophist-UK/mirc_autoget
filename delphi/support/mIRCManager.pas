unit mIRCManager;

interface
uses Windows,
  Sysutils;

  type
  // Standard mIRC type
  TLoadInfo = packed record
    mVersion: DWORD;
    mHwnd: HWND;
    mKeep: Boolean;
  end;
  PLoadInfo = ^TLoadInfo;

type
  TmIRCManager = class(TObject)
  public
    mircHandle: HWND;
    constructor Create(mHandle: HWND = 0);
    destructor Destroy; override;

    procedure Command(c: string; cMethod: integer = 0);
    function Evaluate(c: string): string;

    function ReadString(const Ident, Default: string): string;
    procedure WriteString(const Ident, Value: string);

    function ReadInteger(const Ident: string; const Default: integer): integer;
    procedure WriteInteger(const Ident: string; const Value: integer);

    function ReadFloat(const Ident: string; const Default: Double): Double;
    procedure WriteFloat(const Ident: string; const Value: Double);

    function ReadBool(const Ident: string; const Default: boolean): boolean;
    procedure WriteBool(const Ident: string; Value: boolean);

    procedure Unset(const Ident: string);
  private
    hMutex: hwnd; //mutex so we wouldn't access memory-mapped mIRC file when something is using it. Do not change mutex name!
    FhFileMap: THandle;
    FmData: pchar;
  end;

function GetMircHandle: HWND;

implementation

constructor TmIRCManager.Create(mHandle: HWND = 0);
begin
  inherited Create;
  if mHandle = 0 then mHandle := GetMircHandle;
  mircHandle := mHandle;
  FhFileMap := CreateFileMapping(INVALID_HANDLE_VALUE, nil, PAGE_READWRITE, 0, 4096, 'mIRC');
  FmData := MapViewOfFile(FhFileMap, FILE_MAP_ALL_ACCESS, 0, 0, 0);
  // Do not change mutex name! Many dll's use BWI_Mutex!
  hMutex := windows.CreateMutex(nil, false, 'BWI_Mutex');
  if GetLastError = 183 then //mutex exists (ERROR_ALREADY_EXISTS)
    hMutex := OpenMutex(SYNCHRONIZE, false, 'BWI_Mutex');
end;


destructor TmIRCManager.Destroy;
begin
  UnmapViewOfFile(FmData);
  CloseHandle(FhFileMap);
  CloseHandle(hMutex);
  inherited destroy;
end;

{
cMethod - how mIRC should process the message, where:
   1 = as if typed in editbox
    2 = as if typed in editbox, send as plain text
    4 = use flood protection if turned on, can be or'd with 1 or 2
   Returns - 1 if success, 0 if fail
}

procedure TmIRCManager.Command(c: string; cMethod: integer = 0);
begin
  if hmutex <> 0 then
    WaitForSingleObject(hMutex, 1000); //wait 1 sec. if mutex is not released in 1 sec then mIRC is f*cked anyway
  StrPCopy(FmData, c);
  // replaced WM_command with   $0400 + 200 - no need to include Messages unit
  SendMessage(mircHandle, $0400 + 200, cMethod, 0);
  ReleaseMutex(hMutex);
end;

function TmIRCManager.Evaluate(c: string): string;
begin
  if hmutex <> 0 then
    WaitForSingleObject(hMutex, 1000);
  StrPCopy(FmData, c);
  SendMessage(mirchandle, $0400 + 201, 0, 0);
  Result := FmData;
  ReleaseMutex(hMutex);
end;

function TmIRCManager.ReadString(const ident, default: string): string;
var
  s: string;
begin
  result := default;
  s := Evaluate(ident);
  if s <> '' then result := s;
end;

procedure TmIRCManager.WriteString(const ident, value: string);
begin
  command('//set ' + ident + #32 + value);
end;

function TmIRCManager.ReadInteger(const Ident: string; const Default: integer): integer;
begin
  result := StrToIntDef(evaluate(ident), default);
end;

procedure TmIRCManager.WriteInteger(const Ident: string; const Value: integer);
begin
  command('//set ' + ident + #32 + inttostr(Value));
end;

function TmIRCManager.ReadFloat(const Ident: string; const Default: Double): Double;
var
  FloatStr: string;
begin
  FloatStr := evaluate(ident);
  DecimalSeparator := '.';
  Result := StrToFloatDef(FloatStr, Default);
end;

procedure TmIRCManager.WriteFloat(const Ident: string; const Value: Double);
begin
  DecimalSeparator := '.';
  command('//set ' + ident + #32 + FloatToStr(value));
end;

function TmIRCManager.ReadBool(const Ident: string; const Default: boolean): boolean;
var
  BoolStr: string;
begin
  result := default;
  BoolStr := evaluate(ident);
  // Delphi BoolToStr defaults to true == -1
//on & off are for $group().status
  if (BoolStr = '1') or (BoolStr = '$true') or (BoolStr = '-1') or (BoolStr = 'on') then result := true;
  if (BoolStr = '0') or (BoolStr = '$false') or (BoolStr = 'off') then result := false;
end;


procedure TmIRCManager.WriteBool(const Ident: string; Value: boolean);
begin
  if Value then command('//set ' + ident + ' $true')
  else command('//set ' + ident + ' $false');
end;

procedure TmIRCManager.Unset(const Ident: string);
begin
  command('//unset ' + Ident);
end;

///just because some people don't understand FindWindow....

function GetMircHandle: HWND;
begin
  result := FindWindow('mIRC', nil);
end;

end.

