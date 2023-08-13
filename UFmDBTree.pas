unit UFmDBTree;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, UDbItems, adscnnct, StdCtrls, ExtCtrls, ImgList, ComCtrls,
  RzTreeVw;

type
  TFmDBTree = class(TForm)
    tvDbItems: TRzCheckTree;
    ActionImages: TImageList;
    Panel1: TPanel;
    btnOK: TButton;
    BtnCancel: TButton;
    procedure btnOKClick(Sender: TObject);
  private
    FRoot: TDbBaseItem;
    procedure PopulateTree(Parent: TTreeNode; NodeValue: TDBBaseItem);
    function GetImageIndex(Item: TDBBaseItem): Integer;
    procedure SetRoot(const Value: TDBBaseItem);
  public
    function Execute: Boolean;
    property Root: TDBBaseItem read FRoot write SetRoot;
  end;

var
  FmDBTree: TFmDBTree;

implementation

uses
	UAdsTable, UCodeExplorer, UAdsRef, UAdsLink, UAdsGroup, UAdsView,
	UAdsProc, UAdsUser;


procedure TFmDBTree.PopulateTree(Parent: TTreeNode;
	NodeValue: TDBBaseItem);
var
	i: Integer;
	Child: TTreeNode;
	DbList: TDBBaseList;
begin
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

procedure TFmDBTree.SetRoot(const Value: TDBBaseItem);
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

function TFmDBTree.GetImageIndex(Item: TDBBaseItem): Integer;
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


{$R *.dfm}

function TFmDBTree.Execute: Boolean;
begin
  Result := ShowModal = mrOk;
end;

procedure TFmDBTree.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

end.
