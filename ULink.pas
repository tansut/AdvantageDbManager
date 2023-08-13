unit ULink;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UObjEdit, ComCtrls, StdCtrls, adsdictionary, ExtCtrls, Ace, UAdsObj,
  ImgList, UAdsLink,Adscnnct, Mask, ToolEdit, UadvUtils;

type
  TFmLink = class(TFmDBObjectEditor)
    edName: TEdit;
    Label1: TLabel;
    Image1: TImage;
    edLinkPath: TFilenameEdit;
    Label3: TLabel;
    Label5: TLabel;
    GrOpt: TPanel;
    chStaticPath: TCheckBox;
    chActiveUser: TCheckBox;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    Label6: TLabel;
    EdUser: TEdit;
    edPassword: TEdit;
    procedure chActiveUserClick(Sender: TObject);
    procedure edNameChange(Sender: TObject);
    procedure edLinkPathChange(Sender: TObject);
    procedure chStaticPathClick(Sender: TObject);
    procedure EdUserChange(Sender: TObject);
    procedure edPasswordChange(Sender: TObject);
  private
  public
    function Edit: Boolean; override;
    procedure Init;
    function New: Boolean; override;
    procedure Validate; override;
    procedure ModeChanged; override;
    procedure OnDone; override;
  end;

var
  FmLink: TFmLink;
  AdsLink : TAdsLink;
implementation

{$R *.DFM}

function TFmLink.Edit: Boolean;
  var LinkOptions : TAdsLinkOptions;
begin
  Init;
  AdsLink := TAdsLink.Create(Dictionary, Item);
  try
    edName.Text := Item;
    edLinkPath.Text := AdsLink.GetLinkPath ;
    LinkOptions := AdsLink.GetLinkOptions;

    if loAuthenticateActiveUser in LinkOptions then
       chActiveUser.Checked := True
    else
    begin
       chActiveUser.Checked := False;
       edUser.Text := AdsLink.GetUserName;
    end;

    if loPathIsStatic in LinkOptions then
       chStaticPath.Checked := True
    else
       chStaticPath.Checked := False;

  finally
    AdsLink.Free;
  end;
  Dirty := False;

  edName.ReadOnly := True;
  edLinkPath.ReadOnly := True;
  GrOpt.Enabled := False;

  Result := ShowModal = mrOK;
end;

procedure TFmLink.Init;
begin

end;

function TFmLink.New: Boolean;
begin
  Init;
  Dirty := True;
  Result := ShowModal = mrOK;
end;


procedure TFmLink.Validate;
begin
  if edName.Text = '' then
  begin
    edName.SetFocus;
    raise Exception.Create('VT Link adý girilmelidir.');
  end;

  if edLinkPath.Text = '' then
  begin
    edLinkPath.SetFocus;
    raise Exception.Create('Link yapýlacak veri sözlüðü belirtilmelidir.');
  end;

  if (not chActiveUser.Checked) and (( edUser.Text = '')) then
  begin
    edUser.SetFocus;
    raise Exception.Create('Aktif kullanýcý ile baðlan seçeneðini seçmeli veya '+
                           'baðlantý kuracaðýnýz kullanýcý adýný girmelisiniz.');
  end;

end;

procedure TFmLink.ModeChanged;
begin
  case Mode of
    emEdit:
    begin
       Caption := Item + ' özellikleri';
       edName.ReadOnly := True;
       edLinkPath.ReadOnly := True;
       GrOpt.Enabled := False;
    end;
    emNew:
       Caption := 'Yeni VT Link Ekle';
   end;
end;

procedure TFmLink.OnDone;
  var mOptions :TAdsLinkOptions;
begin

  mOptions :=  mOptions + [loGlobal];
  if chActiveUser.Checked then
     mOptions := mOptions + [loAuthenticateActiveUser];

  if chStaticPath.Checked  then
     mOptions := mOptions + [loPathIsStatic];


     Dictionary.CreateDDLink (edName.Text,replace(edLinkPath.Text,'"'), edUser.Text,edPassword.Text,
                              mOptions);
     Item := edName.Text;
end;

procedure TFmLink.chActiveUserClick(Sender: TObject);
begin
  inherited;
  if chActiveUser.Checked then
  begin
     edUser.Enabled := False;
     edPassword.Enabled := False;
     EdUser.Color := clBtnFace;
     edPassword.Color := clBtnFace;
  end else begin
     edUser.Enabled := True;
     edPassword.Enabled := True;
     EdUser.Color := clWindow;
     edPassword.Color := clWindow;
  end;
  Dirty:= True;
end;

procedure TFmLink.edNameChange(Sender: TObject);
begin
  inherited;
  Dirty:= True;
end;

procedure TFmLink.edLinkPathChange(Sender: TObject);
begin
  inherited;
  Dirty:= True;
end;

procedure TFmLink.chStaticPathClick(Sender: TObject);
begin
  inherited;
  Dirty:= True;
end;

procedure TFmLink.EdUserChange(Sender: TObject);
begin
  inherited;
  Dirty:= True;
end;

procedure TFmLink.edPasswordChange(Sender: TObject);
begin
  inherited;
  Dirty:= True;
end;

end.
