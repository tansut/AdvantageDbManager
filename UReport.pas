unit UReport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, StdCtrls, Mask, ToolEdit, ExtCtrls,AdsDictionary,
  adscnnct,adstable,UAdsTable,UAdsRef,UAdsProc,UAdsView,
  UAdsLink,ComObj;

type
  TfmReport = class(TForm)
    ilSmall: TImageList;
    Panel1: TPanel;
    Label1: TLabel;
    lvDBItems: TListView;
    GroupBox1: TGroupBox;
    rbScreen: TRadioButton;
    rbFile: TRadioButton;
    edFileName: TFilenameEdit;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure rbScreenClick(Sender: TObject);
    procedure rbFileClick(Sender: TObject);
  private
    procedure Report(Dictionary:TAdsDictionary);
  public
    Dictionary : TAdsDictionary;
  end;

var
  fmReport: TfmReport;
implementation

{$R *.dfm}


procedure TfmReport.Report(Dictionary:TAdsDictionary);
  var ww : variant;
      doc: variant;
      sel: variant;
      table: variant;
      mpkname : string;
      i,checkcount: integer;
  Procedure TableBorder (ss : integer);
    var i: integer;
  begin
     for i:= -8 to -1 do
     begin
        table.borders.item(i).LineStyle := ss;
     end;
     table.borders.shadow := false;
  end;

  procedure columnwidth ( width : double ) ;
  begin
      sel.Columns.PreferredWidthType := 3;
      sel.Columns.PreferredWidth := width * 28;
  end;
  procedure rowHeight ( height : double);
  begin
     table.rows.HeightRule := 1;
     table.Rows.Height := height * 28;
     table.Range.Cells.VerticalAlignment := 1;
  end;

  Procedure SatirEkle ( say : integer );
    var i:integer;
  begin
     for i:= 1 to say do
     begin
        sel.TypeParagraph;
     end;
  end;
  procedure writePKey (tempTable:TDBAdsTable);
  var
    tempField:string;
    i:integer;
    tempInx:TAdsIndex;
  begin
      mpkname:=tempTable.PrimaryKey;
      if mpkname='' then exit;
      table := doc.Tables.Add (ww.selection.range,1,2,0,0);
      sel.typetext ('Anahtar Ýndeks'); columnwidth (7.5); sel.moveright (1,1);
      sel.typetext ('Alan Adý');columnwidth (5); sel.moveright (1,1);
      sel.insertrows(1);
      sel.font.bold := false;
      sel.typetext (mpkname);
      sel.range.cells.borders.item(-3).LineStyle := 0;
      sel.moveright (1,1);
      tempField:=tempTable.GetIndexExp(mpkname);
      tempInx:=TAdsIndex.create(Dictionary,tempTable.Name,mpkname);
      tempInx.RefreshDictProp;
    try
      for i:=0 to tempInx.fields.Count-1 do
      begin
         sel.font.bold := false;
         sel.typetext (tempInx.fields[i]);
         sel.moveright (1,1);
         sel.insertrows(1);
         sel.typetext(' ');
         sel.range.cells.borders.item(-1).LineStyle := 0;
         sel.range.cells.borders.item(-3).LineStyle := 0;
         sel.moveright (1,1);
      end;
      rowheight (0.6);
      sel.rows.delete;
      satirekle(1);
    finally
      tempInx.Free;
    end;
  end;

  procedure writeFKey;
     var MRtable : string;
       fkNames:TStringList;
       tempfk:TAdsRef;
       i:integer;
  begin
    fkNames:=TStringList.Create;
    try
      Dictionary.GetRINames(fkNames);
      if fkNames.Count<=0  then exit;
      sel.font.bold := true;
      sel.typetext('ÝLÝÞKÝSEL BAÐLAR' );
      satirEkle(2);
      table := doc.Tables.Add (ww.selection.range,1,5,0,0);
      sel.typetext ('Yabancý Anahtar'); columnwidth (5); sel.moveright (1,1);
      sel.typetext ('Ana Tablo');columnwidth (5); sel.moveright (1,1);
      sel.typetext ('Ana Ýndex');columnwidth (5); sel.moveright (1,1);
      sel.typetext ('Referans Tablo');columnwidth (5); sel.moveright (1,1);
      sel.typetext ('Referans Ýndex');columnwidth (5); sel.moveright (1,1);
      sel.insertrows(1);
      for i:=0 to fkNames.Count-1 do
      begin
         tempfk:=TAdsRef.Create(Dictionary,fkNames[i]);
         MRtable :=tempfk.GetParentTable;
         sel.font.bold := false;
         sel.typetext ( tempfk.Name);
         sel.moveright (1,1);
         sel.font.bold := false;
         sel.typetext (mrtable); sel.moveright (1,1);
         sel.typetext (tempfk.GetPrimaryKey); sel.moveright (1,1);
         sel.typetext (tempfk.GetChildTable); sel.moveright (1,1);
         sel.typetext (tempfk.GetForeignIndex); sel.moveright (1,1);
         sel.insertrows(1);
         sel.typetext(' ');
         sel.range.cells.borders.item(-1).LineStyle := 0;
         sel.range.cells.borders.item(-3).LineStyle := 0;
         sel.moveright (1,1);
         sel.moveleft (1,1);
         sel.range.cells.borders.item(-1).LineStyle := 1;
         tempfk.Free;
      end;
      rowheight (0.6);
      sel.rows.delete;
      table.borders.item(-3).LineStyle := 1;
      satirekle(2);
      sel.InsertBreak (2);
    finally
      fkNames.Free;
    end;
  end;

  procedure writeIndex (tempTable:TDBAdsTable);
  var
    tempInx:TAdsIndex;
    i,j:integer;
    fList:TStringList;
  begin
    if  tempTable.Indexes.Count<=0  then exit;
      table := doc.Tables.Add (ww.selection.range,1,4,0,0);
      sel.typetext ('Ýndeks Adý'); columnwidth (7.5); sel.moveright (1,1);
      sel.typetext ('Tekil');columnwidth (2); sel.moveright (1,1);
      sel.typetext ('Ýçerik Arama Ýndeksi');columnwidth (4); sel.moveright (1,1);
      sel.typetext ('Alan Adý');columnwidth (5); sel.moveright (1,1);
      sel.insertrows(1);
      for i:=0 to tempTable.Indexes.Count-1 do
      begin
         tempInx:=TAdsIndex.create(Dictionary,tempTable.Name,tempTable.Indexes[i]);
         tempInx.RefreshDictProp;
         sel.font.bold := false;
         sel.typetext (tempInx.Name);
         sel.moveright (1,1);
         sel.font.bold := false;
         if tempInx.Unique then
            Sel.TypeText ('Evet')
         else
            Sel.TypeText ('Hayýr');
         sel.moveright (1,1);
         sel.font.bold := false;
         if tempInx.FTSIndex then
            Sel.TypeText ('Evet')
         else
            Sel.TypeText ('Hayýr');
         sel.moveright (1,1);
         try
           fList:=TStringList.Create;
           fList:=tempInx.fields;
           for j:= 0 to fList.Count-1 do
           begin
             sel.font.bold := false;
             sel.typetext ( fList[j]);
             sel.moveright (1,1);
             sel.insertrows(1);
             sel.typetext(' ');
//             sel.range.cells.borders.item(-1).LineStyle := 0;
//             sel.range.cells.borders.item(-3).LineStyle := 0;
             sel.moveright (1,1);
//             sel.range.cells.borders.item(-1).LineStyle := 0;
//             sel.range.cells.borders.item(-3).LineStyle := 0;
             sel.moveright (1,1);
             sel.moveright (1,1);
           end;
         finally
           fList.Free;
         end;
         sel.moveleft (1,1);
         sel.moveleft (1,1);
         sel.moveleft (1,1);
         tempInx.Free;
       end;
       rowheight (0.6);
       sel.rows.delete;
       satirekle(1);
  end;

  procedure writeTrigger (tempTable:TDBAdsTable);
  var
    tempTrg:TAdsTrigger;
    i:integer;
  begin
    if  tempTable.Triggers.Count<=0  then exit;
      table := doc.Tables.Add (ww.selection.range,1,4,0,0);
      sel.typetext ('Tetikleyici Adý'); columnwidth (7.5); sel.moveright (1,1);
      sel.typetext ('Tipi');columnwidth (2.5); sel.moveright (1,1);
      sel.typetext ('Olay Tipi');columnwidth (2.5); sel.moveright (1,1);
      sel.typetext ('Kod Tipi');columnwidth (6); sel.moveright (1,1);
      for i:=0 to tempTable.Triggers.Count-1 do
      begin
         tempTrg:=TAdsTrigger.create(Dictionary,tempTable.Triggers[i]);
         try
           sel.insertrows(1);
           sel.font.bold := false;
           sel.typetext (temptrg.Name);
           sel.moveright (1,1);
           sel.font.bold := false;
           case tempTrg.GetTriggerType of
             adsdictionary.ttBefore    : Sel.TypeText ('Before');
             adsdictionary.ttInsteadOf : Sel.TypeText ('Instead Of');
             adsdictionary.ttAfter     : Sel.TypeText ('After');
           end;
           sel.moveright (1,1);
           case tempTrg.GetEventType of
             etInsert  : Sel.TypeText ('Insert');
             etUpdate  : Sel.TypeText ('Update');
             etDelete  : Sel.TypeText ('Delete');
           end;
           sel.moveright (1,1);
           case tempTrg.GetContainerType of
             ctStdLib  : Sel.TypeText ('Windows DLL');
             ctCOM     : Sel.TypeText ('Com Nesnesi veya .NET Assembly');
             ctScript  : Sel.TypeText ('SQL Script');
           end;
           sel.moveright (1,1);
         finally
           tempTrg.Free;
         end;
       end;
       rowheight (0.6);
       sel.movedown (5,1);
       satirekle(1);
  end;

  procedure writeTableColumns (tablename :string ) ;
     var i : integer;
       tempTable:TDBAdsTable;
  begin
    tempTable:=TDBAdsTable.Create(Dictionary,tablename);
    try
      tempTable.RefreshProperties;
      sel.font.bold := true;
      sel.typetext('Tablo Adý : ' + tablename);
      satirEkle(2);
      if lvDBItems.Items[1].Checked then begin
        table := doc.Tables.Add (ww.selection.range,1,5,0,0);
        sel.typetext ('Alan Adý'); columnwidth (5); sel.moveright (1,1);
        sel.typetext ('Veri Türü');columnwidth (3); sel.moveright (1,1);
        sel.typetext ('Uzunluk'); columnwidth (2); sel.moveright (1,1);
        sel.typetext ('Zorunlu'); columnwidth (2); sel.moveright (1,1);
        sel.typetext ('Açýklama'); columnwidth (13);sel.moveright (1,1);
        for i:=0 to tempTable.Fields.FieldCount-1 do
        begin
           sel.insertrows(1);
           sel.font.bold := false;
           sel.typetext (tempTable.Fields.Field[i].Name);
           sel.moveright (1,1);
           sel.font.bold := false;
           sel.typetext (tempTable.Fields.Field[i].FieldType);
           sel.moveright (1,1);
           sel.font.bold := false;
           sel.typetext (inttostr(tempTable.Fields.Field[i].Definition.usFieldLength));
           sel.moveright (1,1);
           sel.font.bold := false;
           if tempTable.Fields.Field[i].NotNull then
             sel.typetext ('Evet')
           else
             sel.typetext ('Hayýr');
           sel.moveright (1,1);
           sel.typetext (tempTable.Fields.Field[i].Description);
           sel.moveright (1,1);
        end;
        rowHeight (0.6);
        sel.movedown (5,1);
        satirEkle(1);
      end;
      if lvDBItems.Items[2].Checked then writePKey(tempTable);
      if lvDBItems.Items[3].Checked then writeIndex(tempTable);
      if lvDBItems.Items[4].Checked then writeTrigger(tempTable);
      sel.InsertBreak (2);
    finally
      tempTable.Free;
    end;
  end;

  procedure WriteTables ;
  var
    tempList:TStringList;
    i:integer;
    tempTable:TDBAdsTable;
  begin
    tempList:=TStringList.Create;
    try
      Dictionary.GetTableNames(tempList);
      if tempList.Count<=0 then exit;

      if lvDBItems.Items[0].Checked then begin
        sel.font.bold := true;
        sel.typetext('TABLOLAR');
        satirEkle(2);
        table := doc.Tables.Add (ww.selection.range,1,2,0,0);

        sel.typetext ('Tablo Adý'); columnwidth (5); sel.moveright (1,1);
        sel.typetext ('Açýklama');columnwidth (20); sel.moveright (1,1);
        sel.insertrows(1);
        for i:=0 to tempList.Count-1 do
        begin
           tempTable:=TDBAdsTable.Create(Dictionary,tempList[i]);
           try
             sel.font.bold := false;
             sel.typetext (tempList[i]);
             sel.moveright (1,1);
             sel.typetext (tempTable.Description);
             sel.moveright (1,1);
             sel.insertrows(1);
           finally
             tempTable.Free;
           end;
        end;
        rowHeight (0.8);
        sel.rows.delete;
        satirekle(2);
        sel.InsertBreak (2);
      end;

      if (lvDBItems.Items[1].Checked) or (lvDBItems.Items[2].Checked) or
         (lvDBItems.Items[3].Checked) or (lvDBItems.Items[4].Checked) then
         for i:=0 to tempList.Count-1 do writeTableColumns ( tempList[i]);

    finally
      tempList.Free;
    end;
  end;

  procedure writeStrProc ;
  var
    tempProc:TAdsProc;
    tempList:TStringList;
    i :integer;
  begin
      tempList:=TStringList.Create;
      try
        Dictionary.GetStoredProcedureNames(tempList);
        if tempList.Count<=0 then exit;
        sel.font.bold := true;
        sel.typetext('PROSEDÜRLER' );
        satirEkle(2);
        table := doc.Tables.Add (ww.selection.range,1,2,0,0);
        sel.typetext ('Prosedür Adý'); columnwidth (7.5); sel.moveright (1,1);
        sel.typetext ('AEP Prosedür Dosyasý'); columnwidth (15); sel.moveright (1,1);

        for i:=0 to tempList.Count-1 do
        begin
          tempProc:=TAdsProc.Create(Dictionary,tempList[i]);
          sel.insertrows(1);
          sel.font.bold := false;
          sel.typetext (tempProc.Name); sel.moveright (1,1);
          sel.typetext (tempProc.GetDLLName); sel.moveright (1,2);
          tempProc.Free;
        end;
      finally
        tempList.Free;
      end;
  end;

  procedure WriteViews ;
  var
    tempList:TStringList;
    i:integer;
    tempView:TAdsView;
  begin
    tempList:=TStringList.Create;
    try
      Dictionary.GetViewNames(tempList);
      if tempList.Count<=0 then exit;
      sel.font.bold := true;
      sel.typetext('GÖRÜNÜMLER');
      satirEkle(2);
      table := doc.Tables.Add (ww.selection.range,1,3,0,0);

      sel.typetext ('Görünüm Adý'); columnwidth (5); sel.moveright (1,1);
      sel.typetext ('SQL Cümlesi'); columnwidth (10); sel.moveright (1,1);
      sel.typetext ('Açýklama');columnwidth (10); sel.moveright (1,1);
      sel.insertrows(1);
      for i:=0 to tempList.Count-1 do
      begin
         tempView:=TAdsView.Create(Dictionary,tempList[i]);
         try
           sel.font.bold := false;
           sel.typetext (tempList[i]);
           sel.moveright (1,1);
           sel.typetext (tempView.GetSTMT);
           sel.moveright (1,1);
           sel.typetext (tempView.GetDescription);
           sel.moveright (1,1);
           sel.insertrows(1);
         finally
           tempView.Free;
         end;
      end;
      rowHeight (0.8);
      sel.rows.delete;
      satirekle(2);
      sel.InsertBreak (2);

    finally
      tempList.Free;
    end;
  end;


  procedure WriteVTLinks ;
  var
    tempList:TStringList;
    i:integer;
    tempLink:TAdsLink;
  begin
    tempList:=TStringList.Create;
    try
      Dictionary.GetDDLinkNames(tempList);
      if tempList.Count<=0 then exit;
      sel.font.bold := true;
      sel.typetext('VERÝ TABANI BAÐLARI');
      satirEkle(2);
      table := doc.Tables.Add (ww.selection.range,1,2,0,0);

      sel.typetext ('VT Baðý Adý'); columnwidth (5); sel.moveright (1,1);
      sel.typetext ('Hedef Veri Sözlüðü'); columnwidth (20); sel.moveright (1,1);
      sel.insertrows(1);
      for i:=0 to tempList.Count-1 do
      begin
         tempLink:=TAdsLink.Create(Dictionary,tempList[i]);
         try
           sel.font.bold := false;
           sel.typetext (tempList[i]);
           sel.moveright (1,1);
           sel.typetext (tempLink.GetLinkPath);
           sel.moveright (1,1);
           sel.insertrows(1);
         finally
           tempLink.Free;
         end;
      end;
      rowHeight (0.8);
      sel.rows.delete;
      satirekle(2);
      sel.InsertBreak (2);

    finally
      tempList.Free;
    end;
  end;

begin
  checkcount := 0;
  for i:= 0 to lvDBItems.Items.Count - 1 do
    if lvDBItems.Items[i].Checked then checkcount := checkcount + 1;
  if checkcount=0 then
    raise Exception.Create('En az bir veri tabaný nesnesi seçmelisiniz.');
  if (rbFile.Checked) and (edFileName.Text ='') then
    raise Exception.Create('Raporun kaydedileceði dosya adýný seçiniz.');
  Screen.Cursor:=crHourGlass;
  try
    ww := CreateOleObject ('Word.Application');
    doc := ww.documents.add;
    doc.pagesetup.orientation := 1;
    ww.Options.CheckSpellingAsYouType := False;
    ww.Options.CheckGrammarAsYouType := False;
    ww.Options.CheckGrammarWithSpelling := False;
    sel := ww.selection;
    sel.font.name := 'Arial';
    sel.font.Size := 10;
    ww.windowstate := 2;
    ww.visible := True;
    writetables;
    if lvDBItems.Items[5].Checked then writeStrProc;
    if lvDBItems.Items[6].Checked then WriteViews;
    if lvDBItems.Items[7].Checked then writeFKey;
    if lvDBItems.Items[8].Checked then WriteVTLinks;
    if rbFile.Checked then begin
      doc.saveas(edFileName.Text);
      doc.close;
      ww.quit;
    end;
  finally
    Screen.Cursor:=crDefault;
  end;
  Close;
end;

procedure TfmReport.FormCreate(Sender: TObject);
  var i: integer;
begin
  for i:= 0 to lvDBItems.Items.Count - 1 do
    lvDBItems.Items[i].Checked := True;
end;

procedure TfmReport.Button1Click(Sender: TObject);
begin
  Report(Dictionary);
end;

procedure TfmReport.rbScreenClick(Sender: TObject);
begin
  edFileName.Text := '';
  edFileName.Enabled := False;
end;

procedure TfmReport.rbFileClick(Sender: TObject);
begin
  edFileName.Enabled := True;
end;

end.
