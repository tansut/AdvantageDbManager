unit UCheckVersion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzLabel, ExtCtrls, VersionControl, UAdvUtils, RzButton;

type
  TfmCheckVersion = class(TForm)
    Image1: TImage;
    lbCaption: TRzLabel;
    VersionCheck: TVersionControl;
    Panel1: TPanel;
    mmDesc: TMemo;
    Panel2: TPanel;
    btnGotoUrl: TRzButton;
    btnClose: TRzButton;
    procedure btnGotoUrlClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    function formatVersion(pVer: integer):string;
  public
    procedure Execute;
  end;

var
  fmCheckVersion: TfmCheckVersion;

implementation

{$R *.dfm}

{ TfmCheckVersion }

procedure TfmCheckVersion.Execute;
begin
  lbCaption.Blinking := True;
  show;
  Self.Refresh;
  VersionCheck.CheckVersion;
  lbCaption.Blinking := False;
  btnClose.Enabled := True;
  if VersionCheck.NewVersionAvailable then
  begin
    lbCaption.Caption := 'Yeni S�r�m Bulundu';
    mmDesc.Lines.Clear;
    mmDesc.Lines.Add('AdvantageT�rk Veri Taban� Y�neticisi i�in');
    mmDesc.Lines.Add('yeni bir s�r�m bulundu.');
    mmDesc.Lines.Add('S�r�m Numaras�: '+ FormatVersion(VersionCheck.GetLastVersion));
    mmDesc.Lines.Add('A��klama: '+ VersionCheck.GetLastDescription);
    btnGotoUrl.Visible := True;
    btnGotoUrl.SetFocus;
  end
  else begin
    lbCaption.Caption := 'Yeni S�r�m Kontrol� Tamamland�';
    mmDesc.Lines.Clear;
    mmDesc.Lines.Add('Kulland���n�z AdvantageT�rk Veri Taban� Y�neticisi en son s�r�md�r.');
//    mmDesc.Lines.Add('Uzak sistem a��klamas�:');
//    mmDesc.Lines.Add(VersionCheck.GetLastDescription);
  end;
  close;
  ShowModal;
end;

procedure TfmCheckVersion.btnGotoUrlClick(Sender: TObject);
begin
  GotoUrl(VersionCheck.GetLastDirectionUrl, 0, 0, true);
end;

procedure TfmCheckVersion.btnCloseClick(Sender: TObject);
begin
  Close;
end;

function TfmCheckVersion.formatVersion(pVer: integer): string;
  var i,len:integer;
      Version:string;
begin
  Version := IntToStr(pVer);
  len := Length(Version);
  for i:=1 to len do begin
    Result := Result + copy(Version,i,1) + '.';
  end;
  Result := Copy(Result,1,Length(Result)-1);
end;

end.
