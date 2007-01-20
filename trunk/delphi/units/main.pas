unit main;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, JvExControls, JvComponent,
  ComCtrls, JvExComCtrls, JvStatusBar, miscutils, mircmanager,
  ImgList, JvLookOut, Buttons, StdCtrls, Spin;

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
    btChannels: TJvLookOutButton;
    btLists: TJvLookOutButton;
    btQuickQueues: TSpeedButton;
    btQuickLists: TSpeedButton;
    sheetOptions: TTabSheet;
    trChannels: TTreeView;
    grpChOptionsListGrabber: TGroupBox;
    btRefreshChannels: TSpeedButton;
    btLChannels: TJvLookOutButton;
    chEnableListGrabberCH: TCheckBox;
    rdLGRelaxed: TRadioButton;
    Label1: TLabel;
    rdLGAggressive: TRadioButton;
    rdLGTimeDelay: TRadioButton;
    edLGTimeDelay: TSpinEdit;
    SpeedButton1: TSpeedButton;
    chAutoExpire: TCheckBox;
    edListExpire: TSpinEdit;
    chAutoDelete: TCheckBox;
    edAutoDelete: TSpinEdit;
    lblChannel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btChannelsClick(Sender: TObject);
    procedure sheetOptionsShow(Sender: TObject);
    procedure loadChannels;
    procedure btRefreshChannelsClick(Sender: TObject);
    procedure trChannelsChange(Sender: TObject; Node: TTreeNode);
    procedure chEnableListGrabberCHClick(Sender: TObject);
    function getNetChan: string;
    procedure rdLGModeClick(Sender: TObject);
    procedure edLGTimeDelayChange(Sender: TObject);
    procedure chAutoExpireClick(Sender: TObject);
    procedure edListExpireChange(Sender: TObject);
    procedure chAutoDeleteClick(Sender: TObject);
    procedure edAutoDeleteChange(Sender: TObject);
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

procedure TfMain.btChannelsClick(Sender: TObject);
begin
  mainPage.ActivePage := sheetOptions;
end;

//load channels to the treeview

procedure TfMain.loadChannels;
var
  slChannels: TStringList;
  sNet, sNetOld, sChan: string;
  i: integer;
  tr, pr: TTreeNode;
begin
  trChannels.Items.Clear;

  slChannels := TStringList.Create;
  slChannels.CommaText := mirc.Evaluate('$AG8.GetChannels');
  pr := trChannels.Items.GetFirstNode;
  tr := pr;
  for i := 0 to slChannels.count - 1 do
  begin
    miscutils.splitNetChannel(slChannels[i], sNet, sChan);
    if (sNet <> sNetOld) then
    begin
      sNetOld := sNet;
      tr := trChannels.Items.AddChild(pr, sNetOld);
    end;

    trChannels.Items.AddChild(tr, sChan);

  end; //for
  trChannels.FullExpand;
  slChannels.Free;
end; //proc

//sheetOptions show
//load channel tree onshow

procedure TfMain.sheetOptionsShow(Sender: TObject);
var
  i: integer;

begin
  lblChannel.Caption := '';
  //disable controls
  for i := 0 to sheetOptions.ControlCount - 1 do
  begin
    sheetOptions.Controls[i].Enabled := false;
    if sheetOptions.Controls[i] is TGroupBox then
      miscutils.disableChildren(TGroupBox(sheetOptions.Controls[i]), false);
  end; //for

  loadChannels;

  //enable controls?
  trChannels.Enabled := true;
  btRefreshChannels.Enabled := true;
end;

procedure TfMain.btRefreshChannelsClick(Sender: TObject);
begin
  sheetOptionsShow(Sender);
end;

//a treenode is selected

procedure TfMain.trChannelsChange(Sender: TObject; Node: TTreeNode);
var
  i: integer;
  sNG: string;
begin
  if trChannels.Items.Count < 2 then
    exit;
  //if it is a network (has children), then select first child
  if (trChannels.Selected.HasChildren) then
  begin
    trChannels.Select(trChannels.Selected.getFirstChild);
    exit;
  end;

  //regular channel - load channel data
  lblChannel.Caption := node.Parent.Text + ': ' + node.Text;

  sNG := node.Parent.Text
    + node.Text;

  //keep disabled while loading
//enabled
  chEnableListGrabberCH.Checked := mirc.ReadBool('%AG8.LG.' + sNG + '.enabled',
    false);
  //mode
  i := mirc.ReadInteger('%AG8.LG.' + sNG + '.mode', 0);

  if i = 0 then
    rdLGRelaxed.Checked := true
  else if i = 1 then
    rdLGAggressive.Checked := true
  else
    rdLGTimeDelay.Checked := true;

  //time-delay value (min)
  edLGTimeDelay.Value := mirc.ReadInteger('%AG8.LG.' + sNG + '.mode', 3);

  //auto-expire
  chAutoExpire.Checked := mirc.ReadBool('%AG8.LG.' + sNG + '.AutoExpire',
    false);
  //auto-expire time (days)
  edListExpire.Value := mirc.ReadInteger('%AG8.LG.' + sNG + '.AutoExpire.delay',
    15);

  //Auto delete
  chAutoDelete.Checked := mirc.ReadBool('%AG8.LG.' + sNG + '.AutoDelete',
    true);
  //auto-delete delay (days)
  edAutoDelete.Value := mirc.ReadInteger('%AG8.LG.' + sNG + '.AutoDelete.delay',
    30);

  //TODO: file grab settings!

 //enable controls
  for i := 0 to sheetOptions.ControlCount - 1 do
  begin
    sheetOptions.Controls[i].Enabled := true;
    if sheetOptions.Controls[i] is TGroupBox then
      miscutils.disableChildren(TGroupBox(sheetOptions.Controls[i]), true);
  end; //for

end;

//gets net#chan

function TfMain.getNetChan: string;
begin
  result := trchannels.Selected.Parent.Text
    + trchannels.Selected.Text;
end;

procedure TfMain.chEnableListGrabberCHClick(Sender: TObject);
begin
  mirc.WriteBool('%AG8.LG.' + getnetchan + '.enabled',
    chEnableListGrabberCH.Checked);
end;

procedure TfMain.rdLGModeClick(Sender: TObject);
begin
  if rdLGRelaxed.Checked then
    mirc.WriteInteger('%AG8.LG.' + getnetchan + '.mode', 0);
  if rdLGAggressive.Checked then
    mirc.WriteInteger('%AG8.LG.' + getnetchan + '.mode', 1);
  if rdLGTimeDelay.Checked then
    mirc.WriteInteger('%AG8.LG.' + getnetchan + '.mode', 2);
end;

procedure TfMain.edLGTimeDelayChange(Sender: TObject);
begin
  mirc.ReadInteger('%AG8.LG.' + getnetchan + '.mode', edLGTimeDelay.Value);
end;

procedure TfMain.chAutoExpireClick(Sender: TObject);
begin
  mirc.WriteBool('bool %AG8.LG.' + getnetchan + '.AutoExpire',
    chAutoExpire.Checked);

end;

procedure TfMain.edListExpireChange(Sender: TObject);
begin
  //auto-expire time (days)
  mirc.WriteInteger('%AG8.LG.' + getnetchan + '.AutoExpire.delay',
    edListExpire.Value);
end;

procedure TfMain.chAutoDeleteClick(Sender: TObject);
begin
  //Auto delete
  mirc.WriteBool('%AG8.LG.' + getnetchan + '.AutoDelete',
    chAutoDelete.Checked);
end;

procedure TfMain.edAutoDeleteChange(Sender: TObject);
begin
  //auto-delete delay (days)
  mirc.WriteInteger('%AG8.LG.' + getnetchan + '.AutoDelete.delay',
    edAutoDelete.Value);
end;

end.

