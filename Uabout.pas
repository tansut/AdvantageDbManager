unit Uabout;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ShellApi, UAdvUtils, RzButton, RzLabel, jpeg, RxGIF, UCheckVersion;

type
  TAboutBox = class(TForm)
    Panel3: TPanel;
    ADVANTAGE: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    Label1: TLabel;
    btnClose: TRzButton;
    Panel1: TPanel;
    RzLabel2: TRzLabel;
    RzLabel1: TRzLabel;
    btnCheckVer: TRzButton;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Bevel1: TBevel;
    Image2: TImage;
    Shape1: TShape;
    Image1: TImage;
    procedure OKButtonClick(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure RzLabel1Click(Sender: TObject);
    procedure RzLabel2Click(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnCheckVerClick(Sender: TObject);
    procedure Label6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation

{$R *.DFM}

procedure TAboutBox.OKButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TAboutBox.Label3Click(Sender: TObject);
begin
  ShellExecute(handle,'open','mailto:vty@atvantageturk.com','','',SW_SHOWNORMAL );
end;

procedure TAboutBox.Label2Click(Sender: TObject);
begin
   GotoUrl('http://www.advantageturk.com',700,500,true);
end;

procedure TAboutBox.RzLabel1Click(Sender: TObject);
begin
   GotoUrl('http://www.advantageturk.com',0,0,true);
end;

procedure TAboutBox.RzLabel2Click(Sender: TObject);
begin
  ShellExecute(handle,'open','mailto:vty@advantageturk.com','','',SW_SHOWNORMAL );
end;

procedure TAboutBox.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TAboutBox.btnCheckVerClick(Sender: TObject);
begin
  with TfmCheckVersion.Create(nil) do
  try
    self.Enabled := False;
    Execute;
  finally
    self.Enabled := True;
    free;
  end;
  btnClose.SetFocus; 
end;

procedure TAboutBox.Label6Click(Sender: TObject);
begin
  GotoUrl('http://www.advantageturk.com',700,500,true);
end;

end.

