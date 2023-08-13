unit URemoveTables;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, adsdictionary, Buttons;

type
  TFmRemoveTables = class(TForm)
    btnOK: TButton;
    BtnCancel: TButton;
    TableList: TCheckListBox;
    BtChList01: TSpeedButton;
    BtChList02: TSpeedButton;
    ChkDelete: TCheckBox;
    MsgLabel: TLabel;
    procedure btnOKClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtChList01Click(Sender: TObject);
    procedure BtChList02Click(Sender: TObject);
  private
    FDictionary: TAdsDictionary;
    procedure Validate;
  public
    function Execute(ADictionary: TAdsDictionary): Boolean;
    property Dictionary: TAdsDictionary read FDictionary write FDictionary;
  end;

var
  FmRemoveTables: TFmRemoveTables;

implementation

{$R *.dfm}

procedure TFmRemoveTables.btnOKClick(Sender: TObject);
var I: Integer;
begin
  Validate;
  if MessageDlg('Seçili tablolarý veri tabanýndan çýkartmak istiyor musunuz ?'#13#10#13#10
                , mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    for I := 0 to TableList.Items.Count - 1 do
    begin
      if TableList.Checked[i] then
        Dictionary.RemoveTable(TableList.Items[i], ChkDelete.Checked);
    end;
  end;
  ModalResult := mrOK;
end;

function TFmRemoveTables.Execute(ADictionary: TAdsDictionary): Boolean;
var AList: TStringList;
begin
  AList := TStringList.Create;
  self.Dictionary := ADictionary;
  try
    Dictionary.GetTableNames(AList);
    MsgLabel.Caption := Format('Toplam: %d', [AList.Count]);
    TableList.Items := AList;
    Result := ShowModal = mrOK;
  finally
    AList.Free;
  end;
end;

procedure TFmRemoveTables.Validate;
var I: Integer;
begin
  for I := 0 to TableList.Items.Count - 1 do
  begin
    if TableList.Checked[i] then Exit;
  end;
  raise Exception.Create('Lütfen en az bir tablo seçiniz');
end;

procedure TFmRemoveTables.BtnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFmRemoveTables.BtChList01Click(Sender: TObject);
var I: Integer;
begin
  for I := 0 to TableList.Items.Count - 1 do
  begin
    TableList.Checked[i] := True;
  end;
end;

procedure TFmRemoveTables.BtChList02Click(Sender: TObject);
var I: Integer;
begin
  for I := 0 to TableList.Items.Count - 1 do
  begin
    TableList.Checked[i] := False;
  end;
end;

end.
