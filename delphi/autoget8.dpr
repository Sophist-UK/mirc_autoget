library autoget8;

uses
  SysUtils,
  Classes,
  mIRCManager in 'support\mIRCManager.pas',
  main in 'units\main.pas' {fMain};

var
  mIRC: tMircManager;

procedure LoadDll(LoadInfo: PLoadInfo); stdcall; export;
begin
  LoadInfo.mKeep := true; // don`t release DLL after use
  mirc := tmircmanager.Create(Loadinfo.mHwnd);
end;

function UnloadDll(mTimeOut: integer): integer; stdcall; export;
begin
  if mTimeOut = 0 then

  begin
    result := 1;
    try
      if fMain <> nil then freeandnil(fMain);
      mirc.Free;
    except
    end;
  end
  else
  begin
    result := 0;
  end;
end;


//show mainform
function Show(mWnd, aWnd: HWND; data, parms: PChar; show, nopause: boolean):
  integer; stdcall;
begin
  result := 1;
  if fMain = nil then
    fMain := tfMain.Create(nil);
//TODO: Re-implement application-level exception handler
  //  application.OnException := main.MainForm.AppException;
  fMain.Show;
end;

exports LoadDll,
  UnloadDll,
  Show;
{$R *.res}

begin
end.

 