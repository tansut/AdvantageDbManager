unit UTableDesign;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UObjEdit, ComCtrls, StdCtrls, XStringGrid, Grids, ExtCtrls, ToolEdit,
  Mask, RXCtrls,adsdictionary,UAdvUtils,UAdsTable, CEButton, CECheckList,adscnnct,adstable,
  RXSpin, ImgList, Menus, Buttons, RzCommon, RzLookup,AdsData,
  MemoComponentUnit, SourceEditUnit, UActiveXList, SynEditHighlighter,
  SynHighlighterSQL, SynEdit,ace, BaseGrid, AdvGrid, AdvCGrid, ToolWin;

type
  TFmTableDesign = class(TFmDBObjectEditor)
    Panel1: TPanel;
    tsTableProp: TTabSheet;
    tsIndex: TTabSheet;
    Panel2: TPanel;
    Label6: TLabel;
    EdTableName: TEdit;
    Label7: TLabel;
    EdDesc: TMemo;
    Label8: TLabel;
    EdFailValidMess: TMemo;
    Label9: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label10: TLabel;
    Label11: TLabel;
    Bevel3: TBevel;
    Label12: TLabel;
    Bevel4: TBevel;
    EdRecLevelConst: TEdit;
    Label13: TLabel;
    Panel3: TPanel;
    Label15: TLabel;
    EdIndexName: TEdit;
    Label16: TLabel;
    RxSpinButton1: TRxSpinButton;
    CPerLevel: TComboBox;
    EdPrimaryIndex: TEdit;
    EdTablePath: TEdit;
    EdDefaultIndex: TEdit;
    Bevel5: TBevel;
    IndexColumns: TComboCellEditor;
    IndexListView: TListView;
    ImgSmall: TImageList;
    IndexPopup: TPopupMenu;
    Anahtar: TMenuItem;
    VarsaylanndeksYap1: TMenuItem;
    Yenindeks1: TMenuItem;
    Sil1: TMenuItem;
    CIndexFileName: TComboBox;
    N1: TMenuItem;
    CbPageSize: TComboBox;
    Label19: TLabel;
    TableNameDial: TSaveDialog;
    pnFieldProp: TPanel;
    PageControl2: TPageControl;
    columns: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label14: TLabel;
    EdDescription: TEdit;
    EdMinVal: TEdit;
    EdMaxVal: TEdit;
    EdDefVal: TEdit;
    EdValidMes: TEdit;
    EdDecimal: TEdit;
    btNewInx: TSpeedButton;
    btDelItem: TSpeedButton;
    btPrimayInx: TSpeedButton;
    btDefInx: TSpeedButton;
    Bevel7: TBevel;
    ChEncrypt: TCheckBox;
    Label20: TLabel;
    Bevel8: TBevel;
    ChAutoCreate: TCheckBox;
    Label21: TLabel;
    AlanPopup: TPopupMenu;
    MenuInsert: TMenuItem;
    TableNameList: TRzLookupDialog;
    btTablodanEkle: TButton;
    edStartValue: TEdit;
    lbStartValue: TLabel;
    tsTrigger: TTabSheet;
    sbTrgAdd: TSpeedButton;
    lvTrigger: TListView;
    sbDel: TSpeedButton;
    Panel5: TPanel;
    Label23: TLabel;
    edTrgName: TEdit;
    Label22: TLabel;
    mmTrgDesc: TMemo;
    cbTrgType: TComboBox;
    Label77: TLabel;
    Label78: TLabel;
    cbTrgEvent: TComboBox;
    Label80: TLabel;
    edTrgPriority: TEdit;
    Label24: TLabel;
    rbScript: TRadioButton;
    rbDLL: TRadioButton;
    rbCom: TRadioButton;
    Panel6: TPanel;
    trgPages: TNotebook;
    Label25: TLabel;
    btnVerify: TButton;
    Label79: TLabel;
    Label82: TLabel;
    edTrgFunction: TEdit;
    edDLLName: TFilenameEdit;
    Label84: TLabel;
    Label83: TLabel;
    edTrgMethod: TEdit;
    edProgID: TFilenameEdit;
    GroupBox70: TGroupBox;
    TrigOptionMemos: TCheckBox;
    TrigOptionValues: TCheckBox;
    TrigOptionTransaction: TCheckBox;
    mmStmt: TSynEdit;
    shSQL: TSynSQLSyn;
    InxPages: TNotebook;
    Label17: TLabel;
    XgIndexCols: TXStringGrid;
    Label18: TLabel;
    EdConditionExp: TEdit;
    LbWhileCon: TLabel;
    EdWhileCond: TEdit;
    ChUnique: TCheckBox;
    ChDescending: TCheckBox;
    ChCustom: TCheckBox;
    ChCompound: TCheckBox;
    Bevel6: TBevel;
    rbIndex: TRadioButton;
    rbFTSIndex: TRadioButton;
    Label26: TLabel;
    cbIndexField: TComboBox;
    GroupBox1: TGroupBox;
    edMinWordLength: TEdit;
    edMaxWordLength: TEdit;
    Label27: TLabel;
    Label28: TLabel;
    DelimitersGroup: TGroupBox;
    lbek1: TLabel;
    cbDefaultDelimiter: TCheckBox;
    edDelimiters: TEdit;
    DropCharsGroup: TGroupBox;
    lbek2: TLabel;
    cbDefaultDropChar: TCheckBox;
    edDropChars: TEdit;
    ConditionalCharsGroup: TGroupBox;
    lbek3: TLabel;
    cbDefaultConditional: TCheckBox;
    edConditionals: TEdit;
    FTSOptionsGroup: TGroupBox;
    cbKeepScore: TCheckBox;
    cbCaseSensitive: TCheckBox;
    cbFixed: TCheckBox;
    cbProtectNumbers: TCheckBox;
    NoiseWordGroup: TGroupBox;
    lbek4: TLabel;
    cbDefaultNoise: TCheckBox;
    edNoise: TMemo;
    pnFields: TPanel;
    grFields: TAdvColumnGrid;
    Splitter1: TSplitter;
    tbFields: TToolBar;
    ImageList1: TImageList;
    tbFiledUp: TToolButton;
    tbFieldDown: TToolButton;
    tbAddField: TToolButton;
    tbDelField: TToolButton;
    procedure FormDestroy(Sender: TObject);
    procedure Yenindeks1Click(Sender: TObject);
    procedure CIndexFileNameExit(Sender: TObject);
    procedure Sil1Click(Sender: TObject);
    procedure EdDescChange(Sender: TObject);
    procedure FieldTypeChange(fType:string);
    procedure AnahtarClick(Sender: TObject);
    procedure VarsaylanndeksYap1Click(Sender: TObject);
    procedure MenuInsertClick(Sender: TObject);
    procedure btTablodanEkleClick(Sender: TObject);
    procedure edProgIDBeforeDialog(Sender: TObject; var Name: String;
      var Action: Boolean);
    procedure rbScriptClick(Sender: TObject);
    procedure rbDLLClick(Sender: TObject);
    procedure rbComClick(Sender: TObject);
    procedure btnVerifyClick(Sender: TObject);
    procedure sbTrgAddClick(Sender: TObject);
    procedure cbTrgTypeChange(Sender: TObject);
    procedure cbTrgEventChange(Sender: TObject);
    procedure mmTrgDescChange(Sender: TObject);
    procedure edTrgPriorityChange(Sender: TObject);
    procedure mmStmtChange(Sender: TObject);
    procedure TrigOptionValuesClick(Sender: TObject);
    procedure TrigOptionMemosClick(Sender: TObject);
    procedure TrigOptionTransactionClick(Sender: TObject);
    procedure edDLLNameChange(Sender: TObject);
    procedure edTrgFunctionChange(Sender: TObject);
    procedure edProgIDChange(Sender: TObject);
    procedure edTrgMethodChange(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure lvTriggerChanging(Sender: TObject; Item: TListItem;
      Change: TItemChange; var AllowChange: Boolean);
    procedure lvTriggerMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sbDelClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure IndexListViewChanging(Sender: TObject; Item: TListItem;
      Change: TItemChange; var AllowChange: Boolean);
    procedure IndexListViewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ChEncryptClick(Sender: TObject);
    procedure tsGeneralShow(Sender: TObject);
    procedure rbIndexClick(Sender: TObject);
    procedure rbFTSIndexClick(Sender: TObject);
    procedure grFieldsRowChanging(Sender: TObject; OldRow, NewRow: Integer;
      var Allow: Boolean);
    procedure grFieldsComboChange(Sender: TObject; ACol, ARow,
      AItemIndex: Integer; ASelection: String);
    procedure grFieldsCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure grFieldsCellChanging(Sender: TObject; OldRow, OldCol, NewRow,
      NewCol: Integer; var Allow: Boolean);
    procedure EdDecimalChange(Sender: TObject);
    procedure edStartValueChange(Sender: TObject);
    procedure tbFiledUpClick(Sender: TObject);
    procedure tbFieldDownClick(Sender: TObject);
    procedure grFieldsCellsChanged(Sender: TObject; R: TRect);
    procedure tbAddFieldClick(Sender: TObject);
    procedure tbDelFieldClick(Sender: TObject);
    procedure EdDescriptionChange(Sender: TObject);
    procedure EdMinValChange(Sender: TObject);
    procedure EdMaxValChange(Sender: TObject);
    procedure EdDefValChange(Sender: TObject);
    procedure EdValidMesChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure grFieldsCellValidate(Sender: TObject; ACol, ARow: Integer;
      var Value: String; var Valid: Boolean);
    procedure grFieldsCheckBoxClick(Sender: TObject; ACol, ARow: Integer;
      State: Boolean);
   private
    TrgSaveException: Boolean;
    InxSaveException: Boolean;
    AdsTable: TDBAdsTable;
    FInxMode:TEditorMode;
    FTrgMode:TEditorMode;
    procedure SetInxMode(pMode:TEditorMode);
    procedure SetTrgMode(pMode:TEditorMode);
    procedure CreateNewIndex;
    procedure SaveTrigger;
    procedure SaveTableProperties;
    procedure SaveTableFields;
    procedure RestructureTable;
    procedure Refresh;
    procedure LvTablesCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure CheckSQLSyntax (pSQL:pchar; pMessage:Boolean);
    function SaveTriggerConfirm: boolean;
    function SaveIndexConfirm: boolean;
    Function ObjColor (pEnable : Boolean) :Tcolor;
    procedure SwapField(Inx1, Inx2 :Integer);
    function FormSave (pExit : Boolean) : Boolean;
  public
    property InxMode:TEditorMode read FInxMode write SetInxMode;
    property TrgMode:TEditorMode read FTrgMode write SetTrgMode;
    function Edit: Boolean; override;
    function New: Boolean; override;
    procedure Validate; override;
    procedure OnDone; override;
    procedure DirtyChanged; override;
    procedure ModeChanged; override;
    procedure Init;
    procedure ShowFieldDesc(fField:TAdsField);
    procedure ViewTableProp(TempTable:TDbAdsTable);
    procedure ViewIndexes(TempTable:TDbAdsTable);
    procedure ViewTriggers(TempTable:TDbAdsTable);
    procedure ViewIndexDetail(pName:string);
    procedure ViewTriggerDetail(pName:string);
    procedure IndexInit(pMode: TEditorMode);
    procedure TriggerInit(pMode: TEditorMode);
    procedure GridToField(mField: TAdsField; OldRow:integer);
    function GetDefaultLength(mFieldType:string):string;
    procedure GetFromTable;
  end;

var
  FmTableDesign: TFmTableDesign;

implementation
uses UAdsErr, UFmTableName;
{$R *.DFM}

{ TFmTableDesign }

procedure TFmTableDesign.DirtyChanged;
begin

end;

function TFmTableDesign.Edit: Boolean;
begin
  Init;
  AdsTable:=TDbAdsTable.Create(Dictionary,item);
  AdsTable.RefreshProperties;
  ViewTableProp(AdsTable);
  ViewIndexes(AdsTable);
  ViewTriggers(AdsTable);
  Dirty := False;
  Result := ShowModal = mrOK;
end;

procedure TFmTableDesign.Init;
begin
   PageControl1.ActivePage:=tsGeneral;
   trgPages.PageIndex := 0;
   TrgSaveException := False;
   InxSaveException := False;
   InxMode := emNone;
   TrgMode := emNone;
end;

procedure TFmTableDesign.ModeChanged;
begin
  case Mode of
    emEdit:  begin
               Caption:=item+' Özellikleri';
               self.HelpContext:=53;
               btTablodanEkle.Visible:=false;
               TrgSaveException := False;
               InxSaveException := False;
               InxMode := emNone;
               TrgMode := emNone;
             end;
    emNew :  begin
               Caption:='Yeni Tablo';
               self.HelpContext:=51;
               PageControl1.ActivePage:=tsGeneral;
               btTablodanEkle.Visible:=true;
               FieldTypeChange('');
             end;
  end;
end;

function TFmTableDesign.New: Boolean;
//var  fFieldList :TFieldList;
begin
  Init;
//  AdsTable:=TDbAdsTable.Create(Dictionary,'NewTable');
//  fFieldList:=TFieldList.create( Dictionary,'NewTable');
//  adsTable.Fields:=fFieldList;
//  Dirty:=True;
  Result := ShowModal = mrOK;
end;

procedure TFmTableDesign.OnDone;
begin
  if (PageControl1.ActivePage = tsIndex) then
     CreateNewIndex;
  if (PageControl1.ActivePage = tsTrigger) then
     SaveTrigger;
  if (PageControl1.ActivePage = tsTableProp) then
     SaveTableProperties;
  if (PageControl1.ActivePage = tsGeneral) then
     SaveTableFields;
  Dirty := False;
end;

procedure TFmTableDesign.Validate;
begin

end;


procedure TFmTableDesign.ShowFieldDesc(fField: TAdsField);
var
  tDirty:  Boolean;
begin
  if fField = nil then exit;
  tDirty:=Dirty;
  EdDescription.Text:=fField.Description;
  EdMinVal.Text:= fField.MinValue;
  EdMaxVal.Text:= fField.MaxValue;
  EdDefVal.Text:= fField.DefaultValue;
  if fField.Definition.usFieldDecimals<>0 then
    EdDecimal.Text:= inttostr(fField.Definition.usFieldDecimals)
  else
    EdDecimal.Text:='';
  EdValidMes.Text:=fField.ValidMess;
  FieldTypeChange (fField.GetFieldTypeToStr);
  if (fField.FieldType='AUTOINC') and (edStartValue.Visible) then
    edStartValue.Text:=IntToStr(fField.getStartValue);

  if tDirty=false then Dirty:=False;
end;


procedure TFmTableDesign.FormDestroy(Sender: TObject);
  var i: integer;
begin
  try
    if Assigned(AdsTable) then AdsTable.Free;
    for i := 1 to grFields.RowCount -1 do begin
      if Assigned(grFields.Objects[0,i]) then grFields.Objects[0,i].Free;
    end;
  except
  end;  
  inherited;
end;


procedure TFmTableDesign.ViewTableProp(TempTable: TDbAdsTable);
  Var i : integer;
      mField: TAdsField;
      fType: String;
begin
    grfields.Clear;
    grfields.ColumnHeaders.Add('Alan Adý');
    grfields.ColumnHeaders.Add('Tipi');
    grfields.ColumnHeaders.Add('Uzunluk');
    grfields.ColumnHeaders.Add('Zorunlu');
    IndexColumns.Items.Clear;
    IndexColumns.Items.Add('');
    cbIndexField.Items.Clear;
    if AdsTable.Fields.FieldCount > 7 then
      grFields.RowCount := AdsTable.Fields.FieldCount+2;
    for I := 0 to AdsTable.Fields.FieldCount-1 do
    begin
      With grFields do  begin

        Cells[0,i+1]:=AdsTable.Fields.Field[i].Name;
        Cells[1,i+1]:=AdsTable.Fields.Field[i].FieldType;
        Cells[2,i+1]:=InttoStr(AdsTable.Fields.Field[i].Definition.usFieldLength);
        if AdsTable.Fields.Field[i].IsNotNull then Cells[3,i+1]:='Y';

        mField := TAdsField.Create;
        mField.SetProperties(AdsTable.Fields.Field[i]);
        mField.OldName := mfield.Name;

        Objects[0,i+1] := mField;
        CellProperties[2,i+1].BrushColor := ObjColor(Cells[1,i+1]='CHARACTER');
      end;
      // ** Ýndex page tablo kolonlarý combobox deðerleri
      IndexColumns.Items.Add(AdsTable.Fields.Field[i].Name);
      fType := AdsTable.Fields.Field[i].FieldType;
      if (ftype ='CHARACTER') or (ftype ='MEMO') or (ftype ='VARCHAR') or
         (ftype ='BINARY') or (ftype ='IMAGE') or (ftype ='RAW') then
           cbIndexField.Items.Add(AdsTable.Fields.Field[i].Name);
    end;

    grfields.Col := 0;
    grfields.Row := 1;
    ShowFieldDesc( TAdsField(grFields.Objects[0,1]));

    EdTableName.Text:=TempTable.Name;
    EdTablePath.Text:=TempTable.TablePath;
    EdPrimaryIndex.Text:=TempTable.PrimaryKey;
    EdDefaultIndex.Text:=TempTable.DefaultIndex;
    CPerLevel.ItemIndex:=TempTable.PermissionLevel-1;
    EdRecLevelConst.Text:=TempTable.ValidationExpression;
    ChEncrypt.Tag := 1;
    ChEncrypt.Checked:=TempTable.Encrypted;
    ChEncrypt.Tag := 0;
    ChAutoCreate.Checked:=TempTable.AutoCreate;
    EdDesc.Text:=TempTable.Description;
    EdFailValidMess.Text:=TempTable.ValidationMessage;
end;

procedure TFmTableDesign.ViewIndexes(TempTable: TDbAdsTable);
var
  i:integer;
  ImgIndex: integer;
begin
  IndexListView.Items.Clear;
  CIndexFileName.Items.Clear;
  if TempTable.Indexes.Count=0 then begin
     InxMode := emNone;
     exit;
  end;

  for i:=0 to TempTable.Indexes.Count-1 do begin
    if TempTable.PrimaryKey = TempTable.Indexes.Strings[i] then
      ImgIndex := 6
    else if TempTable.DefaultIndex = TempTable.Indexes.Strings[i] then
      ImgIndex := 7 else ImgIndex := 0;

     AddListViewItem(IndexListView,TempTable.Indexes.Strings[i],ImgIndex);
  end;

  IndexListView.Items.Item[0].Selected:=true;

  for i:=0 to TempTable.IndexFiles.Count-1 do
    CIndexFileName.Items.Add(TempTable.IndexFiles.Strings[i]);
  ViewIndexDetail(IndexListView.Items.Item[0].Caption);         
  InxMode := emEdit;
end;

procedure TFmTableDesign.ViewIndexDetail(pName:string);
Var
  TempIndex:TAdsIndex;
  i:integer;
  Fields :TStringList;
begin
  TempIndex:=TAdsIndex.create(Dictionary,item,pName);
  InxMode := emNone;
  try
    TempIndex.RefreshDictProp;
    EdIndexName.Text:=TempIndex.Name;
    CIndexFileName.Text:=TempIndex.FileName;
    CbPageSize.ItemIndex:=CbPageSize.Items.IndexOf(IntToStr(TempIndex.Pagesize));
    Fields := TempIndex.fields;

    if TempIndex.FTSIndex then begin
      rbFTSIndex.Checked := True;
      InxPages.PageIndex := 1;
      cbIndexField.ItemIndex := cbIndexField.Items.IndexOf(TempIndex.Expression);
      edMinWordLength.Text := IntToStr(TempIndex.MinWordLength);
      edMaxWordLength.Text := IntToStr(TempIndex.MaxWordLength);
      cbDefaultDelimiter.Checked := False;
      cbDefaultDropChar.Checked := False;
      cbDefaultConditional.Checked := False;
      cbDefaultNoise.Checked := False;
      edDelimiters.Text := TempIndex.Delimeters;
      edConditionals.Text := TempIndex.ConditionalChars;
      edDropChars.Text := TempIndex.DropChars;
      edNoise.Lines.Text := TempIndex.NoiseWord;
      cbKeepScore.Checked := Tempindex.KeepScore;
      cbCaseSensitive.Checked := Tempindex.CaseSensitive;
      cbFixed.Checked := TempIndex.Fixed;
      cbProtectNumbers.Checked := TempIndex.ProtectNumbers;
    end else begin
      rbIndex.Checked := True;
      InxPages.PageIndex := 0;
      XgIndexCols.RowCount :=6 ;
      XgIndexCols.Row:=1;
      for i:=1 to fields.Count do begin
        if i>4 then
           XgIndexCols.RowCount :=XgIndexCols.RowCount+1;
        XgIndexCols.Cells[0,i]:=Fields.Strings[i-1];
      end;
      EdConditionExp.Text:=TempIndex.condition;
      ChUnique.Checked:=TempIndex.Unique;
      ChCustom.Checked:=TempIndex.Custom;
      ChDescending.Checked:=TempIndex.Descending;
      ChCompound.Checked:= TempIndex.Compound;
    end;
  finally
    TempIndex.Destroy;
  end;
  InxMode := emEdit;
  Dirty:= False;
end;

procedure TFmTableDesign.IndexListViewChanging(Sender: TObject;
  Item: TListItem; Change: TItemChange; var AllowChange: Boolean);
begin
  inherited;
  if (Change=ctState) then begin
    if InxSaveException then
       AllowChange := False
    else begin
       AllowChange := SaveIndexConfirm;
       if (not Dirty) and (Item.Caption <>'') and (Item.Caption <>EdIndexName.Text) and
          (InxMode<>emNone) then ViewIndexDetail(Item.Caption);
    end;
  end;
end;

function TFmTableDesign.SaveIndexConfirm: boolean;
begin
  Result := true;
  if Dirty and (InxMode<>emNone) then begin
    if MessageDlg('Eklediðiniz '+EdIndexName.Text +' isimli indeks yaratýlsýn mý?',
       mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
       try
         CreateNewIndex;
       except on e: Exception do
         begin
           InxSaveException := True;
           Result := False;
           MessageDlg(e.message, mtConfirmation, [mbOk], 0)
         end;
       end;
    end else begin
       Dirty := False;
       if (InxMode = emNew) then begin
          InxMode := emNone;
          IndexListView.Items[IndexListView.Items.Count -1].Delete;
          if IndexListView.Items.Count <> 0 then begin
            InxMode := emEdit;
            IndexListView.ItemIndex := IndexListView.Items.Count -1;
          end;
       end;
    end;
  end;
end;

procedure TFmTableDesign.IndexInit(pMode: TEditorMode);
var
  i:integer;
begin

  if pMode=emNew then begin
    EdIndexName.Enabled:=true;
    CIndexFileName.Enabled:=True;
    XgIndexCols.Options:=XgIndexCols.Options+[goEditing]-[goRowSelect];
    EdConditionExp.Enabled:=True;
    EdWhileCond.Visible:=True;
    LbWhileCon.Visible:=true;
    ChUnique.Enabled:=true;
    ChCustom.Enabled:=true;
    ChDescending.Enabled:=true;
    CbPageSize.Enabled:=True;
    EdIndexName.SetFocus;
    rbIndex.Enabled := True;
    rbFTSIndex.Enabled := True;
    cbIndexField.Enabled := True;
    edMaxWordLength.Enabled := True;
    edMinWordLength.Enabled := True;
    edDelimiters.ReadOnly := False;
    edDropChars.ReadOnly := False;
    edConditionals.ReadOnly := False;
    cbDefaultDelimiter.Enabled := True;
    cbDefaultDropChar.Enabled := True;
    cbDefaultConditional.Enabled := True;
    cbKeepScore.Enabled := True;
    cbCaseSensitive.Enabled := True;
    cbFixed.Enabled := True;
    cbProtectNumbers.Enabled := True;
    cbDefaultNoise.Enabled := True;
    edNoise.ReadOnly := False;
    lbek1.Visible := true;
    lbek2.Visible := true;
    lbek3.Visible := true;
    lbek4.Visible := true;
  end else begin
    EdIndexName.Enabled:=False;
    CIndexFileName.Enabled:=False;
    XgIndexCols.Options:=XgIndexCols.Options-[goEditing]+[goRowSelect];
    EdConditionExp.Enabled:=False;
    EdWhileCond.Visible:=False;
    LbWhileCon.Visible:=False;
    ChUnique.Enabled:=False;
    ChCustom.Enabled:=False;
    ChDescending.Enabled:=False;
    ChCompound.Enabled:=False;
    CbPageSize.Enabled:=false;
    rbIndex.Enabled := False;
    rbFTSIndex.Enabled := False;
    cbIndexField.Enabled := False;
    edMaxWordLength.Enabled := False;
    edMinWordLength.Enabled := False;
    edDelimiters.ReadOnly := True;
    edDropChars.ReadOnly := True;
    edConditionals.ReadOnly := True;
    cbDefaultDelimiter.Enabled := False;
    cbDefaultDropChar.Enabled := False;
    cbDefaultConditional.Enabled := False;
    cbKeepScore.Enabled := False;
    cbCaseSensitive.Enabled := False;
    cbFixed.Enabled := False;
    cbProtectNumbers.Enabled := False;
    cbDefaultNoise.Enabled := False;
    edNoise.ReadOnly := True;
    lbek1.Visible := false;
    lbek2.Visible := false;
    lbek3.Visible := false;
    lbek4.Visible := false;
  end;

  if pMode<>emEdit then begin
    CbPageSize.ItemIndex:=0;
    EdIndexName.Text:='';
    CIndexFileName.Text:='';
    CbPageSize.Text:='';
    for i:=1 to  XgIndexCols.RowCount do
       XgIndexCols.Cells[0,i]:='';
    EdConditionExp.Text:='';
    EdWhileCond.Text:='';
    ChUnique.Checked:=false;
    ChCustom.Checked:=false;
    ChDescending.Checked:=false;
    ChCompound.Checked:=false;
    rbIndex.checked :=True;
    InxPages.PageIndex := 0;
    cbIndexField.ItemIndex := -1;
    edMaxWordLength.Text :='30';
    edMinWordLength.Text :='3';
    edDelimiters.Text :='';
    edDropChars.Text :='';
    edConditionals.Text :='';
    cbDefaultDelimiter.Checked := True;
    cbDefaultDropChar.Checked := True;
    cbDefaultConditional.Checked := True;
    cbKeepScore.Checked := True;
    cbCaseSensitive.Checked := True;
    cbFixed.Checked := True;
    cbProtectNumbers.Checked := True;
    cbDefaultNoise.Checked := True;
    edNoise.Lines.Text := '';
  end;
end;

procedure TFmTableDesign.Yenindeks1Click(Sender: TObject);
begin
  inherited;
  if SaveIndexConfirm then begin
    AddListViewItem(IndexListView,'',0);
    IndexListView.ItemIndex := IndexListView.Items.Count -1;
    InxMode:=emNew;
    Dirty:=true;
  end;
end;

procedure TFmTableDesign.CIndexFileNameExit(Sender: TObject);
var
  i:integer;
begin
  inherited;
  ChCompound.Enabled:=false;
  CbPageSize.Enabled:=True;
  for i:=0 to CIndexFileName.Items.Count do
    if (CIndexFileName.Text=CIndexFileName.Items.Strings[i]) then begin
      ChCompound.Enabled:=true;
      CbPageSize.Enabled:=false;
    end;
end;

procedure TFmTableDesign.SetInxMode(pMode: TEditorMode);
begin
  FInxMode:=pMode;
  IndexInit(pMode);
end;

procedure TFmTableDesign.CreateNewIndex;
var
  NewIndex:TAdsIndex;
  i:integer;
  Exp :String;
  temp: integer;
begin
  if edIndexName.Text ='' then
     raise Exception.Create('Ýndeks adýný girmelisiniz.');

  if rbindex.Checked then begin
     for i:=1 to XgIndexCols.RowCount do
        if XgIndexCols.Cells[0,i]<>'' then
           if Exp='' then
              Exp:=XgIndexCols.Cells[0,i]
           else
              Exp:=Exp+';'+XgIndexCols.Cells[0,i];
  end else Exp := cbIndexField.Text;

  if Exp='' then
     raise Exception.Create('Ýndeks alaný seçmelisiniz.');

  try
    temp := StrToInt(edMinWordLength.Text);
  except
    raise Exception.Create('Kelime en az karakter sayýsý alanýna nümerik deðer girmelisiniz.');
  end;

  try
    temp := StrToInt(edMaxWordLength.Text);
  except
    raise Exception.Create('Kelime en çok karakter sayýsý alanýna nümerik deðer girmelisiniz.');
  end;

  NewIndex:=TAdsIndex.create(Dictionary,item,EdIndexName.Text);
  try
    with NewIndex do begin
      FileName:=CIndexFileName.Text;
      Pagesize:=StrToInt(CbPageSize.Text);
      Expression := Exp;

      if rbIndex.Checked then begin
        FTSIndex := False;
        Condition:=EdConditionExp.Text;
        WhileCon:=EdWhileCond.Text;
        Unique:=ChUnique.Checked;
        Descending:=ChDescending.Checked;
        Compound:=ChCompound.Checked;
        Custom:=ChCustom.Checked;
      end else begin
        FTSIndex := True;
        MinWordLength := StrToInt(edMinWordLength.Text);
        MaxWordLength := StrToInt(edMaxWordLength.Text);
        DefaultDelimeters := cbDefaultDelimiter.Checked;
        DefaultDropChars := cbDefaultDropChar.Checked;
        DefaultConditionals := cbDefaultConditional.Checked;
        DefaultNoise := cbDefaultNoise.Checked;
        Delimeters := edDelimiters.Text;
        DropChars := edDropChars.Text;
        ConditionalChars := edConditionals.Text;
        NoiseWord := edNoise.Text;
        KeepScore := cbKeepScore.Checked;
        CaseSensitive := cbCaseSensitive.Checked;
        Fixed := cbFixed.Checked;
        ProtectNumbers := cbProtectNumbers.Checked;
      end;

      CreateAdsIndex;
      if InxMode = emNew then begin
        IndexListView.Items[IndexListView.Items.Count -1].Caption := EdIndexName.Text;
        if IndexListView.Selected.Caption =EdIndexName.Text then
          ViewIndexDetail(EdIndexName.Text);
      end;
      InxMode := emEdit;
      Dirty:=False;
    end;
  finally
    NewIndex.Destroy;
  end;
end;

procedure TFmTableDesign.Sil1Click(Sender: TObject);
var
  TempInx:TAdsIndex;
  continue: Boolean;
begin
  if IndexListView.Selected=nil then exit;
  if IndexListView.Selected.Caption <>'' then begin
    continue := MessageDlg(IndexListView.Selected.Caption +' isimli indeks kalýcý olarak kaldýrýlacaktýr.' +chr(13)+
                'Devam etmek istiyor musunuz?', mtConfirmation, [mbYes, mbNo], 0) = mrYes;
    if continue then begin
      TempInx:=TAdsIndex.create(Dictionary,item,EdIndexName.Text);
      try
        TempInx.DeleteAdsIndex;
      finally
       TempInx.Destroy;
      end;
    end;
  end else continue := True;

  if continue then begin
    Dirty := False;
    InxMode := emNone;
    IndexListView.Items[IndexListView.Selected.Index].Delete;
    if IndexListView.Items.Count <> 0 then begin
      InxMode := emEdit;
      IndexListView.ItemIndex := IndexListView.Items.Count -1;
    end;
  end;
end;

procedure TFmTableDesign.Refresh;
begin
  AdsTable.RefreshProperties;
  ViewTableProp(AdsTable);
  ViewIndexes(AdsTable);
  ViewTriggers(AdsTable);
end;

procedure TFmTableDesign.EdDescChange(Sender: TObject);
begin
  inherited;
  Dirty:=True;
end;

Function TFmTableDesign.ObjColor (pEnable : Boolean) :Tcolor;
begin
  if pEnable then result := clWindow else result := $00E4E4E4;
end;

procedure TFmTableDesign.FieldTypeChange(fType:string);
begin

  if fType ='' then begin
    EdDescription.Enabled := False;
    edStartValue.Visible  := False;
    lbStartValue.Visible  := False;
    EdMinVal.Enabled      := false;
    EdMaxVal.Enabled      := false;
    EdDefVal.Enabled      := false;
    EdValidMes.Enabled    := false;
    EdDecimal.Enabled     := False;
    EdDescription.Text    := '';
    EdMinVal.Text         := '';
    EdMaxVal.Text         := '';
    EdDefVal.Text         := '';
    EdValidMes.Text       := '';
    EdDecimal.Text        := '';
  end else begin

    EdValidMes.Enabled    := True;
    EdDescription.Enabled := True;

    if (ftype='AUTOINC') and (mode = emNew) then begin
      edstartValue.Text := '0';
      edStartValue.Visible:=true;
      lbStartValue.Visible:=true;
    end else begin
      edStartValue.Visible:=false;
      lbStartValue.Visible:=false;
    end;

    if (pos(ftype,'AUTOINC BINARY LOGICAL')>0) then
    begin
      EdMinVal.Text   := '';
      EdMaxVal.Text   := '';
      EdMinVal.Enabled:= false;
      EdMaxVal.Enabled:= false;
    end else begin
      EdMinVal.Enabled:= True;
      EdMaxVal.Enabled:= True;
    end;

    if (pos(ftype,'AUTOINC BINARY')>0) then
    begin
      EdDefVal.Text   := '';
      EdDefVal.Enabled:= false;
    end else begin
      EdDefVal.Enabled:= True;
    end;

    if (pos(fType,'DOUBLE;CURDOUBLE;MONEY')>0) then
      EdDecimal.Enabled:= True
    else begin
      EdDecimal.Enabled:= False;
      EdDecimal.Text   := '';
    end;
  end;

  EdDescription.Color := ObjColor(EdDescription.Enabled);
  EdMinVal.Color      := ObjColor(EdMinVal.Enabled);
  EdMaxVal.Color      := ObjColor(EdMaxVal.Enabled);
  EdDefVal.Color      := ObjColor(EdDefVal.Enabled);
  EdValidMes.Color    := ObjColor(EdValidMes.Enabled);
  EdDecimal.Color     := ObjColor(EdDecimal.Enabled);

end;

procedure TFmTableDesign.AnahtarClick(Sender: TObject);
var
  i:integer;
begin
  inherited;
  if IndexListView.Selected=nil then exit;
  if rbFTSIndex.Checked then
    raise Exception.Create('Ýçerik arama indeksi Anahtar Ýndeks yapýlamaz.');
  if not ChUnique.Checked then
    raise Exception.Create('Anahtar Ýndeks benzersiz olmalýdýr.');
  AdsTable.PrimaryKey:=IndexListView.Selected.Caption;
  EdPrimaryIndex.Text:=IndexListView.Selected.Caption;
  for i:= 0 to IndexListView.Items.Count -1 do
   if IndexListView.Items[i].ImageIndex = 6 then
      IndexListView.Items[i].ImageIndex := 0;
  IndexListView.Selected.ImageIndex := 6;
end;

procedure TFmTableDesign.VarsaylanndeksYap1Click(Sender: TObject);
var
  i:integer;
begin
  inherited;
  if IndexListView.Selected=nil then exit;
  if rbFTSIndex.Checked then
    raise Exception.Create('Ýçerik arama indeksi Varsayýlan Ýndeks yapýlamaz.');

  AdsTable.DefaultIndex:=IndexListView.Selected.Caption;
  EdDefaultIndex.Text:=IndexListView.Selected.Caption;
  if UpperCase(AdsTable.DefaultIndex) <> UpperCase(AdsTable.PrimaryKey) then begin
     for i:= 0 to IndexListView.Items.Count -1 do
       if IndexListView.Items[i].ImageIndex = 7 then
          IndexListView.Items[i].ImageIndex := 0;
     IndexListView.Selected.ImageIndex := 7
  end else
     MessageDlg('Anahtar Index varsayýlan indeks yapýldý.'
            , mtConfirmation, [mbOk], 0);

end;

function TFmTableDesign.GetDefaultLength(mFieldType:string): string;
begin
  if mFieldType='LOGICAL' then result:='1'
  else if pos(mFieldType,'INTEGER AUTOINC DATE TIME')>0 then result:='4'
  else if mFieldType='SHORTINT' then result:='2'
  else if pos(mFieldType,'DOUBLE MONEY RAW TIMESTAMP CURDOUBLE')>0 then result:='8'
  else if pos(mFieldType,'BINARY IMAGE MEMO')>0 then result := '9'
  else if mFieldType = 'CHARACTER' then result := '25'
  else result := '' ;
end;

procedure TFmTableDesign.GetFromTable;
var
  hedefTable:TDBAdsTable;
  Tables: TStringList;
  mRow, i,inx:integer;
  tempName:string;
  tempPath:string;
  mField, tempField:TAdsField;

begin
  grfields.Col := 0;
  mRow := grfields.Row;
  grfields.Row := mRow + 1;
  if grFields.Row <> mRow + 1 then exit;
  tables:=TStringList.Create;
  tempName:='';
  try
    Dictionary.GetTableNames(tables);
    if Tables.Count=0 then begin
       MessageDlg( 'Veritabanýnda hiç tablo yok.', mtInformation,[ mbOK ],0 );
     exit;
    end;
    TableNameList.List.Clear;
    for i:=0 to tables.Count-1 do
      TableNameList.List.Add(Tables.Strings[i]);
    if TableNameList.Execute then
      tempName:=TableNameList.List[TableNameList.SelectedIndex];
    if tempName='' then
      exit;
  finally
    Tables.Free;
  end;
  hedefTable:=TDBAdsTable.Create(Dictionary,tempName);
  try
    hedefTable.RefreshProperties;
    inx:=1;
    for i:=0 to hedefTable.Fields.FieldCount-1 do begin
      tempField:=hedefTable.Fields.Field[i];
      with grfields do begin
        if inx>=RowCount - 1 then
           RowCount:=RowCount+1;
         While Cells[0,inx]<>'' do
           inx:=inx+1;

         Cells[0,inx]:=TempField.Name;
         Cells[1,inx]:=TempField.FieldType;
         Cells[2,inx]:=InttoStr(TempField.Definition.usFieldLength);
         if TempField.IsNotNull then Cells[3,inx]:='Y';

         mField := TAdsField.Create;
         mField.SetProperties(TempField);

         Objects[0,inx] := mField;
         CellProperties[2,inx].BrushColor := ObjColor(Cells[1,inx]='CHARACTER');
      end;
    end;
  finally
    hedefTable.Free;
  end;
  Dirty := True;
end;

procedure TFmTableDesign.MenuInsertClick(Sender: TObject);
begin
  inherited;
  GetFromTable;
end;

procedure TFmTableDesign.btTablodanEkleClick(Sender: TObject);
begin
  inherited;
  GetFromTable;
end;


procedure TFmTableDesign.LvTablesCompare( Sender: TObject;
                                           Item1,
                                           Item2: TListItem;
                                           Data: Integer;
                                           var Compare: Integer );
begin
   if( StrToInt( Item1.Caption ) = StrToInt( Item2.Caption ) ) then
      Compare := 0
   else if ( StrToInt( Item1.Caption ) < StrToInt( Item2.Caption ) ) then
      Compare := -1
   else
      Compare := 1;
end;


procedure TFmTableDesign.edProgIDBeforeDialog(Sender: TObject;
  var Name: String; var Action: Boolean);
begin
  inherited;
    with TfmActiveXList.Create( nil ) do
    begin
      try
        ShowModal;
        if ( ModalResult = mrOK ) then
        begin
          edProgID.Text := lbActiveX.Items[ LbActiveX.ItemIndex ] ;
        end;
      finally
        Free;
      end;
    end;
    Action := False;
end;

procedure TFmTableDesign.rbScriptClick(Sender: TObject);
begin
  inherited;
  trgPages.PageIndex := 0;
  Dirty := True;
end;

procedure TFmTableDesign.rbDLLClick(Sender: TObject);
begin
  inherited;
  trgPages.PageIndex := 1;
  Dirty := True;
end;

procedure TFmTableDesign.rbComClick(Sender: TObject);
begin
  inherited;
  trgPages.PageIndex := 2;
  Dirty := True;
end;

procedure TFmTableDesign.ViewTriggers(TempTable: TDbAdsTable);
var
  i:integer;
begin
  lvTrigger.Items.Clear;
  if TempTable.Triggers.Count=0 then begin
     TrgMode := emNone;
     exit;
  end;
  for i:=0 to TempTable.triggers.Count-1 do
    AddListViewItem(lvTrigger,TempTable.Triggers.Strings[i], 8);

  lvTrigger.Items.Item[0].Selected:=true;
  ViewTriggerDetail(lvTrigger.Items.Item[0].Caption);
end;

procedure TFmTableDesign.ViewTriggerDetail(pName: string);
Var
  TempTrg:TAdsTrigger;
begin
  TempTrg:=TAdsTrigger.create(Dictionary,pName);
  try
    edTrgName.Text := pName;
    mmTrgDesc.Lines.Text := TempTrg.GetDesc;
    cbTrgType.ItemIndex := integer(TempTrg.GetTriggerType);
    cbTrgEvent.ItemIndex := integer(TempTrg.GetEventType);
    edTrgPriority.Text := IntToStr(TempTrg.GetPriority);

    TrigOptionValues.Checked := TRUE;
    TrigOptionMemos.Checked := TRUE;
    TrigOptionTransaction.Checked := TRUE;

    if ( toNoValues in tempTrg.GetOptions ) then
    begin
       TrigOptionValues.Checked := FALSE;
       TrigOptionMemos.Checked  := FALSE;
    end;

    if ( toNoMemosOrBlobs in tempTrg.GetOptions) then
       TrigOptionMemos.Checked  := FALSE;

    if ( toNoTransaction in tempTrg.GetOptions ) then
       TrigOptionTransaction.Checked := FALSE;

    edDLLName.Text := '';
    edTrgFunction.Text  :='';
    edProgID.Text :='';
    edTrgMethod.Text :='';
    mmStmt.Lines.Text :='';

    if ( tempTrg.GetContainerType = ctStdLib ) then
    begin
      rbDLL.Checked := True;
      trgPages.PageIndex := 1;
      edDLLName.Text := tempTrg.GetContainer;
      edTrgFunction.Text  := tempTrg.GetFunctionName;
   end
   else if ( tempTrg.GetContainerType = ctCOM ) then
   begin
      rbCom.Checked := True;
      trgPages.PageIndex := 2;
      edProgID.Text := tempTrg.GetContainer;
      edTrgMethod.Text := tempTrg.GetFunctionName;
   end
   else if ( tempTrg.GetContainerType = ctScript ) then
   begin
      rbScript.Checked := True;
      trgPages.PageIndex := 0;
      mmStmt.Lines.Text := tempTrg.GetContainer;
      if ( UpperCase( TempTrg.Dictionary.UserName ) = 'ADSSYS' ) then
         btnVerify.Enabled := True
      else
         btnVerify.Enabled := False;
   end;
  finally
    TempTrg.Destroy;
    TrgMode := emEdit;
    Dirty:= False;
  end;
end;

procedure TFmTableDesign.TriggerInit(pMode: TEditorMode);
begin
   if pMode<> emEdit then begin
     edTrgName.Text := '';
     mmTrgDesc.Lines.Text :='';
     cbTrgType.ItemIndex := -1;
     cbTrgEvent.ItemIndex := -1;
     edTrgPriority.Text := '1';
     TrigOptionValues.Checked := TRUE;
     TrigOptionMemos.Checked := TRUE;
     TrigOptionTransaction.Checked := TRUE;
     edDLLName.Text := '';
     edTrgFunction.Text  := '';
     edProgID.Text := '';
     edTrgMethod.Text := '';
     rbScript.Checked := True;
     trgPages.PageIndex := 0;
     mmStmt.Lines.Text := '';
     Dirty := False;
   end;

   if pMode=emNone then begin
      mmTrgDesc.Enabled := False;
      cbTrgType.Enabled := False;
      cbTrgEvent.Enabled := False;
      edTrgPriority.Enabled := False;
      TrigOptionValues.Enabled := false;
      TrigOptionMemos.Enabled := false;
      TrigOptionTransaction.Enabled := false;
      rbScript.Enabled := False;
      rbDLL.Enabled := False;
      rbCom.Enabled := False;
      mmStmt.Enabled := False;
      btnVerify.Enabled := False;
   end else begin
      mmTrgDesc.Enabled := True;
      cbTrgType.Enabled := True;
      cbTrgEvent.Enabled := True;
      edTrgPriority.Enabled := True;
      TrigOptionValues.Enabled := True;
      TrigOptionMemos.Enabled := True;
      TrigOptionTransaction.Enabled := True;
      rbScript.Enabled := True;
      rbDLL.Enabled := True;
      rbCom.Enabled := True;
      mmStmt.Enabled := True;
      btnVerify.Enabled := True;
   end;

    if pMode=emNew then begin
      edTrgName.Enabled := True;
    end else begin
      edTrgName.Enabled := False;
    end;
end;

procedure TFmTableDesign.SetTrgMode(pMode: TEditorMode);
begin
  FTrgMode:=pMode;
  TriggerInit(pMode);
end;

procedure TFmTableDesign.SaveTrigger;
  var TriggerType: TAdsTrigType;
      priority : UNSIGNED32;
      EventType: TAdsTrigEventType;
      ContainerType: TAdsTrigContainerType;
      Options: TAdsTrigOptions;
      Container: String;
      FunctionName : String;
begin
  try
    priority := StrToInt(edTrgPriority.text);
  except
    raise Exception.Create('Öncelik sýrasýný hatalý. Lütfen nümerik bir deðer giriniz.');
  end;

  if (edTrgName.Text='') then  raise
     Exception.Create( 'Tetikleyici adýný giriniz.' );
  if (cbTrgType.Text ='') then
    raise Exception.Create( 'Tetikleyici tipini seçiniz.' );
  if (cbTrgEvent.Text = '') then
    raise Exception.create('Olay tipini seçiniz.');

  if ( cbTrgType.Text = 'BEFORE' ) then
     TriggerType := adsdictionary.ttBefore
  else if ( cbTrgType.Text = 'INSTEAD OF' ) then
     TriggerType := adsdictionary.ttInsteadOf
  else if ( cbTrgType.Text = 'AFTER' ) then
     TriggerType := adsdictionary.ttAfter;

  EventType   := TAdsTrigEventType( cbTrgEvent.ItemIndex );

  if ( rbDLL.Checked) then begin
     if (edDLLName.Text ='') then raise Exception.Create('DLL Dosya adýný seçmelisiniz.');
     if (edTrgFunction.Text ='') then raise Exception.Create('Fonksiyon adýný girmelisiniz.');
     ContainerType := ctStdLib;
     Container     := edDLLName.Text;
     FunctionName  := edTrgFunction.Text;
  end else if ( rbCom.Checked ) then begin
     if (edProgID.Text ='') then raise Exception.Create('ProgramID''yi seçmelisiniz.');
     if (edTrgMethod.Text ='') then raise Exception.Create('Metod adýný girmelisiniz.');
     ContainerType := ctCOM;
     Container     := edProgID.Text;
     FunctionName  := edTrgMethod.Text;
  end else if ( rbScript.Checked ) then begin
     if (mmStmt.Text ='') then raise Exception.Create('SQL Scriti girmelisiniz.');
     CheckSQLSyntax(mmstmt.Lines.GetText, False);
     ContainerType := ctScript;
     Container     := mmstmt.Text;
     FunctionName  := '';
  end;

  Options  := [];
  if ( not TrigOptionMemos.Checked ) then
     Options := Options + [ toNoMemosOrBlobs ];
  if ( not TrigOptionValues.Checked ) then
     Options := Options + [ toNoValues ];
  if ( not TrigOptionTransaction.Checked ) then
     Options := Options + [ toNoTransaction ];

  if TrgMode = emEdit then
    Dictionary.RemoveTrigger(edTrgName.Text);

  Dictionary.CreateTrigger( edtrgName.Text, edTableName.Text, EventType, TriggerType,
                            ContainerType, Container, FunctionName, Priority,
                            mmTrgDesc.Lines.Text, Options );

  if TrgMode = emNew then lvTrigger.Items[lvTrigger.Items.Count -1].Caption := edTrgName.Text;
  TrgMode := emEdit;
  Dirty:=False;
end;

procedure TFmTableDesign.CheckSQLSyntax(pSQL: pchar; pMessage:Boolean);
var
   hStmt    : ADSHANDLE;
   iLine    : integer;
   iColumn  : integer;
   StrTemp  : String;
begin
   AceCheck( nil, ACE.AdsCreateSQLStatement( Dictionary.ConnectionHandle, @hStmt ) );
   try
      try
         Screen.Cursor := crHourglass;
         if not assigned( pSQL ) then
            raise Exception.Create( 'SQL Script girilmemiþ.' );

         strTemp := pSQL;
         strTemp := StringReplace( strTemp, '__old', Item, [rfReplaceAll, rfIgnoreCase] );
         strTemp := StringReplace( strTemp, '__new', Item, [rfReplaceAll, rfIgnoreCase] );

         AceCheck( nil, ACE.AdsVerifySQL( hStmt, PChar( strTemp )) );
         if pMessage then ShowMessage( 'SQL Script yazýmý doðru' );
      except
         on e:EAdsDatabaseError do
           raise EAdsDatabaseError.Create(nil,e.SQLErrorCode, 'SQL Script Yazýmý hatalý.'+chr(13)+e.Message);
      end;
   finally
      ACE.AdsCloseSQLStatement( hStmt );
      if assigned( pSQL ) then
         StrDispose( pSQL );
      Screen.Cursor := crDefault;
   end;
end;

procedure TFmTableDesign.btnVerifyClick(Sender: TObject);
begin
  inherited;
  CheckSQLSyntax(mmstmt.Lines.GetText, True);
end;

procedure TFmTableDesign.sbTrgAddClick(Sender: TObject);
begin
  inherited;
  if SaveTriggerConfirm then begin
    AddListViewItem(lvtrigger,'',8);
    lvTrigger.ItemIndex := lvtrigger.Items.Count -1;
    TrgMode:=emNew;
    Dirty:=true;
  end;
end;

procedure TFmTableDesign.cbTrgTypeChange(Sender: TObject);
begin
  inherited;
  Dirty := True;
end;

procedure TFmTableDesign.cbTrgEventChange(Sender: TObject);
begin
  inherited;
  Dirty := True;
end;

procedure TFmTableDesign.mmTrgDescChange(Sender: TObject);
begin
  inherited;
  Dirty := True;
end;

procedure TFmTableDesign.edTrgPriorityChange(Sender: TObject);
begin
  inherited;
  Dirty := True;
end;

procedure TFmTableDesign.mmStmtChange(Sender: TObject);
begin
  inherited;
  Dirty := True;
end;

procedure TFmTableDesign.TrigOptionValuesClick(Sender: TObject);
begin
  inherited;
  Dirty := True;
end;

procedure TFmTableDesign.TrigOptionMemosClick(Sender: TObject);
begin
  inherited;
  Dirty := True;
end;

procedure TFmTableDesign.TrigOptionTransactionClick(Sender: TObject);
begin
  inherited;
  Dirty := True;
end;

procedure TFmTableDesign.edDLLNameChange(Sender: TObject);
begin
  inherited;
  Dirty := True;
end;

procedure TFmTableDesign.edTrgFunctionChange(Sender: TObject);
begin
  inherited;
  Dirty := True;
end;

procedure TFmTableDesign.edProgIDChange(Sender: TObject);
begin
  inherited;
  Dirty := True;
end;

procedure TFmTableDesign.edTrgMethodChange(Sender: TObject);
begin
  inherited;
  Dirty := True;
end;

procedure TFmTableDesign.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  inherited;
  AllowChange := FormSave(False);
end;

function TFmTableDesign.FormSave (pExit : Boolean) : Boolean;
begin
  Result := True;
  if dirty then begin
    if PageControl1.ActivePage = tsTrigger then
       Result := SaveTriggerConfirm
    else if PageControl1.ActivePage = tsIndex then
       Result := SaveIndexConfirm
    else if MessageDlg(PageControl1.ActivePage.Caption + ' sayfasýnda yaptýðýnýz deðiþiklikler kaydedilsin mi?',
                       mtInformation, [mbOk, mbCancel], 0) = mrOk then
    try
      if (PageControl1.ActivePage = tsTableProp) then
       SaveTableProperties
      else
       SaveTableFields;
      Dirty := false;
    except
      Result := False;
    end else begin
     if Assigned(AdsTable) then
       ViewTableProp(AdsTable);
     Dirty := False;
    end;
  end;

    if (not pExit) and (not Assigned(AdsTable)) then begin
      MessageDlg('Yeni tabloyu kaydetmeden diðer özelliklerini deðiþtiremezsiniz.',mtInformation, [mbOk], 0);
      Result:= False;
      exit;
    end;

end;

procedure TFmTableDesign.lvTriggerChanging(Sender: TObject;
  Item: TListItem; Change: TItemChange; var AllowChange: Boolean);
begin
  inherited;
  if (Change=ctState) then begin
    if TrgSaveException then
       AllowChange := False
    else begin
       AllowChange := SaveTriggerConfirm;
       if (not Dirty) and (Item.Caption <>'') and (Item.Caption <>edTrgName.Text) and
          (TrgMode<>emNone) then ViewTriggerDetail(Item.Caption);
    end;
  end;
end;

procedure TFmTableDesign.lvTriggerMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  TrgSaveException := False;
end;

function TFmTableDesign.SaveTriggerConfirm: boolean;
  var msg: string;
begin
  Result := true;
  if Dirty and (trgmode <> emnone)then begin
    if TrgMode=emNew then
       msg := 'Eklediðiniz '+edTrgName.Text +' isimli tetikleyici kaydedilsin mi?'
    else
       msg := edTrgName.Text +' isimli tetikleyicide yaptýðýnýz deðiþiklikler kaydedilsin mi?';

    if MessageDlg(msg, mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
       try
         SaveTrigger;
       except on e: Exception do
         begin
           TrgSaveException := True;
           Result := False;
           MessageDlg(e.message, mtConfirmation, [mbOk], 0)
         end;
       end;
    end else begin
       Dirty := False;
       if (TrgMode = emNew) then begin
          TrgMode := emNone;
          lvTrigger.Items[lvTrigger.Items.Count -1].Delete;
          if lvTrigger.Items.Count <> 0 then begin
            TrgMode := emEdit;
            lvTrigger.ItemIndex := lvTrigger.Items.Count -1;
          end;
       end;
    end;
  end;
end;

procedure TFmTableDesign.sbDelClick(Sender: TObject);
  var continue: boolean;
begin
  inherited;
  if lvTrigger.Selected=nil then exit;
  if lvTrigger.Selected.Caption <>'' then begin
    continue := MessageDlg(lvTrigger.Selected.Caption +' isimli tetikleyici kalýcý olarak silinecektir.' +chr(13)+
                'Devam etmek istiyor musunuz?', mtConfirmation, [mbYes, mbNo], 0) = mrYes;
    if continue then Dictionary.RemoveTrigger(edTrgName.Text);
  end else continue := True;

  if continue then begin
    Dirty := False;
    TrgMode := emNone;
    lvTrigger.Items[lvTrigger.Selected.Index].Delete;
    if lvtrigger.Items.Count <> 0 then begin
      TrgMode := emEdit;
      lvTrigger.ItemIndex := lvTrigger.Items.Count -1;
    end;
  end;
end;

procedure TFmTableDesign.btnCancelClick(Sender: TObject);
begin
  Dirty:= False;
  inherited;
end;

procedure TFmTableDesign.IndexListViewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  InxSaveException := False;
end;

procedure TFmTableDesign.ChEncryptClick(Sender: TObject);
  var usCheck:UNSIGNED16;
      propertyLength : UNSIGNED16;
begin
  inherited;
  if ChEncrypt.Checked and (ChEncrypt.Tag<>1) then begin
    propertyLength := sizeof( UNSIGNED16 );
    try
      Dictionary.GetDatabaseProperty( ADS_DD_ENCRYPT_NEW_TABLE,
                                      @usCheck,
                                       propertyLength );
    except
       ON E : EAdsDatabaseError do
       begin
         ChEncrypt.Checked := False;
         raise Exception.Create('Veri Tabaný Tablo Þifreleme özelliði okunamadý.'+chr(13)+ e.Message);
       end;
    end;
    if usCheck <> 1 then begin
       MessageDlg('Veri tabaný Tablo Þifreleme özelliði aktif deðil.'+chr(13)+
                  'Önce veri tabaný özelliklerinden Tablo Þifreleme seçeneðini aktif yapýnýz.',
                  mtInformation,[mbOk],0);
       ChEncrypt.Checked := false;
    end else Dirty := True;
  end else Dirty := True;
end;

procedure TFmTableDesign.tsGeneralShow(Sender: TObject);
begin
  inherited;
  grFields.Row :=1;
  grfields.Col :=0;
  grFields.SetFocus;
  grfields.EditorMode := True;
end;

procedure TFmTableDesign.rbIndexClick(Sender: TObject);
begin
  inherited;
  InxPages.PageIndex := 0;
  CbPageSize.ItemIndex := 0;
end;

procedure TFmTableDesign.rbFTSIndexClick(Sender: TObject);
begin
  inherited;
  if cbIndexField.Items.Count = 0 then
    MessageDlg('Tablo içerik arama indeksi oluþturulacak alana sahip deðildir.'+chr(13)+
               'Tablo Character, Varchar, Memo, Raw, Binary, Image'+chr(13)+
               'tiplerinden birine sahip en az bir alan içermelidir.', mtInformation,[mbOk],0)
  else begin
    InxPages.PageIndex := 1;
    CbPageSize.ItemIndex := 1;
  end;
end;


procedure TFmTableDesign.grFieldsRowChanging(Sender: TObject; OldRow,
  NewRow: Integer; var Allow: Boolean);
  var mField : TAdsField;
begin
  inherited;

  // validate field
  if ((grFields.Cells[0,OldRow]='') and (grFields.Cells[1,OldRow]<>'')) or
     ((grFields.Cells[0,OldRow]<>'') and (grFields.Cells[1,OldRow]='')) then begin
     MessageDlg('Alan bilgilerini tamamlayýnýz veya alaný siliniz',mtInformation, [mbok],0);
     Allow := False;
     exit;
  end;


  // field icin nesne yoksa yarat
  if (grFields.Cells[0,OldRow]<>'') and
     (not Assigned(grFields.Objects[0,OldRow])) then begin
     mField := TAdsField.Create;
     grFields.Objects[0,OldRow] := mField;
  end else
    mField := TAdsField(grFields.Objects[0,OldRow]);

  // field nesnesinin ozelliklerini set et
  if Assigned(mField) then
     GridToField(mfield, OldRow);

  // yeni satirdaki alanýn ozelliklerini goster
  if Assigned (grFields.Objects[0,NewRow]) then
    ShowFieldDesc( TAdsField(grFields.Objects[0,NewRow]))
  else
    FieldTypeChange('');

  // son satýr ise satýr ekle
  if NewRow = grfields.RowCount - 1 then
    grFields.RowCount := grfields.RowCount + 1;
end;

procedure TFmTableDesign.GridToField(mField: TAdsField; OldRow:integer);
  var defType : TFieldType;
begin
  mField.Name := grFields.Cells[0,OldRow];

  defType.usFieldType:= mField.TranslateFieldType(grFields.Cells[1,OldRow]);
  defType.usFieldDecimals := 0;
  if grFields.Cells[2,OldRow]<>'' then
    defType.usFieldLength:=StrToInt(grFields.Cells[2,OldRow]);
  if EdDecimal.Text <>'' then
    defType.usFieldDecimals := StrToInt(EdDecimal.Text);

  mField.Definition := defType;
  mField.NotNull := grFields.Cells[3,OldRow] = 'Y';
  mField.Description := EdDescription.Text;
  mField.MinValue := EdMinVal.Text;
  mField.MaxValue := EdMaxVal.Text;
  mField.DefaultValue := EdDefVal.Text;
  mField.ValidMess := EdValidMes.Text;
  if edStartValue.Visible then begin
     if edStartValue.Text='' then edStartValue.Text := '0';
     mfield.setStartValue(StrToInt(edStartValue.text));
  end;
end;

procedure TFmTableDesign.grFieldsComboChange(Sender: TObject; ACol, ARow,
  AItemIndex: Integer; ASelection: String);
begin
  inherited;
  FieldTypeChange(ASelection);
  grFields.Cells[2, ARow] := GetDefaultLength(ASelection);
  grFields.CellProperties[2,Arow].BrushColor := ObjColor(ASelection='CHARACTER');
  Dirty := True;
end;

procedure TFmTableDesign.grFieldsCanEditCell(Sender: TObject; ARow,
  ACol: Integer; var CanEdit: Boolean);
begin
  inherited;

  if (Acol = 1) and (grfields.Cells[Acol, ARow]='') then begin
    FieldTypeChange('AUTOINC');
    grFields.Cells[2, ARow] := '4';
    grFields.CellProperties[2,Arow].BrushColor := ObjColor(false);
  end;

  if (Acol = 2) and (grFields.Cells[1,Arow]<>'CHARACTER') then CanEdit := False;
end;

procedure TFmTableDesign.grFieldsCellChanging(Sender: TObject; OldRow,
  OldCol, NewRow, NewCol: Integer; var Allow: Boolean);
  var i: integer;
begin
  inherited;
  if (OldCol = 2) and (grFields.Cells[2,OldRow] <>'') then
  try
    i:=StrToInt(grFields.Cells[2,OldRow]);
  except
    MessageDlg('Bu alana nümerik bilgi girilmelidir.',mtInformation,[mbok],0);
    Allow := False;
  end;
end;

procedure TFmTableDesign.EdDecimalChange(Sender: TObject);
begin
  inherited;
  if EdDecimal.Text<>'' then
  try
    StrToInt(EdDecimal.Text);
    Dirty := True;
  except
    MessageDlg('Bu alana nümerik bilgi girilmelidir.',mtInformation,[mbok],0);
    EdDecimal.Text := '';
  end;
end;

procedure TFmTableDesign.edStartValueChange(Sender: TObject);
begin
  inherited;
  if edStartValue.Text<>'' then
  try
    StrToInt(edStartValue.Text);
    Dirty := True;
  except
    MessageDlg('Bu alana nümerik bilgi girilmelidir.',mtInformation,[mbok],0);
    edStartValue.Text := '';
  end;
end;

procedure TFmTableDesign.tbFiledUpClick(Sender: TObject);
begin
  inherited;
  if (grFields.Row > 1) and (grfields.Cells[0,grfields.Row]<>'') then
        SwapField(grFields.Row, grFields.Row- 1);

end;

procedure TFmTableDesign.tbFieldDownClick(Sender: TObject);
begin
  inherited;
  if (grFields.Row < grfields.RowCount) and (grfields.Cells[0,grfields.Row]<>'')
     and (grfields.Cells[0,grfields.Row + 1]<>'') then
        SwapField(grFields.Row,grFields.Row +1);

end;

procedure TFmTableDesign.SwapField(Inx1, Inx2 :Integer);
  var mField1, mfield2 : TAdsField;
begin
  grFields.Col := 0;
  grfields.Row := Inx2;
  if grfields.Row = Inx2 then begin
    mField1 := TadsField(grFields.Objects[0,Inx1]);
    mField2 := TadsField(grFields.Objects[0,Inx2]);
    grfields.SwapRows(Inx1, Inx2);
    grFields.Objects[0,Inx1] := mField2;
    grfields.Objects[0,Inx2] := mField1;
    ShowFieldDesc(mField1);
    grfields.SelectRange(0,3,Inx2,Inx2);
  end;
end;

procedure TFmTableDesign.grFieldsCellsChanged(Sender: TObject; R: TRect);
begin
  inherited;
  Dirty := True;
end;

procedure TFmTableDesign.SaveTableFields;
  var
  fFieldList :TFieldList;
  mRow, i: integer;
  fType: String;
  TableFileName: string;
begin
  grfields.Col := 0;
  mRow := grFields.Row ;
  grfields.Row := mRow + 1;
  if grfields.Row <> mRow + 1 then exit;
  grFields.Row := grfields.Row - 1;

  if mode=emNew then begin
     AdsTable:=TDbAdsTable.Create(Dictionary,'NewTable');
     fFieldList:=TFieldList.create( Dictionary,'NewTable');
     adsTable.Fields:=fFieldList;

     for i:=1 to grFields.RowCount do
       if Assigned(grFields.Objects[0,i]) then
          AdsTable.Fields.AddField(TAdsField(grFields.Objects[0,i]));

     if AdsTable.Fields.FieldCount<=0 then
        raise Exception.Create('Tablo alanlarý girilmelidir.');

     TableNameDial.InitialDir:=AdsTable.getDefaultTablePath;
     with TFmGetTableName.Create(nil) do
     try
       if Execute(AdsTable.getDefaultTablePath) <> '' then
       begin
         TableFileName := GetFullTableName;
         AdsTable.CreateAdsTable(TableFileName);
         MessageDlg('Tablo baþarýyla yaratýldý ve veri sözlüðüne eklendi.'
                    ,mtInformation, [mbOk], 0);

         Item := AdsTable.Name;
         Mode := emEdit;
         ViewTableProp(AdsTable);
         Dirty := False;
       end else Abort;
     finally
       Free;
     end;
   end else
     if Mode = emEdit then RestructureTable;

end;
procedure TFmTableDesign.SaveTableProperties;
begin
  if EdDesc.Modified then
    AdsTable.Description:=EdDesc.Text;
  if EdRecLevelConst.Modified then
    AdsTable.ValidationExpression:=EdRecLevelConst.Text;
  if EdFailValidMess.Modified then
    AdsTable.ValidationMessage:=EdFailValidMess.Text;

  if AdsTable.Encrypted<>ChEncrypt.Checked then
    if ChEncrypt.Checked then
       AdsTable.Encrypt
    else AdsTable.Decrypt;
    if ChAutoCreate.Checked then
       AdsTable.AutoCreate:=true
    else AdsTable.AutoCreate:=false;

  AdsTAble.PermissionLevel:=CPerLevel.ItemIndex+1;

  AdsTable.SaveProperties;
  EdDesc.Modified := False;
  EdRecLevelConst.Modified := False;
  EdFailValidMess.Modified := False;
  dirty:=False;
  MessageDlg('Deðiþiklikler kaydedildi.',mtConfirmation, [mbOk], 0);
end;

procedure TFmTableDesign.tbAddFieldClick(Sender: TObject);
   var mrow : Integer;
begin
  inherited;
  if (grFields.Row > 0) then begin
     mrow := grFields.Row;
     grfields.Col := 0;
     grFields.Row :=mRow + 1;
     if grFields.Row = mRow +1 then begin
       grFields.Row := mRow;
       grfields.InsertRows(mRow,1);
       grFields.Row := mRow;
     end;
  end;
end;

procedure TFmTableDesign.tbDelFieldClick(Sender: TObject);
  var i : integer;
      mField1, mField2 : TAdsField;
begin
  inherited;
  if (grFields.Row > 0) then begin
     grFields.Col := 0;
     // edit modda kaydedilmis alaný silecekse sor
     if (mode = emEdit) and Assigned(grFields.Objects[0, grFields.Row]) then
        if TAdsField(grFields.Objects[0, grFields.Row]).OldName <> '' then
           if MessageDlg(grFields.Cells[0,grFields.Row]+' isimli alaný tablodan çýkartmak '+
                        'istediðinize emin misiniz?',mtConfirmation, [mbYes,mbNo], 0)= mrNo then exit;
     for i:= grFields.Row to grfields.RowCount-2 do begin
       mField1 := TadsField(grFields.Objects[0,i]);
       mField2 := TadsField(grFields.Objects[0,i+1]);
       grfields.SwapRows(i, i+1);
       grFields.Objects[0,i] := mField2;
       grfields.Objects[0,i+1] := mField1;
     end;
     grFields.Rows[grfields.RowCount -1].Clear;
     grfields.Objects[0, grfields.RowCount - 1].Free;

     ShowFieldDesc(TadsField(grFields.Objects[0,grFields.Row]));
     grfields.SelectRange(0,3,grFields.Row,grFields.Row);

  end;
end;

procedure TFmTableDesign.RestructureTable;
  var
  mAddFields, mChangeFields, mDelFields : string;
  i : integer;
  mFieldPos, mTableFieldPos : Integer;
  mTableField, mField :TadsField;
  delFields, gridFields : TStringList;
begin

     // alan adý degistirip yeniden eklenenleri duzelt
     for mFieldPos := 1 to grfields.RowCount - 1 do
        if Assigned(grFields.Objects[0,mFieldPos]) then begin
           mField := TAdsField(grFields.Objects[0,mFieldPos]);
           for mTableFieldPos := 1 to grfields.RowCount - 1 do
             if Assigned(grFields.Objects[0,mTableFieldPos]) then begin
                mTableField := TAdsField(grFields.Objects[0,mTableFieldPos]);
                if (mField.Name = mTableField.OldName) and (mFieldPos <> mTableFieldPos) then begin
                    mField.OldName := mTableField.OldName;
                    mTableField.OldName := '';
                end;
             end;
        end;

     // silinip yeniden eklenenleri duzelt
     for mFieldPos := 1 to grfields.RowCount - 1 do
        if Assigned(grFields.Objects[0,mFieldPos]) then begin
           mField := TAdsField(grFields.Objects[0,mFieldPos]);
           if mField.OldName ='' then
              if AdsTable.Fields.FieldIndex[mField.Name] <> 0 then
                 mField.OldName := mField.Name;
        end;

     mFieldPos := 0;
     for i:=1 to grFields.RowCount - 1 do begin
        if Assigned(grfields.Objects[0,i]) then begin
           mField := TAdsField(grFields.Objects[0,i]);
           mFieldPos := mFieldPos + 1;
           if mField.OldName = '' then begin
             // eklenen alanlar
             if mfield.FieldType ='AUTOINC' then
                mAddFields := mAddFields + mField.Name + ',' + mField.FieldType + ',' +
                              IntToStr(mfield.getStartValue) + ',' +
                              IntToStr(mField.Definition.usFieldDecimals)+ ',(' +
                              IntToStr(mFieldPos)+');'

             else
                mAddFields := mAddFields + mField.Name + ',' + mField.FieldType + ',' +
                              IntToStr(mField.Definition.usFieldLength) + ',' +
                              IntToStr(mField.Definition.usFieldDecimals) + ',(' +
                                     IntToStr(mFieldPos)+');';
           end else begin
             // degisen alanlar
             mTableField := AdsTable.Fields.FieldByName[mField.OldName];
             mTableFieldPos := AdsTable.Fields.FieldIndex[mField.OldName];
             // alan degisti ise
             if (mField.Name <> mField.OldName) or (mField.FieldType <> mTableField.FieldType) or
                (mFieldPos <> mTableFieldPos) or
                (mField.Definition.usFieldLength <> mTableField.Definition.usFieldLength) or
                (mField.Definition.usFieldDecimals <> mTableField.Definition.usFieldDecimals) or
                ((mfield.FieldType='AUTOINC') and (mfield.getStartValue <> mTableField.getStartValue)) then
                 if  mField.FieldType='AUTOINC' then
                    mChangeFields := mChangeFields + mfield.OldName + ',' + mfield.Name + ','+
                                     mField.FieldType + ',' +
                                     IntToStr(mfield.getStartValue) + ',' +
                                     IntToStr(mField.Definition.usFieldDecimals)+ ',(' +
                                     IntToStr(mFieldPos)+');'
                 else
                    mChangeFields := mChangeFields + mfield.OldName + ',' + mfield.Name + ','+
                                     mField.FieldType + ',' +
                                     IntToStr(mfield.Definition.usFieldLength) + ',' +
                                     IntToStr(mField.Definition.usFieldDecimals)+ ',(' +
                                     IntToStr(mFieldPos)+');';
           end;
        end;
     end;

   gridFields := TStringList.Create;
   try
     for mFieldPos := 1 to grfields.RowCount - 1 do
        if Assigned(grFields.Objects[0,mFieldPos]) then
           gridFields.Add(UpperCase(TAdsField(grFields.Objects[0,mFieldPos]).OldName));

     gridfields.Sort;

     for i:= 0 to AdsTable.Fields.FieldCount - 1 do
        if not gridFields.Find(UpperCase(AdsTable.Fields.Field[i].Name),mTableFieldPos) then
           mDelFields := mDelFields + AdsTable.Fields.Field[i].Name + ';';

   finally
     gridFields.Free;
   end;

   if (mAddFields<>'') or (mChangeFields <>'') or (mDelFields<>'') then begin
     // alanlar degisti
     if MessageDlg( 'Tablonun yeniden yapýlandýrýlmasý sonucunda doðabilecek veri bozulamalarýna karþý '+
                     Item+'.bak adýnda bir yedeði otomatik alýnacaktýr. '+
                     Item+' tablosu yeniden yapýlandýrýlacak devam edecek misiniz ?',
                     mtConfirmation, [ mbYES, mbNO ], 0 ) = mrNO  then  exit;

      AdsTable.RestructureAdsTable(mAddFields,mChangeFields,mDelFields);
      AdsTable.Dictionary.Disconnect;
      AdsTable.Dictionary.Connect;
      AdsTable.Fields.Clear;
      for i:=1 to grFields.RowCount do
        if Assigned(grFields.Objects[0,i]) then begin
           mField := TAdsField(grFields.Objects[0,i]);
           mField.OldName := mField.Name;
           mField.TableName := Item;
           mField.Dictionary := AdsTable.Dictionary;
           AdsTable.Fields.AddField(mField);
        end;
   end else begin
     // alan ozellikleri degisti
      for i:=1 to grFields.RowCount do
        if Assigned(grFields.Objects[0,i]) then begin
           mField := TAdsField(grFields.Objects[0,i]);
           mTableField := AdsTable.Fields.FieldByName[mField.Name];
           mTableField.SetProperties(mField);
        end;
   end;

   AdsTable.SaveProperties;
   ViewTableProp(AdsTable);
   Dirty := False;


end;

procedure TFmTableDesign.EdDescriptionChange(Sender: TObject);
begin
  inherited;
  Dirty := True;
end;

procedure TFmTableDesign.EdMinValChange(Sender: TObject);
begin
  inherited;
  Dirty := True;
end;

procedure TFmTableDesign.EdMaxValChange(Sender: TObject);
begin
  inherited;
  Dirty := True;
end;

procedure TFmTableDesign.EdDefValChange(Sender: TObject);
begin
  inherited;
  Dirty := True;
end;

procedure TFmTableDesign.EdValidMesChange(Sender: TObject);
begin
  inherited;
  Dirty := True;
end;

procedure TFmTableDesign.FormClose(Sender: TObject;
  var Action: TCloseAction);
  var Allow : Boolean;
begin
  inherited;
  try
  if not FormSave(True) then
     Action := caNone;
  except
  end;   
end;

procedure TFmTableDesign.grFieldsCellValidate(Sender: TObject; ACol,
  ARow: Integer; var Value: String; var Valid: Boolean);
begin
  inherited;
  if Acol=1 then
     grFieldsComboChange(grFields, ACol, ARow, 0, Value);
end;

procedure TFmTableDesign.grFieldsCheckBoxClick(Sender: TObject; ACol,
  ARow: Integer; State: Boolean);
begin
  inherited;
  Dirty := True;
end;

end.






