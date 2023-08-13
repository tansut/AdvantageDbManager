unit UAdsProc;

interface
uses Ace, AdsDictionary, AdsData, Classes, SysUtils, UAdsObj,
     UDbItems,UObjEdit;
type

TAdsProc = class (TAdsObject)
 protected
   procedure GetProcProperty(Prop: UNSIGNED16; Buffer: pointer; var Len: Integer);
   function  GetProcProp (Prop: UNSIGNED16): string;
 public
    function GetDLLName: string;
    function GetProcedureName: string;
    function GetProcInput: string;
    function GetProcOutput: string;
    procedure ParseParam (pVal: string; pList:TStringList );
    function GetProcName(const Param: string): string;
    procedure Execute;
    procedure CreateStoredProc(pName: String; pInParam: String; pOutParam: String;
                                         pDLLName: String; pProcName: String);
    procedure DropStoredProc (pName : String);
end;

TDBProc = class(TDbItem)
 public
   function GetMenuCount: Integer; override;
   function GetMenuItem(Index: Integer; var Cmd: TDBCommand): string; override;
   function ShowProperties: Boolean; override;
   function GetPropertyCount: Integer; override;
   function GetPropertyValue(Index: Integer): string; override;
   function OnCommand(Command: TDBCommand; Reserved: Integer): Boolean; override;
   procedure Execute;
end;

TDBProcList = class(TDBBaseList)
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

uses UProc, UDBSQL, UDbOperation;

{ TAdsProc }


procedure TAdsProc.CreateStoredProc (pName: String; pInParam: String; pOutParam: String;
                                     pDLLName: String; pProcName: String);
var
   strStatement : string;
   hSQL, SQLHandle : ADSHANDLE;
   mInOutParam : String;
begin
   if (pInParam <> '') and (pOutParam <> '') then
      mInOutParam := pOutParam + ',' + pInParam
   else
      mInOutParam := pOutParam + pInParam;

   strStatement := 'CREATE PROCEDURE "' + pName + '" (' + mInOutParam +')' +
                   ' FUNCTION ' + pProcName + ' IN LIBRARY ' + '"' + pDLLName + '"';

   AceCheck( nil, ACE.AdsCreateSQLStatement( Dictionary.ConnectionHandle, @hSql ) );
   try
      AceCheck( nil, ACE.AdsExecuteSQLDirect( hSql, pChar( strStatement ), @SQLHandle ) );
   except
      on E: Exception do
         raise Exception.Create( E.message + '---' + strStatement );
   end;

end;

procedure TAdsProc.DropStoredProc(pName: String);
var
   strStatement : string;
   hSQL, SQLHandle : ADSHANDLE;
begin
   strStatement := 'DROP PROCEDURE "' + pName + '"';
   AceCheck( nil, ACE.AdsCreateSQLStatement( Dictionary.ConnectionHandle, @hSql ) );
   AceCheck( nil, ACE.AdsExecuteSQLDirect( hSql, pChar( strStatement ), @SQLHandle ) );
end;

procedure TAdsProc.Execute;
var ParamCount, I: Integer;
    List: TStringList;
    SQL: string;
begin
  List := TStringList.Create;
  try
    ParseParam(GetProcInput, List);
    ParamCount := List.Count;
    SQL := 'execute procedure "' + Name + '" (';
    for I := 0 to ParamCount - 1 do
    begin
      SQL := SQL + ':"' + GetProcName(List[I]) + '"';
      if I <> ParamCount - 1 then SQL := SQL + ' ,';
    end;
    SQL := SQL + ')';
    with TFmSQL.Create(nil) do
    try
      Execute(self.Dictionary, SQL);
    finally
      //Free;
    end;
  finally
    List.Free;
  end;
end;

function TAdsProc.GetDLLName: string;
begin
  Result := GetProcProp (ADS_DD_PROC_DLL_NAME);
end;

function TAdsProc.GetProcedureName: string;
begin
  Result := GetProcProp (ADS_DD_PROC_DLL_FUNCTION_NAME);
end;

function TAdsProc.GetProcInput: string;
begin
  Result := GetProcProp (ADS_DD_PROC_INPUT);
end;

function TAdsProc.GetProcName(const Param: string): string;
begin
  Result := Copy(Param, 1, Pos(',', Param) - 1);
end;

function TAdsProc.GetProcOutput: string;
begin
  Result := GetProcProp (ADS_DD_PROC_OUTPUT);
end;

function TAdsProc.GetProcProp (Prop: UNSIGNED16): string;
var Buffer: array[0..ADS_DD_MAX_PROPERTY_LEN] of Char;
    Len: Integer;
begin
  Len := ADS_DD_MAX_PROPERTY_LEN;
  Buffer[ 0 ] := #0;
  GetProcProperty(Prop, @Buffer, Len);
  Result := Buffer;
end;

procedure TAdsProc.GetProcProperty(Prop: UNSIGNED16; Buffer: pointer;
  var Len: Integer);
var
 TempLen: UNSIGNED16;
begin
  TempLen := Len;
  try
    Dictionary.GetProcedureProperty (Name, Prop, Buffer, TempLen);
  except
    on E: EAdsDatabaseError do
    begin
      if not CheckLastAdsError then raise;
      FillChar(Buffer^, Len, 0);
    end;
  end;
  Len := TempLen;
end;



procedure TAdsProc.ParseParam(pVal: string; pList: TStringList);
  var mParam: String;
      mParamField: String;
      mpos,i : integer;
      mPos1 : integer;
begin
  mParam := pVal;
  while pos(';', mParam) > 0 do begin
     mpos := pos(';', mParam);
     mParamField := Copy (mParam,1, mpos - 1);
     pList.Add (mParamField);

     mParam := Copy (mParam, mpos+1, length(mParam) - mPos);
  end;
end;

{ TDBProc }

procedure TDBProc.Execute;
var AProc: TAdsProc;
begin
  AProc := TAdsProc.Create(Dictionary, Title);
  Try
   AProc.Execute;
  finally
   AProc.Free;
  end;  
end;

function TDBProc.GetMenuCount: Integer;
begin
  if IsAdmin then
     Result := 4
  else
     Result := 3;
end;

function TDBProc.GetMenuItem(Index: Integer; var Cmd: TDBCommand): string;
begin
  case Index of
  0: begin
       Result := 'Çalýþtýr ...';
       Cmd := dcOpen;
     end;
  1: begin
       Result := '-';
     end;
  2: begin
       if IsAdmin then begin
         Result := 'Sil';
         Cmd := dcDrop;
       end else begin
         Result := 'Özellikler';
         Cmd := dcProperties;
       end;
     end;
  3: begin
       Result := 'Özellikler';
       Cmd := dcProperties;
     end;
  end;
end;

function TDBProc.GetPropertyCount: Integer;
begin
  Result := 2;
end;

function TDBProc.GetPropertyValue(Index: Integer): string;
var ProcInfo: TAdsProc;
begin
  ProcInfo := TAdsProc.Create(Dictionary, Title);
  try
    case Index of
    0: Result := ProcInfo.GetProcedureName ;
    1: Result := ProcInfo.GetDLLName;
    end;
  finally
    ProcInfo.Free;
  end;
end;


function TDBProc.OnCommand(Command: TDBCommand;
  Reserved: Integer): Boolean;
begin
  Result := inherited OnCommand(Command, Reserved);
  if not Result then
  case Command of
  dcDrop: begin
            Dictionary.RemoveProcedure(Title);
            SendNotify(evRemoved);
          end;
  dcOpen: begin
            Execute;
          end;
  end;
end;

function TDBProc.ShowProperties: Boolean;
begin
  Result := EditItem(Dictionary, Title, TFmProc);
  if Result then SendNotify(evModified);
end;

{ TDBProcList }

procedure TDBProcList.CreateItems;
var Item: TDBProc;
    List: TStringList;
    I: Integer;
begin
  ConnectionRequiered;
  List := TStringList.Create;
  List.Sorted := True;
  try
    Dictionary.GetStoredProcedureNames(List);
    for I := 0 to List.Count - 1 do
    begin
      Item := TDBProc.Create(Dictionary, OnNotify);
      Item.SetTitle(List[I]);
      AddChild(Item);
    end;
  finally
    List.Free;
  end;
end;

function TDBProcList.GetTitle: string;
begin
  Result := 'Prosedürler';
end;

function TDBProcList.GetColumnCount: Integer;
begin
  RESULT := 3;
end;

function TDBProcList.GetColumnTitle(Index: Integer): string;
begin
  case Index of
  0: Result := 'Ad';
  1: Result := 'AEP Prosedür Adý';
  2: Result := 'AEP Prosedür Dosyasý';
  end;
end;

function TDBProcList.GetDefaultCommand: TDBCommand;
begin
  Result := dcOpen;
end;

function TDBProcList.GetMenuCount: Integer;
begin
  if IsAdmin then
  begin
    if ItemsCreated then
      Result := 1
    else Result := 2;
  end
  else Result := 0;
end;

function TDBProcList.GetMenuItem(Index: Integer;
  var Cmd: TDBCommand): string;
begin
  if IsAdmin then
  begin
    case Index of
    0: begin
       if ItemsCreated then
       begin
         Result := 'Yeni Prosedür ...';
         Cmd := dcNew;
       end else
       begin
         Result := 'Aç';
         Cmd := dcOpen;
       end;
     end;
    1: begin
       Result := 'Yeni Prosedür ...';
       Cmd := dcNew;
     end;
    end;
  end;
end;


function TDBProcList.OnCommand(Command: TDBCommand;
  Reserved: Integer): Boolean;
begin
  Result := inherited OnCommand(Command, Reserved);
  if not Result then
  case Command of
  dcNew:
   begin
     NewItem(Dictionary, TFmProc);
     Refresh;
   end;
  end;
end;

end.
