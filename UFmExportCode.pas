unit UFmExportCode;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons, UExportCode, UDbItems, adscnnct,
  RzTreeVw, ImgList, ToolWin, RzPrgres, RzStatus, RzPanel, Menus;

type
	TFmExportCode = class(TForm)
		pnlBottom: TPanel;
		dlgSave: TSaveDialog;
    tvDbItems: TRzCheckTree;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ActionImages: TImageList;
    ToolButton4: TToolButton;
    RzStatusBar1: TRzStatusBar;
    RzStatusPane: TRzStatusPane;
    PBar: TRzProgressBar;
    cmbExporter: TComboBox;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    PopupMenu1: TPopupMenu;
    cbIncludeDataMenuItem: TMenuItem;
    Label1: TLabel;
    ToolButton5: TToolButton;
		RzStatusPane1: TRzStatusPane;
		procedure cmbExporterChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure cbIncludeDataMenuItemClick(Sender: TObject);
	private
		{ Private declarations }
		FRoot: TDbBaseItem;
		FExporter: TCodeExporterFactory;

		procedure AddExporters;
		procedure ResetOptions;
		procedure PopulateTree(Parent: TTreeNode; NodeValue: TDBBaseItem);
		procedure SetRoot(const Value: TDBBaseItem);
                function GetImageIndex(Item: TDBBaseItem): Integer;
                procedure DoProgress(Sender: TObject; PercentDone: Integer);
	public
		{ Public declarations }
		function Execute: Boolean; overload;
								procedure ExportToCode(Dest: TDestinationType);

		property Exporter: TCodeExporterFactory read FExporter write FExporter;
		property Root: TDbBaseItem read FRoot write SetRoot;
	end;

var
	FmExportCode: TFmExportCode;

implementation

uses
	UAdsTable, UCodeExplorer, UAdsRef, UAdsLink, UAdsGroup, UAdsView,
	UAdsProc, UAdsUser;

{$R *.dfm}

procedure TFmExportCode.PopulateTree(Parent: TTreeNode;
	NodeValue: TDBBaseItem);
var
	i: Integer;
	Child: TTreeNode;
	DbList: TDBBaseList;
begin
	if (NodeValue.IsList) then
	begin
		TDBBaseList(NodeValue).Open;

		if TDbBaseList(NodeValue).ItemCount = 0 then
			Exit;
	end;

	Child := tvDbItems.Items.AddChild(Parent, NodeValue.Title);
	Child.ImageIndex := GetImageIndex(NodeValue);
	Child.SelectedIndex := Child.ImageIndex;
	Child.Data := NodeValue;

	if NodeValue.IsList then
	begin
		DbList := TDBBaseList(NodeValue);
		DbList.Open;

		for i := 0 to DbList.ItemCount-1 do
		begin
			PopulateTree(Child, DbList.Items[i]);
		end;
	end;
end;

procedure TFmExportCode.SetRoot(const Value: TDBBaseItem);
var
	I: Integer;
begin
	if Value <> FRoot then
	begin
		FRoot := Value;

		tvDbItems.Items.Clear;

		if Assigned(FRoot) then
			PopulateTree(nil, FRoot);
	end;

	if Assigned(tvDbItems.TopItem) then
		tvDbItems.TopItem.Expand(False);

	for I := 0 to tvDbItems.Items.Count-1 do
	begin
		tvDbItems.ItemState[I] := csChecked;
	end;
end;
procedure TFmExportCode.ExportToCode(Dest: TDestinationType);
var
	I: Integer;
	DbItem: TDBBaseItem;
begin
	with TCodeExporter.Create(Self) do
	try
		for I := 0 to tvDbItems.Items.Count-1 do
		begin
			if tvDbItems.Items[i].HasChildren then
				Continue;
				if (tvDbItems.ItemState[i] = csChecked) then
			begin
				DbItem := TDbBaseItem(tvDbItems.Items[i].Data);
					Items.AddDbItem(DbItem);
			end;
		end;
                FileName := '';
		IncludeData := cbIncludeDataMenuItem.Checked;
		ExporterFactory := CodeExporterList.Find(cmbExporter.Text);
		Dictionary := Root.Dictionary;
               	Destination := Dest;
                Exporter.RegisterProgressCallBackFunction(DoProgress);
		ExportCode;
	finally
		Free;
	end;

end;

function TFmExportCode.Execute: Boolean;
begin
        AddExporters;
	Result := ShowModal = mrOK;
end;

procedure TFmExportCode.cmbExporterChange(Sender: TObject);
begin
	cbIncludeDataMenuItem.Enabled :=
		CodeExporterList.Find(TComboBox(Sender).Text).SupportsData;
end;

procedure TFmExportCode.AddExporters;
var
	I: Integer;
begin
	cmbExporter.Clear;

	if Assigned(Exporter) then
	begin
		cmbExporter.Items.Add(Exporter.Description);
	end else
	begin
		for I := 0 to CodeExporterList.Count-1 do
		begin
			cmbExporter.Items.Add(CodeExporterList[I].Description);
		end;
	end;

	if cmbExporter.Items.Count > 0 then
	begin
		cmbExporter.ItemIndex := 0;
		cmbExporter.OnChange(cmbExporter);
	end;

	cmbExporter.Enabled :=
		cmbExporter.Items.Count > 1;
end;

procedure TFmExportCode.ResetOptions;
begin
	cbIncludeDataMenuItem.Enabled := False;
end;

procedure TFmExportCode.FormCreate(Sender: TObject);
begin
	ResetOptions;
end;

procedure TFmExportCode.ToolButton1Click(Sender: TObject);
begin
	ExportToCode(dtFile);
end;

procedure TFmExportCode.ToolButton4Click(Sender: TObject);
begin
	ExportToCode(dtScreen)
end;

function TFmExportCode.GetImageIndex(Item: TDBBaseItem): Integer;
begin
	if Item is TDatabase then Result := 11
	else if (Item is TDBUser) or (Item is TDBUserList) then Result := 12
	else if (Item is TDBGroup) or (Item is TDBGroupList) then Result := 13
	else if (Item is TDBTable) or (Item is TDBTableList) then Result := 14
	else if (Item is TDBProc) or (Item is TDBProcList) then Result := 15
	else if (Item is TDBView) or (Item is TDBViewList) then Result := 16
	else if (Item is TDBRef) or (Item is TDBRefList) then Result := 17
	else if (Item is TDBLink) or (Item is TDBLinkList) then Result := 18
	else Result := -1;
end;

procedure TFmExportCode.cbIncludeDataMenuItemClick(Sender: TObject);
begin
	cbIncludeDataMenuItem.Checked := not cbIncludeDataMenuItem.Checked;
end;

procedure TFmExportCode.DoProgress(Sender: TObject; PercentDone: Integer);
begin
	PBar.Percent := PercentDone;
end;

end.
