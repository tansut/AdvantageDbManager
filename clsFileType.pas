unit clsFileType;

interface
uses
  Registry, Windows, ShlObj, SysUtils, Dialogs;

type TFileType = class
  private
    FFileExtension: string;
    FFileDescription: string;
    FOpenWith: string;
    FUseDDE: Boolean;
    FDdeMessage: string;
    FDDEApplicationNotRunning: string;
    FDDEApplication: string;
    FDDETopic: string;
    FOpenActionDescription: string;
    FOpenAction: string;
    procedure SetFileExtension(const Value: string);

    function AllValuesSet: Boolean;
  public
    function Register: Boolean;
    function UnRegister: Boolean;

    property FileExtension: string read FFileExtension write SetFileExtension;
    property FileDescription: string read FFileDescription write FFileDescription;
    property OpenAction: string read FOpenAction write FOpenAction;
    property OpenActionDescription: string read FOpenActionDescription write FOpenActionDescription;
    property OpenWith: string read FOpenWith write FOpenWith;
    property UseDDE: Boolean read FUseDDE write FUseDDE;
    property DDEMessage: string read FDdeMessage write FDdeMessage;
    property DDEApplication: string read FDDEApplication write FDDEApplication;
    property DDEApplicationNotRunning: string read FDDEApplicationNotRunning write FDDEApplicationNotRunning;
    property DDETopic: string read FDDETopic write FDDETopic;
end;

implementation

{ TFileType }
// *****************************************************************************
function TFileType.AllValuesSet: Boolean;
var
  sFile: string;
begin
  if FFileExtension = '' then
    raise Exception.Create('TFileType.FileExtension has not been set');

  if FFileDescription = '' then
    FFileDescription := Copy(FFileExtension, 2, Length(FFileExtension)) + ' File';

  if FOpenWith = '' then
    raise Exception.Create('TFileType.OpenWith has not been set');

  if FOpenAction = '' then
    FOpenAction := 'Open';

  if FOpenActionDescription = '' then
    FOpenActionDescription := '&' + FOpenAction;

  if FUseDDE then
  begin
    if FDDEMessage = '' then
      FDDEMessage := '[Open(%1)]';
      
    if FDDEApplication = '' then
    begin
      sFile := ExtractFileName(FOpenWith);
      FDDEApplication := Copy(sFile, 1, Length(sFile) - Length(ExtractFileExt(sFile)));
    end;

    if FDDETopic = '' then
      FDDETopic := 'Server';
  end;

  Result := True;
end;
// *****************************************************************************
function TFileType.Register: Boolean;
var
  Reg: TRegistry;
begin
  Result := False;

  if not AllValuesSet then
    Exit;

  Reg := TRegistry.Create;

  try
    // Set the root key to HKEY_CLASSES_ROOT
    Reg.RootKey := HKEY_CLASSES_ROOT;

    // Now open the key, with the possibility to create
    // the key if it doesn't exist.
    Reg.OpenKey(FFileExtension, True);

    // Write my file type to it.
    // This adds HKEY_CLASSES_ROOT\.abc\(Default) = 'Project1.FileType'
    Reg.WriteString('', FFileDescription);
    Reg.CloseKey;

    // Now create an association for that file type
    Reg.OpenKey(FFileDescription, True);

    // This adds HKEY_CLASSES_ROOT\Project1.FileType\(Default)
    //   = 'Project1 File'
    // This is what you see in the file type description for
    // the a file's properties.
    Reg.WriteString('', FFileDescription);
    Reg.CloseKey;

    // Now write the default icon for my file type
    // This adds HKEY_CLASSES_ROOT\Project1.FileType\DefaultIcon
    //  \(Default) = 'Application Dir\Project1.exe,0'
    Reg.OpenKey(FFileDescription + '\DefaultIcon', True);
    Reg.WriteString('', FOpenWith + ',0');
    Reg.CloseKey;

    // Now write the open action in explorer
    Reg.OpenKey(FFileDescription + '\Shell\' + FOpenAction, True);
    Reg.WriteString('', FOpenActionDescription);
    Reg.CloseKey;

    // Write what application to open it with
    // This adds HKEY_CLASSES_ROOT\Project1.FileType\Shell\Open\Command
    // Your application must scan the command line parameters
    // to see what file was passed to it.
    Reg.OpenKey(FFileDescription + '\Shell\' + FOpenAction + '\Command', True);
    Reg.WriteString('', '"' + FOpenWith + '" "%1"');
    Reg.CloseKey;

    // If the user wants DDE then write the additional reg entries
    if FUseDDE then
    begin
      Reg.OpenKey(FFileDescription + '\Shell\' + FOpenAction + '\ddeexec', True);
      Reg.WriteString('', FDDEMessage);
      Reg.CloseKey;

      Reg.OpenKey(FFileDescription + '\Shell\' + FOpenAction + '\ddeexec\Application', True);
      Reg.WriteString('', FDDEApplication);
      Reg.CloseKey;

      Reg.OpenKey(FFileDescription + '\Shell\' + FOpenAction + '\ddeexec\IfExec', True);
      Reg.WriteString('', FDDEApplicationNotRunning);
      Reg.CloseKey;

      Reg.OpenKey(FFileDescription + '\Shell\' + FOpenAction + '\ddeexec\Topic', True);
      Reg.WriteString('', FDDETopic);
      Reg.CloseKey;
    end;


    // Finally, we want the Windows Explorer to realize we added
    // our file type by using the SHChangeNotify API.
    SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_IDLIST, nil, nil);
  finally
    Reg.Free;
  end;

  Result := True;
end;
// *****************************************************************************
procedure TFileType.SetFileExtension(const Value: string);
begin
  if not (Value[1] = '.') then
    FFileExtension := '.' + Value
  else
    FFileExtension := Value;
end;
// *****************************************************************************
function TFileType.UnRegister: Boolean;
var
  reg: TRegistry;
  sClassName: string;
begin
  reg := TRegistry.Create;

  if FFileExtension = '' then
    raise Exception.Create('TFileType.FileExtension property has not been set');

  try
    reg.RootKey := HKEY_CLASSES_ROOT;

    if not reg.KeyExists(FFileExtension) then
    begin
      Result := True;
      Exit;
    end;

    reg.OpenKey(FFileExtension, True);
    sClassName := reg.ReadString('');
    reg.CloseKey;
    reg.DeleteKey(FFileExtension);

    if not reg.KeyExists(sClassName) then
    begin
      Result := True;
      Exit;
    end;

    reg.DeleteKey(sClassName);
  finally
    reg.Free;
  end;

  Result := True;
end;
// *****************************************************************************
end.

