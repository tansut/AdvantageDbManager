unit UObjEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  adsdictionary, ComCtrls, StdCtrls;

type
  TEditorMode = (emEdit, emNew, emNone);
  TFmDBObjectEditor = class(TForm)
    BtnOk: TButton;
    btnCancel: TButton;
    btnHelp: TButton;
    PageControl1: TPageControl;
    tsGeneral: TTabSheet;
    btnApply: TButton;
    procedure BtnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
  private
    FDirty: Boolean;
    FDictionary: TAdsDictionary;
    FItem: string;
    FMode: TEditorMode;
    FApplied: Boolean;
    procedure SetMode(const Value: TEditorMode);
  public
    procedure SetDirty(const Value: Boolean); virtual;
    function Edit: Boolean; virtual; abstract;
    function New: Boolean; virtual; abstract;
    procedure Validate; virtual; abstract;
    procedure OnDone; virtual; abstract;
    procedure DirtyChanged; virtual;
    procedure ModeChanged; virtual;
    property Dirty: Boolean read FDirty write SetDirty;
    property Dictionary: TAdsDictionary read FDictionary write FDictionary;
    property Item: string read FItem write FItem;
    property Mode: TEditorMode read FMode write SetMode;
  end;

  DBObjectEditorClass = class of TFmDBObjectEditor;

var
  FmDBObjectEditor: TFmDBObjectEditor;

function EditItem(Dict: TAdsDictionary; const AItem: string; FormClass: DBObjectEditorClass): Boolean;
function NewItem(Dict: TAdsDictionary; FormClass: DBObjectEditorClass): Boolean;

implementation

{$R *.DFM}

function EditItem(Dict: TAdsDictionary; const AItem: string; FormClass: DBObjectEditorClass): Boolean;
begin
  with FormClass.Create(nil) do
  try
    Dictionary := Dict;
    Item := AItem;
    Mode := emEdit;
    Result := Edit;
  finally
    Free;
  end;
end;

function NewItem(Dict: TAdsDictionary; FormClass: DBObjectEditorClass): Boolean;
begin
  with FormClass.Create(nil) do
  try
    Dictionary := Dict;
    Mode := emNew;
    Result := New();
  finally
    Free;
  end;
end;

procedure TFmDBObjectEditor.BtnOkClick(Sender: TObject);
begin
  if FDirty then
  begin
    Validate;
    OnDone;
    ModalResult := MrOk
  end else if FApplied then ModalResult := MrOk
  else ModalResult := MrCancel;
end;

procedure TFmDBObjectEditor.btnCancelClick(Sender: TObject);
begin
  if FApplied then ModalResult := mrOk
  else ModalResult := MrCancel;
end;

procedure TFmDBObjectEditor.SetDirty(const Value: Boolean);
begin
  FDirty := Value;
  btnApply.Enabled := FDirty;
end;

procedure TFmDBObjectEditor.FormCreate(Sender: TObject);
begin
  Dirty := False;
  FApplied := False;
end;

procedure TFmDBObjectEditor.btnApplyClick(Sender: TObject);
begin
  Validate;
  OnDone;
  if Mode = emNew then
    SetMode (emEdit);
  FApplied := True;
  Dirty := False;
end;

procedure TFmDBObjectEditor.DirtyChanged;
begin

end;

procedure TFmDBObjectEditor.SetMode(const Value: TEditorMode);
begin
  FMode := Value;
  ModeChanged;
end;

procedure TFmDBObjectEditor.ModeChanged;
begin

end;

procedure TFmDBObjectEditor.btnHelpClick(Sender: TObject);
begin
  if Self.HelpContext > 0 then
     Application.HelpCommand (HELP_CONTEXT, Self.HelpContext); 
end;

end.
