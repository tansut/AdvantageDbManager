unit UCodeExplorer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, SynEdit, StdCtrls, SynEditHighlighter,
  SynHighlighterPas, ComCtrls, ToolWin, Menus, DBActns, StdActns, ActnList,
  ImgList, SynMemo;

type
  TFmCodeExplorer = class(TForm)
    dlgSave: TSaveDialog;
    ActionImages: TImageList;
    ActionList1: TActionList;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    EditSelectAll1: TEditSelectAll;
    EditUndo1: TEditUndo;
    EditRedo: TAction;
    ActionOptions: TAction;
    ActionAbout: TAction;
    ActionPrint: TAction;
    FileOpen: TAction;
    FileExit: TAction;
    EditorFont: TAction;
    EditorBckColor: TAction;
    ExportToWord: TAction;
    ExportToHTML: TAction;
    EditDelete2: TEditDelete;
    ActionOpenCat: TAction;
    ActionCloseCat: TAction;
    ViewShowCategory: TAction;
    ViewToolBars: TAction;
    ViewStatusBar: TAction;
    ActionPreview: TAction;
    ViewLineNumbers: TAction;
    ViewEditorLine: TAction;
    HelpDelphiTurk: TAction;
    HelpBook: TAction;
    RecordSend: TAction;
    DeleteSent: TAction;
    EditCopy2: TEditCopy;
    EditCopyAsRTF: TAction;
    VersionCheck: TAction;
    SearchAction: TAction;
    EditorWordWrap: TAction;
    SearchTextAction: TAction;
    ActionFindNext: TAction;
    ActionFindPrev: TAction;
    ActionReplace: TAction;
    ReadmeAction: TAction;
    EditorMenu: TPopupMenu;
    sadas: TMenuItem;
    DKMenuItem: TMenuItem;
    N7: TMenuItem;
    Kes2: TMenuItem;
    Kopyala2: TMenuItem;
    Yaptr2: TMenuItem;
    Sil3: TMenuItem;
    Hakknda2: TMenuItem;
    TmnSe2: TMenuItem;
    ToolBar1: TToolBar;
    BtSaveScr: TToolButton;
    ToolButton11: TToolButton;
    ToolButton8: TToolButton;
    StatusBar1: TStatusBar;
    mmSource: TSynMemo;
    procedure btnCloseClick(Sender: TObject);
    procedure BtSaveScrClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FmCodeExplorer: TFmCodeExplorer;

implementation

uses UDBSQL;

{$R *.dfm}

procedure TFmCodeExplorer.btnCloseClick(Sender: TObject);
begin
	Close;
end;

procedure TFmCodeExplorer.BtSaveScrClick(Sender: TObject);
begin
  if dlgSave.Execute then
		mmSource.Lines.SaveToFile(dlgSave.FileName);
end;

end.
