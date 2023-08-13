unit UAdsErr;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  AdsData, ExtCtrls, StdCtrls, UAdsErrObj, UAdvTypes, ComCtrls, ImgList;

type
  TFmAdsError = class(TForm)
    Image1: TImage;
    LblErr: TLabel;
    EdMessage: TMemo;
    Bevel1: TBevel;
    btnOK: TButton;
    btnDetails: TButton;
    PageControl1: TPageControl;
    TabErrDesc: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    edDesc: TMemo;
    edSolution: TMemo;
    edProblem: TMemo;
    ImageList1: TImageList;
    BtnLookup: TButton;
    LblLookuperr: TLabel;
    procedure btnDetailsClick(Sender: TObject);
    procedure BtnLookupClick(Sender: TObject);
  private
    FAdsError: EAdsDatabaseError;
    FErrorInfo: TAdsErrorDesc;
    procedure LookupError(Code: Integer);
  public
    procedure Execute(E: EAdsDatabaseError);
  end;


implementation

{$R *.DFM}

procedure TFmAdsError.Execute(E: EAdsDatabaseError);

begin
  FAdsError := E;
  with E do
  begin
    LblErr.Caption := 'ADS-' + IntToStr(ACEErrorCode);
    EdMessage.Lines.Text := Message;
  end;
  Tag := 1;
  btnDetailsClick(Self);
  LookupError(E.ACEErrorCode);
  ShowModal;
end;

procedure TFmAdsError.btnDetailsClick(Sender: TObject);
begin
  case Tag of
  0: begin
       Height := 420;
       btnDetails.Caption := '<< Detaylar';
       Tag := 1;
       BtnLookup.Visible := True;
     end;
  1: begin
       Height := 172;
       btnDetails.Caption := 'Detaylar >>';
       Tag := 0;
       BtnLookup.Visible := False;
     end;
  end;   
end;

procedure TFmAdsError.LookupError(Code: Integer);
var AdsErr: TAdsErrorManager;
begin
  AdsErr := TAdsErrorManager.Create;
  try
    FErrorInfo := AdsErr.GetErrorInfo(Code);
  except
    AdsErr.Free;
    Exit;
  end;
  AdsErr.Free;
  if FErrorInfo.ErrCode = -1 then Exit;
  PageControl1.ActivePage := TabErrDesc;
  with FErrorInfo do
  begin
    LblLookuperr.Caption := 'ADS-' + InttoStr(Code);
    edProblem.Lines.Text := Problem;
    edDesc.Lines.Text := Desc;
    edSolution.Lines.Text := Solution;
  end;
end;

procedure TFmAdsError.BtnLookupClick(Sender: TObject);
var S: string;
begin
  S := '';
  if InputQuery('Advantage Hata Kodlarý', 'Hata Kodu Giriniz:', S) then
  begin
    try
      LookupError(StrToInt(S));
    except
    end;
  end;
end;

end.
