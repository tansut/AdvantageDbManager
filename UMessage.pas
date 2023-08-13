unit UMessage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,StdCtrls, ExtCtrls;

type
  TfmMessage = class(TForm)
    Image1: TImage;
    Button1: TButton;
    mmMessage: TMemo;
    chkShow: TCheckBox;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
  end;

var
  fmMessage: TfmMessage;

implementation

{$R *.dfm}

{ TfmMessage }

procedure TfmMessage.Button1Click(Sender: TObject);
begin
  Close;
end;

end.
