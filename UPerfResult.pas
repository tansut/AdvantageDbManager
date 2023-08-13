unit UPerfResult;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, RzPanel, Grids, DBGrids, AdsTable, DB,
  RzStatus, DBCtrls, Mask, RzEdit;

type
  TFmPerfResults = class(TForm)
    RzStatusBar1: TRzStatusBar;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    Grid: TDBGrid;
    Label8: TLabel;
    IndexCombo: TComboBox;
    DTSource: TDataSource;
    RecStatus: TRzStatusPane;
    DBNavigator1: TDBNavigator;
    Shape1: TShape;
    LblCreate: TRzNumericEdit;
    LblSave: TRzNumericEdit;
    LblIndex: TRzNumericEdit;
    Label5: TLabel;
    LblRecCount: TRzNumericEdit;
    procedure IndexComboChange(Sender: TObject);
    procedure DTSourceDataChange(Sender: TObject; Field: TField);
  private
    FTable: TAdsTable;
  public
    procedure Execute(ATable: TAdsTable);
  end;

var
  FmPerfResults: TFmPerfResults;

implementation

{$R *.dfm}

procedure TFmPerfResults.Execute(ATable: TAdsTable);
begin
  FTable := ATable;
  DTSource.DataSet := FTable;
  FTable.Open;
  IndexComboChange(nil);
  ShowModal;
end;

procedure TFmPerfResults.IndexComboChange(Sender: TObject);
begin
  FTable.IndexFieldNames := IndexCombo.Items[IndexCombo.ItemIndex];
end;

procedure TFmPerfResults.DTSourceDataChange(Sender: TObject;
  Field: TField);
begin
      try
         If FTable.IndexName = '' then
            RecStatus.Caption := IntToStr( FTable.RecNo ) + '/' +
                                                       IntToStr( FTable.RecordCount )
         else
            RecStatus.Caption:= IntToStr( FTable.AdsGetKeyNum  ) + '/' +
                                                       IntToStr( FTable.AdsGetKeyCount );
      except
      end;
end;

end.
