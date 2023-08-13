unit UTable;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UObjEdit, ComCtrls, StdCtrls, Db, adsdata, adsfunc, adstable, ExtCtrls,
  AdvListV, ImgList, adsdictionary, adscnnct,UAdvUtils,UAdsTable;

type
  TFmTable = class(TFmDBObjectEditor)
    Label2: TLabel;
    Label1: TLabel;
    Bevel1: TBevel;
    ImgSmall: TImageList;
    LvTables: TAdvListView;
    EdExp: TMemo;
    Label3: TLabel;
    Bevel2: TBevel;
    Label4: TLabel;
    Label5: TLabel;
    LbPrimaryIndex: TLabel;
    LbDefaultIndex: TLabel;
    Bevel3: TBevel;
    edTableName: TEdit;
    EdTablePath: TEdit;
  private
    AdsTable: TDBAdsTable;
  public
    function Edit: Boolean; override;
    function New: Boolean; override;
    procedure Validate; override;
    procedure OnDone; override;
    procedure DirtyChanged; override;
    procedure ModeChanged; override;
    procedure Init;
  end;


var
  FmTable: TFmTable;

implementation

{$R *.DFM}

procedure TFmTable.DirtyChanged;
begin

end;

function TFmTable.Edit: Boolean;
var I: Integer;
begin
  init;
  Result := ShowModal = mrOK;
end;

procedure TFmTable.Init;
var
    I: Integer;
    ListItem: TListItem;
    Conn: TAdsConnection;
    keyFieldStr :string;
begin

  edTableName.Text:=item;
  AdsTable := TDBAdsTable.Create(Dictionary,item);
  try
    AdsTable.RefreshProperties;
    EdTablePath.Text :=AdsTable.TablePath;
    EdExp.Text:=AdsTable.Description;
{
    adstable
    if  AdsTable.getPrimaryKey<>'' then  begin
      AdsTable.IndexName := AdsTable.getPrimaryKey;
      keyFieldStr:=adstable.AdsGetIndexExpr;
      LbPrimaryIndex.Caption:=AdsTable.IndexName;
    end;
}
    LbPrimaryIndex.Caption:=AdsTable.PrimaryKey;
    LbDefaultIndex.Caption:=AdsTable.DefaultIndex;
    if  LbPrimaryIndex.Caption<>'' then
      keyFieldStr:=AdsTable.GetIndexExp(LbPrimaryIndex.Caption);
    for I := 0 to AdsTable.Fields.FieldCount - 1 do
      begin
        ListItem := LvTables.Items.Add;
        with ListItem do   begin
          Caption:='';
          ImageIndex := -1;
          ListItem.SubItems.Add('');
          if pos(AdsTable.Fields.Field[i].Name ,keyFieldStr)>0 then
             Lvtables.SubItemImages[i,0]:=1;
          ListItem.SubItems.Add(AdsTable.Fields.Field[i].Name);
      end;
      ListItem.SubItems.Add(AdsTable.Fields.Field[i].FieldType);
      ListItem.SubItems.Add(inttostr(AdsTable.Fields.Field[i].Definition.usFieldLength));
      ListItem.SubItems.Add('');
      if AdsTable.Fields.Field[i].IsNotNull then
         Lvtables.SubItemImages[i,4]:=2;
    end;
  finally
    AdsTable.Free;
  end;
end;
procedure TFmTable.ModeChanged;
begin

end;

function TFmTable.New: Boolean;
begin

end;

procedure TFmTable.OnDone;
begin

end;

procedure TFmTable.Validate;
begin

end;

end.
