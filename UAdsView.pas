unit UAdsView;

interface

uses Ace, AdsDictionary, AdsData, Classes, SysUtils, UAdsObj,
     UDbItems,UObjEdit,adscnnct, Db, adsfunc, adstable, UAdvUtils,UDSEditor;

type
TAdsView = class (TAdsObject)
 protected
   procedure GetViewProperty(Prop: UNSIGNED16; Buffer: pointer; var Len: Integer);
   function  GetViewProp (Prop: UNSIGNED16): string;
 public
   function GetSTMT: string;
   function GetDescription : string;
end;


TDBView = class(TDbItem)
protected
	 function OpenView: Boolean;
public
	 function GetMenuCount: Integer; override;
	 function GetMenuItem(Index: Integer; var Cmd: TDBCommand): string; override;
	 function ShowProperties: Boolean; override;
	 function GetPropertyCount: Integer; override;
	 function GetPropertyValue(Index: Integer): string; override;
	 function OnCommand(Command: TDBCommand; Reserved: Integer): Boolean; override;
end;


TDBViewList = class(TDBBaseList)
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

uses UView;
{ TAdsView }

function TDBView.OpenView: Boolean;
var AdsTable: TAdsTable;
    Conn: TAdsConnection;
begin
  Conn := TAdsConnection.Create(nil);
  AdsTable := TAdsTable.Create(Nil);
  ConvertDictToConn(Dictionary, Conn);
  try
    try
      Conn.IsConnected := True;
      AdsTable.AdsConnection := Conn;
      AdsTable.TableName := Title;
      AdsTable.Open;
      with TFMDSEditor.Create(nil) do
      try
        Result := Execute(AdsTable, True);
      finally
        Free;
      end;
    except
      Result := False;
      raise;
    end;
  finally
    Conn.IsConnected := False;
    AdsTable.Close;
    AdsTable.Free;
    Conn.Free;
  end;
end;

function TAdsView.GetSTMT: string;
begin
  Result := GetViewProp (ADS_DD_VIEW_STMT);
end;

function TAdsView.GetDescription: string;
begin
  Result := GetViewProp (ADS_DD_COMMENT);
end;

function TAdsView.GetViewProp (Prop: UNSIGNED16): string;
var Buffer: array[0..ADS_DD_MAX_PROPERTY_LEN] of Char;
    Len: Integer;
begin
  Len := ADS_DD_MAX_PROPERTY_LEN;
  GetViewProperty(Prop, @Buffer, Len);
  Result := Buffer;
end;

procedure TAdsView.GetViewProperty(Prop: UNSIGNED16; Buffer: pointer;
  var Len: Integer);
var
 TempLen: UNSIGNED16;
begin
  TempLen := Len;
  try
    Dictionary.GetViewProperty (Name, Prop, Buffer, TempLen);
  except
    on E: EAdsDatabaseError do
    begin
      if not CheckLastAdsError then raise;
      FillChar(Buffer^, Len, 0);
    end;
  end;
  Len := TempLen;
end;

{ TDBView }

function TDBView.GetMenuCount: Integer;
begin
  if IsAdmin then
     Result := 3
  else
     Result := 2;
end;

function TDBView.GetMenuItem(Index: Integer; var Cmd: TDBCommand): string;
begin
  case Index of
  0: begin
       Result := 'Aç';
       Cmd := dcOpen;
     end;
  1: begin
       if IsAdmin then begin
         Result := 'Görünümü Sil';
         Cmd := dcDrop;
       end
       else begin
         Result := 'Özellikler';
         Cmd := dcProperties;
       end;
     end;
  2: begin
       Result := 'Özellikler';
       Cmd := dcProperties;
     end;
  end;
end;

function TDBView.GetPropertyCount: Integer;
begin
  Result := 1;
end;

function TDBView.GetPropertyValue(Index: Integer): string;
var ViewInfo: TAdsView;
begin
  ViewInfo := TAdsView.Create(Dictionary, Title);
  try
    case Index of
    0: Result := ViewInfo.GetDescription;
    end;
  finally
    ViewInfo.Free;
  end;
end;

function TDBView.OnCommand(Command: TDBCommand;
  Reserved: Integer): Boolean;
begin
  Result := inherited OnCommand(Command, Reserved);
  if not Result then
  case Command of
  dcOpen: begin
            Result := OpenView;
          end;
  dcDrop: begin
            Dictionary.RemoveView (Title);
            SendNotify(evRemoved);
          end;
  end;
end;

function TDBView.ShowProperties: Boolean;
begin
  Result := EditItem(Dictionary, Title, TFmView);
  if Result then SendNotify(evModified);
end;

{ TDBViewList }

procedure TDBViewList.CreateItems;
var Item: TDBView;
    List: TStringList;
    I: Integer;
begin
  ConnectionRequiered;
  List := TStringList.Create;
  List.Sorted := True;
  try
    Dictionary.GetViewNames(List);
    for I := 0 to List.Count - 1 do
    begin
      Item := TDBView.Create(Dictionary, OnNotify);
      Item.SetTitle(List[I]);
      AddChild(Item);
    end;
  finally
    List.Free;
  end;
end;

function TDBViewList.GetTitle: string;
begin
  Result := 'Görünümler';
end;

function TDBViewList.GetColumnCount: Integer;
begin
  Result := 2;
end;

function TDBViewList.GetColumnTitle(Index: Integer): string;
begin
  case Index of
  0: Result := 'Ad';
  1: Result := 'Açýklama';
  end;
end;

function TDBViewList.GetDefaultCommand: TDBCommand;
begin
  Result := dcOpen;
end;

function TDBViewList.GetMenuCount: Integer;
begin
  if IsAdmin then
  begin
    if ItemsCreated then
       Result := 1
    else Result := 2;
  end
  else
    Result := 0;
end;

function TDBViewList.GetMenuItem(Index: Integer;
  var Cmd: TDBCommand): string;
begin
  if IsAdmin then
  begin
    case Index of
    0: begin
       if ItemsCreated then
       begin
         Result := 'Yeni Görünüm ...';
         Cmd := dcNew;
       end else
       begin
         Result := 'Aç';
         Cmd := dcOpen;
       end;
     end;
    1: begin
       Result := 'Yeni Görünüm ...';
       Cmd := dcNew;
     end;
    end;
  end;
end;


function TDBViewList.OnCommand(Command: TDBCommand;
  Reserved: Integer): Boolean;
begin
  Result := inherited OnCommand(Command, Reserved);
  if not Result then
  case Command of
  dcNew:
   begin
     NewItem(Dictionary, TFmView);
     Refresh;
   end;
  end;
end;

end.
