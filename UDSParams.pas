unit UDSParams;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, DB, adsdata, adsfunc, adstable, ImgList;

type
  TFmQueryParams = class(TForm)
    LV: TListView;
    edValue: TEdit;
    CmbType: TComboBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ImgSmall: TImageList;
    ChkAutoShow: TCheckBox;
    procedure LVSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FParams: TParams;
  public
    function Execute(Params: TParams): Boolean;
    function GetFieldType(const S: string): TFieldType;
  end;

var
  FmQueryParams: TFmQueryParams;

implementation

uses UAdvTypes, UADVUTILS;

{$R *.dfm}

procedure TFmQueryParams.LVSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  if Item = nil then Exit;
  if ChkAutoShow.Checked then
  begin
    edValue.Text := Item.SubItems[0];
    CmbType.ItemIndex := CmbType.Items.IndexOf(Item.SubItems[1]);
    try
      edValue.SetFocus;
    except
    end;  
  end;  
end;

procedure TFmQueryParams.Button3Click(Sender: TObject);
begin
  if LV.Selected = nil then raise Exception.Create('Lütfen paramtere belirleyiniz');
  LV.Selected.SubItems[0] := edValue.Text;
  LV.Selected.SubItems[1] := CmbType.Text;
end;

function TFmQueryParams.Execute(Params: TParams): Boolean;
var I: Integer;
    FT: TFieldType;
    Item: TListItem;
begin
  FParams := Params;
  LV.Items.Clear;
  CmbType.Items.Clear;
  for FT := Low(TFieldType) to High(TFieldType) do
    CmbType.Items.Add(FieldTypeStr[FT]);
  CmbType.ItemIndex := 0;
  for I := 0 to FParams.Count - 1 do
  begin
    Item := LV.Items.Add;
    Item.Caption := FParams[I].Name;
    Item.SubItems.Add(FParams[I].Value);
    Item.SubItems.Add(FieldTypeStr[FParams[I].DataType]);
    Item.Checked := True;
    Item.ImageIndex := 0;
  end;
  Result := ShowModal = mrOK;
end;

procedure TFmQueryParams.Button1Click(Sender: TObject);
var I: Integer;
    Item: TListItem;
begin
  try
   Button3Click(self);
  except
  end; 
  for I := 0 to LV.Items.Count - 1 do
  begin
    Item := LV.Items[I];
    if Item.Checked then
    begin
      FParams[I].DataType := GetFieldType(Item.SubItems[1]);
      FParams[I].Value := Item.SubItems[0];
    end else
    begin
      FParams[I].DataType := ftUnknown;
      FParams[I].Value := Unassigned;
    end;
  end;
end;

function TFmQueryParams.GetFieldType(const S: string): TFieldType;
var
  FT: TFieldType;
begin
  Result := Low(TFieldType);
  for FT := Low(TFieldType) to High(TFieldType) do
  if S = FieldTypeStr[FT] then
  begin
    Result := FT;
    Break;
  end;
end;

procedure TFmQueryParams.FormShow(Sender: TObject);
begin
  LV.SetFocus;
  if Lv.Items.Count > 0 then
    LV.Selected := Lv.Items[0];
  LVSelectItem(LV, LV.Selected, True);
end;

procedure TFmQueryParams.FormCreate(Sender: TObject);
begin
  ChkAutoShow.Checked := ReadBoolRegKey('AutoShowQueryParams', True);
end;

procedure TFmQueryParams.FormDestroy(Sender: TObject);
begin
  WriteBoolRegKey('AutoShowQueryParams', ChkAutoShow.Checked);
end;

end.
