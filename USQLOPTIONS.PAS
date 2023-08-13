unit USqlOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFmSQLOptions = class(TForm)
    ChkRequestLive: TCheckBox;
    BtnOK: TButton;
    btnCancel: TButton;
    procedure BtnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    function Execute: Boolean;
  end;

var
  FmSQLOptions: TFmSQLOptions;

implementation

uses UADVUTILS;

{$R *.dfm}

{ TFmSQLOptions }

function TFmSQLOptions.Execute: Boolean;
begin
  Result := ShowModal = mrOk;
end;

procedure TFmSQLOptions.BtnOKClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TFmSQLOptions.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
