unit UDbDelete;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  adsdata, adscnnct,adsdictionary,UDBItems, StdCtrls, ExtCtrls, ComCtrls,
  AdvListV, ImgList, Buttons,UAdsTable,UAdvUtils,CommCtrl,Inifiles;

const SilType: array[Boolean] of string = ('Hayýr', 'Evet');

type

  TfmDbDelete = class(TForm)
    Image1: TImage;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    ImgSmall: TImageList;
    GroupBox1: TGroupBox;
    LvTables: TAdvListView;
    AliasName: TLabel;
    DbName: TLabel;
    BtDeselectAll: TSpeedButton;
    BtSelectAll: TSpeedButton;
    btnHelp: TButton;
    procedure LvTablesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure BtSelectAllClick(Sender: TObject);
    procedure BtDeselectAllClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
  private
    DictPath: string;
    function GetListViewItem(ListView: TadvListView; var SubItem: Integer;
      P: TPoint): TListItem;
    procedure ToggleListItem(ListView: TAdvListView; Item: TListItem;
      SubItem: Integer);
    { Private declarations }
  public
    { Public declarations }
     Dictionary:TAdsDictionary;
     procedure AddToListView(ListView: TAdvListView; Name,Path: string;  sil: Boolean);
     procedure FillTables;
     function Init:boolean;
     procedure DeleteDb;
  end;

var
  fmDbDelete: TfmDbDelete;

implementation

{$R *.DFM}

{ TfmDbDelete }

function TfmDbDelete.GetListViewItem(ListView: TadvListView; var SubItem: Integer; P: TPoint): TListItem;
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

procedure TfmDbDelete.ToggleListItem(ListView: TAdvListView;
  Item: TListItem; SubItem: Integer);
var Res: Boolean;
begin
  Res := Item.SubItems[SubItem] = SilType[True];
  Res := not Res;
  Item.SubItems[SubItem] := SilType[Res];
  ListView.SubItemImages[Item.Index, SubItem] := Integer(Res) + 1;
 // if Item.SubItems[ListView.Columns.Count] = '0' then Item.Caption := Item.Caption + ' (*)';
 // Item.SubItems[ListView.Columns.Count] := '1';
end;

procedure TfmDbDelete.AddToListView(ListView: TAdvListView;
  name,path: string; sil: Boolean);
var
  Item: TListItem;
begin
  Item := ListView.Items.Add;
  Item.Caption := Name;
  Item.ImageIndex := -1;
  Item.SubItems.Add(path);
  ListView.SubItemImages[Item.Index, 0] :=-1;
  Item.SubItems.Add(SilType[sil]);
  ListView.SubItemImages[Item.Index,1] :=1;
end;

procedure TfmDbDelete.DeleteDb;
var
  i:integer;
  TempTable:string;
  adsFile:TIniFile;
begin
 try
  if MessageDlg('Veri tabaný ve seçilen tablolar fiziksel olarak silinecek.Emin misiniz?',
      mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      exit;

  Dictionary.Disconnect;

  for i:=0 to LvTables.Items.Count-1 do
     if LvTables.Items[I].SubItems[1] =SilType[true] then begin
        TempTable:=LvTables.Items[I].SubItems[0]+LvTables.Items[I].Caption;
        if FileExists(TempTable+'.ADT') then
           DeleteFile(TempTable+'.ADT');
        if FileExists(TempTable+'.ADI') then
           DeleteFile(TempTable+'.ADI');
        if FileExists(TempTable+'.ADM') then
           DeleteFile(TempTable+'.ADM');
        if FileExists(TempTable+'.ADT') then
           DeleteFile(TempTable+'.ADT');
     end;

  TempTable:=copy(DbName.Caption,1,Length(DbName.Caption)-4);
  if FileExists(TempTable+'.ADD') then
    DeleteFile(TempTable+'.ADD');
  if FileExists(TempTable+'.AM') then
    DeleteFile(TempTable+'.AM');
  if FileExists(TempTable+'.AI') then
    DeleteFile(TempTable+'.AI');
  showMessage('Veri tabaný Silindi.');
  if AliasName.Caption<>'' then begin
    adsFile := TIniFile.Create( GetWinDir+'\ads.ini');
    try
      if  (adsFile.ReadString( 'Databases',AliasName.Caption, 'exists' )<> 'exists') then
        adsFile.DeleteKey('Databases',AliasName.Caption);
    finally
      adsFile.Free;
    end;
  end;
  ModalResult:=mrOK;
//  Close;
  except
   on e:Exception do ShowMessage('Veritabaný silinemedi.Hata:'+e.message);
  end;
end;

procedure TfmDbDelete.FillTables;
var
  AdsTable:TDbAdsTable;
  Tables: TStringList;
  i:integer;
  tempName:string;
  tempPath:string;
begin
  try
  tables:=TStringList.Create;
  //LvTables.Items.Clear;
  Dictionary.GetTableNames(tables);
  for i:=0 to tables.Count-1 do begin
    try
      AdsTable:=TDBAdsTable.Create(Dictionary,tables[i]);
      tempPath:=AdsTable.TablePath;
      tempName:=GetNameFromFileName(tempPath);
      tempPath:=copy(tempPath,1,pos(tempName,tempPath)-1);
      AddToListView(LvTables,tables[i],tempPath,false);
    finally
      AdsTable.Destroy;
    end;
  end;
  finally
    Tables.Free;
  end;
end;

function TfmDbDelete.Init:boolean;
var
  Conn :TAdsConnection;
begin
   conn:=TAdsConnection.Create(nil);
   try
     ConvertDictToConn(Dictionary,conn);
     DbName.Caption:=conn.GetConnectionWithDDPath;
     AliasName.Caption:=Dictionary.AliasName;
     DictPath:=conn.GetConnectionPath;
   finally
     conn.Free;
   end;
   FillTables;
   result:=ShowModal=mrOK;
end;


procedure TfmDbDelete.LvTablesMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var Item: TListItem;
    Index: Integer;
begin
  Item := GetListViewItem(Sender As TAdvListView, Index, Point(X, Y));
  if (Item <> nil) and (Index >= 1) then ToggleListItem(Sender As TAdvListView, Item, Index);
end;

procedure TfmDbDelete.btnOKClick(Sender: TObject);
begin
  DeleteDb;
end;

procedure TfmDbDelete.btnCancelClick(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

procedure TfmDbDelete.BtSelectAllClick(Sender: TObject);
begin
  SelectListCheck(LvTables,1,true,2);
end;

procedure TfmDbDelete.BtDeselectAllClick(Sender: TObject);
begin
  SelectListCheck(LvTables,1,false,1);
end;

procedure TfmDbDelete.btnHelpClick(Sender: TObject);
begin
  Application.HelpCommand (HELP_CONTEXT,22); 
end;

end.
