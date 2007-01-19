unit miscutils;
interface

uses
  mIRCManager, classes, strutils, sysutils, StdCtrls;

var
  mIRC: tMircManager;

  //splits net:channel
procedure splitNetChannel(sNetChan: string; var sNet: string; var sChannel:
  string);
//disables groupbox children
procedure disableChildren(gr: TGroupBox; doEnable: boolean);

implementation

//splits net:channel

procedure splitNetChannel(sNetChan: string; var sNet: string; var sChannel:
  string);
var
  i: integer;
begin
  i := pos(':', sNetChan);
  sNet := leftstr(sNetChan, i - 1);
  sChannel := rightstr(sNetChan, length(sNetChan) - i);
end;

procedure disableChildren(gr: TGroupBox; doEnable: boolean);
var
  i: integer;
begin
  for i := 0 to gr.ControlCount - 1 do
    gr.Controls[i].Enabled := doEnable;
end;

end.

