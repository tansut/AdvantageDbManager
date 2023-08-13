unit UAdsObj;

interface

uses Ace, AdsDictionary, AdsData, Classes, SysUtils;

type

TUserObjectRight = record
  Read, Write,Inherit: Boolean;
end;

TAdsObject = class
 private
  FDictionary: TAdsDictionary;
  FName: string;
 protected
  function CheckLastAdsError: Boolean;
 public
  constructor Create(Dictionary: TAdsDictionary; const Name: string); virtual;
  property Dictionary: TAdsDictionary read FDictionary write FDictionary;
  property Name: string read FName write Fname;
end;

TAdsRightsObject = class(TAdsObject)
 protected
   function GetObjectRight(const ObjectName: string; List: TStringList): TUserObjectRight; virtual;
   function GetObjectPerm(const ObjectName: string; List: TStringList): TAdsPermissionTypes; virtual;
 public
   function GetTableRight(const TableName: string): TAdsPermissionTypes; virtual; abstract;
   function GetViewRight(const ViewName: string): TAdsPermissionTypes; virtual; abstract;
   function GetLinkRight(const LinkName: string): TAdsPermissionTypes; virtual; abstract;
   function GetProcRight(const ProcName: string): TAdsPermissionTypes; virtual; abstract;
   function GetFieldRight(const TableName:string;FieldName:string):TAdsPermissionTypes; virtual; abstract;
   procedure SetTableRights(List: TStringList); virtual; abstract;
   procedure SetViewRights(List: TStringList); virtual; abstract;
   procedure SetLinkRights(List: TStringList); virtual; abstract;
   procedure SetProcRights(List: TStringList); virtual; abstract;
   procedure SetFieldRights(TableName:string;List: TStringList); virtual; abstract;
   function GetRightCount(const pType:char): Integer; virtual; abstract;
end;

procedure CreateDelimitedList(List: TStringList; const S: string; Token: Char);
procedure FormatRightsList( strRights : string; var oRightsList : TStringList; token : char );
function PermFromStr(Rights: String):TAdsPermissionTypes;

implementation

procedure CreateDelimitedList(List: TStringList; const S: string; Token: Char);
var I: Integer;
    Temp: string;
begin
  for I := 1 to Length(S) do
  begin
    if S[I] = Token then
    begin
      List.Add(Temp);
      Temp := '';
    end else Temp := Temp + S[I];
  end;
  if Temp > '' then List.Add(Temp);
end;

procedure FormatRightsList( strRights : string; var oRightsList : TStringList; token : char );
var
   iIndex : integer;
   strTempRights : string;
   strTempTable : String;
begin

   iIndex := 1;

   while( iIndex <= length( strRights ) ) do
   begin
      strTempTable := '';
      strTempRights := '';

      while( strRights[ iIndex ] <> ':' ) do
      begin
         strTempTable := strTempTable + strRights[ iIndex ];
         inc( iIndex );
      end;

      inc( iIndex );

      while( ( iIndex <= length( strRights ) ) and ( strRights[ iIndex ] <> ';' ) ) do
      begin
         strTempRights := strTempRights + strRights[ iIndex ];
         inc( iIndex );
      end;

      oRightsList.Add( strTempTable );

      oRightsList.Add( strTempRights );

      inc( iIndex );

   end;

end;

procedure FormatPermList( ObjName:string; strRights :TAdsPermissionTypes; var oRightsList : TStringList);
var
   strTempTable : String;
begin
   strTempTable:='';

   if  ptRead in  strRights then strTempTable:=strTempTable+'R';
   if  ptUpdate in  strRights then strTempTable:=strTempTable+'U';
   if  ptExecute in  strRights then strTempTable:=strTempTable+'E';
   if  ptInherit in  strRights then strTempTable:=strTempTable+'H';
   if  ptInsert in  strRights then strTempTable:=strTempTable+'I';
   if  ptDelete in  strRights then strTempTable:=strTempTable+'D';
   if  ptLinkAccess in  strRights then strTempTable:=strTempTable+'L';

   oRightsList.Add( ObjName );
   oRightsList.Add( strTempTable);

end;

function PermFromStr(Rights: String):TAdsPermissionTypes;
var
  i : integer;
begin
  Result:=[];
  for i :=1 to Length(Rights) do
    case Rights[i] of
        'R' :Result:=Result+[ptRead];
        'U' :Result:=Result+[ptUpdate];
        'E' :Result:=Result+[ptExecute];
        'H' :Result:=Result+[ptInherit];
        'I' :Result:=Result+[ptInsert];
        'D' :Result:=Result+[ptDelete];
        'L' :Result:=Result+[ptLinkAccess];
    end;
end;

{ TAdsObject }
function TAdsObject.CheckLastAdsError: Boolean;
var
  ErrorCode : UNSIGNED32;
  ErrBuff : array[ 0..ADS_MAX_ERROR_LEN ] of char;
  Len: UNSIGNED16;
begin
  ACE.AdsGetLastError(@ErrorCode, @ErrBuff, @Len);
  Result := (ErrorCode = AE_SUCCESS) or (ErrorCode = AE_PROPERTY_NOT_SET);
end;

constructor TAdsObject.Create(Dictionary: TAdsDictionary;
  const Name: string);
begin
  FDictionary := Dictionary;
  FName := Name;
end;

{ TAdsRightsObject }

function TAdsRightsObject.GetObjectPerm(const ObjectName: string;
  List: TStringList): TAdsPermissionTypes;
var
  Index,i : integer;
  Rights  :string;
begin
  Result:=[];
  Index := List.IndexOf(ObjectName);
  if Index >= 0 then
  begin
    Rights := UpperCase(List[Index+1]);
    for i :=1 to Length(Rights) do
      case Rights[i] of
        'R' :Result:=Result+[ptRead];
        'U' :Result:=Result+[ptUpdate];
        'E' :Result:=Result+[ptExecute];
        'H' :Result:=Result+[ptInherit];
        'I' :Result:=Result+[ptInsert];
        'D' :Result:=Result+[ptDelete];
        'L' :Result:=Result+[ptLinkAccess];
      end;
    end;
end;

function TAdsRightsObject.GetObjectRight(const ObjectName: string;
  List: TStringList): TUserObjectRight;
var Index: Integer;
    Rights: string;
begin
  with Result do
  begin
    Read := False;
    Write := False;
    Inherit := False;
  end;
  Index := List.IndexOf(ObjectName);
  if Index >= 0 then
  begin
    Rights := UpperCase(List[Index+1]);
    Result.Read := (Pos('X', Rights) > 0) or (Pos('R', Rights) > 0);
    Result.Write := Pos('W', Rights) > 0;
    Result.Inherit := Pos('I', Rights) > 0;
  end else Result.Inherit := True;
end;

end.
