unit UAdsUser;

interface
uses Ace, AdsDictionary, AdsData, Classes, SysUtils, UAdsObj,
     UDbItems,UObjEdit,UAdvUtils;
//     Windows, Messages, Graphics, Controls,forms, Dialogs;

type TAdsUser = class(TAdsRightsObject)
 private
    FTableRights: TStringList;
    FViewRights: TStringList;
    FGroupList: TStringList;
    function GetDescription: string;
    function GetGroup: TStringList;
    function GetInternetEnabled: Boolean;
    procedure SetDesription(const Value: string);
    procedure SetGroup(const Value: TStringList);
    procedure SetInternetEnabled(const Value: Boolean);
 protected
    procedure GetUserProperty(Prop: UNSIGNED16; Buffer: pointer; var Len: Integer);
    procedure SetUserProperty(Prop: UNSIGNED16; Buffer: pointer; Len: Integer);
 public
   property Description: string read GetDescription write SetDesription;
   property Group: TStringList read GetGroup write SetGroup;
   property InternetEnabled: Boolean read GetInternetEnabled write SetInternetEnabled;

   function GetTableRight(const TableName: string): TAdsPermissionTypes; override;
   function GetViewRight(const ViewName: string): TAdsPermissionTypes; override;
	 function GetLinkRight(const LinkName: string): TAdsPermissionTypes;  override;
   function GetProcRight(const ProcName: string): TAdsPermissionTypes;  override;
   function GetFieldRight(const TableName:string;FieldName:string):TAdsPermissionTypes; override;
   function GetRightCount(const pType:Char): Integer; override;

   procedure SetTableRights(List: TStringList); override;
   procedure SetViewRights(List: TStringList); override;
   procedure SetLinkRights(List: TStringList); override;
	 procedure SetProcRights(List: TStringList); override;
	 procedure SetFieldRights(TableName:string;List: TStringList);  override;
	 procedure SetPassword(const NewPassword: string);

	 constructor Create(Dictionary: TAdsDictionary; const Name: string); override;
	 destructor Destroy; override;
 protected

end;

TDBUser = class(TDbItem)
public
	 function GetMenuCount: Integer; override;
	 function GetMenuItem(Index: Integer; var Cmd: TDBCommand): string; override;
	 function ShowProperties: Boolean; override;
	 function GetPropertyCount: Integer; override;
	 function GetPropertyValue(Index: Integer): string; override;
	 function OnCommand(Command: TDBCommand; Reserved: Integer): Boolean; override;
	 function IsAdssys: Boolean;
	 procedure ChangeAdminPassw;
	 function GetDefaultCommand: TDBCommand;override;
end;

TDBUserList = class(TDBBaseList)
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
uses UUser;
{ TAdsUser }

constructor TAdsUser.Create(Dictionary: TAdsDictionary;
  const Name: string);
begin
  inherited Create(Dictionary, Name);
  FTableRights := nil;
  FViewRights := nil;
  FGroupList := nil;
end;


destructor TAdsUser.Destroy;
begin
  if Assigned(FTableRights) then FTableRights.Free;
  if Assigned(FViewRights) then FViewRights.Free;
  if Assigned(FGroupList) then FGroupList.Free;
  inherited Destroy;
end;

function TAdsUser.GetDescription: string;
var Buffer: array[0..ADS_DD_MAX_PROPERTY_LEN] of Char;
    Len: Integer;
begin
  Len := ADS_DD_MAX_PROPERTY_LEN;
  GetUserProperty(ADS_DD_COMMENT, @Buffer, Len);
  Result := Buffer;
end;

function TAdsUser.GetFieldRight(const TableName: string;
  FieldName: string): TAdsPermissionTypes;
begin
  Result:=Dictionary.GetPermissions(Name,
                                    ADS_DD_COLUMN_OBJECT,
                                    FieldName,
                                    TableName,
                                    False);
end;

function TAdsUser.GetGroup: TStringList;
var Buffer: array[0..ADS_DD_MAX_PROPERTY_LEN] of Char;
    Len: Integer;
begin
  if not Assigned(FGroupList) then
  begin
    FGroupList := TStringList.Create;
    FGroupList.Sorted := True;
    Len := ADS_DD_MAX_PROPERTY_LEN;
    GetUserProperty(ADS_DD_USER_GROUP_MEMBERSHIP, @Buffer, Len);
    CreateDelimitedList(FGroupList, Buffer, ';');
  end;
  Result := FGroupList;
end;

function TAdsUser.GetInternetEnabled: Boolean;
var Buffer: UNSIGNED16;
    Len: Integer;
begin
  Len := SizeOf(UNSIGNED16);
  GetUserProperty(ADS_DD_ENABLE_INTERNET, @Buffer, Len);
  Result := Boolean(Buffer);
end;

function TAdsUser.GetLinkRight(
  const LinkName: string): TAdsPermissionTypes;
begin
   Result:=Dictionary.GetPermissions(Name,
                                     ADS_DD_LINK_OBJECT,
                                     LinkName,
                                     '',
                                     False);
end;

function TAdsUser.GetProcRight(
  const ProcName: string): TAdsPermissionTypes;
begin
   Result:=Dictionary.GetPermissions(Name,
                                     ADS_DD_PROCEDURE_OBJECT,
                                     ProcName,
                                     '',
                                     False);
end;

function TAdsUser.GetRightCount(const pType: Char): Integer;
begin
  Case pType of
    'T' :Result:=5; //Table
    'V' :Result:=5; //View
    'P' :Result:=2; //Procedure
    'L' :Result:=2; //Link;
  end;
end;

function TAdsUser.GetTableRight(const TableName: string): TAdsPermissionTypes;
var Buffer: array[0..ADS_DD_MAX_PROPERTY_LEN] of Char;
    Len: Integer;
    Temp: string;
begin
  //if not Assigned(FTableRights) then
  //begin
    Result:=Dictionary.GetPermissions(Name,
                                      ADS_DD_TABLE_OBJECT,
                                      TableName,
                                      '',
                                      False);
 {
    FTableRights := TStringList.Create;
    FormatRightsList(Temp, FTableRights, ':');
  end;
  Result := GetObjectRight(TableName, FTableRights);
  }
end;

procedure TAdsUser.GetUserProperty(Prop: UNSIGNED16; Buffer: pointer;
  var Len: Integer);
var
 TempLen: UNSIGNED16;
begin
  TempLen := Len;
  try
    Dictionary.GetUserProperty(Name, Prop, Buffer, TempLen);
  except
    on E: EAdsDatabaseError do
    begin
      if not CheckLastAdsError then raise;
      FillChar(Buffer^, Len, 0);
      //PChar(Buffer^) := #0;
    end;
  end;
  Len := TempLen;
end;

function TAdsUser.GetViewRight(const ViewName: string): TAdsPermissionTypes;
var Buffer: array[0..ADS_DD_MAX_PROPERTY_LEN] of Char;
    Len: Integer;
    Temp: string;
begin
  Result:=Dictionary.GetPermissions(Name,
                                    ADS_DD_VIEW_OBJECT,
                                    ViewName,
                                    '',
                                    False);
{
  if not Assigned(FViewRights) then
  begin
    Len := ADS_DD_MAX_PROPERTY_LEN;
    GetUserProperty(ADS_DD_VIEWS_RIGHTS, @Buffer, Len);
    Temp := Buffer;
    FViewRights := TStringList.Create;
    //FViewRights.Sorted := True;
    FormatRightsList(Temp, FViewRights, ':');
  end;
  Result := GetObjectRight(ViewName, FViewRights);
  }
end;

procedure TAdsUser.SetDesription(const Value: string);
begin
  SetUserProperty(ADS_DD_COMMENT, PChar(Value), Length(Value));
end;

procedure TAdsUser.SetFieldRights(TableName:string;List: TStringList);
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

procedure TAdsUser.SetGroup(const Value: TStringList);
var I: Integer;
    AddList, RemoveList: TStringList;
begin
  AddList := TStringList.Create;
  RemoveList := TStringList.Create;
  for I := 0 to Value.Count - 1 do
   if Group.IndexOf(Value[i]) < 0 then AddList.Add(Value[I]);
  for I := 0 to Group.Count - 1 do
   if Value.IndexOf(Group[I]) < 0 then RemoveList.Add(Group[I]);
  try
    for I := 0 to AddList.Count - 1 do
      Dictionary.AddUserToGroup(AddList[I], Name);
    for I := 0 to RemoveList.Count - 1 do
      Dictionary.RemoveUserfromGroup(RemoveList[I], Name);
  finally
    AddList.Free;
    RemoveList.Free;
    FGroupList.Free;
    FGroupList := nil;
  end;
end;

procedure TAdsUser.SetInternetEnabled(const Value: Boolean);
var Res: UNSIGNED16;
begin
  Res := UNSIGNED16(Value);
  SetUserProperty(ADS_DD_ENABLE_INTERNET, @Res, SizeOf(UNSIGNED16));
end;


procedure TAdsUser.SetLinkRights(List: TStringList);
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
                                [ptLinkAccess,ptInherit]);

    if Perms <> [] then
      Dictionary.GrantPermissions(ADS_DD_LINK_OBJECT,
                                List[I],
                                '',
                                Name,
                                Perms);

    Inc(I,2);
  end;
end;

procedure TAdsUser.SetPassword(const NewPassword: string);
begin
  SetUserProperty(ADS_DD_USER_PASSWORD, PChar(NewPassword), Length(NewPassword)+1);
end;

procedure TAdsUser.SetProcRights(List: TStringList);
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
                                [ptExecute,ptInherit]);

    if Perms <> [] then
      Dictionary.GrantPermissions(ADS_DD_PROCEDURE_OBJECT,
                                List[I],
                                '',
                                Name,
                                Perms);

    Inc(I,2);
  end;
end;

procedure TAdsUser.SetTableRights(List: TStringList);
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
                                [ptRead, ptUpdate, ptInherit, ptInsert, ptDelete]);
    if Perms <> [] then
      Dictionary.GrantPermissions(ADS_DD_TABLE_OBJECT,
                                List[I],
                                '',
                                Name,
                                Perms);
    //Dictionary.SetObjectAccessRights(List[I], Name, List[I+1]);
    Inc(I,2);
  end;
  if I > 0 then
  begin
    FTableRights.Free;
    FTableRights := nil;
  end;

end;

procedure TAdsUser.SetUserProperty(Prop: UNSIGNED16; Buffer: pointer;
  Len: Integer);
begin
  Dictionary.SetUserProperty(Name, Prop, Buffer, Len);
end;


procedure TAdsUser.SetViewRights(List: TStringList);
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
                                [ptRead, ptUpdate, ptInherit, ptInsert, ptDelete]);
    if Perms <> [] then
      Dictionary.GrantPermissions(ADS_DD_VIEW_OBJECT,
                                List[I],
                                '',
                                Name,
                                Perms);

   // Dictionary.SetObjectAccessRights(List[I], Name, List[I+1]);
    Inc(I,2);
  end;
  if I > 0 then
  begin
    FViewRights.Free;
    FViewRights := nil;
  end;
end;

{ TDBUser }

procedure TDBUser.ChangeAdminPassw;
var
  mDb:TAdsDataBase;
  pw1,pw2:string;
begin
  if GetPassWord('Yeni Yönetici Þifresi',pw1) then
     if GetPassWord('Yeni Yönetici Þifresi Tekrar',pw2) then
        if pw1<>pw2 then
          raise Exception.Create('Yönetici þifresi için farklý giriþler yapýldýðý için iþlem iptal edildi.')
        else begin
            mDb:=TAdsDataBase.Create(Dictionary,'temp');
            try
              mDb.AdminPassw:=pw1;
            finally
              mDb.Free;
            end;
        end;
end;

function TDBUser.GetDefaultCommand: TDBCommand;
begin
  if IsAdssys then
    Result := dcNone
  else
    Result := dcProperties;
end;

function TDBUser.GetMenuCount: Integer;
begin
  if IsAdssys then
    Result := 1
  else Result := 2;
end;

function TDBUser.GetMenuItem(Index: Integer; var Cmd: TDBCommand): string;
begin
  case Index of
  0: begin
       if IsAdssys then
       begin
         Result := 'Þifre Deðiþtir';
         Cmd := dcChPassw;
       end else
       begin
         Result := 'Kullanýcýyý Sil';
         Cmd := dcDrop;
       end;
     end;
  1: begin
       Result := 'Özellikler';
       Cmd := dcProperties;
     end;
  end;
end;

function TDBUser.GetPropertyCount: Integer;
begin
  Result := 2;
end;

function TDBUser.GetPropertyValue(Index: Integer): string;
var UserInfo: TAdsUser;
begin
  if IsAdssys then
  begin
    case Index of
    0: Result := '';
    1: Result := 'Advantage Yönetici Kullanýcý';
    end;
    Exit;
  end;
  UserInfo := TAdsUser.Create(Dictionary, Title);
  try
    case Index of
    0: Result := UserInfo.Group.CommaText;
    1: Result := UserInfo.Description;
    end;
  finally
    UserInfo.Free;
  end;
end;

function TDBUser.IsAdssys: Boolean;
begin
  Result := UpperCase(Title) = 'ADSSYS';
end;

function TDBUser.OnCommand(Command: TDBCommand;
  Reserved: Integer): Boolean;
begin
  Result := inherited OnCommand(Command, Reserved);
  if not Result then
  case Command of
  dcDrop: begin
            Dictionary.RemoveUser(Title);
            SendNotify(evRemoved);
          end;
  dcChPassw:ChangeAdminPassw;
  end;
end;

function TDBUser.ShowProperties: Boolean;
begin
  Result := EditItem(Dictionary, Title, TFmUser);
  if Result then SendNotify(evModified);
end;

{ TDBUserList }

procedure TDBUserList.CreateItems;
var Item: TDBUser;
    List: TStringList;
    I: Integer;
begin
  ConnectionRequiered;
  List := TStringList.Create;
  List.Sorted := True;
  Item := TDBUser.Create(Dictionary, OnNotify);
  Item.SetTitle('ADSSYS');
  AddChild(Item);
  try
    Dictionary.GetUserNames(List);
    for I := 0 to List.Count - 1 do
    begin
      Item := TDBUser.Create(Dictionary, OnNotify);
      Item.SetTitle(List[I]);
      AddChild(Item);
    end;
  finally
    List.Free;
  end;
end;


function TDBUserList.GetColumnCount: Integer;
begin
  RESULT := 3;
end;

function TDBUserList.GetColumnTitle(Index: Integer): string;
begin
  case Index of
  0: Result := 'Ad';
  1: Result := 'Grup';
  2: Result := 'Açýklama';
  end;
end;

function TDBUserList.GetDefaultCommand: TDBCommand;
begin
  Result := dcOpen;
end;

function TDBUserList.GetMenuCount: Integer;
begin
  if ItemsCreated then
    Result := 1
  else Result := 2;
end;

function TDBUserList.GetMenuItem(Index: Integer;
  var Cmd: TDBCommand): string;
begin
  case Index of
  0: begin
       if ItemsCreated then
       begin
         Result := 'Yeni Kullanýcý ...';
         Cmd := dcNew;
       end else
       begin
         Result := 'Aç';
         Cmd := dcOpen;
       end;
     end;
  1: begin
       Result := 'Yeni Kullanýcý ...';
       Cmd := dcNew;
     end;
  end;
end;

function TDBUserList.GetTitle: string;
begin
  Result := 'Kullanýcýlar';
end;

function TDBUserList.OnCommand(Command: TDBCommand;
  Reserved: Integer): Boolean;
begin
  Result := inherited OnCommand(Command, Reserved);
  if not Result then
  case Command of
  dcNew:
   begin
     NewItem(Dictionary, TFmUser);
     Refresh;
   end;
  end;
end;

end.
 