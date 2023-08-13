unit Ualias;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, ToolEdit, ComCtrls, IniFiles, ImgList;

type

  TFmAlias = class(TForm)
    Button3: TButton;
    Button4: TButton;
    Button7: TButton;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    FilenameEdit1: TFilenameEdit;
    Edit1: TEdit;
    Button5: TButton;
    Button2: TButton;
    Button1: TButton;
    Button6: TButton;
    ListView1: TListView;
    ImgSmall: TImageList;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Button6Click(Sender: TObject);
    function AliasShow : Boolean;
    procedure Button7Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
    FmAlias: TFmAlias;
    dosya_adi: string [50];
    F: textfile;

implementation

uses UADVUTILS, UAdvTypes, UAdvConst;

{$R *.DFM}
function TFmAlias.AliasShow : Boolean;
begin
  Result := ShowModal = mrOK;
end;

procedure TFmAlias.Button2Click(Sender: TObject);
var
    temp : TListItem;
  begin
    dosya_adi := Edit1.Text;
    temp := ListView1.Items.Add;
    temp.Caption := dosya_adi;
    temp.ImageIndex := 0;
    temp.SubItems.Add(FilenameEdit1.Text);
  end;

  procedure TFmAlias.Button5Click(Sender: TObject);
var
    temp : TListItem;
  begin
    if ListView1.SelCount<>0 then
    begin
    temp := ListView1.Selected;
    dosya_adi:= Edit1.Text;
    temp.Caption := dosya_adi;
    temp.SubItems.Text:=FilenameEdit1.Text;
    end;
  end;

  procedure TFmAlias.Button1Click(Sender: TObject);
var
    index : Integer;
    temp : TListItem;
  begin
    if ListView1.SelCount<>0 then
    begin
    temp := ListView1.Selected;
    index := ListView1.Items.IndexOf(temp);
    ListView1.Items.Delete(index);
    end;
  end;

 procedure TFmAlias.Button4Click(Sender: TObject);
  begin
    ModalResult := MrCancel;
//    Close;
  end;

 function getWinDir:string;
var
    a : Array[0..144] of char;
  begin
    GetWindowsdirectory(a, sizeof(a));
    result:=StrPas(a);
  end;

procedure TFmAlias.FormCreate(Sender: TObject);
var
    List: TStringList;
    I: Integer;
    AliasInfo: TAdvAliasInfo;
    Item: TListItem;
begin
  List := TStringList.Create;
  try
    GetAliasList(List);
    for i := 0 to List.Count - 1 do
    begin
      AliasInfo := GetAliasProperties(List[I]);
      if AliasInfo.TableType = ttDictionary then
      begin
        Item := ListView1.Items.Add;
        Item.Caption := AliasInfo.Name;
        Item.SubItems.Add(AliasInfo.Path);
        Item.ImageIndex := 0;
      end;
    end;
  finally
    List.Free;
  end;
end;

procedure TFmAlias.Button3Click(Sender: TObject);
var
  i : Integer;
begin
  with TIniFile.Create('ads.ini') do
  try
    EraseSection('Databases');
    for i:=0 to ListView1.Items.Count-1 do
    begin
      WriteString('Databases', ListView1.Items[I].Caption,  Replace(ListView1.Items[I].SubItems[0], '"') + ';D');
    end;
  finally
    Free;
  end;
  ModalResult := MrOk;
end;

procedure TFmAlias.ListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var
    temp : TListItem;
begin
    temp := Item;
    if temp.Caption<>' ' then Edit1.Text := temp.Caption;
    FilenameEdit1.Text := temp.SubItems.Strings[0];
end;

procedure TFmAlias.Button6Click(Sender: TObject);
begin
    Edit1.Clear;
    FilenameEdit1.Clear;
end;

procedure TFmAlias.Button7Click(Sender: TObject);
begin
   Application.HelpCommand (HELP_CONTEXT, 12);
end;

end.
