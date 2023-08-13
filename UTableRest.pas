unit UTableRest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, XStringGrid,adscnnct,adsdictionary,adstable,UAdsTable,
  StdCtrls, ImgList, RzBorder, RzLabel, ExtCtrls, RzPanel, ComCtrls,
  AdvListV, Buttons,UAdvConst, RzSpnEdt, Spin,adsdata,ACE, RzStatus,
  UObjEdit;

type
  TFmTableRest = class(TFmDBObjectEditor)
    EdFieldName: TEdit;
    Label1: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    edStartValue: TEdit;
    EdLength: TEdit;
    edDecimal: TEdit;
    fieldType: TComboBox;
    Label2: TLabel;
    Label4: TLabel;
    Image1: TImage;
    LvTables: TAdvListView;
    btEkle: TButton;
    btdegistir: TButton;
    btSil: TButton;
    edTableName: TEdit;
    Label6: TLabel;
    Bevel2: TBevel;
    MoveUpBtn: TSpeedButton;
    MoveDownBtn: TSpeedButton;
    btnew: TButton;
    procedure LvTablesChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure fieldTypeChange(Sender: TObject);
    procedure btEkleClick(Sender: TObject);
    procedure btdegistirClick(Sender: TObject);
    procedure btSilClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MoveUpBtnClick(Sender: TObject);
    procedure MoveDownBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LvTablesCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure BtnOkClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnewClick(Sender: TObject);
    procedure LvTablesClick(Sender: TObject);

  private
    AdsTable:TDbAdsTable;
    AdsConnection:TAdsConnection;
    iNextPos:integer;
    lstAddFields : TStringList;
    lstRemoveFields :TStringList;
    lstChangeFields :TStringList;
    function ValidateCharDef: boolean;
    procedure ValidateDateDef;
    function ValidateDoubleDef: boolean;
    function ValidateFieldName: boolean;
    procedure ValidateIntegerDef;
    procedure ValidateLogicalDef;
    procedure ValidateMemoDef;
    function ValidateNumericDef: boolean;
    procedure MoveField(poListItem: TListItem; iPosition: integer;
                                  poPrevListItem : TListItem; iPrevPosition  : integer);
    procedure HandleDDRestructure;
    { Private declarations }
  public
    function Edit: Boolean; override;
    function getStartValue(fname:string):string;
    procedure init;
    procedure setDbParameters(conn :TAdsConnection;dict:TAdsDictionary;title:string);
    procedure writeCurrentRow;
    procedure InsertRow;
    procedure ChangeFieldDef;
    procedure DeleteField;
    function ValidateFieldDef:boolean;
    procedure OnDone; override;
    procedure DirtyChanged; override;
    procedure ModeChanged; override;
    procedure Validate; override;

  end;

var
  FmTableRest: TFmTableRest;

implementation

{$R *.dfm}
function TFmTableRest.Edit: Boolean;
begin
  AdsTable:=TDbAdsTable.Create(Dictionary,item);
  try
    AdsTable.RefreshProperties;
    init;
    result:=ShowModal = mrOK;
  finally
   
  end;
end;

function TFmTableRest.getStartValue(fname:string): string;
var
  tempQry:TAdsQuery;
begin
  tempQry:=TAdsQuery.Create(nil);
  try
    tempQry.DatabaseName:=AdsConnection.Name;
    tempQry.SQL.Text:='Select max('+fname+') from "'+AdsTable.Name+'"';
    tempQry.Open;
    result:=tempQry.Fields[0].asString;
    if result='' then
      result:='0';
    tempQry.Close;
  finally
    tempQry.Free;
  end;
end;

procedure TFmTableRest.init;
var
  I: Integer;
  ListItem: TListItem;
begin
  PageControl1.ActivePage:=tsGeneral; 
  lstAddFields:=TStringList.Create;
  lstRemoveFields:=TStringList.Create;
  lstChangeFields:=TStringList.Create;
  Dirty:=false;
  iNextPos:=1;
  Self.Caption:='Yeniden Yapýlandýr (' +Item+' )';
  for I := 0 to AdsTable.Fields.FieldCount - 1 do
  begin
    ListItem := LvTables.Items.Add;
    with ListItem do   begin
       Caption:=IntToStr(iNextPos);
       inc(iNextPos);
       ImageIndex := -1;
       SubItems.Add(AdsTable.Fields.Field[i].Name);
       SubItems.Add(AdsTable.Fields.Field[i].FieldType);
       SubItems.Add(inttostr(AdsTable.Fields.Field[i].Definition.usFieldLength));
       SubItems.Add(inttostr(AdsTable.Fields.Field[i].Definition.usFieldDecimals));
       if  AdsTable.Fields.Field[i].FieldType='AUTOINC' then
          SubItems.Add(getStartValue( AdsTable.Fields.Field[i].Name))
       else
          SubItems.Add('');
    end;
  end;
  LvTables.Items.Item[0].Selected:=true;
  edTableName.Text:=Item;
end;

procedure TFmTableRest.setDbParameters(conn: TAdsConnection;dict:TAdsDictionary;title:string);
begin
  AdsConnection:=conn;
  Dictionary:=dict;
  Item:=title;
end;

procedure TFmTableRest.writeCurrentRow;
begin
  //lbTitle.Caption:=LvTables.Selected.SubItems[0];

  EdFieldName.Text:=LvTables.Selected.SubItems[0];
  fieldType.ItemIndex:=fieldType.Items.IndexOf(LvTables.Selected.SubItems[1]);
  EdLength.Text:=LvTables.Selected.SubItems[2];
  edDecimal.Text:=LvTables.Selected.SubItems[3];
  edStartValue.Text:=LvTables.Selected.SubItems[4];
  if  LvTables.Selected.SubItems[4]='' then
    edStartValue.Enabled:=false
  else
    edStartValue.Enabled:=true;
  fieldTypeChange(self);
  btEkle.Enabled := False;
  btdegistir.Enabled := True;
  btSil.Enabled := true;
  btnew.Enabled := true;
end;

procedure TFmTableRest.LvTablesChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
  if LvTables.Selected=nil then exit;
  if (Change=ctState) and (LvTables.Selected.SubItems[0]<>EdFieldName.Text) then
    writeCurrentRow;
end;

procedure TFmTableRest.InsertRow;
var
  ListItem: TListItem;
begin
   if not ValidateFieldDef then
     exit;
   ListItem := LvTables.Items.Add;
   with ListItem do   begin
       Caption:=IntToStr(iNextPos);
       Inc( iNextPos );
       ImageIndex := -1;
       SubItems.Add(EdFieldName.Text);
       SubItems.Add(fieldType.Text);
       SubItems.Add(EdLength.Text);
       SubItems.Add(edDecimal.Text);
       if  fieldType.Text='AUTOINC' then
          SubItems.Add(edStartValue.Text)
       else
          SubItems.Add('');
   end;
   if  fieldType.Text='AUTOINC' then
      lstAddFields.Add( EdFieldName.Text + ',' + fieldType.Text + ',' + edStartValue.Text +',' + edDecimal.Text )
   else
      lstAddFields.Add( EdFieldName.Text + ',' + fieldType.Text + ',' + EdLength.Text +
                      ',' + edDecimal.Text );
   Dirty:=true;
   LvTables.Items.Item[iNextPos-2].Selected:=true;
   btEkle.Enabled := False;
   btdegistir.Enabled := True;
   btSil.Enabled := true;
   btnew.Enabled := true;

end;

procedure TFmTableRest.fieldTypeChange(Sender: TObject);
begin
  edStartValue.Enabled:=false;
  edStartValue.Text:='';
  edDecimal.Enabled:=false;
  edDecimal.Text:='0';
  EdLength.Enabled:=true;

   if fieldType.Text = 'DATE' then begin
      EdLength.Text := '4';
      EdLength.Enabled:=false;
   end
   else if fieldType.Text = 'LOGICAL' then
   begin
      EdLength.Text := IntToStr( SIZE_LOGICAL_FIELD );
      EdLength.Enabled:=false;
   end

   else if( fieldType.Text = 'MEMO' ) or
          ( fieldType.Text = 'BINARY' ) or
          ( fieldType.Text = 'IMAGE' ) then
   begin
     EdLength.Text := IntToStr( SIZE_ADT_MEMO_PTR );
     EdLength.Enabled:=false;
   end

   else if fieldType.Text = 'VARCHAR' then
   begin
      {* Added a check to see if the VARCHAR field was defined to
         fix a bug where the size of the varchar field was being
         lost on modifying the field name. *}
      if (EdLength.Text  = '') or (StrToInt( EdLength.Text )  < 6) then
      begin
         EdLength.Text := IntToStr( SIZE_VAR_CHAR_FIELD );
      end;
   end

   else if fieldType.Text = 'DOUBLE' then
   begin
      EdLength.Text := IntToStr( SIZE_DOUBLE_FIELD );
      EdLength.Enabled :=false;
      edDecimal.Enabled:=true;
   end

   else if fieldType.Text = 'CURDOUBLE' then
   begin
      EdLength.Text := IntToStr( SIZE_DOUBLE_FIELD );
      EdLength.Enabled :=false;
      edDecimal.Enabled:=true;
   end

   else if fieldType.Text = 'MONEY' then
   begin
      EdLength.Text := IntToStr( SIZE_DOUBLE_FIELD );
      EdLength.Enabled :=false;
      edDecimal.Text := '4';
      edDecimal.Enabled:=false;
   end

   else if fieldType.Text = 'INTEGER' then
   begin
      EdLength.Text := IntToStr( SIZE_INTEGER_FIELD );
      EdLength.Enabled :=false;
   end

   else if fieldType.Text = 'AUTOINC' then
   begin
      edStartValue.Enabled := True;
      edStartValue.Text := IntToStr( AUTO_INC_START_VAL );
      EdLength.Text := IntToStr( SIZE_INTEGER_FIELD );
      EdLength.Enabled :=false;
   end

   else if fieldType.Text = 'SHORTINT' then
   begin
      EdLength.Text := IntToStr( SIZE_SHORTINT_FIELD );
      EdLength.Enabled :=false;
   end

   else if fieldType.Text = 'RAW' then
   begin
      EdLength.Text := '';
   end

   else if fieldType.Text = 'TIME' then
   begin
      EdLength.Text := IntToStr( SIZE_TIME_FIELD );
      EdLength.Enabled :=false;
   end

   else if fieldType.Text = 'TIMESTAMP' then
   begin
      EdLength.Text := IntToStr( SIZE_TIMESTAMP_FIELD );
      EdLength.Enabled :=false;
   end

end;

procedure TFmTableRest.btEkleClick(Sender: TObject);
begin
  InsertRow;
end;


function TFmTableRest.ValidateFieldDef: boolean;
begin
   result := true;

   if( edFieldName.Text = '' ) or
     ( fieldType.Text = '' ) or
     ( edLength.Text = '' ) then
   begin
      MessageDlg( 'Alan bilgileri eksik girildi.',
                  mtInformation,
                  [ mbOK ],
                  0 );
      result := false;
      exit;
   end;

   //Validate Field Name.
   if( not ValidateFieldName() ) then
   begin
      result := false;
      exit;
   end;

   //Validate Character Field def
   if( fieldType.Text = 'CHARACTER' ) or
     ( fieldType.Text = 'VARCHAR' )then
   begin
      if( not ValidateCharDef() ) then
      begin
         result := false;
         exit;
      end;
   end

   //Validate Date Field def
   else if fieldType.Text = 'DATE' then
      ValidateDateDef()

   //Validate logical field def
   else if fieldType.Text = 'LOGICAL' then
      ValidateLogicalDef()

   //Validate Memo Field def
   else if( fieldType.Text = 'MEMO' ) or
          ( fieldType.Text = 'BINARY' ) or
          ( fieldType.Text = 'IMAGE' ) then
      ValidateMemoDef()

   //Validate Numeric Field def
   else if fieldType.Text = 'NUMERIC' then
   begin
      if( not ValidateNumericDef() ) then
      begin
         result := false;
         exit;
      end;
   end

   //Validate Numeric Field def
   else if( fieldType.Text = 'DOUBLE' ) or
          ( fieldType.Text = 'CURDOUBLE' ) or
          ( fieldType.Text = 'MONEY' ) then
   begin
      if( not ValidateDoubleDef() ) then
      begin
         result := false;
         exit;
      end;
   end

   //Validate Numeric Field def
   else if fieldType.Text = 'INTEGER' then
      ValidateIntegerDef();
end;

function TFmTableRest.ValidateFieldName: boolean;
var
   ii, jj: integer;
begin
   result := true;

   edFieldName.Text := Trim( edFieldName.Text );

   if edFieldName.Text = '' then
   begin
      MessageDlg( 'Alan adý boþ geçilemez.',
                  mtWarning,
                  [mbOK],
                  0 );
      edFieldName.SetFocus;
      result := false;
   end;

   for ii := 0 to LvTables.Items.Count - 1 do
   begin
      for jj := 0 to LvTables.Items[ ii ].SubItems.Count - 1 do
      begin
         if UpperCase( LvTables.Items[ ii ].SubItems[ 0 ] ) = UpperCase( edFieldName.Text ) then
         begin
            MessageDlg( 'Ayný isimde bir alan zaten var.',
                        mtWarning,
                        [mbOK],
                        0 );
            edFieldName.SetFocus;
            result := false;
            Exit;
         end;//if
      end;//for jj
   end;//for ii
end;

function TFmTableRest.ValidateCharDef: boolean;
begin
   result := true;

   if ( edDecimal.Text <> '0' ) then
      edDecimal.Text := '0';
   if ( StrToInt( edLength.Text ) < 1 ) or ( StrToInt( edLength.Text ) > MAX_CHARACTER_FIELD ) then
   begin
      MessageDlg( 'CHARACTER veya VARCHAR alan tiplerinin uzunluðu 1 ve ' + IntToStr( MAX_CHARACTER_FIELD ) + ' arasýnda olmalýdýr.',
                  MtWarning,
                  [mbOK],
                  0 );
      result := false;
      edLength.SetFocus;
   end;
end;

procedure TFmTableRest.ValidateLogicalDef;
begin
   if ( edDecimal.Text <> '0' ) then
      edDecimal.Text := '0';
   if ( edLength.Text <> '1' ) then
      edLength.Text := '1';
end;

procedure TFmTableRest.ValidateDateDef;
begin
  edDecimal.Text := '0';
  edLength.Text := '4'
end;

procedure TFmTableRest.ValidateIntegerDef;
begin
   if ( edDecimal.Text <> '0' ) then
      edDecimal.Text := '0';
   if ( edLength.Text <> IntToStr( SIZE_INTEGER_FIELD ) ) then
      edLength.Text := IntToStr( SIZE_INTEGER_FIELD );
end;

procedure TFmTableRest.ValidateMemoDef;
begin
   if ( edDecimal.Text <> '0' ) then
      edDecimal.Text := '0';
      if ( edLength.Text <> IntToStr( SIZE_ADT_MEMO_PTR ) ) then
      begin
         edLength.Text := IntToStr( SIZE_ADT_MEMO_PTR );
      end;
end;

function TFmTableRest.ValidateDoubleDef: boolean;
begin
   result := true;
end;

function TFmTableRest.ValidateNumericDef: boolean;
begin
   result := true;

   if ( ( StrToInt( edLength.Text ) <  MIN_NUMERIC_SIZE ) Or ( StrToInt( edLength.Text ) > MAX_NUMERIC_SIZE ) ) then
   begin
      MessageDlg( 'NUMBER alan tipi uzunluðu ' + #13 +
                  IntToStr( MIN_NUMERIC_SIZE ) +
                  ' ve ' + IntToStr( MAX_NUMERIC_SIZE ) + ' arasýnda olmalýdýr.',
                  MtWarning,
                  [mbOK],
                  0 );
      result := false;
      edLength.SetFocus;
   end

   else if ( ( StrToInt( edDecimal.Text ) < MIN_NUMERIC_DECIMAL ) or
      ( StrToInt( edDecimal.Text ) > StrToInt( edLength.Text ) - 2 ) ) then
   begin
      MessageDlg( 'NUMBER alan tipinin ' + #13 +
                  'ondalýk deðeri ' +
                  IntToStr( MIN_NUMERIC_DECIMAL ) + ' ve ' +
                  'Uzunluk - 2 deðerleri arasýnda olmalýdýr.',
                  MtWarning,
                  [mbOK],
                  0 );
      result := false;
      edDecimal.SetFocus;
   end;
end;


procedure TFmTableRest.ChangeFieldDef;
var
   poFieldDefItem   : TListItem;
   strSaveFieldName : string;
   iIndex           : integer;
   bFound           : boolean;
begin
   poFieldDefItem := LvTables.Selected;

   if Assigned( poFieldDefItem ) then
   begin

      if( MessageDlg( 'Yapýlan deðiþiklikler seçili alana ('+ poFieldDefItem.SubItems.Strings[ 0 ]
                      +') uygulansýn mý ?',
                      mtConfirmation,
                      [ mbYES, mbNO ],
                      0 ) ) = mrNo then
         exit;


      //clear field name so that validate field defs won't find it as a duplicate.
      strSaveFieldName := poFieldDefItem.SubItems.Strings[ 0 ];
      poFieldDefItem.SubItems.Strings[ 0 ] := '';

      //validate
      if( not ValidateFieldDef() ) then
      begin
         poFieldDefItem.SubItems.Strings[ 0 ] := strSaveFieldName;
         Exit;
      end;

      {*
       * Check that we are not modifying a new field.  This will cause
       * an error with the Data Dictionary because it can not modify a
       * field that does not exist.
       *}
      bFound := False;

      for iIndex := 0 to lstAddFields.Count -1 do
      begin
         if( pos( UpperCase( strSaveFieldName + ',' ),
                 UpperCase( lstAddFields.Strings[ iIndex ] ) ) <> 0 ) then
         begin
            lstAddFields.Delete( iIndex );
            if  fieldType.Text='AUTOINC' then
              lstAddFields.Add( EdFieldName.Text + ',' + fieldType.Text +
                               ',' +edStartValue.Text + ','+ edDecimal.Text )
            else
              lstAddFields.Add( EdFieldName.Text + ',' + fieldType.Text +
                               ',' + EdLength.Text + ','+ edDecimal.Text );
            bFound := True;
            break;
         end;
      end;

      poFieldDefItem.SubItems.Strings[ 0 ] := EdFieldName.Text;
      poFieldDefItem.SubItems.Strings[ 1 ] := fieldType.Text;
      poFieldDefItem.SubItems.Strings[ 2 ] := EdLength.Text;
      poFieldDefItem.SubItems.Strings[ 3 ] := edDecimal.Text;
      poFieldDefItem.SubItems.Strings[ 4 ] := edStartValue.Text;


      if ( not bFound ) then
      begin
         {*
          * Check that we are not modifing a modified field.  This is going to
          * be ugly because the field name could have changed, so strSaveFileName
          * might not be the original field name which is required.
          *}
         for iIndex := 0 to lstChangeFields.Count -1 do
         begin
            {* This will be true for original and change field names *}
            if ( pos( UpperCase( strSaveFieldName + ',' ),
                  UpperCase( lstChangeFields.Strings[ iIndex ] ) ) <> 0 ) then
            begin

               {*
                * Determine if the field name has been changed, by seeing if the
                * current saved field name starts the field modification defintion.
                * example of a changed field name.
                *
                * Name,NewName,c,12,0,(12);
                *
                *}
               if ( pos( UpperCase( strSaveFieldName + ',' ),
                    UpperCase( lstChangeFields.Strings[ iIndex ] ) ) <> 1 ) then
               begin
                  strSaveFieldName := copy( lstChangeFields.Strings[ iIndex ], 0,
                                            (pos( ',' , lstChangeFields.Strings[ iIndex ] ) - 1) );
               end;

               lstChangeFields.Delete( iIndex );
               lstChangeFields.Add( strSaveFieldName + ',' + poFieldDefItem.SubItems[0] + ',' +
                                     poFieldDefItem.SubItems[1] + ',' + poFieldDefItem.SubItems[2] + ',' +
                                     poFieldDefItem.SubItems[3] + ',(' + poFieldDefItem.Caption + ')' );

               bFound := True;
               break;
            end;
         end;

      end; {* end if ( not bNewField ) *}

      {* If the field still has not been found just add it to the list *}
      if ( not bFound ) then
      begin
         if  fieldType.Text='AUTOINC' then
            lstChangeFields.Add( strSaveFieldName + ',' + EdFieldName.Text + ',' +
                               fieldType.Text + ',' + edStartValue.Text + ','
                               + edDecimal.Text + ',(' + poFieldDefItem.Caption + ')' )
         else
            lstChangeFields.Add( strSaveFieldName + ',' + EdFieldName.Text + ',' +
                               fieldType.Text + ',' + EdLength.Text + ','
                               + edDecimal.Text + ',(' + poFieldDefItem.Caption + ')' )
      end;

      EdFieldName.SetFocus;
      Dirty:=true;
   end;
end;

procedure TFmTableRest.DeleteField;
var
   poFieldDefItem : TListItem;
   ii: Integer;
   i : integer;
   SelectIndex  : integer;
   bNewField : boolean;
   strSaveFieldName : string;
begin
   poFieldDefItem := LvTables.Selected;
   if Assigned( poFieldDefItem ) then
   begin
      if( MessageDlg( 'Seçilen alan kaldýrýlacak: ' +
                  poFieldDefItem.SubItems.Strings[ 0 ],
                  mtConfirmation,
                  [ mbYES, mbNO ],
                  0 ) ) = mrNo then
         exit;


      { check to see if the remove field happens to be in the add list.
        if it is then remove it. }
      bNewField := False;
      for i := 0 to lstAddFields.Count -1 do
      begin
         if( pos( UpperCase( poFieldDefitem.SubItems.Strings[ 0 ] + ',' ),
                 UpperCase( lstAddFields.Strings[ i ] ) ) <> 0 ) then
         begin
            lstAddFields.Delete( i );
            bNewField := True;
            break;
         end;

      end; { for i := 0 ... }

      strSaveFieldName := poFieldDefItem.SubItems.Strings[ 0 ];
      for i := 0 to lstChangeFields.Count -1 do
      begin
         if( pos( UpperCase( poFieldDefitem.SubItems.Strings[ 0 ] + ',' ),
                 UpperCase( lstChangeFields.Strings[ i ] ) ) <> 0 ) then
         begin
            if ( pos( UpperCase( strSaveFieldName + ',' ),
               UpperCase( lstChangeFields.Strings[ i ] ) ) <> 1 ) then
            begin
               strSaveFieldName := copy( lstChangeFields.Strings[ i ], 0,
                                       (pos( ',' , lstChangeFields.Strings[ i ] ) - 1) );
            end;
            lstChangeFields.Delete( i );
            break;
         end;

      end; { for i := 0 ... }

      {* If it is not a new field then add it to the list of field to delete *}
      if not bNewField then
      begin
         lstRemoveFields.Add( strSaveFieldName );
      end;
      SelectIndex:=poFieldDefItem.Index;
      poFieldDefItem.Delete();

      //Loop through field defs and re-number.
      for ii := 0 to LvTables.Items.Count - 1 do
      begin
         LvTables.Items[ ii ].Caption := IntToStr( ii + 1 );

         iNextPos := ii+1;
      end;

      //Reset the next position holder
      iNextPos := iNextPos + 1 ;

      Dirty:=true;
      if (LvTables.Items.Count-1>=SelectIndex) then
        LvTables.SelectItem(SelectIndex)
      else if  LvTables.Items.Count>0 then
        LvTables.SelectItem(0);
      if (lstAddFields.Count = 0) and (lstRemoveFields.Count = 0) and
         (lstChangeFields.Count = 0) then Dirty := False;
   end;
end;

procedure TFmTableRest.btdegistirClick(Sender: TObject);
begin
  ChangeFieldDef;
end;

procedure TFmTableRest.btSilClick(Sender: TObject);
begin
  DeleteField;
end;

procedure TFmTableRest.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   if ( Dirty = true ) then
   begin
      if ( ( MessageDlg( 'Deðiþiklikleri kayedetmeden çýkmak istediðinizden emin misiniz?', mtConfirmation, [ mbYes, mbNo ], 0 ) ) = mrYes ) then begin

         ModalResult := mrCancel;
      end else
      begin
         Action := caNone;
      end;
   end;

end;

procedure TFmTableRest.MoveUpBtnClick(Sender: TObject);
var
   poFieldDefItem,
   poPrevFieldDefItem : TListItem;
begin
   if LvTables.Selected=nil then
      exit;

   poFieldDefItem := LvTables.Selected;
   if Assigned( poFieldDefItem ) then
   begin
      if poFieldDefItem.Caption <> '1' then
      begin
         poPrevFieldDefItem := LvTables.FindCaption( 0,
                                                      IntToStr( StrToInt( poFieldDefItem.Caption ) - 1 ),
                                                      false{partial},
                                                      true,
                                                      false );
         poFieldDefItem.Caption := IntToStr( StrToInt( poFieldDefItem.Caption ) - 1 );
         poPrevFieldDefItem.Caption := IntToStr( StrToInt( poFieldDefItem.Caption ) + 1 );

         MoveField( poFieldDefItem, StrToInt( poFieldDefItem.Caption ),
                    poPrevFieldDefItem, StrToInt( poPrevFieldDefItem.Caption ));

      end;
      Dirty:=true;
   end;
end;

procedure TFmTableRest.MoveDownBtnClick(Sender: TObject);
var
   poFieldDefItem,
   poPrevFieldDefItem : TListItem;
begin
   if LvTables.Selected=nil then
      exit;

   poFieldDefItem := LvTables.Selected;
   if Assigned( poFieldDefItem ) then
   begin
      if StrToInt( poFieldDefItem.Caption ) <> LvTables.Items.Count then
      begin
         poPrevFieldDefItem := LvTables.FindCaption( 0,
                                                      IntToStr( StrToInt( poFieldDefItem.Caption ) + 1 ),
                                                      false{partial},
                                                      true,
                                                      false );
         poFieldDefItem.Caption := IntToStr( StrToInt( poFieldDefItem.Caption ) + 1 );
         poPrevFieldDefItem.Caption := IntToStr( StrToInt( poFieldDefItem.Caption ) - 1 );

         MoveField( poFieldDefItem, StrToInt( poFieldDefItem.Caption ),
                    poPrevFieldDefItem, StrToInt( poPrevFieldDefItem.Caption ) );
      end;
      Dirty:=true;
   end;

end;

procedure TFmTableRest.MoveField( poListItem : TListItem; iPosition  : integer;
                                  poPrevListItem : TListItem; iPrevPosition  : integer );
var
   iIndex               : integer;
   strOriginalFieldName : string;
   temp, findstr        :string;
begin

   if ( not Assigned( poListItem ) ) then
      exit;

   {*
    * Check if the field that is being moved is a new field.  If it is
    * a new field don't add a position to it yet, this will be handled
    * before executing the restructure command.
    *}
   for iIndex := 0 to lstAddFields.Count -1 do
   begin
      if( pos( UpperCase( poListItem.SubItems[0] + ',' ),
         UpperCase( lstAddFields.Strings[ iIndex ] ) ) <> 0 ) then
      begin
         exit;
      end;
   end;

   for iIndex := 0 to lstChangeFields.Count -1 do
   begin
      if( pos( UpperCase( poPrevListItem.SubItems[0] + ',' ),
         UpperCase( lstChangeFields.Strings[ iIndex ] ) ) <> 0 ) then
      begin
         temp := lstChangeFields.Strings[ iIndex ];
         findstr := copy(temp,pos('(',temp),pos(')',temp));
         lstChangeFields.Strings[ iIndex ] := StringReplace(temp,findstr,'('+IntToStr(iprevPosition)+')',[rfReplaceAll]);
      end;
   end;
   {*
    * It must be an existing field, search the existing modified fields first
    * to see if it just can be changed there.
    *}
   for iIndex := 0 to lstChangeFields.Count -1 do
   begin
      if( pos( UpperCase( poListItem.SubItems[0] + ',' ),
         UpperCase( lstChangeFields.Strings[ iIndex ] ) ) <> 0 ) then
      begin
         {* Get the original field name from the modified field list. *}
         strOriginalFieldName := lstChangeFields.Strings[ iIndex ];
         strOriginalFieldName := copy( strOriginalFieldName, 0,
                                       (pos( ',' , strOriginalFieldName ) - 1) );

         lstChangeFields.Delete( iIndex );
         lstChangeFields.Add( strOriginalFieldName + ',' + poListItem.SubItems[0] + ',' +
                               poListItem.SubItems[1] + ',' + poListItem.SubItems[2] + ','
                               + poListItem.SubItems[3] + ',(' + IntToStr( iPosition ) + ')' );

         exit;
      end;
   end;

   lstChangeFields.Add( poListItem.SubItems[0] + ',' + poListItem.SubItems[0] + ',' +
                         poListItem.SubItems[1] + ',' + poListItem.SubItems[2] + ','
                         + poListItem.SubItems[3] + ',(' + IntToStr( iPosition ) + ')' );

end; {* end TTableMgmtForm.MoveField *}


procedure TFmTableRest.HandleDDRestructure();
var
   i, k : integer;
   strAddFields : string;
   strRemoveFields : string;
   strChangeFields : string;
   hConnect : ADSHANDLE;
   strTableName : string;
   bEncrypted : boolean;
   tempTable:TAdsTable;
begin

   {* initialize update strings *}
   strAddFields := '';
   strRemoveFields := '';
   strChangeFields := '';

   hConnect := 0;

   for i := 0 to lstAddFields.Count - 1 do
   begin
      for k := 0 to LvTables.Items.Count - 1 do
      begin
         if ( pos( UpperCase( LvTables.Items[ k ].SubItems.Strings[ 0 ] + ',' ),
                 UpperCase( lstAddFields.Strings[ i ] ) ) <> 0 ) then
           begin
           lstAddFields.Strings[ i ] := lstAddFields.Strings[ i ] + ',(' +
           IntToStr( k + 1 ) + ')';
           break;
           end;

      end; {* for k := 0 ... *}
   end; {* for i := 0 ... *}

   {* now we create the actual strings from our lists *}
   for i := 0 to lstAddFields.Count - 1 do
      strAddFields := strAddFields + lstAddFields.Strings[ i ] + ';';

   for i := 0 to lstRemoveFields.Count - 1  do
      strRemoveFields := strRemoveFields + lstRemoveFields.Strings[ i ] + ';';

   for i := 0 to lstChangeFields.Count - 1 do
      strChangeFields := strChangeFields + lstChangeFields.Strings[ i ] + ';';


      AdsConnection.IsConnected:=false;
      AdsConnection.IsConnected:=true;
      hConnect :=AdsConnection.Handle; //tempTable.AdsConnection.Handle;
      strTableName := AdsTable.Name+'.adt';
      AceCheck( nil, ACE.AdsRestructureTable( hConnect,
                                              pChar( strTableName ),
                                              '',
                                              ADS_DEFAULT,
                                              ADS_ANSI,
                                              ADS_COMPATIBLE_LOCKING,
                                              ADS_CHECKRIGHTS,
                                              pChar( strAddFields ),
                                              pChar( strRemoveFields ),
                                              pChar( strChangeFields) ) );


   {* so the message about saving the table won't popup. *}
   Dirty := false;
   lstAddFields.Clear;
   lstRemoveFields.Clear;
   lstChangeFields.Clear;
   MessageDlg( Item+' tablosu yeniden yapýlandýrýldý.',mtConfirmation, [ mbOK], 0 );
end; {* TTableMgmtForm.HandleDDRestructure() *}



procedure TFmTableRest.FormDestroy(Sender: TObject);
begin
  if Assigned(AdsTable) then
     AdsTable.Free;
  if Assigned(lstAddFields) then
     lstAddFields.Free;
  if Assigned(lstRemoveFields) then
     lstRemoveFields.Free;
  if Assigned(lstChangeFields) then
     lstChangeFields.Free;

end;

procedure TFmTableRest.DirtyChanged;
begin

end;

procedure TFmTableRest.ModeChanged;
begin

end;

procedure TFmTableRest.OnDone;
begin
  inherited;
  btEkle.Enabled:=false;
  btdegistir.Enabled:=false;
  btSil.Enabled:=false;
  try
    HandleDDRestructure;
  finally
    btEkle.Enabled:=true;
    btdegistir.Enabled:=true;
    btSil.Enabled:=true;
  end;
end;

procedure TFmTableRest.Validate;
begin
  inherited;

end;

procedure TFmTableRest.FormCreate(Sender: TObject);
begin
  inherited;
  LvTables.SortType := stBoth;
  LvTables.OnCompare := LvTablesCompare;
end;

procedure TFmTableRest.LvTablesCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  inherited;
 if( StrToInt( Item1.Caption ) = StrToInt( Item2.Caption ) ) then
      Compare := 0
   else if ( StrToInt( Item1.Caption ) < StrToInt( Item2.Caption ) ) then
      Compare := -1
   else
      Compare := 1;
end;

procedure TFmTableRest.BtnOkClick(Sender: TObject);
begin
  if (Dirty) and ( MessageDlg( 'Tablonun yeniden yapýlandýrýlmasý sonucunda doðabilecek veri bozulamalarýna karþý '+Item+'.bak adýnda bir yedeði otomatik alýnacaktýr. '+Item+' tablosu yeniden yapýlandýrýlacak devam edecek misiniz ?',
       mtConfirmation, [ mbYES, mbNO ], 0 ) = mrNO ) then
     exit;
  inherited;
end;

procedure TFmTableRest.btnApplyClick(Sender: TObject);
begin
  if (Dirty) and ( MessageDlg( 'Tablonun yeniden yapýlandýrýlmasý sonucunda doðabilecek veri bozulamalarýna karþý '+Item+'.bak adýnda bir yedeði otomatik alýnacaktýr. '+Item+' tablosu yeniden yapýlandýrýlacak devam edecek misiniz ?',
       mtInformation, [ mbYES, mbNO ], 0 ) = mrNO ) then
     exit;
  inherited;
end;

procedure TFmTableRest.btnewClick(Sender: TObject);
begin
  inherited;
  EdFieldName.Text :='';
  fieldType.ItemIndex := -1;
  EdLength.Text := '';
  edStartValue.Text := '';
  edDecimal.Text := '';
  btEkle.Enabled := true;
  btdegistir.Enabled := False;
  btSil.Enabled := False;
  btnew.Enabled := False;
  EdFieldName.SetFocus;
end;

procedure TFmTableRest.LvTablesClick(Sender: TObject);
begin
  inherited;
  if LvTables.Selected=nil then exit;
  if (LvTables.Selected.SubItems[0]<>EdFieldName.Text) then
    writeCurrentRow;
end;

end.
