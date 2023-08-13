unit UAdsRef;

interface

uses Ace, AdsDictionary, AdsData, Classes, SysUtils, UAdsObj,
     UDbItems,UObjEdit;

type
TAdsRef = class (TAdsObject)
 protected
   procedure GetRefProperty(Prop: UNSIGNED16; Buffer: pointer; var Len: Integer);
   function  GetRefProp (Prop: UNSIGNED16): string;
 public
   function GetParentTable: string;
   function GetPrimaryKey: string;
   function GetChildTable: string;
   function GetForeignIndex: string;
   function GetPkeyError: string;
   function GetCascadeError: string;
   function GetUpdateRule: string;
   function GetDeleteRule: string;
end;

TDBRef = class(TDbItem)
 public
   function GetMenuCount: Integer; override;
   function GetMenuItem(Index: Integer; var Cmd: TDBCommand): string; override;
   function ShowProperties: Boolean; override;
   function GetPropertyCount: Integer; override;
   function GetPropertyValue(Index: Integer): string; override;
   function OnCommand(Command: TDBCommand; Reserved: Integer): Boolean; override;
end;

TDBRefList = class(TDBBaseList)
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

uses URef;

{ TAdsRef }

function TAdsRef.GetParentTable: string;
begin
  Result := GetRefProp (ADS_DD_RI_PRIMARY_TABLE);
end;

function TAdsRef.GetPrimaryKey: string;
begin
  Result := GetRefProp (ADS_DD_RI_PRIMARY_INDEX);
end;

function TAdsRef.GetChildTable: string;
begin
  Result := GetRefProp (ADS_DD_RI_FOREIGN_TABLE);
end;

function TAdsRef.GetForeignIndex: string;
begin
  Result := GetRefProp (ADS_DD_RI_FOREIGN_INDEX);
end;

function TAdsRef.GetPkeyError: string;
begin
  Result := GetRefProp (ADS_DD_RI_NO_PKEY_ERROR);
end;

function TAdsRef.GetCascadeError: string;
begin
  Result := GetRefProp (ADS_DD_RI_CASCADE_ERROR);
end;

function TAdsRef.GetUpdateRule: string;
  var cTemp :String;
begin
  Result := GetRefProp (ADS_DD_RI_UPDATERULE);
  cTemp := Result[1];

   if ( cTemp = #1 ) then
      Result := '1'
   else if ( cTemp = #2 ) then
      Result := '2'
   else if ( cTemp = #3 ) then
      Result := '3'
   else
      Result := '4';
end;

function TAdsRef.GetDeleteRule: string;
  var cTemp :String;
begin
  Result := GetRefProp (ADS_DD_RI_DELETERULE);
  cTemp := Result[1];

   if ( cTemp = #1 ) then
      Result := '1'
   else if ( cTemp = #2 ) then
      Result := '2'
   else if ( cTemp = #3 ) then
      Result := '3'
   else
      Result := '4';
end;

function TAdsRef.GetRefProp (Prop: UNSIGNED16): string;
var Buffer: array[0..ADS_DD_MAX_PROPERTY_LEN] of Char;
    Len: Integer;
begin
  Len := ADS_DD_MAX_PROPERTY_LEN;
  GetRefProperty(Prop, @Buffer, Len);
  Result := Buffer;
end;

procedure TAdsRef.GetRefProperty(Prop: UNSIGNED16; Buffer: pointer;
  var Len: Integer);
var
 TempLen: UNSIGNED16;
begin
  TempLen := Len;
  try
    Dictionary.GetRIProperty (Name, Prop, Buffer, TempLen);
  except
    on E: EAdsDatabaseError do
    begin
      if not CheckLastAdsError then raise;
      FillChar(Buffer^, Len, 0);
    end;
  end;
  Len := TempLen;
end;


{ TDBRef }

function TDBRef.GetMenuCount: Integer;
begin
  if IsAdmin then
     Result := 2
  else
     Result := 1;
end;

function TDBRef.GetMenuItem(Index: Integer; var Cmd: TDBCommand): string;
begin
  case Index of
  0: begin
       if IsAdmin then begin
         Result := 'Ýliþkisel Baðý Sil';
         Cmd := dcDrop;
       end
       else begin
         Result := 'Özellikler';
         Cmd := dcProperties;
       end;
     end;
  1: begin
       Result := 'Özellikler';
       Cmd := dcProperties;
     end;
  end;
end;

function TDBRef.GetPropertyCount: Integer;
begin
  Result := 4;
end;

function TDBRef.GetPropertyValue(Index: Integer): string;
var RefInfo: TAdsRef;
begin
  RefInfo := TAdsRef.Create(Dictionary, Title);
  try
    case Index of
    0: Result := RefInfo.GetParentTable;
    1: Result := RefInfo.GetPrimaryKey;
    2: Result := RefInfo.GetChildTable;
    3: Result := RefInfo.GetForeignIndex;
    end;
  finally
    RefInfo.Free;
  end;
end;


function TDBRef.OnCommand(Command: TDBCommand;
  Reserved: Integer): Boolean;
begin
  Result := inherited OnCommand(Command, Reserved);
  if not Result then
  case Command of
  dcDrop: begin
            Dictionary.RemoveRI(Title);
            SendNotify(evRemoved);
          end;
  end;
end;

function TDBRef.ShowProperties: Boolean;
begin
  Result := EditItem(Dictionary, Title, TFmRef);
  if Result then SendNotify(evModified);
end;

{ TDBRefList }

procedure TDBRefList.CreateItems;
var Item: TDBRef;
    List: TStringList;
    I: Integer;
begin
  ConnectionRequiered;
  List := TStringList.Create;
  List.Sorted := True;
  try
    Dictionary.GetRINames(List);
    for I := 0 to List.Count - 1 do
    begin
      Item := TDBRef.Create(Dictionary, OnNotify);
      Item.SetTitle(List[I]);
      AddChild(Item);
    end;
  finally
    List.Free;
  end;
end;

function TDBRefList.GetTitle: string;
begin
  Result := 'Ýliþkisel Baðlar';
end;

function TDBRefList.GetColumnCount: Integer;
begin
  RESULT := 5;
end;

function TDBRefList.GetColumnTitle(Index: Integer): string;
begin
  case Index of
  0: Result := 'Ad';
  1: Result := 'Temel Tablo';
  2: Result := 'Ana Anahtar';
  3: Result := 'Detay Tablo';
  4: Result := 'Yabancý Anahtar';
  end;
end;

function TDBRefList.GetDefaultCommand: TDBCommand;
begin
  Result := dcOpen;
end;

function TDBRefList.GetMenuCount: Integer;
begin
  if IsAdmin then
  begin
    if ItemsCreated then
      Result := 1
    else Result := 2;
  end
  else Result := 0;
end;

function TDBRefList.GetMenuItem(Index: Integer;
  var Cmd: TDBCommand): string;
begin
  if IsAdmin then
  begin
    case Index of
    0: begin
       if ItemsCreated then
       begin
         Result := 'Yeni Ýliþkisel Bað ...';
         Cmd := dcNew;
       end else
       begin
         Result := 'Aç';
         Cmd := dcOpen;
       end;
     end;
    1: begin
       Result := 'Yeni Ýliþkisel Bað ...';
       Cmd := dcNew;
     end;
    end;
  end;
end;


function TDBRefList.OnCommand(Command: TDBCommand;
  Reserved: Integer): Boolean;
begin
  Result := inherited OnCommand(Command, Reserved);
  if not Result then
  case Command of
  dcNew:
   begin
     NewItem(Dictionary, TFmRef);
     Refresh;
   end;
  end;
end;

end.
