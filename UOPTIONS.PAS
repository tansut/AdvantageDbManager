unit UOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, adsset;

type
  TFmOptions = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    PG: TPageControl;
    GeneralSheet: TTabSheet;
    ChkAutoVersion: TCheckBox;
    ChkAutoTablePath: TCheckBox;
    EnvSettings: TTabSheet;
    Label1: TLabel;
    DateFmtCombo: TComboBox;
    Decimals: TUpDown;
    EdDecimals: TEdit;
    Label2: TLabel;
    AdsSettings: TAdsSettings;
    ChkShowHints: TCheckBox;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    procedure Validate;
  public
    procedure LoadSettings;
    procedure SaveSettings;
    procedure ApplySettings;
    procedure Execute;
  end;

var
  FmOptions: TFmOptions;

implementation

uses UADVUTILS;

{$R *.dfm}

procedure TFmOptions.LoadSettings;
var Temp: string;
begin
  ChkAutoVersion.Checked := ReadRegKey('AutoVersionControl') <> ResType[False];
  ChkAutoTablePath.Checked := ReadRegKey('AutoTablePath') = ResType[True];
  ChkShowHints.Checked := ReadRegKey('ChkShowHints') <> ResType[False];
  Temp := ReadRegKey('DateFormat');
  DateFmtCombo.ItemIndex := DateFmtCombo.Items.IndexOf(Temp);
  if DateFmtCombo.ItemIndex < 0 then Temp := AdsSettings.DateFormat;
  DateFmtCombo.ItemIndex := DateFmtCombo.Items.IndexOf(Temp);
  Temp := ReadRegKey('NumDecimals');
  if Temp = '' then Temp := '2';
  Decimals.Position := StrToInt(Temp);
end;

procedure TFmOptions.SaveSettings;
begin
  WriteRegKey('AutoVersionControl', ResType[ChkAutoVersion.Checked]);
  WriteRegKey('AutoTablePath', ResType[ChkAutoTablePath.Checked]);
  WriteRegKey('DateFormat', DateFmtCombo.Items[DateFmtCombo.ItemIndex]);
  WriteRegKey('NumDecimals', IntToStr(Decimals.Position));
  WriteRegKey('ChkShowHints', ResType[ChkShowHints.Checked]);
end;

procedure TFmOptions.Validate;
begin

end;

procedure TFmOptions.btnCancelClick(Sender: TObject);
begin
  LoadSettings;
  ModalResult := mrCancel;
end;

procedure TFmOptions.btnOKClick(Sender: TObject);
begin
  Validate;
  SaveSettings;
  ApplySettings;
  ModalResult := mrOK;
end;

procedure TFmOptions.Execute;
begin
  LoadSettings;
  ShowModal;
end;

procedure TFmOptions.ApplySettings;
begin
  AdsSettings.DateFormat := DateFmtCombo.Items[DateFmtCombo.ItemIndex];
  AdsSettings.NumDecimals := Decimals.Position;
  Application.ShowHint := ChkShowHints.Checked;
end;

end.
