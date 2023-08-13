unit UView;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UObjEdit, ComCtrls, StdCtrls, adsdictionary, ExtCtrls, Ace, UAdsObj,
  ImgList, UAdsView, MemoComponentUnit, SourceEditUnit, SynEditHighlighter,
  SynHighlighterSQL, SynEdit;

type
  TFmView = class(TFmDBObjectEditor)
    edName: TEdit;
    Label1: TLabel;
    Image1: TImage;
    mmDesc: TMemo;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    mmStmt: TSynEdit;
    shSQL: TSynSQLSyn;
    procedure edNameChange(Sender: TObject);
    procedure mmStmtChange(Sender: TObject);
    procedure mmDescChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    AdsView : TAdsView;
    function IsAdmin: Boolean;
  public
    procedure Init;
    function Edit: Boolean; override;
    procedure Validate; override;
    procedure ModeChanged; override;
    function New: Boolean; override;
    procedure OnDone; override;
  end;

var
  FmView: TFmView;

implementation

{$R *.DFM}

function TFmView.IsAdmin: Boolean;
begin
   Result := UpperCase(Dictionary.UserName) = 'ADSSYS';
end;

function TFmView.Edit: Boolean;
begin
  Init;
  AdsView := TAdsView.Create(Dictionary, Item);
  try
    edName.Text := Item;
    mmStmt.Lines.Text := AdsView.GetSTMT;
    mmDesc.Lines.Text := AdsView.GetDescription;
  finally
    AdsView.Free;
  end;
  Dirty := False;
  Result := ShowModal = mrOK;
end;

procedure TFmView.Init;
begin
  if Not IsAdmin then
  begin
     edName.ReadOnly := True;
     mmStmt.ReadOnly := True;
     mmDesc.ReadOnly := True;
  end;
end;

procedure TFmView.ModeChanged;
begin
  case Mode of
    emEdit:
    begin
       Caption := Item + ' özellikleri';
    end;
    emNew:
    begin
       Caption := 'Yeni Görünüm Ekle';
    end;
   end;
end;

procedure TFmView.Validate;
begin
  if edName.Text = '' then
  begin
    edName.SetFocus;
    raise Exception.Create('Görünümün adý girilmelidir.');
  end;

  if mmStmt.Lines.Text = '' then
  begin
    mmStmt.SetFocus;
    raise Exception.Create('SQL Cümlesi girilmelidir.');
  end;

end;

function TFmView.New: Boolean;
begin
  Init;
  Dirty := True;
  Result := ShowModal = mrOK;
end;

procedure TFmView.OnDone;
  var mTempDesc : String;
      mTempStmt : String;
begin

    if Mode = emEdit then
    begin
       AdsView := TAdsView.Create(Dictionary, Item);
       mTempDesc := AdsView.GetDescription;
       mTempStmt := AdsView.GetSTMT;
       AdsView.Free;
       Dictionary.RemoveView(Item);
    end;

    try
      Dictionary.AddView (edName.Text,mmDesc.Lines.Text,mmStmt.Lines.Text);
      Item := edName.Text;
    except
      if Mode = emEdit then
         Dictionary.AddView (Item,mTempDesc ,mTempStmt);
      raise;
    end;

end;

procedure TFmView.edNameChange(Sender: TObject);
begin
  inherited;
  Dirty := True;
end;

procedure TFmView.mmStmtChange(Sender: TObject);
begin
  inherited;
  Dirty := True;
end;

procedure TFmView.mmDescChange(Sender: TObject);
begin
  inherited;
  Dirty := True;
end;

procedure TFmView.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (self.ActiveControl <>mmStmt) and (Key=13) then
    BtnOkClick (Sender);
end;

procedure TFmView.FormShow(Sender: TObject);
begin
  inherited;
  edName.SetFocus; 
end;

end.
