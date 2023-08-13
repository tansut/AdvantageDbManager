unit UTableInfs;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, ToolWin, StdCtrls, ImgList, adsdictionary,
  Menus, SynEdit, SynEditHighlighter, SynHighlighterSQL;

type
  TFmTables = class(TForm)
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    Tables: TListView;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Fields: TListView;
    ImageList1: TImageList;
    ToolButton3: TToolButton;
    PopupMenu1: TPopupMenu;
    UseTableNames: TMenuItem;
    UseQuota: TMenuItem;
    PopupMenu2: TPopupMenu;
    AddTableAst: TMenuItem;
    AddTableFields: TMenuItem;
    PopupMenu3: TPopupMenu;
    AddField: TMenuItem;
    edInfo: TSynEdit;
    shSQL: TSynSQLSyn;
    abloAd1: TMenuItem;
    N1: TMenuItem;
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure TablesClick(Sender: TObject);
    procedure TablesDblClick(Sender: TObject);
    procedure AddTableAstClick(Sender: TObject);
    procedure AddTableFieldsClick(Sender: TObject);
    procedure AddFieldClick(Sender: TObject);
    procedure UseTableNamesClick(Sender: TObject);
    procedure UseQuotaClick(Sender: TObject);
    procedure FieldsDblClick(Sender: TObject);
    procedure abloAd1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    FDict: TAdsDictionary;
    function GetField(const Field: string): string;
    function GetTable(const Table: string): string;
    procedure AddInfo(const Info: string);
    
  public
    function Execute(ADict: TAdsDictionary): string;
  end;

var
  FmTables: TFmTables;

implementation

{$R *.dfm}

function TFmTables.Execute(ADict: TAdsDictionary): string;
var Item: TListItem;
    List: TStringList;
    I: Integer;
begin
  EdInfo.Lines.Clear;
  List := TStringList.Create;
  FDict := ADict;
  try
    ADict.GetTableNames(List);
    List.Sorted := True;
    List.Sort;
    for i := 0 to List.Count - 1 do
    begin
      Item := Tables.Items.Add;
      Item.Caption := List[i];
      Item.ImageIndex := 0;
    end;
    if List.Count > 0 then
    begin
      Tables.Selected := Tables.Items[0];
      TablesClick(nil);
    end;  
  finally
    List.Free;
  end;
  if ShowModal = mrOk then Result := EdInfo.Text
  else Result := '';
end;

procedure TFmTables.ToolButton1Click(Sender: TObject);
begin
  ModalResult := mrOK; 
end;

procedure TFmTables.ToolButton2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFmTables.TablesClick(Sender: TObject);
var Item: TListItem;
    List: TStringList;
    I: Integer;
begin
  Item := Tables.Selected;
  if Item <> nil then
  try
    Fields.Items.BeginUpdate;
    List := TStringList.Create;
    FDict.GetFieldNames(Item.Caption, List);
    Fields.Items.Clear;
    List.Sorted := True;
    List.Sort;
    for I := 0 to List.Count - 1 do
    begin
      Item := Fields.Items.Add;
      Item.Caption := List[i];
      Item.ImageIndex := 1;
    end;
  finally
    List.Free;
    Fields.Items.EndUpdate;
  end;
end;

procedure TFmTables.TablesDblClick(Sender: TObject);
begin
  AddTableAstClick(Self);
end;

procedure TFmTables.AddTableAstClick(Sender: TObject);
begin
  if Tables.Selected = nil then Exit;
  AddInfo(GetTable(Tables.Selected.Caption) + '.*');
end;

procedure TFmTables.AddTableFieldsClick(Sender: TObject);
var FieldList, Temp: string;
    I: Integer;
begin
  if Tables.Selected = nil then Exit;
  FieldList := '';
  for I := 0 to Fields.Items.count - 1 do
  begin
    Temp := GetField(Fields.Items[i].Caption);
    FieldList := FieldList + Temp;
    if I <> Fields.Items.count - 1 then
      FieldList := FieldList + ', ';
  end;
  AddInfo(FieldList);
end;

procedure TFmTables.AddFieldClick(Sender: TObject);
begin
  if Fields.Selected = nil then Exit;
  AddInfo(GetField(Fields.Selected.Caption));
end;

procedure TFmTables.AddInfo(const Info: string);
begin
  if Trim(EdInfo.Lines.Text) = '' then
    EdInfo.Lines.Text := EdInfo.Lines.Text + Info
  else if Trim(EdInfo.Lines.Text)[Length(Trim(EdInfo.Lines.Text))] <> ',' then
  begin
    EdInfo.Lines.Text := Trim(EdInfo.Lines.Text) + ', ' + Info;
  end else
    EdInfo.Lines.Text := Trim(EdInfo.Lines.Text) + Info;
end;

function TFmTables.GetField(const Field: string): string;
var Table: string;
begin
  if UseTableNames.Checked and (Tables.Selected <> nil) then
    Table := GetTable(Tables.Selected.Caption)
  else
    Table := '';
  if Table <> '' then
  begin
    if UseQuota.Checked then Result := Table + '."' + Field + '"'
    else Result := Table + '.' + Field;
  end else if UseQuota.Checked then
  begin
    Result := '"' + Field + '"';
  end else Result := Field;
end;

function TFmTables.GetTable(const Table: string): string;
begin
  if UseQuota.Checked then Result := '"' + Table + '"'
  else Result := Table;
end;

procedure TFmTables.UseTableNamesClick(Sender: TObject);
begin
  UseTableNames.Checked := not UseTableNames.Checked;
end;

procedure TFmTables.UseQuotaClick(Sender: TObject);
begin
  UseQuota.Checked := not UseQuota.Checked;
end;

procedure TFmTables.FieldsDblClick(Sender: TObject);
begin
  AddFieldClick(self);
end;

procedure TFmTables.abloAd1Click(Sender: TObject);
begin
  AddInfo(GetTable(Tables.Selected.Caption));
end;

procedure TFmTables.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then Close;
end;

end.
