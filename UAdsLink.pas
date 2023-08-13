unit UAdsLink;

interface
uses Ace, AdsDictionary, AdsData, Classes, SysUtils, UAdsObj,
     UDbItems,UObjEdit, Adscnnct;

type
TAdsLink = class (TAdsObject)
 protected
   procedure GetLinkProperty(Prop: UNSIGNED16; Buffer: pointer; var Len: Integer);
   function  GetLinkProp (Prop: UNSIGNED16): string;
 public
   function GetLinkPath: string;
   function GetUserName: string;
   function  GetLinkOptions: TAdsLinkOptions;
end;

TDBLink = class(TDbItem)
 public
   function GetMenuCount: Integer; override;
   function GetMenuItem(Index: Integer; var Cmd: TDBCommand): string; override;
   function ShowProperties: Boolean; override;
   function GetPropertyCount: Integer; override;
   function GetPropertyValue(Index: Integer): string; override;
   function OnCommand(Command: TDBCommand; Reserved: Integer): Boolean; override;
end;

TDBLinkList = class(TDBBaseList)
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

uses ULink;
{TAdsLink}
function TAdsLink.GetLinkPath: string;
begin
  Result := GetLinkProp (ADS_DD_LINK_PATH);
end;

function TAdsLink.GetUserName: string;
begin
  Result := GetLinkProp (ADS_DD_LINK_USERNAME);
end;

function TAdsLink.GetLinkOptions: TAdsLinkOptions;
var mOptions     : UNSIGNED32;
    Len: UNSIGNED16;
    LOptions : TAdsLinkOptions;
begin
  Len := sizeof(UNSIGNED32);
  try
    Dictionary.GetLinkProperty( Name, ADS_DD_LINK_OPTIONS, @mOptions, Len );
  except
    on E: EAdsDatabaseError do
      if not CheckLastAdsError then raise;
  end;

  LOptions := [];

  if ( ( mOptions AND ADS_LINK_GLOBAL ) = ADS_LINK_GLOBAL ) then
     LOptions := LOptions + [loGlobal];

  if ( ( mOptions AND ADS_LINK_AUTH_ACTIVE_USER ) = ADS_LINK_AUTH_ACTIVE_USER ) then
     LOptions := LOptions + [loAuthenticateActiveUser];

  if ( ( mOptions AND ADS_LINK_PATH_IS_STATIC ) = ADS_LINK_PATH_IS_STATIC ) then
     LOptions := LOptions + [loPathIsStatic];

  Result := LOptions;
end;

function TAdsLink.GetLinkProp (Prop: UNSIGNED16): string;
var Buffer: array[0..ADS_DD_MAX_PROPERTY_LEN] of Char;
    Len: Integer;
begin
  Len := ADS_DD_MAX_PROPERTY_LEN;
  GetLinkProperty(Prop, @Buffer, Len);
  Result := Buffer;
end;

procedure TAdsLink.GetLinkProperty(Prop: UNSIGNED16; Buffer: pointer;
  var Len: Integer);
var
 TempLen: UNSIGNED16;
begin
  TempLen := Len;
  try
    Dictionary.GetLinkProperty (Name, Prop, Buffer, TempLen);
  except
    on E: EAdsDatabaseError do
    begin
      if not CheckLastAdsError then raise;
      FillChar(Buffer^, Len, 0);
    end;
  end;
  Len := TempLen;
end;

{TDBLink}

function TDBLink.GetMenuCount: Integer;
begin
  if IsAdmin then
     Result := 2
  else
     Result := 1;
end;

function TDBLink.GetMenuItem(Index: Integer; var Cmd: TDBCommand): string;
begin
  case Index of
  0: begin
       if IsAdmin then begin
         Result := 'VT Baðýný Sil';
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

function TDBLink.GetPropertyCount: Integer;
begin
  Result := 1;
end;

function TDBLink.GetPropertyValue(Index: Integer): string;
var LinkInfo: TAdsLink;
begin
  LinkInfo := TAdsLink.Create(Dictionary, Title);
  try
    case Index of
    0: Result := LinkInfo.GetLinkPath;
    end;
  finally
    LinkInfo.Free;
  end;
end;


function TDBLink.OnCommand(Command: TDBCommand;
  Reserved: Integer): Boolean;
begin
  Result := inherited OnCommand(Command, Reserved);
  if not Result then
  case Command of
  dcDrop: begin
            Dictionary.DropDDLink (Title,true);
            SendNotify(evRemoved);
          end;
  end;
end;

function TDBLink.ShowProperties: Boolean;
begin
  Result := EditItem(Dictionary, Title, TFmLink);
  if Result then SendNotify(evModified);
end;

{ TDBLinkList }

procedure TDBLinkList.CreateItems;
var Item: TDBLink;
    List: TStringList;
    I: Integer;
begin
  ConnectionRequiered;
  List := TStringList.Create;
  List.Sorted := True;
  try
    Dictionary.GetDDLinkNames (List);
    for I := 0 to List.Count - 1 do
    begin
      Item := TDBLink.Create(Dictionary, OnNotify);
      Item.SetTitle(List[I]);
      AddChild(Item);
    end;
  finally
    List.Free;
  end;
end;

function TDBLinkList.GetTitle: string;
begin
  Result := 'VT Baðlarý';
end;

function TDBLinkList.GetColumnCount: Integer;
begin
  RESULT := 2;
end;

function TDBLinkList.GetColumnTitle(Index: Integer): string;
begin
  case Index of
  0: Result := 'Ad';
  1: Result := 'Baðlanýlan Veri Tabaný';
  end;
end;

function TDBLinkList.GetDefaultCommand: TDBCommand;
begin
  Result := dcOpen;
end;

function TDBLinkList.GetMenuCount: Integer;
begin
  if IsAdmin then
  begin
    if ItemsCreated then
      Result := 1
    else Result := 2;
  end
  else Result := 0;
end;

function TDBLinkList.GetMenuItem(Index: Integer;
  var Cmd: TDBCommand): string;
begin
  if IsAdmin then
  begin
    case Index of
    0: begin
       if ItemsCreated then
       begin
         Result := 'Yeni VT Baðý ...';
         Cmd := dcNew;
       end else
       begin
         Result := 'Aç';
         Cmd := dcOpen;
       end;
     end;
    1: begin
       Result := 'Yeni VT Baðý ...';
       Cmd := dcNew;
     end;
    end;
  end;
end;


function TDBLinkList.OnCommand(Command: TDBCommand;
  Reserved: Integer): Boolean;
begin
  Result := inherited OnCommand(Command, Reserved);
  if not Result then
  case Command of
  dcNew:
   begin
     NewItem(Dictionary, TFmLink);
     Refresh;
   end;
  end;
end;

end.
