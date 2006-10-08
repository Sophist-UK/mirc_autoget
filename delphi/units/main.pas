unit main;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, JvExControls, JvComponent,
  ComCtrls, JvExComCtrls, JvStatusBar, miscutils, mircmanager,
  ImgList, JvLookOut;

type
  TfMain = class(TForm)
    StatusBar: TJvStatusBar;
    MainPage: TPageControl;
    imlButtons: TImageList;
    barMain: TJvLookOut;
    pageQueues: TJvLookOutPage;
    pageLists: TJvLookOutPage;
    pageTools: TJvLookOutPage;
    btTransfers: TJvLookOutButton;
    btQueues: TJvLookOutButton;
    btFinished: TJvLookOutButton;
    btQueOptions: TJvLookOutButton;
    pageOptions: TJvLookOutPage;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private

  public
    { Public declarations }
  end;

var
  fMain: TfMain;

implementation
{$R *.dfm}

procedure TfMain.FormCreate(Sender: TObject);
begin
  //window position/size
  if mirc.ReadBool('%AG8.UIMaximized', false) then
    self.WindowState := wsMaximized
  else
  begin
    self.Top := mirc.ReadInteger('%AG8.UITop', 100);
    self.Left := mirc.ReadInteger('%AG8.UILeft', 100);
    self.Height := mirc.ReadInteger('%AG8.UIHeight', 534);
    self.Width := mirc.ReadInteger('%AG8.UIWidth', 774);
  end;
end;

procedure TfMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  mirc.WriteBool('%AG8.UIMaximized', (self.WindowState = wsMaximized));
  if self.WindowState <> wsMaximized then
  begin
    mirc.WriteInteger('%AG8.UITop', self.Top);
    mirc.WriteInteger('%AG8.UILeft', self.Left);
    mirc.WriteInteger('%AG8.UIHeight', self.Height);
    mirc.WriteInteger('%AG8.UIWidth', self.Width);
  end;
end;

end.

