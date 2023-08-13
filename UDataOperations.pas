unit UDataOperations;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, RzPrgres, RzLabel,Db, Provider, DBClient,Dialogs,
  adsdata,adsfunc,adstable,adscnnct,UDSEditor,jobthrd, ExtCtrls, RzPanel,
  RzRadGrp, ComCtrls;

type
  TDataOpType = (opExport,opImport);
  TFmDataOperations = class(TForm)
    ImpFile: TOpenDialog;
    ExpFile: TSaveDialog;
    pgcMain: TPageControl;
    pgADTVeri: TTabSheet;
    pgIslem: TTabSheet;
    AlanGrup: TRzRadioGroup;
    lbmsg: TRzLabel;
    JobProgBar: TRzProgressBar;
    BtCancel: TButton;
    BtAktar: TButton;
    RzLabel1: TRzLabel;
    lbKaynak: TRzLabel;
    lbHedef: TRzLabel;
    btAdtCancel: TButton;
    procedure BtCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtAktarClick(Sender: TObject);
    procedure btAdtCancelClick(Sender: TObject);
  private
    { Private declarations }
    FoDbUtilThrd: TDbUtilThread;
    baseDS :TDataSet;
    baseconn:TAdsConnection;
    pfilename:string;
    stoppJob:boolean;
    opType:TDataOpType;
  public
    { Public declarations }
    sonucMsg: String;
    function execute:boolean;
    procedure prepare(pbaseDS:TDataSet;conn:TAdsConnection;opType:TDataOpType);
    procedure JobFinished(Sender: TObject);
    function isStopped:boolean;
    procedure startTransaction;
    procedure commit;
    procedure rollback;
 //   procedure txtVeriYukle(pFileName: string);
   // procedure xmlVeriCik(kaynakDS: TDataSet; pFileName: string);
   // procedure xmlVeriYukle(hedefDS: TDataSet; pFileName: string);

  end;

//var
  //FmDataOperations: TFmDataOperations;

implementation
uses UAdvUtils;
{$R *.dfm}


function TFmDataOperations.execute: boolean;
var temp:string;
  opJobKey:TJobType;
begin
  temp:='';
  sonucMsg:='';
  stoppJob:=false;
  pgcMain.ActivePage:=pgIslem;
  Case opType of
    opExport: if ExpFile.Execute then begin
                temp:=Copy(ExpFile.FileName,Length(ExpFile.FileName)-3,4);
                if LowerCase(temp)='.avd' then
                   opJobKey:=jtExpTXT
                else if LowerCase(temp)='.xml' then begin
                   opJobKey:=jtExpXML;
                   JobProgBar.Visible:=false;
                   BtCancel.Visible:=false;
                   lbmsg.Top:=40;
                end else if  LowerCase(temp)='.adt' then begin
                   lbKaynak.Caption:=TAdsTable(baseDS).TableName;
                   pfilename:=GetNameFromFileName(ExpFile.FileName);
                   lbHedef.Caption:=Copy(pfilename,1,Length(pfilename)-4);
                   pgcMain.ActivePage:=pgADTVeri;
                   opJobKey:=jtExpADT;
                end;
                pfilename:=ExpFile.FileName;
              end;
    opImport: if ImpFile.Execute then begin
                temp:=Copy(ImpFile.FileName,Length(ImpFile.FileName)-3,4);
                if LowerCase(temp)='.avd' then  begin
                   opJobKey:=jtImpTXT;
                   JobProgBar.Visible:=false;

                end
                else if LowerCase(temp)='.xml' then
                   opJobKey:=jtImpXML;
                pfilename:=ImpFile.FileName;
              end;
  end;
  if temp='' then
     exit;
  if (opJobKey<>jtExpADT) then begin
    if( baseconn.AliasName <> '' ) then
        FoDbUtilThrd := TDbUtilThread.Create( TAdsTable(baseDS),
                                            baseconn.AliasName,
                                            Self,
                                            opJobKey,pfilename )
     else
        FoDbUtilThrd := TDbUtilThread.Create( TAdsTable(baseDS),
                                            baseconn.ConnectPath,
                                            Self,
                                            opJobKey,pfilename);

    FoDbUtilThrd.OnTerminate := JobFinished;
  end;
  ShowModal;
end;

procedure TFmDataOperations.prepare(pbaseDS: TDataSet;conn:TAdsConnection;
  opType: TDataOpType);
begin
  baseDS:=pbaseDS;
  baseconn:=conn;
  self.opType:=opType;
  baseconn.Name:='baseConn';
  Self.Caption:='Veri Aktarýmlarý';
  if (opType=opExport) then
     lbmsg.Caption:='Veri Çýkýlýyor...'
  else
     lbmsg.Caption:='Veri Yükleniyor...';


end;

procedure TFmDataOperations.BtCancelClick(Sender: TObject);
begin
  FoDbUtilThrd.Terminate;
  stoppJob:=true;

end;

procedure TFmDataOperations.JobFinished(Sender: TObject);
begin
  if stoppJob then begin
    ShowMessage('Ýþlem iptal edildi.')
  end;
  Close;
  //   bJobInProgress := false;
 //  TAdsTable(FAdsDataSet).Open();
  // JobProgBar.PartsComplete := 0;
 //  pnCommnads.Enabled:=true;
 //  pnTableFilters.Enabled:=true;
  // DsSource.Enabled := true;

end;

function TFmDataOperations.isStopped: boolean;
begin
  result:=stoppJob;
end;

procedure TFmDataOperations.startTransaction;
begin
  if (UpperCase(baseconn.ConnectionType)<>'LOCAL') and (UpperCase(baseconn.Username)<>'ADSSYS') then
    baseconn.BeginTransaction;
end;

procedure TFmDataOperations.commit;
begin
  if (UpperCase(baseconn.ConnectionType)<>'LOCAL') and (UpperCase(baseconn.Username)<>'ADSSYS') then
    baseconn.Commit;
end;

procedure TFmDataOperations.rollback;
begin
  if (UpperCase(baseconn.ConnectionType)<>'LOCAL') and (UpperCase(baseconn.Username)<>'ADSSYS') then
    baseconn.Rollback;
end;

procedure TFmDataOperations.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if  sonucMsg<>'' then
    ShowMessage(sonucMsg);
  //Action:=caFree;
  //exit;
end;

procedure TFmDataOperations.BtAktarClick(Sender: TObject);
var
  useFieldName:boolean;
begin
  if AlanGrup.ItemIndex=0 then
     useFieldName:=true
  else
     useFieldName:=false;
  if not TAdsTable(baseDS).Active then
     TAdsTable(baseDS).Active:=true;
  pgcMain.ActivePage:=pgIslem;
  if( baseconn.AliasName <> '' ) then
     FoDbUtilThrd := TDbUtilThread.Create( TAdsTable(baseDS),
                                            baseconn.AliasName,
                                            self,
                                            jtExpADT,
                                            pfilename,
                                            useFieldName)
  else
     FoDbUtilThrd := TDbUtilThread.Create( TAdsTable(baseDS),
                                            baseconn.ConnectPath,
                                            Self,
                                            jtExpADT,
                                            pfilename,
                                            useFieldName);
  FoDbUtilThrd.OnTerminate := JobFinished;


end;

procedure TFmDataOperations.btAdtCancelClick(Sender: TObject);
begin
  close;
end;

end.

