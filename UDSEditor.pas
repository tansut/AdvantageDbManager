unit UDSEditor;

interface

uses
  Windows, Messages, XPMenu, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, ImgList, Grids, DBGrids, RXDBCtrl, ComCtrls, ToolWin, adsdata,
  adsfunc, adstable,adscnnct, ExtCtrls, DBCtrls, Buttons, Menus,UBlob, RzButton,
  RzPanel, RzSplit, RzPrgres, RzStatus,jobthrd, StdCtrls, RzLabel,
  indexcombo, Provider, DBClient,ACE,AdsDictionary, ActnList;

type
  TFmDSEditor = class(TForm)
    XPMenu1: TXPMenu;
    DsSource: TDataSource;
    pnCommnads: TPanel;
    DBNavigator1: TDBNavigator;
    ImpFile: TOpenDialog;
    ExportFile: TSaveDialog;
    pnTableFilters: TRzSizePanel;
    RzSplitter1: TRzSplitter;
    RxDBGrid1: TRxDBGrid;
    OrderByIndexCombo: TdrmIndexCombo;
    RzLabel1: TRzLabel;
    RzSpacer2: TRzSpacer;
    ScopeBeginEdit: TEdit;
    ScopeEndEdit: TEdit;
    ScopeBtn: TBitBtn;
    RzSpacer3: TRzSpacer;
    RzSpacer4: TRzSpacer;
    SetFilterBtn: TBitBtn;
    FilterEdit: TEdit;
    FilterShape: TShape;
    RzLabel2: TRzLabel;
    ExactCheckBox: TCheckBox;
    Seekedit: TEdit;
    RzLabel3: TRzLabel;
    RzSpacer5: TRzSpacer;
    btnGotoRecord: TBitBtn;
    GotoEdit: TEdit;
    RzLabel4: TRzLabel;
    RecordCountCheck: TCheckBox;
    SequencedCheckBox: TCheckBox;
    RzSpacer6: TRzSpacer;
    ClearFilterBtn: TBitBtn;
    RzLabel5: TRzLabel;
    PopupMenu1: TPopupMenu;
    XML1: TMenuItem;
    AVD1: TMenuItem;
    blobPopup: TPopupMenu;
    BilgiyiGster1: TMenuItem;
    N1: TMenuItem;
    DosyadanAlanaYkle1: TMenuItem;
    AlandanDosyayaYkle1: TMenuItem;
    Label1: TLabel;
    RzLabel6: TRzLabel;
    ChkFilterRecCount: TCheckBox;
    ChkScobeRecCount: TCheckBox;
    ImgSmall: TImageList;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ActionList1: TActionList;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    AcPack: TAction;
    AcReIndex: TAction;
    AcEmpty: TAction;
    AcImport: TAction;
    AcExport: TAction;
    AcRepair: TAction;
    AcHelp: TAction;
    AcEdit: TAction;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    StatusBar1: TRzStatusBar;
    JobProgBar: TRzProgressBar;
    StatusRecord: TRzStatusPane;
    StatusPane: TRzStatusPane;

    procedure RxDBGrid1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RxDBGrid1DblClick(Sender: TObject);
    procedure JobFinished( Sender: TObject );
    procedure BtnExitClick(Sender: TObject);
    procedure BtnExportClick(Sender: TObject);
    procedure BtnImportClick(Sender: TObject);
    procedure BtnPacktableClick(Sender: TObject);
    procedure BtnUndoClick(Sender: TObject);
    procedure BtnDeleteClick(Sender: TObject);
    procedure BtnReindexClick(Sender: TObject);
    procedure BtnRecycleClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    function SQLString(s:String;fType:TAdsFieldTypes):String;
    procedure OrderByIndexComboChange(Sender: TObject);
    procedure ScopeBtnClick(Sender: TObject);
    procedure SetFilterBtnClick(Sender: TObject);
    procedure SeekeditChange(Sender: TObject);
    procedure btnGotoRecordClick(Sender: TObject);
    procedure ClearFilterBtnClick(Sender: TObject);
    procedure SequencedCheckBoxClick(Sender: TObject);
    procedure RecordCountCheckClick(Sender: TObject);
    procedure DsSourceDataChange(Sender: TObject; Field: TField);
    procedure BtnRestructClick(Sender: TObject);
    procedure BilgiyiGster1Click(Sender: TObject);
    procedure blobPopupPopup(Sender: TObject);
    procedure DosyadanAlanaYkle1Click(Sender: TObject);
    procedure AlandanDosyayaYkle1Click(Sender: TObject);
    procedure ChkFilterRecCountClick(Sender: TObject);
    procedure ChkScobeRecCountClick(Sender: TObject);
    procedure FilterEditKeyPress(Sender: TObject; var Key: Char);
    procedure GotoEditKeyPress(Sender: TObject; var Key: Char);
    procedure Verik1Click(Sender: TObject);
    procedure VeriYkle1Click(Sender: TObject);
    procedure RxDBGrid1TitleBtnClick(Sender: TObject; ACol: Integer;
      Field: TField);
    procedure AcExportExecute(Sender: TObject);
    procedure AcRepairExecute(Sender: TObject);
    procedure AcHelpExecute(Sender: TObject);
  private
    FAdsDataSet: TAdsExtendedDataSet;
    FConnection: TAdsConnection;
    FoDbUtilThrd: TDbUtilThread;
    function GetIndexName(Const FieldName: string): string;
    function GetIsReadOnly: Boolean;
    procedure SetIsReadOnly(const Value: Boolean);

  public
    bJobInProgress:Boolean;
    Dictionary:TAdsDictionary;
    procedure SetConnection(conn:TAdsConnection);
    function Execute(AdsDataSet: TAdsExtendedDataSet; ForceReadOnly: Boolean = False): Boolean;
    procedure Prepare(AdsDataSet: TAdsExtendedDataSet; ForceReadOnly: Boolean = False);
    property AdsDataSet: TAdsExtendedDataSet read FAdsDataSet;
    procedure AlanaDosyaAta;
    procedure DosyayaAlanAta;
    property IsReadOnly: Boolean read GetIsReadOnly write SetIsReadOnly;
  end;


implementation

uses UDataOperations,UAdsTable,UDBItems, UFmDataExport;
{$R *.DFM}

{ TFmDSEditor }

function TFmDSEditor.Execute(AdsDataSet: TAdsExtendedDataSet; ForceReadOnly: Boolean = False): Boolean;
begin
  Prepare(AdsDataSet, ForceReadOnly);
  ShowModal;
end;


procedure TFmDSEditor.Prepare(AdsDataSet: TAdsExtendedDataSet; ForceReadOnly: Boolean = False);
begin
  FAdsDataSet := AdsDataSet;
  DsSource.DataSet := FAdsDataSet;
  bJobInProgress:=false;
  if FAdsDataSet is TAdsTable then
    Caption:=TAdsTable(FAdsDataSet).TableName;
  if not FAdsDataSet.Active then
    FAdsDataSet.Open;
  if ForceReadOnly then
    IsReadOnly := True
  else
    IsReadOnly := GetIsReadOnly;
end;

procedure TFmDSEditor.RxDBGrid1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  tempFilter:string;
  tempType:TAdsBinaryTypes;
  StreamFile : TFileStream;
begin
  {
     ImpFile.Title:='Alana Dosya Ata';
     if RxDBGrid1.SelectedField.DataType = ftMemo then begin
        ImpFile.Filter:='Memo Alaný Dosyasý (*.TXT)|*.txt';
        tempType:=btBINARY;
     end else begin
        ImpFile.Filter:='';//GraphicFilter(TGraphic);
        tempType:=btIMAGE;
     end;
     if ImpFile.Execute then begin
        DsSource.Edit;
        TBlobField(RxDBGrid1.SelectedField).LoadFromFile(ImpFile.FileName);
     end;
     ImpFile.Filter:=tempFilter;
   end;
   }
end;

procedure TFmDSEditor.RxDBGrid1DblClick(Sender: TObject);
var
  tBuffer : pchar;
  fmBlob:TFmBlob;
begin
  if RxDBGrid1.SelectedField.DataType in [ftTypedBinary] then
    exit;
  if RxDBGrid1.SelectedField.DataType in [ftMemo,ftBlob] then begin
    fmBlob:=TfmBlob.Create(nil);
    with FmBlob do try

      poImage.DataSource :=DsSource ;
      poMemo.DataSource := DsSource;
      strFieldName := RxDBGrid1.SelectedField.FieldName;

      if ( RxDBGrid1.SelectedField.DataType = ftBlob ) then
        begin
          FmBlob.poImage.DataField := RxDBGrid1.SelectedField.FieldName;
          FmBlob.poImage.BringToFront;
          FmBlob.Caption := '[ Resim Dosyasý ] Alan: ' + RxDBGrid1.SelectedField.FieldName; ;
        end
      else if( RxDBGrid1.SelectedField.DataType = ftMemo ) then
        begin
          FmBlob.poMemo.DataField := RxDBGrid1.SelectedField.FieldName;
          FmBlob.poMemo.BringToFront;
          FmBlob.Caption := '[ Memo Verisi ] Alan: ' + RxDBGrid1.SelectedField.FieldName; ;
        end;
      ShowModal();
      if( RxDBGrid1.SelectedField.DataType = ftMemo ) and fmblob.poMemo.Modified then begin
        DsSource.Edit;
        TBlobField(RxDBGrid1.SelectedField).Value := fmblob.poMemo.Lines.Text;
      end
    finally
      fmBlob.Free;
    end;
  end;
end;

procedure TFmDSEditor.JobFinished(Sender: TObject);
begin

  StatusPane.Caption := '';
   bJobInProgress := false;
   TAdsTable(FAdsDataSet).Open();
   JobProgBar.PartsComplete := 0;
   pnCommnads.Enabled:=true;
   pnTableFilters.Enabled:=true;
   DsSource.Enabled := true;

end;

procedure TFmDSEditor.BtnExitClick(Sender: TObject);
begin
  close;
end;

procedure TFmDSEditor.BtnExportClick(Sender: TObject);
var
  i:integer;
  temp:string;
begin
 if bJobInProgress then
   begin
      MessageDlg( 'Yapýlmakta olan bir iþ bitmeden bu iþ baþlatýlamaz.',
                  mtInformation,
                  [ mbOK ],
                  0 );
      exit;
   end;
   StatusPane.Caption:='Veri Çýkýlýyor...';
   with TFmDataOperations.Create(nil) do try
        prepare(TAdsTable(FAdsDataSet),FConnection,opExport);
        execute;
   finally
      free;
   end;
   StatusPane.Caption:='';
end;

procedure TFmDSEditor.BtnImportClick(Sender: TObject);
var
  FImp:TextFile;
  i:integer;
  temp,pSQL:string;
  adsSql:TAdsQuery;
  recCount:Longint;
begin
  if bJobInProgress then
  begin
      MessageDlg( 'Yapýlmakta olan bir iþ bitmeden bu iþ baþlatýlamaz.',
                  mtInformation,
                  [ mbOK ],
                  0);
      exit;
  end;
   StatusPane.Caption:='Veri Yükleniyor...';
   with TFmDataOperations.Create(nil) do try
        prepare(TAdsTable(FAdsDataSet),FConnection,opImport);
        execute;
   finally
      free;
   end;
   StatusPane.Caption:='';
end;

procedure TFmDSEditor.BtnPacktableClick(Sender: TObject);
begin
   if bJobInProgress then
   begin
      MessageDlg( 'Yapýlmakta olan bir iþ bitmeden bu iþ baþlatýlamaz.',
                  mtInformation,
                  [ mbOK ],
                  0 );
      exit;
   end;

   if MessageDlg( 'Silinmiþ olan tüm kayýtlarý kaybedeceksiniz , devam edecek misiniz?',
                  mtConfirmation,
                  [mbYES, mbNO],
                  0 ) = mrNO then
      exit;

   TAdsTable(FAdsDataSet).Close;

   StatusPane.Caption := 'Tablo Güncelleniyor...';
   DsSource.Enabled := false;

   if( FConnection.AliasName <> '' ) then
      FoDbUtilThrd := TDbUtilThread.Create( TAdsTable(FAdsDataSet),
                                            FConnection.AliasName,
                                            Self,
                                            jtPackTable,'' )
   else
      FoDbUtilThrd := TDbUtilThread.Create( TAdsTable(FAdsDataSet),
                                            FConnection.ConnectPath,
                                            Self,
                                            jtPackTable,'' );
   FoDbUtilThrd.OnTerminate := JobFinished;
   bJobInProgress := true;

end;

procedure TFmDSEditor.SetConnection(conn: TAdsConnection);
begin
  FConnection:=conn;
end;

procedure TFmDSEditor.BtnUndoClick(Sender: TObject);
begin
   if bJobInProgress then
   begin
      MessageDlg( 'Yapýlmakta olan bir iþ bitmeden bu iþ baþlatýlamaz.',
                  mtInformation,
                  [ mbOK ],
                  0 );
      exit;
   end;

   if MessageDlg( 'Silinen bütün kayýtlar geri alýnacak devam edecek misiniz?',
                  mtConfirmation,
                  [mbYES, mbNO],
                  0 ) = mrNO then
      exit;

   pnCommnads.Enabled:=false;
   pnTableFilters.Enabled:=false;

   TAdsTable(FAdsDataSet).Close();
   StatusPane.Caption := 'Tümü Geri Alýnýyor';
   DsSource.Enabled := false;
   if( FConnection.AliasName <> '' ) then
      FoDbUtilThrd := TDbUtilThread.Create( TAdsTable(FAdsDataSet),
                                            FConnection.AliasName,
                                            Self,
                                            jtRecall_All,'' )
   else
      FoDbUtilThrd := TDbUtilThread.Create( TAdsTable(FAdsDataSet),
                                            FConnection.ConnectPath,
                                            Self,
                                            jtRecall_All,'' );
   FoDbUtilThrd.OnTerminate := JobFinished;
   bJobInProgress := true;

end;

procedure TFmDSEditor.BtnDeleteClick(Sender: TObject);
begin
   if bJobInProgress then
   begin
      MessageDlg( 'Yapýlmakta olan bir iþ bitmeden bu iþ baþlatýlamaz.',
                  mtInformation,
                  [ mbOK ],
                  0 );
      exit;
   end;



   if MessageDlg( 'Bu iþlem sonucunda tablonun tüm kayýtlarý boþaltýlacak, devam edecek misiniz ?',
                  mtWarning,
                  [ mbYES, mbNO ],
                  0 ) = mrNO then
      exit;

   if MessageDlg( 'Tablonun tüm kayýtlarýný boþaltmak istediðinizden emin misiniz?',
                  mtWarning,
                  [ mbYES, mbNO ],
                  0 ) = mrNO then
      exit;
   pnCommnads.Enabled:=false;
   pnTableFilters.Enabled:=false;

   TAdsTable(FAdsDataSet).Close();
   StatusPane.Caption := 'Tablo Boþaltýlýyor...';
   DsSource.Enabled := false;

   if( FConnection.AliasName <> '' ) then
      FoDbUtilThrd := TDbUtilThread.Create( TAdsTable(FAdsDataSet),
                                            FConnection.AliasName,
                                            Self,
                                            jtEmptyTable,'' )
   else
      FoDbUtilThrd := TDbUtilThread.Create( TAdsTable(FAdsDataSet),
                                            FConnection.ConnectPath,
                                            Self,
                                            jtEmptyTable,'' );

   FoDbUtilThrd.OnTerminate := JobFinished;
   bJobInProgress := true;

end;

procedure TFmDSEditor.BtnReindexClick(Sender: TObject);
begin
   if bJobInProgress then
   begin
      MessageDlg( 'Yapýlmakta olan bir iþ bitmeden bu iþ baþlatýlamaz.',
                  mtInformation,
                  [ mbOK ],
                  0 );
      exit;
   end;

   if MessageDlg( 'Tablonun indekslerini yeniden yaratacaksýnýz, devam edecek misiniz?',
                  mtConfirmation,
                  [mbYES, mbNO],
                  0 ) = mrNO then
      exit;

   pnCommnads.Enabled:=false;
   pnTableFilters.Enabled:=false;

   TAdsTable(FAdsDataSet).Close();

   StatusPane.Caption := 'Indeksler Yenileniyor...';
   DsSource.Enabled := false;

   if( FConnection.AliasName <> '' ) then
      FoDbUtilThrd := TDbUtilThread.Create( TAdsTable(FAdsDataSet),
                                            FConnection.AliasName,
                                            Self,
                                            jtReIndex,'' )
   else
      FoDbUtilThrd := TDbUtilThread.Create( TAdsTable(FAdsDataSet),
                                            FConnection.ConnectPath,
                                            Self,
                                            jtReIndex,'' );
   bJobInProgress := true;
   
end;

procedure TFmDSEditor.BtnRecycleClick(Sender: TObject);
begin
   try
      if bJobInProgress then
      begin
         MessageDlg( 'Yapýlmakta olan bir iþ bitmeden bu iþ baþlatýlamaz.',
                     mtInformation,
                     [ mbOK ],
                     0 );
         exit;
      end;
      pnCommnads.Enabled:=false;
      pnTableFilters.Enabled:=false;

      TAdsTable(FAdsDataSet).AdsRecallRecord;
   finally
      pnCommnads.Enabled:=true;
      pnTableFilters.Enabled:=true;
   end;
end;

procedure TFmDSEditor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if bJobInProgress then
   begin
      Action := caNone;
      exit;
   end else
   begin
     FAdsDataSet.Close;
   end;
end;

function TFmDSEditor.SQLString(s: String; fType: TAdsFieldTypes): String;
begin
  if (fType in [AdsfldNUMERIC,AdsfldDOUBLE,AdsfldINTEGER, AdsfldSHORTINT,AdsfldCURDOUBLE]) then
     result:=s
  else begin
    if (ftype in [AdsfldDATE,AdsfldCOMPACTDATE,AdsfldTIME,AdsfldTIMESTAMP]) and (s='') then
      Result:='NULL'
    else
      result:=''''+s+'''';
  end;
end;

procedure TFmDSEditor.OrderByIndexComboChange(Sender: TObject);
begin
   if ( ( OrderByIndexCombo.ItemIndex <> 0 ) and
        ( OrderByIndexCombo.ItemIndex <> -1 ) ) then
      ScopeBtn.Enabled := true
   else
      ScopeBtn.Enabled := false;

   //since active order was changed, reset button caption to 'Scope'.  It might
   //have been set to 'Clear'.  Regardless, when active index changes, scope gets
   //cleared by TAdsTable, so reset caption.
   ScopeBtn.Caption := 'A&ralýk';
end;

procedure TFmDSEditor.ScopeBtnClick(Sender: TObject);
begin
  if( FAdsDataSet.Scoped ) then
   begin
      FAdsDataSet.Scoped := false;
      ScopeBtn.Caption := 'A&ralýk';
   end

   else
   begin
      if( ScopeBeginEdit.Text <> '' ) and
        ( ScopeEndEdit.Text <> '' ) then
      begin
         FAdsDataSet.ScopeBegin := ScopeBeginEdit.Text;
         FAdsDataSet.ScopeEnd := ScopeEndEdit.Text;
         FAdsDataSet.Scoped := true;
         ScopeBtn.Caption := '&Temizle';
      end;
   end;

end;

procedure TFmDSEditor.SetFilterBtnClick(Sender: TObject);
var
   strFilter: string;
   OptLevel: TAdsAOFOptimizeLevel;
begin
   try
      try
         Screen.Cursor := crHourGlass;

         if( FilterEdit.Text <> '' ) then
         begin

            FilterShape.Visible := true;
            FilterShape.Brush.Color := clSilver;

            AdsDataSet.Filter := FilterEdit.Text;
            FAdsDataSet.Filtered := true;

            strFilter := '';
            OptLevel := AdsDataSet.AdsGetAOFOptLevel( strFilter );

            case OptLevel of
               olFULL: FilterShape.Brush.Color := clLime;
               olPART: FilterShape.Brush.Color := clYellow;
               olNONE: FilterShape.Brush.Color := clRed;
               else
                  FilterShape.Visible := false;
            end;//case
         end;

         ClearFilterBtn.BringToFront();

      finally
         Screen.Cursor := crDefault;
      end;

   except
      FilterShape.Visible := false;
      raise;
   end;
end;

procedure TFmDSEditor.SeekeditChange(Sender: TObject);
var
   strSeekKey: string;
begin
   if (AdsDataSet.IndexName = '') AND (FAdsDataSet.IndexFieldNames = '') then
   begin
      if SeekEdit.text <> '' then
      begin
         ShowMessage( 'Arama yapabilmek için bir indeks aktif olmalýdýr. Bir indeks seçtikten sonra arama yapýnýz.');
         SeekEdit.text := '';
      end
   end
   else
   begin
      strSeekKey := SeekEdit.Text;
      if( ExactCheckBox.Checked ) then
      begin
         FAdsDataSet.FindKey([strSeekKey]);
      end
      else
      begin
         FAdsDataSet.FindNearest([strSeekKey]);
      end;
   end;
end;


procedure TFmDSEditor.btnGotoRecordClick(Sender: TObject);
begin
   if( GotoEdit.Text <> '' ) then
      TAdsTable(FAdsDataSet).AdsGotoRecord( StrToInt( GotoEdit.Text ) );
end;

procedure TFmDSEditor.ClearFilterBtnClick(Sender: TObject);
begin
   FAdsDataSet.Filtered := false;
   SetFilterBtn.BringToFront();
   FilterShape.Visible := false;
end;

procedure TFmDSEditor.SequencedCheckBoxClick(Sender: TObject);
begin
   TAdsExtendedDataSet(FAdsDataSet).Sequenced := SequencedCheckBox.Checked;
   if TAdsExtendedDataSet(FAdsDataSet).Sequenced then
     TAdsExtendedDataSet(FAdsDataSet).SequencedLevel := slExact;
end;

procedure TFmDSEditor.RecordCountCheckClick(Sender: TObject);
begin
   FAdsDataSet.Refresh;
end;

procedure TFmDSEditor.DsSourceDataChange(Sender: TObject; Field: TField);
begin
   if( FAdsDataSet.State = dsBrowse ) and
     ( RecordCountCheck.Checked ) then
   begin
      //StatusRecord.Visible:=true;
      try
         If FAdsDataSet.IndexName = '' then
            StatusRecord.Caption := IntToStr( FAdsDataSet.RecNo ) + '/' +
                                                       IntToStr( FAdsDataSet.RecordCount )
         else
            StatusRecord.Caption:= IntToStr( FAdsDataSet.AdsGetKeyNum  ) + '/' +
                                                       IntToStr( FAdsDataSet.AdsGetKeyCount );
      except
      end;
   end
   else
      StatusRecord.Caption := '';

end;



procedure TFmDSEditor.BtnRestructClick(Sender: TObject);
var result: boolean;
    i:integer;
    DbTable: TDBTable;
begin
  TAdsTable(FAdsDataSet).DisableControls;
  TAdsTable(FAdsDataSet).Close;
  FConnection.IsConnected:=true;
  FConnection.Name:='restConn';
  DbTable := TDBTable.Create(self.Dictionary);
  DbTable.SetTitle(TAdsTable(FAdsDataSet).TableName);
  try
    DbTable.SendCommand(dcEdit);
  finally
    DBTable.Free;
    TAdsTable(FAdsDataSet).Open;
    TAdsTable(FAdsDataSet).EnableControls;
  end;

end;

procedure TFmDSEditor.BilgiyiGster1Click(Sender: TObject);
begin
  RxDBGrid1DblClick(self);
end;

procedure TFmDSEditor.blobPopupPopup(Sender: TObject);
begin
  if RxDBGrid1.SelectedField.IsBlob then begin
     BilgiyiGster1.Enabled:=true;
     AlandanDosyayaYkle1.Enabled:=true;
     DosyadanAlanaYkle1.Enabled:=true;
  end else begin
     BilgiyiGster1.Enabled:=false;
     AlandanDosyayaYkle1.Enabled:=false;
     DosyadanAlanaYkle1.Enabled:=false;
  end;
end;

procedure TFmDSEditor.AlanaDosyaAta;
var
  tempFilter:string;
  tempType:TAdsBinaryTypes;
  StreamFile : TFileStream;
begin
//  if  self.Parent<>nil then
  //  exit;
  if (RxDBGrid1.SelectedField.IsBlob) then begin
     tempFilter:=ImpFile.Filter;
     ImpFile.Title:='Alana Dosya Ata';
     if RxDBGrid1.SelectedField.DataType = ftMemo then begin
        ImpFile.Filter:='Memo Alaný Dosyasý (*.TXT)|*.txt';
        tempType:=btBINARY;
     end else begin
        ImpFile.Filter:='';//GraphicFilter(TGraphic);
        tempType:=btIMAGE;
     end;
     if ImpFile.Execute then begin
        DsSource.Edit;
        TBlobField(RxDBGrid1.SelectedField).LoadFromFile(ImpFile.FileName);
     end;
     ImpFile.Filter:=tempFilter;
   end;

end;

procedure TFmDSEditor.DosyadanAlanaYkle1Click(Sender: TObject);
begin
  AlanaDosyaAta;
end;

procedure TFmDSEditor.DosyayaAlanAta;
var
  tempFilter:string;
  tempType:TAdsBinaryTypes;
  StreamFile : TFileStream;
begin
  if (RxDBGrid1.SelectedField.IsBlob) then begin
     tempFilter:=ImpFile.Filter;
     ExportFile.Title:='Alana Dosya Ata';
     if RxDBGrid1.SelectedField.DataType = ftMemo then begin
        ExportFile.Filter:='Memo Alaný Dosyasý (*.TXT)|*.txt';
        tempType:=btBINARY;
     end else begin
        ExportFile.Filter:='';//GraphicFilter(TGraphic);
        tempType:=btIMAGE;
     end;
     if ExportFile.Execute then begin
        TBlobField(RxDBGrid1.SelectedField).SaveToFile(ExportFile.FileName);
     end;
     ExportFile.Filter:=tempFilter;
   end;
end;

procedure TFmDSEditor.AlandanDosyayaYkle1Click(Sender: TObject);
begin
  DosyayaAlanAta;
end;

procedure TFmDSEditor.ChkFilterRecCountClick(Sender: TObject);
begin
  if FAdsDataSet is TAdsTable then
    TAdsTable(FAdsDataSet).AdsTableOptions.AdsFilterOptions := TAdsRespectFilters(ChkFilterRecCount.Checked)
  else if FAdsDataSet is TAdsQuery then
    TAdsQuery(FAdsDataSet).AdsTableOptions.AdsFilterOptions := TAdsRespectFilters(ChkFilterRecCount.Checked);
  FAdsDataSet.Refresh;
end;

procedure TFmDSEditor.ChkScobeRecCountClick(Sender: TObject);
begin
  if FAdsDataSet is TAdsTable then
    TAdsTable(FAdsDataSet).AdsTableOptions.AdsScopeOptions := TAdsRespectScopes(ChkScobeRecCount.Checked)
  else if FAdsDataSet is TAdsQuery then
    TAdsQuery(FAdsDataSet).AdsTableOptions.AdsScopeOptions := TAdsRespectScopes(ChkScobeRecCount.Checked);
  FAdsDataSet.Refresh;
end;

procedure TFmDSEditor.FilterEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    SetFilterBtnClick(nil);
    Key := #0;
  end;
end;

procedure TFmDSEditor.GotoEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    btnGotoRecordClick(nil);
    Key := #0;
  end;

end;

procedure TFmDSEditor.Verik1Click(Sender: TObject);
begin
   StatusPane.Caption:='Veri Çýkýlýyor...';
   with TFmDataOperations.Create(nil) do try
        prepare(RxDBGrid1.DataSource.DataSet,TAdsTable(RxDBGrid1.DataSource.DataSet).AdsConnection,opExport);
        execute;
   finally
      free;
   end;
   StatusPane.Caption:='';
end;

procedure TFmDSEditor.VeriYkle1Click(Sender: TObject);
begin
   StatusPane.Caption:='Veri Çýkýlýyor...';
   with TFmDataOperations.Create(nil) do try
        prepare(RxDBGrid1.DataSource.DataSet,TAdsTable(RxDBGrid1.DataSource.DataSet).AdsConnection,opExport);
        execute;
   finally
      free;
   end;
   StatusPane.Caption:='';
end;

procedure TFmDSEditor.RxDBGrid1TitleBtnClick(Sender: TObject;
  ACol: Integer; Field: TField);
var IndexName: string;
    I: Integer;
begin
  IndexName := GetIndexName(Field.FieldName);
  if IndexName = '' then raise Exception.Create(Field.FieldName + ' isimli alaný içeren indeks tanýmlanmamýþtýr')
  else begin
    I := OrderByIndexCombo.Items.IndexOf(IndexName);
    if I <> -1 then
    begin
      OrderByIndexCombo.ItemIndex := I;
      OrderByIndexCombo.SwitchToIndex;
    end;
  end;
end;

function TFmDSEditor.GetIndexName(const FieldName: string): string;
var I: Integer;
begin
  Result := '';
  try
    if FAdsDataSet.IndexDefs.Updated then
     FAdsDataSet.IndexDefs.Update;
    for I := 0 to FAdsDataSet.IndexDefs.Count - 1 do
    begin
      if AnsiCompareText(Copy(FAdsDataSet.IndexDefs[I].Fields, 1, Length(FieldName)), FieldName) = 0 then
      begin
        Result := FAdsDataSet.IndexDefs[I].Name;
        Break;
      end;
    end;
  except
  end;
end;

procedure TFmDSEditor.AcExportExecute(Sender: TObject);
begin
  with TFmDataExport.Create(nil) do
  try
    ExportDataSet(FAdsDataSet);
  finally
    Free;
  end;    
end;

procedure TFmDSEditor.AcRepairExecute(Sender: TObject);
begin
   if bJobInProgress then
   begin
      MessageDlg( 'Yapýlmakta olan bir iþ bitmeden bu iþ baþlatýlamaz.',
                  mtInformation,
                  [ mbOK ],
                  0 );
      exit;
   end;
   TAdsTable(FAdsDataSet).Close();
   StatusPane.Caption := 'Tablo hatalara karþý kontrol ediliyor ...';
   DsSource.Enabled := false;

   if( FConnection.AliasName <> '' ) then
      FoDbUtilThrd := TDbUtilThread.Create( TAdsTable(FAdsDataSet),
                                            FConnection.AliasName,
                                            Self,
                                            jtRepairTable,'' )
   else
      FoDbUtilThrd := TDbUtilThread.Create( TAdsTable(FAdsDataSet),
                                            FConnection.ConnectPath,
                                            Self,
                                            jtRepairTable,'' );

   FoDbUtilThrd.OnTerminate := JobFinished;
   bJobInProgress := true;
end;

procedure TFmDSEditor.AcHelpExecute(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,54);
end;

function TFmDSEditor.GetIsReadOnly: Boolean;
begin
  if FAdsDataSet is TAdsTable then
    Result := TAdsTable(FAdsDataSet).ReadOnly
  else if FAdsDataSet is TAdsQuery then
    Result := True
  else Result := True;
end;

procedure TFmDSEditor.SetIsReadOnly(const Value: Boolean);
begin
  AcPack.Enabled := not Value;
  AcEmpty.Enabled := not Value;
  AcReIndex.Enabled := not Value;
  AcRepair.Enabled := not Value;
  AcImport.Enabled := not Value;
  AcEdit.Enabled := not Value;

end;

end.

