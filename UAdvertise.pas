unit UAdvertise;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzLabel, RxGIF, ExtCtrls, RzButton, StdCtrls, UAdvUtils, jpeg;

type
  TFmAdvertise = class(TForm)
    btnClose: TRzButton;
    Label2: TLabel;
    Image2: TImage;
    ChkDontShow: TCheckBox;
    Panel1: TPanel;
    Label3: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    RzLabel1: TRzLabel;
    Shape1: TShape;
    Shape2: TShape;
    RzLabel2: TRzLabel;
    RzLabel3: TRzLabel;
    RzLabel4: TRzLabel;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    procedure btnCloseClick(Sender: TObject);
    procedure RzLabel2Click(Sender: TObject);
    procedure RzLabel4Click(Sender: TObject);
    procedure RzLabel3Click(Sender: TObject);
    procedure RzLabel1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FmAdvertise: TFmAdvertise;

implementation

uses UDBLimits, UPerformans;

{$R *.dfm}

procedure TFmAdvertise.btnCloseClick(Sender: TObject);
begin
  if ChkDontShow.Checked then
    WriteRegKey ('ShowAdvertiseOnStart','0');
  Close;
end;

procedure TFmAdvertise.RzLabel2Click(Sender: TObject);
begin
  with TFmDbLimits.Create(nil) do
  try
    ShowModal;
  finally
    Free;
  end;    
end;

procedure TFmAdvertise.RzLabel4Click(Sender: TObject);
begin
  with TFmPerformans.Create(nil) do
  try
    Execute;
  finally
    Free;
  end;    
end;

procedure TFmAdvertise.RzLabel3Click(Sender: TObject);
begin
  GotoUrl('http://www.delphiturk.com/Forums.aspx?Forums=251',700,500,true);
end;

procedure TFmAdvertise.RzLabel1Click(Sender: TObject);
begin
 GotoUrl('http://www.advantageturk.com',700,500,true);
end;

end.
