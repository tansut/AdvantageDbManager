unit UDelphiExporter;

interface

uses
	Windows, SysUtils, Classes, Db, AdsTable, AdsData, AdsFunc, AdsDictionary,
	AdsSet, ADSCNNCT, UExportCode, Types, Ace, AceUnPub, Dialogs;

type

	TDelphiExporter = class(TBaseCodeExporter)
	private
		CallProc: TStrings;
		Connection: TAdsConnection;

		procedure AddHeader;
		procedure AddFooter;
	protected
		procedure DoFileNameChange; override;

		procedure ExportUser(UserName: String); override;
		procedure ExportGroup(GroupName: String); override;
		procedure ExportTable(TableName: String); override;
		procedure ExportProcedure(ProcedureName: String); override;
		procedure ExportView(ViewName: String); override;
		procedure ExportRelation(RelationName: String); override;
		procedure ExportLink(LinkName: String); override;
		procedure Initialize; override;
		procedure Finalize; override;
	public
		constructor Create; override;
		destructor Destroy; override;
	end;

	TDelphiExporterFactory = class(TCodeExporterFactory)
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
	UUtils;

var
	ExporterFactory: TDelphiExporterFactory;

{ TDelphiExporter }

procedure TDelphiExporter.AddFooter;
begin
	with Code do
	begin
		Add('procedure CreateAll(strDatabasePath: String; bReplace: Boolean);');
		Add('begin');
		AddStrings(CallProc);
		Add('end;');
		Add('');
		Add('end.');
	end;
end;

procedure TDelphiExporter.AddHeader;
begin
	with Code do
	begin
		if Length(FileName) = 0 then
			Add('unit unit1;')
		else
			Add('unit ' + ExtractFileName(FileName));
		Add('');

		Add('interface');
		Add('');

		Add('uses');
		Add('  Windows, Messages, SysUtils, Classes, Forms, Db, AdsTable, ');
		Add('  AdsData, AdsFunc, AdsSet, ADSCNNCT;');
		Add('');

		Add('procedure CreateAll(strDatabasePath: String; bReplace: Boolean);');
		Add('');
		Add('');

		Add('implementation');
		Add('');
	end;
end;

constructor TDelphiExporter.Create;
begin
	inherited;

	CallProc := TStringList.Create;
end;

destructor TDelphiExporter.Destroy;
begin
	CallProc.Free;

	inherited;
end;

procedure TDelphiExporter.DoFileNameChange;
var
	I: Integer;
begin
	if Length(FileName) > 0 then
	begin
		for I := 0 to Code.Count-1 do
		begin
			if Pos('unit ', Code[I]) = 1 then
			begin
				Code[I] := 'Unit ' + GetFileNameWoExt(FileName) + ';';

				Break;
			end;
		end;
	end;
end;

procedure TDelphiExporter.ExportGroup(GroupName: String);
begin

end;

procedure TDelphiExporter.ExportLink(LinkName: String);
begin

end;

procedure TDelphiExporter.ExportProcedure(ProcedureName: String);
begin

end;

procedure TDelphiExporter.ExportRelation(RelationName: String);
begin

end;

procedure TDelphiExporter.ExportTable(TableName: String);
var
	i: Integer;
	iIndex: Integer;
	iField: Integer;
	iStr: Integer;

	wLength : Word;
	wTableType: Word;
	ulFTSOptions, ulMinWord, ulMaxWord, ulPageSize: Cardinal;
	usLen: DWord;

	ProcDeclStr: String;
	ProcCallStr: String;

	IndexSource: TStrings;
	FTSIndexes: TStrings;
	IndexFiles: TStrings;

	acName : array[0..MAX_DATA_LEN] of char;

	strIndexExpr: String;
	strIndexCond: String;
	strIndexName: String;
	strIndexFileName: String;
	strIndexExt: String;

	strCode: String;
	strOptions: String;

	strTmp: String;
	strDelimiters: String;
	strNoiseWords: String;
	strDropChars: String;
	strConditionalChars: String;

	CodeTable: TAdsTable;

	hIndexHandle: ADSHANDLE;
begin
	IndexSource := TStringList.Create;
	FTSIndexes := TStringList.Create;
	IndexFiles := TStringList.Create;

	ProcDeclStr :=
		Format(
			'procedure CreateTable%s(strDatabasePath: String; bReplace: Boolean);',
			[RemoveSpecialChars(TableName)]);

	ProcCallStr :=
		Format(
			'CreateTable%s(strDatabasePath, bReplace);',
			[RemoveSpecialChars(TableName)]);


	CodeTable := TAdsTable.Create(nil);

	try
		with Code do
		begin
			Add(ProcDeclStr);

			Add( 'var' );
			Add( '   oTable : TADSTable;' );
			Add( '   oConnect : TADSConnection;' );
			Add( 'begin');
			Add( '   oTable := TADSTable.Create( Application );' );
			Add( '   oConnect := TADSConnection.Create( Application );' );
			Add( '' );
			Add( '   try' );
			Add( '      oConnect.ConnectPath := strDatabasePath;' );
			Add( '      oConnect.AdsServerTypes := [stADS_REMOTE, stADS_LOCAL];' );
			Add( '      oConnect.IsConnected := TRUE;' );
			Add( '' );
			Add( '      oTable.AdsConnection := oConnect;' );
			Add( '      oTable.TableName := ''' +  TableName + ''';' );
			Add( '' );

			{*  Add in the type of table to create *}
			wLength := 2;
			Dictionary.GetTableProperty(
				TableName, ADS_DD_TABLE_TYPE, @wTableType, wLength);

			case wTableType of
				ADS_ADT:
					begin
						Add( '      oTable.TableType := ttAdsADT;');
						CodeTable.TableType := ttAdsADT;
					end;
				ADS_CDX:
					begin
						Add( '      oTable.TableType := ttAdsCDX;');
						CodeTable.TableType := ttAdsCDX;
					end;
				ADS_NTX:
					begin
						Add( '      oTable.TableType := ttAdsNTX;');
						CodeTable.TableType := ttAdsNTX;
					end;
			end;
			Add( '' );

			Add( '      if not bReplace then' );
			Add( '         if oTable.Exists then' );
			Add( '            exit;' );
			Add( '' );
			Add( '      if ( strDatabasePath[ Length( strDatabasePath ) ] <> ''\'' ) then' );
			Add( '         strDatabasePath := strDatabasePath + ''\'';' );

			{* The table type we are creating affects what files we want to automatically delete before
			 * the create is performed. *}
			case wTableType of
				ADS_ADT:
					begin
						Add( '      DeleteFile( strDatabasePath + ''' + TableName + '.ADT'' );' );
						Add( '      DeleteFile( strDatabasePath + ''' + TableName + '.ADM'' );' );
						Add( '      DeleteFile( strDatabasePath + ''' + TableName + '.ADI'' );' );
					end;
				ADS_CDX:
					begin
						Add( '      DeleteFile( strDatabasePath + ''' + TableName + '.DBF'' );' );
						Add( '      DeleteFile( strDatabasePath + ''' + TableName + '.FPT'' );' );
						Add( '      DeleteFile( strDatabasePath + ''' + TableName + '.CDX'' );' );
					end;
				ADS_NTX:
					begin
						Add( '      DeleteFile( strDatabasePath + ''' + TableName + '.DBF'' );' );
						Add( '      DeleteFile( strDatabasePath + ''' + TableName + '.DBT'' );' );
					end;
			end;
			Add( '' );

			CodeTable.AdsConnection := Connection;
			CodeTable.TableName := TableName;
			CodeTable.Active := TRUE;

			if( CodeTable.AdsTableOptions.AdsCharType = ANSI ) then
				Add( '      oTable.AdsTableOptions.AdsCharType := ANSI;')
			else
				Add( '      oTable.AdsTableOptions.AdsCharType := OEM;');

			{* Now it is time to the Write the actual field definitions to the code*}
			Add( '' );
			Add( '      with oTable.FieldDefs do');
			Add( '      begin');
			Add( '         Clear;');
			Add( '' );

			for iField := 0 to CodeTable.FieldCount-1 do
			begin
				Add( '         with AddFieldDef do');
				Add( '         begin' );

				with CodeTable.Fields.Fields[iField] do
				begin
					Add( '            Name := ''' + FieldName + ''';' );
					case DataType of
						ftString:
							begin
								Add( '            DataType := ftString;' );
								Add( '            Size := ' + IntToStr(Size) + ';' );
							end;
						ftSmallint:
							Add( '            DataType := ftSmallInt;' );
						ftInteger:
							Add( '            DataType := ftInteger;' );
						ftWord:
							Add( '            DataType := ftWord;' );
						ftBoolean:
							Add( '            DataType := ftBoolean;' );
						ftFloat:
							begin
								if not (CodeTable.TableType = ttAdsADT)  then
								begin
									Add( '         {* Do to the lack of a Numeric'+
															'field type in Delphi please check' );
									Add( '            that the field type has not'+
															' been changed.  If the field type has' );
									Add( '            been changed the Table to'+
															' Code generator can generate SQL scripts');
									Add( '            that will retain the Numeric'+
															' field type. *}' );
								end;

								Add( '            DataType := ftFloat;' );
							end;
						ftCurrency:
							Add( '            DataType := ftCurrency;' );
						ftBCD:
							begin
								Add( '            DataType := ftBCD;' );

								{* Getting the precision of BCD requires going
									 through the FieldDefs property rather then
									 the Fields property *}
								Add( '            Precision := '+
											 IntToStr(CodeTable.FieldDefs.Items[iField].Precision) +';');
								Add( '            Size := '+ IntToStr(Size) + ';' );
							end;
						ftDate:
							Add( '            DataType := ftDate;' );
						ftTime:
							Add( '            DataType := ftTime;' );
						ftDateTime:
							Add( '            DataType := ftDateTime;' );
						ftBytes:
							begin
								Add( '            DataType := ftBytes;' );
								Add( '            Size := ' + IntToStr(Size) + ';' );
							end;
						ftVarBytes:
							begin
								Add( '            DataType := ftVarBytes;' );
								Add( '            Size := ' + IntToStr(Size) + ';' );
							end;
						ftAutoInc:
							Add( '            DataType := ftAutoInc;' );
						ftBlob:
							begin
								Add( '            DataType := ftBlob;' );
								Add( '            Size := ' + IntToStr(Size) + ';' );
							end;
						ftMemo:
							begin
								if CodeTable.TableType = ttAdsADT then
								begin
									Add( '         {* Do to the lack of a VarChar'+
															' field type in Delphi please check' );
									Add( '            that the field type has not'+
															' been changed.  If the field type has' );
									Add( '            been changed the Table to'+
															' Code generator can generate SQL scripts' );
									Add( '            that will retain the VarChar'+
															' field type. *}' );
								end;

								Add( '            DataType := ftMemo;' );
								Add( '            Size := ' + IntToStr(Size) + ';' );
							end;
						ftGraphic:
							begin
								Add( '            DataType := ftGraphic;' );
								Add( '            Size := ' + IntToStr(Size) + ';' );
							end;
						ftFmtMemo:
							Add( '            DataType := ftFmtMemo;' );
						ftParadoxOle:
							Add( '            DataType := ftParaDoxOle;' );
						ftDBaseOle:
							Add( '            DataType := ftDBaseOle;' );
						ftCursor:
							Add( '            DataType := ftCursor;' );
						ftFixedChar:
							begin
								Add( '            DataType := ftFixedChar;' );
								Add( '            Size := ' + IntToStr(Size) + ';' );
							end;
						ftWideString:
							begin
								Add( '            DataType := ftWideString;' );
								Add( '            Size := ' + IntToStr(Size) + ';' );
							end;
						ftLargeInt:
							Add( '            DataType := ftLargeInt;' );
						ftADT:
							Add( '            DataType := ftADT;' );
						ftArray:
							Add( '            DataType := ftArray;' );
						ftReference:
							Add( '            DataType := ftReference;' );
						ftDataSet:
							Add( '            DataType := ftDataSet;' );
						ftOraBlob:
							Add( '            DataType := ftOraBlob;' );
						ftOraClob:
							Add( '            DataType := ftOraClob;' );
						ftVariant:
							Add( '            DataType := ftVariant;' );
						ftInterface:
							Add( '            DataType := ftInterface;' );
						ftIDispatch:
							Add( '            DataType := ftIDispatch;' );
						ftGuid:
							Add( '            DataType := ftGuid;' );
					end; {* case DataType of *}
				end; {* with CodeTable.Fields.Fields[iField] do *}

				Add( '         end;' );
				Add( '' );
			end; {* for iField := 0 to CodeTable.FieldCount-1 do *}

			Add( '      end;');
			Add( '' );
			Add( '' );
			Add( '      try' );
			Add( '         oTable.CreateTable;' );
			Add( '      except on E: exception do' );
			Add( '      begin' );
			Add( '         {* Your Error Handling Goes Here! *}' );
			Add( '         Application.MessageBox( ''Table ' +
									CodeTable.TableName + ' Could Not Be Created'',' );
			Add( '                              ''Table Creation Failure'',' );
			Add( '                              MB_OK + MB_DEFBUTTON1);' );
			Add( '         raise;');
			Add( '      end;' );
			Add( '   end;' );
			Add( '' );

			{* Now the indexes need to be added to the table.
				All non-auto-open indexes will be added to the table
				using the IndexFile property.  Then all auto-open indexes
				not containing a condition will be created using AddIndex
				If the index is conditional it will be created using a
				call to the extended method AdsCreateIndex.  All indexes
				that are non-auto-open will need to created using the call
				to the extended method AdsCreateIndex method *}

				Dictionary.GetIndexFileNames(TableName, TStringList(IndexFiles));
				for I := 0 to IndexFiles.Count-1 do
				begin
					try
						CodeTable.IndexFiles.Add(IndexFiles[i]);
					except
					end;
				end;

			{* Always call update before accessing IndexDefs because
				 there is no guarantee that the information is current. *}
			CodeTable.IndexDefs.Update;

			if  CodeTable.IndexDefs.Count > 0 then
			begin
				Add( '   {* The table was created and now the structural' );
				Add( '      indexes will be added using the AddIndex method');
				Add( '      of TAdsTable. *}' );
				Add( '' );
				Add( '      oTable.Active := TRUE;' );
			end;

			for iIndex:= 0 to CodeTable.IndexDefs.count -1 do
			begin
				CodeTable.IndexName := CodeTable.IndexDefs.Items[iIndex].Name;

				{* Use AdsGetIndexExpr for returning this information
					 rather than TIndexDefs properties becasue the information
					 needed to create an index for a DBF is not present, i.e.
					 DtoS(Field1).*}
				strIndexExpr := CodeTable.AdsGetIndexExpr;

				{* Use AdsGetIndexCondition for returning the condition, if one
					 is present.  This is needed because indexes with auto-open
					 indexes with conditions can not be created using AddIndex. *}
				strIndexCond := CodeTable.AdsGetIndexCondition;

				{* Use AdsGetIndexFileName becuase information on the actual file
					 the index is from is not avaible. *}
				strIndexFileName := CodeTable.AdsGetIndexFileName(foBaseNameAndExt);

				{* Determine the auto-open index file extension *}
				if CodeTable.TableType = ttAdsADT then
					strIndexExt := '.adi'
				else
					if CodeTable.TableType = ttAdsCDX then
						strIndexExt := '.cdx'
					else
						strIndexExt := '.ntx';

					{* Determine if the index is auto-open without a condition
					 so that AddIndex can be used. *}
				if (strIndexCond = '') and
					(CompareText(strIndexFileName, TableName+strIndexExt)=0)
				then
				begin
					strCode := '      oTable.AddIndex( ''' + CodeTable.IndexName +
								''', ' + QuotedStr(strIndexExpr) + ', [';

					{* The IndexOptions are determined in this block of code.
						 ixCaseInsensitive can be ignored as a possible option
						 because the index expression is used rather than the
						 fields.  When the original index is created in
						 AdsTable.pas UPPER() is added to all fields.  Use
						 AdsIsIndexCompount instead of looking at ixExpression
						 because it is not being set by ACE *}
					if CodeTable.AdsIsIndexCompound then
						strOptions := 'ixExpression';

					if ixUnique in CodeTable.IndexDefs.Items[iIndex].Options then
						if( length( strOptions ) > 0 ) then
							strOptions := strOptions + ', ixUnique'
						else
							strOptions := 'ixUnique';

					if ixDescending in CodeTable.IndexDefs.Items[iIndex].Options then
						if( length( strOptions ) > 0 ) then
							strOptions := strOptions + ', ixDescending'
						else
							strOptions := 'ixDescending';

					strCode := strCode + strOptions + ']);';
					Add( strCode );
					Add( '' );
				end {* if (strIndexCond = '') *}
				else
				begin
					{* The IndexFileName *}
					IndexSource.Add( '      oTable.AdsCreateIndex( ''' +
																				 strIndexFileName + ''', ' );

					{* The IndexTagName *}
					IndexSource.Add( '                           ''' +
																				CodeTable.IndexName + ''',' );
					{* The actual Index Expression *}
					IndexSource.Add( '                           ' +
																				QuotedStr(strIndexExpr) + ',' );

					{* The Index Condition *}
					IndexSource.Add( '                           ' +
																				QuotedStr(strIndexCond) + ',' );

					{* The Index While Condition is not available inside
						 of the TDataSet Descendant *}
					IndexSource.Add( '                           '''',' );

					strCode :=( '                          [' );

					{* The IndexOptions are determined in this block of code.
						 ixCaseInsensitive can be ignored as a possible option
						 because the index expression is used rather than the
						 fields.  When the original index is created in
						 AdsTable.pas UPPER() is added to all fields.  Use
						 AdsIsIndexCompount instead of looking at ixExpression
						 because it is not being set by ACE *}
					if CodeTable.AdsIsIndexCompound then
						strOptions := 'optCOMPOUND';

					if ixUnique in CodeTable.IndexDefs.Items[iIndex].Options then
						if( length( strOptions ) > 0 ) then
							strOptions := strOptions + ', optUNIQUE'
						else
							strOptions := 'optUNIQUE';

					if ixDescending in CodeTable.IndexDefs.Items[iIndex].Options then
						if( length( strOptions ) > 0 ) then
							strOptions := strOptions + ', optDESCENDING'
						else
							strOptions := 'optDESCENDING';

					strCode := strCode + strOptions + ']);';
					IndexSource.Add( strCode );

				end; {* else *}
			end; {* for iIndex:= 0 to CodeTable.IndexDefs.count -1 do *}


			// Handle the FTS indexes
			FTSIndexes.Clear;
			CodeTable.GetFTSIndexNames( FTSIndexes );

			if FTSIndexes.Count > 0 then
				{* Make sure the table is open for this *}
				IndexSource.add( '      oTable.Active := TRUE;' );

			for i := 0 to ( FTSIndexes.Count - 1 ) do
			begin
				{* Retrieve the information needed to create the index *}
				AceCheck( CodeTable, ACE.AdsGetIndexHandle( CodeTable.Handle,
																									PChar( FTSIndexes.Strings[i] ),
																																@hIndexHandle ) );
				GetFTSIndexInfo( CodeTable, hIndexHandle, strIndexExpr, strDelimiters, strNoiseWords,
															strDropChars, strConditionalChars, ulMinWord, ulMaxWord,
															ulFTSOptions );

				ACEUNPUB.AdsGetIndexPageSize( hIndexHandle, @ulPageSize );

				usLen := length( acName );
				ACECheck( CodeTable, ACE.AdsGetIndexFileName( hIndexHandle, ADS_BASENAMEANDEXT,
																										 @acName, @usLen ) );
				strIndexFileName := acName;
				strIndexName := FTSIndexes.Strings[i];

				{* add the info to the string list *}
				IndexSource.Add( '      AceCheck( oTable, ACE.AdsCreateFTSIndex( oTable.GetAceTableHandle, ' );

				{* file name *}
				IndexSource.Add( '                           ''' +
						strIndexFileName + ''', ' );

				{* The IndexTagName *}
				IndexSource.Add( '                           ''' +
						strIndexName + ''',' );

				{* The field name the index is on *}
				IndexSource.Add( '                           ''' +
						strIndexExpr + ''',' );

				{* page size, min/max word lengths *}
				IndexSource.Add( '                           ' +
						IntToStr( ulPageSize ) + ',' );
				IndexSource.Add( '                           ' +
						IntToStr( ulMinWord ) + ',' );
				IndexSource.Add( '                           ' +
						IntToStr( ulMaxWord ) + ',' );

				{*
				 * Print the delimiters and such.  The FALSE for each one is
				 * the "usedefault" option for delimiter, drop char, etc.  Don't
				 * use the defaults - rather use whatever is actually in the
				 * delimiter, drop char, etc. value.
				 *}

				{* print the delimiters as byte values - looks better in the code *}
				strTmp := '';
				for iStr := 1 to length( strDelimiters ) do
					strTmp := strTmp + '#' + IntToStr( Byte( strDelimiters[iStr] ) );

				IndexSource.Add( '                           ' +
							'Word( False ), ' + strTmp + ',' );

				strNoiseWords := QuotedStr( strNoiseWords );

				{*
				 * Break noise words into a prettier block of text (and avoid
				 * the compile error about string exceeding 255 characters if
				 * the "use huge strings" option is not turned on.
				 *}
				strNoiseWords := WrapText( strNoiseWords, #$27#32#$2B#13#10 + '                           ' + #$27, [' ', #9], 70 );
				IndexSource.Add( '                           ' +
							 'Word( False ), ' );
				IndexSource.Add( '                           ' +
							 strNoiseWords + ',' );

				strDropChars := QuotedStr( strDropChars );
				IndexSource.Add( '                           ' +
							'Word( False ), ' + strDropChars + ',' );

				strConditionalChars := QuotedStr( strConditionalChars );
				IndexSource.Add( '                           ' +
							'Word( False ), ' + strConditionalChars + ',' );

				IndexSource.Add( '                           ' +
							'nil, nil, ' );

				{* fts index options *}
				strOptions := 'ADS_FTS_INDEX';
				if ( ulFTSOptions and ADS_COMPOUND ) = ADS_COMPOUND then
					strOptions := strOptions + ' or ADS_FTS_COMPOUND';

				if ( ulFTSOptions and ADS_FTS_KEEP_SCORE ) = ADS_FTS_KEEP_SCORE then
					strOptions := strOptions + ' or ADS_FTS_KEEP_SCORE';

				if ( ulFTSOptions and ADS_FTS_FIXED ) = ADS_FTS_FIXED then
					strOptions := strOptions + ' or ADS_FTS_FIXED';

				if ( ulFTSOptions and ADS_FTS_CASE_SENSITIVE ) = ADS_FTS_CASE_SENSITIVE then
					strOptions := strOptions + ' or ADS_FTS_CASE_SENSITIVE';

				if ( ulFTSOptions and ADS_FTS_PROTECT_NUMBERS ) = ADS_FTS_PROTECT_NUMBERS then
					strOptions := strOptions + ' or ADS_FTS_PROTECT_NUMBERS';

				IndexSource.Add( '                           ' +
						strOptions + ' ));' );

				{* blank line *}
				IndexSource.Add( ' ' );
			end;

			// AddStrings method doesn't work with TSyntaxMemo, it clears the
			// current contents before it adds the strings, so loop through and add
			// them individually
			//AddStrings( poAdsAddIndex );
			Add(IndexSource.Text);

			{* Clear out the poAdsAddIndex list for the next go around. *}
			IndexSource.Clear;

			if  CodeTable.IndexDefs.Count > 0 then
				Add( '      oTable.Active := FALSE;' );

			Add( '   finally');
			Add( '      oTable.Active := False;');
			Add( '      oConnect.IsConnected := False;');
			Add( '      oTable.Destroy;');
			Add( '      oConnect.Destroy;');
			Add( '   end;');
			Add( 'end;');
			Add( '');

			CodeTable.IndexName := '';
			CodeTable.IndexDefs.Clear;
			CodeTable.IndexFiles.Clear;

			CodeTable.Active := FALSE;

		end; {* with FSource *}

		CallProc.Add('  ' + ProcCallStr);
	finally
		IndexSource.Free;
		FTSIndexes.Free;
		IndexFiles.Free;

		CodeTable.Free;
	end;
end;

procedure TDelphiExporter.ExportUser(UserName: String);
begin

end;

procedure TDelphiExporter.ExportView(ViewName: String);
begin

end;

procedure TDelphiExporter.Finalize;
begin
	AddFooter;

	Connection.Free;
end;

procedure TDelphiExporter.Initialize;
begin
	Connection := TAdsConnection.Create(nil);
	ConvertDictToConn(Dictionary, Connection);

	AddHeader;
end;

{ TDelphiExporterFactory }

function TDelphiExporterFactory.GetDescription: String;
begin
	Result := 'Delphi';
end;

function TDelphiExporterFactory.GetExtension: String;
begin
	Result := '.pas';
end;

function TDelphiExporterFactory.GetFilterString: String;
begin
	Result := 'Pascal Files (*.pas,*.dpr,*.dpk,*.inc)|*.pas;*.dpr;*.dpk;*.inc';
end;

function TDelphiExporterFactory.GetInstance: TBaseCodeExporter;
begin
	Result := TDelphiExporter.Create;
end;

function TDelphiExporterFactory.GetLanguage: String;
begin
	Result := 'ObjectPascal';
end;

function TDelphiExporterFactory.GetSupportsData: Boolean;
begin
	Result := False;
end;

initialization
	ExporterFactory := TDelphiExporterFactory.Create(nil);
	CodeExporterList.Add(ExporterFactory);

finalization
	CodeExporterList.Remove(ExporterFactory);
	ExporterFactory.Free;

end.
