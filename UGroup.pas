unit UGroup;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UObjEdit, ComCtrls, StdCtrls, UAdsObj, UObjRights, UAdsGroup, ExtCtrls,
  DualList;

type
  TFmGroup = class(TFmDBObjectEditor)
    Label1: TLabel;
    edGroupName: TEdit;
    btnRights: TButton;
    edExp: TMemo;
    Label2: TLabel;
    Image1: TImage;
    GroupListD: TDualListDialog;
    Button1: TButton;
    procedure btnRightsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edExpChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    Group: TadsGroup;
  public
    function Edit: Boolean; override;
    function New: Boolean; override;
    procedure Validate; override;
    procedure OnDone; override;
    procedure DirtyChanged; override;
    procedure ModeChanged; override;
    procedure Init;
  end;

implementation

{$R *.DFM}

procedure TFmGroup.DirtyChanged;
begin
  if not Dirty then
    EdExp.Modified := False;

end;

function TFmGroup.Edit: Boolean;
begin
  Init;
  Group := TAdsGroup.Create(Dictionary, Item);
  edGroupName.Text := Item;
  edExp.Lines.Text := Group.Description;
  Dirty:=false;
  Result := ShowModal = mrOk;
end;

procedure TFmGroup.Init;
begin

end;

procedure TFmGroup.ModeChanged;
begin
  case Mode of
  emEdit:
   begin
     Caption := Item + ' özellikleri';
     edGroupName.ReadOnly := True;
   end;
  emNew:
   begin
     Caption := 'Yeni Grup Ekle';
     edGroupName.ReadOnly := False;
   end;
  end;

end;

function TFmGroup.New: Boolean;
begin
  Init;
  Dirty := True;
  Result := ShowModal = mrOK;
end;

procedure TFmGroup.OnDone;
begin
  if mode=emNew then begin
    Dictionary.CreateUserGroup(edGroupName.Text,edExp.Text);
    Group := TAdsGroup.Create(Dictionary, edGroupName.Text);
    Item := edGroupName.Text;
    Mode := emEdit;
  end else
    Group.Description:=edExp.Text;
  dirty:=false;
end;

procedure TFmGroup.Validate;
begin
  if mode=emNew then begin
    if  edGroupName.Text='' then begin
       edGroupName.SetFocus;
       raise Exception.Create('Geçerli bir Grup adý giriniz.');
    end;
  end;
end;

procedure TFmGroup.btnRightsClick(Sender: TObject);
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
    AdsObject := Self.Group;
    Edit;
  end;

end;

procedure TFmGroup.FormDestroy(Sender: TObject);
begin
  if Assigned(Group) then
    Group.Free;
  inherited;

end;

procedure TFmGroup.edExpChange(Sender: TObject);
begin
  inherited;
  Dirty:=true;
end;

procedure TFmGroup.Button1Click(Sender: TObject);
var
  DbUsers,GrUsers,TempList:TStringList;
  i:integer;
begin
  inherited;
  DbUsers:=TStringList.Create;
  GrUsers:=TStringList.Create;
  try
    Dictionary.GetUserNames(DbUsers);
    Dictionary.GetUsersFromGroup(Item,GrUsers);
    GroupListD.List1:=GrUsers;
    GroupListD.Title:=Item+ ' Kullanýcýlarý';
    for i:=0 to GrUsers.Count-1 do
      if  DbUsers.IndexOf(GrUsers[i])>=0 then
        DbUsers.Delete(DbUsers.IndexOf(GrUsers[i]));
    GroupListD.List2:=DbUsers;
    if GroupListD.Execute  then begin
      for i:=0 to GroupListD.List1.Count-1 do
        if GrUsers.IndexOf(GroupListD.List1[i])<0 then
          Dictionary.AddUserToGroup(Item,GroupListD.List1[i]);
      for i:=0 to GrUsers.Count-1 do
        if GroupListD.List1.IndexOf(GrUsers[i])<0 then
          Dictionary.RemoveUserFromGroup(Item,GrUsers[i]);
    end;
  finally
    DbUsers.Free;
    GrUsers.Free;
  end;
end;

procedure TFmGroup.FormShow(Sender: TObject);
begin
  inherited;
  edGroupName.SetFocus;
end;

end.
