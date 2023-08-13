unit UFmDataExport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdsData, StdCtrls, AdsDataExporter, ComCtrls, DB, indexcombo,
  ImgList, RzPrgres, RzStatus, ExtCtrls, RzPanel, Mask, ToolEdit,
  UFmExportCode, AdsExporterFactory, AdsDataExportXML, AdsDataExportADT, jpeg, Buttons,
  adsdictionary, adstable, adsfunc, adscnnct;

type
  TDataExportFormMode = (defSingle, defMulti);
  TFmDataExport = class(TForm)
    Exporter: TAdsDataExporter;
    DS: TDataSource;
    ImageList1: TImageList;
    Panel1: TPanel;
    Panel2: TPanel;
    Image1: TImage;
    Label3: TLabel;
    Image2: TImage;
    Panel3: TPanel;
    Bevel1: TBevel;
    NB: TNotebook;
    ExporterList: TListView;
    LblIndex: TLabel;
    BtnCancel: TButton;
    BtnNext: TButton;
    Label1: TLabel;
    DSList: TListView;
    FieldList: TListView;
    Label4: TLabel;
    OrderByIndexCombo: TdrmIndexCombo;
    btnBack: TButton;
    LastMsg: TLabel;
    dirDB: TDirectoryEdit;
    edFileName: TFilenameEdit;
    PBar: TProgressBar;
    btnStart: TBitBtn;
    LblExporter: TLabel;
    DSBar: TProgressBar;
    LogList: TListView;
    Label5: TLabel;
    ExportConn: TAdsConnection;
    procedure BtnNextClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DSListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure btnBackClick(Sender: TObject);
    procedure NBPageChanged(Sender: TObject);
    procedure ExporterListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure btnStartClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DSListChanging(Sender: TObject; Item: TListItem;
      Change: TItemChange; var AllowChange: Boolean);
  private
    FDataSet: TAdsDataSet;
    FDictionary: TAdsDictionary;
    FMode: TDataExportFormMode;
    procedure Initialize;
    procedure GetExporters;
    procedure GetSingleFields;
    procedure Validate;
    procedure SetMode(const Value: TDataExportFormMode);
    function AddDataSet(DSName: string): TListItem;
    procedure ExportMultiDs;
    procedure ExportSingleDs;
    function CheckExists(LV: TListView): Boolean;
    function GetExportType: TAdsExportDestinationType;
    procedure OnExportProgress(PercentDone: Integer);
    function GetDataSetTitle(ADataSet: TAdsDataSet): string;
    procedure _ExportDataSet(ADataSet: TAdsDataSet; const FileName: string; Fields: TStrings);
    procedure GetSelectedTables(List: TStringList);
    procedure GetSelectedFields(const TableName: string; List: TStringList);
  public
    procedure ExportDataSet(DataSet: TAdsDataSet);
    procedure ExportDictionary(ADict: TAdsDictionary);
    property Mode: TDataExportFormMode read FMode write SetMode;

  end;

var
  FmDataExport: TFmDataExport;

implementation

uses UADVUTILS;

{$R *.dfm}

{ TFmDataExport }

procedure TFmDataExport.ExportDataSet(DataSet: TAdsDataSet);
begin
  FDataSet := DataSet;
  DS.DataSet := FDataSet;
  Mode := defSingle;
  AddDataSet(GetDataSetTitle(FDataSet));
  DSList.Items[0].Selected := True;
  GetSingleFields;
  ShowModal;
end;

procedure TFmDataExport.GetExporters;
var Exporters: TAdsDataExporterInfoList;
    I: Integer;
    Item: TListItem;
begin
  ExporterList.Items.Clear;
  Exporters := TAdsDataExporterFactory.GetRegisteredAdsDataExporters;
  for I := Low(Exporters) to High(Exporters) do
  begin
    Item := ExporterList.Items.Add;
    Item.Caption := Exporters[I].Title;
    Item.ImageIndex := 0;
    Item.Data := @(Exporters[I]);
  end;
  ExporterList.Items[0].Selected := True;
end;

procedure TFmDataExport.GetSingleFields;
var
  Item: TListItem;
  I: Integer;
begin
  FieldList.Items.Clear;
  if not FDataSet.FieldDefs.Updated then
    FDataSet.FieldDefs.Update;
  for I := 0 to FDataSet.FieldDefs.Count - 1 do
  begin
    Item := FieldList.Items.Add;
    Item.Caption := FDataSet.FieldDefs[I].Name;
    Item.Checked := True;
    Item.ImageIndex := 1;
  end;
end;

procedure TFmDataExport.BtnNextClick(Sender: TObject);
var
 Temp: Boolean;
begin
  Validate;
  case NB.PageIndex of
  0: begin
       Temp := True;
       if Mode = defMulti then DSListChanging(DsList, DsList.Selected, ctState, Temp);
       NB.PageIndex := 1;
     end;
  1: NB.PageIndex := 2;
  end;
end;

procedure TFmDataExport.Validate;
begin
  case NB.PageIndex of
  0:
   begin
     if not CheckExists(DSList) then
      raise Exception.Create('Lütfen veri kümesi seçiniz');
     if (Mode = defSingle) and (not CheckExists(FieldList)) then
      raise Exception.Create('Lütfen enaz bir alan seçiniz');
   end;
  1:
   begin
     if ExporterList.Selected = nil then
      raise Exception.Create('Lütfen dýþ ortam veri aktarým nesnesi seçiniz');
   end;
  2:
   begin
     if (Mode = defSingle) and (edFileName.Text = '') then
      raise Exception.Create('Lütfen aktarým yapýlmasýný istediðiniz dosyayý belirtiniz')
     else if (Mode = defMulti) and (dirDB.Text = '') then
      raise Exception.Create('Lütfen aktarým yapýlmasýný istediðiniz klasörü belirtiniz')
   end;
  end;
end;

procedure TFmDataExport.FormCreate(Sender: TObject);
begin
  Initialize;
end;

procedure TFmDataExport.Initialize;
begin
  btnBack.Enabled := False;
  NB.PageIndex := 0;
  GetExporters;
end;

procedure TFmDataExport.ExportDictionary(ADict: TAdsDictionary);
var List, FList: TStringList;
    I: Integer;
    Item: TListItem;
begin
  Mode := defMulti;
  FDictionary := ADict;
  List := TStringList.Create;
  DSList.OnChanging := nil;
  try
    ADict.GetTableNames(List);
    for I := 0 to List.Count - 1 do
    begin
      Item := AddDataSet(List[I]);
      FList := TStringList.Create;
      ADict.GetFieldNames(List[I], FList);
      Item.Data := FList;
    end;
    if DSList.Items.Count > 0 then
     DSList.Selected := DSList.Items[0];
  finally
    List.Free;
    DSList.OnChanging := DSListChanging;
  end;
  ShowModal;
end;

procedure TFmDataExport.SetMode(const Value: TDataExportFormMode);
begin
  FMode := Value;
  if FMode = defSingle then
  begin
    LastMsg.Caption := 'Lütfen veri kümesi bilgilerinin aktarýlacaðý dýþ dosyayý belirtiniz.';
    dirDB.Visible := False;
    edFileName.Visible := True;
    LblIndex.Visible := True;
    OrderByIndexCombo.Visible := True;
  end else
  begin
    LblIndex.Visible := False;
    OrderByIndexCombo.Visible := False;
    dirDB.Visible := True;
    edFileName.Visible := False;
    LastMsg.Caption := 'Veri kümelerinin aktarýlacaðý dizini belirtiniz. Dosyalar Advantage tablo isimleri olarak yaratýlacaktýr';
  end;
end;

function TFmDataExport.AddDataSet(DSName: string): TListItem;
var
  Item: TListItem;
begin
  Item := DSList.Items.Add;
  Item.ImageIndex := 2;
  Item.Caption := DSName;
  Item.Checked := True;
  Item.Data := nil;
  Result := Item;
end;

procedure TFmDataExport.DSListSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var I: Integer;
    TempList, CList: TStringList;
    AItem: TListItem;
begin
  if (Item = nil) or (not Selected) then Exit;
  if Mode = defMulti then
  begin
    FieldList.Items.BeginUpdate;
    TempList := TStringList.Create;
    try
      FieldList.Items.Clear;
      FDictionary.GetFieldNames(Item.Caption, TempList);
      for I := 0 to TempList.Count - 1 do
      begin
        AItem := FieldList.Items.Add;
        AItem.Caption := TempList[I];
        AItem.ImageIndex := 1;
        CList := TStringList(Item.Data);
        AItem.Checked := CList.IndexOf(TempList[I]) <> -1;
      end;
    finally
      FieldList.Items.EndUpdate;
      TempList.Free;
    end;
  end;
end;

procedure TFmDataExport.btnBackClick(Sender: TObject);
begin
  case NB.PageIndex of
  1: NB.PageIndex := 0;
  2: NB.PageIndex := 1;
  end;
end;

procedure TFmDataExport.NBPageChanged(Sender: TObject);
begin
  btnBack.Enabled := NB.PageIndex <> 0;
  BtnNext.Enabled := NB.PageIndex <> 2;
end;

procedure TFmDataExport.ExporterListSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  if (Item <> nil) and (Selected) then
    LblExporter.Caption := Item.Caption;
end;

procedure TFmDataExport.btnStartClick(Sender: TObject);
begin
  if btnStart.Tag = 0 then
  begin
    Validate;
    edFileName.Enabled := False;
    dirDB.Enabled := False;
    BtnCancel.Caption := 'Kapat';
    btnStart.Tag := 1;
    btnStart.Caption := 'Ýþlemi Ýptal Et';
    BtnNext.Enabled := False;
    btnBack.Enabled := False;
    BtnCancel.Enabled := False;
    if Mode = defSingle then ExportSingleDS
    else ExportMultiDs;
  end else if btnStart.Tag = 1 then
  begin
    if MessageDlg('Ýþlem iptal edilsin mi ?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;
    Exporter.GetAdsExportDestination.CancelExport;
    btnStart.Visible := False;
    BtnCancel.Enabled := True;
  end;
end;

procedure TFmDataExport.ExportMultiDs;
var TableList, FieldList: TStringList;
    I: Integer;
    ATable: TAdsTable;
    BaseDir: string;
begin
  TableList := TStringList.Create;
  FieldList := TStringList.Create;
  ConvertDictToConn(FDictionary, ExportConn);
  ExportConn.Connect;
  ATable := TAdsTable.Create(nil);
  ATable.AdsConnection := ExportConn;
  BaseDir := dirDB.Text;
  if (Basedir[Length(BaseDir)] <> '\') or (Basedir[Length(BaseDir)] <> '/') then
    Basedir := BaseDir + '\';
  try
    GetSelectedTables(TableList);
    DSBar.Max := TableList.Count;
    DSBar.Position := 0;
    for I := 0 to TableList.Count - 1 do
    begin
      ATable.TableName := TableList[I];
      ATable.Open;
      GetSelectedFields(TableList[I], FieldList);
      _ExportDataSet(ATable, BaseDir + TableList[I], FieldList);
      DSBar.Position := I + 1;
      Application.ProcessMessages;
      ATable.Close;
    end;
  finally
    BtnCancel.Enabled := True;
    btnStart.Visible := False;
    TableList.Free;
    FieldList.Free;
    ExportConn.Disconnect;
  end;
end;

procedure TFmDataExport.ExportSingleDs;
var Fields: TStrings;
    I: Integer;
begin
  Fields := TStringList.Create;
  for I := 0 to FieldList.Items.Count - 1 do
   if FieldList.Items[I].Checked then
    Fields.Add(FieldList.Items[I].Caption);
  try
    _ExportDataSet(FDataSet, edFileName.Text, Fields);
  finally
   Fields.Free;
   BtnCancel.Enabled := True;
   btnStart.Visible := False;
  end;
end;

function TFmDataExport.CheckExists(LV: TListView): Boolean;
var I: Integer;
begin
  Result := True;
  for I := 0 to LV.Items.Count - 1 do
   if LV.Items[I].Checked then Exit;
  Result := False;
end;

function TFmDataExport.GetExportType: TAdsExportDestinationType;
var I: Integer;
    Exporters: TAdsDataExporterInfoList;
begin
  Exporters := TAdsDataExporterFactory.GetRegisteredAdsDataExporters;
  for I := 0 to ExporterList.Items.Count - 1 do
   if ExporterList.Items[I].Selected then
   begin
     //Result := TAdsExportDestinationType(I);
     // anlayamadým, olmasý lazým ????? üstteki ile deðiþtirdim: tansu
     Result := Exporters[I].AdsExportDestinationType;
     Break;
   end;
end;

procedure TFmDataExport.OnExportProgress(PercentDone: Integer);
begin
  PBar.Position := PercentDone;
  Application.ProcessMessages;
end;

procedure TFmDataExport._ExportDataSet(ADataSet: TAdsDataSet;
  const FileName: string; Fields: TStrings);
var Item: TListItem;
begin
  Exporter.Source := ADataSet;
  Exporter.AdsExportDestination := GetExportType;
  if ExtractFileExt(FileName) <> '' then
    Exporter.FileName := FileName
  else
    Exporter.FileName := FileName + '.' + Exporter.GetAdsExportDestination.GetFileExtension;
  Exporter.Fields := Fields;
  Exporter.GetAdsExportDestination.ProgressFunction := OnExportProgress;
  Item := LogList.Items.Add;
  Item.Caption := GetDataSetTitle(ADataSet);
  Item.SubItems.Add('Ýþlem sürüyor ...');
  Item.ImageIndex := 5;
  Item.Selected := True;
  Update;
  ADataSet.DisableControls;
  try
   Exporter.StartExport;
   Item.ImageIndex := 4;
   Item.SubItems[0] := 'Baþarýlý';
   ADataSet.EnableControls;
   Update;
  except
   on E: Exception do
   begin
     Item.ImageIndex := 3;
     Item.SubItems[0] := E.Message;
     ADataSet.EnableControls;
     Update;
   end;
  end;
end;

function TFmDataExport.GetDataSetTitle(ADataSet: TAdsDataSet): string;
begin
  if ADataSet is TAdsTable then Result := TAdsTable(ADataSet).TableName
  else if ADataSet is TAdsQuery then Result := 'Advantage Sorgusu'
  else if ADataSet is TAdsStoredProc then Result := TAdsStoredProc(ADataSet).StoredProcName
  else Result := 'Advantage Veri Kümesi';
end;

procedure TFmDataExport.FormDestroy(Sender: TObject);
var List: TStringList;
    I: Integer;
begin
  if Mode = defMulti then
  begin
    DSList.OnChanging := nil;
    DSList.OnSelectItem := nil;
    for i := 0 to DSList.Items.Count - 1 do
    begin
      List := TStringList(DSList.Items[I].Data);
      List.Free;
    end;
  end;
end;

procedure TFmDataExport.DSListChanging(Sender: TObject; Item: TListItem;
  Change: TItemChange; var AllowChange: Boolean);
var List: TStringList;
    I: Integer;
begin
  if (Change <> ctState) or (Item.Data = nil) or (Item <> DSList.Selected) then Exit;
  List := TStringList(Item.Data);
  List.Clear;
  for I := 0 to FieldList.Items.Count - 1 do
  begin
    if FieldList.Items[I].Checked then
     List.Add(FieldList.Items[I].Caption)
  end;
end;

procedure TFmDataExport.GetSelectedFields(const TableName: string;
  List: TStringList);
var I: Integer;
begin
  List.Clear;
  for I := 0 to DSList.Items.Count - 1 do
  begin
    if DSList.Items[I].Caption = TableName then
    begin
      List.AddStrings(TStringList(DSList.Items[I].Data));
      Break;
    end;
  end;
end;

procedure TFmDataExport.GetSelectedTables(List: TStringList);
var I: Integer;
begin
  List.Clear;
  for I := 0 to DSList.Items.Count - 1 do
  begin
    if DSList.Items[I].Checked then List.Add(DSList.Items[I].Caption);
  end;
end;

end.
