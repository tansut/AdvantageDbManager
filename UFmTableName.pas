unit UFmTableName;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TFmGetTableName = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    edTableName: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    btnOK: TButton;
    Button2: TButton;
    edPath: TEdit;
    SpeedButton1: TSpeedButton;
    TableNameDial: TSaveDialog;
    procedure btnOKClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    function Execute(DictPath: string): string;
    function GetTablePath: string;
    function GetFullTableName: string;
  end;

var
  FmGetTableName: TFmGetTableName;

implementation

{$R *.dfm}

{ TFmGetTableName }

function TFmGetTableName.Execute(DictPath: string): string;
begin
  edPath.Text := DictPath;
  edTableName.Clear;
  if ShowModal = mrOk then
  begin
    Result := edTableName.Text;
  end else Result := '';
end;

procedure TFmGetTableName.btnOKClick(Sender: TObject);
begin
  if Trim(edTableName.Text) = '' then
  begin
    edTableName.SetFocus;
    raise Exception.Create('Lütfen geçerli bir tablo adý giriniz');
  end else ModalResult := mrOK;
end;

procedure TFmGetTableName.SpeedButton1Click(Sender: TObject);
begin
  TableNameDial.InitialDir := edPath.Text;
  if TableNameDial.Execute then
  begin
    edPath.Text := ExtractFilePath(TableNameDial.FileName);
    edTableName.Text := ExtractFileName(TableNameDial.FileName);
  end;
end;

function TFmGetTableName.GetTablePath: string;
begin
  Result := edPath.Text;
end;

function TFmGetTableName.GetFullTableName: string;
begin
  Result := edPath.Text;
  if (Result[Length(Result)] <> '/') or (Result[Length(Result)] <> '\') then
    Result := Result + '\';
  Result := Result + edTableName.Text;  
end;

end.
