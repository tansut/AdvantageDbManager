unit UUser;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UObjEdit, ComCtrls, StdCtrls, adsdictionary, ExtCtrls, Ace, UAdsObj,UPasswordDlg,
  ImgList, UObjRights, UAdsUser, adscnnct, Db, adsdata, adsfunc, adstable;

type
  TFmUser = class(TFmDBObjectEditor)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ChkInternet: TCheckBox;
    EdExp: TMemo;
    EdPassword: TEdit;
    Image1: TImage;
    Label4: TLabel;
    btnRights: TButton;
    edUser: TEdit;
    LVGroup: TListView;
    ImgSmall: TImageList;
    procedure btnRightsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edUserChange(Sender: TObject);
    procedure ChkInternetClick(Sender: TObject);
    procedure LVGroupSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure LVGroupClick(Sender: TObject);
  private
    AdsUser: TAdsUser;
  public
    function Edit: Boolean; override;
    function New: Boolean; override;
    procedure Validate; override;
    procedure OnDone; override;
    procedure DirtyChanged; override;
    procedure ModeChanged; override;
    procedure Init;
    function GetPassWord(FrmCaption:string; var tPassw :string):integer;
  end;

var
  FmUser: TFmUser;

implementation

{$R *.DFM}

{ TFmUser }

function TFmUser.Edit: Boolean;
var I: Integer;
begin
  Init;
  AdsUser := TAdsUser.Create(Dictionary, Item);
  EdExp.Lines.Text := AdsUser.Description;
  ChkInternet.Checked := AdsUser.InternetEnabled;
  EdUser.Text := Item;
  for I := 0 to LVGroup.Items.Count - 1 do
  begin
    LVGroup.Items[I].Checked := AdsUser.Group.IndexOf(LVGroup.Items[I].Caption) >=0;
  end;
  Dirty := False;
  Result := ShowModal = mrOK;
end;

procedure TFmUser.Init;
var List: TStringList;
    I: Integer;
    ListItem: TListItem;
begin
  AdsUser := nil;
  List := TStringList.Create;
  try
    Dictionary.GetGroupNames(List);
    for I := 0 to List.Count - 1 do
    begin
      ListItem := LVGroup.Items.Add;
      with ListItem do
      begin
        Caption := List[I];
        Checked := False;
        ImageIndex := 0;
      end;
    end;
  finally
    List.Free;
  end;
end;

function TFmUser.New: Boolean;
begin
  Init;
  Dirty := True;
  Result := ShowModal = mrOK;
end;

procedure TFmUser.OnDone;
var List: TStringList;
    I: Integer;
    NewPass: string;
begin
  if EdPassword.Modified then
  begin
    if EdPassword.Text = '' then
    begin
      if Mode = emEdit then AdsUser.SetPassword('')
    end
    else begin
      if GetPassWord('Kullanýcý Þifresi Tekrar', NewPass)=mrOk then
      begin
        if NewPass = EdPassword.Text then
        begin
          if Mode = emEdit then AdsUser.SetPassword(NewPass);
        end
        else raise Exception.Create('Þifreler birbirinden farklý');
      end else Abort;
    end;
  end;
  if Mode = emNew then
  begin
    Dictionary.AddUser('', edUser.Text, EdPassword.Text, EdExp.Lines.Text);
    AdsUser := TAdsUser.Create(Dictionary, edUser.Text);
    Item := edUser.Text;
    Mode := emEdit;
  end else
  begin
    if EdExp.Modified then AdsUser.Description := edExp.Lines.Text;
  end;  
  List := TStringList.Create;
  for I := 0 to LVGroup.Items.Count - 1 do
   if LVGroup.Items[I].Checked then List.Add(LVGroup.Items[I].Caption);
  try
    AdsUser.Group := List;
  finally
    List.Free;
  end;
  if ChkInternet.Checked <> AdsUser.InternetEnabled then AdsUser.InternetEnabled := ChkInternet.Checked;
  Dirty := False;
end;

procedure TFmUser.Validate;
begin
  if Trim(edUser.Text) = '' then
  begin
    edUser.SetFocus;
    raise Exception.Create('Geçerli bir kullanýcý adý giriniz');
  end;
  if UpperCase(edUser.Text) = 'ADSSYS' then
  begin
    edUser.SetFocus;
    raise Exception.Create('ADSSYS kullanýcýsý yaratamazsýnýz. Geçerli bir kullanýcý adý giriniz');
  end;
end;

procedure TFmUser.btnRightsClick(Sender: TObject);
begin
  inherited;
  if Mode = emNew then
  begin
    Validate;
    OnDone;
  end;
  with TFmObjectRights.Create(nil) do
  begin
    Dictionary := Self.Dictionary;
    Item := Self.Item;
    AdsObject := Self.AdsUser;
    Edit;
  end;
end;

procedure TFmUser.FormDestroy(Sender: TObject);
begin
  if Assigned(AdsUser) then
    AdsUser.Free;
  inherited;

end;

procedure TFmUser.edUserChange(Sender: TObject);
begin
  inherited;
  Dirty := True;
end;

procedure TFmUser.ChkInternetClick(Sender: TObject);
begin
  inherited;
  Dirty := True;
end;

procedure TFmUser.DirtyChanged;
begin
  if not Dirty then
  begin
    EdExp.Modified := False;
    EdPassword.Modified := False;    
  end;
end;

procedure TFmUser.ModeChanged;
begin
  case Mode of
  emEdit:
   begin
     Caption := Item + ' özellikleri';
     edUser.ReadOnly := True;
     btnRights.Enabled := UpperCase(Item) <> 'ADSSYS';
   end;
  emNew:
   begin
     Caption := 'Yeni Kullanýcý Ekle';
     edUser.ReadOnly := False;
     edUser.Text := '';
     EdExp.Text := '';
     EdExp.Modified := True;
     EdPassword.Text := '';
     ChkInternet.Checked := False;
     ActiveControl := edUser;
   end;
  end;
end;

procedure TFmUser.LVGroupSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  inherited;
  Dirty := True;
end;

procedure TFmUser.LVGroupClick(Sender: TObject);
begin
  inherited;
  Dirty := True;
end;

function TFmUser.GetPassWord(FrmCaption: string;
  var tPassw: string): integer;
var
  fmPassw:TFmPasswordDlg;
begin
  fmPassw:=TFmPasswordDlg.Create(nil);
  try
    fmPassw.Caption:=FrmCaption;
    result:=fmPassw.ShowModal;
    tPassw:=fmPassw.Password.Text;
  finally
    fmPassw.Free;
  end;
end;

end.
