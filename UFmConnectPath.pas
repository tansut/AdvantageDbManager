unit UFmConnectPath;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, AgOpenDialog, StdCtrls, ExtCtrls, UAdvUtils;

type
  TFmGetConnectPath = class(TForm)
    Label1: TLabel;
    DlgOpenDict: TAgOpenDialog;
    SpeedButton1: TSpeedButton;
    Shape1: TShape;
    BtnOK: TButton;
    btnCancel: TButton;
    Shape2: TShape;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    EdDictPath: TComboBox;
    procedure SpeedButton1Click(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    function Execute: string;
  end;

var
  FmGetConnectPath: TFmGetConnectPath;

implementation

{$R *.dfm}

procedure TFmGetConnectPath.SpeedButton1Click(Sender: TObject);
begin
  if DlgOpenDict.Execute then
    edDictPath.Text := DlgOpenDict.FileName;
end;

procedure TFmGetConnectPath.BtnOKClick(Sender: TObject);
var
  OldIndex: Integer;
  CP: string;
begin
  CP := Trim(edDictPath.Text);
  if CP = '' then
   raise Exception.Create('Geçerli bir veri tabaný baðlantý dizesi belirtiniz');
  Caption := CP;
  OldIndex := edDictPath.Items.IndexOf(CP);
  if OldIndex <> -1 then
   EdDictPath.Items.Delete(OldIndex);
  EdDictPath.Items.Insert(0, CP);
  if EdDictPath.Items.Count > 10 then
   EdDictPath.Items.Delete(10);
  ModalResult := mrOk;
end;

function TFmGetConnectPath.Execute: string;
begin
  if ShowModal = mrOK then
   Result := Caption
  else
   Result := '';
end;

procedure TFmGetConnectPath.FormCreate(Sender: TObject);
begin
  edDictPath.Items.Text := ReadRegKey('LastConnectPath');
  if edDictPath.Items.Count > 0 then
   EdDictPath.Text := edDictPath.Items[0];
end;

procedure TFmGetConnectPath.FormDestroy(Sender: TObject);
begin
  WriteRegKey('LastConnectPath', edDictPath.Items.Text);
end;

end.
