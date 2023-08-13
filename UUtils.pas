unit UUtils;

interface

uses
	Windows, SysUtils, Classes, Ace, AdsData, AdsDictionary, AdsCnnct, Db;


procedure ConvertDictToConn(Dict: TAdsDictionary; Conn: TAdsConnection);
function ConvertValueToSQLSyntax( oField : TField ) : string;
function GetFileNameWoExt(FileName: String): String;
function RemoveSpecialChars(Str: String): String;
procedure GetFTSIndexInfo
(
	 oDataSet : TAdsDataSet;         // (I) for error handling
	 hFTS : ADSHANDLE;               // (I) FTS index handle
	 var strField : String;          // (O) field it is indexed on
	 var strDelimiters: String;      // (O) delimiter characters
	 var strNoise : String;          // (O) noise words
	 var strDropChars : String;      // (O) drop (ignore) characters
	 var strConditionalChars: String;// (O) conditional drop characters
	 var ulMinWord: UNSIGNED32;      // (O) minimum word length
	 var ulMaxWord: UNSIGNED32;      // (O) maximum word length (key length)
	 var ulOptions: UNSIGNED32       // (O) FTS index options (ORed together)
);

function GetParameters(LongList: String; Prefix, Postfix: String): TStrings;

implementation

function GetFileNameWoExt(FileName: String): String;
var
	Index: Integer;
begin
	Index := LastDelimiter('.', FileName);

	if Index > 0 then
		Result := Copy(FileName, 1, Index-1)
	else
		Result := FileName;

	Result := ExtractFileName(Result);
end;

function RemoveSpecialChars(Str: String): String;
var
	I: Integer;
begin
	for I := 1 to Length(Str) do
	begin
		case Str[I] of
			'ý', 'I': Str[I] := 'I';
			'Ý', 'i': Str[I] := 'I';
			'ð', 'Ð': Str[I] := 'G';
			'ç', 'Ç': Str[I] := 'C';
			'ö', 'Ö': Str[I] := 'O';
			'ü', 'Ü': Str[I] := 'U';
			'þ', 'Þ': Str[I] := 'S';
			' ', '-': Str[I] := '_';
		end;
	end;

	Result := UpperCase(Str);
end;

function GetParameters(LongList: String; Prefix, Postfix: String): TStrings;
var
	I: Integer;
	Param, ParamDef: String;
begin
	Result := TStringList.Create;

	with Result do
	begin
		Text := StringReplace(LongList, ';', #13#10, [rfReplaceAll]);

		for I := 0 to Count-1 do
		begin
			Param := Strings[I];
			ParamDef := '';

			if Length(Prefix) > 0 then
				ParamDef := Prefix + ' ';
			with TStringList.Create do
			try
				Text := StringReplace(Param, ',', #13#10, [rfReplaceAll]);

				ParamDef := ParamDef + '"' + Strings[0] + '" ';
				ParamDef := ParamDef + Strings[1];

				if Count = 3 then
				begin
					ParamDef := ParamDef + '(' + Strings[2] + ')';
				end;
			finally
				Free;
			end;
			if Length(Postfix) > 0 then
				ParamDef := ParamDef + ' ' + Postfix;

			Strings[I] := ParamDef;
		end;

	end;
end;

procedure ConvertDictToConn(Dict: TAdsDictionary; Conn: TAdsConnection);
begin
	if Conn.IsConnected then Conn.IsConnected := False;
	if Dict.AliasName <> '' then Conn.AliasName := Dict.AliasName
	else Conn.ConnectPath := Dict.ConnectPath;
	Conn.AdsServerTypes := Dict.AdsServerTypes;
	Conn.LoginPrompt := False;
	Conn.Username := Dict.UserName;
	Conn.Password := Dict.Password;
end;

{*******************************************************************************
*  Module: GetFTSIndexInfo
*  Date:   10-Apr-2003
*  Description: Retrieve FTS-specific information from the given index handle
*******************************************************************************}
procedure GetFTSIndexInfo
(
	 oDataSet : TAdsDataSet;         // (I) for error handling
	 hFTS : ADSHANDLE;               // (I) FTS index handle
	 var strField : String;          // (O) field it is indexed on
	 var strDelimiters: String;      // (O) delimiter characters
	 var strNoise : String;          // (O) noise words
	 var strDropChars : String;      // (O) drop (ignore) characters
	 var strConditionalChars: String;// (O) conditional drop characters
	 var ulMinWord: UNSIGNED32;      // (O) minimum word length
	 var ulMaxWord: UNSIGNED32;      // (O) maximum word length (key length)
	 var ulOptions: UNSIGNED32       // (O) FTS index options (ORed together)
);
var
	 pucBuffer: PChar;
	 ulRetCode : UNSIGNED32;
   ulBufLen  : UNSIGNED32;
   pucField : PChar;
   pucDelimiters : PChar;
   pucNoiseWords : PChar;
   pucDropChars  : PChar;
   pucConditionalChars : PChar;

begin { GetFTSIndexInfo }


   // Initialize pucBuffer (the only one that gets set to allocated memory).
   // The others simply get set to point into the one buffer so they do not
   // need to be initialized.
   pucBuffer := nil;

   try
      // Make a call to see how long a buffer we need
      ulBufLen := 0;
			ulRetCode := ACE.AdsGetFTSIndexInfo( hFTS, nil, @ulBufLen, @pucField, nil, nil,
                                           @pucDelimiters, @pucNoiseWords,
                                           @pucDropChars, @pucConditionalChars,
																					 nil, nil, nil );

      // Should have gotten an insufficient buffer error
      if ulRetCode <> AE_INSUFFICIENT_BUFFER then
				 AceCheck( oDataSet, ulRetCode );


      pucBuffer := StrAlloc( ulBufLen );

      // Get the data
      AceCheck( oDataSet, ACE.AdsGetFTSIndexInfo( hFTS, pucBuffer, @ulBufLen, @pucField,
                                @ulMinWord, @ulMaxWord, @pucDelimiters, @pucNoiseWords,
                                @pucDropChars, @pucConditionalChars, nil, nil,
                                @ulOptions ));

      strField := pucField;
      strDelimiters := pucDelimiters;
      strNoise := pucNoiseWords;
      strDropChars := pucDropChars;
      strConditionalChars := pucConditionalChars;

   finally
      if pucBuffer <> nil then
         StrDispose( pucBuffer );
   end;

end;

function ConvertValueToSQLSyntax( oField : TField ) : string;
var
	 iOffset : integer;
	 iLength : integer;
	 strSavedDateFormat : string;
	 strSavedTimeFormat : string;
	 cSavedDateSeparator     : char;
begin
	 Result := '';

	 if oField.IsNull then
	 begin
			Result := 'NULL';
      exit;
   end;

   {* Save the date and time format, and set Delphi to use the format we need
    * for our sql syntax. This will make the AsString method do all of the
    * formatting for us. No threads running so this is perfectly save, and
    * pretty darn cool. Set them back in a finally block at the end of the
    * routine. *}
   cSavedDateSeparator := DateSeparator;
   DateSeparator := '-';
   strSavedDateFormat := ShortDateFormat;
   ShortDateFormat := 'YYYY-MM-DD';
   strSavedTimeFormat := LongTimeFormat;
   LongTimeFormat := 'HH:MM:SS';

   try

   case oField.DataType of
      {* With some types we can just put the field in with no processing. *}
      ftBoolean,
			ftSmallInt,
      ftFloat,
      ftInteger,
      ftBCD:
         Result := oField.AsString;

      ftDate,
      ftTime,
      ftDateTime :
         Result := '''' + oField.AsString + '''';

			ftString,
      ftMemo :
      begin
         {* Inspect the string, and for every quote in the string, insert another
          * one next to it. *}
         Result := oField.AsString;
         iOffset := 1;
         iLength := Length( Result );
         while ( iOffset <= iLength ) do
         begin
            if ( Result[iOffset] = '''' ) then
            begin
               insert( '''', Result, iOffset );
               inc( iOffset );
               inc( iLength );
            end;
            inc( iOffset );

            {* special case - if the field ended in a quote then we need to shove one more
             * in before we quit. *}
            if ( Result[iOffset - 1] = '''' ) and ( iOffset = iLength ) then
							insert( '''', Result, iOffset )

         end;

				 {* and then put quotes on the outside *}
         Result := '''' + Result + '''';
      end;

      ftCurrency :
         Result := FloatToStr( oField.AsFloat );

      ftAutoInc:
         Result := 'DEFAULT';

      ftBLOB,
      ftGraphic,
      ftBytes :
         {* unsupported type. *}
      begin
         raise Exception.Create( 'unsupported type' );
      end;

   else
      raise Exception.Create( 'unknown field type encountered for the following field : ' + oField.FieldName );
   end;   {* case *}

   finally
      DateSeparator := cSavedDateSeparator;
      ShortDateFormat := strSavedDateFormat;
      LongTimeFormat := strSavedTimeFormat;
   end;

end;


end.
