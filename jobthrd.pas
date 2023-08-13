// Copyright (c) 2002 Extended Systems, Inc.  ALL RIGHTS RESERVED.
//
// This source code can be used, modified, or copied by the licensee as long as
// the modifications (or the new binary resulting from a copy or modification of
// this source code) are used with Extended Systems' products. The source code
// is not redistributable as source code, but is redistributable as compiled
// and linked binary code. If the source code is used, modified, or copied by
// the licensee, Extended Systems Inc. reserves the right to receive from the
// licensee, upon request, at no cost to Extended Systems Inc., the modifications.
//
// Extended Systems Inc. does not warrant that the operation of this software
// will meet your requirements or that the operation of the software will be
// uninterrupted, be error free, or that defects in software will be corrected.
// This software is provided "AS IS" without warranty of any kind. The entire
// risk as to the quality and performance of this software is with the purchaser.
// If this software proves defective or inadequate, purchaser assumes the entire
// cost of servicing or repair. No oral or written information or advice given
// by an Extended Systems Inc. representative shall create a warranty or in any
// way increase the scope of this warranty.
unit jobthrd;

interface

uses

{$IFDEF WIN32}
   Windows,
   Forms,
   Dialogs,
   Controls,
   UAdvUtils,
{$ENDIF}

{$IFDEF LINUX}
   QForms,
   QDialogs,
   QControls,
   linutil,
{$ENDIF}

   Classes,
   adstable,
   adsdata,
   ace,
   adsset,
   SysUtils,
   //arc_glbl,
   //arc_utils,
   dbutils,
   RzPrgres,
   Db,
   Provider,
   DBClient;

type

   TJobType = ( jtPackTable,
                jtEmptyTable,
                jtRecall_All,
                jtRepairTable,
                jtCreateIndex,
                jtReIndex,
                jtExpXML,
                jtExpTXT,
                jtImpXML,
                jtImpTXT,
                jtExpADT);

   TDBUtilThread = class( TThread )
   private
      FTable: TAdsTable;
      FRecordCount: LongInt;
      FOwner: TForm;
      FJobType: TJobType;
      FFileName:string;
      FUseFieldName:boolean;
   protected
      procedure Execute; override;
      procedure UpdateStatus;

      procedure PackTable;
      procedure EmptyTable;
      procedure Recall_All;
      procedure RepairTable;
      procedure CreateIndex;
      procedure ReIndex;
      function CheckLastAdsError: Boolean;
      procedure txtVeriCik(kaynakDS: TDataSet;pFileName:string);
      procedure txtVeriYukle(hedef: TDataSet; pFileName: string);
      procedure xmlVeriCik(kaynakDS: TDataSet; pFileName: string);
      procedure Aktar(Hedef, Kaynak: TDataSet;useFieldName:boolean);
      procedure xmlVeriYukle(hedefDS: TDataSet; pFileName: string);
      procedure AdtVeriYukle(KaynakDS: TDataSet; pFileName: string);

   public
      constructor Create( poAdsTable: TAdsTable;
                          strDataBaseName: string;
                          FAnOwner: TForm;
                          JobType: TJobType;
                          fname:string);overload;

      Constructor Create( poAdsTable: TAdsTable;
                          strDataBaseName: string;
                          FAnOwner: TForm;
                          JobType: TJobType;
                          fname:string;
                          useFieldName:boolean );overload;


end;


implementation

uses  UDSEditor,UDataOperations;

Constructor TDbUtilThread.Create( poAdsTable: TAdsTable;
                                  strDataBaseName: string;
                                  FAnOwner: TForm;
                                  JobType: TJobType;
                                  fname:string );
begin
   inherited Create( true );
   FOwner := FAnOwner;
   FJobType := JobType;
   FTable := poAdsTable;
   FFileName:=fName;
   FreeOnTerminate := true;
   if FAnOwner is TFmDSEditor then
     OnTerminate := TFmDSEditor( FOwner ).JobFinished
   else
     OnTerminate := TFmDataOperations( FOwner ).JobFinished;
   Resume();
end;


constructor TDBUtilThread.Create(poAdsTable: TAdsTable;
  strDataBaseName: string; FAnOwner: TForm; JobType: TJobType;
  fname: string; useFieldName: boolean);
begin
  Create( poAdsTable,
          strDataBaseName,
          FAnOwner,
          JobType,
          fname);
  FUseFieldName:=useFieldName;
end;


procedure TDbUtilThread.Execute;
begin
   if( not Terminated ) then
   begin
      FTable.DisableControls;
      try
         Screen.Cursor := crHourGlass;
         case FJobType of
            jtPackTable:   begin
                              PackTable();
                           end;

            jtEmptyTable:  begin
                              EmptyTable();
                           end;

            jtRecall_All:  begin
                              Recall_All();
                           end;

            jtRepairTable:  begin
                               RepairTable();
                            end;

            jtCreateIndex: begin
                              CreateIndex();
                           end;

            jtReIndex:     begin
                              ReIndex();
                           end;

            jtExpTxt:      begin
                             txtVeriCik(FTable,FFileName);
                           end;
            jtImpTxt:      begin
                             txtVeriYukle(FTable,FFileName);
                           end;
            jtExpXML:      begin
                             xmlVeriCik(FTable,FFileName);
                           end;
            jtImpXML:      begin
                             xmlVeriYukle(FTable,FFileName);
                           end;
            jtExpADT:      begin
                             AdtVeriYukle(FTable,FFileName);
                           end;

         end;//case
      finally
         FTable.EnableControls;
         Screen.Cursor := crDefault;
      end;

   end;//if not terminated
end;

procedure TDBUtilThread.PackTable;
var
   bSavedExclusive : boolean;
begin
   bSavedExclusive := FTable.Exclusive;
   FTable.Exclusive := true;
   try
      try
         FTable.Open();
         FTable.AdsPackTable();
      except
         ON E : Exception do
         begin
            MessageBox( PChar( E.Message + '.' + #13 + #13 +
                                    'Tablo özel modda açýlýrken (exclusively) hata.' + #13 +
                                    'Veri tabaný: ' + FTable.DatabaseName + #13 +
                                    'Tablo Adý: ' + FTable.TableName ),
                                    'Hata:',
                                     MB_OK );
            exit;
         end;
      end;//try
   finally
      FTable.Close();
      FTable.Exclusive := bSavedExclusive;
   end;
end;


procedure TDBUtilThread.EmptyTable;
var
   bSavedExclusive : boolean;
begin
   bSavedExclusive := FTable.Exclusive;
   FTable.Exclusive := true;
   try
      try
         FTable.Open();
         FTable.AdsZapTable();
      except
         On E: Exception do
         begin
            //clear the progress bar
            MessageBox( PChar( E.Message + '.' + #13 + #13 +
                                    'Tablo özel modda açýlýrken (exclusively) hata.' + #13 +
                                    'Veritabaný: ' + FTable.DatabaseName + #13 +
                                    'Tablo Adý: ' + FTable.TableName ),
                                    'Hata:',
                                     MB_OK );
            exit;
         end;
      end;//try
   finally
      FTable.Close();
      FTable.Exclusive := bSavedExclusive;
   end;
end;


procedure TDBUtilThread.Recall_All;
var
   strMessage: string;
begin
   try
      FTable.Open();

      //Getting record count for status bar.
      if FTable.ActiveHandle = FTable.Handle then
         FRecordCount := FTable.AdsGetRecordCount()
      else
         FRecordCount := FTable.AdsGetKeyCount;

      FTable.First();
      while( not FTable.EOF ) and
           ( not Suspended ) and
           ( not Terminated )  do
      begin
         try
            FTable.AdsRecallRecord;
         except
            On E: Exception do
            begin
               if FTable.AdsGetLastError( strMessage ) = 5035 then
               begin
                  MessageDlg( 'Kayýt ' + IntToStr( FTable.AdsGetRecordNum() ) +
                              'yeniden alýnamýyor,baþka bir kullanýcý tarafýndan kilitlenmiþ.',
                              mtInformation,
                              [ mbOK ],
                              0 );
               end
               else
                  raise;
            end;
         end;//try

         FTable.Next();
         Synchronize( UpdateStatus );
      end;
   finally
      FTable.Close();
   end;
end;




//change this to repair entire database.  That would include deleted byte, copyto, reindex.
procedure TDBUtilThread.RepairTable;
begin
   try
      FTable.Open();

      //Getting record count for status bar.
      if FTable.ActiveHandle = FTable.Handle then
         FRecordCount := FTable.AdsGetRecordCount()
      else
         FRecordCount := FTable.AdsGetKeyCount;

      FTable.First();
      while( not FTable.EOF ) and
           ( not Suspended ) and
           ( not Terminated )  do
      begin
         if FTable.AdsIsRecordDeleted( 0 ) then
            FTable.AdsDeleteRecord()
         else
            FTable.AdsRecallRecord();

         FTable.AdsSkip( 1 );

   //      Synchronize( UpdateStatus );
      end;
   finally
      FTable.Close();
   end;
end;


procedure TDBUtilThread.CreateIndex;
begin
end;


procedure TDBUtilThread.ReIndex;
var
   bSavedExclusive : boolean;
begin
   bSavedExclusive := FTable.Exclusive;
   FTable.Exclusive := true;
   try
      try
         FTable.Open();
         FTable.AdsReIndex();
      except
         On E: Exception do
         begin
            MessageBox( PChar( E.Message + '.' + #13 + #13 +
                                    'Tablo özel modda açýlýrken (exclusively) hata.' + #13 +
                                    'Veritabaný: ' + FTable.DatabaseName + #13 +
                                    'Tablo Adý: ' + FTable.TableName ),
                                    'Hata:',
                                     MB_OK );
            exit;
         end;
      end;//try
   finally
      FTable.Close();
      FTable.Exclusive := bSavedExclusive;
   end;
end;


procedure TDbUtilThread.UpdateStatus;
begin
   if Assigned(  FOwner  ) then
   begin
     if FOwner is TFmDSEditor then begin
       if TFmDSEditor( FOwner ).JobProgBar.TotalParts <> FRecordCount then
          TFmDSEditor( FOwner ).JobProgBar.TotalParts := FRecordCount;
       TFmDSEditor( FOwner ).JobProgBar.IncPartsByOne;
     end else if  FOwner is TFmDataOperations then begin
        if TFmDataOperations(FOwner).isStopped then
          exit;
       if TFmDataOperations( FOwner ).JobProgBar.TotalParts <> FRecordCount then
          TFmDataOperations( FOwner ).JobProgBar.TotalParts := FRecordCount;
       TFmDataOperations( FOwner ).JobProgBar.IncPartsByOne;
     end ;
   end;
end;


function TDBUtilThread.CheckLastAdsError: Boolean;
var
  ErrorCode : UNSIGNED32;
  ErrBuff : array[ 0..ADS_MAX_ERROR_LEN ] of char;
  Len: UNSIGNED16;
begin
  ACE.AdsGetLastError(@ErrorCode, @ErrBuff, @Len);
  Result := (ErrorCode = AE_SUCCESS) or (ErrorCode = AE_PROPERTY_NOT_SET);
end;

procedure TDBUtilThread.txtVeriCik(kaynakDS:TDataSet;pFileName:string);
var
  ExpF:TextFile;
  i:integer;
  temp:string;
begin
   AssignFile(ExpF,pFileName);
   try
      Rewrite(ExpF);
      temp:='';
      //Getting record count for status bar.
      if FTable.ActiveHandle = FTable.Handle then
         FRecordCount := FTable.AdsGetRecordCount()
      else
         FRecordCount := FTable.AdsGetKeyCount;
      for i:=0 to kaynakDS.FieldCount-1 do
      if not (kaynakDS.Fields.Fields[i].DataType in [ftMemo,ftBlob,ftAutoInc]) then
      begin
        if i=0 then
          temp:= kaynakDS.Fields.Fields[i].FieldName
        else
          temp:=temp+','+kaynakDS.Fields.Fields[i].FieldName;
      end;
      Writeln(ExpF,temp);
      kaynakDS.First;
      temp:='';
      While not kaynakDS.Eof do begin
        if TFmDataOperations(FOwner).isStopped then begin
           Exit;
        end;

        for  i:=0 to kaynakDS.FieldCount-1 do
        if not(kaynakDS.Fields[i].DataType in [ftMemo,ftBlob,ftAutoInc]) then
        begin
          if i=0 then
            temp:=SQLString(kaynakDS.Fields[i].AsString,TAdsTable(kaynakDS).AdsGetFieldType(kaynakDS.Fields[i].FieldName))
          else
            temp:=temp+'|'+SQLString(kaynakDS.Fields[i].AsString,TAdsTable(kaynakDS).AdsGetFieldType(kaynakDS.Fields[i].FieldName));
        end;
        Writeln(ExpF,temp);
        kaynakDS.Next;
        Synchronize( UpdateStatus );
      end;
   finally
      CloseFile(ExpF);
      kaynakDS.First;
   end;
end;

procedure  TDBUtilThread.txtVeriYukle(hedef : TDataSet;pFileName:string);
var
  FImp:TextFile;
  i:integer;
  temp,pSQL:string;
  adsSql:TAdsQuery;
  recCount:Longint;
begin
  temp:='';
  AssignFile(FImp,pFileName);
  adsSql:=TAdsQuery.Create(nil);
  try  try
      adsSql.DatabaseName:=TAdsTable(hedef).AdsConnection.Name;
      Reset(FImp);
      Readln(FImp,temp);
      recCount:=0;
      pSQL:='Insert Into '+TAdsTable(hedef).TableName+' ( '+temp+') VALUES (';
      TFmDataOperations(FOwner).startTransaction;
      while not Eof(FImp) do begin
        if TFmDataOperations(FOwner).isStopped then begin
           TFmDataOperations(FOwner).rollback;
           Exit;
        end;
        Readln(FImp,temp);
        temp:=StringReplace(temp,'|',',',[rfReplaceAll]);
        temp:=pSQL+temp+');';
        if adsSql.Active then adsSql.Close;
        adsSql.SQL.Text:=temp;
        adsSql.ExecSQL;
        recCount:=recCount+1;
      end;
      TFmDataOperations(FOwner).commit;
      TAdsTable(hedef).Close;
      TAdsTable(hedef).Open;
    except
      ON E : Exception do begin
         TFmDataOperations(FOwner).sonucMsg:='Hata:'+E.Message+' Ýþlem iptal edildi.';
         TFmDataOperations(FOwner).rollback;
         exit;
      end;
    end;
  finally
      CloseFile(FImp);
      adsSql.Free;
  end;
end;

procedure TDBUtilThread.xmlVeriCik(kaynakDS:TDataSet;pFileName:string);
var
  dataProvider :TDataSetProvider;
  hedefDS :TClientDataSet;
  ExpF:TextFile;
begin
  dataProvider:=TDataSetProvider.Create(nil);
  hedefDS:=TClientDataSet.Create(nil);
  AssignFile(ExpF,pFileName);
  try
    dataProvider.DataSet:=kaynakDS;
    hedefDS.SetProvider(dataProvider);
    hedefDS.Active:=true;
    Rewrite(ExpF);
    Writeln(Expf,hedefDS.XMLData);
    hedefDS.Active:=false;
  finally
    CloseFile(ExpF);
    hedefDS.Free;
    dataProvider.Free;
  end;
end;

procedure TDBUtilThread.xmlVeriYukle(hedefDS:TDataSet;pFileName:string);
var
  kaynakDS :TClientDataSet;
begin
  kaynakDS:=TClientDataSet.Create(nil);
  try
    kaynakDS.Active:=false;
    kaynakDS.LoadFromFile(pFileName);
    kaynakDS.Active:=true;
    Aktar(hedefDS,kaynakDS,false);
  finally
    kaynakDS.Free;
  end;
end;

procedure TDBUtilThread.Aktar(Hedef, Kaynak: TDataSet; useFieldName:boolean);
var I, baseFldCount: Integer;
begin
  FRecordCount:=Kaynak.RecordCount;
  TFmDataOperations(FOwner).startTransaction;
  if Kaynak.FieldCount<=Hedef.FieldCount then
     baseFldCount:=Kaynak.FieldCount
  else
     baseFldCount:=Hedef.FieldCount;
  Kaynak.First;   
  while not Kaynak.EOF do try
    if TFmDataOperations(FOwner).isStopped then begin
       Terminate;
       TFmDataOperations(FOwner).Rollback;
       Exit;
    end;
    Hedef.Insert;
    for I := 0 to baseFldCount - 1 do
    if not useFieldName then  begin
      if Kaynak.Fields[i].IsBlob then
        TBlobField(Hedef.Fields[i]).Assign(Kaynak.Fields[i])
      else
        Hedef.Fields[i].AsString := Kaynak.Fields[i].AsString;
    end else begin
      if Kaynak.FieldByName(Kaynak.Fields[i].FieldName).IsBlob then
        TBlobField(Hedef.FieldByName(Kaynak.Fields[i].FieldName)).Assign(Kaynak.FieldByName(Kaynak.Fields[i].FieldName))
      else
        Hedef.FieldByName(Kaynak.Fields[i].FieldName).AsString := Kaynak.FieldByName(Kaynak.Fields[i].FieldName).AsString;
    end;
    Synchronize( UpdateStatus );
    Kaynak.Next;
    Hedef.Post;
  Except
     on E:Exception  do begin
        TFmDataOperations(FOwner).sonucMsg:='Dosya aktarýlamadý.Hata:'+E.Message;
        TFmDataOperations(FOwner).Rollback;
        exit;
     end;
  end;
  TFmDataOperations(FOwner).commit;

end;

procedure TDBUtilThread.AdtVeriYukle(KaynakDS: TDataSet; pFileName: string);
var
  hedefTb:TAdsTable;
begin
  hedefTb:=TAdsTable.Create(nil);
  try
    hedefTb.AdsConnection:=TAdsTable(KaynakDS).AdsConnection;
    FFileName:=GetNameFromFileName(FFileName);
    hedefTb.TableName:=Copy(FFileName,1,Length(FFileName)-4);
    hedefTb.Open;
    Aktar(hedefTb,KaynakDS,FUseFieldName);
  finally
    hedefTb.Free;
  end;
end;

end.

