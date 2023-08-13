unit URef;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UObjEdit, ComCtrls, StdCtrls, adsdictionary, ExtCtrls, Ace, UAdsObj,
  ImgList, UAdsRef, Db, adsdata, adsfunc, adstable;

type
  TFmRef = class(TFmDBObjectEditor)
    Image1: TImage;
    edName: TEdit;
    Label1: TLabel;
    cbParentTable: TComboBox;
    Label2: TLabel;
    cbChildTable: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    cbForeignKey: TComboBox;
    Label5: TLabel;
    Label6: TLabel;
    edParentKey: TEdit;
    GroupBox2: TGroupBox;
    Label9: TLabel;
    edPKeyError: TEdit;
    edCascadeError: TEdit;
    Label10: TLabel;
    cbUpdateRule: TComboBox;
    cbDeleteRule: TComboBox;
    Label7: TLabel;
    Label8: TLabel;
    AdsQuery1: TAdsQuery;
    procedure cbParentTableChange(Sender: TObject);
    procedure cbChildTableChange(Sender: TObject);
    procedure cbForeignKeyChange(Sender: TObject);
    procedure cbUpdateRuleChange(Sender: TObject);
    procedure cbDeleteRuleChange(Sender: TObject);
    procedure edPKeyErrorChange(Sender: TObject);
    procedure edCascadeErrorChange(Sender: TObject);
    procedure edNameChange(Sender: TObject);
  private
    AdsRef : TAdsRef;
    function IsAdmin: Boolean;
  public
    procedure Init;
    function New: Boolean; override;
    function Edit: Boolean; override;
    procedure Validate; override;
    procedure ModeChanged; override;
    procedure OnDone; override;

  end;

var
  FmRef: TFmRef;

implementation

{$R *.DFM}

function TFmRef.IsAdmin: Boolean;
begin
   Result := UpperCase(Dictionary.UserName) = 'ADSSYS';
end;

function TFmRef.Edit: Boolean;
begin
  Init;
  AdsRef := TAdsRef.Create(Dictionary, Item);
  try
    edName.Text := Item;
    cbParentTable.Text := AdsRef.GetParentTable;
    cbChildTable.Text := AdsRef.GetChildTable;
    cbParentTableChange(nil);
    cbChildTableChange(nil);
    cbForeignKey.Text := AdsRef.GetForeignIndex;
    cbUpdateRule.ItemIndex := StrToInt(AdsRef.GetUpdateRule) - 1;
    cbDeleteRule.ItemIndex := StrToInt(AdsRef.GetDeleteRule) - 1;
    edPKeyError.Text := AdsRef.GetPkeyError;
    edCascadeError.Text := AdsRef.GetCascadeError;
  finally
    AdsRef.Free;
  end;
  Dirty := False;
  Result := ShowModal = mrOK;
end;

procedure TFmRef.Init;
var List: TStringList;
begin
  List := TStringList.Create;
  if Not IsAdmin then
  begin
     edName.ReadOnly := True;
     cbParentTable.Enabled := False;
     cbChildTable.Enabled := False;
     cbForeignKey.Enabled := False;
     cbUpdateRule.Enabled := False;
     cbDeleteRule.Enabled := False;
     edPKeyError.ReadOnly := True;
     edCascadeError.ReadOnly := True;
  end;
  try
    Dictionary.GetTableNames(List);
    cbParentTable.Items := List;
    cbChildTable.Items := List;
    cbUpdateRule.ItemIndex := 0;
    cbDeleteRule.ItemIndex := 0;
  finally
    List.Free;
  end;
end;

function TFmRef.New: Boolean;
begin
  Init;
  Dirty := True;
  Result := ShowModal = mrOK;
end;

procedure TFmRef.Validate;
begin
  if edName.Text = '' then
  begin
    edName.SetFocus;
    raise Exception.Create('Ýliþkisel Bað adý girilmelidir.');
  end;

  if edParentKey.Text = '' then
  begin
    cbParentTable.SetFocus;
    raise Exception.Create('Temel tablonun bir ana anahtarý olmalýdýr.');
  end;

  if cbForeignKey.Text = '' then
  begin
    cbForeignKey.SetFocus;
    raise Exception.Create('Yabancý anahtarý seçmelisiniz.');
  end;

end;

procedure TFmRef.ModeChanged;
begin
  case Mode of
    emEdit:
       Caption := Item + ' özellikleri';
    emNew:
       Caption := 'Yeni Ýliþkisel Bað Ekle';
   end;
end;

procedure TFmRef.OnDone;
  var mUpdateRule : UNSIGNED16;
      mDeleteRule : UNSIGNED16;
      mTempUpdRule : UNSIGNED16;
      mTempDelRule : UNSIGNED16;
      mTempParent : string;
      mTempPKey : String;
      mTempChild : String;
      mTempFKey : String;
      mTempPKError : String;
      mTempCasError : String;
begin
  if Mode = emEdit then
  begin
     AdsRef := TAdsRef.Create(Dictionary, Item);
     mTempUpdRule := StrToInt(AdsRef.GetUpdateRule);
     mTempDelRule := StrToInt(AdsRef.GetDeleteRule);
     mTempParent := AdsRef.GetParentTable;
     mTempPKey := AdsRef.GetPrimaryKey ;
     mTempChild := AdsRef.GetChildTable;
     mTempFKey := AdsRef.GetForeignIndex;
     mTempPKError := AdsRef.GetPkeyError;
     mTempCasError := AdsRef.GetCascadeError;
     AdsRef.Free;
     Dictionary.RemoveRI(Item);
  end;

  mUpdateRule := cbUpdateRule.ItemIndex + 1;
  mDeleteRule := cbDeleteRule.ItemIndex + 1;

  try
     Dictionary.CreateRI(edName.Text,'',cbParentTable.Text,edParentKey.Text,
                         cbChildTable.Text, cbForeignKey.Text, mUpdateRule, mDeleteRule,
                         edPKeyError.Text, edCascadeError.Text);
     Item := edName.Text;
  except
     if Mode = emEdit then
     begin

        Dictionary.CreateRI (Item,'',mTempParent ,mTempPKey, mTempChild ,mTempFKey ,
                             mTempUpdRule, mTempDelRule, mTempPKError , mTempCasError );
     end;
     raise;
  end;

end;

procedure TFmRef.cbParentTableChange(Sender: TObject);
var aucBuffer : array [0..ADS_DD_MAX_PROPERTY_LEN] of char;
    TempLen: UNSIGNED16;
begin
  inherited;
  TempLen := ADS_DD_MAX_PROPERTY_LEN;
  try
     Dictionary.GetTableProperty( cbParentTable.Text , ADS_DD_TABLE_PRIMARY_KEY,
                                  @aucBuffer, TempLen);
     edParentKey.Text := string(aucBuffer);
  except
     edParentKey.Text := '';
  end;
  Dirty := True;
end;

procedure TFmRef.cbChildTableChange(Sender: TObject);
var List: TStringList;
begin
  inherited;
  List := TStringList.Create;
  cbForeignKey.Clear;
  try
    Dictionary.GetIndexNames (cbChildTable.Text,List);
    cbForeignKey.Items := List;
  finally
    List.Free;
  end;

  Dirty := True;
end;

procedure TFmRef.cbForeignKeyChange(Sender: TObject);
begin
  inherited;
  Dirty := True;
end;

procedure TFmRef.cbUpdateRuleChange(Sender: TObject);
begin
  inherited;
  Dirty := True;
end;

procedure TFmRef.cbDeleteRuleChange(Sender: TObject);
begin
  inherited;
  Dirty := True;
end;

procedure TFmRef.edPKeyErrorChange(Sender: TObject);
begin
  inherited;
  Dirty := True;
end;

procedure TFmRef.edCascadeErrorChange(Sender: TObject);
begin
  inherited;
  Dirty := True;
end;

procedure TFmRef.edNameChange(Sender: TObject);
begin
  inherited;
  Dirty := True;
end;

end.
