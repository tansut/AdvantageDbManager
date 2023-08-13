unit UAdsTable;

interface
uses Ace, AdsDictionary, AdsData, Classes, SysUtils, UAdsObj,
		 UDbItems,UObjEdit, AdsTable, adscnnct, UDBSQL, UDBCon,
		 UAdvUtils, UDSEditor,AdsFunc,Dialogs, Messages,Controls,
		 UDBSelect, UFmExportCode, AdsDataExporter;

const
   MAX_ARRAY_SIZE = 5000;

type

TFieldType = record
   usFieldType     : UNSIGNED16;
   usFieldLength   : UNSIGNED16;
   usFieldDecimals : UNSIGNED16;
end;

TAdsField=class(TAdsObject)
private
	 FTableName : string;
   FDefinition :TFieldType;
   FDescription:string;
   FDefaultValue:string;
   FMaxValue :string;
   FMinValue :string;
   FValidMess:string;
   FOldName  :string;
   FNotNull  :Boolean;
   FStartValue:longint;

   function GetDefaultValue:string;
	 procedure SetDefaultValue(const desc :string);
   function GetDefinition:TFieldType;
   procedure SetDefinition(fDef:TFieldType);
	 function GetMinValue:string;
   procedure SetMinValue(fValue:string);
   function GetMaxValue:string;
   procedure SetMaxValue(fValue:string);
public
   property TableName :string read FTableName write FTableName;
   property NotNull:boolean read FNotNull write FNotNull;
   property Definition:TFieldType read FDefinition write FDefinition;
   property Description:string read FDescription write  FDescription;
   property DefaultValue:string read FDefaultValue write FDefaultValue;
   property MaxValue :string read FMaxValue Write FMaxValue;
   property MinValue :string read FMinValue Write FMinValue;
   property ValidMess:string read FValidMess Write FValidMess;
   property OldName : string read FOldName Write FOldName;
   procedure GetAdsProperties;
   function GetFieldTypeToStr:string;
   property FieldType:string read GetFieldTypeToStr;
	 constructor Create(pDictionary: TAdsDictionary; const TableName: string; const name:string);overload;
	 constructor Create;overload;
   function GetDescription:string;
   procedure SetDescription(const desc :string);
	 function IsNotNull:Boolean;
   procedure SetNotNull(mValue:boolean);
   function GetValidationMessage:string;
   procedure SetValidationMessage(fMessage:string);
   function GetValidationExp:string;
   procedure SetValidationExp(fMessage:string);
   function TranslateFieldType(fField :string):UNSIGNED16;
   function GetFieldLength:Integer;
	 function getStartValue:longint;
   procedure setStartValue(sval:longint);
   procedure SetProperties( fField : TAdsField);
end;


TFieldList=class(TObject)
private
   FDictionary:TAdsDictionary;
   FTableName:String;
   FItemsCreated: Boolean;
   FList:TList;
   function GetFields(Index: Integer): TAdsField;
   function GetFieldsByName(const FName: string): TAdsField;
   function GetFieldIndex(const FName: string): Integer;
   function GetFieldCount: Integer;
   procedure DestroyItems;
   function GetList: TList;
   procedure AddChild(Child: TObject);
   procedure CreateFields;
public
   constructor create(Dictionary:TAdsDictionary;TableName:string);overload;
   constructor create(Dictionary:TAdsDictionary);overload;
	 destructor Destroy;

   property Field[index:integer]:TAdsField read GetFields;
   property FieldByName[const Name: string]: TAdsField read GetFieldsByName;
   property FieldIndex[const Name: string]: Integer read GetFieldIndex;
   property FieldCount: Integer read GetFieldCount;
   property ItemsCreated: Boolean read FItemsCreated;
   function Refresh: Boolean;
   procedure AddField(fField:TAdsField);
	 procedure DeleteField(fField:TAdsField);
   procedure Clear;
   procedure Open;
   procedure Close;
end;

TAdsIndex=class(TAdsObject)
private
  FTableName : string;
	FFileName:string;
  FCondition:string;
  FWhileCon :string;
  FExpression:string;
  FDescending:boolean;
  FUnique:boolean;
  FCompound:boolean;
  FCustom:boolean;
  FFTSIndex: Boolean;
  FKeepScore:Boolean;
  FCaseSensitive: Boolean;
	FFixed:Boolean;
  FProtectNumbers:Boolean;
  FPageSize : UNSIGNED32;
  FNoiseWord: String;
  FDelimiters: String;
  FDropChars: String;
	FConditionalChars: String;
  FDefaultNoise: Boolean;
  FDefaultDelimeters:Boolean;
  FDefaultDropChars : Boolean;
  FDefaultConditionals : Boolean;
  FMinWordLength: Integer;
	FMaxWordLength: Integer;
  function GetFileName: string;
  function getFields:TStringList;
  function ReplaceControlChars( strValue : string) : string;
public
  property TableName :string read FTableName;
  property FileName:string read GetFileName write FFileName;
	property condition:string read FCondition write FCondition;
  property WhileCon:string read FWhileCon write FWhileCon;
  property Descending:boolean read FDescending write FDescending;
  property Unique:boolean read FUnique write FUnique;
  property Compound:boolean read FCompound write FCompound;
	property Custom:boolean read FCustom write FCustom;
  property FTSIndex: Boolean read FFTSIndex write FFTSIndex;
  property KeepScore: Boolean read FKeepScore write FKeepScore;
  property CaseSensitive: Boolean read FCaseSensitive write FCaseSensitive;
  property Fixed:Boolean read FFixed write FFixed;
  property ProtectNumbers: Boolean read FProtectNumbers write FProtectNumbers;
  property NoiseWord:String read FNoiseWord write FNoiseWord;
  property Delimeters:String read FDelimiters write FDelimiters;
	property DropChars: String read FDropChars write FDropChars;
  property ConditionalChars:String read FConditionalChars write FConditionalChars;
  property DefaultNoise:Boolean read FDefaultNoise write FDefaultNoise;
  property DefaultDelimeters: Boolean read FDefaultDelimeters write FDefaultDelimeters;
  property DefaultDropChars: Boolean read FDefaultDropChars write FDefaultDropChars;
  property DefaultConditionals:Boolean read FDefaultConditionals write FDefaultConditionals;
  property MinWordLength:Integer read FMinWordLength write FMinWordLength;
  property MaxWordLength:Integer read FMaxWordLength write FMaxWordLength;
  property Expression:string read FExpression write FExpression;
	property Pagesize:UNSIGNED32 read FPageSize write FPageSize;
  property fields:TStringList read getFields;
  constructor create(Dictionary:TAdsDictionary;const TableName: string;const Name: string);
	procedure RefreshDictProp;
  function GetPageSize:integer;
  procedure CreateAdsIndex;
  procedure CreateAdsStandartIndex;
  procedure CreateAdsFTSIndex;
  procedure DeleteAdsIndex;
end;

TAdsTrigger=class(TAdsObject)
private
   procedure GetTrgProperty(Prop: UNSIGNED16; Buffer: pointer; var Len: Integer);
   function  GetTrgProp (Prop: UNSIGNED16): string;
   function  GetTrgTypeProp (Prop: UNSIGNED16): UNSIGNED32;
public
   function GetDesc: string;
	 function GetTriggerType: TAdsTrigType;
   function GetEventType: TAdsTrigEventType;
   function GetContainerType: TAdsTrigContainerType;
   function GetContainer : string;
	 function GetFunctionName: String;
	 function GetTableName: string;
	 function GetPriority: UNSIGNED32;
   function GetOptions: TAdsTrigOptions;
end;

TDBAdsTable=class(TAdsObject)
private
  FFields : TFieldList;
  FIndexes:TStringList;
  FTriggers:TStringList;
  FIndexFiles:TStringList;


	function GetDescription: string;
  procedure SetDescription(const Value: string);
  function getPrimaryKey:string;
  procedure SetPrimaryKey(const InxName:string);
  function getDefaultIndex:string;
  procedure SetDefaultIndex(const InxName:string);
  function getValidationMessage:string;
	procedure SetValidationMessage(const Messg:string);
  function getValidationExpression:string;
  procedure SetValidationExpression(const exp:string);
	function GetTablePath:string;
  function getAutoCreate:Boolean;
  procedure SetAutoCreate(ACreate:boolean);
  function getPermLevel:shortint;
  procedure SetPermLevel(pLevel:shortint);
  function GetEncrypted: boolean;
    procedure ManageAutoInc;
public
	constructor Create(Dictionary: TAdsDictionary;const Name: string);
  destructor Destroy; override;
	property PrimaryKey:string read GetPrimaryKey write SetPrimaryKey;
  property DefaultIndex:string read GetDefaultIndex write SetDefaultIndex;
  property Indexes:TStringList read FIndexes write FIndexes ;
  property Triggers: TStringList read fTriggers write FTriggers;
  property IndexFiles:TStringList read FIndexFiles  write FIndexFiles;
  property Description: string read GetDescription write SetDescription;
  property TablePath : string read GetTablePath;
  property ValidationMessage :string read GetValidationMessage write SetValidationMessage;
  property ValidationExpression : string read GetValidationExpression write SetValidationExpression;
  property AutoCreate : boolean read GetAutoCreate write SetAutoCreate;
  property Encrypted : boolean read GetEncrypted;
  property Fields : TFieldList read FFields write FFields;
	property PermissionLevel:shortint read GetPermLevel write SetPermLevel;
  function  GetIndexExp(fIndexName:string):string;
  Procedure SetIndexExp(fIndexName:string);
	procedure SaveProperties;
  procedure AddField( strName : string );
  procedure RemoveTable( bRemove : boolean);
  procedure ExportDictionary( strExportPath : string );
	procedure Encrypt;
  procedure Decrypt;
  procedure RefreshProperties;
	procedure CreateAdsTable(fName:string);
  procedure RestructureAdsTable (fAddFields, fChangeFields, fDelFields: String);
  function getDefaultTablePath:string;

	function IsEnc: Boolean;
	function GetFileSize: Cardinal;
	procedure SetAutoInc;


end;

TDBTable = class(TDbItem)
public
	 function GetMenuCount: Integer; override;
	 function GetMenuItem(Index: Integer; var Cmd: TDBCommand): string; override;
	 function GetDefaultCommand: TDBCommand; override;
	 function ShowProperties: Boolean; override;
	 function IsEnc: Boolean; // þifreli mi, yazmaya üþendim tümünü: Tansu
protected
	 function OnCommand(Command: TDBCommand; Reserved: Integer): Boolean; override;
	 function OpenTable: Boolean; virtual;
	 function EditTableDesign:Boolean;
	 function GetPropertyCount: Integer; override;
	 function GetPropertyValue(Index: Integer): string; override;
	 procedure AddIndexFile;
	 procedure ExportImport(opType:char);
         procedure ExportTable;
	 procedure ManageAutoInc;

end;

TDBTableList = class(TDBBaseList)
	protected
		function GetTitle: string; override;
		function OnCommand(Command: TDBCommand; Reserved: Integer): Boolean; override;
	public
		procedure CreateItems; override;
		function GetMenuCount: Integer; override;
		function GetMenuItem(Index: Integer; var Cmd: TDBCommand): string; override;
		function GetColumnCount: Integer; override;
		function GetColumnTitle(Index: Integer): string; override;
		procedure AddExistTable;
		procedure RemoveExistTable;
		procedure ExportToCode;
                procedure ExportTableDatas;
end;

implementation
uses UTable,UTableDesign,UDataOperations, URemoveTables, UAutoInc, UExportCode,
	UCodeExplorer, Forms, UFmDBTree, UFmDataExport;

{TAdsTrigger}

function TAdsTrigger.GetContainerType: TAdsTrigContainerType;
begin
  result := TAdsTrigContainerType( GetTrgTypeProp(ADS_DD_TRIG_CONTAINER_TYPE) - 1 );
end;

function TAdsTrigger.GetDesc: string;
begin
	Result := GetTrgProp (ADS_DD_COMMENT);
end;

function TAdsTrigger.GetEventType: TAdsTrigEventType;
begin
	Result := TAdsTrigEventType( GetTrgTypeProp(ADS_DD_TRIG_EVENT_TYPE) - 1 );
end;

function TAdsTrigger.GetTrgTypeProp (Prop: UNSIGNED16): UNSIGNED32;
var mType     : UNSIGNED32;
		Len: UNSIGNED16;
begin
	Len := sizeof(UNSIGNED32);
	try
		Dictionary.GetTriggerProperty( Name, prop, @mType, Len );
	except
		on E: EAdsDatabaseError do
			if not CheckLastAdsError then raise;
	end;
	Result := mType;
end;

function TAdsTrigger.GetTrgProp (Prop: UNSIGNED16): string;
var Buffer: array[0..ADS_DD_MAX_PROPERTY_LEN] of Char;
		Len: Integer;
begin
	Len := ADS_DD_MAX_PROPERTY_LEN;
	GetTrgProperty(Prop, @Buffer, Len);
	Result := Buffer;
end;

procedure TAdsTrigger.GetTrgProperty(Prop: UNSIGNED16; Buffer: pointer;
	var Len: Integer);
var
 TempLen: UNSIGNED16;
begin
	TempLen := Len;
	try
		Dictionary.GetTriggerProperty (Name, Prop, Buffer, TempLen);
	except
		on E: EAdsDatabaseError do
		begin
			if not CheckLastAdsError then raise;
			FillChar(Buffer^, Len, 0);
		end;
	end;
	Len := TempLen;
end;

function TAdsTrigger.GetTriggerType: TAdsTrigType;
var mType     : UNSIGNED32;
begin
	mType := GetTrgTypeProp(ADS_DD_TRIG_TRIGGER_TYPE);
	if ( ( mType and ADS_TRIGTYPE_BEFORE ) = ADS_TRIGTYPE_BEFORE ) then
			Result := ttBefore
	else if ( ( mType and ADS_TRIGTYPE_INSTEADOF ) = ADS_TRIGTYPE_INSTEADOF ) then
			Result := ttInsteadOf
	else if ( ( mType and ADS_TRIGTYPE_AFTER ) = ADS_TRIGTYPE_AFTER ) then
			Result := ttAfter;
end;

function TAdsTrigger.GetContainer: string;
begin
	Result := Trim(GetTrgProp (ADS_DD_TRIG_CONTAINER));
        if Result <> '' then
        begin
          if Result[Length(Result)] <> ';' then
           Result := Result + ';';
        end;
end;

function TAdsTrigger.GetFunctionName: String;
begin
	Result := GetTrgProp (ADS_DD_TRIG_FUNCTION_NAME);
end;

function TAdsTrigger.GetPriority: UNSIGNED32;
begin
	result := GetTrgTypeProp(ADS_DD_TRIG_PRIORITY);
end;

function TAdsTrigger.GetOptions: TAdsTrigOptions;
	var mOptions: UNSIGNED32;
begin
	mOptions := GetTrgTypeProp(ADS_DD_TRIG_OPTIONS);
	result := [];
	if ( ( mOptions and ADS_TRIGOPTIONS_WANT_MEMOS_AND_BLOBS ) <> ADS_TRIGOPTIONS_WANT_MEMOS_AND_BLOBS ) then
		 result := result + [ toNoMemosOrBlobs ];
	if ( ( mOptions and ADS_TRIGOPTIONS_WANT_VALUES ) <> ADS_TRIGOPTIONS_WANT_VALUES ) then
		 result := result + [ toNoValues ];
	if ( ( mOptions and ADS_TRIGOPTIONS_NO_TRANSACTION ) = ADS_TRIGOPTIONS_NO_TRANSACTION ) then
		 result := result + [ toNoTransaction ];
end;

function TAdsTrigger.GetTableName: string;
begin
  Result := GetTrgProp(ADS_DD_TRIG_TABLEID);
end;

{ TDBTable }
function TDBTable.OpenTable: Boolean;
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
        SetConnection(Conn);
        Dictionary:=Self.Dictionary;
        Result := Execute(AdsTable);
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

function TDBTable.ShowProperties: Boolean;
begin
  Result := EditItem(Dictionary, Title, TFmTable);
  if Result then SendNotify(evModified);
  // tablo özellikleri
end;

function TDBTable.GetMenuCount: Integer;
begin
  if IsAdmin then
     Result := 11
  else Result:=4;
end;

function TDBTable.GetMenuItem(Index: Integer;
  var Cmd: TDBCommand): string;
begin
  if IsAdmin then
    case Index of
    0:
      begin
       Result := 'Aç ...';
       Cmd := dcOpen;
      end;
		1:
      begin
        Result := 'Düzenle ...';
        Cmd := dcEdit;
      end;
    2:
      begin
        Result := '-';
      end;
		3:begin
       Result:='Otomatik Artan Sayý Yönetimi ...';
       Cmd :=dcAutoInc;
      end;

    4:begin
       Result:='Varolan Ýndeks Dosyasý Ekle ...';
			 Cmd :=dcAdd;
      end;
    5:
      begin
        Result := '-';
      end;

    6:
      begin
        Result := 'Veri Tabanýndan Çýkar';
        Cmd := dcDrop;
      end;
    7:
      begin
        Result := 'Sil';
        Cmd := dcDeleteFile;
			end;
    8:
      begin
        Result := '-';
      end;

    9:begin
       Result:='Veri Çýk ...';
       Cmd :=dcExport;
      end;
    10:
     begin
        Result := 'Özellikler';
        Cmd := dcProperties;
      end;
    end
  else begin
    case Index of
      0:
        begin
          Result := 'Aç';
          Cmd := dcOpen;
        end;
      1:
        begin
          Result := '-';
        end;

      2:begin
          Result:='Veri Çýk ...';
          Cmd :=dcExport;
        end;
      3:
        begin
          Result := 'Özellikler';
          Cmd := dcProperties;
        end;
    end;
  end;
end;

function TDBTable.EditTableDesign: Boolean;
begin
  Result := EditItem(Dictionary, Title, TFmTableDesign);
  if Result then SendNotify(evModified);
end;

function TDBTable.OnCommand(Command: TDBCommand;
  Reserved: Integer): Boolean;
begin
  if Command<>dcDrop then
    Result := inherited OnCommand(Command, Reserved);
  if not Result then
  case Command of
  dcOpen:
		begin
      Result := OpenTable;
    end;
  dcEdit:
    begin
      Result:=EditTableDesign;
    end;
  dcDrop:
    begin
			if MessageDlg('Bu iþlem '+self.GetTitle+' tablosunun tanýmýný veri sözlüðünden çýkaracaktýr. Tabloyu veri sözlüðünden baðýmsýz olarak açmak için daha sonra "Araçlar | Sözlük Tablosunu Serbest Býrak" komutunu kullanýn. '
           +'Devam edecek misiniz?',
              mtConfirmation, [mbYes, mbNo], 0) = mrNo then begin
            result:=true;
            exit;
            end;
       Dictionary.RemoveTable(title,false);
			 SendNotify(evRemoved);
    end;
  dcDeleteFile:
    begin
      if MessageDlg(self.GetTitle+' tabloyu veri sözlüðünden çýkaracak ve fiziksel olarak tablo ile iliþkli tüm dosyalarý silecektir. '
           +'Ýþlemin geri dönüþü yoktur.Devam edecek misiniz?',
              mtConfirmation, [mbYes, mbNo], 0) = mrNo then begin
            result:=true;
            exit;
            end;
       Dictionary.RemoveTable(title,true);
       SendNotify(evRemoved);
    end;
  dcAdd:
    begin
       AddIndexFile;
		end;
  dcExport:
    begin
      ExportTable;
    end;
  dcImport:
    begin
       ExportImport('I');
    end;
	dcAutoInc:
    begin
      ManageAutoInc;
    end;
  end;
end;


function TDBTable.GetPropertyCount: Integer;
begin
  result:=2;
end;

function TDBTable.GetPropertyValue(Index: Integer): string;
  var InfoTable :TDBADSTAble;
begin
  InfoTable:=TDbAdsTable.Create(Dictionary,title);
  try
    if Index = 0 then result:=InfoTable.Description
    else if Index = 1 then begin
      Result := FormatFileSize(InfoTable.GetFileSize);
    end;
  finally
		InfoTable.Free;
  end;
end;

procedure TDBTable.AddIndexFile;
var
  inxPath:TStrings;
  i :integer;
begin
	inxPath:=getDialogFileName('Advantage Ýndex Dosyasý (*.ADI)|*.ADI');
  try
    if (inxPath<>nil) and (inxPath.Count>0) then
      for i:=0 to inxPath.Count-1 do
        Dictionary.AddIndexFile(title,inxPath.Strings[i],'');
  finally
    if inxPath<>nil then
			inxPath.Free;
  end;
end;

procedure TDBTable.ExportImport(opType: char);
var
  temp:TDataOpType;
  AdsTable: TAdsTable;
  Conn: TAdsConnection;
begin
  Conn := TAdsConnection.Create(nil);
  AdsTable := TAdsTable.Create(Nil);
  ConvertDictToConn(Dictionary, Conn);
  try
    Conn.IsConnected := True;
    AdsTable.AdsConnection := Conn;
		AdsTable.TableName := Title;
    AdsTable.Open;
    case opType of
      'E':temp:=opExport;
      'I':temp:=opImport;
    end;
    with TFmDataOperations.Create(nil) do try
        prepare(AdsTable,Conn,temp);
        execute;
		finally
        free;
    end;
  finally
    Conn.IsConnected := False;
    AdsTable.Close;
    AdsTable.Free;
		Conn.Free;
  end;

end;

function TDBTable.IsEnc: Boolean;
var
  InfoTable :TDBADSTAble;
begin
  InfoTable:=TDbAdsTable.Create(Dictionary,title);
  try
    result:=InfoTable.IsEnc;
  finally
    InfoTable.Free;
  end;
end;

function TDBTable.GetDefaultCommand: TDBCommand;
begin
  Result := dcOpen;
end;

procedure TDBTable.ManageAutoInc;
var
  AdsTable: TDBAdsTable;
begin
  AdsTable := TDbAdsTable.Create(Dictionary,title);
  try
    AdsTable.SetAutoInc;
  finally
    AdsTable.Free;
  end;
end;

procedure TDBTable.ExportTable;
var
  AdsTable: TAdsTable;
  Conn: TAdsConnection;
begin
  Conn := TAdsConnection.Create(nil);
  AdsTable := TAdsTable.Create(Nil);
  ConvertDictToConn(Dictionary, Conn);
  try
    Conn.IsConnected := True;
    AdsTable.AdsConnection := Conn;
    AdsTable.TableName := Title;
    AdsTable.Open;
    with TFmDataExport.Create(nil) do
    try
      ExportDataSet(AdsTable);
    finally
      Free;
    end;
  finally
    Conn.IsConnected := False;
    AdsTable.Close;
    AdsTable.Free;
    Conn.Free;
  end;
end;


{ TDBTableList }

procedure TDBTableList.RemoveExistTable;
begin
  with TFmRemoveTables.Create(nil) do
  try
    if Execute(self.Dictionary) then self.Refresh;
  finally
    Free;
  end;
end;

procedure TDBTableList.AddExistTable;
var
	tablePath:TStrings;
  tableName:string;
  i :integer;
begin
  tablePath:=getDialogFileName('Advantage Tablosu (*.ADT)|*.ADT');
  try
    if (tablePath<>nil) and (tablePath.Count>0) then begin
      for  i:=0 to tablePath.Count-1 do begin
        tableName:=GetNameFromFileName(tablePath.Strings[i]);
				tableName:=copy(tableName,1,Length(tableName)-4);
        Dictionary.AddTable( tableName, tablePath.Strings[i] , '', '', ttAdsADT, ANSI );
      end;
      self.Refresh;
    end;
  finally
    if tablePath<>nil then
			 tablePath.Free;
  end;
end;

procedure TDBTableList.CreateItems;
var Item: TDBTable;
		List: TStringList;
		I: Integer;
begin
	ConnectionRequiered;
	List := TStringList.Create;
	List.Sorted := True;
	try
		Dictionary.GetTableNames(List);
		for I := 0 to List.Count - 1 do
		begin
			Item := TDBTable.Create(Dictionary, OnNotify);
			Item.SetTitle(List[I]);
			AddChild(Item);
		end;
	finally
		List.Free;
	end;
end;

function TDBTableList.GetColumnCount: Integer;
begin
  Result:=3;
end;

function TDBTableList.GetColumnTitle(Index: Integer): string;
begin
 case Index of
  0: Result := 'Ad';
	1: Result := 'Açýklama';
	2: Result := 'Boyut';
	end;
end;

function TDBTableList.GetMenuCount: Integer;
begin
	if ItemsCreated then
	begin
		if IsAdmin then  Result := 4
		else Result:=1
	end else
	begin
		if IsAdmin then Result := 6
		else Result:=2;
	end;
end;

function TDBTableList.GetMenuItem(Index: Integer;
	var Cmd: TDBCommand): string;
begin
	case Index of
	0: begin
			 if ItemsCreated then
			 begin
				 if IsAdmin then begin
					 Result := 'Yeni Tablo ...';
					 Cmd := dcNew;
				 end else
				 begin
					 Result := 'Tablo Verilerini Aktar ...';
					 Cmd := dcExport;
				 end;
			 end else
			 begin
				 Result := 'Aç';
				 Cmd := dcOpen;
			 end;
		 end;
	1: begin
			 if IsAdmin then
			 begin
				 if ItemsCreated then begin
					 Result := 'Varolan Tablolarý Ekle ...';
					 Cmd := dcAdd;
				 end else begin
					 Result := 'Yeni Tablo ...';
					 Cmd := dcNew;
				 end;
			 end else
			 begin
				 Result := 'Tablo Verilerini Aktar ...';
				 Cmd := dcExport;
			 end;
		 end;
	2: begin
			 if IsAdmin then
			 begin
				 if ItemsCreated then
				 begin
					 Result := 'Tablolarý Çýkar ...';
					 Cmd := dcDrop;
				 end else
				 begin
					 Result := 'Varolan Tablolarý Ekle ...';
					 Cmd := dcAdd;
				 end;
			 end;
		 end;
	3: begin
			 if IsAdmin then
			 begin
				 if ItemsCreated then
				 begin
					 Result := 'Tablo Verilerini Aktar ...';
					 Cmd := dcExport;
				 end else
				 begin
					 Result := 'Tablolarý Çýkar ...';
					 Cmd := dcDrop;
				 end;
			 end;
		 end;
	4: begin
			 if IsAdmin then
			 begin
				 Result := 'Tablo Verilerini Aktar ...';
				 Cmd := dcExport;
			 end;
		 end;
	end;
end;

function TDBTableList.GetTitle: string;
begin
	Result := 'Tablolar';
end;


function TDBTableList.OnCommand(Command: TDBCommand;
	Reserved: Integer): Boolean;
begin
	if Command <> dcDrop then
		Result := inherited OnCommand(Command, Reserved)
	else Result := False;
	if not Result then
	case Command of
		dcNew:
					begin
						NewItem(Dictionary, TFmTableDesign);
						Refresh;
					end;
		dcAdd: begin
						 AddExistTable;
					 end;
		dcDrop: begin
							RemoveExistTable;
						end;
		dcExport: begin
                            ExportTableDatas;
			  end;
	end;
end;


procedure TDBTableList.ExportToCode;
begin
        // deðiþecek // tansu

	with TFmExportCode.Create(nil) do
	try
		Exporter := nil;
		Root := Self;

		Execute();
	finally
		Free;
	end;
end;

procedure TDBTableList.ExportTableDatas;
begin
  with TFmDataExport.Create(nil) do
  try
    ExportDictionary(Self.Dictionary);
  finally
    Free;
  end;
end;

{ TDBAdsTable }

constructor TDBAdsTable.Create(Dictionary: TAdsDictionary;const Name: string);
begin
	 inherited;
	 FIndexes:=nil;
	 FTriggers := nil;
	 FIndexFiles:=nil;
	 FFields:=nil;
end;

destructor TDBAdsTable.Destroy;
begin
	if Assigned(FIndexes) then  FIndexes.Free;
	if Assigned(FTriggers) then  FTriggers.Free;
	if Assigned( FIndexFiles) then  FIndexFiles.Free;
	if  Assigned(FFields) then FFields.Destroy;
	inherited Destroy;
end;

function TDBAdsTable.getPrimaryKey: string;
var aucBuffer : array [0..MAX_ARRAY_SIZE] of char;
    usLength : UNSIGNED16;
begin
  usLength := MAX_ARRAY_SIZE;
  aucBuffer[ 0 ] := #0;
  try
		Dictionary.GetTableProperty( self.Name,
                                     ADS_DD_TABLE_PRIMARY_KEY,
                                     @aucBuffer,
																		 usLength );

  except
      ON E : EAdsDatabaseError do
      begin
        if not CheckLastAdsError then
          raise
  //      else
    //      result:='';
      end;
  end;
  result := aucBuffer;

end;

function TDBAdsTable.getTablePath: string;
var aucBuffer :array [0..MAX_ARRAY_SIZE] of char;
    usLength : UNSIGNED16;
begin
  usLength := MAX_ARRAY_SIZE;
  try
    Dictionary.GetTableProperty( self.Name,
                                     ADS_DD_TABLE_PATH,
                                     @aucBuffer,
                                     usLength );

  except
      ON E : EAdsDatabaseError do
      begin
				if not CheckLastAdsError then raise;
      end;
  end;

  result := aucBuffer;
end;


function TDBAdsTable.GetDescription: string;
var aucBuffer : array [0..MAX_ARRAY_SIZE] of char;
    usLength : UNSIGNED16;
begin
   usLength:=MAX_ARRAY_SIZE;
   aucBuffer[ 0 ] := #0;
   try
     Dictionary.GetTableProperty( self.Name,
                                     ADS_DD_COMMENT,
                                     @aucBuffer,
                                     usLength );
  except
      ON E : EAdsDatabaseError do
      begin
        if not CheckLastAdsError then raise;
      end;
  end;

   result := aucBuffer;
end;

procedure TDBAdsTable.SetDescription(const Value: string);
begin
  try
		Dictionary.SetTableProperty( Name,
                                 ADS_DD_COMMENT,
                                 pChar( Value ),
																 length( Value ) + 1,
                                 ADS_NO_VALIDATE,
                                 '' );
  except
      ON E : EAdsDatabaseError do
      begin
        if not CheckLastAdsError then raise;
      end;
  end;

end;

procedure TDBAdsTable.RefreshProperties;
begin
  if not Assigned (FIndexes) then  FIndexes:=TStringList.Create;
  if not Assigned (FTriggers) then  FTriggers:=TStringList.Create;
  if not Assigned (FIndexFiles) then  FIndexFiles:=TStringList.Create;
  if not Assigned (FFields) then FFields:=TFieldList.create(Dictionary,Name);
  FFields.CreateFields;
  FIndexes.Clear;
  FTriggers.Clear;
  FIndexFiles.Clear;
  Dictionary.GetIndexNames(self.Name,FIndexes);
  Dictionary.GetTriggerNames(self.Name,FTriggers);
  Dictionary.GetIndexFileNames(self.Name,FIndexFiles);
end;

procedure TDBAdsTable.AddField(strName: string);
begin

end;

procedure TDBAdsTable.Decrypt;
var
   usValue : UNSIGNED16;
begin

   usValue := 0;

   Dictionary.SetTableProperty(Name,
                               ADS_DD_TABLE_ENCRYPTION,
                               @usValue,
                               sizeof( UNSIGNED16 ),
                               ADS_DEFAULT,
                               '' );
end;

procedure TDBAdsTable.Encrypt;
var
   usValue : UNSIGNED16;
begin

   usValue := 1;

   Dictionary.SetTableProperty(Name,
                               ADS_DD_TABLE_ENCRYPTION,
                               @usValue,
                               sizeof( UNSIGNED16 ),
                               ADS_DEFAULT,
                               '' );
end;

procedure TDBAdsTable.ExportDictionary(strExportPath: string);
begin

end;

function TDBAdsTable.getAutoCreate: Boolean;
var
  usAutoCreate : UNSIGNED16;
  usLength     : UNSIGNED16;
begin
  usLength := sizeof( UNSIGNED16 );
  try
    Dictionary.GetTableProperty( self.Name,
                                 ADS_DD_TABLE_AUTO_CREATE,
                                 @usAutoCreate,
                                 usLength );
  except
      ON E : EAdsDatabaseError do
      begin
        if not CheckLastAdsError then raise;
      end;
  end;
  if ( usAutoCreate = 1 ) then
      result := TRUE
  else
      result := FALSE;
end;

function TDBAdsTable.getDefaultIndex: string;
var aucBuffer : array [0..MAX_ARRAY_SIZE] of char;
    usLength : UNSIGNED16;
begin
  usLength := MAX_ARRAY_SIZE;
  aucBuffer[ 0 ] := #0;
	try
    Dictionary.GetTableProperty( self.Name,
                                 ADS_DD_TABLE_DEFAULT_INDEX,
                                 @aucBuffer,
                                 usLength );
  except
      ON E : EAdsDatabaseError do
      begin
        if not CheckLastAdsError then raise;
      end;
  end;
  result:=aucBuffer;
end;

function TDBAdsTable.getValidationExpression: string;
var aucBuffer : array [0..MAX_ARRAY_SIZE] of char;
    usLength : UNSIGNED16;
begin
  usLength := MAX_ARRAY_SIZE;
  aucBuffer[ 0 ] := #0;
  try
     Dictionary.GetTableProperty( Name,
                                  ADS_DD_TABLE_VALIDATION_EXPR,
                                  @aucBuffer,
                                  usLength );

  except
      ON E : EAdsDatabaseError do
      begin
				if not CheckLastAdsError then raise;
      end;
  end;
	result:=aucBuffer;

end;

function TDBAdsTable.getValidationMessage: string;
var aucBuffer : array [0..MAX_ARRAY_SIZE] of char;
    usLength : UNSIGNED16;
begin
  usLength := MAX_ARRAY_SIZE;
  aucBuffer[ 0 ] := #0;
  try
     Dictionary.GetTableProperty( Name,
                                  ADS_DD_TABLE_VALIDATION_MSG,
                                  @aucBuffer,
                                  usLength );

  except
      ON E : EAdsDatabaseError do
      begin
        if not CheckLastAdsError then raise;
      end;
  end;
  result:=aucBuffer;

end;

procedure TDBAdsTable.RemoveTable(bRemove: boolean);
begin
  Dictionary.RemoveTable(Name,True);
end;

procedure TDBAdsTable.SaveProperties;
var
  i:integer;
begin
  for i:=0 to fields.FieldCount-1 do
    With fields do begin
      if  not (Field[i].Definition.usFieldType in [ADS_AUTOINC,ADS_BINARY,ADS_IMAGE,ADS_MEMO,ADS_RAW]) then
      begin
        Field[i].SetDefaultValue(Field[i].FDefaultValue);
        if  not (Field[i].Definition.usFieldType in [ADS_LOGICAL]) then begin
          Field[i].SetMinValue(Field[i].MinValue);
          Field[i].SetMaxValue(Field[i].MaxValue);
        end;
      end;
      Field[i].SetDescription(Field[i].Description);
      Field[i].SetValidationMessage(Field[i].ValidMess);
      Field[i].SetNotNull(Field[i].NotNull);
    end;
end;

procedure TDBAdsTable.SetAutoCreate(ACreate: boolean);
begin
  try
    Dictionary.SetTableProperty( Name,
                                 ADS_DD_TABLE_AUTO_CREATE,
                                 @ACreate,
                                 1,
                                 ADS_NO_VALIDATE,
                                 '');
  except
			ON E : EAdsDatabaseError do
      begin
        if not CheckLastAdsError then raise;
			end;
  end;
end;

procedure TDBAdsTable.SetDefaultIndex(const InxName: string);
begin
  try
    Dictionary.SetTableProperty( Name,
                                 ADS_DD_TABLE_DEFAULT_INDEX,
                                 pChar(InxName),
                                 length(InxName) + 1,
                                 ADS_NO_VALIDATE,
                                 '');
  except
      ON E : EAdsDatabaseError do
      begin
        if not CheckLastAdsError then raise;
      end;
  end;
end;

procedure TDBAdsTable.SetPrimaryKey(const InxName: string);
begin
  try
    Dictionary.SetTableProperty( Name,
                                 ADS_DD_TABLE_PRIMARY_KEY,
                                 pChar(InxName),
                                 length(InxName) + 1,
                                 ADS_NO_VALIDATE,
																 '');
  except
      ON E : EAdsDatabaseError do
			begin
        if not CheckLastAdsError then raise;
      end;
  end;
end;

procedure TDBAdsTable.SetValidationExpression(const exp: string);
begin
  try
    Dictionary.SetTableProperty( Name,
                                 ADS_DD_TABLE_VALIDATION_EXPR,
                                 pChar(Exp),
                                 length(Exp) + 1,
                                 ADS_NO_VALIDATE,
                                 '');
  except
      ON E : EAdsDatabaseError do
      begin
        if not CheckLastAdsError then raise;
      end;
  end;

end;

procedure TDBAdsTable.SetValidationMessage(const Messg: string);
begin
  try
    Dictionary.SetTableProperty( Name,
                                 ADS_DD_TABLE_VALIDATION_MSG,
																 pChar(Messg),
                                 length(Messg) + 1,
                                 ADS_NO_VALIDATE,
																 '');
  except
      ON E : EAdsDatabaseError do
      begin
        if not CheckLastAdsError then raise;
      end;
  end;
end;

function TDBAdsTable.GetIndexExp(fIndexName: string): string;
var
  aucBuffer      : array[ 0..ADS_DD_MAX_PROPERTY_LEN ] of char;
  usLength : UNSIGNED16;
begin
  usLength := ADS_DD_MAX_PROPERTY_LEN;
  aucBuffer[ 0 ] := #0;
  try
     Dictionary.GetIndexProperty( Name,
                                  fIndexName,
                                  ADS_DD_INDEX_EXPRESSION,
                                  @aucBuffer,
                                  usLength );
  except
      ON E : EAdsDatabaseError do
      begin
        if not CheckLastAdsError then raise;
      end;
  end;
  result:=aucBuffer;
end;

procedure TDBAdsTable.SetIndexExp(fIndexName: string);
begin

end;

function TDBAdsTable.getPermLevel:shortint;
var
  usBuff : UNSIGNED16;
  usLength : UNSIGNED16;
begin
  usLength := sizeof( UNSIGNED16 );
  try
    Dictionary.GetTableProperty( Name,
                                   ADS_DD_TABLE_PERMISSION_LEVEL,
                                   @usBuff,
                                   usLength );

  except
     ON E : EAdsDatabaseError do
     begin
       if not CheckLastAdsError then raise;
     end;
  end;

  if ( usBuff = ADS_DD_TABLE_PERMISSION_LEVEL_1 ) then
     result:=1
  else if ( usBuff = ADS_DD_TABLE_PERMISSION_LEVEL_3 ) then
     result:=3
  else
      {* Set it to the default value which is Permission level 2 *}
		 result:=2;

end;

procedure TDBAdsTable.SetPermLevel(pLevel: shortint);
var
  tempLevel : UNSIGNED16;
begin
  case pLevel of
    1:tempLevel:=ADS_DD_TABLE_PERMISSION_LEVEL_1;
    3:tempLevel:=ADS_DD_TABLE_PERMISSION_LEVEL_3;
  else
     tempLevel:=ADS_DD_TABLE_PERMISSION_LEVEL_2;
  end;
  try
    Dictionary.SetTableProperty( Name,
                                 ADS_DD_TABLE_PERMISSION_LEVEL,
                                 @tempLevel,
                                 sizeof(tempLevel),
                                 ADS_NO_VALIDATE,
                                 '');
  except
      ON E : EAdsDatabaseError do
      begin
        if not CheckLastAdsError then raise;
      end;
  end;

end;

procedure TDBAdsTable.CreateAdsTable(fName:string);
var
	strFieldList: string;
  hTable: ADSHANDLE;
  i,TempLen:integer;
	fFieldType:TFieldType;
begin
  strFieldList:='';
  for i:=0 to Fields.FieldCount-1 do
    With Fields do begin
      TempLen:=Field[i].GetFieldLength;
      strFieldList:=strFieldList+Field[i].Name+','+field[i].GetFieldTypeToStr;

      //if  pos(field[i].GetFieldTypeToStr,'CHARACTER;VARCHAR;NUMERIC')>0 then
      if (field[i].GetFieldTypeToStr='AUTOINC') then
         strFieldList:=strFieldList+','+IntToStr(field[i].getStartValue)
      else begin

        if TempLen>0 then begin
           fFieldType:=Field[i].Definition;
           fFieldType.usFieldLength:=TempLen;
           Field[i].Definition:=fFieldType;
        end;
        if  (Field[i].Definition.usFieldLength>0) then begin
            strFieldList:=strFieldList+','+inttostr(Field[i].Definition.usFieldLength);
            if pos(field[i].GetFieldTypeToStr,'DOUBLE;CURDOUBLE;MONEY')>0 then
              strFieldList:=strFieldList+','+inttostr(Field[i].Definition.usFieldDecimals);
        end;
      end;
      strFieldList:=strFieldList+';';
    end;
  try
    ACECheck( nil, ACE.AdsCreateTable(Dictionary.ConnectionHandle,
                                      pChar(fName),
																			'',
                                      ADS_ADT,
                                      ADS_ANSI,
																			ADS_PROPRIETARY_LOCKING,
                                      ADS_IGNORERIGHTS,
                                      512,
                                      PChar( strFieldList ),
                                      @hTable));
    ACE.AdsCloseTable( hTable );
    Name:=GetNameFromFileName(fName);
    for i:=0 to Fields.FieldCount-1 do begin
       Fields.Field[i].TableName:=Name;
       Fields.Field[i].Dictionary := Dictionary;
    end;
    SaveProperties;
  except
      ON E : EAdsDatabaseError do
      begin
        if not CheckLastAdsError then begin
          ACE.AdsCloseTable( hTable );
          raise;
        end;
      end;
  end;

end;

function TDBAdsTable.GetEncrypted: boolean;
var
   usLen : UNSIGNED16;
   encrypt:boolean;
begin

   usLen := sizeof( UNSIGNED16 );
   try
		 Dictionary.GetTableProperty( Name,
                                ADS_DD_TABLE_ENCRYPTION,
                                @encrypt,
                                uslen);
     result:=encrypt;
   except
     ON E : EAdsDatabaseError do
     begin
       if not CheckLastAdsError then raise;
     end;
  end;

end;


function TDBAdsTable.getDefaultTablePath: string;
begin
  Result := GetTablePathFromDictionary(Dictionary);
end;

function TDBAdsTable.IsEnc: Boolean;
var
   propertyBuffer : array [0..1] of char;
   propertyLength : UNSIGNED16;
begin
   propertyBuffer[ 0 ] := #0;
   propertyLength := length( propertyBuffer );
   Dictionary.GetTableProperty(Name, ADS_DD_TABLE_ENCRYPTION, @propertyBuffer, propertyLength);
   Result := (propertyBuffer[0] <> #0) or (propertyBuffer[1] <> #0);
end;

function TDBAdsTable.GetFileSize: Cardinal;
var
   f: file of Byte;
   size : Longint;
   S: string;
begin
  try
     AssignFile(f, GetTablePath);
     Reset(f);
     Result := FileSize(f);
     CloseFile(f);
   except
     Result := 0;
   end;
end;

procedure TDBAdsTable.RestructureAdsTable(fAddFields, fChangeFields, fDelFields: String);
  var mTableName : string;
begin
  mTableName := Name+'.adt';
  AceCheck( nil, ACE.AdsRestructureTable( Dictionary.ConnectionHandle,
                                          pChar( mTableName ),
                                          '',
                                          ADS_DEFAULT,
                                          ADS_ANSI,
                                          ADS_COMPATIBLE_LOCKING,
                                          ADS_CHECKRIGHTS,
                                          pChar( fAddFields ),
                                          pChar( fDelFields ),
                                          pChar( fChangeFields) ) );

end;

procedure TDBAdsTable.ManageAutoInc;
begin

end;

procedure TDBAdsTable.SetAutoInc;
begin
  with TFmAutoInc.Create(nil) do
  try
    Execute(Self);
  finally
    Free;
  end;    
end;

{ TAdsField }

constructor TAdsField.Create(pDictionary: TAdsDictionary;
  const TableName: string;const Name: string);
begin
  inherited create(pDictionary,Name);
  FTableName:=TableName;
  FDefinition.usFieldDecimals:=0;
  FStartValue:=0;
end;

function TAdsField.GetFieldTypeToStr:string;
begin
 case Definition.usFieldType of
			ADS_LOGICAL     : Result :=  'LOGICAL';
      ADS_NUMERIC     : Result :=  'NUMERIC';
      ADS_DATE        : Result :=  'DATE';
			ADS_STRING      : Result :=  'CHARACTER';
      ADS_MEMO        : Result :=  'MEMO';
      ADS_VARCHAR     : Result :=  'VARCHAR';
      ADS_COMPACTDATE : Result :=  'COMPACT DATE';
      ADS_DOUBLE      : Result :=  'DOUBLE';
      ADS_INTEGER     : Result :=  'INTEGER';
      ADS_IMAGE       : Result :=  'IMAGE';
      ADS_BINARY      : Result :=  'BINARY';
      ADS_SHORTINT    : Result :=  'SHORTINT';
      ADS_TIME        : Result :=  'TIME';
      ADS_TIMESTAMP   : Result :=  'TIMESTAMP';
      ADS_AUTOINC     : Result :=  'AUTOINC';
      ADS_RAW         : Result :=  'RAW';
      ADS_CURDOUBLE   : Result :=  'CURDOUBLE';
      ADS_MONEY       : Result :=  'MONEY';
      else
      Result :=                 'ERROR';
   end; {* case *}
end;

function TAdsField.GetDefaultValue: string;
var
   pucBuffer     : array[0..ADS_DD_MAX_PROPERTY_LEN ] of char;
   usPropertyLen : UNSIGNED16;
begin
   pucBuffer[ 0 ] := #0;
   usPropertyLen := ADS_DD_MAX_PROPERTY_LEN;
   try
     Dictionary.GetFieldProperty( TableName,
																		 Name,
                                     ADS_DD_FIELD_DEFAULT_VALUE,
                                     @pucBuffer,
																		 usPropertyLen );

   except
      ON E : EAdsDatabaseError do
        begin
          if not CheckLastAdsError then raise;
        end;
    end;
    result:=pucBuffer;
end;

function TAdsField.GetDefinition: TFieldType;
var
   pucBuffer     : array[0..ADS_DD_MAX_PROPERTY_LEN ] of char;
   usPropertyLen : UNSIGNED16;
   pucBuff       : array[ 0..ADS_DD_MAX_PROPERTY_LEN ] of char;
   usBuffLen     : UNSIGNED16;
   stFieldStruct : TFieldType;
begin
   usPropertyLen := sizeof( UNSIGNED16 );
   pucBuffer[ 0 ] := #0;
   usBuffLen := sizeof( stFieldStruct );

   try
      Dictionary.GetFieldProperty( Self.TableName,
                                     Name,
                                     ADS_DD_FIELD_DEFINITION,
                                     @stFieldStruct,
                                     usBuffLen );
	 except
     ON E : EAdsDatabaseError do
       begin
				 if not CheckLastAdsError then raise;
       end;
   end;
   result:=stFieldStruct;
end;

function TAdsField.GetDescription: string;
var
   pucBuffer     : array[0..ADS_DD_MAX_PROPERTY_LEN ] of char;
   usPropertyLen : UNSIGNED16;
begin
   pucBuffer[ 0 ] := #0;
   usPropertyLen := ADS_DD_MAX_PROPERTY_LEN;
   try
      Dictionary.GetFieldProperty( TableName,
                                   Name,
                                   ADS_DD_COMMENT,
                                   @pucBuffer,
                                   usPropertyLen );

   except
      ON E : EAdsDatabaseError do
        begin
          if not CheckLastAdsError then raise;
        end;
    end;
    result:=pucBuffer;
end;

function TAdsField.IsNotNull: boolean;
var aucBuffer :Boolean;
    usLength : UNSIGNED16;
begin
   usLength:=sizeof( UNSIGNED16 );
   try
     Dictionary.GetFieldProperty( self.TableName,
                                 Name,
                                 ADS_DD_FIELD_CAN_NULL	,
                                 @aucBuffer,
                                 usLength );
   except
      ON E : EAdsDatabaseError do
      begin
        if not CheckLastAdsError then raise;
      end;
   end;

   result := not aucBuffer;

end;

procedure TAdsField.SetDefaultValue(const desc: string);
begin
  try
    if desc<>'' then
       Dictionary.SetFieldProperty( TableName,
                                 Name,
                                 ADS_DD_FIELD_DEFAULT_VALUE,
                                 pChar( desc ),
                                 length( desc ) + 1,
                                 ADS_NO_VALIDATE,
																 '' )
    else
       Dictionary.SetFieldProperty( TableName,
																 Name,
                                 ADS_DD_FIELD_DEFAULT_VALUE,
                                 nil,
                                 length( desc ) + 1,
                                 ADS_NO_VALIDATE,
                                 '' );
  except
    ON E : EAdsDatabaseError do
        begin
          if not CheckLastAdsError then raise;
        end;
  end;

end;

procedure TAdsField.SetDescription(const desc: string);
begin
  try
    if desc<>'' then
       Dictionary.SetFieldProperty( TableName,
                                 Name,
                                 ADS_DD_COMMENT,
                                 pChar( desc ),
                                 length( desc ) + 1,
                                 ADS_NO_VALIDATE,
                                 '' )
    else
       Dictionary.SetFieldProperty( TableName,
                                 Name,
																 ADS_DD_COMMENT,
                                 nil,
                                 length( desc ) + 1,
																 ADS_NO_VALIDATE,
                                 '' );
  except
    ON E : EAdsDatabaseError do
        begin
          if not CheckLastAdsError then raise;
        end;
  end;
end;

function TAdsField.GetMaxValue: string;
var
   pucBuffer     : array[0..ADS_DD_MAX_PROPERTY_LEN ] of char;
   usPropertyLen : UNSIGNED16;
begin
   pucBuffer[ 0 ] := #0;
   usPropertyLen := ADS_DD_MAX_PROPERTY_LEN;
   try
      Dictionary.GetFieldProperty( TableName,
                                     Name,
                                     ADS_DD_FIELD_MAX_VALUE,
                                     @pucBuffer,
                                     usPropertyLen );

   except
      ON E : EAdsDatabaseError do
        begin
          if not CheckLastAdsError then raise;
        end;
		end;
    result:=pucBuffer;
end;

function TAdsField.GetMinValue: string;
var
   pucBuffer     : array[0..ADS_DD_MAX_PROPERTY_LEN ] of char;
   usPropertyLen : UNSIGNED16;
begin
   pucBuffer[ 0 ] := #0;
   usPropertyLen := ADS_DD_MAX_PROPERTY_LEN;
   try
      Dictionary.GetFieldProperty( TableName,
                                     Name,
                                     ADS_DD_FIELD_MIN_VALUE,
                                     @pucBuffer,
                                     usPropertyLen );

   except
      ON E : EAdsDatabaseError do
        begin
          if not CheckLastAdsError then raise;
        end;
    end;
    result:=pucBuffer;

end;

function TAdsField.GetValidationExp: string;
begin

end;

function TAdsField.GetValidationMessage: string;
var
	 pucBuffer     : array[0..ADS_DD_MAX_PROPERTY_LEN ] of char;
   usPropertyLen : UNSIGNED16;
begin
   pucBuffer[ 0 ] := #0;
   usPropertyLen := ADS_DD_MAX_PROPERTY_LEN;
   try
      Dictionary.GetFieldProperty( TableName,
                                     Name,
                                     ADS_DD_FIELD_VALIDATION_MSG,
                                     @pucBuffer,
                                     usPropertyLen );

   except
      ON E : EAdsDatabaseError do
        begin
          if not CheckLastAdsError then raise;
        end;
    end;
    result:=pucBuffer;

end;

procedure TAdsField.SetMaxValue(fValue: string);
begin
  try
    if fValue<>'' then
       Dictionary.SetFieldProperty( TableName,
                                 Name,
                                 ADS_DD_FIELD_MAX_VALUE,
																 pChar( fValue ),
                                 length( fValue ) + 1,
                                 ADS_NO_VALIDATE,
																 '' )
    else
       Dictionary.SetFieldProperty( TableName,
                                 Name,
                                 ADS_DD_FIELD_MAX_VALUE,
                                 nil,
                                 length( fValue ) + 1,
                                 ADS_NO_VALIDATE,
                                 '' );
  except
    ON E : EAdsDatabaseError do
        begin
          if not CheckLastAdsError then raise;
        end;
  end;
end;

procedure TAdsField.SetMinValue(fValue: string);
begin
  try
    if fValue<>'' then
       Dictionary.SetFieldProperty( TableName,
                                 Name,
                                 ADS_DD_FIELD_MIN_VALUE,
                                 pChar( fValue ),
                                 length( fValue ) + 1,
                                 ADS_NO_VALIDATE,
                                 '' )
    else
			 Dictionary.SetFieldProperty( TableName,
                                 Name,
                                 ADS_DD_FIELD_MIN_VALUE,
																 nil,
                                 length( fValue ) + 1,
                                 ADS_NO_VALIDATE,
                                 '' );
  except
    ON E : EAdsDatabaseError do
        begin
          if not CheckLastAdsError then raise;
        end;
  end;
end;

procedure TAdsField.SetValidationExp(fMessage: string);
begin

end;

procedure TAdsField.SetValidationMessage(fMessage: string);
begin
  try
    if fMessage<>'' then
       Dictionary.SetFieldProperty( TableName,
                                 Name,
                                 ADS_DD_FIELD_VALIDATION_MSG,
                                 pChar( fMessage ),
                                 length( fMessage ) + 1,
                                 ADS_NO_VALIDATE,
                                 '' )
    else
			 Dictionary.SetFieldProperty( TableName,
                                 Name,
                                 ADS_DD_FIELD_VALIDATION_MSG,
																 nil,
                                 length( fMessage ) + 1,
                                 ADS_NO_VALIDATE,
                                 '' );
  except
    ON E : EAdsDatabaseError do
        begin
          if not CheckLastAdsError then raise;
        end;
  end;
end;

procedure TAdsField.GetAdsProperties;
begin
   FDefinition :=GetDefinition;
   FDescription:=GetDescription;
   FDefaultValue:=GetDefaultValue;
   FMaxValue :=GetMaxValue;
   FMinValue :=GetMinValue;
   FValidMess:=GetValidationMessage;
   FNotNull:=IsNotNull;
end;

procedure TAdsField.SetDefinition(fDef: TFieldType);
begin
  FDefinition:=fDef;
end;

procedure TAdsField.SetNotNull(mValue: boolean);
var
  DataReq: UNSIGNED16;
begin
	if mValue then DataReq:=0
  else DataReq:=1;
  try
    Dictionary.SetFieldProperty( TableName,
                                 Name,
                                 ADS_DD_FIELD_CAN_NULL,
                                 @DataReq,
                                 sizeof( UNSIGNED16 ),
                                 ADS_NO_VALIDATE,
                                 '' );
  except
    ON E : EAdsDatabaseError do
        begin
          if not CheckLastAdsError then raise;
        end;
  end;

end;

function TAdsField.TranslateFieldType(fField: string): UNSIGNED16;

begin
  if fField='LOGICAL'      then    Result :=ADS_LOGICAL;
  if fField='NUMERIC'      then    Result :=ADS_NUMERIC;
  if fField='DATE'         then    Result :=ADS_DATE;
  if fField='CHARACTER'    then    Result :=ADS_STRING;
  if fField='MEMO'         then    Result :=ADS_MEMO;
  if fField='VARCHAR'      then    Result :=ADS_VARCHAR;
  if fField='COMPACT DATE' then    Result :=ADS_COMPACTDATE;
	if fField='DOUBLE'       then    Result :=ADS_DOUBLE;
  if fField='INTEGER'      then    Result :=ADS_INTEGER;
  if fField='IMAGE'        then    Result :=ADS_IMAGE;
	if fField='BINARY'       then    Result :=ADS_BINARY  ;
  if fField='SHORTINT'     then    Result :=ADS_SHORTINT;
  if fField='TIME'         then    Result := ADS_TIME;
  if fField='TIMESTAMP'    then    Result :=ADS_TIMESTAMP;
  if fField='AUTOINC'      then    Result :=ADS_AUTOINC;
  if fField='RAW'          then    Result :=ADS_RAW;
  if fField='CURDOUBLE'    then    Result :=ADS_CURDOUBLE;
  if fField='MONEY'        then    Result :=ADS_MONEY;
end;

function TAdsField.GetFieldLength: Integer;
begin
  case FDefinition.usFieldType of
    ADS_STRING          : result:=0;
    ADS_LOGICAL         : result:=1;
    ADS_DATE            : result:=4;
    ADS_MEMO            : result:=9;
    ADS_COMPACTDATE     : result:=4;
    ADS_DOUBLE          : result:=8;
    ADS_INTEGER         : result:=4;
    ADS_IMAGE           : result:=9;
    ADS_BINARY          : result:=9;
    ADS_SHORTINT        : result:=2;
    ADS_TIME            : result:=4;
    ADS_TIMESTAMP       : result:=8;
    ADS_AUTOINC         : result:=4;
    ADS_RAW             : result:=0;
    ADS_CURDOUBLE       : result:=8;
    ADS_MONEY           : result:=8;
	end;
end;

function TAdsField.getStartValue: longint;
begin
  result:=FStartValue;
end;

procedure TAdsField.setStartValue(sval: Integer);
begin
  FStartValue:=sval;
end;

constructor TAdsField.Create;
begin
  FDefinition.usFieldDecimals:=0;
  FStartValue:=0;
end;

procedure TAdsField.SetProperties(fField: TAdsField);
begin
  Name          := fField.Name;
  FOldName      := fField.OldName;
  FTableName    := fField.TableName;
  FNotNull      := fField.NotNull;
  FDefinition   := fField.Definition;
  FDescription  := fField.Description;
  FDefaultValue := fField.DefaultValue;
  FMaxValue     := fField.MaxValue;
  FMinValue     := fField.MinValue;
  FValidMess    := fField.ValidMess;
end;

{ TFieldList }

procedure TFieldList.AddChild(Child: TObject);
begin
  GetList.Add(Child);
end;

constructor TFieldList.create(Dictionary:TAdsDictionary;TableName: string);
begin
  FDictionary:=Dictionary;
  FTableName:=TableName;
  FItemsCreated:=False;
end;
constructor TFieldList.create(Dictionary: TAdsDictionary);
begin
  FDictionary:=Dictionary;
  FItemsCreated:=False;
end;

destructor TFieldList.Destroy;
begin
  close;
  if FList <> nil then FList.Free;
end;

procedure TFieldList.DestroyItems;
begin
  if FList <> nil then
   while FList.Count > 0 do
   begin
     TObject(FList[0]).Free;
		 FList.Delete(0);
   end;
end;
function TFieldList.GetFieldIndex(const FName: string): Integer;
var
  i :integer;
begin
  if   FItemsCreated then
    for i:=0 to FieldCount-1 do
       if Field[i].Name=FName then begin
         result:=i+1;
         exit;
       end;
  result:=0;
end;

procedure TFieldList.Clear;
begin
   DestroyItems;
end;


function TFieldList.GetFieldCount: Integer;
begin
  if FList = nil then Result := 0
  else Result := FList.Count;
end;

function TFieldList.GetFields(Index: Integer): TAdsField;
begin
  Result := TAdsField(FList[Index]);
end;

function TFieldList.GetFieldsByName(const FName: string): TAdsField;
var
	i :integer;
begin
  if   FItemsCreated then
    for i:=0 to FieldCount-1 do
       if UpperCase(Field[i].Name)=UpperCase(FName) then begin
         result:=Field[i];
         exit;
       end;
  result:=nil;
end;

function TFieldList.GetList: TList;
begin
  if FList = nil then
     FList := TList.Create;
     Result := FList;
end;

procedure TFieldList.Open;
begin
  if not FItemsCreated then CreateFields;
    FItemsCreated := True;
end;

procedure TFieldList.Close;
begin
  if FItemsCreated then DestroyItems;
    FItemsCreated := False;
end;


function TFieldList.Refresh: Boolean;
begin
  Close;
  Open;
  Result := True;
end;

procedure TFieldList.CreateFields;
var
  Item: TAdsField;
  List: TStringList;
  I: Integer;
begin
  List:=TStringList.Create;
  FItemsCreated:=true;
  try
    FDictionary.GetFieldNames(FTableName,List);
    for I := 0 to List.Count - 1 do
      begin
        Item:=TAdsField.Create(FDictiOnary,FTableName,List[i]);
        Item.GetAdsProperties;
        AddChild(Item);
      end;

  finally
    List.Free;
  end;
end;
procedure TFieldList.AddField(fField: TAdsField);
begin
	if FItemsCreated=False then  FItemsCreated:=True;
  AddChild(fField);
end;
procedure TFieldList.DeleteField(fField: TAdsField);
begin
  FList.Delete(FList.IndexOf(fField));
end;


{ TIndex }

constructor TAdsIndex.create(Dictionary: TAdsDictionary;
  const TableName: string;const Name: string);
begin
  inherited create(Dictionary,Name);
  FTableName:=TableName;
end;

function TAdsIndex.GetFileName: string;
begin
  Result := FFileName;
end;

function TAdsIndex.GetPageSize:integer;
var
   usLength       : UNSIGNED16;
   ulPageSize     : UNSIGNED32;
begin
  {* Retrieve index page size *}
  usLength := 4;
  try
    Dictionary.GetIndexFileProperty( TableName,
																		 FFileName,
                                     ADS_DD_INDEX_FILE_PAGESIZE,
                                     @ulPageSize,
																		 usLength );
  except
     ON E : EAdsDatabaseError do
       begin
         if not CheckLastAdsError then raise;
       end;
  end;
  result:=ulPageSize;
end;

procedure TAdsIndex.RefreshDictProp;
var
   usLength       : UNSIGNED16;
   usKeyLength    : UNSIGNED16;
   ulOptionVal    : UNSIGNED32;
   aucBuffer      : array[ 0..ADS_DD_MAX_PROPERTY_LEN ] of char;
   usVal          : UNSIGNED16;
begin
  usLength := ADS_DD_MAX_PROPERTY_LEN;
  aucBuffer[ 0 ] := #0;
  try
    Dictionary.GetIndexProperty( TableName,
                                 Name,
                                 ADS_DD_INDEX_EXPRESSION,
                                 @aucBuffer,
                                 usLength );
  except
     ON E : EAdsDatabaseError do
       begin
				 if not CheckLastAdsError then raise;
       end;
  end;
	FExpression:=aucBuffer;

  usLength := ADS_DD_MAX_PROPERTY_LEN;
  aucBuffer[ 0 ] := #0;
  try
    Dictionary.GetIndexProperty( TableName,
                               Name,
                               ADS_DD_INDEX_CONDITION,
                               @aucBuffer,
                               usLength );
  except
     ON E : EAdsDatabaseError do
       begin
         if not CheckLastAdsError then raise;
       end;
  end;
  if ( StrPas( aucBuffer ) = '' ) then
      FCondition := 'NONE'
   else
      FCondition := aucBuffer;


  usLength := 4;
  try
    Dictionary.GetIndexProperty( TableName,
                                 Name,
                                 ADS_DD_INDEX_OPTIONS,
                                 @ulOptionVal,
                                 usLength );

  except
     ON E : EAdsDatabaseError do
			 begin
         if not CheckLastAdsError then raise;
       end;
  end;
  FDescending:=False;
  FUnique:=False;
  FCompound:=False;
  FCustom:=False;
  FFTSIndex:=False;
  FKeepScore:=False;
  FCaseSensitive:=False;
  FFixed:=False;
  FProtectNumbers:=False;

  if ( ( ulOptionVal and ADS_UNIQUE ) = ADS_UNIQUE ) then
      FUnique:=true;

  if ( ( ulOptionVal and ADS_CUSTOM ) = ADS_CUSTOM ) then
     FCustom:=true;

  if ( ( ulOptionVal and ADS_DESCENDING ) = ADS_DESCENDING ) then
      FDescending:=true;

  if ( ( ulOptionVal and ADS_COMPOUND ) = ADS_COMPOUND ) then
      FCompound:=true;

  if ( ( ulOptionVal and ADS_FTS_INDEX ) = ADS_FTS_INDEX ) then
      FFTSIndex := True;

	 if ( ( ulOptionVal and ADS_FTS_KEEP_SCORE ) = ADS_FTS_KEEP_SCORE ) then
      FKeepScore := True;

	 if ( ( ulOptionVal and ADS_FTS_CASE_SENSITIVE ) = ADS_FTS_CASE_SENSITIVE ) then
      FCaseSensitive := True;

   if ( ( ulOptionVal and ADS_FTS_FIXED ) = ADS_FTS_FIXED ) then
      FFixed := True;

   if ( ( ulOptionVal and ADS_FTS_PROTECT_NUMBERS ) = ADS_FTS_PROTECT_NUMBERS ) then
      FProtectNumbers := True;


  usLength := ADS_DD_MAX_PROPERTY_LEN;
  aucBuffer[ 0 ] := #0;
  try
    Dictionary.GetIndexProperty( TableName,
                                 Name,
                                 ADS_DD_INDEX_FILE_NAME,
                                 @aucBuffer,
                                 usLength );
  except
     ON E : EAdsDatabaseError do
       begin
         if not CheckLastAdsError then raise;
       end;
  end;
  FFileName:=aucBuffer;

  {* Retrieve index page size *}
  FPageSize:=GetPageSize;

	if FFTSIndex then begin
      {* retrieve noise words *}
      usLength := ADS_DD_MAX_PROPERTY_LEN;
			aucBuffer[ 0 ] := #0;
      Dictionary.GetIndexProperty( TableName,
                                   Name,
                                   ADS_DD_INDEX_FTS_NOISE,
                                   @aucBuffer,
                                   usLength );
      FNoiseWord := aucBuffer;

      {* retrieve delimiters *}
      usLength := ADS_DD_MAX_PROPERTY_LEN;
      aucBuffer[ 0 ] := #0;
      Dictionary.GetIndexProperty( TableName,
                                   Name,
                                   ADS_DD_INDEX_FTS_DELIMITERS,
                                   @aucBuffer,
                                   usLength );
      FDelimiters := aucBuffer;
      FDelimiters := ReplaceControlChars( FDelimiters );

      {* retrieve drop characters *}
      usLength := ADS_DD_MAX_PROPERTY_LEN;
      aucBuffer[ 0 ] := #0;
      Dictionary.GetIndexProperty( TableName,
                                   Name,
                                   ADS_DD_INDEX_FTS_DROP_CHARS,
                                   @aucBuffer,
                                   usLength );
      FDropChars := aucBuffer;

			{* retrieve conditional drop characters *}
      usLength := ADS_DD_MAX_PROPERTY_LEN;
      aucBuffer[ 0 ] := #0;
			Dictionary.GetIndexProperty( TableName,
                                   Name,
                                   ADS_DD_INDEX_FTS_CONDITIONAL_CHARS,
                                   @aucBuffer,
                                   usLength );
      FConditionalChars := aucBuffer;

      {* retrieve min word length *}
      usLength := 2;
      Dictionary.GetIndexProperty( TableName,
                                   Name,
                                   ADS_DD_INDEX_FTS_MIN_LENGTH,
                                   @usVal,
                                   usLength );
      FMinWordLength := usVal;

      usLength := sizeof( UNSIGNED16 );
      Dictionary.GetIndexProperty( TableName,
                                   Name,
                                   ADS_DD_INDEX_KEY_LENGTH,
                                   @usKeyLength,
                                   usLength );

      FMaxWordLength := usKeyLength;

  end;
end;

procedure TAdsIndex.CreateAdsIndex;
begin
  if FFTSIndex then
    CreateAdsFTSIndex
	else
    CreateAdsStandartIndex;
end;

procedure TAdsIndex.CreateAdsStandartIndex;
var
  hTable           : ADSHANDLE;
  hIndex           : ADSHANDLE;
  usOptions        : UNSIGNED16;
begin
  usOptions := 0;
  if Unique then  usOptions :=usOptions+ADS_UNIQUE;
  if Custom then  usOptions :=usOptions+ADS_CUSTOM;
  if Descending then  usOptions :=usOptions+ADS_DESCENDING;
  if Compound then  usOptions :=usOptions+ADS_COMPOUND;
  try
    AceCheck( nil, ACE.AdsOpenTable( Dictionary.ConnectionHandle,
                                     pChar(TableName ),
                                     '',
                                     ADS_DEFAULT,
                                     ADS_ANSI,
                                     ADS_PROPRIETARY_LOCKING,
                                     ADS_IGNORERIGHTS,
                                     ADS_EXCLUSIVE,
                                     @hTable ) );
  except
     ON E : EAdsDatabaseError do
       begin
         if not CheckLastAdsError then raise;
			 end;
  end;

	try
    AceCheck( nil, AdsCreateIndex61( hTable,
              pChar( FFileName ),
              pChar( Name ),
              pChar( FExpression ),
              pChar( FCondition ),
              pChar( FWhileCon),
              usOptions,
              FPageSize,
              @hIndex ) );

    AceCheck( nil, ACE.AdsCloseTable( hTable ) );
  except
     ON E : EAdsDatabaseError do
       begin
         AceCheck( nil, ACE.AdsCloseTable( hTable ) );
          raise;
//         if not CheckLastAdsError then raise;
       end;
  end;

end;

procedure TAdsIndex.CreateAdsFTSIndex;
var
  hTable           : ADSHANDLE;
  hIndex           : ADSHANDLE;
  usOptions        : UNSIGNED16;
begin
	usOptions := ADS_COMPOUND;

  if FKeepScore then usOptions := usOptions or ACE.ADS_FTS_KEEP_SCORE;
	if FCaseSensitive then usOptions := usOptions or ACE.ADS_FTS_CASE_SENSITIVE;
  if FFixed then usOptions := usOptions or ACE.ADS_FTS_FIXED;
  if FProtectNumbers then usOptions := usOptions or ACE.ADS_FTS_PROTECT_NUMBERS;

  try
    AceCheck( nil, ACE.AdsOpenTable( Dictionary.ConnectionHandle,
                                     pChar(TableName ),
                                     '',
                                     ADS_DEFAULT,
                                     ADS_ANSI,
                                     ADS_PROPRIETARY_LOCKING,
                                     ADS_IGNORERIGHTS,
                                     ADS_EXCLUSIVE,
                                     @hTable ) );
  except
     ON E : EAdsDatabaseError do
       begin
         if not CheckLastAdsError then raise;
       end;
  end;

  try
    AceCheck( nil, ACE.AdsCreateFTSIndex(htable,
                            PChar( FFileName ),
                            PChar( Name ),
                            PChar( FExpression ),
                            FPageSize,
                            FMinWordLength,
                            FMaxWordLength,
														Word( FDefaultDelimeters ),
                            PChar( FDelimiters ),
                            Word( FDefaultNoise ),
														PChar( FNoiseWord ),
                            Word( FDefaultDropChars ),
                            PChar( FDropChars ),
                            Word( FDefaultConditionals),
                            PChar( FConditionalChars ),
                            nil, nil,  {* reserved params *}
                            usOptions ));

    AceCheck( nil, ACE.AdsCloseTable( hTable ) );
  except
     ON E : EAdsDatabaseError do
       begin
         AceCheck( nil, ACE.AdsCloseTable( hTable ) );
          raise;
//         if not CheckLastAdsError then raise;
       end;
  end;
end;

procedure TAdsIndex.DeleteAdsIndex;
var
  hTable           : ADSHANDLE;
  hIndex           : ADSHANDLE;
begin
  try
    AceCheck( nil, ACE.AdsOpenTable( Dictionary.ConnectionHandle,
                                     pChar(TableName ),
                                     '',
                                     ADS_DEFAULT,
																		 ADS_ANSI,
                                     ADS_PROPRIETARY_LOCKING,
                                     ADS_IGNORERIGHTS,
																		 ADS_EXCLUSIVE,
                                     @hTable ) );
  except
     ON E : EAdsDatabaseError do
       begin
         if not CheckLastAdsError then raise;
       end;
  end;
  try
    AdsGetIndexHandle( hTable, pChar(name) , @hIndex );
    AceCheck( nil, AdsDeleteIndex( hIndex ) );
    AceCheck( nil, ACE.AdsCloseTable( hTable ) );
  except
     ON E : EAdsDatabaseError do
       begin
         AceCheck( nil, ACE.AdsCloseTable( hTable ) );
         if not CheckLastAdsError then raise;
       end;
  end;

end;

function TAdsIndex.getFields: TStringList;
var
  tempfld:TAdsField;
  tempList:TStringList;
  sPos,bas,i:integer;
  InxExp:string;
begin
	InxExp:=self.Expression;
  if InxExp='' then exit;
  tempList:=TStringList.Create;
	bas:=1;
	repeat
		 sPos:=pos(';',InxExp);
		 if sPos=0 then
				tempList.Add(InxExp)
		 else begin
				tempList.Add(Copy(InxExp,bas,(sPos-bas)));
				InxExp:=Copy(InxExp,(sPos+1),Length(InxExp));
		 end;
	Until sPos=0;
	result:=tempList;
end;

function TAdsIndex.ReplaceControlChars( strValue : string) : string;
	var strRet : string;
begin
	 strRet := strValue;
	 strRet := StringReplace( strRet, #32, '<space>', [rfReplaceAll] );
	 strRet := StringReplace( strRet, #8, '<backspace>', [rfReplaceAll] );
	 strRet := StringReplace( strRet, #9, '<tab>', [rfReplaceAll] );
	 strRet := StringReplace( strRet, #10, '<newline>', [rfReplaceAll] );
	 strRet := StringReplace( strRet, #11, '<vertical tab>', [rfReplaceAll] );
	 strRet := StringReplace( strRet, #12, '<formfeed>', [rfReplaceAll] );
	 strRet := StringReplace( strRet, #13, '<carriage return>', [rfReplaceAll] );

	 result := strRet;
end;


end.
