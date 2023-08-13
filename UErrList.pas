unit UErrList;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, StdCtrls, ComCtrls;

type
  TFmAdsErrorList = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    edDesc: TMemo;
    TabSheet2: TTabSheet;
    edProblem: TMemo;
    TabSheet3: TTabSheet;
    edSolution: TMemo;
    ImageList1: TImageList;
  private
    { Private declarations }
  public
    procedure Execute(ErrCode: Integer);
  end;


implementation

{$R *.DFM}

{ TFmAdsErrorList }

procedure TFmAdsErrorList.Execute(ErrCode: Integer);
begin

end;

end.
