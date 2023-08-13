unit UMain;

interface

uses
  XPMenu, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, adsdictionary, ToolWin, ComCtrls, ExtCtrls, Menus, UDBItems,
  FileCtrl, ImgList, ActnList, AgOpenDialog, Grids,  DirOutln, Db,
  adsdata, adsfunc, adstable, adscnnct, AppEvent, UAdsUser, UAdsGroup, UAbout,
  UAdsTable, UAdsProc, UAdsView, UAdsRef, UAdsLink,UDbDelete,Ualias, UDbSql,ACE,
  UadvUtils,mgtscrn, UMigTool, RzStatus, RzPanel, UCheckVersion,UAdvertise,
  UPerformans, Ureport, UDBLimits, ShellApi;

type
  TFmMain = class(TForm)
    XPMenu1: TXPMenu;
    MainMenu1: TMainMenu;
    Dosya1: TMenuItem;
    Aralar1: TMenuItem;
    Yardm1: TMenuItem;
    PnlLeftMain: TPanel;
    Splitter1: TSplitter;
    PnlRightMain: TPanel;
    ImgSmall: TImageList;
    ViewMenu: TMenuItem;
    ItemPopup: TPopupMenu;
    LV: TListView;
    ImgLarge: TImageList;
    gdfg1: TMenuItem;
    dfgdf1: TMenuItem;
    AdsDictionary1: TAdsDictionary;
    StunEkleKaldr1: TMenuItem;
    N1: TMenuItem;
    BykSimgeler1: TMenuItem;
    KkSimgeler1: TMenuItem;
    Liste1: TMenuItem;
    Detaylar1: TMenuItem;
    ActionList1: TActionList;
    AcIconView: TAction;
    AcSmallView: TAction;
    AcListView: TAction;
    AcReportView: TAction;
    AcRefreshItem: TAction;
    AcHelp: TAction;
    ToolBar: TToolBar;
    tbConn: TToolButton;
    tbAliasConfig: TToolButton;
    tbSqlWindow: TToolButton;
    tbExpImp: TToolButton;
    TV: TTreeView;
    AcNewDatabase: TAction;
    AcNewUser: TAction;
    AcNewGroup: TAction;
    AcNewTable: TAction;
    AcNewProc: TAction;
    AcNewView: TAction;
    AcNewRI: TAction;
    tbAddDb: TToolButton;
    tbAddUser: TToolButton;
    tbAddGroup: TToolButton;
    AcAliasConf: TAction;
    RumuzKonfigrasyonu1: TMenuItem;
    AcExit: TAction;
    k1: TMenuItem;
    Komutlar1: TMenuItem;
    YeniVeriTaban1: TMenuItem;
    AcOpenDatabase: TAction;
    AcDropDatabase: TAction;
    VeriTabanA1: TMenuItem;
    VeriTabanSil1: TMenuItem;
    CommandsMenu: TMenuItem;
    VeriTaban2: TMenuItem;
    KullancYarat1: TMenuItem;
    GrupYarat1: TMenuItem;
    TabloYarat1: TMenuItem;
    ProsedrYarat1: TMenuItem;
    GrnmYarat1: TMenuItem;
    likiselBaYarat1: TMenuItem;
    CommandMenuLine: TMenuItem;
    DlgOpenDict: TAgOpenDialog;
    tbAddTable: TToolButton;
    tbAddRI: TToolButton;
    ToolButton10: TToolButton;
    tbAddView: TToolButton;
    tbAddProc: TToolButton;
    tbAddLink: TToolButton;
    tbAbout: TToolButton;
    tbHelp: TToolButton;
    tbView: TToolButton;
    ToolButton19: TToolButton;
    ViewPopup: TPopupMenu;
    BykSimgeler2: TMenuItem;
    KkSimgeler2: TMenuItem;
    Liste2: TMenuItem;
    Detaylar2: TMenuItem;
    Konular1: TMenuItem;
    Hakknda1: TMenuItem;
    AcSqlWindow: TAction;
    AcMigTool: TAction;
    AcAbout: TAction;
    SQLPenceresi1: TMenuItem;
    VeriDntrme1: TMenuItem;
    AcNewLink: TAction;
    YeniVTLinkEkle1: TMenuItem;
    Dizin1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    WindowsYardmKullanm1: TMenuItem;
    AcGotoSite: TAction;
    DialFreeTable: TOpenDialog;
    SzlkTablosunuSerbestBrak1: TMenuItem;
    AcFreeTable: TAction;
    VeritabanSunucusuYnetimi1: TMenuItem;
    AcDbMngt: TAction;
    Status: TRzStatusBar;
    spnSelDB: TRzGlyphStatus;
    spnDBConn: TRzGlyphStatus;
    spnSelObj: TRzGlyphStatus;
    AcDbReport: TAction;
    VeritabanRaporu1: TMenuItem;
    acCheckVersion: TAction;
    YeniSrmKontrol1: TMenuItem;
    N4: TMenuItem;
    acShowAdvertise: TAction;
    AlEkran2: TMenuItem;
    acSupport: TAction;
    OptionsAction: TAction;
    anmlar1: TMenuItem;
    N5: TMenuItem;
    VeriTabanLimitleri1: TMenuItem;
    MteriTemsilcisineUlan1: TMenuItem;
    VeriTabanLimitleri2: TMenuItem;
    AdvantageWebSitesi1: TMenuItem;
    cretsizTeknikDestekHizmeti1: TMenuItem;
    AdvantagePerformansDemosu1: TMenuItem;
    rkeKullanmKlavuzunundir1: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    BeniOku1: TMenuItem;
    N9: TMenuItem;
    SzlkDosyalarnlikilendir1: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ImageList1: TImageList;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    AcExportAsCode: TAction;
    ToolButton9: TToolButton;
    AcProperties: TAction;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    AcDropItem: TAction;
    AcExport: TAction;
    ToolButton14: TToolButton;
    VeriAktarmArac1: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    ToolButton15: TToolButton;
    AcPerformans: TAction;
    ToolButton16: TToolButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TVChange(Sender: TObject; Node: TTreeNode);
    procedure LVData(Sender: TObject; Item: TListItem);
    procedure LVSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure LVDblClick(Sender: TObject);
    procedure TVDblClick(Sender: TObject);
    procedure TVMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LVMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LVGetImageIndex(Sender: TObject; Item: TListItem);
    procedure AcIconViewExecute(Sender: TObject);
    procedure AcSmallViewExecute(Sender: TObject);
    procedure AcListViewExecute(Sender: TObject);
    procedure AcReportViewExecute(Sender: TObject);
    procedure AcRefreshItemExecute(Sender: TObject);
    procedure LVCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure CommandsMenuClick(Sender: TObject);
    procedure AcOpenDatabaseExecute(Sender: TObject);
    procedure TVChanging(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure AppEventsException(Sender: TObject; E: Exception);
    procedure AcNewDatabaseExecute(Sender: TObject);
    procedure tbConnClick(Sender: TObject);
    procedure AcDropDatabaseExecute(Sender: TObject);
    procedure AcAliasConfExecute(Sender: TObject);
    procedure AcSqlWindowExecute(Sender: TObject);
    procedure AcMigToolExecute(Sender: TObject);
    procedure AcNewUserExecute(Sender: TObject);
    procedure AcNewGroupExecute(Sender: TObject);
    procedure AcNewTableExecute(Sender: TObject);
    procedure AcNewProcExecute(Sender: TObject);
    procedure AcNewViewExecute(Sender: TObject);
    procedure AcNewRIExecute(Sender: TObject);
    procedure AcNewLinkExecute(Sender: TObject);
    procedure AcHelpExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AcExitExecute(Sender: TObject);
    procedure AcAboutExecute(Sender: TObject);
    procedure Dizin1Click(Sender: TObject);
    procedure WindowsYardmKullanm1Click(Sender: TObject);
    procedure AcGotoSiteExecute(Sender: TObject);
    procedure AcFreeTableExecute(Sender: TObject);
    procedure AcDbMngtExecute(Sender: TObject);
    procedure AcDbReportExecute(Sender: TObject);
    procedure acCheckVersionExecute(Sender: TObject);
    procedure acShowAdvertiseExecute(Sender: TObject);
    procedure acSupportExecute(Sender: TObject);
    procedure BtnOptionsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cretsizTeknikDestekHizmeti1Click(Sender: TObject);
    procedure MteriTemsilcisineUlan1Click(Sender: TObject);
    procedure AdvantageWebSitesi1Click(Sender: TObject);
    procedure VeriTabanLimitleri2Click(Sender: TObject);
    procedure rkeKullanmKlavuzunundir1Click(Sender: TObject);
    procedure AdvantagePerformansDemosu1Click(Sender: TObject);
    procedure VeriTabanLimitleri1Click(Sender: TObject);
    procedure OptionsActionExecute(Sender: TObject);
    procedure BeniOku1Click(Sender: TObject);
    procedure SzlkDosyalarnlikilendir1Click(Sender: TObject);
    procedure LVKeyPress(Sender: TObject; var Key: Char);
    procedure LVKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LVInfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: String);
    procedure AcExportAsCodeExecute(Sender: TObject);
    procedure AcPropertiesExecute(Sender: TObject);
    procedure AcPropertiesUpdate(Sender: TObject);
    procedure AcExportAsCodeUpdate(Sender: TObject);
    procedure AcDropItemUpdate(Sender: TObject);
    procedure AcDropItemExecute(Sender: TObject);
    procedure AcExportExecute(Sender: TObject);
    procedure AcPerformansExecute(Sender: TObject);
  private
    OldNode: TTreeNode;
    procedure Initialize;
    procedure CreateInitialItems;
    procedure CreateChilds(DBList: TDBBaseList; Node: TTreeNode);
    function  AddNode(ParentNode: TTreeNode; DbItem: TDBBaseItem): TTreeNode;
    procedure ItemEvent(Sender: TObject; Event: TDBEvent);
    procedure UpdateViews;
    function CurrentListItem: TDBBaseList;
    function FindTVItem(Data: Pointer): TTreeNode;
    function GetIconIndex(Item: TDBBaseItem): Integer;
    procedure CreatePopupMenu(Item: TDBItem; Popup: TPopupMenu);
    procedure OnMenuCommand(Sender: TObject);
    procedure CreateListColumns(Item: TDBBaseItem);
    function GetCurrentSelectedItem: TDBBaseItem;
    procedure CreateCommandsMenu(Item: TDBBaseItem);
    procedure AddAdsObject (Item: TDBBaseListClass);
    function GetSelectedDatabase (pSelect : Boolean) : TDatabase;
    procedure SelectionChanged (Item : TDatabase; SelItem1: TDBBaseItem; SelItem2: TDBBaseItem);
    function IsAdmin( pDB : TDatabase ): Boolean;
    procedure SetConnStatus (ConnType : String);
    procedure ShowAbout;
    procedure ShowAdvertise;
    procedure OpenDictionary(const FileName: string);
    function FindDatabaseItemFromDict(const FileName: string): TDatabase;
    procedure RegisterAddFile;
    procedure LoadSettings;
    procedure SaveSettibgs;
    function GetCommandImageIndex(Item: TDBBaseItem; Cmd: TDBCommand): Integer;
  public
    procedure CheckAutoVersion;
    procedure CheckCmdLine;
    procedure CloseDatabaseForms(ADict: TAdsDictionary);
    procedure DestroyItems;
  end;

var
  FmMain: TFmMain;

implementation

uses UAdsErr,UObjEdit,UDataBase, UOptions, UFmConnectPath, UDataOperations,
  UFmDataExport;

{$R *.DFM}
type
 TItemCommand = class
 public
  Cmd: TDBCommand;
  Owner: TDBItem;
 end;

function TFmMain.IsAdmin( pDB : TDatabase ): Boolean;
begin
   Result := UpperCase(pDB.Dictionary.UserName) = 'ADSSYS';
end;

procedure TFmMain.Button1Click(Sender: TObject);
var List: TStringList;
begin
  List := TStringList.Create();
  List.free;
end;

procedure TFmMain.CreateInitialItems;
var Node: TTreeNode;
    DatabaseList: TDatabaseList;
begin
  with TV do
  begin
    DatabaseList := TDatabaseList.Create(ItemEvent);
    Node := AddNode(nil, DatabaseList);
    DatabaseList.Open;
  end;
end;

procedure TFmMain.Initialize;
begin
  CreateInitialItems;
  Show;
  ShowAbout;
  ShowAdvertise;
end;

procedure TFmMain.FormCreate(Sender: TObject);
begin
  Application.OnException := AppEventsException;
  LoadSettings;
  Initialize;
  FmOptions := TFmOptions.Create(nil);
  FmOptions.LoadSettings;
  FmOptions.ApplySettings;
end;

procedure TFmMain.CreateChilds(DBList: TDBBaseList; Node: TTreeNode);
var I: Integer;
begin
  for I := 0 to DbList.ItemCount - 1 do
   AddNode(Node, DbList[I]);
end;


function TFmMain.AddNode(ParentNode: TTreeNode;
  DbItem: TDBBaseItem): TTreeNode;
begin
  Result := Tv.Items.AddChild(ParentNode, DbItem.Title);
  Result.Data := DbItem;
  Result.ImageIndex := GetIconIndex(DBItem);
  if DbItem is TDatabaseList then
    Result.SelectedIndex := 8
  else
    Result.SelectedIndex := Result.ImageIndex;
end;

procedure TFmMain.ItemEvent(Sender: TObject; Event: TDBEvent);
begin
  case Event of
    evCreated:
    begin
      if (Sender is TDatabaseList) then
        TDBBaseItem(Sender).HelpID := 20
      else if Sender is TDBUserList then
        TDBBaseItem(Sender).HelpID := 30
      else if Sender is TDBGroupList then
        TDBBaseItem(Sender).HelpID := 40
      else if Sender is TDBTableList then
        TDBBaseItem(Sender).HelpID := 50
      else if Sender is TDBProcList then
        TDBBaseItem(Sender).HelpID := 60
      else if Sender is TDBViewList then
        TDBBaseItem(Sender).HelpID := 70
      else if Sender is TDBRefList then
        TDBBaseItem(Sender).HelpID := 80
      else if Sender is TDBLinkList then
        TDBBaseItem(Sender).HelpID := 90;
    end;
    evChildsCreated:
     begin
       if (CurrentListItem = Sender) and
          (not TV.Selected.HasChildren) and
          ((CurrentListItem is TDatabase) or (CurrentListItem is TDatabaseList)) then
          begin
             CreateChilds(CurrentListItem, TV.Selected);
             TV.Selected.Expand(False);
          end;
       if Sender is TDatabase then
       begin
         tbConn.ImageIndex := 42;
         tbConn.Hint := 'Veri Tabaný Baðlantýsýný Kapat';
         SetConnStatus( TDatabase(Sender).GetConnectionType);
       end;
      end;
    evChildsDestroyed:
     begin
       if (CurrentListItem = Sender) and (TV.Selected.HasChildren) then
         TV.Selected.DeleteChildren;
       if Sender is TDatabase then
       begin
         tbConn.ImageIndex := 41;
         tbConn.Hint := 'Seçili Veri Tabanýna Baðlan ...';
         try
           CloseDatabaseForms(TDatabase(Sender).Dictionary);
         except
         end;
         SetConnStatus('');
       end;
      end;
    evModified:
     begin
       CurrentListItem.Refresh;
     end;
  end;

  if (Event <> evCreated) and (CurrentListItem = Sender) then
    UpdateViews;
  if Event = evRemoved then CurrentListItem.Refresh;
end;

procedure TFmMain.SetConnStatus (ConnType : String);
begin
  spnDBConn.Caption := ConnType;
  spnDBConn.Glyph := nil;
  if connType = '' then begin
    ImgSmall.GetBitmap(20, spnDBConn.Glyph);
    spnDBConn.Caption := 'Baðlantý Yok';
  end else if UpperCase(connType) ='YEREL' then
    ImgSmall.GetBitmap(17, spnDBConn.Glyph)
  else if UpperCase(connType) ='UZAK' then
    ImgSmall.GetBitmap(18, spnDBConn.Glyph)
  else
    ImgSmall.GetBitmap(19, spnDBConn.Glyph);
end;

procedure TFmMain.TVChange(Sender: TObject; Node: TTreeNode);
begin
  try
    if not (CurrentListItem is TDatabase) then CurrentListItem.Open;
    UpdateViews;
  except
    TV.Selected := OldNode;
    raise;
  end;

  SelectionChanged(GetSelectedDatabase(False),TV.Selected.Data, nil);
end;

procedure TFmMain.UpdateViews;
begin
  LV.Items.BeginUpdate;
  try
   LV.OnData := nil;
   if LV.ViewStyle = vsReport then
   begin
     CreateListColumns(CurrentListItem);
   end;
   LV.Items.Count := CurrentListItem.ItemCount;
  finally
    LV.OnData := LVData;
    LV.Items.EndUpdate;
  end;
end;

procedure TFmMain.LVData(Sender: TObject; Item: TListItem);
var I: Integer;
    BaseList: TDBBaseList;
begin
  BaseList := CurrentListItem;
  if Item.Index >= BaseList.ItemCount then Exit;
  Item.Caption := BaseList[Item.Index].Title;
  Item.Data := BaseList[Item.Index];
  if LV.ViewStyle = vsReport then
  begin
    for I := 0 to BaseList[Item.Index].GetPropertyCount - 1 do
     Item.SubItems.Add(BaseList[Item.Index].GetPropertyValue(I));
  end;
end;

function TFmMain.CurrentListItem: TDBBaseList;
begin
  if TV.Selected = nil then TV.Selected := TV.Items[0];
  Result := TDBBaseList(TV.Selected.Data);
end;

procedure TFmMain.LVSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if Item <> nil then
  begin
    SelectionChanged(GetSelectedDatabase(False),Item.Data,TV.Selected.Data );
  end;
end;

procedure TFmMain.LVDblClick(Sender: TObject);
var Item: TDBBaseItem;
    Node: TTreeNode;
begin
  if LV.Selected = nil then Exit;
  Item := TDBBaseItem(LV.Selected.Data);
  if not Item.IsList then
  begin
    Item.SendCommand(Item.GetDefaultCommand);
  end else
  begin
    Node := FindTVItem(LV.Selected.Data);
    if Node <> nil then
    begin
      TV.Selected := Node;
      if not TDBBaseList(Item).ItemsCreated then CurrentListItem.Open;
      //else CurrentListItem.Open;
    end;
  end;
end;

function TFmMain.FindTVItem(Data: Pointer): TTreeNode;
var I: Integer;
begin
  Result := nil;
  for I := 0 to TV.Items.Count - 1 do
  begin
    if Data = TV.Items[I].Data then
    begin
      Result := TV.Items[I];
      Break;
    end;
  end;
end;

procedure TFmMain.TVDblClick(Sender: TObject);
begin
  if CurrentListItem is TDatabase then CurrentListItem.Open;
end;

function TFmMain.GetIconIndex(Item: TDBBaseItem): Integer;
begin
  if Item is TDatabase then Result := 0
  else if (Item is TDBUser) or (Item is TDBUserList) then Result := 1
  else if (Item is TDBGroup) or (Item is TDBGroupList) then Result := 2
  else if (Item is TDBTable) or (Item is TDBTableList) then
  begin
    Result := 3;
    if (Item is TDBTable) then
    begin
      if TDBTable(Item).IsEnc then
      begin
         if LV.ViewStyle = vsIcon then Result := 8
         else Result := 23;
      end;   
    end;
  end
  else if (Item is TDBProc) or (Item is TDBProcList) then Result := 4
  else if (Item is TDBView) or (Item is TDBViewList) then Result := 5
  else if (Item is TDBRef) or (Item is TDBRefList) then Result := 6
  else if (Item is TDBLink) or (Item is TDBLinkList) then Result := 7
  else if (Item is TDatabaseList) then Result := 8;
end;

procedure TFmMain.TVMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var Node: TTreeNode;
begin
  if Button = mbRight then
  begin
    Node := TV.GetNodeAt(X, Y);
    if Node <> nil then
    begin
      Node.Selected := True;
      CreatePopupMenu(TDBItem(Node.Data), ItemPopup);
      ItemPopup.Popup(TV.ClientOrigin.x + X, TV.ClientOrigin.Y +  Y);
    end;
  end;
end;

procedure TFmMain.CreatePopupMenu(Item: TDBItem; Popup: TPopupMenu);
var Count, I: Integer;
    MenuItem, Temp: TMenuItem;
    Cmd: TItemCommand;
    Node: TTreeNode;
    ItemCmd: TDbCommand;

procedure CreateOtherMenuItems(Flag: Boolean);
var SubMenu: TMenuItem;
begin
  if Temp <> nil then Exit;
  if Popup.Items.Count > 0 then
  begin
    Temp := TMenuItem.Create(Popup);
    Temp.Caption := '-';
    Popup.Items.Add(Temp);
  end;
  if not (CurrentListItem is TDatabaseList) then
  begin
    Temp := TMenuItem.Create(Popup);
    Temp.Caption := 'SQL Kaynak Kodu';
    Cmd := TItemCommand.Create;
    Cmd.Owner := Item;
    Cmd.Cmd := dcExportToCode;
    Temp.OnClick := OnMenuCommand;
    Popup.Items.Add(Temp);
    Temp.Tag := Integer(Cmd);
    Temp.ImageIndex := GetCommandImageIndex(Item, Cmd.Cmd);
    Temp := TMenuItem.Create(Popup);
    Temp.Caption := '-';
    Popup.Items.Add(Temp);
  end;


  Temp := TMenuItem.Create(Popup);
  Temp.Caption := 'Görünüm';

  SubMenu := TMenuItem.Create(Popup);
  Temp.Add(SubMenu);
  SubMenu.GroupIndex := 1;
  SubMenu.RadioItem := True;
  SubMenu.Action := AcIconView;
  if LV.ViewStyle = vsIcon then
     SubMenu.Checked := True;

  SubMenu := TMenuItem.Create(Popup);
  Temp.Add(SubMenu);
  SubMenu.GroupIndex := 1;
  SubMenu.RadioItem := True;
  SubMenu.Action := AcSmallView;
  if LV.ViewStyle = vsSmallIcon then
     SubMenu.Checked := True;

  SubMenu := TMenuItem.Create(Popup);
  Temp.Add(SubMenu);
  SubMenu.GroupIndex := 1;
  SubMenu.RadioItem := True;
  SubMenu.Action := AcListView;
  if LV.ViewStyle = vsList then
     SubMenu.Checked := True;


  SubMenu := TMenuItem.Create(Popup);
  Temp.Add(SubMenu);
  SubMenu.GroupIndex := 1;
  SubMenu.RadioItem := True;
  SubMenu.Action := AcReportView;
  if LV.ViewStyle = vsReport then
     SubMenu.Checked := True;

  Popup.Items.Add(Temp);

  Temp := TMenuItem.Create(Popup);
  Temp.Action := AcRefreshItem;
  Popup.Items.Add(Temp);

end;

begin
  while PopUp.Items.Count > 0 do PopUp.Items.Delete(0);
  Count := Item.GetMenuCount;
  I := 0;
  Temp := nil;
  while (I < Count) do
  begin
    MenuItem := TMenuItem.Create(Popup);
    Cmd := TItemCommand.Create;
    Cmd.Owner := Item;
    MenuItem.Caption := Item.GetMenuItem(I, Cmd.Cmd);
    MenuItem.Tag := Integer(Cmd);
    MenuItem.ImageIndex := GetCommandImageIndex(Item, Cmd.Cmd);
    MenuItem.OnClick := OnMenuCommand;
		if Cmd.Cmd = Item.GetDefaultCommand then MenuItem.Default := True;
		if Cmd.Cmd = dcExportToCode then
		begin
			Temp := TMenuItem.Create(Popup);
			Temp.Caption := '-';
			Popup.Items.Add(Temp);
		end else
		if Cmd.Cmd = dcProperties then begin
			CreateOtherMenuItems(True);
			Temp := TMenuItem.Create(Popup);
			Temp.Caption := '-';
			Popup.Items.Add(Temp);
		end;

		Popup.Items.Add(MenuItem);
		Inc(I);
	end;
	CreateOtherMenuItems(False);
	Temp := TMenuItem.Create(Popup);
	Temp.Caption := '-';
	Popup.Items.Add(Temp);

	MenuItem := TMenuItem.Create(Popup);
	Cmd := TItemCommand.Create;
	Cmd.Owner := Item;
	Cmd.Cmd := dcHelp;
  MenuItem.Caption := 'Yardým';
  MenuItem.Tag := Integer(Cmd);
  MenuItem.ImageIndex := GetCommandImageIndex(nil, Cmd.Cmd);
  MenuItem.OnClick := OnMenuCommand;
  Popup.Items.Add(MenuItem);
  XPMenu1.Active := True;
end;

procedure TFmMain.OnMenuCommand(Sender: TObject);
var Cmd: TItemCommand;
    Node: TTreeNode;
    ACmd: TDBCommand;
    Item: TDBItem;
begin
  Cmd := TItemCommand((Sender as TMenuItem).Tag);
  if Cmd.Owner.IsList and (TV.Selected.Data <> Cmd.Owner) then
  begin
    Node := FindTVItem(LV.Selected.Data);
    if Node <> nil then
    begin
      Node.Selected := True;
    end;
  end;
  ACmd := Cmd.Cmd;
  Item := Cmd.Owner;
  Cmd.Free;
  Item.SendCommand(ACmd);
end;

procedure TFmMain.LVMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var Node: TListItem;
    TreeNode: TTreeNode;
begin
  if Button = mbRight then
  begin
    Node := LV.GetItemAt(X, Y);
    if Node <> nil then
    begin
      Node.Selected := True;
      CreatePopupMenu(TDBItem(Node.Data), ItemPopup);
      ItemPopup.Popup(LV.ClientOrigin.x + X, LV.ClientOrigin.y + Y);
    end else
    begin
      TreeNode := TV.Selected;
      CreatePopupMenu(TDBItem(TreeNode.Data), ItemPopup);
      ItemPopup.Popup(LV.ClientOrigin.x + X, LV.ClientOrigin.y + Y);
    end;
  end;

end;
procedure TFmMain.CreateListColumns(Item: TDBBaseItem);
var I: Integer;
    Col: TListColumn;
begin
  LV.Columns.BeginUpdate;
  LV.Items.BeginUpdate;
  LV.Enabled := False;
  try
    while LV.Columns.Count > Item.GetColumnCount do
     LV.Column[LV.Columns.Count-1].Free;
    for I := 0 to Item.GetColumnCount - 1 do
    begin
      if LV.Columns.Count > I then
       Col := LV.Columns[I]
      else
       Col := LV.Columns.Add;
      Col.Width := 150;
      Col.Caption := Item.GetColumnTitle(I);
      if I = Item.GetColumnCount - 1 then
      begin
        Col.Width := 300;
        Col.AutoSize := True;
      end;
    end;
  finally
    LV.Columns.EndUpdate;
    LV.Items.EndUpdate;
    LV.Enabled := True;
  end;
end;

procedure TFmMain.LVGetImageIndex(Sender: TObject; Item: TListItem);
begin
  Item.ImageIndex := GetIconIndex(CurrentListItem[Item.Index]);
end;

procedure TFmMain.AcIconViewExecute(Sender: TObject);
begin
  LV.ViewStyle := vsIcon;
  BykSimgeler1.Checked := True;
  BykSimgeler2.Checked := True;
end;

procedure TFmMain.AcSmallViewExecute(Sender: TObject);
begin
  LV.ViewStyle := vsSmallIcon;
  KKsimgeler1.Checked := True;
  KKsimgeler2.Checked := True;
end;

procedure TFmMain.AcListViewExecute(Sender: TObject);
begin
  LV.ViewStyle := vsList;
  Liste1.Checked := True;
  Liste2.Checked := True;
end;

procedure TFmMain.AcReportViewExecute(Sender: TObject);
begin
  CreateListColumns(CurrentListItem);
  LV.ViewStyle := vsReport;
  detaylar1.Checked := True;
  detaylar2.Checked := True;
  LV.Refresh;
end;

procedure TFmMain.AcRefreshItemExecute(Sender: TObject);
begin
  GetCurrentSelectedItem.SendCommand(dcRefresh);
end;

function TFmMain.GetCurrentSelectedItem: TDBBaseItem;
begin
  if (ActiveControl = LV) and (LV.Selected <> nil) then Result := TDBBaseItem(LV.Selected.Data)
  else Result := TDBBaseItem(TV.Selected.Data);
end;

procedure TFmMain.LVCompare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
begin
  Compare := CompareText(TDBBaseItem(Item1.Data).Title, TDBBaseItem(Item2.Data).Title);
end;

procedure TFmMain.CommandsMenuClick(Sender: TObject);
var
	DBItem: TDBItem;
begin
	DBItem := nil;

	try
		if (ActiveControl = TV) and Assigned(TV.Selected) then
			DBItem := TDBItem(TV.Selected.Data)
		else if Assigned(LV.Selected) then
			DBItem := TDBItem(LV.Selected.Data);

		CreateCommandsMenu(DBItem);
	except

  end;
end;

procedure TFmMain.CreateCommandsMenu(Item: TDBBaseItem);
var MenuItem: TMenuItem;
    Cmd: TItemCommand;
    Count, I: Integer;
begin
  for I := CommandsMenu.Count - 1 downto 2 do
    CommandsMenu.Delete(I);
  CommandMenuLine.Visible := Assigned(Item);
  if not Assigned(Item) then Exit;
  Count := Item.GetMenuCount;
  I := 0;
  while (I < Count) do
  begin
    MenuItem := TMenuItem.Create(CommandsMenu);
    Cmd := TItemCommand.Create;
    Cmd.Owner := TDBItem(Item);
    MenuItem.Caption := Item.GetMenuItem(I, Cmd.Cmd);
    MenuItem.Tag := Integer(Cmd);
    MenuItem.OnClick := OnMenuCommand;
    MenuItem.ImageIndex := GetCommandImageIndex(Item, Cmd.Cmd);
    CommandsMenu.Add(MenuItem);
    if Cmd.Cmd = Item.GetDefaultCommand then MenuItem.Default := True;
    Inc(I);
  end;
  CommandMenuLine.Visible := Count > 0;
end;

procedure TFmMain.AcOpenDatabaseExecute(Sender: TObject);
var ConnectPath: string;
begin
  with TFmGetConnectPath.Create(nil) do
  try
    ConnectPath := Execute;
  finally
    Free;
  end;
  if ConnectPath <> '' then
    OpenDictionary(ConnectPath);
end;

procedure TFmMain.TVChanging(Sender: TObject; Node: TTreeNode;
  var AllowChange: Boolean);
begin
  OldNode := Node;
end;

procedure TFmMain.AppEventsException(Sender: TObject; E: Exception);
begin
  if E is EADSDatabaseError then
  begin
    with TFmAdsError.Create(nil) do
    try
      Execute(EADSDatabaseError(E));
    finally
      Free;
    end;
  end else Application.ShowException(E);
end;

procedure TFmMain.AcNewDatabaseExecute(Sender: TObject);
var
  Res:Boolean;
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
    TV.Items[0].Selected := True;
    TV.Refresh;
    CurrentListItem.Refresh;
  end;
end;

procedure TFmMain.tbConnClick(Sender: TObject);
  var mDB : TDatabase;
begin
  mDB := GetSelectedDatabase (True);
  if not mDB.ItemsCreated then
    mDb.Open
  else
    mDB.Close;
end;

procedure TFmMain.AcDropDatabaseExecute(Sender: TObject);
var
  Res:Boolean;
  mDB:TDatabase;
begin
  mDB := GetSelectedDatabase(True);
  if not mDb.ItemsCreated then mDb.Open;

  if not IsAdmin(mDB) then
     raise Exception.Create('Bu iþlemi sadece yönetici kullanýcý (ADSSYS) ile baðlanarak yapabilirsiniz.');

  with TfmDbDelete.Create(nil) do
    try
      Dictionary := mDB.Dictionary;
      Res := Init();
    finally
      Free;
    end;
    if res then begin
      TV.Items[0].Selected := True;
      TV.Refresh;
      CurrentListItem.Refresh;
    end;

end;

procedure TFmMain.AcAliasConfExecute(Sender: TObject);
begin
   with TFmAlias.Create (nil) do
   try
     if AliasShow then
     begin
       TV.Items[0].Selected := True;
       TV.Refresh;
       CurrentListItem.Refresh;
     end;
   finally
     free;
   end;
end;

procedure TFmMain.AddAdsObject (Item: TDBBaseListClass);
  var mDB : TDatabase;
      i: integer;
      mNode : TTreeNode;
begin

  mDB := GetSelectedDatabase(True);
  if not mDb.ItemsCreated then mDb.Open;

  if not IsAdmin(mDB) then
     raise Exception.Create('Bu iþlemi sadece Yönetici Kullanýcýsý ile baðlanarak yapabilirsiniz.');

  for i := 0 to   TV.Selected.Count -1 do
  begin
    mNode := TV.Selected.Item[i];
    if Tobject(mNode.Data) is Item then
    begin
       mNode.Selected := True;
       TDBBaseList(mNode.Data).SendCommand(dcNew);
       break;
    end;
  end;

end;

procedure TFmMain.AcSqlWindowExecute(Sender: TObject);
  var mDB : TDatabase;
begin
  mDB := GetSelectedDatabase(True);
  if not mDb.ItemsCreated then mDb.Open;
  mDB.SendCommand(dcSQL);
end;

procedure TFmMain.AcMigToolExecute(Sender: TObject);
begin
   with TfmMigTool.Create (nil) do
   try
     ShowModal;
     if NewDbCreated then begin
       TV.Items[0].Selected := True;
       TV.Refresh;
       CurrentListItem.Refresh;
     end;
   finally
     free;
   end;

end;

Function TFmMain.GetSelectedDatabase (pSelect : Boolean) : TDatabase;
  var mNode : TTreeNode;
  i:integer;
begin
  if TObject(TV.Selected.Data) is TDatabaseList then
  begin
    if LV.SelCount = 1 then
    begin
      mNode := TV.Items[0];
      for i:= 0 to mNode.Count - 1 do
      begin
         if Tdatabase(mNode.Item[i].Data) = Tdatabase (LV.Selected.Data) then
         begin
            if pSelect then MNode.Item[i].Selected := True;
            Result := mNode.Item[i].Data;
            Break;
         end;
      end;
    end else
      if pSelect then
        raise Exception.Create('Önce Veri Tabaný Nesnelerinden bir veritabaný seçiniz.')
      else
        Result := nil;
  end else begin
     if (not (TObject(TV.Selected.Data) is TDatabase)) and pSelect then
        TV.Selected.Parent.Selected := True;

     if TObject(TV.Selected.Data) is TDatabase then
        Result := TDatabase (TV.Selected.Data)
     else  begin
        mNode := TV.Selected.Parent;
        Result := TDatabase (mNode.Data);
     end;
  end;
end;

procedure TFmMain.AcNewUserExecute(Sender: TObject);
begin
   AddAdsObject(TDbUserList);
end;

procedure TFmMain.AcNewGroupExecute(Sender: TObject);
begin
   AddAdsObject(TDbGroupList);
end;

procedure TFmMain.AcNewTableExecute(Sender: TObject);
begin
   AddAdsObject(TDbTableList);
end;

procedure TFmMain.AcNewProcExecute(Sender: TObject);
begin
   AddAdsObject(TDbProcList);
end;

procedure TFmMain.AcNewViewExecute(Sender: TObject);
begin
   AddAdsObject(TDbViewList);
end;

procedure TFmMain.AcNewRIExecute(Sender: TObject);
begin
   AddAdsObject(TDBRefList);
end;

procedure TFmMain.AcNewLinkExecute(Sender: TObject);
begin
   AddAdsObject(TDBLinkList);
end;

Procedure TFmMain.SelectionChanged (Item : TDatabase; SelItem1: TDBBaseItem; SelItem2: TDBBaseItem);
begin
    spnSelDB.Glyph := nil;
    spnSelObj.Glyph := nil;
    if Assigned(Item) then
    begin
      ImgSmall.GetBitmap (0, spnSelDB.Glyph);
      if Item.ItemsCreated then
      begin
        tbConn.ImageIndex := 42;
        tbConn.Hint := 'Veri Tabaný Kapat';
      end else begin
        tbConn.ImageIndex := 41;
        tbConn.Hint := 'Veri Tabaný Aç';
      end;
      spnSelDB.Caption := Item.Title;
      setConnStatus(Item.GetConnectionType);

      if SelItem1 is TDatabase then begin
        spnSelObj.Caption := '';
      end else begin
        if Assigned(SelItem2) then
        begin
          ImgSmall.GetBitmap(TV.Selected.ImageIndex,spnSelObj.Glyph);
          if SelItem2 is TDBLinkList then
             spnSelObj.Caption := ' '+ SelItem1.Title
          else
             if SelItem1 is TDBBaseList then
               spnSelObj.Caption := ' '+ SelItem1.Title
             else
               spnSelObj.Caption := ' '+ SelItem1.Title;
        end else
          begin
            ImgSmall.GetBitmap(TV.Selected.ImageIndex,spnSelObj.Glyph);
            spnSelObj.Caption := SelItem1.Title;
          end;
        end;

    end else begin
      ImgSmall.GetBitmap (8, spnSelDB.Glyph);
      spnSelDB.Caption := 'Veri Tabanlarý';
      spnDBConn.Glyph := nil;
      spnDBConn.Caption := '';
      spnSelObj.Caption := ''; 
    end;
end;

procedure TFmMain.AcHelpExecute(Sender: TObject);
begin
  Application.HelpCommand(HELP_FINDER,0);
end;

procedure TFmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.HelpCommand (HELP_QUIT ,0);
  SaveSettibgs;
end;

procedure TFmMain.AcExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFmMain.AcAboutExecute(Sender: TObject);
begin
   with TAboutBox.Create (nil) do
   try
     ShowModal;
   finally
     free;
   end;
end;

procedure TFmMain.Dizin1Click(Sender: TObject);
begin
  Application.HelpCommand (HELP_KEY , 0);
end;

procedure TFmMain.WindowsYardmKullanm1Click(Sender: TObject);
begin
  Application.HelpCommand (HELP_HELPONHELP,0);
end;

procedure TFmMain.AcGotoSiteExecute(Sender: TObject);
begin
 GotoUrl('http://www.advantageturk.com',700,500,true);
end;

procedure TFmMain.AcFreeTableExecute(Sender: TObject);
var
  iRetVal : integer;
  strTempString : string;
begin

//  mDB := GetSelectedDatabase(True);
 // if not mDb.ItemsCreated then mDb.Open;
  if not FileExists(ExtractFilePath( Application.EXEName )+ '.\freeadt.exe') then
     raise Exception.Create('Hata:Freeadt.exe program dosyasý çalýþma dizininde bulunamadý.');
  if DialFreeTable.Execute then begin
    if MessageDlg(DialFreeTable.FileName+' tablosunu serbest býrakmak istediðinizden emin misiniz?',
      mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      exit;

    strTempString := ExtractFilePath( Application.EXEName );

    strTempString := strTempString + '.\freeadt.exe ' + DialFreeTable.FileName + ' -y';

    iRetVal := WinExec( pChar( strTempString ), SW_HIDE );
    if( iRetVal > 32 ) then
       ShowMessage( DialFreeTable.FileName + ' serbest býrakýldý.')
    else
       raise Exception.Create('Hata:'+DialFreeTable.FileName+' tablosu serbest býrakýlamadý.');
  end;
end;

procedure TFmMain.AcDbMngtExecute(Sender: TObject);
begin
   with TMgtForm.Create (nil) do
   try
     ShowModal;
   finally
     free;
   end;
end;

procedure TFmMain.AcDbReportExecute(Sender: TObject);
  var mDB : TDatabase;
begin
  mDB := GetSelectedDatabase(True);
  if not mDb.ItemsCreated then mDb.Open;
  with TfmReport.Create(nil) do
  try
    Dictionary := mDB.Dictionary;
    ShowModal;
  finally
    free;
  end;
end;

procedure TFmMain.acCheckVersionExecute(Sender: TObject);
begin
  with TfmCheckVersion.Create(nil) do
  try
    self.Enabled := False;
    Execute;
  finally
    self.Enabled := True;
    free;
  end;
end;

procedure TFmMain.ShowAbout;
  var mKeyValue: string;
  const mRegKey ='ShowAboutOnStart';
begin
  mKeyValue := ReadRegKey(mRegKey);
  if (mKeyValue='1') or (mKeyValue='') then begin
     RegisterAddFile;
     with TAboutBox.Create (nil) do
     try
       ShowModal;
     finally
       free;
     end;
     WriteRegKey (mRegKey,'0');
  end;
end;

procedure TFmMain.ShowAdvertise;
  var mKeyValue: string;
  const mRegKey ='ShowAdvertiseOnStart';
begin
  mKeyValue := ReadRegKey(mRegKey);
  if (mKeyValue='1') or (mKeyValue='') then begin
     with TFmAdvertise.Create (nil) do
     try
       ShowModal;
     finally
       free;
     end;
  end;
end;

procedure TFmMain.acShowAdvertiseExecute(Sender: TObject);
begin
   with TFmAdvertise.Create (nil) do
   try
     ShowModal;
   finally
     free;
   end;
end;

procedure TFmMain.acSupportExecute(Sender: TObject);
begin
  GotoUrl('http://www.delphiturk.com/Forums.aspx?Forums=251',700,500,true);
end;

procedure TFmMain.BtnOptionsClick(Sender: TObject);
begin
  OptionsAction.Execute;
end;

procedure TFmMain.FormDestroy(Sender: TObject);
begin
  FmOptions.Free;
  DestroyItems;
end;

procedure TFmMain.CheckAutoVersion;
var D: TDateTime;
begin
  if not FmOptions.ChkAutoVersion.Checked then Exit;
  D := StrToDateDef(ReadRegKey('LastVersionCheck'), Date);
  if DayDiff(Date, D) > 30 then
  begin
    WriteRegKey('LastVersionCheck', DateTimeToStr(Date));
    acCheckVersion.Execute;
  end else if DayDiff(Date, D) < 1 then
    WriteRegKey('LastVersionCheck', DateTimeToStr(Date));
end;

procedure TFmMain.cretsizTeknikDestekHizmeti1Click(Sender: TObject);
begin
  GotoUrl('http://www.delphiturk.com/Forums.aspx?Forums=251',700,500,true);
end;

procedure TFmMain.MteriTemsilcisineUlan1Click(Sender: TObject);
begin
  GotoUrl('http://www.advantageturk.com/ContactForm.aspx', 0, 0, True);
end;

procedure TFmMain.AdvantageWebSitesi1Click(Sender: TObject);
begin
  GotoUrl('http://www.advantageturk.com', 0, 0, True);
end;

procedure TFmMain.VeriTabanLimitleri2Click(Sender: TObject);
begin
  GotoUrl('www.kaleyazilim.com.tr', 0, 0, True);
end;

procedure TFmMain.rkeKullanmKlavuzunundir1Click(Sender: TObject);
begin
  GotoUrl('http://www.advantageturk.com/Downloads/Doc/Turkce/AdvantageManual.zip', 0, 0, True);
end;

procedure TFmMain.AdvantagePerformansDemosu1Click(Sender: TObject);
begin
  with TFmPerformans.Create(nil) do
  try
    Execute;
  finally
    Free;
  end;    

end;

procedure TFmMain.VeriTabanLimitleri1Click(Sender: TObject);
begin
  with TFmDbLimits.Create(nil) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TFmMain.OptionsActionExecute(Sender: TObject);
begin
  FmOptions.Execute;
end;

procedure TFmMain.CheckCmdLine;
var DB: TDatabase;
    Node: TTreeNode;
begin
  if ParamStr(1) <> '' then
  begin
    Show;
    Update;
    Db := FindDatabaseItemFromDict(ParamStr(1));
    if DB = nil then
      OpenDictionary(ParamStr(1))
    else begin
      Node := FindTVItem(DB);
      if Node = nil then
       OpenDictionary(ParamStr(1))
      else begin
       TV.Selected := Node;
       DB.Open;
      end;
    end;
  end;
end;

procedure TFmMain.OpenDictionary(const FileName: string);
var NewItem: TDatabase;
begin
  TV.Selected := TV.Items[0];
  NewItem := TDatabaseList(TV.Items[0].Data).AddDatabase(FileName);
  ItemEvent(TDatabaseList(TV.Items[0].Data), evChildsDestroyed);
  ItemEvent(TDatabaseList(TV.Items[0].Data), evChildsCreated);
  if NewItem <> nil then
  begin
    TV.Selected := FindTVItem(NewItem);
    NewItem.Open;
  end;
end;

function TFmMain.FindDatabaseItemFromDict(
  const FileName: string): TDatabase;
var List: TDatabaseList;
    DB: TDatabase;
    I: Integer;
begin
  Result := nil;
  List := TDatabaseList(TV.Items[0].Data);
  for I := 0 to List.ItemCount - 1 do
  begin
    DB := TDatabase(List[i]);
    if CompareText(DB.GetPropertyValue(0), FileName) = 0 then
    begin
      Result := DB;
      Break;
    end;
  end;
end;

procedure TFmMain.BeniOku1Click(Sender: TObject);
var S: string;
begin
  S := GetAppPath + 'benioku.txt';
  ShellExecute(self.Handle, 'open', PChar(S), nil, nil, SW_SHOWNORMAL);
end;

procedure TFmMain.RegisterAddFile;
begin
  RegisterExtension('.add', 'Advantage Veri Sözlük Dosyasý', Application.ExeName);
end;

procedure TFmMain.SzlkDosyalarnlikilendir1Click(Sender: TObject);
begin
  RegisterAddFile;
  MessageDlg('Ýþlem baþarýlý', mtInformation, [mbOK], 0);
end;

procedure TFmMain.LVKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    LVDblClick(Sender);
    Key := #0;
  end;
end;

procedure TFmMain.LVKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var Item: TDBBaseItem;
    Node: TTreeNode;
begin
  if LV.Selected = nil then Exit;
  if Key = VK_DELETE then
  begin
    Item := TDBBaseItem(LV.Selected.Data);
    if not Item.IsList then
    begin
      Item.SendCommand(dcDrop);
    end;
  end;
end;

procedure TFmMain.CloseDatabaseForms(ADict: TAdsDictionary);
var I: Integer;
    AForm: TForm;
begin
  for I := 0 to Screen.FormCount - 1 do
  begin
    AForm := Screen.Forms[I];
    if AForm is TFmSQL then
    begin
      //AForm := TFmSQL(AForm);
      if ADict = nil then
      begin
        AForm.Close;
      end else begin
        if TFmSQL(AForm).Dictionary = ADict then
        begin
          AForm.Close;
        end;
      end;
    end;
  end;
end;

procedure TFmMain.DestroyItems;
var Obj: TObject;
begin
  Obj := TObject(TV.Items[0].Data);
  TDatabaseList(Obj).Close;
  TDatabaseList(Obj).Free;
end;

procedure TFmMain.LVInfoTip(Sender: TObject; Item: TListItem;
  var InfoTip: String);
begin
  try
    if Item.Selected then InfoTip := TDBItem(Item.Data).Hint;
  except
  end;
end;

procedure TFmMain.LoadSettings;
begin
  PnlLeftMain.Width := ReadIntRegKey('PnlLeftMain', PnlLeftMain.Width);
  LV.ViewStyle := TViewStyle(ReadIntRegKey('MainFormViewStyle', Integer(LV.ViewStyle)));
end;

procedure TFmMain.SaveSettibgs;
begin
  WriteIntRegKey('PnlLeftMain', PnlLeftMain.Width);
  WriteIntRegKey('MainFormViewStyle', Integer(LV.ViewStyle));
end;


function TFmMain.GetCommandImageIndex(Item: TDBBaseItem; Cmd: TDBCommand): Integer;
begin
   case Cmd of
    dcNew : if Item is TDBTable then Result := 36
            else Result := 25;
    dcDrop: Result := 37;
    dcHelp: Result := 33;
    dcProperties: Result := 38;
    dcOpen: begin
              if Item is TDBProc then Result := 27
              else Result := 28;
            end;
    dcSQL: Result := 11;
    dcClose: Result := 29;
    dcEdit: if Item is TDBTable then Result := 35
            else Result := 30;
    dcChPassw: Result := 31;
    dcDeleteFile: Result := 34;
    dcExportToCode: Result := 32;
    dcExport: Result := 43;

   else Result := -1;
   end;
end;

procedure TFmMain.AcExportAsCodeExecute(Sender: TObject);
begin
  GetCurrentSelectedItem.SendCommand(dcExportToCode);
end;

procedure TFmMain.AcPropertiesExecute(Sender: TObject);
begin
  GetCurrentSelectedItem.SendCommand(dcProperties);
end;

procedure TFmMain.AcPropertiesUpdate(Sender: TObject);
var Item: TDBBaseItem;
begin
  Item := GetCurrentSelectedItem;
  if (Item is TDatabase) then
    AcProperties.Enabled :=  TDatabase(Item).ItemsCreated
  else
    AcProperties.Enabled := not (Item.IsList);
end;

procedure TFmMain.AcExportAsCodeUpdate(Sender: TObject);
begin
  AcExportAsCode.Enabled := not (GetCurrentSelectedItem is TDatabaseList);
end;

procedure TFmMain.AcDropItemUpdate(Sender: TObject);
var Item: TDBBaseItem;
begin
  Item := GetCurrentSelectedItem;
  AcDropItem.Enabled := (not Item.IsList) and (not (Item is TDatabase));
end;

procedure TFmMain.AcDropItemExecute(Sender: TObject);
begin
  GetCurrentSelectedItem.SendCommand(dcDrop);
end;

procedure TFmMain.AcExportExecute(Sender: TObject);
  var mDB : TDatabase;
begin
  //if GetCurrentSelectedItem is TDBTable then
  // GetCurrentSelectedItem.SendCommand(dcExport)
  //else
  begin
    mDB := GetSelectedDatabase(True);
    if not mDb.ItemsCreated then mDb.Open;
    with TFmDataExport.Create(nil) do
    try
      ExportDictionary(mdb.Dictionary);
    finally
      Free;
    end;
  end;
end;

procedure TFmMain.AcPerformansExecute(Sender: TObject);
begin
  with TFmPerformans.Create(nil) do
  try
    Execute;
  finally
    Free;
  end;
end;

end.
