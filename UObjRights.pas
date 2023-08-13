unit UObjRights;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UObjEdit, ComCtrls, StdCtrls, UAdsObj, ExtCtrls, ImgList, AdvListV,
  CommCtrl,AdsDictionary,UFieldRights, Buttons,UAdvUtils;

const RightsStr: array[Boolean] of string = ('Hayýr', 'Evet');
type

  TFmObjectRights = class(TFmDBObjectEditor)
    tsView: TTabSheet;
    tsProcedure: TTabSheet;
    Image1: TImage;
    LblUser: TLabel;
    ImgSmall: TImageList;
    LvTables: TAdvListView;
    LvProc: TAdvListView;
    tsLink: TTabSheet;
    BtChList01: TSpeedButton;
    BtChList02: TSpeedButton;
    BtChList03: TSpeedButton;
    BtChList04: TSpeedButton;
    BtChList05: TSpeedButton;
    BtChList06: TSpeedButton;
    BtChList07: TSpeedButton;
    BtChList08: TSpeedButton;
    BtChList09: TSpeedButton;
    BtChList10: TSpeedButton;
    BtChList11: TSpeedButton;
    BtChList12: TSpeedButton;
    BtChList13: TSpeedButton;
    BtChList14: TSpeedButton;
    BtChList15: TSpeedButton;
    BtChList16: TSpeedButton;
    BtChList17: TSpeedButton;
    BtChList18: TSpeedButton;
    BtChList19: TSpeedButton;
    BtChList20: TSpeedButton;
    BtChList21: TSpeedButton;
    BtChList22: TSpeedButton;
    BtChList23: TSpeedButton;
    BtChList24: TSpeedButton;
    BtChList25: TSpeedButton;
    BtChList26: TSpeedButton;
    BtChList27: TSpeedButton;
    BtChList28: TSpeedButton;
    LvLink: TAdvListView;
    LvViews: TAdvListView;
    BitBtn1: TBitBtn;
    procedure LvTablesMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PageControl1Change(Sender: TObject);
    procedure LvTablesDblClick(Sender: TObject);
    procedure SelectChList(Sender: TObject);
  private
    FAdsObject: TAdsRightsObject;
  public
    function Edit: Boolean; override;
    procedure Validate; override;
    procedure OnDone; override;
    property AdsObject: TAdsRightsObject read FAdsObject write FAdsObject;
    procedure FillTableRights;
    procedure FillViewRights;
    procedure FillProcRights;
    procedure FillLinkRights;
    procedure AddToListView(ListView: TAdvListView; Caption: string; Rights: TAdsPermissionTypes; ImgIndex: Integer);
    function GetListViewItem(ListView: TadvListView; var SubItem: Integer; P: TPoint): TListItem;
    procedure ToggleListItem(ListView: TAdvListView; Item: TListItem; SubItem: Integer);
    procedure GetRightsList(ListView: TAdvListView; List: TStringList; ReadChar: Char = 'R');
  end;

implementation
uses
  UAdsUser;
{$R *.DFM}

procedure TFmObjectRights.AddToListView(ListView: TAdvListView; Caption: string;
  Rights: TAdsPermissionTypes; ImgIndex: Integer);
var
  Item: TListItem;
begin
  Item := ListView.Items.Add;
  Item.Caption := Caption;
  //with Item do -- interesting error :)
  begin
    Item.ImageIndex := ImgIndex;
    if ImgIndex<3 then begin
      Item.SubItems.Add(RightsStr[(ptRead in Rights)]);
      ListView.SubItemImages[Item.Index, 0] := Integer(ptRead in Rights) + 5;
    end else if  ImgIndex=3 then
    begin
      Item.SubItems.Add(RightsStr[(ptExecute in Rights)]);
      ListView.SubItemImages[Item.Index, 0] := Integer(ptExecute in Rights) + 5;
    end else if   ImgIndex=4 then begin
      Item.SubItems.Add(RightsStr[(ptLinkAccess in Rights)]);
      ListView.SubItemImages[Item.Index, 0] := Integer(ptLinkAccess in Rights) + 5;
    end;
    if ListView.Columns.Count > 2 then
      if ImgIndex<3 then
      begin
        Item.SubItems.Add(RightsStr[(ptInsert in Rights)]);
        ListView.SubItemImages[Item.Index, 1] := Integer(ptInsert in Rights) + 5;
      end else if (AdsObject is TAdsUser) then begin
        Item.SubItems.Add(RightsStr[(ptInherit in Rights)]);
        ListView.SubItemImages[Item.Index, 1] := Integer(ptInherit in Rights) + 5;
      end;
    if (ListView.Columns.Count > 3) then
    begin
      Item.SubItems.Add(RightsStr[(ptUpdate in Rights)]);
      ListView.SubItemImages[Item.Index, 2] := Integer(ptUpdate in Rights) + 5;
    end;
    if ListView.Columns.Count > 4 then
    begin
      Item.SubItems.Add(RightsStr[(ptDelete in Rights)]);
      ListView.SubItemImages[Item.Index, 3] := Integer(ptDelete in Rights) + 5;
    end;
    if (ListView.Columns.Count > 5) and (AdsObject is TAdsUser) then
    begin
      Item.SubItems.Add(RightsStr[(ptInherit in Rights)]);
      ListView.SubItemImages[Item.Index, 4] := Integer(ptInherit in Rights) + 5;
    end;
    Item.SubItems.Add(Caption);
    Item.SubItems.Add('0');
  end;
end;

function TFmObjectRights.Edit: Boolean;
begin
  LblUser.Caption := Item;
  Caption := Item + ' haklarý';
  PageControl1.ActivePage:=tsGeneral;
  if (AdsObject is TAdsUser) then
    self.HelpContext:=32
  else
    self.HelpContext:=32;

  with LvTables do if Columns.Count-1 <> AdsObject.GetRightCount('T') then
    columns[columns.Count-1].Free;
  with LvViews do if Columns.Count-1 <> AdsObject.GetRightCount('V') then
    columns[columns.Count-1].Free;
  with LvLink do if Columns.Count-1 <> AdsObject.GetRightCount('L') then
    columns[columns.Count-1].Free;
  with LvProc do if Columns.Count-1 <> AdsObject.GetRightCount('P') then
    columns[columns.Count-1].Free;
  FillTableRights;
  FillViewRights;
  FillProcRights;
  FillLinkRights;
  if not (AdsObject is TAdsUser) then begin
    BtChList09.Visible:=false;
    BtChList10.Visible:=false;
    BtChList19.Visible:=false;
    BtChList20.Visible:=false;
    BtChList23.Visible:=false;
    BtChList24.Visible:=false;
    BtChList27.Visible:=false;
    BtChList28.Visible:=false;

  end;
  Result := ShowModal = mrOK;
end;


procedure TFmObjectRights.FillTableRights;
var TableRight: TAdsPermissionTypes;
    Tables: TStringList;
    I: Integer;
begin
  Tables := TStringList.Create;
  try
    Dictionary.GetTableNames(Tables);
    for I := 0 to Tables.Count - 1 do
    begin
      TableRight := AdsObject.GetTableRight(Tables[i]);
      AddToListView(LvTables, Tables[i], TableRight, 1);
    end;
  finally
    Tables.Free;
  end;
  LvTables.SortColumn := 0;
end;

procedure TFmObjectRights.OnDone;
var List: TStringList;
begin
  List := TStringList.Create;
  try
    GetRightsList(LvTables, List);
    AdsObject.SetTableRights(List);
    List.Clear;

    GetRightsList(LvViews, List);
    AdsObject.SetViewRights(List);
    List.Clear;

    GetRightsList(LvProc, List);
    AdsObject.SetProcRights(List);
    List.Clear;

    GetRightsList(LvLink, List);
    AdsObject.SetLinkRights(List);
    List.Clear;
  finally
    List.Free;
  end;
end;

procedure TFmObjectRights.Validate;
begin

end;

procedure TFmObjectRights.FillViewRights;
var ViewRight: TAdsPermissionTypes;
    Views: TStringList;
    I: Integer;
begin
  Views := TStringList.Create;
  try
    Dictionary.GetViewNames(Views);
    for I := 0 to Views.Count - 1 do
    begin
      ViewRight := AdsObject.GetViewRight(Views[i]);
      AddToListView(LvViews, Views[i], ViewRight, 2);
    end;
  finally
    Views.Free;
  end;
  LvViews.SortColumn := 0;
end;

procedure TFmObjectRights.LvTablesMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var Item: TListItem;
    Index: Integer;
begin
  inherited;
  Item := GetListViewItem(Sender As TAdvListView, Index, Point(X, Y));
  if (Item <> nil) and (Index >= 0) then ToggleListItem(Sender As TAdvListView, Item, Index);
end;

function TFmObjectRights.GetListViewItem(ListView: TadvListView; var SubItem: Integer; P: TPoint): TListItem;
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


procedure TFmObjectRights.ToggleListItem(ListView: TAdvListView;
  Item: TListItem; SubItem: Integer);
var Res: Boolean;
begin
  Res := Item.SubItems[SubItem] = RightsStr[True];
  Res := not Res;
  Item.SubItems[SubItem] := RightsStr[Res];
  ListView.SubItemImages[Item.Index, SubItem] := Integer(Res) + 5;
  if Item.SubItems[ListView.Columns.Count] = '0' then Item.Caption := Item.Caption + ' (*)';
  Item.SubItems[ListView.Columns.Count] := '1';
  if not Dirty then Dirty := True;
end;

procedure TFmObjectRights.PageControl1Change(Sender: TObject);
begin
  inherited;
  LvViews.Width := 1;
end;

procedure TFmObjectRights.GetRightsList(ListView: TAdvListView;
  List: TStringList; ReadChar: Char);
var I: Integer;
    R: string;
begin
  for I := 0 to ListView.Items.Count - 1 do
  begin
    if ListView.Items[I].SubItems[ListView.columns.Count] = '1' then begin
      if ListView.Columns.Count>3 then
      begin
        R := '';
        if ListView.Items[I].SubItems[0] = RightsStr[True] then R := R + ReadChar;
        if ListView.Items[I].SubItems[1] = RightsStr[True] then R := R + 'I';
        if ListView.Items[I].SubItems[2] = RightsStr[True] then R := R + 'U';
        if ListView.Items[I].SubItems[3] = RightsStr[True] then R := R + 'D';
        if (AdsObject is TAdsUser) and (ListView.Items[I].SubItems[4] = RightsStr[True])  then R := R + 'H';
      end else if ListView.Columns.Items[0].Caption='Prosedür' then begin
        R := '';
        if ListView.Items[I].SubItems[0] = RightsStr[True] then R := R + 'E';
        if (AdsObject is TAdsUser) and (ListView.Items[I].SubItems[1] = RightsStr[True]) then R := R + 'H';
      end else if ListView.Columns.Items[0].Caption='Link' then begin
        R := '';
        if ListView.Items[I].SubItems[0] = RightsStr[True] then R := R + 'L';
        if (AdsObject is TAdsUser) and (ListView.Items[I].SubItems[1] = RightsStr[True]) then R := R + 'H';
      end;
      List.Add(ListView.Items[I].SubItems[ListView.Columns.Count-1]);
      List.Add(R);
    end;
  end;
end;

procedure TFmObjectRights.LvTablesDblClick(Sender: TObject);
var
  TableName:string;
begin
  inherited;
  if Dirty then raise Exception.Create('Lütfen önce yaptýðýnýz düzenlemeleri kaydediniz');
  if (LvTables.Selected = nil) or (LvTables.Selected.Caption = '') then begin
    showMessage('Lütfen haklarýný belirleyeceðiniz tabloyu seçiniz.');
    exit;
  end;
  TableName:=LvTables.Selected.SubItems[LvTables.Columns.Count-1];
  //btnApplyClick(self);
  with TFmFieldRights.Create(nil) do try
      Dictionary:=self.Dictionary;
      Item :=TableName;
      AdsObject := Self.AdsObject;
      mode:=emEdit;
      Edit;
  finally
      free;
  end;
end;

procedure TFmObjectRights.FillLinkRights;
var LinkRight: TAdsPermissionTypes;
    Links: TStringList;
    I: Integer;
begin
  Links := TStringList.Create;
  try
    Dictionary.GetDDLinkNames(Links);
    for I := 0 to Links.Count - 1 do
    begin
      LinkRight := AdsObject.GetLinkRight(Links[i]);
      AddToListView(LvLink, Links[i], LinkRight, 4);
    end;
  finally
    Links.Free;
  end;
  LvLink.SortColumn := 0;
end;

procedure TFmObjectRights.FillProcRights;
var ProcRight: TAdsPermissionTypes;
    Procs: TStringList;
    I: Integer;
begin
  Procs := TStringList.Create;
  try
    Dictionary.GetStoredProcedureNames(Procs);
    for I := 0 to Procs.Count - 1 do
    begin
      ProcRight := AdsObject.GetProcRight(Procs[i]);
      AddToListView(LvProc, Procs[i], ProcRight, 3);
    end;
  finally
    Procs.Free;
  end;
  LvProc.SortColumn := 0;
end;

procedure TFmObjectRights.SelectChList(Sender: TObject);
var
  inx,i:integer;
  temp:string;
  TempList:TAdvListView;
begin
  inherited;
  temp:=TSpeedButton(Sender).Name;
  inx:=strtoint(copy(temp,Length(temp)-1,2));
  Case Inx of
    1 :SelectListCheck(LvTables,0,true,6);
    2 :SelectListCheck(LvTables,0,false,5);
    3 :SelectListCheck(LvTables,1,true,6);
    4 :SelectListCheck(LvTables,1,false,5);
    5 :SelectListCheck(LvTables,2,true,6);
    6 :SelectListCheck(LvTables,2,false,5);
    7 :SelectListCheck(LvTables,3,true,6);
    8 :SelectListCheck(LvTables,3,false,5);
    9 :SelectListCheck(LvTables,4,true,6);
    10:SelectListCheck(LvTables,4,false,5);
    11:SelectListCheck(LvViews,0,true,6);
    12:SelectListCheck(LvViews,0,false,5);
    13:SelectListCheck(LvViews,1,true,6);
    14:SelectListCheck(LvViews,1,false,5);
    15:SelectListCheck(LvViews,2,true,6);
    16:SelectListCheck(LvViews,2,false,5);
    17:SelectListCheck(LvViews,3,true,6);
    18:SelectListCheck(LvViews,3,false,5);
    19:SelectListCheck(LvViews,4,true,6);
    20:SelectListCheck(LvViews,4,false,5);
    21:SelectListCheck(LvProc,0,true,6);
    22:SelectListCheck(LvProc,0,false,5);
    23:SelectListCheck(LvProc,1,true,6);
    24:SelectListCheck(LvProc,1,false,5);
    25:SelectListCheck(LvLink,0,true,6);
    26:SelectListCheck(LvLink,0,false,5);
    27:SelectListCheck(LvLink,1,true,6);
    28:SelectListCheck(LvLink,1,false,5);
  end;
  if inx<=10 then
    TempList:=LvTables
  else if inx<=20 then
    TempList:=LvViews
  else if inx<=24 then
    TempList:=LvProc
  else
    TempList:=LvLink;

  for i:=0 to TempList.Items.Count-1 do
    if (TempList.Items.Item[i] <> nil) then begin
       if TempList.Items.Item[i].SubItems[TempList.Columns.Count] = '0' then
          TempList.Items.Item[i].Caption := TempList.Items.Item[i].Caption + ' (*)';
       TempList.Items.Item[i].SubItems[TempList.Columns.Count] := '1';
    end;

  if not Dirty then Dirty := True;
end;

end.
