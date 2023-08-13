unit UDbOperation;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  adsdictionary, adscnnct, UAdvUtils;

type
  TFmDBOperation = class(TForm)
    Connection: TAdsConnection;
    procedure FormDestroy(Sender: TObject);
  protected
    procedure FindCaption(ACaption: string); virtual;
  private
    FDict: TAdsDictionary;
  public
    procedure OpenConnection; virtual;
    function Execute(AdsDict: TAdsDictionary): Boolean; virtual;
    property Dictionary: TAdsDictionary read FDict;
  end;

implementation

{$R *.DFM}

function TFmDBOperation.Execute(AdsDict: TAdsDictionary): Boolean;
var ACaption: string;
begin
  FDict := AdsDict;
  OpenConnection;
  if AdsDict.AliasName > '' then
    ACaption := AdsDict.AliasName
  else
    ACaption := AdsDict.ConnectPath;
  FindCaption(ACaption);
  Show;
  BringToFront;
  Result := True;
end;

procedure TFmDBOperation.FormDestroy(Sender: TObject);
begin
  if Connection.IsConnected then Connection.IsConnected := False;
end;

procedure TFmDBOperation.OpenConnection;
begin
  ConvertDictToConn(Fdict, Connection);
  Connection.IsConnected := True;
end;

procedure TFmDBOperation.FindCaption(ACaption: string);
var I, J: Integer;
    AForm: TForm;
begin
  J := 0;
  for I := 0 to Screen.FormCount - 1 do
  begin
    AForm := Screen.Forms[I];
    if AForm is TFmDBOperation then
    begin
      if Copy(AForm.Caption, 1, Length(ACaption)) = ACaption then Inc(J);
    end;
  end;
  if J = 0 then Caption := ACaption
  else Caption := ACaption + ':' + IntToStr(J);
end;

end.
