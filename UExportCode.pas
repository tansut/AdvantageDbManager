unit UExportCode;

interface

uses
	Windows, SysUtils, Classes, Ace, adscnnct, adsdictionary, Dialogs, UDbItems;

type
	TItemType = (itUser, itGroup, itTable, itProcedure, itView, itRelation, itDbLink);
  TProgressCallBackFunction = procedure(Sender: TObject; PercentDone: Integer) of object;
	TItem = class (TCollectionItem)
	private
		FItemType: TItemType;
		FName: string;
	public
		procedure Assign(Source: TPersistent); override;
		property ItemType: TItemType read FItemType write FItemType;
		property Name: string read FName write FName;
	end;

	TItems = class (TCollection)
	protected
		function GetItem(Index: integer): TItem;
		procedure SetItem(Index: integer; Value: TItem);
	public
		constructor Create;
		function Insert(Index: integer): TItem;
		function Add: TItem;
		function AddDbItem(DbItem: TDbBaseItem): TItem;
		property Items[Index: integer]: TItem read GetItem write SetItem; default;
	end;

	TBaseCodeExporter = class
	private
		FCode: TStrings;
		FDictionary: TAdsDictionary;
		FFileName: string;
		FIncludeData: boolean;
		FItems: TItems;
		FProgressCallBackFunction: TProgressCallBackFunction;

		UserList: TStrings;
		GroupList: TStrings;
		TableList: TStrings;
		ProcedureList: TStrings;
		ViewList: TStrings;
		RelationList: TStrings;
		LinkList: TStrings;

		procedure InternalInitialize;
		procedure InternalCleanUp;
	protected
		procedure DoProgress(Count: Integer); 
		procedure SetFileName(const Value: string);
		procedure AddMultiLineComment(Comment: string);
		procedure AddSingleLineComment(Comment: string);

		procedure ExportTablePermissions(Name: string);
		procedure ExportProcedurePermissions(Name: string);
		procedure ExportViewPermissions(Name: string);
		procedure ExportLinkPermissions(Name: string);
		
		procedure DoFileNameChange; virtual; abstract;
		procedure ExportUser(UserName: string); virtual; abstract;
		procedure ExportMembership(GroupName, UserName: string); virtual; abstract;
		procedure ExportGroup(GroupName: string); virtual; abstract;
		procedure ExportTable(TableName: string); virtual; abstract;
		procedure ExportProcedure(ProcedureName: string); virtual; abstract;
		procedure ExportPermissions(Grantee: string; ObjectType: Word;
			ObjectName, ParentName: string; Permissions: TAdsPermissionTypes); virtual; abstract;
		procedure ExportView(ViewName: string); virtual; abstract;
		procedure ExportRelation(RelationName: string); virtual; abstract;
		procedure ExportLink(LinkName: string); virtual; abstract;
		procedure Initialize; virtual; abstract;
		procedure Finalize; virtual; abstract;
	public
		constructor Create; virtual;
		destructor Destroy; override;
		procedure ExportToCode;
                procedure RegisterProgressCallBackFunction(ProgressCallBackFunction: TProgressCallBackFunction);
		property Code: TStrings read FCode write FCode;
		property Dictionary: TAdsDictionary read FDictionary write FDictionary;
		property FileName: string read FFileName write SetFileName;
		property IncludeData: boolean read FIncludeData write FIncludeData;
		property Items: TItems read FItems;
                property ProgressCallBackFunction: TProgressCallBackFunction read FProgressCallBackFunction;

	end;

	TCodeExporterFactory = class (TComponent)
	protected
		function GetDescription: String; virtual; abstract;
		function GetExtension: String; virtual; abstract;
		function GetLanguage: String; virtual; abstract;
		function GetFilterString: String; virtual; abstract;
		function GetInstance: TBaseCodeExporter; virtual; abstract;
		function GetSupportsData: Boolean; virtual; abstract;
	public
		property Description: String read GetDescription;
		property Extension: String read GetExtension;
		property FilterString: String read GetFilterString;
		property Instance: TBaseCodeExporter read GetInstance;
		property Language: String read GetLanguage;
		property SupportsData: Boolean read GetSupportsData;
	end;

	TDestinationType = (dtNoDestination, dtScreen, dtFile);
	TCodeExporter = class (TComponent)
	private
		FDictionary: TAdsDictionary;
		FExporter: TBaseCodeExporter;
		FExporterFactory: TCodeExporterFactory;
		FIncludeData: boolean;
		FItems: TItems;
		FFileName: string;
		FDestination: TDestinationType;
		function GetExporterName: string;
		function GetCode: TStrings;
		procedure SetFileName(const Value: string);
		procedure SetExporterFactory(const Value: TCodeExporterFactory);
	protected
		procedure Notification(AComponent: TComponent; Operation: TOperation); override;
	public
		constructor Create(AOwner: TComponent); override;
		destructor Destroy; override;
		procedure ExportCode;
		property Code: TStrings read GetCode;
                property Exporter: TBaseCodeExporter read FExporter;
	published
		property Destination: TDestinationType read FDestination write FDestination;
		property Dictionary: TAdsDictionary read FDictionary write FDictionary;
		property FileName: string read FFileName write SetFileName;
		property ExporterFactory: TCodeExporterFactory read FExporterFactory write SetExporterFactory;
		property ExporterName: string read GetExporterName;
		property IncludeData: boolean read FIncludeData write FIncludeData;
		property Items: TItems read FItems;
	end;

	TCodeExporterArray = array of TCodeExporterFactory;
	TCodeExporterList = class
	private
		FExporters: TCodeExporterArray;
	protected
		function GetExporters(Index: integer): TCodeExporterFactory;
	public
		procedure Add(const Exporter: TCodeExporterFactory);
		function Count: integer;
		function Find(const Desc: string): TCodeExporterFactory;
		procedure Remove(const Exporter: TCodeExporterFactory);
		property Exporters[Index: integer]: TCodeExporterFactory read GetExporters; default;
	end;

var
	CodeExporterList: TCodeExporterList;

implementation

uses
	UCodeExplorer, SynEditHighlighter, Forms, UUtils, UAdsUser, UAdsGroup,
	UAdsTable, UAdsView, UAdsProc, UAdsRef, UAdsLink, UAdsObj;

{ TItems }

function TItems.Add: TItem;
begin
	Result := TItem(inherited Add);
end;

function TItems.AddDbItem(DbItem: TDbBaseItem): TItem;
begin
	Result := Self.Add;

	with Result do
	begin
  	Name := DbItem.Title;

		if DbItem is TDBUser then
			ItemType := itUser
		else if DbItem is TDBGroup then
			ItemType := itGroup
		else if DbItem is TDBTable then
			ItemType := itTable
		else if DbItem is TDBView then
			ItemType := itView
		else if DbItem is TDBProc then
			ItemType := itProcedure
		else if DbItem is TDBRef then
			ItemType := itRelation
		else if DbItem is TDBLink then
			ItemType := itDbLink;
	end;
end;

constructor TItems.Create;
begin
	inherited Create(TItem);
end;

function TItems.GetItem(Index: integer): TItem;
begin
	Result := TItem(inherited GetItem(Index));
end;

function TItems.Insert(Index: integer): TItem;
begin
	Result := TItem(inherited Insert(Index));
end;

procedure TItems.SetItem(Index: integer; Value: TItem);
begin
	inherited SetItem(Index, Value);
end;

{ TItem }

procedure TItem.Assign(Source: TPersistent);
begin
	if (Source is TItem) then
		with TItem(Source) do
		begin
			Self.Name := Name;
			Self.ItemType := ItemType;
		end;
end;

{ TBaseCodeExporter }
procedure TBaseCodeExporter.AddMultiLineComment(Comment: string);
begin
	Code.Add('');
	Code.Add('/*');
	Code.Add(Comment);
	Code.Add('*/');
end;

procedure TBaseCodeExporter.AddSingleLineComment(Comment: string);
begin
	Code.Add('');
	Code.Add('/* ' + Comment + ' */');
end;

constructor TBaseCodeExporter.Create;
begin
	inherited;
	FFileName := '';
	FIncludeData := True;
	FItems := TItems.Create;
	FCode := TStringList.Create;

	InternalInitialize;
end;

destructor TBaseCodeExporter.Destroy;
begin
	InternalCleanUp;
	
  FItems.Free;
  FCode.Free;
	inherited;
end;

procedure TBaseCodeExporter.DoProgress(Count: Integer);
begin
	if Assigned(FProgressCallBackFunction) then
	begin
		FProgressCallBackFunction(Self, Round(((Count+1) / Items.Count) * 100));
	end;
end;

procedure TBaseCodeExporter.ExportLinkPermissions(Name: string);
var
	I: Integer;
	Permissions: TAdsPermissionTypes;
begin
	for I := 0 to LinkList.Count-1 do
	begin
		Permissions :=
			Dictionary.GetPermissions(
				Name, ADS_DD_LINK_OBJECT, LinkList[I], '', False);

		ExportPermissions(
			Name,
			ADS_DD_LINK_OBJECT,
			LinkList[I],
			'',
			Permissions);
	end;
end;

procedure TBaseCodeExporter.ExportProcedurePermissions(Name: string);
var
	I: Integer;
	Permissions: TAdsPermissionTypes;
begin
	for I := 0 to ProcedureList.Count-1 do
	begin
		Permissions :=
			Dictionary.GetPermissions(
				Name, ADS_DD_PROCEDURE_OBJECT, ProcedureList[I], '', False);

		ExportPermissions(
			Name,
			ADS_DD_PROCEDURE_OBJECT,
			ProcedureList[I],
			'',
			Permissions);
	end;
end;

procedure TBaseCodeExporter.ExportTablePermissions(Name: string);
var
	I, J: Integer;
	FieldNames: TStringList;
	Permissions: TAdsPermissionTypes;
begin
	FieldNames := TStringList.Create;

	try
		for I := 0 to TableList.Count-1 do
		begin
			Permissions :=
				Dictionary.GetPermissions(
					Name, ADS_DD_TABLE_OBJECT, TableList[I], '', False);

			ExportPermissions(
				Name,
				ADS_DD_TABLE_OBJECT,
				TableList[I],
				'',
				Permissions);

			FieldNames.Clear;
			Dictionary.GetFieldNames(TableList[I], FieldNames);
			for J := 0 to FieldNames.Count-1 do
			begin
				Permissions :=
					Dictionary.GetPermissions(
						Name, ADS_DD_COLUMN_OBJECT, FieldNames[J], TableList[I], False);

				ExportPermissions(
					Name,
					ADS_DD_COLUMN_OBJECT,
					FieldNames[J],
					TableList[I],
					Permissions);
			end;
		end;
	finally
		FieldNames.Free;
	end;
end;

procedure TBaseCodeExporter.ExportToCode;
var
	I, J: integer;
	Item: TItem;
	Count: Integer;
begin
	Initialize;
  if Assigned(FProgressCallBackFunction) then
   FProgressCallBackFunction(self, 0);
  for I := 0 to Items.Count - 1 do
  begin
    Item := Items[i];
    case Item.ItemType of
			itUser:
				UserList.Add(Item.Name);
			itGroup:
				GroupList.Add(Item.Name);
			itTable:
				TableList.Add(Item.Name);
			itProcedure:
				ProcedureList.Add(Item.Name);
			itView:
				ViewList.Add(Item.Name);
			itRelation:
				RelationList.Add(Item.Name);
			itDbLink:
				LinkList.Add(Item.Name);
		end;
	end;

	Count := 0;

	if TableList.Count > 0 then AddSingleLineComment('Tablolar...');
	for I := 0 to TableList.Count-1 do
	begin
		ExportTable(TableList[i]);

		Inc(Count); DoProgress(Count);
	end;

	if ViewList.Count > 0 then AddSingleLineComment('Görünümler...');
	for I := 0 to ViewList.Count-1 do
	begin
		ExportView(ViewList[i]);

		Inc(Count); DoProgress(Count);
	end;

	if RelationList.Count > 0 then AddSingleLineComment('Ýliþkisel Baðlar...');
	for I := 0 to RelationList.Count-1 do
	begin
		ExportRelation(RelationList[i]);

		Inc(Count); DoProgress(Count);
	end;

	if ProcedureList.Count > 0 then AddSingleLineComment('Prosedürler...');
	for I := 0 to ProcedureList.Count-1 do
	begin
		ExportProcedure(ProcedureList[i]);

		Inc(Count); DoProgress(Count);
	end;

	if LinkList.Count > 0 then AddSingleLineComment('VT Baðlarý...');
	for I := 0 to LinkList.Count-1 do
	begin
		ExportLink(LinkList[i]);

		Inc(Count); DoProgress(Count);
	end;

	if GroupList.Count > 0 then AddSingleLineComment('Gruplar...');
	for I := 0 to GroupList.Count-1 do
	begin
		ExportGroup(GroupList[i]);

		ExportTablePermissions(GroupList[i]);
		ExportViewPermissions(GroupList[i]);
		ExportProcedurePermissions(GroupList[i]);
		ExportLinkPermissions(GroupList[i]);

		Inc(Count); DoProgress(Count);
	end;

	if UserList.Count > 0 then AddSingleLineComment('Kullanýcýlar...');
	for I := 0 to UserList.Count-1 do
	begin
		if UserList[I] = 'ADSSYS' then Continue;

		ExportUser(UserList[i]);

		ExportTablePermissions(UserList[i]);
		ExportViewPermissions(UserList[i]);
		ExportProcedurePermissions(UserList[i]);
		ExportLinkPermissions(UserList[i]);

		with TAdsUser.Create(Dictionary, UserList[i]) do
		try
			for J := 0 to Group.Count-1 do
			begin
				if GroupList.IndexOf(Group[J]) >= 0 then
					ExportMembership(Group[J], UserList[I]);
			end;
		finally
			Free;
		end;

		Inc(Count); DoProgress(Count);
	end;

	Finalize;
end;

procedure TBaseCodeExporter.ExportViewPermissions(Name: string);
var
	I: Integer;
	Permissions: TAdsPermissionTypes;
begin
	for I := 0 to ViewList.Count-1 do
	begin
		Permissions :=
			Dictionary.GetPermissions(
				Name, ADS_DD_VIEW_OBJECT, ViewList[I], '', False);

		ExportPermissions(
			Name,
			ADS_DD_VIEW_OBJECT,
			ViewList[I],
			'',
			Permissions);				
	end;
end;

procedure TBaseCodeExporter.InternalCleanUp;
begin
	UserList.Free;
	GroupList.Free;
	TableList.Free;
	ProcedureList.Free;
	ViewList.Free;
	RelationList.Free;
	LinkList.Free;
end;

procedure TBaseCodeExporter.InternalInitialize;
begin
	UserList := TStringList.Create;
	GroupList := TStringList.Create;
	TableList := TStringList.Create;
	ProcedureList := TStringList.Create;
	ViewList := TStringList.Create;
	RelationList := TStringList.Create;
	LinkList := TStringList.Create;
end;

procedure TBaseCodeExporter.RegisterProgressCallBackFunction(
  ProgressCallBackFunction: TProgressCallBackFunction);
begin
  Self.FProgressCallBackFunction := ProgressCallBackFunction;
end;

procedure TBaseCodeExporter.SetFileName(const Value: string);
begin
  FFileName := Value;

  DoFileNameChange;
end;

{ TCodeExporter }

constructor TCodeExporter.Create(AOwner: TComponent);
begin
	inherited;

	FExporter := nil;
	FItems := TItems.Create;
end;

destructor TCodeExporter.Destroy;
begin
	FItems.Free;

	inherited;
end;

procedure TCodeExporter.ExportCode;
var
	HighlighterIndex: Integer;
begin
	if not Assigned(FExporterFactory) then
		raise Exception.Create('Exporter için deðer verilmedi.');

	with FExporter do
	begin
		Dictionary := Self.Dictionary;
		FileName := Self.FileName;
		IncludeData := Self.IncludeData;
		Items.Assign(Self.Items);

		ExportToCode;
	end;

	if Destination = dtScreen then
	begin
		with TFmCodeExplorer.Create(Self.Owner) do
		try
			mmSource.Lines.Text := Code.Text;

			with GetPlaceableHighlighters do
			begin
				HighlighterIndex := FindByName(ExporterFactory.GetLanguage);

				if HighlighterIndex > -1 then
					mmSource.Highlighter := Items[HighlighterIndex].Create(Owner)
				else
					mmSource.Highlighter := nil;
			end;

			ShowModal;
		finally
			Free;
		end;
	end else
	if Destination = dtFile then
	begin
		if Length(FFileName) = 0 then
		begin
			with TSaveDialog.Create(Owner) do
			try
				Filter := ExporterFactory.GetFilterString;
				DefaultExt := ExporterFactory.GetExtension;

				if Execute then
					Self.FileName := Files[0]
				else
					Exit;
			finally
				Free;
			end;

			if FileExists(FileName) then
			begin
				if MessageBox(0, 'Mevcut dosya üzerine yazmak istediðinizden emin misiniz?', 'Soru', MB_YESNO) = ID_NO then
					Exit;
			end;

			Code.SaveToFile(FileName);
		end;
	end;
end;

function TCodeExporter.GetCode: TStrings;
begin
	if Assigned(FExporter) then
		Result := FExporter.Code
	else
		Result := nil;
end;

function TCodeExporter.GetExporterName: string;
begin
	if Assigned(FExporter) then
		Result := ''
	else
		Result := '';
end;

procedure TCodeExporter.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
	if (AComponent = FExporterFactory) and (Operation = opRemove) then
	begin
		FExporterFactory := nil;
	end;
end;

procedure TCodeExporter.SetExporterFactory(
	const Value: TCodeExporterFactory);
begin
	FExporterFactory := Value;

	if Assigned(FExporter) then
	begin
		FExporter.Free;
	end;

	if Assigned(Value) then
	begin
		FExporter := Value.Instance;
	end;
end;

procedure TCodeExporter.SetFileName(const Value: string);
begin
	if Value <> FileName then
	begin
		FFileName := Value;

    if Assigned(FExporter) then
      FExporter.FileName := FFileName;
  end;
end;


{ TCodeExporterList }

procedure TCodeExporterList.Add(const Exporter: TCodeExporterFactory);
var
  Index: integer;
begin
  if Find(Exporter.Description) <> nil then
    Exit;
    
  Index := Length(FExporters);
  SetLength(FExporters, Index + 1);
  FExporters[Index] := Exporter;
end;

function TCodeExporterList.Count: integer;
begin
  Result := Length(FExporters);
end;

function TCodeExporterList.Find(const Desc: string): TCodeExporterFactory;
var
  I: integer;
begin
  Result := nil;

  for I := 0 to Length(FExporters) - 1 do
  begin
    if FExporters[I].Description = Desc then
    begin
      Result := FExporters[I];

      Break;
    end;
  end;
end;

function TCodeExporterList.GetExporters(Index: integer): TCodeExporterFactory;
begin
  Result := FExporters[Index];
end;

procedure TCodeExporterList.Remove(const Exporter: TCodeExporterFactory);
var
  I, Index: integer;
begin
  Index := Count;
  for I := 0 to Count - 1 do
    if Exporter = FExporters[I] then
		begin
      Index := I;
			Break;
    end;
  if Index >= Count then 
    Exit;
  for I := Index to Count - 2 do
    FExporters[I] := FExporters[I + 1];
  SetLength(FExporters, Count - 1);
end;

initialization
  CodeExporterList := TCodeExporterList.Create;

finalization
  CodeExporterList.Free;


end.
