unit USQLExporter;

interface

uses
	Windows, SysUtils, Classes, Db, AdsTable, AdsData, AdsFunc, AdsDictionary,
	AdsSet, ADSCNNCT, UExportCode, Types, Ace, AceUnPub, Forms;

type

	TSqlExporter = class(TBaseCodeExporter)
	private
		Connection: TAdsConnection;

		procedure AddInsertStatements(Table: TAdsTable);
		procedure ExportTrigger(TriggerName, OwnerTableName: String);
	protected
		procedure DoFileNameChange; override;

		procedure ExportUser(UserName: String); override;
		procedure ExportGroup(GroupName: String); override;
		procedure ExportMembership(GroupName, UserName: string); override;
		procedure ExportTable(TableName: String); override;
		procedure ExportProcedure(ProcedureName: String); override;
		procedure ExportView(ViewName: String); override;
		procedure ExportRelation(RelationName: String); override;
		procedure ExportLink(LinkName: String); override;
		procedure ExportPermissions(Grantee: string; ObjectType: Word;
			ObjectName, ParentName: string;
			Permissions: TAdsPermissionTypes); override;
		procedure Initialize; override;
		procedure Finalize; override;
	public
		constructor Create; override;
		destructor Destroy; override;
	end;

	TSqlExporterFactory = class(TCodeExporterFactory)
	protected
		function GetDescription: String; override;
		function GetExtension: String; override;
		function GetFilterString: String; override;
		function GetInstance: TBaseCodeExporter; override;
		function GetLanguage: String; override;
		function GetSupportsData: Boolean; override;
	end;

implementation

uses
	UAdsProc, UAdsTable, UAdsUser, UAdsView, UAdsGroup, UAdsRef, UAdsLink, UUtils;

var
	ExporterFactory: TSqlExporterFactory;

const
	CtrlLf = #13#10;

{ TSqlExporter }

procedure TSqlExporter.AddInsertStatements(Table: TAdsTable);
var
	strStmt: string;
	strValues: string;
	strColumnList: string;
	iField: integer;
	bShownMessage: boolean;
begin
	bShownMessage := FALSE;

	{* Loop through each field and see if it's an autoinc. If this table has an
	 * autoinc field then we have to build an insert statement with a field
	 * list. *}
	strColumnList := '';

	Code.Add('');

	while not Table.EOF do
	begin
		strStmt := '';
		strValues := '';

		strStmt := 'INSERT INTO "' + Table.TableName + '" VALUES( ';

		{* add the field values. *}
		iField := 0;
		while ( iField < Table.FieldDefs.Count ) do
		begin
			try
				if ( strValues = '' ) then
					strValues := ConvertValueToSQLSyntax( Table.Fields[iField] )
				else
					strValues := strValues + ', ' + ConvertValueToSQLSyntax( Table.Fields[iField] );
			except
				on E : Exception do
					if ( E.message = 'unsupported type' ) then
					begin
						if not bShownMessage then
						begin
							bShownMessage := TRUE;
							Application.MessageBox( 'BLOBs and graphic fields are not supported through this utility. These field ' +
														'values will be populated with a NULL indicator. Some script modification may be required.',
														'Uyarý' );
						end;

						strValues := strValues + ', NULL';
					end else
						raise;
			end;
			inc( iField );
		end;

		strStmt := strStmt + strValues + ' );';
		Code.Add( strStmt );
		Table.Next;
	end;

	Code.Add('');
end;

constructor TSqlExporter.Create;
begin
	inherited;
end;

destructor TSqlExporter.Destroy;
begin
	inherited;
end;

procedure TSqlExporter.DoFileNameChange;
begin

end;

procedure TSqlExporter.ExportGroup(GroupName: String);
begin
	with TAdsGroup.Create(Dictionary, GroupName) do
	try
		with TStringStream.Create('') do
		try
			WriteString('EXECUTE PROCEDURE sp_CreateGroup(');
			WriteString(CtrlLf + #9);
			WriteString(QuotedStr(GroupName) + ',');
			WriteString(CtrlLf + #9);
			try
				WriteString(QuotedStr(Description));
			except
				on E: EADSDatabaseError do
					WriteString('NULL');
			end;
			WriteString(');');


			Code.Add(DataString);
		finally
			Free;
		end;
	finally
		Free;
	end;
end;

procedure TSqlExporter.ExportLink(LinkName: String);
var
	Options: TAdsLinkOptions;
begin
	with TAdsLink.Create(Dictionary, LinkName) do
	try
		Options := GetLinkOptions;

		with TStringStream.Create('') do
		try
			WriteString('EXECUTE PROCEDURE sp_CreateLink(');
			WriteString(CtrlLf + #9);
			WriteString(QuotedStr(LinkName) + ',');
			WriteString(CtrlLf + #9);
			WriteString(QuotedStr(GetLinkPath) + ',');
			WriteString(CtrlLf + #9);
			if loGlobal in Options then
				WriteString('TRUE' + ',')
			else
				WriteString('FALSE' + ',');

			WriteString(CtrlLf + #9);
			if loPathIsStatic in Options then
				WriteString('TRUE' + ',')
			else
				WriteString('FALSE' + ',');

			WriteString(CtrlLf + #9);
			if loAuthenticateActiveUser in Options then
				WriteString('TRUE' + ',')
			else
				WriteString('FALSE' + ',');

			WriteString(CtrlLf + #9);
			WriteString(QuotedStr(GetUserName) + ',');
			WriteString(CtrlLf + #9);
			WriteString('NULL');

			WriteString(');');

			Code.Add(DataString);
		finally
			Free;
		end;
	finally
		Free;
	end;
end;

procedure TSqlExporter.ExportMembership(GroupName, UserName: string);
begin
	with TStringStream.Create('') do
	try
		WriteString('EXECUTE PROCEDURE sp_AddUserToGroup(');
		WriteString(CtrlLf + #9);
		WriteString(QuotedStr(UserName) + ',');
		WriteString(CtrlLf + #9);
		WriteString(QuotedStr(GroupName) + ');');

		Code.Add(DataString);
	finally
    Free;
	end;
end;

procedure TSqlExporter.ExportPermissions(Grantee: string; ObjectType: Word;
	ObjectName, ParentName: string; Permissions: TAdsPermissionTypes);
{const
	RevokeCommand = 'REVOKE %s ON "%s" FROM "%s";';
	RevokeColumnCommand = 'REVOKE %s ( "%s" ) ON "%s" FROM "%s";';
	GrantCommand = 'GRANT %s ON "%s" TO "%s";';
	GrantColumnCommand = 'GRANT %s ( "%s" ) ON "%s" TO "%s";';
var
	I: TAdsPermissionType;
	Operation, Statement: String;
}
begin
{	with TStringStream.Create('') do
	try
		if ObjectType <> ADS_DD_COLUMN_OBJECT then
			WriteString(Format(RevokeCommand, [ 'ALL', ObjectName, Grantee ]) + CtrlLf);

		for I := Low(TAdsPermissionType) to High(TAdsPermissionType) do
		begin
			Operation := '';

			case I of
				ptRead:
					Operation := 'SELECT';
				ptUpdate:
					Operation := 'UPDATE';
				ptExecute:
					Operation := 'EXECUTE';
				ptInherit:
					Operation := 'INHERIT';
				ptInsert:
					Operation := 'INSERT';
				ptDelete:
					Operation := 'DELETE';
				ptLinkAccess:
					Operation := 'ACCESS';
			end;

			if I in Permissions then
			begin

				case ObjectType of
					ADS_DD_COLUMN_OBJECT:
						if I <> ptInherit then
							Statement :=
								Format(GrantColumnCommand, [ Operation, ObjectName, ParentName, Grantee ]);
					ADS_DD_TABLE_OBJECT:
						if not (I in [ptRead, ptUpdate, ptInsert]) then
							Statement :=
								Format(GrantCommand, [Operation, ObjectName, Grantee ]);
					else
						Statement :=
							Format(GrantCommand, [Operation, ObjectName, Grantee ]);
				end;

				WriteString(Statement + CtrlLf);
			end;
		end;

		Code.Add(DataString);
	finally
		Free;
	end;
}
end;

procedure TSqlExporter.ExportProcedure(ProcedureName: String);
var
	I: Integer;
	PrefixWithComma: Boolean;
begin
	with TAdsProc.Create(Dictionary, ProcedureName) do
	try
		with TStringStream.Create('') do
		try
			WriteString('CREATE PROCEDURE ');
			WriteString('"' + ProcedureName + '" ');
			WriteString('(');

			with GetParameters(GetProcInput, '', '') do
			try
				PrefixWithComma := Count > 0;

				for I := 0 to Count-1 do
				begin
					WriteString(Strings[I]);

					if I <> Count-1 then
						WriteString(', ');
				end;
			finally
				Free;
			end;

			with GetParameters(GetProcOutput, '', 'OUTPUT') do
			try
				if PrefixWithComma then
					WriteString(', ');

				for I := 0 to Count-1 do
				begin
					WriteString(Strings[I]);

					if I <> Count-1 then
						WriteString(', ');
				end;
			finally
				Free;
			end;

			WriteString(') ');
			WriteString('FUNCTION "' + GetProcedureName + '" ');
			WriteString('IN LIBRARY "' + GetDLLName + '";');

			Code.Add(DataString);
		finally
			Free;
		end;
	finally
		Free;
	end;
end;

procedure TSqlExporter.ExportRelation(RelationName: String);
begin
	with TAdsRef.Create(Dictionary, RelationName) do
	try
		with TStringStream.Create('') do
		try
			WriteString('EXECUTE PROCEDURE sp_CreateReferentialIntegrity(');
			WriteString(CtrlLf + #9);
			WriteString(QuotedStr(RelationName) + ',');
			WriteString(CtrlLf + #9);
			WriteString(QuotedStr(GetParentTable) + ',');
			WriteString(CtrlLf + #9);
			WriteString(QuotedStr(GetChildTable) + ',');
			WriteString(CtrlLf + #9);
			WriteString(QuotedStr(GetForeignIndex) + ',');
			WriteString(CtrlLf + #9);
			WriteString(GetUpdateRule + ',');
			WriteString(CtrlLf + #9);
			WriteString(GetDeleteRule + ',');
			WriteString(CtrlLf + #9);
			WriteString(QuotedStr('') + ',');
			WriteString(CtrlLf + #9);
			WriteString(QuotedStr(GetPkeyError) + ',');
			WriteString(CtrlLf + #9);
			WriteString(QuotedStr(GetCascadeError) + ');');

			Code.Add(DataString);
		finally
			Free;
		end;
	finally
		Free;
	end;
end;

procedure TSqlExporter.ExportTable(TableName: String);
var
	CodeTable: TAdsTable;

	FTSIndexes: TStrings;

	iField: integer;
	iIndex: integer;
	iDelimiter: integer;
	strCode : string;
	strIndexExpr : string;
	strIndexFields : string;
	strIndexes : string;
	acName : array[0..MAX_DATA_LEN] of char;
	strIndexFileName : string;
	strDelimiters: String;
	strNoiseWords : String;
	strDropChars : String;
	strConditionalChars: String;
	hIndexHandle: ADSHANDLE;
	wTableType: Word;
	wLength: Word;
	ulMinWord: UNSIGNED32;
	ulMaxWord: UNSIGNED32;
	ulFTSOptions: UNSIGNED32;
	usLen : UNSIGNED16;
	ulPageSize : UNSIGNED32;
	I: Integer;
begin
	FTSIndexes := TStringList.Create;

	CodeTable := TAdsTable.Create(nil);
	try

		with Code do
		begin
			CodeTable.AdsConnection := Connection;
			CodeTable.TableName := TableName;

			{*  Add in the type of table to create *}
			wLength := 2;
			Dictionary.GetTableProperty(
				TableName, ADS_DD_TABLE_TYPE, @wTableType, wLength);

			case wTableType of
				ADS_ADT:
					begin
						CodeTable.TableType := ttAdsADT;
					end;
				ADS_CDX:
					begin
						CodeTable.TableType := ttAdsCDX;
					end;
				ADS_NTX:
					begin
						CodeTable.TableType := ttAdsNTX;
					end;
			end;

			CodeTable.Active := TRUE;

			{* Start creating the SQL Create statement *}
			strCode := 'Create Table "';
			strCode := strCode + TableName;
			strCode := strCode + '" (';

			{* This for loops adds each field to the SQL create statement *}
			for iField := 0 to CodeTable.FieldCount-1 do
			begin
				with CodeTable.Fields.Fields[iField] do
				begin
					if iField = 0 then
						strCode := strCode + ' "' + FieldName + '" '
					else
						strCode := strCode + ', "' + FieldName + '" ';

					case CodeTable.AdsGetFieldType( FieldName ) of
						AdsfldLOGICAL:
							strCode := strCode + 'Logical';
						AdsfldNUMERIC:
							strCode := strCode + 'Numeric( ' +
								IntToStr(CodeTable.AdsGetFieldLength( FieldName ) ) +
								' ,' +
								IntToStr(CodeTable.AdsGetFieldDecimals( FieldName ) ) +
								' )';
						AdsfldDATE:
							strCode := strCode + 'Date';
						AdsfldSTRING:
							strCode := strCode+'Char( '+IntToStr(Size)+' )';
						AdsfldMEMO:
							strCode := strCode + 'Memo';
						AdsfldVARCHAR:
							strCode := strCode + 'VarChar( ' +
								IntToStr(CodeTable.AdsGetFieldLength(FieldName ) )+
								' )';
						AdsfldDOUBLE:
							strCode := strCode + 'Double';
						AdsfldINTEGER:
							strCode := strCode + 'Integer';
						AdsfldSHORTINT:
							strCode := strCode+'Short';
						AdsfldTIME:
							strCode := strCode + 'Time';
						AdsfldTIMESTAMP:
							strCode := strCode + 'TimeStamp';
						AdsfldAUTOINC:
							strCode := strCode + 'AutoInc';
						AdsfldRAW:
							strCode := strCode + 'Raw( ' + IntToStr(Size) + ' )';
						AdsfldBINARY:
							strCode := strCode + 'Blob';
						AdsfldIMAGE:
							strCode := strCode + 'BLOB';
						AdsfldCURDOUBLE:
							strCode := strCode + 'CurDouble';
						AdsfldMONEY:
							strCode := strCode + 'Money';
						else
							begin
								Application.MessageBox('A Field Type not supported by' +
										'the StreamLine SQL Engine was in the' +
										'table to be converted.',
										'Table Creation Failure',
										MB_OK + MB_DEFBUTTON1);
								exit;
							end;
					end; {* case CodeTable.AdsGetFieldType( FieldName ) of *}
				end; {* with CodeTable.Fields.Fields[iField] do *}

			end; {* for iField := 0 to CodeTable.FieldCount-1 do *}

			strCode := strCode + ');';
			Add( strCode );
			Add( '');

			{* SQL only support auto-open indexes so that is all that will
				 be created.  Always call update before accessing IndexDefs because
				 there is no guarantee that the information is current. *}
			CodeTable.IndexDefs.Update;
			for iIndex:= 0 to CodeTable.IndexDefs.count -1 do
			begin
				CodeTable.IndexName := CodeTable.IndexDefs.Items[iIndex].Name;
				if CodeTable.AdsIsIndexUnique then
					strCode := 'Create Unique Index "' + CodeTable.IndexName
				else
					strCode := 'Create Index "' + CodeTable.IndexName;
					strCode := strCode + '" on "' + TableName + '" ( ';

				strIndexFields :=
					CodeTable.IndexDefs.Items[iIndex].Fields;
				strIndexes := '';

				while True do
				begin
					if Length(strIndexFields) = 0 then
						Break;

					iDelimiter := Pos(';', strIndexFields);

					if iDelimiter > 0 then
					begin
						strIndexes :=
							strIndexes
								+ '"' + Copy(strIndexFields, 1, iDelimiter-1) + '"';
						System.Delete(strIndexFields, 1, iDelimiter);
					end else
					begin
						strIndexes := strIndexes + '"' + strIndexFields + '"';
						strIndexFields := '';
					end;

					if CodeTable.AdsIsIndexDescending then
						strIndexes := strIndexes + ' DESC';

					if Length(strIndexFields) > 0 then
						strIndexes := strIndexes + ', ';
				end;

				strCode := strCode + strIndexes + ' ); ';
				Add( strCode );
			end;

			// Handle the FTS indexes
			FTSIndexes.Clear;
			CodeTable.GetFTSIndexNames( FTSIndexes );

			for iIndex := 0 to ( FTSIndexes.Count - 1 ) do
			begin
				{* Retrieve the information needed to create the index *}
				AceCheck( CodeTable, ACE.AdsGetIndexHandle( CodeTable.Handle,
						PChar( FTSIndexes.Strings[iIndex] ),
						@hIndexHandle ) );

				GetFTSIndexInfo( CodeTable, hIndexHandle, strIndexExpr, strDelimiters, strNoiseWords,
					strDropChars, strConditionalChars, ulMinWord, ulMaxWord,
					ulFTSOptions );

				ACEUNPUB.AdsGetIndexPageSize( hIndexHandle, @ulPageSize );
				usLen := length( acName );
				ACECheck( CodeTable, ACE.AdsGetIndexFileName( hIndexHandle, ADS_BASENAMEANDEXT,
					@acName, @usLen ) );
				strIndexFileName := acName;

				strCode := 'Create Index "' + FTSIndexes.Strings[iIndex];
				strCode := strCode + '" on "' + TableName + '" ( "';
				strCode := strCode + strIndexExpr + '" ) ';

				Add( strCode );

				{* fts index options *}
				strCode := '          CONTENT ';
				if ( ulFTSOptions and ADS_FTS_KEEP_SCORE ) = ADS_FTS_KEEP_SCORE then
					strCode := strCode + ' KEEPSCORE';

				if ( ulFTSOptions and ADS_FTS_FIXED ) = ADS_FTS_FIXED then
					strCode := strCode + ' NOTMAINTAINED';

				if ( ulFTSOptions and ADS_FTS_CASE_SENSITIVE ) = ADS_FTS_CASE_SENSITIVE then
					strCode := strCode + ' CASESENSITIVE';

				if ( ulFTSOptions and ADS_FTS_PROTECT_NUMBERS ) = ADS_FTS_PROTECT_NUMBERS then
					strCode := strCode + ' PROTECTNUMBERS';

				Add( strCode );
				strCode := '          In File "' + strIndexFileName + '" ';
				Add( strCode );

				strCode := '          PageSize ' + IntToStr( ulPageSize );
				Add( strCode );

				strCode := '          Min Word ' + IntToStr( ulMinWord );
				Add( strCode );

				strCode := '          Max Word ' + IntToStr( ulMaxWord );
				Add( strCode );

				{*
				 * Print the delimiters and noise words and related items.
				 *}
				strDelimiters := QuotedStr( strDelimiters );
				strCode := '          New Delimiters ' + strDelimiters;
				Add( strCode );

				{* Break noise words into a prettier block of text *}
				strNoiseWords := QuotedStr( strNoiseWords );
				strCode := '          New Noise ' + strNoiseWords;
				Add( strCode );

				strDropChars := QuotedStr( strDropChars );
				strCode := '          New DropChars ' + strDropChars;
				Add( strCode );

				strConditionalChars := QuotedStr( strConditionalChars );
				strCode := '          New Conditionals ' + strConditionalChars;
				strCode := strCode + ';';
				Add( strCode );
			end;

			CodeTable.IndexName := '';
			CodeTable.IndexDefs.Clear;
			CodeTable.IndexFiles.Clear;

			Add('');

			if IncludeData then
			begin
				CodeTable.First;
				AddInsertStatements( CodeTable );
			end;

			CodeTable.Active := FALSE;
		end; {* with TableToCodeForm do *}

	finally
		CodeTable.IndexDefs.Clear;
		CodeTable.IndexFiles.Clear;
		CodeTable.IndexName := '';
		CodeTable.Active := FALSE;

		CodeTable.Free;

		FTSIndexes.Free;
	end; {* try/finally block *}

	// Export Triggers...
	with TDBAdsTable.Create(Dictionary, TableName) do
	try
		RefreshProperties;

		for I := 0 to Triggers.Count-1 do
		begin
			ExportTrigger(Triggers[I], TableName);
			Code.Add('');
		end;
	finally
		Free;
	end;
end;

procedure TSqlExporter.ExportTrigger(TriggerName, OwnerTableName: String);
var
	Options: TAdsTrigOptions;
begin
	with TAdsTrigger.Create(Dictionary, TriggerName) do
	try
		with TStringStream.Create('') do
		try
			WriteString('CREATE TRIGGER "' + TriggerName + '"');
			WriteString(CtrlLf + #9);
			WriteString('ON "' + OwnerTableName + '"');

			WriteString(CtrlLf + #9);
			case GetTriggerType of
				ttBefore:
					WriteString('BEFORE ');
				ttInsteadOf:
					WriteString('INSTEAD OF ');
				ttAfter:
					WriteString('AFTER ');
			end;
			case GetEventType of
				etInsert:
					WriteString('INSERT ');
				etUpdate:
					WriteString('UPDATE ');
				etDelete:
					WriteString('DELETE ');
			end;

			WriteString(CtrlLf);
			case GetContainerType of
				ctStdLib:
					begin
						WriteString(#9);
						WriteString('FUNCTION "' + GetFunctionName + '" ');
						WriteString('IN LIBRARY "' + GetContainer + '" ');
					end;
				ctCOM:
					begin
						WriteString(#9);
						WriteString('FUNCTION "' + GetFunctionName + '" ');
						WriteString('IN ASSEMBLY "' + GetContainer + '" ');
					end;
				ctScript:
					begin
						WriteString('BEGIN' + CtrlLf);
						WriteString(GetContainer + CtrlLf);
						WriteString('END ');
					end;
			end;

			Options := GetOptions;
			if (toNoValues in Options) then
				WriteString('NO VALUES ');

			if (toNoMemosOrBlobs in Options) then
				WriteString('NO MEMOS ');

			if (toNoTransaction in Options) then
				WriteString('NO TRANSACTION ');

			WriteString('PRIORITY ' + IntToStr(GetPriority));
			WriteString(';');

			Code.Add(DataString);
		finally
			Free;
		end;
	finally
		Free;
	end;
end;

procedure TSqlExporter.ExportUser(UserName: String);
begin
	if UserName = 'ADSSYS' then
		Exit;

	with TAdsUser.Create(Dictionary, UserName) do
	try
		with TStringStream.Create('') do
		try
			WriteString('EXECUTE PROCEDURE sp_CreateUser(');
			WriteString(CtrlLf + #9);
			WriteString(QuotedStr(UserName) + ',');
			WriteString(CtrlLf + #9);
			WriteString('NULL' + ',');
			WriteString('/* Þifre Bilgisini Elinizle Giriniz... */');
			WriteString(CtrlLf + #9);
			try
				WriteString(QuotedStr(Description));
			except
				on E: EADSDatabaseError do
					WriteString('NULL');
			end;
			WriteString(');');
			WriteString(CtrlLf);

			Code.Add(DataString);
		finally
			Free;
		end;
	finally
		Free;
	end;
end;

procedure TSqlExporter.ExportView(ViewName: String);
begin
	with TAdsView.Create(Dictionary, ViewName) do
	try
		with TStringStream.Create('') do
		try
			WriteString('CREATE VIEW ');
			WriteString('"' + ViewName + '" ');
			WriteString('AS ');
			WriteString(GetSTMT);
			WriteString(';');

			Code.Add(DataString);
		finally
			Free;
		end;
	finally
		Free;
	end;
end;

procedure TSqlExporter.Finalize;
begin
	Connection.Free;
end;

procedure TSqlExporter.Initialize;
begin
	Connection := TAdsConnection.Create(nil);
	ConvertDictToConn(Dictionary, Connection);
end;

{ TSqlExporterFactory }

function TSqlExporterFactory.GetDescription: String;
begin
	Result := 'SQL';
end;

function TSqlExporterFactory.GetExtension: String;
begin
	Result := '.sql';
end;

function TSqlExporterFactory.GetFilterString: String;
begin
	Result := 'SQL Files (*.sql)|*.sql';
end;

function TSqlExporterFactory.GetInstance: TBaseCodeExporter;
begin
	Result := TSqlExporter.Create;
end;

function TSqlExporterFactory.GetLanguage: String;
begin
	Result := 'SQL';
end;

function TSqlExporterFactory.GetSupportsData: Boolean;
begin
	Result := True;
end;

initialization
	ExporterFactory := TSqlExporterFactory.Create(nil);
	CodeExporterList.Add(ExporterFactory);

finalization
	CodeExporterList.Remove(ExporterFactory);
	ExporterFactory.Free;

end.
