program AdvExp;

uses
	Forms,
	SysUtils,
	UMain in 'UMain.pas' {FmMain},
	UDbItems in 'UDbItems.pas',
	UAdvConst in '..\Lib\UADVCONST.PAS',
	UAdvGlobals in '..\Lib\UAdvGlobals.pas',
	UAdvMsgs in '..\Lib\UAdvMsgs.pas',
	UAdvTypes in '..\Lib\UAdvTypes.pas',
	UDBCon in 'UDBCon.pas' {FmConnDb},
	UObjEdit in 'UObjEdit.pas' {FmDBObjectEditor},
	UUser in 'UUser.pas' {FmUser},
	UAdsObj in 'UAdsObj.pas',
	UObjRights in 'UObjRights.pas' {FmObjectRights},
	UGroup in 'UGroup.pas' {FmGroup},
	UDbOperation in 'UDbOperation.pas' {FmDBOperation},
  UDBSQL in 'UDBSQL.pas' {FmSQL},
  UDSEditor in 'UDSEditor.pas' {FmDSEditor},
  UAdsErr in 'UAdsErr.pas' {FmAdsError},
  UAdsErrObj in 'UAdsErrObj.pas',
  UAdsUser in 'UAdsUser.pas',
  UAdsGroup in 'UAdsGroup.pas',
  UAdsTable in 'UAdsTable.pas',
  UAdsProc in 'UAdsProc.pas',
  UAdsView in 'UAdsView.pas',
  UAdsRef in 'UAdsRef.pas',
  UTable in 'UTable.pas' {FmTable},
  URef in 'URef.pas' {FmRef},
  UTableDesign in 'UTableDesign.pas' {FmTableDesign},
  UView in 'UView.pas' {FmView},
  UAdsLink in 'UAdsLink.pas',
	ULink in 'ULink.pas' {FmLink},
	UFieldRights in 'UFieldRights.pas' {FmFieldRights},
  UDatabase in 'UDatabase.pas' {FmDataBase},
  UProc in 'UProc.pas' {FmProc},
  UPasswordDlg in 'UPasswordDlg.pas' {FmPasswordDlg},
  UDbDelete in 'UDbDelete.pas' {fmDbDelete},
  Ualias in 'Ualias.pas' {FmAlias},
  Uabout in 'Uabout.pas' {AboutBox},
	UADVUTILS in '..\LIB\UADVUTILS.PAS',
  UBlob in 'UBlob.pas' {fmBlob},
  UActiveXList in 'UActiveXList.pas' {fmActiveXList},
  mgtscrn in 'mgtscrn.pas' {MgtForm},
  jobthrd in 'jobthrd.pas',
  UMigTool in 'UMigTool.pas' {fmMigTool},
  UDataOperations in 'UDataOperations.pas' {FmDataOperations},
  UMessage in 'UMessage.pas' {fmMessage},
  UCheckVersion in 'UCheckVersion.pas' {fmCheckVersion},
  UAdvertise in 'UAdvertise.pas' {FmAdvertise},
  UPerformans in 'UPerformans.pas' {FmPerformans},
  UPerfResult in 'UPerfResult.pas' {FmPerfResults},
  UReport in 'UReport.pas' {fmReport},
  USqlOptions in 'USQLOPTIONS.PAS' {FmSQLOptions},
  UOptions in 'UOPTIONS.PAS' {FmOptions},
  URemoveTables in 'UREMOVETABLES.PAS' {FmRemoveTables},
  UFmTableName in 'UFmTableName.pas' {FmGetTableName},
  clsFileType in 'clsFileType.pas',
  UFmConnectPath in 'UFmConnectPath.pas' {FmGetConnectPath},
  UTableInfs in 'UTableInfs.pas' {FmTables},
  UAutoInc in 'UAutoInc.pas' {FmAutoInc},
  UDSParams in 'UDSParams.pas' {FmQueryParams},
  UDBSelect in 'UDBSelect.pas' {FmDBSelect},
  dlgSearchText in 'dlgSearchText.pas' {TextSearchDialog},
	dlgConfirmReplace in 'dlgConfirmReplace.pas' {ConfirmReplaceDialog},
	dlgReplaceText in 'dlgReplaceText.pas' {TextReplaceDialog},
	UFmExportCode in 'UFmExportCode.pas' {FmExportCode},
	UUtils in 'UUtils.pas',
	UExportCode in 'UExportCode.pas',
	UDelphiExporter in 'UDelphiExporter.pas',
	USQLExporter in 'USQLExporter.pas',
	UCodeExplorer in 'UCodeExplorer.pas' {FmCodeExplorer},
	UFmDataExport in 'UFmDataExport.pas' {FmDataExport},
	UFmDBTree in 'UFmDBTree.pas' {FmDBTree};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Advantage Türkiye Veri Tabaný Yöneticisi';
  Application.HelpFile :='AdsTrHelp.hlp';
  Application.CreateForm(TFmMain, FmMain);
  FmMain.CheckAutoVersion;
  try
    FmMain.CheckCmdLine;
  except
  end;  
  Application.Run;
end.
