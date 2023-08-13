unit UProc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UObjEdit, ComCtrls, StdCtrls, adsdictionary, ExtCtrls, Ace, UAdsObj,
  ImgList, UAdsProc, Mask, ToolEdit,UActiveXList, Buttons, ToolWin,UAdvUtils;

type
  TFmProc = class(TFmDBObjectEditor)
    Image1: TImage;
    Label1: TLabel;
    edName: TEdit;
    Label2: TLabel;
    edDLLName: TFilenameEdit;
    edProcName: TEdit;
    Label3: TLabel;
    GroupBox1: TGroupBox;
    edNameIn: TEdit;
    Label4: TLabel;
    cbTypeIn: TComboBox;
    Label5: TLabel;
    edSizeIn: TEdit;
    Label6: TLabel;
    BtnAddIn: TButton;
    GroupBox2: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    edNameOut: TEdit;
    cbTypeOut: TComboBox;
    edSizeOut: TEdit;
    btnAddOut: TButton;
    rbStandart: TRadioButton;
    rbActiveX: TRadioButton;
    Label11: TLabel;
    edDecIn: TEdit;
    Label7: TLabel;
    EdDecOut: TEdit;
    ImgSmall: TImageList;
    Panel1: TPanel;
    lstParamIn: TListView;
    Panel2: TPanel;
    lstParamOut: TListView;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    btnRemoveOut: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    btnRemoveIn: TSpeedButton;
    procedure cbTypeInChange(Sender: TObject);
    procedure cbTypeOutChange(Sender: TObject);
    procedure BtnAddInClick(Sender: TObject);
    procedure btnRemoveInClick(Sender: TObject);
    procedure btnAddOutClick(Sender: TObject);
    procedure btnRemoveOutClick(Sender: TObject);
    procedure edNameChange(Sender: TObject);
    procedure edDLLNameChange(Sender: TObject);
    procedure edProcNameChange(Sender: TObject);
    procedure edDLLNameBeforeDialog(Sender: TObject; var Name: String;
      var Action: Boolean);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
  private
    AdsProc : TAdsProc;
    function IsAdmin: Boolean;
    function ConcatParam (pList:TListView; pInOut: String): string;
    procedure AddItems(pList :TStringList; pLV: TListView);
    procedure SwapItems(pLV: TListView; pItem: Integer; pItem1: Integer);
  public
    procedure Init;
    function Edit: Boolean; override;
    procedure Validate; override;
    procedure ModeChanged; override;
    function New: Boolean; override;
    procedure OnDone; override;

end;

var
  FmProc: TFmProc;

implementation

{$R *.DFM}

function TFmProc.IsAdmin: Boolean;
begin
   Result := UpperCase(Dictionary.UserName) = 'ADSSYS';
end;

function TFmProc.Edit: Boolean;
   var ParamList: String;
   mList :TStringList;
begin
  Init;
  AdsProc := TAdsProc.Create(Dictionary, Item);
  mList := TStringList.Create;
  try
    edName.Text := Item;
    edDLLName.Text := AdsProc.GetDLLName;
    edProcName.Text := AdsProc.GetProcedureName;
    ParamList := AdsProc.GetProcInput;
    AdsProc.ParseParam (ParamList, mlist);
    AddItems(mList, lstParamIn);
    ParamList := '';
    ParamList := AdsProc.GetProcOutput;
    mList.Clear;
    AdsProc.ParseParam (ParamList, mlist);
    AddItems(mList, lstParamOut);
    if pos('.aep',edDLLName.Text) > 0 then
       rbStandart.Checked := true
    else
       rbActiveX.Checked := true;
  finally
    AdsProc.Free;
    mList.Free;
  end;
  Dirty := False;

  Result := ShowModal = mrOK;
end;

procedure TFmProc.Init;
begin
  if Not IsAdmin then
  begin
     edName.ReadOnly := True;
     edDLLName.ReadOnly := True;
     edProcName.ReadOnly := True;
     BtnAddIn.Enabled := False;
     btnRemoveIn.Enabled := False;
     btnAddOut.Enabled := False;
     btnRemoveOut.Enabled := False;
  end;
end;

function TFmProc.New: Boolean;
begin
  Init;
  Dirty := True;
  Result := ShowModal = mrOK;
end;

procedure TFmProc.ModeChanged;
begin
  case Mode of
    emEdit:
       Caption := Item + ' özellikleri';
    emNew:
       Caption := 'Yeni Prosedür Ekle';
   end;
end;

procedure TFmProc.Validate;
begin
  if  edName.Text = '' then
  begin
    edName.SetFocus;
    raise Exception.Create('Prosedür adýný girmelisiniz.');
  end;

  if edDLLName.Text = '' then
  begin
    edDLLName.SetFocus;
    raise Exception.Create('AEP Prosedür dosyasýný girmelisiniz.');
  end;

  if edProcName.Text = '' then
  begin
    edProcName.SetFocus;
    raise Exception.Create('AEP Prosedür adýný girmelisiniz.');
  end;

end;

procedure TFmProc.OnDone;
var
  mTempDLLName : String;
  mTempProcName : String;
  mTempInputParam : String;
  mTempOutputParam : String;
  mParam :TstringList;
  mInLV : TListView;
  mOutLV: TListView;
begin
  AdsProc := TAdsProc.Create(Dictionary, Item);
  try
    if Mode = emEdit then
    begin
      mTempDLLName := AdsProc.GetDLLName ;
      mTempProcName := AdsProc.GetProcedureName ;
      mTempInputParam := AdsProc.GetProcInput;
      mTempOutputParam := AdsProc.GetProcOutput;
      AdsProc.DropStoredProc(Item);
    end;
    try
      AdsProc.CreateStoredProc(edName.Text, ConcatParam(lstParamIn, ''),
                               ConcatParam(lstParamOut, 'OUTPUT'),
                               Replace(edDLLName.Text, '"'), edProcName.Text);

      Item := edName.Text;
    except
      if Mode = emEdit then begin
         mParam := TStringList.Create;
         mInLV  := TListView.Create(nil);
         mInLV.Visible := False;
         mInLV.Parent := Self;
         mOutLV := TListView.Create(nil);
         mOutLV.Visible := False;
         mOutLV.Parent := Self;
         try
           AdsProc.ParseParam(mTempInputParam, mParam);
           AddItems(mParam, mInLV);
           mParam.Clear;
           AdsProc.ParseParam(mTempOutputParam, mParam);
           AddItems(mParam, mOutLV);
           AdsProc.CreateStoredProc(Item, ConcatParam( mInLV, ''),
                                    ConcatParam(mOutLV,'OUTPUT'),
                                    Replace(mTempDLLName, '"') , mTempProcName);
         finally
           mParam.Free;
           mInLv.Free;
           mOutLv.Free;
         end;
      end;
      raise;
    end;
  finally
    AdsProc.Free;
  end;

end;

function TFmProc.ConcatParam (pList:TListView; pInOut: String): string;
  var mParam: string;
      i: integer;
      mType : string;
begin
  for i := 0 to pList.Items.Count - 1 do begin
    mType := pList.Items[i].SubItems.Strings[0];
    if UPPERCASE(mType) = 'BINARY' then
       mType := 'BLOB';
    mParam := '"' + pList.Items[i].Caption + '" '+ mType;
    if pList.Items[i].SubItems.Count > 1 then begin
       mParam := mParam + '(' + pList.Items[i].SubItems.Strings[1];
      if pList.Items[i].SubItems.Count > 2 then
         mParam := mParam + ',' + pList.Items[i].SubItems.Strings[2] + ')'
      else
         mParam := mParam + ')';
    end;
    Result := Result + mParam +' ' +pInOut +', ';
  end;
  Result := Copy (Result, 1, Length(Result) -2);
end;

procedure TFmProc.cbTypeInChange(Sender: TObject);
begin
  inherited;
  if (cbTypeIn.Text='CHAR') or (cbTypeIn.Text='VARCHAR') or (cbTypeIn.Text='RAW') or
     (cbTypeIn.Text='DOUBLE') or (cbTypeIn.Text='CURDOUBLE') then
  begin
     edSizeIn.Text := '10';
     edSizeIn.Enabled := True;
     edSizeIn.Color := clWindow;
     if (cbTypeIn.Text='DOUBLE') or (cbTypeIn.Text='CURDOUBLE') then
     begin
       edDecIn.Enabled := True;
       edDecIn.Text := '2';
       edDecIn.Color := clWindow;
     end else
     begin
       edDecIn.Enabled := False;
       edDecIn.Color := clBtnFace;
     end;
  end else begin
     edSizeIn.Text := '';
     edSizeIn.Enabled := False;
     edSizeIn.Color := clBtnFace;
     edDecIn.Text := '';
     edDecIn.Enabled := False;
     edDecIn.Color := clBtnFace;
  end;

end;

procedure TFmProc.cbTypeOutChange(Sender: TObject);
begin
  inherited;
  if (cbTypeOut.Text='CHAR') or (cbTypeOut.Text='VARCHAR') or (cbTypeOut.Text='RAW') or
  (cbTypeOut.Text='DOUBLE') or (cbTypeOut.Text='CURDOUBLE') then
  begin
     edSizeOut.Text := '10';
     edSizeOut.Enabled := True;
     edSizeOut.Color := clWindow;
     if (cbTypeOut.Text='DOUBLE') or (cbTypeOut.Text='CURDOUBLE') then
     begin
      edDecOut.Enabled := True;
      EdDecOut.Text := '2';
      EdDecOut.Color := clWindow;
     end else
     begin
       edDecOut.Enabled := False;
       EdDecOut.Color := clBtnFace;
     end;
  end else begin
     edSizeOut.Text := '';
     edSizeOut.Enabled := False;
     EdSizeOut.Color := clBtnFace;
     edDecOut.Text := '';
     edDecOut.Enabled := False;
     EdDecOut.Color := clBtnFace;

  end;
end;

procedure TFmProc.BtnAddInClick(Sender: TObject);
  var mNum: integer;
  var ListItem: TListItem;
begin
  inherited;
  if edNameIn.Text = '' then
  begin
    edNameIn.SetFocus;
    raise Exception.Create('Parametre adý girmelisiniz.');
  end;

  if cbTypeIn.Text = '' then
  begin
    edNameIn.SetFocus;
    raise Exception.Create('Parametre tipini seçmelisiniz.');
  end;

  if ((cbTypeIn.Text = 'CHAR') or  (cbTypeIn.Text = 'VARCHAR') or (cbTypeIn.Text = 'RAW') or
    (cbTypeIn.Text='DOUBLE') or (cbTypeIn.Text='CURDOUBLE') )
     and (edSizeIn.Text = '')  then
  begin
    edSizeIn.SetFocus;
    raise Exception.Create('Parametre uzunluðunu girmelisiniz.');
  end;

  if (cbTypeIn.Text='DOUBLE') or (cbTypeIn.Text='CURDOUBLE') then
  try
    mnum := StrToInt(edDecIn.Text);
  except
    edDecIn.SetFocus;
    raise Exception.Create('Ondalýk nümerik olmalýdýr.');
  end;

  if edSizeIn.Text <> '' then
    try
      mNum := StrToInt(edSizeIn.Text);
    except
      edSizeIn.SetFocus;
      raise Exception.Create('Parametre uzunluðunu nümerik olmalýdýr.');
    end;

  ListItem:=lstParamIn.Items.Add;
  With ListItem do begin
    Caption:=edNameIn.Text;
    ImageIndex := 0;
    SubItems.Add(cbTypeIn.Text);
    if edSizeIn.Text <>'' then begin
       SubItems.Add(edSizeIn.Text);
       if eddecin.Text<>'' then
         SubItems.Add(edDecIn.Text);
    end;
  end;

  Dirty := True;
end;

procedure TFmProc.btnRemoveInClick(Sender: TObject);
begin
  inherited;
  if lstParamIn.Selected = nil then Exit;
  lstParamIn.Items.Delete(lstParamIn.ItemIndex);
  Dirty := True;
end;

procedure TFmProc.btnAddOutClick(Sender: TObject);
  var mNum: integer;
    ListItem : TListItem;
begin
  inherited;
  if edNameOut.Text = '' then
  begin
    edNameOut.SetFocus;
    raise Exception.Create('Parametre adý girmelisiniz.');
  end;

  if cbTypeOut.Text = '' then
  begin
    edNameOut.SetFocus;
    raise Exception.Create('Parametre tipini seçmelisiniz.');
  end;

  if ((cbTypeOut.Text = 'CHAR') or  (cbTypeOut.Text = 'VARCHAR') or (cbTypeOut.Text = 'RAW'))
     and (edSizeOut.Text = '')  then
  begin
    edSizeOut.SetFocus;
    raise Exception.Create('Parametre uzunluðunu girmelisiniz.');
  end;
  if (cbTypeOut.Text='DOUBLE') or (cbTypeOut.Text='CURDOUBLE') then
  try
    mnum := StrToInt(edDecOut.Text);
  except
    edDecOut.SetFocus;
    raise Exception.Create('Ondalýk nümerik olmalýdýr.');
  end;


  if edSizeOut.Text <> '' then
    try
      mNum := StrToInt(edSizeOut.Text);
    except
      edSizeOut.SetFocus;
      raise Exception.Create('Parametre uzunluðunu nümerik olmalýdýr.');
    end;

  ListItem:=lstParamOut.Items.Add;
  With ListItem do begin
    Caption:=edNameOut.Text;
    ImageIndex := 0;
    SubItems.Add(cbTypeOut.Text);
    if edSizeOut.Text <>'' then begin
       SubItems.Add(edSizeOut.Text);
       if edDecOut.Text<>'' then
         SubItems.Add(edDecOut.Text);
    end;
  end;

  Dirty := True;
end;

procedure TFmProc.btnRemoveOutClick(Sender: TObject);
begin
  inherited;
  if lstParamOut.Selected = nil then Exit;
  lstParamOut.Items.Delete(lstParamOut.ItemIndex);
  Dirty := True;
end;

procedure TFmProc.edNameChange(Sender: TObject);
begin
  inherited;
  Dirty := True;
end;

procedure TFmProc.edDLLNameChange(Sender: TObject);
begin
  inherited;
  Dirty := True;
end;

procedure TFmProc.edProcNameChange(Sender: TObject);
begin
  inherited;
  Dirty := True;
end;

procedure TFmProc.edDLLNameBeforeDialog(Sender: TObject; var Name: String;
  var Action: Boolean);
begin
  inherited;
  if rbActiveX.Checked then
  begin
    with TfmActiveXList.Create( nil ) do
    begin
      try
        ShowModal;
        if ( ModalResult = mrOK ) then
        begin
          edDLLName.Text := lbActiveX.Items[ LbActiveX.ItemIndex ] ;
        end;
      finally
        Free;
      end;
    end;
    Action := false;
  end;
end;

procedure TFmProc.AddItems(pList: TStringList; pLV: TListView);
  var ListItem : TlistItem;
  i:integer;
  mField : String;
  mpos:integer;
begin
  for i:= 0 to pList.Count - 1 do begin
    ListItem:=pLV.Items.Add;
    mField := pList.Strings[i];
    With ListItem do begin
      mpos := Pos(',', mField);
      Caption:=Copy(mField,1,mPos -1);
      mField := Copy(mField,mPos + 1, length(mField)-mPos);
      ImageIndex := 0;
      while Pos(',', mField) > 0 do begin
        mpos := Pos(',', mField);
        SubItems.Add(Copy(mField,1,mPos -1));
        mField := Copy(mField,mPos + 1, length(mField)-mPos);
      end;
      SubItems.Add(mField);
    end;
  end;
end;

procedure TFmProc.SwapItems(pLV: TListView; pItem, pItem1: Integer);
  var ListItem : TListItem;
  procedure SetItemProp (pListItem: TlistItem; pListItem1: TlistItem);
    var i : integer;
  begin
     pListItem.Caption := pListItem1.Caption;
     pListItem.ImageIndex := pListItem1.ImageIndex;
     pListItem.SubItems.Clear;
     for i:= 0 to pListItem1.SubItems.Count -1 do
        pListItem.SubItems.Add(pListItem1.SubItems.Strings[i]);
  end;
begin
  ListItem := pLV.Items.Add;
  try
    SetItemProp (ListItem, pLV.Items[pItem]);
    SetItemProp (pLV.Items[pItem], pLV.Items[pItem1]);
    SetItemProp (pLV.Items[pItem1],ListItem);
  finally
    ListItem.Delete;
  end;
  pLV.ItemIndex := pItem1;
  Dirty := True;
end;

procedure TFmProc.ToolButton1Click(Sender: TObject);
begin
  inherited;
  if LstParamIn.ItemIndex > 0 then
    SwapItems(lstParamIn, LstParamIn.ItemIndex, LstParamIn.ItemIndex -1);
end;

procedure TFmProc.ToolButton2Click(Sender: TObject);
begin
  inherited;
  if LstParamIn.ItemIndex < LstParamIn.Items.Count -1 then
    SwapItems(lstParamIn, LstParamIn.ItemIndex, LstParamIn.ItemIndex +1);
end;

procedure TFmProc.ToolButton3Click(Sender: TObject);
begin
  inherited;
  if LstParamOut.ItemIndex > 0 then
    SwapItems(lstParamOut, LstParamOut.ItemIndex, LstParamOut.ItemIndex -1);

end;

procedure TFmProc.ToolButton4Click(Sender: TObject);
begin
  inherited;
  if LstParamOut.ItemIndex < LstParamOut.Items.Count -1 then
    SwapItems(lstParamOut, LstParamOut.ItemIndex, LstParamOut.ItemIndex +1);
end;

end.
