unit UDBSQL;

interface

uses
  XPMenu,Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UDbOperation, DBActns, StdActns, ActnList, DB, Menus, SynEditHighlighter,
  SynHighlighterSQL, ImgList, adsdata, adsfunc, adstable, RzStatus,
  RzPanel, ComCtrls, Buttons, SynEdit, ExtCtrls, ToolWin, adscnnct,
  MemoComponentUnit, SourceEditUnit, UDsEditor, ACE, UAdvUtils,
  adsdictionary, DBCtrls, syneditkeycmds;

const
    SQL_EXECUTE_SCRIPT = 1;
    SQL_EXECUTE_SINGLE = 0;
type
  TFmSQL = class(TFmDBOperation)
    XPMenu1: TXPMenu;
    AdsQuery: TAdsQuery;
    ToolBar1: TToolBar;
    BtnRunSQL: TToolButton;
    ImageList1: TImageList;
    PnlSQL: TPanel;
    Splitter1: TSplitter;
    PageControl: TPageControl;
    TabResults: TTabSheet;
    TabStats: TTabSheet;
    LV: TListView;
    BtSaveScr: TToolButton;
    btOpenScr: TToolButton;
    OpenScr: TOpenDialog;
    SaveScr: TSaveDialog;
    btTrancStart: TToolButton;
    btCommitTrans: TToolButton;
    btClose: TToolButton;
    btHelp: TToolButton;
    edSQL: TSynEdit;
    shSQL: TSynSQLSyn;
    BtnOptions: TToolButton;
    PopupMenu1: TPopupMenu;
    anmlar1: TMenuItem;
    ShowRecordCountMenuItem: TMenuItem;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton1: TToolButton;
    RzStatusBar1: TRzStatusBar;
    RecordCountPanel: TRzStatusPane;
    InsertStatus: TRzStatusPane;
    LineStatus: TRzStatusPane;
    StatPanel: TRzStatusPane;
    ToolButton5: TToolButton;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    ToolButton6: TToolButton;
    ActionImages: TImageList;
    DataSource1: TDataSource;
    EditorMenu: TPopupMenu;
    sadas: TMenuItem;
    DKMenuItem: TMenuItem;
    N7: TMenuItem;
    Kes2: TMenuItem;
    Kopyala2: TMenuItem;
    Yaptr2: TMenuItem;
    Sil3: TMenuItem;
    Hakknda2: TMenuItem;
    TmnSe2: TMenuItem;
    ActionList1: TActionList;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    EditSelectAll1: TEditSelectAll;
    EditUndo1: TEditUndo;
    EditRedo: TAction;
    DataSetFirst1: TDataSetFirst;
    DataSetPrior1: TDataSetPrior;
    DataSetNext1: TDataSetNext;
    DataSetLast1: TDataSetLast;
    DataSetInsert1: TDataSetInsert;
    DataSetDelete1: TDataSetDelete;
    DataSetPost1: TDataSetPost;
    DataSetCancel1: TDataSetCancel;
    ActionOptions: TAction;
    ActionRefresh: TAction;
    ActionAbout: TAction;
    ActionPrint: TAction;
    FileOpen: TAction;
    FileExit: TAction;
    EditorFont: TAction;
    EditorBckColor: TAction;
    ExportToWord: TAction;
    ExportToHTML: TAction;
    EditDelete2: TEditDelete;
    ActionOpenCat: TAction;
    ActionCloseCat: TAction;
    ViewShowCategory: TAction;
    ViewToolBars: TAction;
    ViewStatusBar: TAction;
    ActionPreview: TAction;
    ViewLineNumbers: TAction;
    ViewEditorLine: TAction;
    HelpDelphiTurk: TAction;
    HelpBook: TAction;
    RecordSend: TAction;
    DeleteSent: TAction;
    EditCopy2: TEditCopy;
    EditCopyAsRTF: TAction;
    DataSetRefresh1: TDataSetRefresh;
    AdsWebSite: TAction;
    AdsPerformance: TAction;
    AdsHelp: TAction;
    AdsSupport: TAction;
    AdsHowToCS: TAction;
    AdsLimits: TAction;
    AdsCodeBankOptions: TAction;
    VersionCheck: TAction;
    SearchAction: TAction;
    EditorWordWrap: TAction;
    SearchTextAction: TAction;
    ActionFindNext: TAction;
    ActionFindPrev: TAction;
    ActionReplace: TAction;
    ReadmeAction: TAction;
    AdsDownloadManual: TAction;
    AdsKALE: TAction;
    AdsDownloadVTY: TAction;
    AdsCust: TAction;
    DataSetEdit1: TDataSetEdit;
    ToolButton18: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton15: TToolButton;
    ToolButton14: TToolButton;
    AdsTable1: TAdsTable;
    ToolButton16: TToolButton;
    StCompression: TRzGlyphStatus;
    procedure FormCreate(Sender: TObject);
    procedure AcOpenExecute(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure EdSQLKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btOpenScrClick(Sender: TObject);
    procedure BtSaveScrClick(Sender: TObject);
    procedure btScrExecuteClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure ConnectionAfterConnect(Sender: TObject);
    procedure btTrancStartClick(Sender: TObject);
    procedure btCommitTransClick(Sender: TObject);
    procedure btHelpClick(Sender: TObject);
    procedure edSQLChange(Sender: TObject);
    procedure BtnOptionsClick(Sender: TObject);
    procedure anmlar1Click(Sender: TObject);
    procedure ShowRecordCountMenuItemClick(Sender: TObject);
    procedure CheckSQLMenuItemClick(Sender: TObject);
    procedure edSQLStatusChange(Sender: TObject;
      Changes: TSynStatusChanges);
    procedure TableListClick(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Splitter1Moved(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure ToolButton6Click(Sender: TObject);
    procedure ToolButton7Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SearchTextActionExecute(Sender: TObject);
    procedure ActionFindNextExecute(Sender: TObject);
    procedure ToolButton13Click(Sender: TObject);
    procedure ActionFindNextUpdate(Sender: TObject);
    procedure edSQLReplaceText(Sender: TObject; const ASearch,
      AReplace: String; Line, Column: Integer;
      var Action: TSynReplaceAction);
    procedure ActionFindPrevExecute(Sender: TObject);
    procedure ActionReplaceExecute(Sender: TObject);
  private
    FDSEditor: TFmDSEditor;
    FSqlList: TStringList;
    SQLIndex: Integer;
    FSearchFromCaret: boolean;
    AutoExecute : Boolean;
    procedure AddToSqlList(const SQL: string);
    procedure ShowRecordCount;
    procedure ShowResultSet;
    procedure HideResultSet;
    procedure ClearStats;
    procedure AddStat(const Prop, Value: string); overload;
    procedure AddStat(const Prop, Value: string; ImgIndex: Integer); overload;
    procedure ShowSearchReplaceDialog(AReplace: boolean);
    procedure DoSearchReplaceText(AReplace: boolean;
                                  ABackwards: boolean);
    
  public
    procedure OpenConnection; override;
    procedure RunSQL(SQL: string);
    procedure Execute(AdsDict: TAdsDictionary; SQL: string); overload; 
  end;

var
  FmSQL: TFmSQL;
  gbSearchBackwards: boolean;
  gbSearchCaseSensitive: boolean;
  gbSearchFromCaret: boolean;
  gbSearchSelectionOnly: boolean;
  gbSearchTextAtCaret: boolean;
  gbSearchWholeWords: boolean;

  gsSearchText: string;
  gsSearchTextHistory: string;
  gsReplaceText: string;
  gsReplaceTextHistory: string;

implementation

uses USqlOptions, UTableInfs, UDSParams, dlgConfirmReplace, dlgReplaceText,
  dlgSearchText;

{$R *.DFM}

procedure TFmSQL.OpenConnection;
begin
  inherited OpenConnection;
  AdsQuery.DatabaseName := Connection.Name;
end;

procedure TFmSQL.FormCreate(Sender: TObject);
var I: Integer;
    TempSQL: String;
begin
  inherited;
  FSearchFromCaret := True;
  FSqlList := TStringList.Create;
  SQLIndex := 0;
  FDSEditor := nil;
  TabResults.TabVisible := False;
  PageControl.ActivePage := TabStats;
  ClearStats;
  edSQL.Lines.Text := ReadRegKey('LastSQL');
  ShowRecordCountMenuItem.Checked := ReadBoolRegKey('ShowQueryRecordCount', False);
  AdsQuery.RequestLive := ReadBoolRegKey('RequestLiveQuery', False);
  I := 0;
  for I := 0 to 10 do
  begin
    TempSQL := ReadRegKey('LastSQLList' + IntToStr(I));
    if Trim(TempSQL) = '' then break;
    FSqlList.Add(TempSQL);
  end;
  AutoExecute := False;
  edSQLStatusChange(nil, [scAll]);
end;

procedure TFmSQL.HideResultSet;
begin
  if Assigned(FDSEditor) then
  begin
    FDsEditor.Hide;
    FDSEditor.Free;
    FDSEditor := nil;
  end;
  TabResults.TabVisible := False;
  PageControl.ActivePage := TabStats;
end;

procedure TFmSQL.ShowResultSet;
begin
  if not Assigned(FDSEditor) then
  begin
    FDSEditor := TFmDSEditor.Create(nil);
    FDSEditor.Position := poDesigned;
    FDSEditor.Left := 0;
    FDSEditor.Top := 0;
    FDSEditor.Parent := TabResults;
    FDSEditor.BorderStyle := bsNone;
    FDSEditor.Prepare(AdsQuery);
    FormResize(Self);
    FDSEditor.Show;
    TabResults.Refresh;
  end;
  //TabResults.TabVisible := False;
  TabResults.TabVisible := True;
  PageControl.ActivePage := TabResults;
  ShowRecordCount;
end;

procedure TFmSQL.RunSQL(SQL: string);
var
  mTime: Cardinal;
begin
  HideResultSet;
  if AdsQuery.Active then AdsQuery.Close;
  AdsQuery.IndexName := '';
  ClearStats;
  if AdsQuery.SQL.Text <> SQL then
   AdsQuery.SQL.Text := SQL;
  mTime := GetTickCount;
  try
    try
      if AdsQuery.ParamCount > 0 then
      with TFmQueryParams.Create(nil) do
      try
        if not Execute(AdsQuery.Params) then
          raise Exception.Create('Ýþlem iptal edildi');
      finally
        Free;
      end;
      if not AdsQuery.Prepared then
        AdsQuery.Prepare;
      AdsQuery.Open;
      AddToSqlList(AdsQuery.SQL.Text);
      mTime := (GetTickCount - mTime) + 1;
      AddStat('Tip', 'Sonuç Kümesi döndüren SQL Cümlesi');
      AddStat('Çalýþma Süresi',IntToStr(mTime)+' Mili Saniye');
      StatPanel.Caption := 'Çalýþma Süresi: ' + IntToStr(mTime)+' Mili Saniye';
      ShowResultSet;
    except
      raise;
    end;
  except
    on E: EAdsDatabaseError do
    begin
      if E.ACEErrorCode = AE_TADSDATASET_GENERAL then
      begin
        mTime := (GetTickCount - mTime) + 1;
        AddStat('Tip', 'Çalýþtýrýlabilen SQL Cümlesi');
        AddStat('Çalýþma Süresi',IntToStr(mTime)+' Mili Saniye');
        StatPanel.Caption := 'Çalýþma Süresi: ' + IntToStr(mTime)+' Mili Saniye';
        AddStat('Ýþlem', IntToStr(AdsQuery.RowsAffected) +' Kayýt Etkilendi...');
        AddToSqlList(AdsQuery.SQL.Text);
        HideResultSet;
      end
      else
      begin
        HideResultSet;
        AddStat('Hata', E.Message);
        raise;
      end;
    end;
  end;

end;

procedure TFmSQL.AcOpenExecute(Sender: TObject);
begin
  inherited;
  if edSQL.Text <> '' then begin
    AdsQuery.Tag:=SQL_EXECUTE_SINGLE;
    RunSQL(EdSQL.Text);
  end;
end;

procedure TFmSQL.FormResize(Sender: TObject);
begin
  inherited;
  if Assigned(FDSEditor) then
    FDSEditor.SetBounds(0, 0, TabResults.Width, TabResults.Height);
end;

procedure TFmSQL.ClearStats;
begin
  LV.Items.Clear;
end;

procedure TFmSQL.AddStat(const Prop, Value: string);
begin
  AddStat(Prop, Value, 0);
end;

procedure TFmSQL.AddStat(const Prop, Value: string; ImgIndex: Integer);
begin
  with LV.Items.Add do
  begin
    Caption := Prop;
    SubItems.Add(Value);
    ImageIndex := ImgIndex;
  end;
end;

procedure TFmSQL.EdSQLKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = 13) and (ssCTRL in Shift) then AcOpenExecute(self);
end;

procedure TFmSQL.btOpenScrClick(Sender: TObject);
begin
  inherited;
  if OpenScr.Execute then
    EdSQL.Lines.LoadFromFile(OpenScr.FileName);
end;

procedure TFmSQL.BtSaveScrClick(Sender: TObject);
begin
  inherited;
  if SaveScr.Execute then begin
    EdSQL.Lines.SaveToFile(SaveScr.FileName);
  end;
end;

procedure TFmSQL.btScrExecuteClick(Sender: TObject);
begin
  inherited;
  if edsql.Text <> '' then begin
    AdsQuery.Tag:=SQL_EXECUTE_SCRIPT;
    RunSQL(EdSQL.Lines.Text);
  end;
end;

procedure TFmSQL.btCloseClick(Sender: TObject);
begin
  inherited;
  close;
end;

procedure TFmSQL.ConnectionAfterConnect(Sender: TObject);
begin
  inherited;
  btTrancStart.Enabled := (UpperCase(Connection.ConnectionType)  <> 'LOCAL') and
                          (UpperCase(Connection.Username) <> 'ADSSYS');

  btCommitTrans.Enabled := False;

  if not btTrancStart.Enabled then
   btTrancStart.Hint := 'Yerel Baðlantý veya '#13#10'Yönetici Kullanýcý (AdsSys) Baðlantýsý'#13#10' yapýldýðýndan iþlem grubu (Transaction) kullanýlamaz'
  else
   btTrancStart.Hint := 'Ýþlem Grubu Baþlat';
end;

procedure TFmSQL.btTrancStartClick(Sender: TObject);
begin
  inherited;
  if btTrancStart.ImageIndex=68 then begin
    Connection.BeginTransaction;
    btTrancStart.ImageIndex:=77;
    btCommitTrans.Enabled:=true;
    btTrancStart.Hint:='Ýþlem Grubunu Ýptal Et';
  end else begin
    Connection.Rollback;
    btTrancStart.ImageIndex:=68;
    btTrancStart.Hint:='Ýþlem Grubu Baþlat';
    btCommitTrans.Enabled:=false;
  end;
end;

procedure TFmSQL.btCommitTransClick(Sender: TObject);
begin
  inherited;
  Connection.Commit;
  btCommitTrans.Enabled:=false;
  btTrancStart.ImageIndex:=68;
  btTrancStart.Hint:='Ýþlem Grubu Baþlat';
  AddStat('Script', 'Ýþlem Grubu Veri Tabanýna Ýþlendi...');
end;

procedure TFmSQL.btHelpClick(Sender: TObject);
begin
  inherited;
  Application.HelpCommand(HELP_CONTEXT,14);
end;

procedure TFmSQL.edSQLChange(Sender: TObject);
begin
  inherited;
  if replace(replace(edsql.Text,chr(10)),chr(13))='' then begin
     BtnRunSQL.Enabled := false;
     //btScrExecute.Enabled := false;
  end else begin
     BtnRunSQL.Enabled := true;
     //btScrExecute.Enabled := true;
  end;


end;

procedure TFmSQL.BtnOptionsClick(Sender: TObject);
begin
  inherited;
  with TFmSqlOptions.Create(nil) do
  try
    ChkRequestLive.Checked := AdsQuery.RequestLive;
    if Execute then
    begin
      if AdsQuery.Active then AdsQuery.Close;
      AdsQuery.RequestLive := ChkRequestLive.Checked;
    end;
  finally
    Free;
  end;
end;

procedure TFmSQL.anmlar1Click(Sender: TObject);
begin
  inherited;
  BtnOptionsClick(nil);
end;

procedure TFmSQL.ShowRecordCountMenuItemClick(Sender: TObject);
begin
  inherited;
  ShowRecordCountMenuItem.Checked := not ShowRecordCountMenuItem.Checked;
  if AdsQuery.Active then
    ShowRecordCount;
end;

procedure TFmSQL.CheckSQLMenuItemClick(Sender: TObject);
begin
  inherited;
  AdsQuery.SQL.Text := edSQL.Lines.Text;
  AdsQuery.VerifySQL;
end;

procedure TFmSQL.edSQLStatusChange(Sender: TObject;
  Changes: TSynStatusChanges);
var
  p: TPoint;
begin
  inherited;
  if Changes * [scAll, scCaretX, scCaretY] <> [] then begin
    p := edSQL.CaretXY;
    LineStatus.Caption := Format('%6d: %3d', [p.Y, p.X]);
  end;
  if Changes * [scAll, scInsertMode, scReadOnly] <> [] then begin
    InsertStatus.Enabled := EdSQL.InsertMode;
  end;
end;


procedure TFmSQL.TableListClick(Sender: TObject);
var Info: string;
begin
  inherited;
  with TFmTables.Create(nil) do
  try
    Info := Execute(Self.Dictionary);
    edSQL.Text := edSQL.Text + Info;
  finally
    Free;
  end;
end;

procedure TFmSQL.ToolButton5Click(Sender: TObject);
begin
  inherited;
  TableListClick(Self);
end;

procedure TFmSQL.Execute(AdsDict: TAdsDictionary; SQL: string);
begin
  edSQL.Text := SQL;
  AutoExecute := True;
  Inherited Execute(AdsDict);
end;

procedure TFmSQL.FormShow(Sender: TObject);
begin
  inherited;
  if (Trim(edSQL.Text) <> '') and AutoExecute then AcOpenExecute(self);
end;

procedure TFmSQL.ShowRecordCount;
begin
  if ShowRecordCountMenuItem.Checked then
   RecordCountPanel.Caption := Format('Toplam: %d', [AdsQuery.RecordCount])
  else
   RecordCountPanel.Caption := '';
end;

procedure TFmSQL.Splitter1Moved(Sender: TObject);
begin
  inherited;
  FormResize(Self);
end;

procedure TFmSQL.FormDestroy(Sender: TObject);
var I: Integer;
begin
  inherited;
  FSqlList.Free;
end;

procedure TFmSQL.AddToSqlList(const SQL: string);
var Index: Integer;
begin
  if (Trim(SQL) = '') then Exit;
  Index := FSqlList.IndexOf(Trim(SQL));
  if (Index <> - 1) then FSqlList.Delete(Index);
  SQLIndex := 0;
  FSqlList.Insert(0, Trim(SQL));
end;

procedure TFmSQL.SpeedButton1Click(Sender: TObject);
begin
  inherited;
  //AddToSqlList(edSQL.Text);
  if SQLIndex > 0 then Dec(SQLIndex)
  else Exit;
  if FSqlList.Count > 0 then
  begin
    edSQL.Text := FSqlList[SQLIndex];
  end;
end;

procedure TFmSQL.SpeedButton2Click(Sender: TObject);
begin
  inherited;
  //AddToSqlList(edSQL.Text);
  if SQLIndex < FSqlList.Count - 1 then
    Inc(SQLIndex)
  else Exit;
  if FSqlList.Count > 0 then
  begin
    edSQL.Text := FSqlList[SQLIndex];
  end;
end;

procedure TFmSQL.ToolButton6Click(Sender: TObject);
begin
  inherited;
  AddToSqlList(edSQL.Text);
  edSQL.Lines.Clear;
end;

procedure TFmSQL.ToolButton7Click(Sender: TObject);
begin
  inherited;
  with TFmQueryParams.Create(nil) do
  try
   Execute(AdsQuery.Params);
  finally
   Free;
  end;

end;

procedure TFmSQL.FormClose(Sender: TObject; var Action: TCloseAction);
var I: Integer;
begin
  inherited;
  WriteRegKey('LastSQL', edSQL.Text);
  WriteBoolRegKey('ShowQueryRecordCount', ShowRecordCountMenuItem.Checked);
  WriteBoolRegKey('RequestLiveQuery', AdsQuery.RequestLive);
  if FSqlList.Count > 10 then
    while FSqlList.Count > 10 do
      FSqlList.Delete(10);
  for I := 0 to FSqlList.Count - 1 do
    WriteRegKey('LastSQLList' + IntToStr(I), FSqlList[I]);
  Action := caFree;
end;

procedure TFmSQL.SearchTextActionExecute(Sender: TObject);
begin
  inherited;
  ShowSearchReplaceDialog(False);
end;

procedure TFmSQL.ActionFindNextExecute(Sender: TObject);
begin
  inherited;
  DoSearchReplaceText(FALSE, FALSE);
end;

procedure TFmSQL.ToolButton13Click(Sender: TObject);
begin
  inherited;
  DoSearchReplaceText(FALSE, True);
end;

procedure TFmSQL.ActionFindNextUpdate(Sender: TObject);
begin
  inherited;
 (Sender as TAction).Enabled := (gsSearchText <> '')
end;

procedure TFmSQL.DoSearchReplaceText(AReplace, ABackwards: boolean);
var
  Options: TSynSearchOptions;
begin
  StatPanel.Caption := '';
  if AReplace then
    Options := [ssoPrompt, ssoReplace, ssoReplaceAll]
  else
    Options := [];
  if ABackwards then
    Include(Options, ssoBackwards);
  if gbSearchCaseSensitive then
    Include(Options, ssoMatchCase);
  if not fSearchFromCaret then
    Include(Options, ssoEntireScope);
  if gbSearchSelectionOnly then
    Include(Options, ssoSelectedOnly);
  if gbSearchWholeWords then
    Include(Options, ssoWholeWord);
  if edSQL.SearchReplace(gsSearchText, gsReplaceText, Options) = 0 then
  begin
    MessageBeep(MB_ICONASTERISK);
    StatPanel.Caption := 'Aranan metin bulunamadý.';
    if ssoBackwards in Options then
      edSQL.BlockEnd := edSQL.BlockBegin
    else
      edSQL.BlockBegin := edSQL.BlockEnd;
    edSQL.CaretXY := edSQL.BlockBegin;
  end;
end;

procedure TFmSQL.ShowSearchReplaceDialog(AReplace: boolean);
var
  dlg: TTextSearchDialog;
begin
  StatPanel.Caption := '';
  if AReplace then
    dlg := TTextReplaceDialog.Create(Self)
  else
    dlg := TTextSearchDialog.Create(Self);
  with dlg do try
    // assign search options
    SearchBackwards := gbSearchBackwards;
    SearchCaseSensitive := gbSearchCaseSensitive;
    SearchFromCursor := gbSearchFromCaret;
    SearchInSelectionOnly := gbSearchSelectionOnly;
    // start with last search text
    SearchText := gsSearchText;
    if gbSearchTextAtCaret then begin
      // if something is selected search for that text
      if edSQL.SelAvail and (edSQL.BlockBegin.Y = edSQL.BlockEnd.Y)
      then
        SearchText := edSQL.SelText
      else
        SearchText := edSQL.GetWordAtRowCol(edSQL.CaretXY);
    end;
    SearchTextHistory := gsSearchTextHistory;
    if AReplace then with dlg as TTextReplaceDialog do begin
      ReplaceText := gsReplaceText;
      ReplaceTextHistory := gsReplaceTextHistory;
    end;
    SearchWholeWords := gbSearchWholeWords;
    if ShowModal = mrOK then begin
      gbSearchBackwards := SearchBackwards;
      gbSearchCaseSensitive := SearchCaseSensitive;
      gbSearchFromCaret := SearchFromCursor;
      gbSearchSelectionOnly := SearchInSelectionOnly;
      gbSearchWholeWords := SearchWholeWords;
      gsSearchText := SearchText;
      gsSearchTextHistory := SearchTextHistory;
      if AReplace then with dlg as TTextReplaceDialog do begin
        gsReplaceText := ReplaceText;
        gsReplaceTextHistory := ReplaceTextHistory;
      end;
      fSearchFromCaret := gbSearchFromCaret;
      if gsSearchText <> '' then begin
        DoSearchReplaceText(AReplace, gbSearchBackwards);
        fSearchFromCaret := TRUE;
      end;
    end;
  finally
    dlg.Free;
  end;

end;

procedure TFmSQL.edSQLReplaceText(Sender: TObject; const ASearch,
  AReplace: String; Line, Column: Integer; var Action: TSynReplaceAction);
var
  APos: TPoint;
  EditRect: TRect;
begin
  if ASearch = AReplace then
    Action := raSkip
  else begin
    APos := Point(Column, Line);
    APos := edSQL.ClientToScreen(edSQL.RowColumnToPixels(APos));
    EditRect := ClientRect;
    EditRect.TopLeft := ClientToScreen(EditRect.TopLeft);
    EditRect.BottomRight := ClientToScreen(EditRect.BottomRight);

    if ConfirmReplaceDialog = nil then
      ConfirmReplaceDialog := TConfirmReplaceDialog.Create(Application);
    ConfirmReplaceDialog.PrepareShow(EditRect, APos.X, APos.Y,
      APos.Y + edSQL.LineHeight, ASearch);
    case ConfirmReplaceDialog.ShowModal of
      mrYes: Action := raReplace;
      mrYesToAll: Action := raReplaceAll;
      mrNo: Action := raSkip;
      else Action := raCancel;
    end;
  end;
end;

procedure TFmSQL.ActionFindPrevExecute(Sender: TObject);
begin
  inherited;
  DoSearchReplaceText(FALSE, True);
end;

procedure TFmSQL.ActionReplaceExecute(Sender: TObject);
begin
  inherited;
  ShowSearchReplaceDialog(True);
end;

end.

