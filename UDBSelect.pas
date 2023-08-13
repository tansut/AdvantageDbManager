unit UDBSelect;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, StdCtrls, ComCtrls, RzTreeVw, ExtCtrls, UDbItems;

type
	TFmDBSelect = class(TForm)
		pnlDbItems: TPanel;
		lblDbItems: TLabel;
		tvDbItems: TRzCheckTree;
		btnOk: TButton;
		btnCancel: TButton;
	private
		{ Private declarations }
		FRoot: TDBBaseItem;
		FSelectionList: TList;
		procedure SetRoot(const Value: TDBBaseItem);

		procedure PopulateTree(Parent: TTreeNode; NodeValue: TDBBaseItem);
    function GetSelected: TList;
	public
		{ Public declarations }
		function Execute: Boolean;

		property Root: TDBBaseItem read FRoot write SetRoot;
		property SelectedItems: TList read GetSelected;
	end;

var
	FmDBSelect: TFmDBSelect;

implementation

{$R *.dfm}

{ TFmDBSelect }

function TFmDBSelect.Execute: Boolean;
begin
	Result :=
		ShowModal = mrOK;
end;

function TFmDBSelect.GetSelected: TList;
var
	i: Integer;
	SelectedNode: TTreeNode;
begin
	if Assigned(FSelectionList) then
	begin

	end else
	begin
		FSelectionList := TList.Create;

		for i := 0 to tvDbItems.Items.Count-1 do
		begin
			SelectedNode := tvDbItems.Items[i];

			if (not SelectedNode.HasChildren) and (tvDbItems.ItemState[i] = csChecked) then
				FSelectionList.Add(SelectedNode.Data);
		end;
	end;

	Result := FSelectionList;
end;

procedure TFmDBSelect.PopulateTree(Parent: TTreeNode;
	NodeValue: TDBBaseItem);
var
	i: Integer;
	Child: TTreeNode;
	DbList: TDBBaseList;
begin
	Child :=
		tvDbItems.Items.AddChild(Parent, NodeValue.Title);
	Child.Data := NodeValue;

	if NodeValue.IsList then
	begin
		DbList := TDBBaseList(NodeValue);

		for i := 0 to DbList.ItemCount-1 do
		begin
			PopulateTree(Child, DbList.Items[i]);
		end;
	end;
end;

procedure TFmDBSelect.SetRoot(const Value: TDBBaseItem);
begin
	if Value <> FRoot then
	begin
		FRoot := Value;

		tvDbItems.Items.Clear;

		if Assigned(FRoot) then
			PopulateTree(nil, FRoot);
	end;
end;

end.
