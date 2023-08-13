unit UBlob;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBCtrls, StdCtrls;

type
  TfmBlob = class(TForm)
    poMemo: TDBMemo;
    poImage: TDBImage;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    strFieldName : string;
  end;

var
  fmBlob: TfmBlob;

implementation

{$R *.DFM}

procedure TfmBlob.FormCreate(Sender: TObject);
begin
   poMemo.DataField:=strFieldName;
   poImage.DataField:=strFieldName;
   self.PixelsPerInch := Screen.PixelsPerInch;
   self.BorderStyle := bsSizeToolWin;
   self.ClientHeight := 264;
   self.ClientWidth := 274;
   self.Height := 264;
   self.Width := 274;
end;

end.
