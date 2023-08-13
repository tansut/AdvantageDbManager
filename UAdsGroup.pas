unit UAdsGroup;

interface

uses UAdsObj, Ace, AdsDictionary, AdsData, Classes, SysUtils,
     UDbItems, UObjEdit;

type TAdsGroup = class (TAdsRightsObject)
  private
    function GetDescription: string;
    procedure SetDescription(const Value: string);
  protected
    procedure GetGroupProperty(Prop: UNSIGNED16; Buffer: pointer; var Len: Integer);
  public
   function GetTableRight(const TableName: string): TAdsPermissionTypes; override;
   function GetViewRight(const ViewName: string): TAdsPermissionTypes; override;
   function GetLinkRight(const LinkName: string): TAdsPermissionTypes;  override;
   function GetProcRight(const ProcName: string): TAdsPermissionTypes;  override;
   function GetFieldRight(const TableName:string;FieldName:string):TAdsPermissionTypes; override;

   procedure SetTableRights(List: TStringList); override;
   procedure SetViewRights(List: TStringList); override;
   procedure SetProcRights(List: TStringList); override;
   procedure SetLinkRights(List: TStringList); override;
   procedure SetFieldRights(TableName:string;List: TStringList);  override;
   function GetRightCount(const pType:char): Integer; override;
   property Description: string read GetDescription write SetDescription;
end;

TDBGroup = class(TDbItem)
public
   function GetMenuCount: Integer; override;
   function GetMenuItem(Index: Integer; var Cmd: TDBCommand): string; override;
   function ShowProperties: Boolean; override;
   function GetPropertyCount: Integer; override;
   function GetPropertyValue(Index: Integer): string; override;
   function IsAdssys: Boolean;
protected
   function OnCommand(Command: TDBCommand; Reserved: Integer): Boolean; override;
end;

TDBGroupList = class(TDBBaseList)
	protected
		function GetTitle: string; override;
    function OnCommand(Command: TDBCommand; Reserved: Integer): Boolean; override;
  public
   procedure CreateItems; override;
   function GetMenuCount: Integer; override;
   function GetMenuItem(Index: Integer; var Cmd: TDBCommand): string; override;
   function GetDefaultCommand: TDBCommand; override;
   function GetColumnCount: Integer; override;
   function GetColumnTitle(Index: Integer): string; override;
end;

implementation

uses UGroup;
{ TAdsGroup }

function TAdsGroup.GetDescription: string;
var Buffer: array[0..ADS_DD_MAX_PROPERTY_LEN] of Char;
    Len: Integer;
begin
  Len := ADS_DD_MAX_PROPERTY_LEN;
  GetGroupProperty(ADS_DD_COMMENT, @Buffer, Len);
  Result := Buffer;
end;

function TAdsGroup.GetFieldRight(const TableName: string;
  FieldName: string): TAdsPermissionTypes;
begin
  Result:=Dictionary.GetPermissions(Name,
                                    ADS_DD_COLUMN_OBJECT,
                                    FieldName,
                                    TableName,
                                    False);

end;

procedure TAdsGroup.GetGroupProperty(Prop: UNSIGNED16; Buffer: pointer;
  var Len: Integer);
var
 TempLen: UNSIGNED16;
begin
  TempLen := Len;
  try
    Dictionary.GetUserGroupProperty(Name, Prop, Buffer, TempLen);
  except
    on E: EAdsDatabaseError do
    begin
      if not CheckLastAdsError then raise;
      FillChar(Buffer^, Len, 0);
    end;
  end;
  Len := TempLen;
end;

function TAdsGroup.GetLinkRight(
  const LinkName: string): TAdsPermissionTypes;
begin
   Result:=Dictionary.GetPermissions(Name,
                                     ADS_DD_LINK_OBJECT,
                                     LinkName,
                                     '',
                                     False);

end;

function TAdsGroup.GetProcRight(
  const ProcName: string): TAdsPermissionTypes;
begin
   Result:=Dictionary.GetPermissions(Name,
                                     ADS_DD_PROCEDURE_OBJECT,
                                     ProcName,
                                     '',
                                     False);

end;

function TAdsGroup.GetRightCount(const pType:Char): Integer;
begin
  Case pType of
    'T' :Result:=4; //Table
    'V' :Result:=4; //View
    'P' :Result:=1; //Procedure
    'L' :Result:=1; //Link;
  end;
end;

function TAdsGroup.GetTableRight(
  const TableName: string): TAdsPermissionTypes;
begin
    Result:=Dictionary.GetPermissions(Name,
                                      ADS_DD_TABLE_OBJECT,
                                      TableName,
                                      '',
                                      False);
end;

function TAdsGroup.GetViewRight(const ViewName: string): TAdsPermissionTypes;
begin
  Result:=Dictionary.GetPermissions(Name,
                                    ADS_DD_VIEW_OBJECT,
                                    ViewName,
                                    '',
                                    False);
end;

procedure TAdsGroup.SetDescription(const Value: string);
begin
  Dictionary.SetUserGroupProperty(Name,
                                  ADS_DD_COMMENT,
                                  PChar(Value),
                                  Length(Value)+1);

end;

procedure TAdsGroup.SetFieldRights(TableName: string; List: TStringList);
var I: Integer;
  NewPerms,OldPerms,RevPerms,GraPerms:TAdsPermissionTypes;
begin
  I := 0;
  while (I < List.Count) do
  begin
    RevPerms:=[];
    GraPerms:=[];
    OldPerms:=GetFieldRight(TableName,List[I]);
    NewPerms:=PermFromStr(List[I+1]);
    if (ptRead in OldPerms) and not(ptRead in NewPerms) then
       RevPerms:=RevPerms+[ptRead]
    else if  not (ptRead in OldPerms) and (ptRead in NewPerms) then
       GraPerms:=GraPerms+[ptRead];

    if (ptInsert in OldPerms) and not(ptInsert in NewPerms) then
       RevPerms:=RevPerms+[ptInsert]
    else if  not (ptInsert in OldPerms) and (ptInsert in NewPerms) then
       GraPerms:=GraPerms+[ptInsert];

    if (ptUpdate in OldPerms) and not(ptUpdate in NewPerms) then
       RevPerms:=RevPerms+[ptUpdate]
    else if  not (ptUpdate in OldPerms) and (ptUpdate in NewPerms) then
       GraPerms:=GraPerms+[ptUpdate];

    if  RevPerms<>[] then
       Dictionary.RevokePermissions(ADS_DD_COLUMN_OBJECT,
                                List[I],
                                TableName,
                                Name,
                                RevPerms);

    if GraPerms<>[] then
       Dictionary.GrantPermissions(ADS_DD_COLUMN_OBJECT,
                                List[I],
                                TableName,
                                Name,
                                GraPerms);
    //Dictionary.SetObjectAccessRights(List[I], Name, List[I+1]);
    Inc(I,2);
  end;
end;

procedure TAdsGroup.SetLinkRights(List: TStringList);
var I: Integer;
  perms:TAdsPermissionTypes;
begin
  I := 0;
  while (I < List.Count) do
  begin
    perms:=PermFromStr(List[I+1]);
    Dictionary.RevokePermissions(ADS_DD_LINK_OBJECT,
                                List[I],
                                '',
                                Name,
                                [ptLinkAccess]);

    if Perms <> [] then
      Dictionary.GrantPermissions(ADS_DD_LINK_OBJECT,
                                List[I],
                                '',
                                Name,
                                Perms);

    Inc(I,2);
  end;
end;

procedure TAdsGroup.SetProcRights(List: TStringList);
var I: Integer;
  perms:TAdsPermissionTypes;
begin
  I := 0;
  while (I < List.Count) do
  begin
    perms:=PermFromStr(List[I+1]);
    Dictionary.RevokePermissions(ADS_DD_PROCEDURE_OBJECT,
                                List[I],
                                '',
                                Name,
                                [ptExecute]);

    if Perms <> [] then
      Dictionary.GrantPermissions(ADS_DD_PROCEDURE_OBJECT,
                                List[I],
                                '',
                                Name,
                                Perms);

    Inc(I,2);
  end;
end;

procedure TAdsGroup.SetTableRights(List: TStringList);
var I: Integer;
  Perms:TAdsPermissionTypes;
begin
  I := 0;
  while (I < List.Count) do
  begin
    perms:=PermFromStr(List[I+1]);
    Dictionary.RevokePermissions(ADS_DD_TABLE_OBJECT,
                                List[I],
                                '',
                                Name,
                                [ptRead, ptUpdate, ptInsert, ptDelete]);
    if Perms <> [] then
      Dictionary.GrantPermissions(ADS_DD_TABLE_OBJECT,
                                List[I],
                                '',
                                Name,
                                Perms);
    Inc(I,2);
  end;
end;

procedure TAdsGroup.SetViewRights(List: TStringList);
var I: Integer;
  Perms:TAdsPermissionTypes;
begin
  I := 0;
  while (I < List.Count) do
  begin
    perms:=PermFromStr(List[I+1]);
    Dictionary.RevokePermissions(ADS_DD_VIEW_OBJECT,
                                List[I],
                                '',
                                Name,
                                [ptRead, ptUpdate, ptInsert, ptDelete]);
    if Perms <> [] then
      Dictionary.GrantPermissions(ADS_DD_VIEW_OBJECT,
                                List[I],
                                '',
                                Name,
                                Perms);

    Inc(I,2);
  end;
end;

{ TDBGroup }

function TDBGroup.GetMenuCount: Integer;
begin
  Result := 2;
end;

function TDBGroup.GetMenuItem(Index: Integer; var Cmd: TDBCommand): string;
begin
  case Index of
  0:
   begin
     Result := 'Grubu Sil';
     Cmd := dcDrop;
   end;
  1:
    begin
      Result := 'Özellikler';
      Cmd := dcProperties;
    end;
  end;
end;

function TDBGroup.GetPropertyCount: Integer;
begin
  Result := 1;
end;

function TDBGroup.GetPropertyValue(Index: Integer): string;
var Temp: TAdsGroup;
begin
  Temp := TAdsGroup.Create(Dictionary, Title);
  try
    case Index of
    0: begin
         Result := Temp.Description;
       end;
    end;
  finally
    Temp.Free;
  end;
end;

function TDBGroup.IsAdssys: Boolean;
begin
  Result := UpperCase(Title) = 'ADSSYS';
end;

function TDBGroup.OnCommand(Command: TDBCommand;
  Reserved: Integer): Boolean;
begin
  Result := inherited OnCommand(Command, Reserved);
  if not Result then
  case Command of
  dcDrop: begin
            Dictionary.DeleteUserGroup(Title);
            SendNotify(evRemoved);
          end;
  end;
end;

function TDBGroup.ShowProperties: Boolean;
begin
  Result := EditItem(Dictionary, Title, TFmGroup);
  if Result then SendNotify(evModified);
end;

{ TDBGroupList }

procedure TDBGroupList.CreateItems;
var Item: TDBGroup;
    List: TStringList;
    I: Integer;
begin
  ConnectionRequiered;
  List := TStringList.Create;
  List.Sorted := True;
  try
    Dictionary.GetGroupNames(List);
    for I := 0 to List.Count - 1 do
    begin
      Item := TDBGroup.Create(Dictionary, OnNotify);
      Item.SetTitle(List[I]);
      AddChild(Item);
    end;
  finally
    List.Free;
  end;
end;

function TDBGroupList.GetColumnCount: Integer;
begin
  Result := 2;
end;

function TDBGroupList.GetColumnTitle(Index: Integer): string;
begin
  case Index of
  0: Result := 'Ad';
  1: Result :='Açýklama';
  end;
end;

function TDBGroupList.GetDefaultCommand: TDBCommand;
begin
  Result := dcProperties;
end;

function TDBGroupList.GetMenuCount: Integer;
begin
  Result := 1;
end;

function TDBGroupList.GetMenuItem(Index: Integer;
  var Cmd: TDBCommand): string;
begin
  case Index of
  0: begin
       Result := 'Yeni Grup Ekle ...';
       Cmd := dcNew;
     end;
  end;
end;

function TDBGroupList.GetTitle: string;
begin
  Result := 'Gruplar';
end;

function TDBGroupList.OnCommand(Command: TDBCommand;
  Reserved: Integer): Boolean;
begin
  Result := inherited OnCommand(Command, Reserved);
  if not Result then
  case Command of
  dcNew:
   begin
     NewItem(Dictionary, TFmGroup);
     Refresh;
   end;
  end;
end;

end.
 