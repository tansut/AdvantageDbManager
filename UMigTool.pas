unit UMigTool;

interface

uses

  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DBTables, db, Mask, ToolEdit, UAdvUtils, UAdvTypes,
  UDbCon, AdsDictionary, AdsSet, AdsFunc, Udatabase, UObjEdit, adsdata,
  adstable, adscnnct, ACE, sUtils, ComCtrls, BDE, ImgList, ADODB,
  OracleData, Oracle, AdvListV,CommCtrl, Buttons, DBClient, xmldom,
  Provider, Xmlxform;

  const SilType: array[Boolean] of string = ('Hayýr', 'Evet');

type
  TfmMigTool = class(TForm)
    pnHeader: TPanel;
    pnMain: TPanel;
    pnFooter: TPanel;
    Image1: TImage;
    Label1: TLabel;
    btnNext: TButton;
    btnPrev: TButton;
    btnClose: TButton;
    SessionBDE: TSession;
    AdvDictionary: TAdsDictionary;
    BDETable: TTable;
    AdvTable: TAdsTable;
    AdsConn: TAdsConnection;
    ilStatus: TImageList;
    ADOConn: TADOConnection;
    ADOTable: TADOTable;
    OraSession: TOracleSession;
    OraLogon: TOracleLogon;
    OraQuery: TOracleQuery;
    OraDataSet: TOracleDataSet;
    ImgSmall: TImageList;
    btnHelp: TButton;
    csXML: TClientDataSet;
    nbPages: TNotebook;
    pnMigrate: TPanel;
    Label8: TLabel;
    dirAdvTable: TDirectoryEdit;
    GroupBox2: TGroupBox;
    rbMigAll: TRadioButton;
    rbMigTable: TRadioButton;
    rbMigData: TRadioButton;
    chkIndex: TCheckBox;
    pnTables: TPanel;
    Label4: TLabel;
    BtSelectAll: TSpeedButton;
    BtDeselectAll: TSpeedButton;
    LvTables: TAdvListView;
    pnSelAdvDB: TPanel;
    Label7: TLabel;
    cbAdvAlias: TComboBox;
    rbAlias: TRadioButton;
    rbPath: TRadioButton;
    edAdvPath: TFilenameEdit;
    btnNewDB: TButton;
    pnStatus: TPanel;
    lblAck: TLabel;
    Label9: TLabel;
    lblCustom: TLabel;
    pbAll: TProgressBar;
    pbCustom: TProgressBar;
    lvStatus: TListView;
    pnSelectDB: TPanel;
    Label2: TLabel;
    GroupBox1: TGroupBox;
    rbBDE: TRadioButton;
    rbStd: TRadioButton;
    rbADO: TRadioButton;
    rbOracle: TRadioButton;
    nbOpenDB: TNotebook;
    pnADO: TPanel;
    Label10: TLabel;
    edADOConn: TComboEdit;
    pnOracle: TPanel;
    Label11: TLabel;
    btnOraConn: TButton;
    pnPath: TPanel;
    lbStdXML: TLabel;
    dirDB: TDirectoryEdit;
    pnAlias: TPanel;
    Label5: TLabel;
    cbAlias: TComboBox;
    rbXML: TRadioButton;
    procedure btnCloseClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure cbAliasChange(Sender: TObject);
    procedure dirDBChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure rbAliasClick(Sender: TObject);
    procedure rbPathClick(Sender: TObject);
    procedure edAdvPathChange(Sender: TObject);
    procedure cbAdvAliasChange(Sender: TObject);
    procedure btnNewDBClick(Sender: TObject);
    procedure edADOConnButtonClick(Sender: TObject);
    procedure edADOConnChange(Sender: TObject);
    procedure btnOraConnClick(Sender: TObject);
    procedure LvTablesMouseDown(Sender: TObject; Button: TMouseButton;
                                Shift: TShiftState; X, Y: Integer);
    procedure BtSelectAllClick(Sender: TObject);
    procedure BtDeselectAllClick(Sender: TObject);
    procedure LvTablesClear(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
  private
    CurStep : integer;
    ErrorCount : integer;
    procedure SelectListCheck(subInx:integer;res:boolean;imageInx:integer);
    function  GetListViewItem(ListView: TadvListView;
                              var SubItem: Integer; P: TPoint): TListItem;
    procedure ToggleListItem(ListView: TAdvListView;
                             Item: TListItem; SubItem: Integer);
    procedure AddToListView(name: string);
    procedure getTablesBDE(dbAlias: string);
    function  CheckLastAdsError: Boolean;
    procedure AdvConn(IsAlias: Boolean; DBName: String);
    procedure getAdvAlias;
    procedure Step1;
    procedure Step2;
    procedure Step3;
    procedure Step4;
    procedure AddInfo (ImgIndex :Integer; Info:String);
    procedure ImportBDETable( strDatabaseName, strTableName: string );
    procedure ImportXMLTable( strPath: string; strFileName: string );
    procedure GetFieldDecimals( oTable: TTable; iFieldNum: integer;
                            var iPrecision, iScale: integer );
    procedure ConvertIntToAutoInc( strFileName, strField: string;
                                   i64NextAutoIncValue: Int64 );
    procedure ImportADOTable( strTable : string );
    procedure ImportOracleTable( strTable : string );
    function  LvSelectedCount : integer;
    procedure FindFiles(const Path, Mask: string; IncludeSubDir: boolean; Out List:TStringList);
  public
    NewDBCreated: Boolean;
  end;


implementation
{$R *.dfm}

procedure TfmMigTool.SelectListCheck(subInx:integer;res:boolean;imageInx:integer);
var
  i:integer;
begin
  for i :=0 to LvTables.Items.Count-1 do begin
    LvTables.SubItemImages[i, subInx] :=imageInx;
    LvTables.Items.Item[i].SubItems[subInx]:=ResType[res];
  end;
end;

function TfmMigTool.GetListViewItem(ListView: TadvListView; var SubItem: Integer; P: TPoint): TListItem;
var
  Info: TLVHitTestInfo;
begin
  Result := ListView.GetItemAt(P.x, P.Y);
  if Result <> nil then
  begin
    Info.pt := P;
    SendMessage(ListView.Handle, LVM_SUBITEMHITTEST, 0, Longint(@info));
    if Info.iSubItem = 0 then SubItem := -1
    else SubItem := Info.iSubItem-1;
  end;
end;

procedure TfmMigTool.ToggleListItem(ListView: TAdvListView;
  Item: TListItem; SubItem: Integer);
var Res: Boolean;
begin
  Res := Item.SubItems[SubItem] = SilType[True];
  Res := not Res;
  Item.SubItems[SubItem] := SilType[Res];
  ListView.SubItemImages[Item.Index, SubItem] := Integer(Res) + 1;
end;

procedure TfmMigTool.LvTablesMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var Item: TListItem;
    Index: Integer;
begin
  Item := GetListViewItem(Sender As TAdvListView, Index, Point(X, Y));
  if (Item <> nil) then ToggleListItem(Sender As TAdvListView, Item, 0);
end;

procedure TfmMigTool.AddToListView(name: string);
var
  Item: TListItem;
begin
  Item := LvTables.Items.Add;
  Item.SubItems.Add(SilType[False]);
  LvTables.SubItemImages[Item.Index,0] := 1;
  Item.SubItems.Add(name);
  LvTables.SubItemImages[Item.Index,1] := 0;
end;


procedure TfmMigTool.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmMigTool.btnNextClick(Sender: TObject);
begin
  case CurStep of
  1 : Step1;
  2 : Step2;
  3 : Step3;
  4 : Step4;
  5 : begin
        btnNext.Tag := 99;
        btnNext.Visible := False;
      end;
  end;
end;

procedure TfmMigTool.Step1;
  var mList: TStringList;
begin

   cbalias.ItemIndex := -1;
   dirdb.Text := '';
   edADOConn.Text := '';
   LvTablesClear(nil);

   // BDE secildiyse
   if rbBDE.Checked then begin
     if cbAlias.Items.Count < 1 then begin
       mList := TStringList.Create;
       try
         SessionBDE.GetAliasNames(mList);
         cbAlias.Items := mList;
       finally
         mList.Free;
       end;
     end;
     nbOpenDB.PageIndex := 0;
   end;

   // Paradox, DBase, Text secildiyse
   if rbStd.Checked then begin
     nbOpenDB.PageIndex := 1;
     lbStdXML.Caption := 'Dönüþtürmek istediðiniz veri tabanýnýn bulunduðu dizini seçiniz';
   end;

   // XML secildiyse
   if rbXML.Checked then begin
     nbOpenDB.PageIndex := 1;
     lbStdXML.Caption := 'Dönüþtürmek istediðiniz XML dosyalarýnýn bulunduðu dizini seçiniz';
   end;

   // ADO secildiyse
   if rbADO.Checked then
     nbOpenDB.PageIndex := 2;

   // Oracle secildiyse
   if rbOracle.Checked then
     nbOpenDB.PageIndex := 3;

   nbPages.PageIndex := 1;
   btnPrev.Visible := True;
   CurStep := 2;
end;

procedure TfmMigTool.Step2;
begin
   if (rbBDE.Checked) and (cbAlias.Text ='') then
      raise Exception.Create('Dönüþtürmek istediðiniz veri tabanýný seçiniz');
   if (rbStd.Checked) and (dirDB.Text = '') then
      raise Exception.Create('Dönüþtürmek istediðiniz veri tabanýn bulunduðu dizini seçiniz');
   if (rbXML.Checked) and (dirDB.Text = '') then
      raise Exception.Create('Dönüþtürmek istediðiniz XML dosyalarýnýn bulunduðu dizini seçiniz');
   if (rbADO.Checked) and (not ADOConn.Connected) then
      raise Exception.Create('Dönüþtürmek istediðiniz veri tabaný için'+chr(13)+
                             'ADO Baðlantý dizinini oluþturunuz ve baðlantý saðlayýnýz');
   if (rbOracle.Checked) and (not OraSession.Connected) then
      raise Exception.Create('Dönüþtürmek istediðiniz Oracle veri tabanýna baðlanýnýz');
   if LvSelectedCount = 0 then
      raise Exception.Create('Dönüþtürmek istediðiniz tablolarý seçiniz');

   if cbAdvAlias.Items.Count < 1 then getAdvAlias;

   nbPages.PageIndex := 2;
   CurStep := 3;
end;

procedure TfmMigTool.Step3;
begin
   if not AdvDictionary.IsConnected then
     raise Exception.Create('Dönüþtüreceðiniz verileri ekleyeceðiniz'+chr(13)+
                            'Advantage Veri Tabanýný seçiniz ve baðlanýnýz');

   nbPages.PageIndex := 3;
   btnNext.Caption := 'Dönüþtür';
   CurStep := 4;
   if dirAdvTable.Text = '' then
    dirAdvTable.Text := GetTablePathFromDictionary(AdvDictionary);
end;

procedure TfmMigTool.Step4;
  var iTable: integer;
begin
   if ((rbMigAll.Checked) or (rbMigTable.Checked)) and
      (dirAdvTable.Text = '')  then
       raise Exception.Create('Advantage Tablolarýnýn yaratýlacaðý dizini seçiniz');

   btnPrev.Visible := False;
   btnNext.Caption := 'Durdur';

   nbPages.PageIndex := 4;
   CurStep := 5;

   pbAll.Max := LvSelectedCount;
   for iTable := 0 to LvTables.Items.Count - 1 do begin
     if LvTables.Items[iTable].SubItems[0] =SilType[true] then begin
       try
         Screen.Cursor := crAppStart;
         Application.ProcessMessages();
         if btnNext.Tag = 99 then Exit;
         if rbBDE.Checked then
           ImportBDEtable( cbAlias.Text, LvTables.Items[iTable].SubItems[1])
         else if rbStd.Checked then
           ImportBDEtable( 'GECXXX', LvTables.Items[iTable].SubItems[1])
         else if rbADO.Checked then
           ImportADOTable(LvTables.Items[iTable].SubItems[1])
         else if rbOracle.Checked then
           ImportOracleTable(LvTables.Items[iTable].SubItems[1])
         else if rbXML.Checked then
           ImportXMLTable(dirdb.Text+'\', LvTables.Items[iTable].SubItems[1]);


         pbAll.StepBy( 1 );
       finally
         Screen.Cursor := crDefault;
       end;
     end;
   end;

   BDETable.Close;
   ADOTable.Close;
   AdvTable.Close;
   OraQuery.Close;
   OraDataSet.Close;
   AdvDictionary.IsConnected := False;
   AdsConn.IsConnected := False;
   SessionBDE.Active := False;
   OraSession.Connected := False;

   btnnext.Visible := false;
   lblCustom.Caption := '';
   pbCustom.Visible := false;

   if btnNext.Tag = 99 then begin
     lblAck.Caption := 'Dönüþtürme iþlemi durduruldu.';
     AddInfo( 2,'Dönüþtürme iþlemi durduruldu.');
     MessageDlg('Dönüþtürme iþlemi durduruldu.', mtInformation,[mbOk],0);
   end else begin
     if ErrorCount = 0 then begin
       lblAck.Caption := 'Dönüþtürme iþlemi baþarýyla tamamlandý.';
       AddInfo( 2,'Dönüþtürme iþlemi baþarýyla tamamlandý.');
       MessageDlg('Dönüþtürme iþlemi baþarýyla tamamlandý.', mtInformation,[mbOk],0);
     end else begin
       lblAck.Caption := 'Dönüþtürme iþlemi hatalarla tamamlandý.';
       AddInfo( 2,'Dönüþtürme iþlemi hatalarla tamamlandý. Lütfen hatalarý kontrol ediniz.');
       MessageDlg('Dönüþtürme iþlemi hatalarla tamamlandý.'+chr(13)+'Lütfen hatalarý kontrol ediniz.', mtInformation,[mbOk],0);
     end;

     MessageDlg('Advantage Tablolarýnda sýralama anahtar indekse göre'+chr(13)+
                'deðil verilerin eklenme sýrasýna göredir.'+chr(13)+
                'Verilerinizi buna göre düzenlemeniz gerekebilir', mtInformation,[mbOk],0);
   end;

end;

procedure TfmMigTool.getAdvAlias;
var AliasList: TStringList;
    I: Integer;
    AliasInfo: TAdvAliasInfo;
begin
   cbAdvAlias.Clear;
   AliasList := TStringList.Create;
   AliasList.Sorted := True;
   try
     GetAliasList(AliasList);
     for I := 0 to AliasList.Count - 1 do
     begin
       AliasInfo := GetAliasProperties(AliasList[I]);
       if AliasInfo.TableType = ttDictionary then
         cbAdvAlias.Items.Add (AliasInfo.Name);
     end;
   finally
     AliasList.Free;
   end;
end;

procedure TfmMigTool.cbAliasChange(Sender: TObject);
begin
  if (cbAlias.ItemIndex <> -1) and (cbAlias.Text <>'') then begin
     getTablesBDE(cbAlias.Text);
  end;
end;

procedure TFmMigTool.getTablesBDE(dbAlias: string);
var DataBase: TDatabase;
    TableList : TStringList;
    i: integer;
begin
   LvTablesClear (nil);
   try
     DataBase := SessionBDE.OpenDatabase(dbAlias);
     TableList := TStringList.Create;
     try
       SessionBDE.GetTableNames(dbAlias,'',true,false,TableList);
       for i:=0 to TableList.Count - 1 do
          AddToListView(TableList[i])
     finally
       DataBase.Close;
       TableList.Free;
     end;
   except
     on EDBEngineError do raise Exception.Create('Girilen kullanýcý adý veya parolasý yanlýþ');
     on EStringListError do raise Exception.Create('Tablo adlarý alýnamadý.');
     on EDatabaseError do ;
   end;
   LvTables.SortColumn := 2;
   LvTables.Sort;
end;

procedure TfmMigTool.dirDBChange(Sender: TObject);
  var FileList: TStringList;
      i : integer;
begin
   if dirdb.Text = '' then exit;
   if rbStd.Checked then begin
     SessionBDE.ConfigMode := cmSession;
     SessionBDE.DeleteAlias('GECXXX');
     try
       SessionBDE.AddStandardAlias('GECXXX', dirDB.Text, '');
     finally
       SessionBDE.ConfigMode := cmAll;
     end;
     getTablesBDE('GECXXX');
   end else begin
     FileList := TStringList.Create;
     try
       FindFiles(dirdb.Text,'\*.xml',false,FileList);
       for i:= 0 to FileList.Count - 1 do
         AddToListView(FileList[i])
     finally
       Filelist.Free;
     end;
   end;
end;

procedure TfmMigTool.FormCreate(Sender: TObject);
begin
  CurStep := 1;
  ErrorCount := 0;
  NewDBCreated := False;
  nbPages.PageIndex := 0;
end;

procedure TfmMigTool.btnPrevClick(Sender: TObject);
begin

  case CurStep of
   2: begin
        nbPages.PageIndex := 0;
      end;
   3: begin
        if rbBDE.Checked then
           nbOpenDB.PageIndex := 0
        else if rbStd.Checked then
           nbOpenDB.PageIndex := 1
        else if rbADO.Checked then
           nbOpenDB.PageIndex := 2
        else if rbOracle.Checked then
           nbOpenDB.PageIndex := 3;

        nbPages.PageIndex := 1;
      end;
   4: begin
        nbPages.PageIndex := 2;
        btnNext.Caption := 'Ýleri  >>';
      end;
  end;

  CurStep := CurStep - 1;
  if CurStep = 1 then
     btnPrev.Visible := False;

end;

procedure TfmMigTool.rbAliasClick(Sender: TObject);
begin
  edAdvPath.Visible := False;
  cbAdvAlias.Visible := True;
end;

procedure TfmMigTool.rbPathClick(Sender: TObject);
begin
   cbAdvAlias.Visible := False;
   edAdvPath.Visible := True;
end;

procedure TFmMigTool.AdvConn (IsAlias: Boolean; DBName: String);
var ServerTypes: TAdsServerTypes;
    user,pass:String;
    Compression: Integer;
begin
  AdvDictionary.IsConnected := False;
  AdvDictionary.AliasName := '';
  AdvDictionary.ConnectPath := '';

  if IsAlias then
     AdvDictionary.AliasName := DBName
  else
     AdvDictionary.ConnectPath := DBName;

  begin
    user:='AdsSys';
    if not ExecuteConnectionForm(ServerTypes,DBName,user,pass, Compression) then begin
       edAdvPath.Text :='';
       SysUtils.Abort;
    end;
    AdvDictionary.AdsServerTypes := ServerTypes;
    AdvDictionary.UserName := user;
    AdvDictionary.Password:=pass;
    AdvDictionary.LoginPrompt := false;
    AdvDictionary.Tag := Compression;
    AdvDictionary.Compression := TAdsCompressionTypes(Compression);
    Screen.Cursor := crHourGlass;
    try
      AdvDictionary.IsConnected := True;
    finally
      Screen.Cursor := crDefault;
      if not AdvDictionary.IsConnected then
        edAdvPath.Text :='';
    end;
  end;
end;

procedure TfmMigTool.edAdvPathChange(Sender: TObject);
begin
  if edAdvPath.Text <>'' then
    AdvConn(False, edAdvPath.Text);
end;

procedure TfmMigTool.cbAdvAliasChange(Sender: TObject);
begin
   AdvConn(True, cbAdvAlias.Text);
end;

procedure TfmMigTool.btnNewDBClick(Sender: TObject);
  var Res:Boolean;
begin
  with TFmDatabase.Create(nil) do
  try
    Dictionary := nil;
    Mode := emNew;
    Res := New();
  finally
    Free;
  end;

  if res then begin
    getAdvAlias;
    NewDBCreated := True;
  end;

end;

function TFmMigTool.CheckLastAdsError: Boolean;
var
  ErrorCode : UNSIGNED32;
  ErrBuff : array[ 0..ADS_MAX_ERROR_LEN ] of char;
  Len: UNSIGNED16;
begin
  ACE.AdsGetLastError(@ErrorCode, @ErrBuff, @Len);
  Result := (ErrorCode = AE_SUCCESS) or (ErrorCode = AE_PROPERTY_NOT_SET);
end;

procedure TfmMigTool.btnOraConnClick(Sender: TObject);
begin
  OraSession.Connected := False;
  OraLogon.Execute;
  LvTablesClear (nil);
  if OraSession.Connected then begin
     OraQuery.Close;
     OraQuery.SQL.Clear;
     OraQuery.SQL.Add('Select table_name from user_tables');
     OraQuery.Execute;
     while not OraQuery.Eof do begin
       AddToListView(OraQuery.Field(0));
       OraQuery.Next;
     end;
     OraQuery.Close;
  end;
  LvTables.SortColumn := 2;
  LvTables.Sort;
end;

procedure TfmMigTool.edADOConnButtonClick(Sender: TObject);
begin
  edADOConn.Text := PromptDataSource( handle, '' );
end;

procedure TfmMigTool.edADOConnChange(Sender: TObject);
var TableList : TStringList;
    i: integer;
begin
  if edADOConn.Text = '' then exit;
  ADOConn.Connected := False;
  ADOConn.ConnectionString := edADOConn.Text;
  LvTablesClear (nil);
  TableList := TStringList.Create;
  try
    if ADOConn.ConnectionString <> '' then
      Screen.Cursor := crHourGlass;
      ADOConn.Connected := true;
      Screen.Cursor := crDefault;
    try
      ADOConn.GetTableNames (TableList,False);
      for i:= 0 to TableList.Count - 1 do
        AddToListView(TableList[i]);
    except
      raise EStringListError.Create ('Tablo adlarý alýnamadý.');
    end;
  except
    on E: Exception do
    begin
      TableList.Free;
      if (E is EStringListError) then raise
      else
             raise Exception.Create ('Oluþturduðunuz ADO baðlantý dizini ile baðlantý saðlanamadý.'+
                             chr(13)+ e.Message + chr(13)+
                             'ADO Baðlantý dizinini yeniden oluþturunuz');

    end;
  end;
  TableList.Free;
  LvTables.SortColumn := 2;
  LvTables.Sort;
end;


// ------- convert procedures ------- //

procedure TFmMigTool.ImportBDETable( strDatabaseName, strTableName: string );
var
   i,
   iPrecision,
   iScale,
   iFieldNum,
   iIndexDef: integer;

   strFieldType,
   strFieldName,
   strFieldSize,
   strDecimals,
   strFieldDefs: string;

   setIndexOptions: TAdsIndexOptions;

   strExpr,
   strIndexName,
   strIndexFile,
   strNewTable,
   strAutoIncField: string;

   oIndexFieldsList: TStrings;

   i64NextAutoIncValue: Int64;
   hTable: ADSHANDLE;
begin
   BDETable.Close();
   BDETable.IndexName := '';
   BDETable.DatabaseName := strDatabaseName;
   BDETable.TableName := strTableName;
   BDETable.TableType := ttDefault;

   try
      BDETable.Active := true;
   except
      On E: Exception do
      begin
        AddInfo (0, strTableName + ' tablosu açýlamadý');
        Exit;
      end;
   end;

   ConvertDictToConn(AdvDictionary, AdsConn);
   AdsConn.IsConnected := True;

   strAutoIncField := '';

// ------------- yapýyý aktar --------------------- //

   if (rbMigAll.Checked) or (rbMigTable.Checked) then begin

     lblCustom.Caption  := strTableName + ' tablosu yaratýlýyor...';
     for iFieldNum := 0 to BDETable.FieldCount - 1 do
     begin
       Application.ProcessMessages();

       strDecimals := '';
       strFieldSize := '';

       Case BDETable.Fields[ iFieldNum ].DataType of
         ftUnknown      : raise Exception.Create( 'Unknown Data Type Encountered' );
         ftString : strFieldType := 'CHARACTER';
         ftSmallint  : strFieldType := 'SHORTINT';
         ftInteger   : strFieldType := 'INTEGER';
         ftWord   : strFieldType := 'INTEGER';
         ftBoolean   : strFieldType := 'LOGICAL';
         ftFloat     :  strFieldType := 'DOUBLE';
         ftCurrency  :  strFieldType := 'CURDOUBLE';
         ftBCD       :  begin
                           strFieldType := 'DOUBLE';
                           GetFieldDecimals( BDETable,
                                             iFieldNum,
                                             iPrecision,
                                             iScale );

                           strDecimals := IntToStr( iScale );
                        end;
         ftDate      : strFieldType := 'DATE';
         ftTime      : strFieldType := 'TIME';
         ftDateTime     : strFieldType := 'TIMESTAMP';
         ftBytes        : strFieldType := 'RAW';
         ftVarBytes  : strFieldType := 'BINARY';
         ftAutoInc      : begin
                             strFieldType := 'INTEGER';
                             if( strAutoIncField = '' ) then
                                strAutoIncField := BDETable.Fields[ iFieldNum ].FieldName;
                          end;
         ftBlob         : strFieldType := 'BINARY';
         ftMemo         : strFieldType := 'MEMO';
         ftGraphic      : strFieldType := 'IMAGE';
         ftFmtMemo      : strFieldType := 'MEMO';
         ftParadoxOle   : strFieldType := 'BINARY';
         ftDBaseOle     : strFieldType := 'BINARY';
         ftTypedBinary  : strFieldType := 'BINARY';
       end;//case

       if( strFieldSize = '' ) then
         strFieldSize   := IntToStr( BDETable.Fields[ iFieldNum ].Size );

       strFieldName := BDETable.Fields[ iFieldNum ].FieldName;

       strFieldDefs := strFieldDefs + strFieldName + ',' +
                       strFieldType + ',' +
                       strFieldSize + ',' +
                       strDecimals + ';';

     end;//for

     if dirAdvTable.Text[length(dirAdvTable.Text)]='\' then
       strNewTable := dirAdvTable.Text + ChangeFileExt( BDETable.TableName, '.ADT' )
     else
       strNewTable := dirAdvTable.Text +'\'+ ChangeFileExt( BDETable.TableName, '.ADT' );
       
     try
       ACECheck( nil, ACE.AdsCreateTable(AdsConn.Handle,
                                         pChar(strNewTable),
                                         '',
                                         ADS_ADT,
                                         ADS_ANSI,
                                         ADS_PROPRIETARY_LOCKING,
                                         ADS_IGNORERIGHTS,
                                         512,
                                         PChar( strFieldDefs ),
                                         @hTable));
       ACE.AdsCloseTable( hTable );
       AddInfo(1, strTableName + ' tablosu yaratýldý.')
     except
       ON E : EAdsDatabaseError do
       begin
         if not CheckLastAdsError then begin
           ACE.AdsCloseTable( hTable );
           AddInfo(0, strTableName + ' tablosu yaratýlamadý.');
           raise;
         end;
       end;
     end;

     strIndexFile := ChangeFileExt( dirAdvTable.Text +'\'+ BDETable.TableName, '.adi');
     if(FileExists( strIndexFile ))then
        DeleteFile( strIndexFile );

   end;

// ------------- veriyi aktar --------------------- //

   if (rbMigAll.Checked) or (rbMigData.Checked) then begin

      if btnNext.Tag = 99 then Exit;
      lblCustom.Caption := strTableName + ' tablosunun verileri dönüþtürülüyor...';
      AdvTable.Active := False;

      AdvTable.TableName := ChangeFileExt( BDETable.TableName, '.ADT' );
      try
        AdvTable.Active := true;
      except
        if rbMigData.Checked then
          AddInfo(0, strTableName + ' tablosu mevcut deðil')
        else AddInfo(0, strTableName + ' tablosu açýlamadý. Veri Aktarýlmadý.');
        exit;
      end;

      BDETable.First();

      pbCustom.Position := 0;
      Application.ProcessMessages();
      pbCustom.Max := BDETable.RecordCount;

      while not BDETable.EOF do
      begin
        Application.ProcessMessages();
        if btnNext.Tag = 99 then Exit;
        pbCustom.StepBy( 1 );
        AdvTable.Append();

        if( strAutoIncField <> '' ) then
        begin
          if( i64NextAutoIncValue < BDETable.FieldByName( strAutoIncField ).AsInteger ) then
             i64NextAutoIncValue := BDETable.FieldByName( strAutoIncField ).AsInteger;
        end;

        for iFieldNum := 0 to BDETable.FieldCount - 1 do
        begin
          try
            begin
               AdvTable.Fields[ iFieldNum ].Value := BDETable.Fields[ iFieldNum ].Value;
            end;
          except
             On E: Exception do
             begin
               AddInfo(0, 'Veri Yüklenemedi.');
               Application.ProcessMessages();
             end;
          end;//try
        end;
        AdvTable.Post();
        BDETable.Next();
      end;
      AddInfo (1, strTableName + ' tablosunun verileri dönüþtürüldü.');
   end;

// ------------- index olustur --------------------- //

   if (chkIndex.Checked) then begin

     if btnNext.Tag = 99 then Exit;
     BDETable.IndexDefs.Update();

     AdvTable.Close;
     AdvTable.TableName := ChangeFileExt( BDETable.TableName, '.ADT' );
     try
       AdvTable.Open;
     except
       AddInfo(0, strTableName + ' tablosu açýlamadý. Ýndexler yaratýlmadý.');
       exit;
     end;

     pbCustom.Position := 0;
     pbCustom.Max := BDETable.IndexDefs.Count;

     if BDETable.IndexDefs.Count> 0 then begin
       lblCustom.Caption := strTableName + ' tablosunun indeksleri yaratýlýyor...';

       for iIndexDef := 0 to BDETable.IndexDefs.Count - 1 do
       begin
         pbCustom.StepBy( 1 );
         Application.ProcessMessages();
         if btnNext.Tag = 99 then Exit;

         setIndexOptions := [ optCOMPOUND ];

         oIndexFieldsList := TStringList.Create();
         StrToList( ';', BDETable.IndexDefs[ iIndexDef ].Fields, oIndexFieldsList );

         if (ixUnique in BDETable.IndexDefs[ iIndexDef ].Options) then
            setIndexOptions := setIndexOptions + [ optUNIQUE ];

         if (ixDescending in BDETable.IndexDefs[ iIndexDef ].Options) then
            setIndexOptions := setIndexOptions + [ optDescending ];

         if (ixCaseInsensitive in BDETable.IndexDefs[ iIndexDef ].Options) then
         begin

           for i := 0 to oIndexFieldsList.Count - 1 do
           begin
              iFieldNum := AdvTable.FieldList.IndexOf( oIndexFieldsList.Strings[ i ] );
              if( iFieldNum <> -1 ) and
                ( AdvTable.Fields[ iFieldNum ].DataType = ftString ) then
                 oIndexFieldsList.Strings[ i ] := 'UPPER(' + oIndexFieldsList.Strings[ i ] + ')';
           end;
         end;

         if(  ixExpression in BDETable.IndexDefs[ iIndexDef ].Options ) then
            strExpr := BDETable.IndexDefs[ iIndexDef ].Expression
         else
            strExpr := ListToStr( ';', oIndexFieldsList );

          oIndexFieldsList.Free();

          strIndexName := BDETable.IndexDefs[ iIndexDef ].Name;

          //use the name PRIMARY for primary indexes ( they have no name )
          if (strIndexName = '') then
             strIndexName := 'PRIMARY';

          //validate the index definition with ACE
          if( not AdvTable.AdsIsExprValid( strExpr ) ) then
            AddInfo (0, strIndexName + ' indeksinin açýklamasý geçersiz.')
          else
          try
            AdvTable.AdsCreateIndex( '', strIndexName, strExpr, '', '', setIndexOptions );
            if ixPrimary in BDETable.IndexDefs[iIndexDef].Options then
               try
                 AdvDictionary.SetTableProperty( ChangeFileExt( BDETable.TableName, '.ADT' ),
                                 ADS_DD_TABLE_PRIMARY_KEY,
                                 pChar(strIndexName),
                                 length(strIndexName) + 1,
                                 ADS_NO_VALIDATE,
                                 '');
               except
                 AddInfo(0, strIndexName + ' indeksi anahtar indeks yapýlamadý.');
               end;
          except
            On E: Exception do
            begin
              AddInfo(0, strIndexName + ' indeksi yaratýlamadý.');
              Application.ProcessMessages();
            end;
          end;//try
       end;//for i := 0 to IndexDefs.Count - 1 do
       AddInfo (1, strTableName + ' tablosunun indexleri oluþturuldu.');
     end else
       AddInfo(2, strTableName + ' tablosunda indeks mevcut deðildir.');
   end;

// ----------------- auto incremet alan varsa -------------------//
   if btnNext.Tag = 99 then Exit;
   if (strAutoIncField <> '') then
   try
      AdvTable.Close();
      ConvertIntToAutoInc ( strNewTable, strAutoIncField, i64NextAutoIncValue + 1 );
      AddInfo (1, strAutoIncField + ' alaný AutoInc olarak düzenlendi.');
   except
      On E: Exception do
      AddInfo (0, strAutoIncField + ' alaný AutoInc olarak düzenlenemedi.');
   end;

end;

procedure TFmMigTool.ImportXMLTable(strPath: string; strFileName: string );
var
   i,
   iPrecision,
   iScale,
   iFieldNum,
   iIndexDef: integer;

   strFieldType,
   strFieldName,
   strFieldSize,
   strDecimals,
   strFieldDefs: string;

   setIndexOptions: TAdsIndexOptions;

   strExpr,
   strIndexName,
   strIndexFile,
   strNewTable,
   strTableName,
   strAutoIncField: string;

   oIndexFieldsList: TStrings;

   i64NextAutoIncValue: Int64;
   hTable: ADSHANDLE;
begin
   csXML.Close();
   csXML.FileName := strPath + strFileName;

   strTableName := ChangeFileExt( strFileName, '');
     if dirAdvTable.Text[length(dirAdvTable.Text)]='\' then
        strNewTable := dirAdvTable.Text + ChangeFileExt( strFileName, '.ADT' )
     else
       strNewTable := dirAdvTable.Text +'\'+ ChangeFileExt( strFileName, '.ADT' );

   try
      csXML.Active := true;
   except
      On E: Exception do
      begin
        AddInfo (0, strPath + strFileName + ' dosyasý açýlamadý'+ chr(13)+ e.Message);
        Exit;
      end;
   end;

   ConvertDictToConn(AdvDictionary, AdsConn);
   AdsConn.IsConnected := True;

   strAutoIncField := '';

// ------------- yapýyý aktar --------------------- //

   if (rbMigAll.Checked) or (rbMigTable.Checked) then begin

     lblCustom.Caption  := 'Tablo yaratýlýyor...';
     for iFieldNum := 0 to csXML.FieldCount - 1 do
     begin
       Application.ProcessMessages();

       strDecimals := '';
       strFieldSize := '';

       Case csXML.FieldDefs[ iFieldNum ].DataType of
         ftUnknown      : raise Exception.Create( 'Unknown Data Type Encountered' );
         ftString       : strFieldType := 'CHARACTER';
         ftSmallint     : strFieldType := 'SHORTINT';
         ftInteger      : strFieldType := 'INTEGER';
         ftWord         : strFieldType := 'INTEGER';
         ftBoolean      : strFieldType := 'LOGICAL';
         ftFloat        :  strFieldType := 'DOUBLE';
         ftCurrency     :  strFieldType := 'CURDOUBLE';
         ftBCD          :  begin
                             strFieldType := 'DOUBLE';
                             GetFieldDecimals( TTable(csXML),
                                               iFieldNum,
                                               iPrecision,
                                               iScale );

                             strDecimals := IntToStr( iScale );
                           end;
         ftDate         : strFieldType := 'DATE';
         ftTime         : strFieldType := 'TIME';
         ftDateTime     : strFieldType := 'TIMESTAMP';
         ftBytes        : strFieldType := 'RAW';
         ftVarBytes     : strFieldType := 'BINARY';
         ftAutoInc      : begin
                             strFieldType := 'INTEGER';
                             if( strAutoIncField = '' ) then
                                strAutoIncField := csXML.Fields[ iFieldNum ].FieldName;
                          end;
         ftBlob         : strFieldType := 'BINARY';
         ftMemo         : strFieldType := 'MEMO';
         ftGraphic      : strFieldType := 'IMAGE';
         ftFmtMemo      : strFieldType := 'MEMO';
         ftParadoxOle   : strFieldType := 'BINARY';
         ftDBaseOle     : strFieldType := 'BINARY';
         ftTypedBinary  : strFieldType := 'BINARY';
       end;//case

       if( strFieldSize = '' ) then
         strFieldSize   := IntToStr( csXML.Fields[ iFieldNum ].Size );

       strFieldName := csXML.Fields[ iFieldNum ].FieldName;

       strFieldDefs := strFieldDefs + strFieldName + ',' +
                       strFieldType + ',' +
                       strFieldSize + ',' +
                       strDecimals + ';';

     end;//for

     try
       ACECheck( nil, ACE.AdsCreateTable(AdsConn.Handle,
                                         pChar(strNewTable),
                                         '',
                                         ADS_ADT,
                                         ADS_ANSI,
                                         ADS_PROPRIETARY_LOCKING,
                                         ADS_IGNORERIGHTS,
                                         512,
                                         PChar( strFieldDefs ),
                                         @hTable));
       ACE.AdsCloseTable( hTable );
       AddInfo(1, strTableName + ' tablosu yaratýldý.')
     except
       ON E : EAdsDatabaseError do
       begin
         if not CheckLastAdsError then begin
           ACE.AdsCloseTable( hTable );
           AddInfo(0, strTableName + ' tablosu yaratýlamadý.');
           raise;
         end;
       end;
     end;
   end;
// ------------- veriyi aktar --------------------- //

   if (rbMigAll.Checked) or (rbMigData.Checked) then begin

      if btnNext.Tag = 99 then Exit;
      lblCustom.Caption := strTableName + ' tablosunun verileri dönüþtürülüyor...';
      AdvTable.Active := False;

      AdvTable.TableName := ChangeFileExt( strFileName, '.ADT' );
      try
        AdvTable.Active := true;
      except
        if rbMigData.Checked then
          AddInfo(0, strtablename + ' tablosu mevcut deðil')
        else AddInfo(0, strTablename + ' tablosu açýlamadý. Veri Aktarýlmadý.');
        exit;
      end;

      csXML.First();

      pbCustom.Position := 0;
      Application.ProcessMessages();
      pbCustom.Max := csXML.RecordCount;

      while not csXML.EOF do
      begin
        Application.ProcessMessages();
        if btnNext.Tag = 99 then Exit;
        pbCustom.StepBy( 1 );
        AdvTable.Append();

        if( strAutoIncField <> '' ) then
        begin
          if( i64NextAutoIncValue < csXML.FieldByName( strAutoIncField ).AsInteger ) then
             i64NextAutoIncValue := csXML.FieldByName( strAutoIncField ).AsInteger;
        end;

        for iFieldNum := 0 to csXML.FieldCount - 1 do
        begin
          try
            begin
               AdvTable.Fields[ iFieldNum ].Value := csXML.Fields[ iFieldNum ].Value;
            end;
          except
             On E: Exception do
             begin
               AddInfo(0, strTableName + ' tablosunun verileri yüklenemedi.');
               Application.ProcessMessages();
             end;
          end;//try
        end;
        AdvTable.Post();
        csXML.Next();
      end;
      AddInfo (1, strTableName + ' tablosunun verileri dönüþtürüldü.');
   end;
// ----------------- auto incremet alan varsa -------------------//
{
   if btnNext.Tag = 99 then Exit;
   if (strAutoIncField <> '') then
   try
      AdvTable.Close();
      ConvertIntToAutoInc ( strNewTable, strAutoIncField, i64NextAutoIncValue + 1 );
   except
      On E: Exception do
      raise Exception.Create('AUTOINC tipindeki ' + strAutoIncField +
                             ' alaný düzenlenirken hata oluþtu.');
   end;
}
end;

procedure TFmMigTool.AddInfo (ImgIndex :Integer; Info:String);
  var ListItem :TListItem;
begin
  ListItem := lvStatus.Items.Add;
  ListItem.Caption := Info;
  lvStatus.Items.Item[lvStatus.Items.Count-1].ImageIndex := ImgIndex;
  if ImgIndex = 0 then
    ErrorCount := ErrorCount + 1;
end;

procedure TFmMigTool.GetFieldDecimals( oTable: TTable; iFieldNum: integer;
                            var iPrecision, iScale: integer );
var
   pCursorProp: CURProps;
   pFieldDesc, pCurrentField: pFLDDesc;
   i: integer;
   iMemSize: integer;
begin
   Check( DbiGetCursorProps( oTable.Handle, pCursorProp ) );

   // Get enough memory for one field desc times the # of fields
   iMemSize := pCursorProp.iFields * SizeOf( FLDDesc );
   pFieldDesc := AllocMem( iMemSize );
   try
      pCurrentField := pFieldDesc;

      Check( DbiGetFieldDescs( oTable.Handle, pFieldDesc ) );

      for i := 1 to iFieldNum do
      begin
         // increment pointer to the next record
         inc( pCurrentField );
      end;

      iPrecision := pCurrentField^.iUnits1;
      iScale := pCurrentField^.iUnits2;
   finally
      FreeMem( pFieldDesc );
   end;
end;

procedure TfmMigTool.ConvertIntToAutoInc( strFileName,
                               strField: string;
                               i64NextAutoIncValue: Int64 );

var
   ADTFile: TFileStream;
   wColType,
   wColCount: word;
   iColNum : integer;
   btOption: byte;
   aucColName: array [ 0..128 ] of char;
   bColFound: boolean;

begin
   ADTFile := nil;

   try
      //open file exclusively
      ADTFile := TFileStream.Create( strFileName,
                                     fmOpenReadWrite or fmShareExclusive );



      //Seek to last auto inc value position.
      ADTFile.Seek( 80, soFromBeginning );

      //write the next auto inc value
      ADTFile.Write(  i64NextAutoIncValue, SizeOf( i64NextAutoIncValue ) );


      //read the existing option
      ADTFile.Seek( 88, soFromBeginning );
      ADTFile.Read( btOption, SizeOf( btOption ) );

      //write the AI option
      ADTFile.Seek( 88, soFromBeginning );
      if( btOption = 0 ) or
        ( btOption = 1 ) or
        ( btOption = 4) or
        ( btOption = 5 ) then
      begin
         btOption := btOption + 2;
         ADTFile.Write(  btOption, SizeOf( btOption ) );
      end;

      //read in the number of columns
      ADTFile.Seek( 358, soFromBeginning );
      ADTFile.Read( wColCount, SizeOf( wColCount ) );


      //find the field and change the type to auto inc.
      bColFound := false;
      for iColNum := 0 to wColCount - 1 do
      begin
         ADTFile.Seek( 400 + ( iColNum * 200 ), soFromBeginning );
         ADTFile.Read( aucColName, 129 );
         if( UpperCase( aucColName ) = UpperCase( strField ) ) then
         begin

            //found the field, now change type to autoinc
            ADTFile.Read( wColType, SizeOf( wColType ) );
            if( wColType <> $B ) then
               raise Exception.Create( 'Alan: ' + strField + ' integer deðil.' )

            else
            begin
               ADTFile.Seek( -2, soFromCurrent );
               wColType := $F;
               ADTFile.Write( wColType, SizeOf( wColType ) );
               bColFound := true;
               break;
            end;
         end;
      end;

      if( not bColFound ) then
         raise Exception.Create( 'Alan: ' + strField + ' bulunamadý' );

   finally
      ADTFile.Free();
   end;

end;

procedure TFmMigTool.ImportADOTable( strTable : string );
var
   i,
   iFieldNum,
   iIndexDef,
   iScale              : integer;

   strAutoIncField,
   strDecimals,
   strExpr,
   strFieldDefs,
   strFieldName,
   strFieldSize,
   strFieldType,
   strIndexFile,
   strIndexName,
   strNewTable         : string;
   setIndexOptions     : TAdsIndexOptions;
   tsIndexFieldsList   : TStrings;
   i64NextAutoIncValue : Int64;
   oIndexFieldsList    : TStringList;
   hTable: ADSHANDLE;
begin

   ADOTable.TableName := strTable;
   try
      ADOTable.Active := true;;
   except
      on E : Exception do
      begin
        AddInfo (0, strTable + ' tablosu açýlamadý');
        Exit;
      end;
   end;

   ConvertDictToConn(AdvDictionary, AdsConn);
   AdsConn.IsConnected := True;

   strAutoIncField := '';

// ------------- yapýyý aktar --------------------- //

   if (rbMigAll.Checked) or (rbMigTable.Checked) then begin

     lblCustom.Caption  := strTable + ' tablosu yaratýlýyor...';
     for iFieldNum := 0 to ADOTable.FieldCount - 1 do
     begin
       Application.ProcessMessages();

       strDecimals := '';
       strFieldSize := '';

       case ADOTable.Fields[ iFieldNum ].DataType of
         ftUnknown     : raise Exception.Create( 'Unknown Data Type Encountered' );
         ftString      : strFieldType := 'CHARACTER';
         ftSmallint    : strFieldType := 'SHORTINT';
         ftInteger     : strFieldType := 'INTEGER';
         ftWord        : strFieldType := 'INTEGER';
         ftBoolean     : strFieldType := 'LOGICAL';
         ftFloat       : strFieldType := 'DOUBLE';
         ftCurrency    : strFieldType := 'CURDOUBLE';
         ftBCD         : begin
                            strFieldType := 'DOUBLE';
                            iScale := ADOTable.FieldDefs.Items[ iFieldNum ].Size;
                            strDecimals := IntToStr( iScale );
                         end;
         ftDate        : strFieldType := 'DATE';
         ftTime        : strFieldType := 'TIME';
         ftDateTime    : strFieldType := 'TIMESTAMP';
         ftBytes       : strFieldType := 'RAW';
         ftVarBytes    : strFieldType := 'BINARY';
         ftAutoInc     : begin
                            strFieldType := 'INTEGER';
                            if( strAutoIncField = '' ) then
                               strAutoIncField := ADOTable.Fields[ iFieldNum ].FieldName;
                         end;
         ftBlob        : strFieldType := 'BINARY';
         ftMemo        : strFieldType := 'MEMO';
         ftGraphic     : strFieldType := 'IMAGE';
         ftFmtMemo     : strFieldType := 'MEMO';
         ftParadoxOle  : strFieldType := 'BINARY';
         ftDBaseOle    : strFieldType := 'BINARY';
         ftTypedBinary : strFieldType := 'BINARY';
         ftWideString  : strFieldType := 'CHARACTER';

       end;//case

       if strFieldSize = '' then
         strFieldSize := IntToStr( ADOTable.Fields[ iFieldNum ].Size );

       strFieldName := ADOTable.Fields[ iFieldNum ].FieldName;

       strFieldDefs := strFieldDefs + strFieldName + ',' +
                       strFieldType + ',' +
                       strFieldSize + ',' +
                       strDecimals + ';';
     end;//for

     if dirAdvTable.Text[length(dirAdvTable.Text)]='\' then
       strNewTable := dirAdvTable.Text + ChangeFileExt( ADOTable.TableName, '.ADT' )
     else
       strNewTable := dirAdvTable.Text +'\'+ ChangeFileExt( ADOTable.TableName, '.ADT' );

     try
       ACECheck( nil, ACE.AdsCreateTable(AdsConn.Handle,
                                         pChar(strNewTable),
                                         '',
                                         ADS_ADT,
                                         ADS_ANSI,
                                         ADS_PROPRIETARY_LOCKING,
                                         ADS_IGNORERIGHTS,
                                         512,
                                         PChar( strFieldDefs ),
                                         @hTable));
       ACE.AdsCloseTable( hTable );
       AddInfo(1, strTable + ' tablosu yaratýldý.')
     except
       ON E : EAdsDatabaseError do
       begin
         if not CheckLastAdsError then begin
           ACE.AdsCloseTable( hTable );
           AddInfo(0, strTable + ' tablosu yaratýlamadý.');
           raise;
         end;
       end;
     end;

     strIndexFile := ChangeFileExt( dirAdvTable.Text +'\'+ ADOTable.TableName, '.adi');

     if FileExists( strIndexFile ) then
        DeleteFile( strIndexFile );

   end;

   // ------------- veriyi aktar --------------------- //

   if (rbMigAll.Checked) or (rbMigData.Checked) then begin

      if btnNext.Tag = 99 then Exit;
      lblCustom.Caption := strTable + ' tablosunun verileri dönüþtürülüyor...';

      AdvTable.Active := False;

      AdvTable.TableName := ChangeFileExt( ADOTable.TableName, '.ADT' );
      try
        AdvTable.Active := true;
      except
        if rbMigData.Checked then
          AddInfo(0, strTable + ' tablosu mevcut deðil')
        else AddInfo(0, strTable + ' tablosu açýlamadý. Veri Aktarýlmadý.');
        exit;
      end;

      ADOTable.First;

      pbCustom.Position := 0;
      pbCustom.Max := ADOTable.RecordCount;

      while not ADOTable.EOF do
      begin
        Application.ProcessMessages;
        if btnNext.Tag = 99 then Exit;
        AdvTable.Append;
        pbCustom.StepBy (1);
        if strAutoIncField <> '' then
        begin
           if( i64NextAutoIncValue < ADOTable.FieldByName( strAutoIncField ).AsInteger ) then
              i64NextAutoIncValue := ADOTable.FieldByName( strAutoIncField ).AsInteger;
        end;

        for iFieldNum := 0 to ADOTable.FieldCount - 1 do
        begin
          try
            AdvTable.Fields[ iFieldNum ].Value := ADOTable.Fields[ iFieldNum ].Value;
          except
             On E: Exception do
             begin
               AddInfo(0, 'Veri Yüklenemedi.');
               Application.ProcessMessages();
             end;
          end;
        end;

        AdvTable.Post;
        ADOTable.Next
      end;//while not ADOTable.EOF
      AdvTable.Close;
      AddInfo (1, strTable + ' tablosunun verileri dönüþtürüldü.');
   end;

// ------------- index olustur --------------------- //

   if (chkIndex.Checked) then begin

     if btnNext.Tag = 99 then Exit;
     ADOTable.IndexDefs.Update();

     AdvTable.Close;
     AdvTable.TableName := ChangeFileExt( ADOTable.TableName, '.ADT' );
     try
       AdvTable.Open;
     except
       AddInfo(0, strTable + ' tablosu açýlamadý. Ýndexler yaratýlmadý.');
       exit;
     end;

     pbCustom.Position := 0;
     pbCustom.Max := ADOTable.IndexDefs.Count;

     if ADOTable.IndexDefs.Count> 0 then begin
       lblCustom.Caption := strTable + ' tablosunun indeksleri yaratýlýyor...';

       for iIndexDef := 0 to ADOTable.IndexDefs.Count - 1 do
       begin
         pbCustom.StepBy( 1 );
         Application.ProcessMessages();
         if btnNext.Tag = 99 then Exit;

         setIndexOptions := [ optCOMPOUND ];

         oIndexFieldsList := TStringList.Create();
         StrToList( ';', ADOTable.IndexDefs[ iIndexDef ].Fields, oIndexFieldsList );

         if (ixUnique in ADOTable.IndexDefs[ iIndexDef ].Options) then
            setIndexOptions := setIndexOptions + [ optUNIQUE ];

         if (ixDescending in ADOTable.IndexDefs[ iIndexDef ].Options) then
            setIndexOptions := setIndexOptions + [ optDescending ];

         if (ixCaseInsensitive in ADOTable.IndexDefs[ iIndexDef ].Options) then
         begin

           for i := 0 to oIndexFieldsList.Count - 1 do
           begin
              iFieldNum := AdvTable.FieldList.IndexOf( oIndexFieldsList.Strings[ i ] );
              if( iFieldNum <> -1 ) and
                ( AdvTable.Fields[ iFieldNum ].DataType = ftString ) then
                 oIndexFieldsList.Strings[ i ] := 'UPPER(' + oIndexFieldsList.Strings[ i ] + ')';
           end;
         end;

         //for dbase tables there could be an expression, if so use the expression.
         if(  ixExpression in ADOTable.IndexDefs[ iIndexDef ].Options ) then
            strExpr := ADOTable.IndexDefs[ iIndexDef ].Expression
         else
            //get index expression by converting def list back to a string.
            strExpr := ListToStr( ';', oIndexFieldsList );

          oIndexFieldsList.Free();

          strIndexName := ADOTable.IndexDefs[ iIndexDef ].Name;

          //use the name PRIMARY for primary indexes ( they have no name )
          if (strIndexName = '') then
             strIndexName := 'PRIMARY';

          //validate the index definition with ACE
          if( not AdvTable.AdsIsExprValid( strExpr ) ) then
            AddInfo (0, strIndexName + ' indeksinin açýklamasý geçersiz.')
           else
          try
            AdvTable.AdsCreateIndex( '', strIndexName, strExpr, '', '', setIndexOptions );
            if ixPrimary in ADOTable.IndexDefs[iIndexDef].Options then
               try
                 AdvDictionary.SetTableProperty( ChangeFileExt( ADOTable.TableName, '.ADT'),
                                 ADS_DD_TABLE_PRIMARY_KEY,
                                 pChar(strIndexName),
                                 length(strIndexName) + 1,
                                 ADS_NO_VALIDATE,
                                 '');
               except
                 AddInfo(0, strIndexName + ' indeksi anahtar indeks yapýlamadý.');
               end;
          except
            On E: Exception do
            begin
              AddInfo(0, strIndexName + ' indeksi yaratýlamadý.');
              Application.ProcessMessages();
            end;
          end;//try
       end;//for i := 0 to IndexDefs.Count - 1 do
       AddInfo (1, strTable + ' tablosunun indexleri oluþturuldu.');
     end else
       AddInfo(2, strTable + ' tablosunda indeks mevcut deðildir.');
   end;

   // ----------------- auto incremet alan varsa -------------------//
   if btnNext.Tag = 99 then Exit;

   if( strAutoIncField <> '' ) then
   try
      AdvTable.Close();
      ConvertIntToAutoInc( strNewTable,
                           strAutoIncField,
                           i64NextAutoIncValue + 1 );
      AddInfo (1, strAutoIncField + ' alaný AutoInc olarak düzenlendi.');
   except
      On E: Exception do
      AddInfo (0, strAutoIncField + ' alaný AutoInc olarak düzenlenemedi.');
   end;
   ADOTable.Close;

end;

procedure TFmMigTool.ImportOracleTable( strTable : string );
var
  strIndexName,
  strExpr,
  strFieldType,
  strFieldDef,
  strFieldDefs,
  strFieldName,
  strIndexFile :String;

  iIndexNum,
  iFieldNum : integer;
  setIndexOptions     : TAdsIndexOptions;
  hTable: ADSHANDLE;
  mScale, mPrecision : Integer;
begin

   ConvertDictToConn(AdvDictionary, AdsConn);
   AdsConn.IsConnected := True;

// ------------- yapýyý aktar --------------------- //

   if (rbMigAll.Checked) or (rbMigTable.Checked) then begin

     lblCustom.Caption  := strTable + ' tablosu yaratýlýyor...';
     OraQuery.Close;
     OraQuery.SQL.Clear;
     OraQuery.SQL.Add ('Select column_name,rtrim(data_type) data_type,data_length,');
     OraQuery.SQL.Add ('data_precision,data_scale from user_tab_columns ');
     OraQuery.SQL.Add ('where table_name = '''+ UpperCase(strTable)+''' order by column_id');
     try
       OraQuery.Execute;
     except
        AddInfo (0, strTable + ' tablosunun alan bilgileri alýnamadý');
        Exit;
     end;

     while not OraQuery.Eof do begin
       Application.ProcessMessages();
       strFieldType := OraQuery.Field('data_type');

       if (strFieldType ='VARCHAR2') or (strFieldType ='NVARCHAR2') or
          (strFieldType ='CHAR') or (strFieldType ='NCHAR') then
          strFieldDef := 'CHARACTER,' + IntToStr(OraQuery.Field('data_length'))
       else if (strFieldType ='LONG') or (strFieldType ='CLOB') or
               (strFieldType = 'NCLOB') then
          strFieldDef := 'MEMO'
       else if strFieldType = 'DATE' then
          strFieldType := 'TIMESTAMP'
       else if (strFieldType ='RAW') or (strFieldType ='LONG RAW') or
               (strFieldType ='BLOB') or (strFieldType ='BFILE') then
          strFieldDef := 'BINARY'
       else if strFieldType = 'NUMBER' then
       begin
         mScale := OraQuery.Field('data_scale');
         mPrecision := OraQuery.Field('data_precision');
         if mScale > 0 then begin
            strFieldDef := 'DOUBLE,8,' + IntToStr(OraQuery.Field('data_scale'));
         end else
           if mPrecision > 9 then
              strFieldDef := 'DOUBLE,8'
           else
              strFieldDef := 'INTEGER,4';
       end;

       strFieldDefs := strFieldDefs + OraQuery.Field('column_name') + ',' +
                       strFieldDef + ';';
       OraQuery.Next;
     end;
     OraQuery.Close;

     try
       ACECheck( nil, ACE.AdsCreateTable(AdsConn.Handle,
                                         pChar(dirAdvTable.Text +'\'+ strTable+ '.ADT'),
                                         '',
                                         ADS_ADT,
                                         ADS_ANSI,
                                         ADS_PROPRIETARY_LOCKING,
                                         ADS_IGNORERIGHTS,
                                         512,
                                         PChar( strFieldDefs ),
                                         @hTable));
       ACE.AdsCloseTable( hTable );
       AddInfo(1, strTable + ' tablosu yaratýldý.')
     except
       ON E : EAdsDatabaseError do
       begin
         if not CheckLastAdsError then begin
           ACE.AdsCloseTable( hTable );
           AddInfo(0, strTable + ' tablosu yaratýlamadý.');
           raise;
         end;
       end;
     end;

     strIndexFile := dirAdvTable.Text +'\'+ strTable + '.adi';

     if FileExists( strIndexFile ) then
        DeleteFile( strIndexFile );
   end;

   // ------------- veriyi aktar --------------------- //

   if (rbMigAll.Checked) or (rbMigData.Checked) then begin

      if btnNext.Tag = 99 then Exit;
      lblCustom.Caption := strTable + ' tablosunun verileri dönüþtürülüyor...';

      OraQuery.Close;
      OraQuery.SQL.Clear;
      OraQuery.SQL.Add ('Select count(*) from ' + strTable);
      pbCustom.Position := 0;
      try
        OraQuery.Execute;
        pbCustom.Max := OraQuery.Field(0);
      except
        pbCustom.Max := 0;
      end;

      OraQuery.Close;
      OraQuery.SQL.Clear;
      OraQuery.SQL.Add ('Select * from ' + strTable);
      try
        OraQuery.Execute;
      except
        AddInfo (0, strTable + ' tablosundan veriler alýnamadý');
        Exit;
      end;

      AdvTable.Active := False;

      AdvTable.TableName := strTable + '.ADT';
      try
        AdvTable.Active := true;
      except
        if rbMigData.Checked then
          AddInfo(0, strTable + ' tablosu mevcut deðil')
        else AddInfo(0, strTable + ' tablosu açýlamadý. Veri Aktarýlmadý.');
        exit;
      end;

      while not OraQuery.EOF do
      begin
        Application.ProcessMessages;
        if btnNext.Tag = 99 then Exit;
        AdvTable.Append;
        pbCustom.StepBy (1);
        for iFieldNum := 0 to OraQuery.FieldCount - 1  do
        begin
          try
            strFieldName := OraQuery.FieldName(iFieldNum);
            AdvTable.FieldByName(strFieldName).Value := OraQuery.Field(strFieldName);
          except
             On E: Exception do
             begin
               AddInfo(0, 'Veri Yüklenemedi.');
               Application.ProcessMessages();
             end;
          end;
        end;

        AdvTable.Post;
        OraQuery.Next
      end;//while not ADOTable.EOF
      OraQuery.Close;
      AdvTable.Close;
      AddInfo (1, strTable + ' tablosunun verileri dönüþtürüldü.');
   end;

// ------------- index olustur --------------------- //

   if (chkIndex.Checked) then begin

     if btnNext.Tag = 99 then Exit;
     AdvTable.Close;
     AdvTable.TableName := strTable + '.ADT';
     try
       AdvTable.Open;
     except
       AddInfo(0, strTable + ' tablosu açýlamadý. Ýndexler yaratýlmadý.');
       exit;
     end;

     OraDataSet.Close;
     OraDataSet.SQL.Clear;
     OraDataSet.SQL.Add ('Select index_name, UNIQUENESS from user_indexes');
     OraDataSet.SQL.Add ('where table_name = '''+ UpperCase(strTable)+'''');
     try
       OraDataSet.Open;
     except
        AddInfo (0, strTable + ' tablosunun indeks bilgileri alýnamadý');
        Exit;
     end;

     pbCustom.Position := 0;
     pbCustom.Max :=  OraDataSet.RecordCount;

     if OraDataSet.RecordCount > 0 then begin
       lblCustom.Caption := strTable + ' tablosunun indeksleri yaratýlýyor...';

       for iIndexNum := 0 to OraDataSet.RecordCount - 1 do
       begin
         pbCustom.StepBy( 1 );
         Application.ProcessMessages();
         if btnNext.Tag = 99 then Exit;

         setIndexOptions := [ optCOMPOUND ];

         if OraDataSet.FieldByName('UNIQUENESS').AsString = 'UNIQUE' then
            setIndexOptions := setIndexOptions + [ optUNIQUE ];

         OraQuery.Close;
         OraQuery.SQL.Clear;
         OraQuery.SQL.Add ('Select column_name from user_ind_columns');
         OraQuery.SQL.Add ('where index_name = '''+
                            UpperCase(OraDataSet.FieldByName('index_name').AsString)+'''');
         OraQuery.SQL.Add ('order by COLUMN_POSITION');

         try
           OraQuery.Execute;

           strExpr := '';
           while not OraQuery.Eof do
           begin
              strExpr := strExpr + OraQuery.Field(0)+';';
              OraQuery.Next;
           end;
           OraQuery.Close;
           strExpr := Copy(strExpr, 0, length(strExpr) - 1);
           strIndexName := OraDataSet.FieldByName('index_name').AsString;

           if( not AdvTable.AdsIsExprValid( strExpr ) ) then
             AddInfo (0, strIndexName + ' indeksinin açýklamasý geçersiz.')
           else
             try
               AdvTable.AdsCreateIndex( '', strIndexName, strExpr, '', '', setIndexOptions );
               OraQuery.SQL.Clear;
               OraQuery.SQL.Add ('Select constraint_name from user_constraints');
               OraQuery.SQL.Add ('where constraint_name = '''+
                            UpperCase(OraDataSet.FieldByName('index_name').AsString)+'''');
               OraQuery.SQL.Add ('and constraint_type=''P''');
               try
                 OraQuery.Execute;
                 if not OraQuery.Eof then
                   try
                     AdvDictionary.SetTableProperty( strTable,
                                    ADS_DD_TABLE_PRIMARY_KEY,
                                    pChar(strIndexName),
                                    length(strIndexName) + 1,
                                    ADS_NO_VALIDATE,'');
                   except
                     AddInfo(0, strIndexName + ' indeksi birincil index yapýlamadý.');
                   end;
               finally
                 OraQuery.Close;
               end;
             except
               On E: Exception do
               begin
                 AddInfo(0, strIndexName + ' indeksi yaratýlamadý.');
                 Application.ProcessMessages();
               end;
             end;//try
         except
           AddInfo(0, strIndexName + ' indeksinin alanlarý alýnamadý.');
         end;
         OraDataSet.Next;
       end;
       OraDataSet.Close;
       AddInfo (1, strTable + ' tablosunun indexleri oluþturuldu.');
     end else
       AddInfo(2, strTable + ' tablosunda indeks mevcut deðildir.');
   end;
end;

procedure TfmMigTool.BtSelectAllClick(Sender: TObject);
begin
  SelectListCheck(0,true,2);
end;

procedure TfmMigTool.BtDeselectAllClick(Sender: TObject);
begin
  SelectListCheck(0,false,1);
end;

procedure TfmMigTool.LvTablesClear(Sender: TObject);
begin
  LvTables.Clear;
  LvTables.Columns[1].Caption :='Dönüþtür';
  LvTables.Columns[2].Caption :='Tablo Adý';
end;

function TfmMigTool.LvSelectedCount : integer;
  var i : integer;
begin
   result := 0;
   for i := 0 to LvTables.Items.Count - 1 do
     if LvTables.Items[i].SubItems[0] =SilType[true] then
        result := result + 1;
end;

procedure TfmMigTool.btnHelpClick(Sender: TObject);
begin
  Application.HelpCommand (HELP_CONTEXT, 13);
end;

Procedure TfmMigTool.FindFiles(const Path, Mask: string; IncludeSubDir: boolean; Out List:TStringList);
var
  FindResult: integer;
  SearchRec : TSearchRec;
begin
  FindResult := FindFirst(Path + Mask, faAnyFile - faDirectory, SearchRec);
  while FindResult = 0 do
  begin
    { do whatever you'd like to do with the files found }
    List.Add(SearchRec.Name);
    FindResult := FindNext(SearchRec);
  end;
  { free memory }
  FindClose(SearchRec);
  if not IncludeSubDir then
    Exit;
  FindResult := FindFirst(Path + '*.*', faDirectory, SearchRec);
  while FindResult = 0 do
  begin
    if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
        FindFiles (Path + SearchRec.Name + '\', Mask, TRUE,List);
    FindResult := FindNext(SearchRec);
  end;
  { free memory }
  FindClose(SearchRec);
end;

end.

