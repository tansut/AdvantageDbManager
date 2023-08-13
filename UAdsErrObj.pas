unit UAdsErrObj;

interface

uses
 UAdvTypes, UAdvUtils, UAdvConst, adscnnct, AdsTable, AdsSet, sysUtils;

type

  TAdsErrorManager = class
  private
   FConnection: TAdsConnection;
   procedure CreateConnection;
  public
   constructor Create;
   function GetErrorInfo(ErrorCode: Integer): TAdsErrorDesc;
   destructor Destroy; override;
  end;

implementation

{ TAdsErrorManager }

constructor TAdsErrorManager.Create;
begin
  FConnection := nil;
end;

procedure TAdsErrorManager.CreateConnection;
begin
  if FConnection = nil then
  begin
    FConnection := TAdsConnection.Create(nil);
    FConnection.Name := 'ERRORCONN';
    with FConnection do
    begin
      AdsServerTypes := [stADS_LOCAL];
      ConnectPath := GetAppPath + 'ErrCodes';
      LoginPrompt := False;
    end;
  end;
  FConnection.IsConnected := True;
end;

destructor TAdsErrorManager.Destroy;
begin
  if Assigned(FConnection) then
  begin
    FConnection.IsConnected := False;
    FConnection.Free;
  end;
  inherited Destroy;
end;

function TAdsErrorManager.GetErrorInfo(ErrorCode: Integer): TAdsErrorDesc;
var Query: TAdsQuery;
begin
  //CreateConnection;
  Query := TAdsQuery.Create(nil);
  with Query do
  try
    DatabaseName := GetAppPath + 'ErrCodes';
    Sql.Text := 'select ErrorCode, Description, Problem, Solution from ERRCODE where ErrorCode = ' + IntToStr(ErrorCode);
    Open;
    with Result do
    begin
      if Eof then
      begin
        ErrCode := -1;
      end else
      begin
        ErrCode := FieldByName('ErrorCode').AsInteger;
        Desc := FieldByName('Description').AsString;
        Problem := FieldByName('Problem').AsString;
        Solution := FieldByName('Solution').AsString;
      end;
    end;
    Close;
  finally
    Free;
  end;
end;

end.
