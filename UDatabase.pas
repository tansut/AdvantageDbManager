unit UDatabase;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UObjEdit, Mask, StdCtrls, ToolEdit, ExtCtrls, ComCtrls,
  Ace,Adsdictionary,AdsData,AdsCnnct,UAdvUtils,inifiles,AdsSet,UPasswordDlg,
  UDbItems;

type
  TFmDataBase = class(TFmDBObjectEditor)
    edName: TEdit;
    Label1: TLabel;
    EdAliasName: TEdit;
    Label2: TLabel;
    Dizinler: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    GroupBox1: TGroupBox;
    ConnRequired: TCheckBox;
    ChUserRight: TCheckBox;
    GroupBox3: TGroupBox;
    TableSecurity: TCheckBox;
    BtTableSec: TButton;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    InternetAccess: TCheckBox;
    SecLevel: TComboBox;
    Label6: TLabel;
    Label7: TLabel;
    Image1: TImage;
    EdExp: TMemo;
    EdMaxLogin: TEdit;
    EdDbPath: TDirectoryEdit;
    EdDefPath: TDirectoryEdit;
    EdTempPath: TDirectoryEdit;
    GroupBox2: TGroupBox;
    EdMajorVer: TEdit;
    Label8: TLabel;
    EdMinorVer: TEdit;
    Label9: TLabel;
    GroupBox6: TGroupBox;
    DictSecurity: TCheckBox;
    procedure FormDestroy(Sender: TObject);
    procedure EditChange(Sender: TObject);
    procedure TableSecurityClick(Sender: TObject);
    procedure BtTableSecClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EdDbPathChange(Sender: TObject);
  private
     DictPath:string;
     conn:TAdsConnection;
     AdsDb:TAdsDatabase;
     DictEncryt:Boolean;
  public
    function Edit: Boolean; override;
    function New: Boolean; override;
    procedure Validate; override;
    procedure OnDone; override;
    procedure DirtyChanged; override;
    procedure ModeChanged; override;
    procedure GetDictProperties;
    procedure SetDictProperties;
    function GetPassWord(FrmCaption:string; var tPassw :string):integer;
  end;

var
  FmDataBase: TFmDataBase;

implementation

{$R *.DFM}


{ TFmDataBase }

procedure TFmDataBase.DirtyChanged;
begin
  if not Dirty then begin
    EdExp.Modified:=false;
    EdDefPath.Modified:=false;
    EdMaxLogin.Modified:=false;
    EdTempPath.Modified:=false;
    EdMajorVer.Modified:=false;
    EdMinorVer.Modified:=false;
  end;
end;

function TFmDataBase.Edit: Boolean;
begin
   conn:=TAdsConnection.Create(nil);
   ConvertDictToConn(Dictionary,conn);
   edName.Text:=GetNameFromFileName(conn.GetConnectionWithDDPath);
   EdAliasName.Text:=Dictionary.AliasName;
   EdDbPath.Text:=conn.GetConnectionPath;//copy(conn.GetConnectionPath,1,pos(edName.Text,conn.GetConnectionPath)-1);
   AdsDb:=TAdsDatabase.Create(Dictionary,edName.Text);
   AdsDb.AliasName:=EdAliasName.Text;
   AdsDb.DbPath:=EdDbPath.Text;
   GetDictProperties;
   if AdsDb.TablePassw ='' then BtTableSec.Caption := 'Þifre Belirle';
   Dirty := False;

   Result := ShowModal = mrOK;
end;

procedure TFmDataBase.FormDestroy(Sender: TObject);
begin
  if Assigned(Conn) then  conn.Free;
  if Assigned(AdsDb) then  AdsDb.Free;
  inherited;
end;

procedure TFmDataBase.GetDictProperties;
begin
   AdsDb.RefreshProperties;
   InternetAccess.Checked:=AdsDb.InternetEnable;
   EdMaxLogin.Text:=inttoStr(AdsDb.MaxLogAtt);
   SecLevel.ItemIndex:=AdsDb.SecLevel;
   ChUserRight.Checked:=AdsDb.ChUserRight;
   TableSecurity.Checked:=AdsDb.TableEncrypt;
   EdExp.Lines.Text:=AdsDb.Description;
   EdDefPath.Text:=AdsDb.DefPath;
   EdTempPath.Text:=AdsDb.TempPath;
   ConnRequired.Checked:=AdsDb.LoginReq;
   EdMajorVer.Text:=IntToStr(AdsDb.MajorVer);
   EdMinorVer.Text:=IntToStr(AdsDb.MinorVer);
end;

procedure TFmDataBase.ModeChanged;
begin
 case Mode of
  emEdit:
    begin
      Caption := Item + ' özellikleri';
      DictSecurity.Visible:=false;
      edName.Enabled:=false;
      EdAliasName.Enabled:=false;
      EdDbPath.Enabled:=False;
      if UpperCase(Dictionary.UserName) <> 'ADSSYS' then begin
        EdDefPath.Enabled:=false;
        EdTempPath.Enabled:=false;
        ConnRequired.Enabled:=false;
        ChUserRight.Enabled:=false;
        TableSecurity.Enabled:=false;
        TableSecurity.Enabled:=false;
        EdExp.Enabled:=false;
        InternetAccess.Enabled:=false;
        SecLevel.Enabled:=false;
        EdMaxLogin.Enabled:=false;
      end else begin
        TableSecurity.Enabled:=true;
        BtTableSec.Enabled:=true;
      end;
   end;
  emNew:
   begin
     Caption := 'Yeni Veri Tabaný';
     DictSecurity.Visible:=true;
     edName.Enabled:=true;
     EdAliasName.Enabled:=true;
     EdDbPath.Enabled:=true;
     TableSecurity.Enabled:=false;
     BtTableSec.Enabled:=false;
   end;
  end;
end;

function TFmDataBase.New: Boolean;
begin
  Dirty := True;
  SecLevel.ItemIndex:=0;
  BtTableSec.Caption := 'Þifre Belirle';
  Result := ShowModal = mrOK;
end;

procedure TFmDataBase.OnDone;
var
  AliasFile:TIniFile;
  AdminPassw,temp:string;
  F:TextFile;
begin
  if mode=emEdit then begin
    SetDictProperties;
  end else begin
    if EdAliasName.Text<>'' then
      if not FileExists(GetWinDir+'\ads.ini') then begin
         AssignFile(F,GetWinDir+'\ads.ini');
         {$I-}
         Reset(F);
         {$I+}
      end;
      AliasFile := TIniFile.Create( GetWinDir+'\ads.ini');
    try
      if (EdAliasName.Text<>'') and ( AliasFile.ReadString( 'Databases',EdAliasName.Text, 'exists' ) <> 'exists' ) then
         raise Exception.Create('Ayný rumuzla bir veri tabaný mevcut. Rumuzu deðiþtirin');

      While (true) do  try
      if GetPassWord(EdName.Text+' Yönetici Þifresi',temp)=mrOk then
         if GetPassWord(EdName.Text+' Yönetici Þifresi Tekrar',AdminPassw)=mrOk then
            if temp<>AdminPassw then begin
              AdminPassw:='';
              raise Exception.Create('Yönetici þifresi için farklý giriþler yapýldýðý için iþlem iptal edildi.');

            end else break
         else begin raise Exception.Create('Ýþlemden vageçildi.'); exit; end
      else raise Exception.Create('Ýþlemden vazgeçildi.');
      except
        raise;
      end;
      DictEncryt:=DictSecurity.Checked;
      if  Copy(EdDbPath.Text,Length(EdDbPath.Text),1)<>'\' then
        EdDbPath.Text:=EdDbPath.Text+'\';

      DictPath:=EdDbPath.Text+edName.Text+'.add';
      Dictionary:=TAdsDictionary.Create(nil);
      Dictionary.AdsServerTypes:=[stADS_AIS, stADS_REMOTE, stADS_LOCAL];

      Dictionary.CreateDictionary(DictPath,DictEncryt,EdExp.Lines.Text);
      AdsDb:=TAdsDataBase.Create(Dictionary,edName.Text);
      AdsDb.AliasName:=EdAliasName.Text;
      AdsDb.DbPath:=EdDbPath.Text;
      SetDictProperties;
      if  AdminPassw<>'' then
        AdsDb.AdminPassw:=AdminPassw;
      if (EdAliasName.Text<>'') then
        AliasFile.WriteString( 'Databases',
                                EdAliasName.Text,
                                DictPath + ';D' );


    finally
      if (EdAliasName.Text<>'') then AliasFile.Free;
    end;
  end;
end;

procedure TFmDataBase.Validate;
begin
  if (mode=emEdit) and (AdsDb.TablePassw='') and (TableSecurity.Checked)  then begin
    TableSecurity.SetFocus;
    raise Exception.Create('Þifre belirlenmeden tablo güveliði aktif yapýlamaz.');
  end;
  if edName.Text='' then
    raise Exception.Create('Veri tabaný adý girilmelidir.');

 // if EdAliasName.Text='' then
   // raise Exception.Create('Rumuz girilmelidir.');

  if EdDbPath.Text='' then
    raise Exception.Create('Veri Tabaný dizini girilmelidir.');

  if EdDefPath.Text='' then
    raise Exception.Create('Varsayýlan veri tabaný dizini girilmelidir.');
    
  if EdTempPath.Text='' then
    raise Exception.Create('Geçici veri tabaný dizini girilmelidir.');

end;

procedure TFmDataBase.SetDictProperties;
begin
   if  Copy(EdDefPath.Text,Length(EdDefPath.Text),1)<>'\' then
      EdDefPath.Text:=EdDefPath.Text+'\';
   if  Copy(EdTempPath.Text,Length(EdTempPath.Text),1)<>'\' then
      EdTempPath.Text:=EdTempPath.Text+'\';

   if (EdExp.Modified) or (mode=emNew) then
      AdsDb.Description:=EdExp.Lines.Text;

   if (EdDefPath.Modified)  or (mode=emNew) then
     AdsDb.DefPath:= EdDefPath.Text;

   if ChUserRight.Checked <> AdsDb.ChUserRight then
      AdsDb.ChUserRight:=ChUserRight.Checked;

   if ConnRequired.Checked <> AdsDb.LoginReq then
      AdsDb.LoginReq:=ConnRequired.Checked;

   if TableSecurity.Checked <> AdsDb.TableEncrypt then
     AdsDb.TableEncrypt:=TableSecurity.Checked;

   if InternetAccess.Checked <> AdsDb.InternetEnable then
     AdsDb.InternetEnable:= InternetAccess.Checked;

   AdsDb.SecLevel:=SecLevel.ItemIndex;
   if ((EdMaxLogin.Modified) or (mode=emNew)) and (EdMaxLogin.Text<>'') then
     AdsDb.MaxLogAtt:=StrToInt(EdMaxLogin.Text);

   if (EdTempPath.Modified) or (mode=emNew) then
     AdsDb.TempPath:=EdTempPath.Text;

   if ((EdMajorVer.Modified) or (mode=emNew)) and (EdMajorVer.Text<>'') then
     AdsDb.MajorVer:=StrToInt(EdMajorVer.Text);

   if ((EdMinorVer.Modified) or (mode=emNew))  and (EdMinorVer.Text<>'')then
     AdsDb.MinorVer:=StrToInt(EdMinorVer.Text);

   AdsDb.SetProperties;
end;


procedure TFmDataBase.EditChange(Sender: TObject);
begin
  inherited;
  Dirty:=true;
end;

procedure TFmDataBase.TableSecurityClick(Sender: TObject);
begin
  inherited;
  Dirty:=true;
end;

procedure TFmDataBase.BtTableSecClick(Sender: TObject);
var
  tempPassw:string;
begin
  inherited;
  if AdsDb.TablePassw <>'' then begin
    if GetPassWord('Eski Tablo Güvenlik Þifresi',tempPassw)=mrOk then begin
      if (AdsDb.TablePassw<>tempPassw) then begin
          raise Exception.Create('Yanlýþ þifre girdiniz.Tekrar deneyiniz.');
          exit;
      end;
    end;
  end;

  tempPassw:='';
  if GetPassWord('Yeni Tablo Güvenlik Þifresi',tempPassw)=mrOk then begin
     while length(temppassw) <6 do begin
       messageDlg('Tablo Güvenlik þifresi 6 karakterden küçük olamaz.',mtConfirmation,[mbOk],0);
       if GetPassWord('Yeni Tablo Güvenlik Þifresi',tempPassw)=mrCancel then exit;
     end;
     AdsDb.TablePassw:= tempPassw;
     BtTableSec.Caption := 'Þifre Deðiþtir';
     Dirty:=true;
  end;

end;

function TFmDataBase.GetPassWord(FrmCaption: string; var tPassw :string):integer;
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

procedure TFmDataBase.FormShow(Sender: TObject);
begin
  inherited;
  if edName.Enabled then edName.SetFocus; 
end;

procedure TFmDataBase.EdDbPathChange(Sender: TObject);
begin
  inherited;
  if EdDefPath.Text = '' then EdDefPath.Text := EdDbPath.Text;
  if EdTempPath.Text = '' then EdTempPath.Text := EdDbPath.Text;
end;

end.
