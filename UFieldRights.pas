unit UFieldRights;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UObjEdit, ComCtrls, StdCtrls, UAdsObj, ExtCtrls, ImgList, AdvListV,
  CommCtrl,AdsDictionary, Buttons,UAdvUtils;

const RightsStr: array[Boolean] of string = ('Hayýr', 'Evet');
type
  TFmFieldRights = class(TFmDBObjectEditor)
    LvTables: TAdvListView;
    ImgSmall: TImageList;
    BtChList01: TSpeedButton;
    BtChList02: TSpeedButton;
    BtChList03: TSpeedButton;
    BtChList04: TSpeedButton;
    BtChList05: TSpeedButton;
    BtChList06: TSpeedButton;
    procedure LvTablesMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SelectChList(Sender: TObject);
  private
    FAdsUser: TAdsRightsObject;
  public
    function Edit: Boolean; override;
    procedure Validate; override;
    procedure OnDone; override;
    property AdsObject: TAdsRightsObject read FAdsUser write FAdsUser;
    procedure FillFieldRights;
    procedure GetRightsList(ListView: TAdvListView;List: TStringList; ReadChar: Char='R');
    procedure AddToListView(ListView: TAdvListView; Caption: string;
              Rights: TAdsPermissionTypes; ImgIndex: Integer);
    procedure ToggleListItem(ListView: TAdvListView;
              Item: TListItem; SubItem: Integer);

    function GetListViewItem(ListView: TadvListView; var SubItem: Integer; P: TPoint): TListItem;

  end;

var
  FmFieldRights: TFmFieldRights;

implementation

{$R *.DFM}

procedure TFmFieldRights.AddToListView(ListView: TAdvListView; Caption: string;
  Rights: TAdsPermissionTypes; ImgIndex: Integer);
var
  Item: TListItem;
begin
  Item := ListView.Items.Add;
  Item.Caption := Caption;
  //with Item do -- interesting error :)
  begin
    Item.ImageIndex := ImgIndex;
    Item.SubItems.Add(RightsStr[(ptRead in Rights)]);
    ListView.SubItemImages[Item.Index, 0] := Integer(ptRead in Rights);
    if ListView.Columns.Count > 2 then
    begin
      Item.SubItems.Add(RightsStr[(ptInsert in Rights)]);
      ListView.SubItemImages[Item.Index, 1] := Integer(ptInsert in Rights);
    end;
    if ListView.Columns.Count > 3 then
    begin
      Item.SubItems.Add(RightsStr[(ptUpdate in Rights)]);
      ListView.SubItemImages[Item.Index, 2] := Integer(ptUpdate in Rights);
    end;
    Item.SubItems.Add(Caption);
    Item.SubItems.Add('0');
  end;
end;

procedure TFmFieldRights.ToggleListItem(ListView: TAdvListView;
  Item: TListItem; SubItem: Integer);
var Res: Boolean;
begin
  Res := Item.SubItems[SubItem] = RightsStr[True];
  Res := not Res;
  Item.SubItems[SubItem] := RightsStr[Res];
  ListView.SubItemImages[Item.Index, SubItem] := Integer(Res);
  if Item.SubItems[ListView.Columns.Count] = '0' then Item.Caption := Item.Caption + ' (*)';
  Item.SubItems[ListView.Columns.Count] := '1';
  if not Dirty then Dirty := True;
end;

procedure TFmFieldRights.LvTablesMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var Item: TListItem;
    Index: Integer;
begin
  inherited;
  Item := GetListViewItem(Sender As TAdvListView, Index, Point(X, Y));
  if (Item <> nil) and (Index >= 0) then ToggleListItem(Sender As TAdvListView, Item, Index);
end;

function TFmFieldRights.GetListViewItem(ListView: TadvListView;
  var SubItem: Integer; P: TPoint): TListItem;
var
  Info: TLVHitTestInfo;
begin
  Result := ListView.GetItemAt(P.x, P.Y);
  if Result <> nil then
  begin
    Info.pt := P;
    SendMessage(ListView.Handle, LVM_SUBITEMHITTEST, 0, Longint(@info));
    if Info.iSubItem = 0 then SubItem := -1
    else SubItem := Info.iSubItem-1;
  end;
end;

function TFmFieldRights.Edit: Boolean;
begin
  Caption := Item + ' tablosu alan haklarý';
 // with LvTables do if Columns.Count-1 <> AdsObject.GetRightCount then columns[columns.Count-1].Free;
  FillFieldRights;
  Result := ShowModal = mrOK;
end;

procedure TFmFieldRights.FillFieldRights;
var TableRight: TAdsPermissionTypes;
    Fields: TStringList;
    I: Integer;
begin
  Fields := TStringList.Create;
  try
    Dictionary.GetFieldNames(item,Fields);
    for I := 0 to Fields.Count - 1 do
    begin
      TableRight := AdsObject.GetFieldRight(item,Fields[i]);
      AddToListView(LvTables, Fields[i], TableRight, 2);
    end;
  finally
    Fields.Free;
  end;
  LvTables.SortColumn := 0;
end;

procedure TFmFieldRights.GetRightsList(ListView: TAdvListView;
  List: TStringList; ReadChar: Char);
var I: Integer;
    R: string;
begin
  for I := 0 to ListView.Items.Count - 1 do
  begin
    if ListView.Items[I].SubItems[ListView.columns.Count] = '1' then
    begin
      R := '';
      if ListView.Items[I].SubItems[0] = RightsStr[True] then R := R + ReadChar;
      if ListView.Items[I].SubItems[1] = RightsStr[True] then R := R + 'I';
      if ListView.Items[I].SubItems[2] = RightsStr[True] then R := R + 'U';
      List.Add(ListView.Items[I].SubItems[ListView.Columns.Count-1]);
      List.Add(R);
    end;
  end;
end;

procedure TFmFieldRights.OnDone;
var List: TStringList;
begin
  List := TStringList.Create;
  try
    GetRightsList(LvTables, List);
    AdsObject.SetFieldRights(item,List);
    List.Clear;
  finally
    List.Free;
  end;
end;

procedure TFmFieldRights.Validate;
begin

end;
procedure TFmFieldRights.SelectChList(Sender: TObject);
var
  inx,i:integer;
  temp:string;
begin
  inherited;
  temp:=TSpeedButton(Sender).Name;
  inx:=strtoint(copy(temp,Length(temp)-1,2));
  Case Inx of
    1 :SelectListCheck(LvTables,0,true,1);
    2 :SelectListCheck(LvTables,0,false,0);
    3 :SelectListCheck(LvTables,1,true,1);
    4 :SelectListCheck(LvTables,1,false,0);
    5 :SelectListCheck(LvTables,2,true,1);
    6 :SelectListCheck(LvTables,2,false,0);
    7 :SelectListCheck(LvTables,3,true,1);
    8 :SelectListCheck(LvTables,3,false,0);
  end;

  for i:=0 to LvTables.Items.Count-1 do
    if (LvTables.Items.Item[i] <> nil) then begin
       if LvTables.Items.Item[i].SubItems[LvTables.Columns.Count] = '0' then
          LvTables.Items.Item[i].Caption := LvTables.Items.Item[i].Caption + ' (*)';
       LvTables.Items.Item[i].SubItems[LvTables.Columns.Count] := '1';
    end;

  if not Dirty then Dirty := True;
end;

end.
