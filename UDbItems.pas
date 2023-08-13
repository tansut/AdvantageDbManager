unit UDbItems;

interface

uses UObjEdit, adsdictionary, Classes, UAdvTypes, UAdvUtils, UAdvConst, ComCtrls,
     AdsSet, ADsData, UDBCon, SysUtils,  Ace, UAdsObj, UDBSQL, adscnnct,Dialogs,
     Windows, Messages, Graphics, Controls, Forms;

type

TDBEvent = (evCreated, evChildsCreated, evChildsDestroyed, evModified, evRemoved);

TDBCommand = (dcNone, dcNew, dcProperties, dcOpen, dcClose, dcRefresh, dcDrop,
							dcSQL,dcEdit, dcHelp,dcChPassw,dcAdd,dcExport,dcImport,dcReport,
							dcRestructure,dcDeleteFile, dcRename, dcAutoInc, dcExportToCode);

TDBCommands = set of TDBCommand;


TDBBaseItem = class;
TDBBaseItemClass = class of TDBBaseItem;

TDBItemEvent = procedure(Sender: TObject; Event: TDBEvent) of object;

{ Base Class for Items and Lists }
TDBBaseItem = class
 private
   FDictionary: TAdsDictionary;
	 FOnNotify: TDBItemEvent;
   //FTreeNode: TTreeNode;
   FTag: Integer;
   FHelpID : Integer;
   procedure SetTreeNode(const Value: TTreeNode);
 protected
	 function _IsList: Boolean; virtual; abstract;
   function GetTitle: string; virtual; abstract;
   function GetHint: string; virtual;
   function SupportedCommands: TDBCommands; virtual;
   function OnCommand(Command: TDBCommand; Reserved: Integer): Boolean; virtual;
   procedure SendNotify(Event: TDBEvent);
   procedure ConnectionRequiered;
 public
   constructor Create(ADictionary: TAdsDictionary); overload; virtual;
   constructor Create(ADictionary: TAdsDictionary; NotifyEvent: TDBItemEvent); overload; virtual;
   property Dictionary: TAdsDictionary read FDictionary;
	 property IsList: Boolean read _IsList;
	 property Title: string read GetTitle;
	 property Hint: string read GetHint;
	 property OnNotify: TDBItemEvent read FOnNotify;
	 //property TreeNode: TTreeNode read FTreeNode write SetTreeNode;
	 property Tag: Integer read FTag write FTag;
	 property HelpID : Integer read FHelpId write FHelpId;
	 function SendCommand(Command: TDBCommand): Boolean;
	 function GetMenuCount: Integer; virtual;
	 function GetMenuItem(Index: Integer; var Cmd: TDBCommand): string; virtual;
	 function GetDefaultCommand: TDBCommand; virtual;
	 function ShowProperties: Boolean; virtual;
	 function ShowSql: Boolean; virtual;
	 function Refresh: Boolean; virtual;

	 function GetColumnCount: Integer; virtual;
	 function GetColumnTitle(Index: Integer): string; virtual;

   function GetPropertyCount: Integer; virtual;
   function GetPropertyValue(Index: Integer): string; virtual;
   function IsAdmin: Boolean;
   Procedure ShowHelp;

 end;

{ Base Class for Lists }
TDBBaseList = class (TDBBaseItem)
 private
   FItemsCreated: Boolean;
   FList: TList;
 protected
   function GetList: TList;
   procedure AddChild(Child: TObject); virtual;
   function _IsList: Boolean; override;
   function GetItemCount: Integer; virtual;
   function GetItems(Index: Integer): TDBBaseItem; virtual;
   function GetItemsByName(const Name: string): TDBBaseItem; virtual; abstract;
	 procedure CreateItems; virtual; abstract;
   procedure DestroyItems; virtual;
   function OnCommand(Command: TDBCommand; Reserved: Integer): Boolean; override;
 public
   constructor Create(ADictionary: TAdsDictionary); overload; override;
   constructor Create(ADictionary: TAdsDictionary; NotifyEvent: TDBItemEvent); overload; override;
   procedure Open; virtual;
   procedure Close; virtual;
   property ItemCount: Integer read GetItemCount;
   property Items[Index: Integer]: TDBBaseItem read GetItems; default;
   property ItemByName[const Name: string]: TDBBaseItem read GetItemsByName;
   property ItemsCreated: Boolean read FItemsCreated;
	 destructor Destroy; override;
	 function Refresh: Boolean; override;
end;

TDBBaseListClass = class of TDBBaseList;

TDBNamedList = class (TDBBaseList)
 private
  FTitle: string;
 public
   procedure SetTitle(const Value: string); virtual;
   function GetTitle: string; override;
   constructor Create(Dictionary: TAdsDictionary; Title: string);
end;

{ Base Class for Database Items}
TDBItem = class (TDBBaseItem)
 private
  FTitle: string;
 protected
   function _IsList: Boolean; override;
   function GetTitle: string; override;
 public
   procedure SetTitle(const Value: string); virtual;
end;

TAdsDataBase=class(TAdsObject)
private
  FAliasName:string;
  FDbPath:string;
	FDefPath:string;
  FTempPath:string;
  FLoginReq:Boolean;
  FChUserRight:Boolean;
  FDictEncrypt:Boolean;
	FTableEncrypt:Boolean;
  FTablePassw:string;
  FDesc:string;
  FInternetEnable:Boolean;
  FSecLevel:Integer;
  FMaxLogAtt:Integer;
  FMajorVer:Integer;
  FMinorVer:Integer;

	procedure SetAdminPassw(passw:string);
  function GetAdminPassw:string;
public
  property AliasName:string read FAliasName write FAliasName;
  property DbPath:string read FDbPath write FDbPath;
  property DefPath:string read FDefPath write FDefPath;
  property TempPath:string read FTempPath write FTempPath;
  property LoginReq:Boolean read FLoginReq write FLoginReq;
  property ChUserRight:Boolean read FChUserRight write FChUserRight;
  property DictEncrypt:Boolean read FDictEncrypt write FDictEncrypt;
  property TableEncrypt:Boolean read FTableEncrypt write FTableEncrypt;
  property Description:string read FDesc write FDesc;
  property TablePassw:string read FTablePassw write FTablePassw;
  property InternetEnable:Boolean read FInternetEnable write FInternetEnable;
	property SecLevel:Integer read FSecLevel write FSecLevel;
  property MaxLogAtt:Integer read FMaxLogAtt write FMaxLogAtt;
  property AdminPassw:string read GetAdminPassw write SetAdminPassw;
  property MajorVer:Integer read FMajorVer write FMajorVer;
  property MinorVer:Integer read FMinorVer write FMinorVer;

  function GetTableEncrypt: Boolean;
  function GetTablePass : string;
  procedure RefreshProperties;
	procedure SetProperties;
	procedure DeleteDatabase(DelTables:boolean);

end;

TDatabase = class (TDBBaseList)
 private
	 FAliasInfo: TAdvAliasInfo;
	 FConnectPath: string;
	 FConnectionType: TAdvConnectionType;
	 procedure SetAliasInfo(const Value: TAdvAliasInfo);
	 procedure SetConnectionType(const Value: TAdvConnectionType);
	 procedure SetConnectPath(const Value: string);
	 function  IsAdmin: Boolean;
 protected
	 function GetTitle: string; override;
	 function GetItemCount: Integer; override;
	 procedure CreateItems; override;
	 property AliasInfo: TAdvAliasInfo read FAliasInfo write SetAliasInfo;
	 property ConnectPath: string read FConnectPath write SetConnectPath;
	 property ConnectionType: TAdvConnectionType read FConnectionType write SetConnectionType;
	 function OnCommand(Command: TDBCommand; Reserved: Integer): Boolean; override;
 public
	 destructor Destroy; override;
	 function GetMenuCount: Integer; override;
	 function GetMenuItem(Index: Integer; var Cmd: TDBCommand): string; override;
	 function GetDefaultCommand: TDBCommand; override;
	 procedure Close; override;
	 function Refresh: Boolean; override;

	 function GetPropertyCount: Integer; override;
	 function GetPropertyValue(Index: Integer): string; override;
	 function ShowProperties:Boolean; override;
	 function GetConnectionType : String;

end;

TDatabaseList = class (TDBBaseList)
 private
 protected
	 procedure CreateItems; override;
	 function GetTitle: string; override;
	 function GetHint: string; override;
 public
	 function AddDatabase(AliasInfo: TAdvAliasInfo): TDatabase; overload;
	 function AddDatabase(ConnectPath: string): TDatabase; overload;
	 constructor Create(NotifyEvent: TDBItemEvent); reintroduce; overload;
	 constructor Create; reintroduce; overload;

	 function GetColumnCount: Integer; override;
	 function GetColumnTitle(Index: Integer): string; override;
end;

implementation

uses UDSEditor,UAdsUser, UAdsGroup, UAdsTable, UAdsProc, UAdsView,
		 UAdsRef, UAdsLink,UDatabase, Ureport, UExportCode, UFmExportCode,
		 UCodeExplorer;

{ TDBItemList }

procedure TDBBaseList.AddChild(Child: TObject);
begin
  GetList.Add(Child);
  if (Child is TDBBaseItem) and  (TDBBaseItem(Child).HelpId = 0) then
     TDBBaseItem(Child).HelpId := Self.HelpId;
end;

procedure TDBBaseList.Close;
begin
  if FItemsCreated then DestroyItems;
  FItemsCreated := False;
  SendNotify(evChildsDestroyed);
end;

constructor TDBBaseList.Create(ADictionary: TAdsDictionary);
begin
  inherited Create(ADictionary);
  FItemsCreated := False;
end;

constructor TDBBaseList.Create(ADictionary: TAdsDictionary;
  NotifyEvent: TDBItemEvent);
begin
  inherited Create(ADictionary, NotifyEvent);
	FItemsCreated := False;
end;

destructor TDBBaseList.Destroy;
begin
  Close;
  if FList <> nil then FList.Free;
end;

procedure TDBBaseList.DestroyItems;
begin
  if FList <> nil then
   while FList.Count > 0 do
   begin
     TObject(FList[0]).Free;
     FList.Delete(0);
   end;
end;

function TDBBaseList.GetItemCount: Integer;
begin
  if FList = nil then Result := 0
  else Result := FList.Count;
end;

function TDBBaseList.GetItems(Index: Integer): TDBBaseItem;
begin
  Result := TDBBaseItem(FList[Index]);
end;

function TDBBaseList.GetList: TList;
begin
  if FList = nil then
   FList := TList.Create;
  Result := FList;
end;

function TDBBaseList.OnCommand(Command: TDBCommand; Reserved: Integer): Boolean;
begin
	Result := inherited OnCommand(Command, Reserved);
  if not Result then
    case Command of
     dcOpen: begin
               Open;
               Result := True;
						 end;
		 dcClose:begin
               Close;
               Result := True;
             end;
    end;
end;

procedure TDBBaseList.Open;
begin
  if not FItemsCreated then CreateItems;
	FItemsCreated := True;
  SendNotify(evChildsCreated);
end;


function TDBBaseList.Refresh: Boolean;
begin
  Close;
  Open;
	Result := True;
end;

function TDBBaseList._IsList: Boolean;
begin
  Result := True;
end;

{ TDBItem }

function TDBItem.GetTitle: string;
begin
  Result := FTitle;
end;

procedure TDBItem.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

function TDBItem._IsList: Boolean;
begin
	Result := False;
end;

{ TDBBaseItem }

constructor TDBBaseItem.Create(ADictionary: TAdsDictionary);
begin
  FDictionary := ADictionary;
  FOnNotify := nil;
  FHelpID := 0;
end;

procedure TDBBaseItem.ConnectionRequiered;
var ServerTypes: TAdsServerTypes;
		user,pass:String;
    Compression: Integer;            
begin
  if (Dictionary <> nil) and (not Dictionary.IsConnected) then
  begin
    user:='AdsSys';
    if not ExecuteConnectionForm(ServerTypes,Dictionary.AliasName,user,pass, Compression) then Abort;
		Dictionary.AdsServerTypes := ServerTypes;
    Dictionary.UserName := user;
    Dictionary.Password:=pass;
    Dictionary.LoginPrompt := false;
    Dictionary.IsConnected := True;
    Dictionary.Tag := Compression;
    Dictionary.Compression := TAdsCompressionTypes(Compression);
  end;
end;

constructor TDBBaseItem.Create(ADictionary: TAdsDictionary;
  NotifyEvent: TDBItemEvent);
begin
  FDictionary := ADictionary;
  FOnNotify := NotifyEvent;
  FHelpID := 0;
	// bu satýr en sonda olmalý
  SendNotify(evCreated);
end;

function TDBBaseItem.GetHint: string;
begin
	Result := GetTitle;
end;

function TDBBaseItem.OnCommand(Command: TDBCommand; Reserved: Integer): Boolean;
begin
	Result := False;
	case Command of
	 dcExportToCode:
		begin
			Result := ShowSql;
		end;
   dcProperties:
    begin
			Result := ShowProperties;
    end;
   dcRefresh:
		begin
      Result := Refresh;
    end;
    dcDrop: if MessageDlg(self.GetTitle+' nesnesini silmek istediðinizden emin misiniz?',
              mtConfirmation, [mbYes, mbNo], 0) = mrNo then begin
            result:=true;
						exit;
            end;
    dcHelp:
     begin
       if (FHelpID > 0) then ShowHelp;
		 end;
  end;
end;

function TDBBaseItem.SendCommand(Command: TDBCommand): Boolean;
begin
  Result := OnCommand(Command, 0);

end;

procedure TDBBaseItem.SendNotify(Event: TDBEvent);
begin
  if Assigned(FOnNotify) then FOnNotify(Self, Event);
end;

procedure TDBBaseItem.SetTreeNode(const Value: TTreeNode);
begin
	//FTreeNode := Value;
end;

function TDBBaseItem.SupportedCommands: TDBCommands;
begin
  Result := [];
end;

function TDBBaseItem.GetMenuCount: Integer;
begin
  Result := 0;
end;

function TDBBaseItem.GetMenuItem(Index: Integer;
  var Cmd: TDBCommand): string;
begin
  Result := '';
  Cmd := dcNone;
end;

function TDBBaseItem.GetDefaultCommand: TDBCommand;
begin
  Result := dcProperties;
end;

function TDBBaseItem.ShowProperties: Boolean;
begin
  Result := False;
end;

function TDBBaseItem.Refresh: Boolean;
begin
  Result := False;
end;

function TDBBaseItem.GetPropertyCount: Integer;
begin
  Result := 0;
end;

function TDBBaseItem.GetColumnTitle(Index: Integer): string;
begin
  Result := 'Ad';
end;

function TDBBaseItem.GetPropertyValue(Index: Integer): string;
begin
  Result := '';
end;

function TDBBaseItem.GetColumnCount: Integer;
begin
	Result := 1;
end;

function TDBBaseItem.IsAdmin: Boolean;
begin
	 Result := UpperCase(FDictionary.UserName) = 'ADSSYS';
end;

procedure TDBBaseItem.ShowHelp;
begin
	Application.HelpCommand (HELP_CONTEXT, FHelpId);
end;

function TDBBaseItem.ShowSql: Boolean;
begin
	if Self.IsList then
	begin
		with TFmExportCode.Create(nil) do
		try
			Root := Self;

			if Self is TDBTableList then
				Exporter := nil
			else
				Exporter := CodeExporterList.Find('SQL');

			Execute();
		finally
			Free;
		end;
	end else
	begin
		with TCodeExporter.Create(nil) do
		try
			Destination := dtScreen;
			Dictionary := Self.Dictionary;
			ExporterFactory := CodeExporterList.Find('SQL');
			IncludeData := False;
			Items.AddDbItem(Self);

			ExportCode;
		finally
			Free;
		end;
	end;

	Result := True;
end;

{ TDatabase }


procedure TDatabase.Close;
begin
  if FItemsCreated then DestroyItems;
  FItemsCreated := False;
  Dictionary.IsConnected := False;
  SendNotify(evChildsDestroyed);
end;

function TDatabase.IsAdmin: Boolean;
begin
   Result := UpperCase(Dictionary.UserName) = 'ADSSYS';
end;

procedure TDatabase.CreateItems;
begin
  ConnectionRequiered;
  if IsAdmin then
  begin
    AddChild(TDBUserList.Create(Dictionary, OnNotify));
    AddChild(TDBGroupList.Create(Dictionary, OnNotify));
    AddChild(TDBTableList.Create(Dictionary, OnNotify));
    AddChild(TDBProcList.Create(Dictionary, OnNotify));
    AddChild(TDBViewList.Create(Dictionary, OnNotify));
		AddChild(TDBRefList.Create(Dictionary, OnNotify));
    AddChild(TDBLinkList.Create(Dictionary, OnNotify));
  end else begin
    AddChild(TDBTableList.Create(Dictionary, OnNotify));
    AddChild(TDBProcList.Create(Dictionary, OnNotify));
    AddChild(TDBViewList.Create(Dictionary, OnNotify));
    AddChild(TDBRefList.Create(Dictionary, OnNotify));
  end;
end;

destructor TDatabase.Destroy;
begin
  inherited Destroy;
  FDictionary.Free;
end;


function TDatabase.GetDefaultCommand: TDBCommand;
begin
  if ItemsCreated then Result := dcProperties
  else Result := dcOpen;
end;

function TDatabase.GetItemCount: Integer;
begin
  if FItemsCreated then
    if IsAdmin then
       Result := 7
    else
       Result := 4
  else Result := 0;
end;

function TDatabase.GetMenuCount: Integer;
begin
	if FItemsCreated then
		Result := 5
	else
		Result:=3;

end;

function TDatabase.GetMenuItem(Index: Integer;
	var Cmd: TDBCommand): string;
begin
	case Index of
	0: begin
			 if ItemsCreated then
			 begin
				 Result := '&Baðlantýyý Kes';
				 Cmd := dcClose;
			 end else begin
				 Result := '&Baðlan ...';
				 Cmd := dcOpen;
			 end;
		 end;

	1: begin
			 Result := '&SQL Penceresi';
			 Cmd := dcSQL;
		 end;
	2: begin
			 if FItemsCreated then
			 begin
				 Result := 'Veri Tabaný Raporu';
				 Cmd := dcReport;
			 end else
			 begin
				 Result := 'SQL Kaynak Kodu';
				 Cmd := dcExportToCode;
			 end;
		 end;

	3: begin
			 Result := 'SQL Kaynak Kodu';
			 Cmd := dcExportToCode;
		 end;
	4: begin
			 Result := '&Özellikler';
			 Cmd := dcProperties;
		 end;
	else Result := '-';
	end;
end;

function TDatabase.GetPropertyCount: Integer;
begin
  Result := 1;
end;

function TDatabase.GetPropertyValue(Index: Integer): string;
begin
  case Index of
  0: begin
       if ConnectionType = ctPath then Result := ConnectPath
       else Result := AliasInfo.Path;
     end;
  end;
end;

function TDatabase.GetTitle: string;
begin
  case FConnectionType of
   ctAlias: Result := FAliasInfo.Name;
   ctPath : Result := ExtractFileName(ConnectPath);
  end;
end;


function TDatabase.OnCommand(Command: TDBCommand;
  Reserved: Integer): Boolean;
var RepForm: TfmReport;
begin
  Result := inherited OnCommand(Command, Reserved);
  if not Result then
  case Command of
	dcSQL:
   begin
     if not ItemsCreated then Open;
     with TFmSQL.Create(nil) do
     try
       Execute(Self.Dictionary);
     finally
       //Free;
     end;
   end;
  dcReport:
    begin
      RepForm := TfmReport.Create(nil);
      try
         RepForm.dictionary := self.Dictionary;
         RepForm.ShowModal;
      finally
        RepForm.free;
     end;
    end;
  end;

end;

function TDatabase.Refresh: Boolean;
begin
  if ItemsCreated then
  begin
    DestroyItems;
    FItemsCreated := False;
    SendNotify(evChildsDestroyed);
    Open;
    Result := True;
  end else Result := False;
end;

procedure TDatabase.SetAliasInfo(const Value: TAdvAliasInfo);
begin
  FAliasInfo := Value;
  FConnectionType := ctAlias;
  Dictionary.AliasName := Value.Name;
end;

procedure TDatabase.SetConnectionType(const Value: TAdvConnectionType);
begin
  FConnectionType := Value;
end;

procedure TDatabase.SetConnectPath(const Value: string);
begin
  FConnectPath := Value;
  Dictionary.ConnectPath := Value;
end;

function TDatabase.showProperties: Boolean;
begin
  Result := EditItem(Dictionary, Title, TFmDatabase);
  if Result then SendNotify(evModified);
end;

function TDatabase.GetConnectionType : string;
  var mConnectionHandle : Integer;
      mConnectType : UNSIGNED16;
begin

  if not ItemsCreated then
     Result := ''
  else begin
    mConnectionHandle := Dictionary.ConnectionHandle;
    AdsGetConnectionType( mConnectionHandle, @mConnectType );

    case mConnectType of
    ADS_REMOTE_SERVER:
      Result := 'Uzak';
    ADS_LOCAL_SERVER:
      Result := 'Yerel';
    else
      Result := 'Internet';
    end;
  end;
end;

{ TDBNamedList }

constructor TDBNamedList.Create(Dictionary: TAdsDictionary; Title: string);
begin
  inherited Create(Dictionary);
  self.FTitle := Title;
end;

function TDBNamedList.GetTitle: string;
begin
  Result := FTitle;
end;

procedure TDBNamedList.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

{ TDatabaseList }

function TDatabaseList.AddDatabase(ConnectPath: string): TDatabase;
var Item: TDatabase;
    Dict: TAdsDictionary;
begin
  Dict := TAdsDictionary.Create(nil);
  Item := TDatabase.Create(Dict, OnNotify);
  Item.ConnectPath := ConnectPath;
  Item.ConnectionType := ctPath;
  AddChild(Item);
  Result := Item;
end;

function TDatabaseList.AddDatabase(AliasInfo: TAdvAliasInfo): TDatabase;
var Item: TDatabase;
    Dict: TAdsDictionary;
begin
  Result := nil;
  Dict := TAdsDictionary.Create(nil);
  Item := TDatabase.Create(Dict, OnNotify);
  Item.AliasInfo := AliasInfo;
  AddChild(Item);
  Result := Item;
end;

constructor TDatabaseList.Create;
begin
  inherited Create(nil);
end;

constructor TDatabaseList.Create(NotifyEvent: TDBItemEvent);
begin
  inherited Create(nil, NotifyEvent);
end;

procedure TDatabaseList.CreateItems;
var AliasList: TStringList;
    I: Integer;
    AliasInfo: TAdvAliasInfo;
begin
  AliasList := TStringList.Create;
  AliasList.Sorted := True;
  try
    GetAliasList(AliasList);
    for I := 0 to AliasList.Count - 1 do
    begin
      AliasInfo := GetAliasProperties(AliasList[I]);
      if AliasInfo.TableType = ttDictionary then
        AddDatabase(AliasInfo);
    end;
  finally
    AliasList.Free;
  end;
end;


function TDatabaseList.GetHint: string;
begin
  Result := 'Sistemde bulunan Advantage Rumuzlarý';
end;

function TDatabaseList.GetColumnTitle(Index: Integer): string;
begin
  case Index of
  0: Result := 'Ad';
  1: Result := 'Sözlük Dosyasý';
  end;
end;

function TDatabaseList.GetTitle: string;
begin
  Result := 'Veri Tabanlarý';
end;

function TDatabaseList.GetColumnCount: Integer;
begin
  Result := 2;
end;

{ TAdsDataBase }

procedure TAdsDataBase.DeleteDatabase(DelTables: boolean);

begin

end;


procedure TAdsDataBase.RefreshProperties;
var
   propertyBuffer : array [0..ADS_DD_MAX_PROPERTY_LEN] of char;
   pulVersion : UNSIGNED32;
   propertyLength : UNSIGNED16;
   ulErrorCode : UNSIGNED32;
   aucBuff : array [ 0..ADS_DD_MAX_PROPERTY_LEN ] of char;
   usBufLen : UNSIGNED16;
   usCheck : UNSIGNED16;
begin
   FAliasName:=Dictionary.AliasName;
     propertyLength := sizeof( UNSIGNED16 );
     try
       Dictionary.GetDatabaseProperty( ADS_DD_ENABLE_INTERNET,
                                     @usCheck,
                                     propertyLength );
     except
        ON E : EAdsDatabaseError do
        begin
          if not CheckLastAdsError then raise;
        end;
     end;
     FInternetEnable:=(usCheck=1);

     propertyLength := sizeof( UNSIGNED16 );
     try
       Dictionary.GetDatabaseProperty( ADS_DD_MAX_FAILED_ATTEMPTS,
                                       @usCheck,
                                       propertyLength );
     except
        ON E : EAdsDatabaseError do
        begin
          if not CheckLastAdsError then raise;
        end;
     end;
     FMaxLogAtt:=usCheck;

     propertyLength := sizeof( UNSIGNED16 );
     try
       Dictionary.GetDatabaseProperty( ADS_DD_INTERNET_SECURITY_LEVEL,
                                     @usCheck,
                                     propertyLength );
     except
        ON E : EAdsDatabaseError do
				begin
          if not CheckLastAdsError then raise;
        end;
     end;
     FSecLevel:=usCheck;

   propertyLength := sizeof( UNSIGNED16 );
   try
     Dictionary.GetDatabaseProperty( ADS_DD_VERIFY_ACCESS_RIGHTS,
                                     @usCheck,
                                     propertyLength );
   except
      ON E : EAdsDatabaseError do
      begin
        if not CheckLastAdsError then raise;
      end;
   end;
   FChUserRight:=(usCheck=1);

   propertyLength := sizeof( UNSIGNED16 );
   try
     Dictionary.GetDatabaseProperty( ADS_DD_ENCRYPT_NEW_TABLE,
                                       @usCheck,
                                       propertyLength );
   except
      ON E : EAdsDatabaseError do
      begin
        if not CheckLastAdsError then raise;
      end;
   end;
   FTableEncrypt:=(usCheck=1);

   propertyBuffer[ 0 ] := #0;
   propertyLength := length( propertyBuffer );
   try
			Dictionary.GetDatabaseProperty( ADS_DD_COMMENT,
                                        @propertyBuffer,
                                        propertyLength );
   except
      ON E : EAdsDatabaseError do
      begin
        if not CheckLastAdsError then raise;
      end;
   end;
   FDesc:=propertyBuffer;

   propertyBuffer[ 0 ] := #0;
   propertyLength := length( propertyBuffer );
   try
      Dictionary.GetDatabaseProperty( ADS_DD_DEFAULT_TABLE_PATH,
                                        @propertyBuffer,
                                        propertyLength );

   except
      ON E : EAdsDatabaseError do
      begin
        if not CheckLastAdsError then raise;
      end;
   end;
   FDefPath:=propertyBuffer;

   propertyBuffer[ 0 ] := #0;
   propertyLength := length( propertyBuffer );
   try
      Dictionary.GetDatabaseProperty( ADS_DD_TEMP_TABLE_PATH,
                                        @propertyBuffer,
                                        propertyLength );
   except
      ON E : EAdsDatabaseError do
      begin
				if not CheckLastAdsError then raise;
      end;
   end;
   FTempPath:=propertyBuffer;
   propertyLength := sizeof( UNSIGNED16 );
   try
      Dictionary.GetDatabaseProperty( ADS_DD_LOG_IN_REQUIRED,
                                        @usCheck,
                                        propertyLength );
   except
      ON E : EAdsDatabaseError do
      begin
        if not CheckLastAdsError then raise;
      end;
   end;
   FLoginReq:=(usCheck=1);

   propertyBuffer[ 0 ] := #0;
   propertyLength := length( propertyBuffer );
   try
     Dictionary.GetDatabaseProperty( ADS_DD_ENCRYPT_TABLE_PASSWORD,
                                     @propertyBuffer,
                                     propertyLength );
   except
      ON E : EAdsDatabaseError do
      begin
        if not CheckLastAdsError then raise;
      end;
   end;
   TablePassw:=propertyBuffer;

   propertyLength := SizeOf( UNSIGNED16 );

   try
     Dictionary.GetDatabaseProperty( ADS_DD_VERSION_MAJOR,
																		 @usCheck,
                                     propertyLength );
   except
      ON E : EAdsDatabaseError do
      begin
        if not CheckLastAdsError then raise;
      end;
   end;
   FMajorVer:=usCheck;

   propertyLength := SizeOf( UNSIGNED16 );   
   try
     Dictionary.GetDatabaseProperty( ADS_DD_VERSION_MINOR,
                                     @usCheck,
                                     propertyLength );
   except
      ON E : EAdsDatabaseError do
      begin
        if not CheckLastAdsError then raise;
      end;
   end;
   FMinorVer:=usCheck;

end;

function TAdsDataBase.GetAdminPassw: string;
var
  propertyBuffer : array [0..ADS_DD_MAX_PROPERTY_LEN] of char;
  propertyLength : UNSIGNED16;

begin
   propertyBuffer[ 0 ] := #0;
   propertyLength := length( propertyBuffer );
   try
     Dictionary.GetDatabaseProperty( ADS_DD_ADMIN_PASSWORD,
                                     @propertyBuffer,
                                     propertyLength );
   except
      ON E : EAdsDatabaseError do
      begin
        if not CheckLastAdsError then raise;
      end;
   end;
   result:=propertyBuffer;
end;

procedure TAdsDataBase.SetAdminPassw(passw: string);
begin
  Dictionary.SetDatabaseProperty( ADS_DD_ADMIN_PASSWORD, pChar( Passw ),
                                  length( Passw ) + 1 );
end;

procedure TAdsDataBase.SetProperties;
var
  temp:string;
  tempCheck:integer;
  SecurityLevel,MaxLogins:integer;
begin
   Dictionary.SetDatabaseProperty( ADS_DD_COMMENT, pChar(FDesc),
                                     length( FDesc ) + 1 );

   Dictionary.SetDatabaseProperty( ADS_DD_DEFAULT_TABLE_PATH, pChar(FDefPath),
                                     length( FDefPath ) + 1 );

   tempCheck:=integer(FChUserRight);
   Dictionary.SetDatabaseProperty( ADS_DD_VERIFY_ACCESS_RIGHTS, @tempCheck,
                                     sizeof( UNSIGNED16 ) );

   tempCheck:=integer(FLoginReq);
   Dictionary.SetDatabaseProperty( ADS_DD_LOG_IN_REQUIRED, @tempCheck,
                                     sizeof( UNSIGNED16 ) );

   if FTablePassw <> GetTablePass then
     Dictionary.SetDatabaseProperty( ADS_DD_ENCRYPT_TABLE_PASSWORD, pChar( FTablePassw ),
                                        length( FTablePassw ) + 1 );

   if FTableEncrypt <> GetTableEncrypt then begin
     tempCheck:=integer(FTableEncrypt);
     Dictionary.SetDatabaseProperty( ADS_DD_ENCRYPT_NEW_TABLE, @tempCheck,
                                     sizeof( UNSIGNED16 ) );
   end;

   tempCheck:=integer(InternetEnable);
   Dictionary.SetDatabaseProperty( ADS_DD_ENABLE_INTERNET, @tempCheck,
                                     sizeof( UNSIGNED16 ) );

   Dictionary.SetDatabaseProperty( ADS_DD_INTERNET_SECURITY_LEVEL, @FSecLevel,
                                     sizeof( UNSIGNED16 ) );

   Dictionary.SetDatabaseProperty( ADS_DD_MAX_FAILED_ATTEMPTS, @FMaxLogAtt,
                                     sizeof( UNSIGNED16 ) );


   Dictionary.SetDatabaseProperty( ADS_DD_TEMP_TABLE_PATH, pChar( FTempPath ),
                                        length( FTempPath ) + 1 );


   Dictionary.SetDatabaseProperty( ADS_DD_VERSION_MAJOR, @FMajorVer,
                                     sizeof( UNSIGNED16 ) );

   Dictionary.SetDatabaseProperty( ADS_DD_VERSION_MINOR, @FMinorVer,
                                     sizeof( UNSIGNED16 ) );
end;

function TAdsDataBase.GetTableEncrypt: Boolean;
  var
   propertyLength : UNSIGNED16;
   usCheck : UNSIGNED16;
begin
   propertyLength := sizeof( UNSIGNED16 );
   try
     Dictionary.GetDatabaseProperty( ADS_DD_ENCRYPT_NEW_TABLE,
                                       @usCheck,
                                       propertyLength );
   except
      ON E : EAdsDatabaseError do
      begin
        if not CheckLastAdsError then raise;
      end;
   end;
   Result := (usCheck=1);
end;

function TAdsDataBase.GetTablePass: string;
  var
   propertyLength : UNSIGNED16;
   propertyBuffer : array [0..ADS_DD_MAX_PROPERTY_LEN] of char;
begin
   propertyBuffer[ 0 ] := #0;
   propertyLength := length( propertyBuffer );
   try
     Dictionary.GetDatabaseProperty( ADS_DD_ENCRYPT_TABLE_PASSWORD,
                                     @propertyBuffer,
                                     propertyLength );
   except
      ON E : EAdsDatabaseError do
      begin
        if not CheckLastAdsError then raise;
      end;
   end;
   Result:=propertyBuffer;
end;

end.
