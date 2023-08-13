unit UDbCon;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, adsdictionary, AdsSet,UAdvUtils, jpeg, Mask, RzEdit,
  RzButton, RzRadChk, RzCommon, 
  RzLabel, RzCmboBx;

type
  TFmConnDb = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    lbRumuz: TLabel;
    Image6: TImage;
    Shape4: TShape;
    ChkRemote: TRzCheckBox;
    Image1: TImage;
    edUser: TRzEdit;
    RzFrameController1: TRzFrameController;
    EdPass: TRzEdit;
    ChkLocal: TRzCheckBox;
    RzLabel1: TRzLabel;
    ChkInternet: TRzCheckBox;
    Image4: TImage;
    Image3: TImage;
    Image7: TImage;
    Image8: TImage;
    Shape5: TShape;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Image5: TImage;
    Shape6: TShape;
    RzLabel2: TRzLabel;
    Shape7: TShape;
    lbUser: TLabel;
    lbPass: TLabel;
    Shape8: TShape;
    RzLabel3: TRzLabel;
    Shape9: TShape;
    ChkCompression: TRzComboBox;
    Label4: TLabel;
    Shape1: TShape;
    RzLabel4: TRzLabel;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure ChkNoLoginClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RzLabel4Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
  private
    function CheckValue (pValue:Boolean):String;
  public
    { Public declarations }
  end;


function ExecuteConnectionForm(var ServerType: TAdsServerTypes;
                               Alias: String; var UserName,Password:String; var Compression: Integer): Boolean;

implementation

uses UMain;

{$R *.DFM}

function ExecuteConnectionForm(var ServerType: TAdsServerTypes;
                               Alias: String; var UserName,Password:String;var Compression: Integer): Boolean;
begin
  ServerType := [];
  with TFmConnDb.Create(nil) do
  try
    lbRumuz.Caption := Alias;
    if ReadRegKey ('ConnectLocal')<>'' then begin
       ChkLocal.Checked := ReadRegKey ('ConnectLocal')='1';
       ChkRemote.Checked := ReadRegKey ('ConnectRemote')='1';
       ChkInternet.Checked := ReadRegKey ('ConnectInternet')='1';
       //ChkNoLogin.Checked := ReadRegKey ('ConnectNoLogin')='1';
       if edUser.Enabled then edUser.Text := ReadRegKey('ConnectUser');
       if edUser.Text = '' then edUser.Text := 'AdsSys';
    end else
      if UserName ='' then
        edUser.Text := 'AdsSys'
      else
        edUser.Text := UserName;
    ChkCompression.ItemIndex := ReadIntRegKey('Compression', 0);
    Result := ShowModal = mrOK;
    if Result then
    begin
      if ChkLocal.Checked then Include(ServerType, stADS_LOCAL);
      if ChkRemote.Checked then Include(ServerType, stADS_REMOTE);
      if ChkInternet.Checked then Include(ServerType, stADS_AIS);
      UserName := edUser.Text;
      Password := edPass.Text;
      Compression := ChkCompression.ItemIndex;
    end;
  finally
    Free;
  end;
end;

procedure TFmConnDb.btnOkClick(Sender: TObject);
var Res: Boolean;
begin
  Res := ChkLocal.Checked or ChkRemote.Checked or ChkInternet.Checked;
  if not Res then raise Exception.Create('Lütfen sunucu tiplerinden en az birini seçiniz');
    ShowInfo('Advantage Yerel Sunucusu, masaüstü uygulamalarýnýz (Desktop Applications) için '+
             'tek kullanýcýlý sistemlerde ücretsiz olarak Advantage Veri Tabaný baðlantýsý '+
             'yapabileceðiniz sunucudur. AdvantageTürk Veri Tabaný Yöneticisi''ni kurduðunuzda '+
             'bu sunucu sisteminize otomatik olarak kurulmuþ olacaktýr.'+ chr(13)+chr(13)+
             'Advantage Veri Tabaný Sunucusu, çok kullanýcýlý ortamlarda yüksek '+
             'performans ve güvenlik saðlayan istemci - sunucu (Client / Server) '+
             'iliþkisel veri tabaný yönetim sistemidir. Advantage Veri Tabaný Sunucusunu '+
             'www.advantageturk.com internet sitemizden indirebilir ve test edebilirsiniz.'+chr(13)+chr(13)+
             'Advantage Internet Sunucusu, Advantage Veri Tabanýna internetten eriþmenizi '+
             'saðlayan sunucudur. Advantage Veri Tabaný Sunucusu kurulduðunda '+
             'Internet Sunucusu da otomatik olarak kurulacaktýr.'
             ,'ShowLoginMessage');
  WriteRegKey('ConnectLocal',CheckValue(ChkLocal.Checked));
  WriteRegKey('ConnectRemote',CheckValue(ChkRemote.Checked));
  WriteRegKey('ConnectInternet',CheckValue(ChkInternet.Checked));
  //WriteRegKey('ConnectNoLogin',CheckValue(ChkNoLogin.Checked));
  WriteIntRegKey('Compression', ChkCompression.ItemIndex);
  WriteRegKey('ConnectUser', edUser.Text);
  ModalResult := mrOK;
end;

procedure TFmConnDb.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFmConnDb.ChkNoLoginClick(Sender: TObject);
begin
  (*edUser.Enabled := not ChkNoLogin.Checked;
  edPass.Enabled := not ChkNoLogin.Checked;
  lbUser.Enabled := not ChkNoLogin.Checked;
  lbPass.Enabled := not ChkNoLogin.Checked;
  if ChkNoLogin.Checked then begin
    edUser.Text := '';
    edPass.Text := '';
  end;*)
end;

procedure TFmConnDb.FormShow(Sender: TObject);
begin
  if edUser.Text <> '' then
   edPass.SetFocus
  else if edUser.Enabled then edUser.SetFocus;
end;

function TFmConnDb.CheckValue(pValue: Boolean): String;
begin
  if pValue then Result:='1' else Result:='0';
end;

procedure TFmConnDb.RzLabel4Click(Sender: TObject);
begin
  GotoUrl('http://www.delphiturk.com/Forums.aspx?Forums=251',700,500,true);
end;

procedure TFmConnDb.Image2Click(Sender: TObject);
begin
  GotoUrl('http://www.advantageturk.com',0,0,true);
end;

end.
