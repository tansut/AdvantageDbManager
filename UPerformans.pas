unit UPerformans;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, RzEdit, RzPrgres, ExtCtrls, RzPanel, adscnnct,
  RzStatus, DB, adsdata, adsfunc, adstable, UAdvUtils;

type
  TFmPerformans = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    EdRecCount: TRzNumericEdit;
    btnGo: TButton;
    Label3: TLabel;
    mmText: TMemo;
    RzStatusBar1: TRzStatusBar;
    PBar: TRzProgressBar;
    DbConn: TAdsConnection;
    Status: TRzStatusPane;
    PersonsTable: TAdsTable;
    PersonsTableNUMARA: TAutoIncField;
    PersonsTableAD: TStringField;
    PersonsTableSOYAD: TStringField;
    PersonsTableMAAS: TCurrencyField;
    Shape1: TShape;
    Image1: TImage;
    procedure EdRecCountChange(Sender: TObject);
    procedure btnGoClick(Sender: TObject);
  private
    CreateTime, PostTime, IndexTime, LastTime: Cardinal;
    procedure CreateDatas(RecCount: Integer);
    procedure SetStatus(const Msg: string);
  public
    procedure Execute;
  end;

var
  FmPerformans: TFmPerformans;

implementation

uses UPerfResult;

{$R *.dfm}
const
  BIRLER: array[0..9] of string=('', 'Bir', 'Iki', 'Üc', 'Dört', 'Bes', 'Alti',
          'Yedi', 'Sekiz', 'Dokuz');
  ONLAR : array[0..9] of string=('', 'On', 'Yirmi', 'Otuz', 'Kirk', 'Elli', 'Altmis',
          'Yetmis', 'Seksen', 'Doksan');
  DIGER : array[0..5] of string=('', 'Bin', 'Milyon', 'Milyar', 'Trilyon', 'Katrilyon');


function RandomString(PWLen: integer): string;
const StrTable: string =
    'üýðöçÇÖÝÐÜ ' +
    'ABCDEFGHIJKLMabcdefghijklm' +
    '0123456789' +
    'NOPQRSTUVWXYZnopqrstuvwxyz';
var
  N, K, X, Y: integer;
begin
  Randomize;
  if (PWlen > Length(StrTable)) then K := Length(StrTable)-1
    else K := PWLen;
  SetLength(result, K);
  Y := Length(StrTable);
  N := 0;

  while N < K do begin
    X := Random(Y) + 1;
    if (pos(StrTable[X], result) = 0) then begin
      inc(N);
      Result[N] := StrTable[X];
    end;
  end;
end;

function SmallNum(N: Integer): string;
var
  S: string[3];
begin
  Result := '';
  S := IntToStr(N);
  if (Length(S)=1) then
    S := '00' + S
  else if (Length(S)=2) then
    S := '0' + S;
  if S[1]<>'0' then
    if S[1]<>'1' then
      Result := BIRLER[StrToInt(S[1])] + 'Yüz'
    else
      Result := 'Yüz';
  Result := Result + ONLAR[StrToInt(S[2])];
  Result := Result + BIRLER[StrToInt(S[3])];
end;

function NumStr(Num: Extended): string;
var
  i, j, n, Nm: Integer;
  S, Sn: string;
begin
  S := FormatFloat('0', Num);
  Sn := '';
  if Num = 0 then
    Sn := 'Sifir'
  else if Length(S) < 4 then
    Sn := SmallNum(Round(Num))
  else
  begin
    I := 1;
    J := Length(S) mod 3;
    if J=0 then
    begin
      J := 3;
      N := Length(S) div 3 - 1;
    end
    else
      N := Length(S) div 3;
    while i<Length(S) do
    begin
      Nm := StrToInt(Copy(S, I, J));
      if (Nm=1) and (N=1) then
      begin
        Nm := 0;
        Sn := Sn + SmallNum(Nm) + Diger[N];
      end;
      if Nm<>0 then
        Sn := Sn + SmallNum(Nm) + Diger[N];
      I := I + J;
      J := 3;
      N := N - 1;
    end;
  end;
  Result := Sn;
end;
procedure TFmPerformans.Execute;
begin
  EdRecCountChange(nil);
  ShowModal;
end;

procedure TFmPerformans.EdRecCountChange(Sender: TObject);
begin
  mmText.Text := NumStr(EdRecCount.Value);
end;

procedure TFmPerformans.btnGoClick(Sender: TObject);
var RecCount: Integer;
begin
  if Tag = 1 then
  begin
    Tag := 0;
    Exit;
  end;
  RecCount := EdRecCount.IntValue;
  if RecCount <= 0 then raise Exception.Create('Geçersiz Bilgi');
  try
    Tag := 1;
    btnGo.Caption := 'Durdur';
    PBar.Visible := True;
    EdRecCount.Enabled := False;
    CreateDatas(RecCount);
    with TFmPerfResults.Create(nil) do
    try
      LblCreate.Value := CreateTime;
      LblSave.Value := PostTime;
      LblIndex.Value := IndexTime;
      LblRecCount.Value := RecCount;
      Execute(PersonsTable);
    finally
      Free;
    end;
  finally
    Tag := 0;
    btnGo.Caption := 'Ýþleme Baþla';
    PBar.Visible := False;
    EdRecCount.Enabled := True;
    Status.Caption := 'Hazýr';
  end;
end;

procedure TFmPerformans.CreateDatas(RecCount: Integer);
var I, Str1Len, Str2Len: Integer;
    Str1, Str2: string;
begin
  if DbConn.IsConnected then DbConn.Disconnect;
  PersonsTable.IndexFieldNames := '';
  DBConn.ConnectPath := GetAppPath + 'Performans\AdsDb.add';
  DbConn.Connect;
  try
    DbConn.Execute('Drop Index PERSONS.ADINDEX');
    DbConn.Execute('Drop Index PERSONS.SOYADINDEX');
    DbConn.Execute('Drop Index PERSONS.NUMARAINDEX');
  except
  end;
  SetStatus('Tablo Boþaltýlýyor ...');
  PersonsTable.Exclusive := True;
  PersonsTable.EmptyTable;
  PersonsTable.PackTable;
  I := 1;
  PersonsTable.Exclusive := False;
  PersonsTable.Close;
  PersonsTable.Open;
  PBar.PartsComplete := I;
  PBar.TotalParts := RecCount;
  SetStatus('Veriler Yaratýlýyor / Ekleniyor ...');
  CreateTime := 0;
  PostTime := 0;
  while (I <= RecCount) do
  begin
    LastTime := GetTickCount;
    Randomize;
    Str1Len := Random(25) + 3;
    Randomize;
    Str2Len := Random(25);
    Str1 := RandomString(Str1Len);
    Str2 := RandomString(Str2Len);
    CreateTime := CreateTime + (GetTickCount - LastTime);
    PersonsTable.Insert;
    PersonsTableAD.AsString  := Str1;
    PersonsTableSOYAD.AsString := Str2;
    PersonsTableMAAS.AsInteger := Random(MaxInt);
    LastTime := GetTickCount;
    PersonsTable.Post;
    PostTime := PostTime + (GetTickCount - LastTime);
    Inc(I);
    PBar.IncPartsByOne;
    PBar.Update;
    Application.ProcessMessages;
    if Tag = 0 then Abort;
  end;
  PersonsTable.Close;
  LastTime := GetTickCount;
  SetStatus('Numara indeks yaratýlýyor ...');
  DbConn.Execute('Create UNIQUE Index NUMARAINDEX ON PERSONS(NUMARA)');
  SetStatus('Ad indeks yaratýlýyor ...');
  DbConn.Execute('Create Index ADINDEX ON PERSONS(AD)');
  SetStatus('Soyad indeks yaratýlýyor ...');
  DbConn.Execute('Create Index SOYADINDEX ON PERSONS(SOYAD)');
  IndexTime := GetTickCount - LastTime;
end;

procedure TFmPerformans.SetStatus(const Msg: string);
begin
  Status.Caption := Msg;
  Status.Refresh; 
end;

end.
