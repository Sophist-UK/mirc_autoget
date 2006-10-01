unit main;

interface

uses
  Windows,SysUtils,  Classes,  Controls, Forms, JvExControls, JvComponent,
  JvOutlookBar;


type
  TfMain = class(TForm)
    barMain: TJvOutlookBar;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fMain: TfMain;

implementation

{$R *.dfm}

end.
