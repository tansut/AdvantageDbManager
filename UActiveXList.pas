unit UActiveXList;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, registry;

type
  TfmActiveXList = class(TForm)
    lbActiveX: TListBox;
    BtnOk: TButton;
    btnCancel: TButton;
    procedure btnCancelClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmActiveXList: TfmActiveXList;

implementation

{$R *.DFM}

procedure TfmActiveXList.btnCancelClick(Sender: TObject);
begin
   ModalResult := mrCancel;
end;

procedure TfmActiveXList.BtnOkClick(Sender: TObject);
begin
   if ( lbActiveX.ItemIndex < 0 ) then
   begin
     lbActiveX.SetFocus;
     raise Exception.Create('Önce listeden bir ActiveX seçmelisiniz.');
   end;
   ModalResult := mrOK;
end;

procedure TfmActiveXList.FormCreate(Sender: TObject);
var
   KeyNames: TStrings;
   strProgID: string;
   i: integer;
   registry : tregistry;
   SavedCursor : TCursor;
begin
   SavedCursor := Screen.Cursor;
   Screen.Cursor := crHourGlass;
   try
      KeyNames := TStringList.Create;

      registry := tregistry.Create;
      registry.RootKey := HKEY_CLASSES_ROOT;
      registry.OpenKey( '\CLSID', FALSE );

      Registry.GetKeyNames(KeyNames);
      Registry.CloseKey;

      if KeyNames.Count > 0 then
         for i := 0 to KeyNames.Count - 1 do
         begin
            if Registry.OpenKey('CLSID\' + KeyNames[i] + '\ProgID', False) then
            begin
               Registry.CloseKey;
               if Registry.OpenKey('CLSID\' + KeyNames[i], False) then
               begin
                  strProgID := Registry.ReadString('');
                  if ( strProgID <> '' ) then
                     lbActiveX.Items.Add(strProgID);

               Registry.CloseKey;
               end;
            Registry.CloseKey;
            end;
         end;

     KeyNames.Free;
     Registry.Free;

   finally
      Screen.Cursor := SavedCursor;
   end;
end;

end.
