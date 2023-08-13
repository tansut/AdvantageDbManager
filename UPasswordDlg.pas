unit UPasswordDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls;

type
  TFmPasswordDlg = class(TForm)
    Label1: TLabel;
    Password: TEdit;
    btOk: TButton;
    BtnCancel: TButton;
    Image2: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FmPasswordDlg: TFmPasswordDlg;

implementation

{$R *.DFM}

end.
 
