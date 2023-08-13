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
{*******************************************************************************
* Source File : MgtScrn.PAS
* Date Created: 11/25/97
* Description : This is the main screen for the management utility
* Notes       :
*******************************************************************************}
unit mgtscrn;

interface

uses

{$IFDEF WIN32}
   Windows,
   Messages,
   Graphics,
   Controls,
   Forms,
   Dialogs,
   StdCtrls,
   Buttons,
   ExtCtrls,
   Menus,
   ComCtrls,
   Grids,
   //WinUtils,
{$ENDIF}

{$IFDEF LINUX}
   QGraphics,
   QControls,
   QForms,
   QDialogs,
   QStdCtrls,
   QButtons,
   QExtCtrls,
   QMenus,
   QComCtrls,
   QGrids,
   QTypes,
   linutil,
{$ENDIF}

   SysUtils,
   Classes,
   ace,
   //drmreg,
   adsset, XStringGrid, RzCommon, RzSelDir;

const
   HIT_RETURN = #13;
   ADS_MAX_SERVER = 50;
   // Constant for length of the error string
   ERROR_STRING_LEN = 255;

   // Constant for the server returned error FILE_NOT_FOUND
   FILE_NOT_FOUND = 7051;

type
   // The enumeration type for the connected server
   TServerType = ( stNone, stNT, stNetWare, stLocal, stWin9x, stUnknown );

   // The object definition for the container class that will hold
   // the full file path which is not what is shown when the path
   // is larger than 50 chars in most grids.  These objects are
   // instantiated and stored in the object member of the grid cells.
   TServerFilePath = class(TObject)
   protected
      mstrFullPath : String;
   public
      constructor Create( strPath : String );
      property Path : String  read mstrFullPath write mstrFullPath;
   end;

   // The main form class.  This contains all of the graphical and other
   // components needed for the main form.
   TMgtForm = class(TForm)
      // These are the generic panels that just allow graphic display of
      // grouping things together
      Panel2:  TPanel;
      Panel4:  TPanel;
      Panel8:  TPanel;
      Panel9:  TPanel;
      Panel10: TPanel;
      Panel12: TPanel;
      Panel13: TPanel;
      Panel14: TPanel;

      // These are the generic labels that just allow descriptive words to be
      // put on the screen for definition of displayed values
      Label1:  TLabel;
      Label2:  TLabel;
      Label3:  TLabel;
      Label4:  TLabel;
      Label5:  TLabel;
      Label7:  TLabel;
      Label8:  TLabel;
      Label9:  TLabel;
      Label10: TLabel;
      Label11: TLabel;
      Label12: TLabel;
      Label13: TLabel;
      Label14: TLabel;
      Label15: TLabel;
      Label16: TLabel;
      Label17: TLabel;
      Label19: TLabel;
      Label23: TLabel;
      Label27: TLabel;
      Label28: TLabel;
      Label29: TLabel;
      Label30: TLabel;
      Label31: TLabel;
      Label32: TLabel;
      Label33: TLabel;
      Label34: TLabel;
      Label35: TLabel;
      Label36: TLabel;
      Label37: TLabel;
      Label38: TLabel;
      Label39: TLabel;
      Label40: TLabel;
      Label41: TLabel;
      Label42: TLabel;
      sbConnectServer: TSpeedButton;

      // TabSheets that are contained within the page control of the main form
      poMainPage:  TPageControl;
      DataInfo:    TTabSheet;
      InstallInfo: TTabSheet;
      ConnUsers:   TTabSheet;
      OpenFiles:   TTabSheet;
      ConfigParam: TTabSheet;
      CommStat:    TTabSheet;
      AffectMem:   TTabSheet;
      NotAffectMem: TTabSheet;

      // members associated to the Installation Information tab
      poRegTo:      TPanel;
      poSerialNum:  TPanel;
      poUserOpt:    TPanel;
      poADSRev:     TPanel;
      poInitDate:   TPanel;
      poEvalDate:   TPanel;
      poLogEntries: TPanel;
      poANSISet:    TPanel;
      poOEMSet:     TPanel;

      // members associated to the Open Files tab
      poRgOpenFileType:  TRadioGroup;
      poStrGrdOpenFiles: TStringGrid;
      poStrGrdUserFile:  TStringGrid;

      // members associated to the Configuration Parameters tab
      poConfigPageCtl:   TPageControl;
      poNumWorkThread:   TPanel;
      poNumDataLocks:    TPanel;
      poNumIndexes:      TPanel;
      poNumTables:       TPanel;
      poNumWork:         TPanel;
      poNumConn:         TPanel;
      poMemNumConn:      TPanel;
      poMemNumWork:      TPanel;
      poMemNumTables:    TPanel;
      poMemNumIndexes:   TPanel;
      poMemNumDataLocks: TPanel;
      poMemNumWorkThead: TPanel;
      poTranLogFile:     TPanel;
      poSemFilePath:     TPanel;
      poLogPath:         TPanel;
      poSizeErrorLog:    TPanel;
      poTotalMemUsed:    TPanel;
      poIPRecv:          TPanel;

      // members associated to the Communication Statistics tab
      poTotalPacketRcv:  TPanel;
      poCheckSum:        TPanel;
      poPacketOutSeq:    TPanel;
      poReqOutSeq:       TPanel;
      poOwnerNotLog:     TPanel;
      poServerInitDiscon: TPanel;
      poRemovePartCon:   TPanel;
      poInvalidPacket:   TPanel;
      poRecvError:       TPanel;
      poSendError:       TPanel;
      poPercentError:    TPanel;
      mbResetStat:       TButton;

      // members associated to the Server connect section
      StatusBar1:        TStatusBar;
      poServerPanel:     TPanel;
      cbServer:          TComboBox;
      lbConnectedServerType: TLabel;
      imgConnectedServer: TImage;
    Timer1: TTimer;
    pmDisconUser: TPopupMenu;
    DisconUser: TMenuItem;
    Panel1: TPanel;
    poStrGrdConUser: TStringGrid;
    Panel3: TPanel;
    poStrGrdOpenLck: TStringGrid;
    Panel5: TPanel;
    poRgUserOpenType: TRadioGroup;
    Panel6: TPanel;
    poStrGrdOpenData: TStringGrid;
    Label6: TLabel;
    poInternetPort: TPanel;
    poDInfoGrid: TXStringGrid;
    EditCellEditor1: TEditCellEditor;

      // The following are methods that happen in response to an event.
      procedure Exit1Click(Sender: TObject);
      procedure FormCreate(Sender: TObject);
      procedure DatabaseInformation2Click(Sender: TObject);
      procedure InstallationInformation1Click(Sender: TObject);
      procedure ConnectedUsers1Click(Sender: TObject);
      procedure OpenFiles1Click(Sender: TObject);
      procedure ConfigurationParameters1Click(Sender: TObject);
      procedure CommStat1Click(Sender: TObject);
      procedure FormDestroy(Sender: TObject);
      procedure FormKeyDown(Sender: TObject; var Key: Word;
        Shift: TShiftState);
      procedure sbConnectServerClick(Sender: TObject);
      procedure RefreshCurrentViewClick(Sender: TObject);
      procedure cbServerKeyPress(Sender: TObject; var Key: Char);
      procedure Timer1Timer(Sender: TObject);
      procedure ResetStatClick(Sender: TObject);
      procedure MainPageChange(Sender: TObject);
      procedure RgUserOpenTypeClick(Sender: TObject);
      procedure RgOpenFileTypeClick(Sender: TObject);
      procedure ServerBoxChange(Sender: TObject);
      procedure HelpClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbServerClick(Sender: TObject);
    procedure DisconUserClick(Sender: TObject);
    procedure pmDisconUserPopup(Sender: TObject);
    procedure poStrGrdConUserMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
   private
      bServerBoxChanged : Boolean;
      aucServerName : array[0..ADS_MAX_SERVER - 1] of char;
      mhConnect : ADSHANDLE;
      meServerType : TServerType;
      musDifference : UNSIGNED16;
      procedure CloseAllDialogs;
      procedure RefreshAllUpdateableViews;
      procedure ClearAll( poCurControl : TWinControl );
      procedure RefreshTabDBView( pstActiveInfo : pADS_MGMT_ACTIVITY_INFO );
      procedure RefreshTabCommView;
      procedure RefreshTabConfigView;
      procedure RefreshTabInstallView;
      procedure RefreshTabConnectView;
      procedure RefreshTabOpenFilesView;
      procedure RefreshIndexAndLocks;
      function  ValidateConnectionString( strConnect : String ) : UNSIGNED16;
      procedure DoDisconnect;
      procedure AddServerToReg( strServer : string );
      procedure PopulateServerList;
      procedure InitializeHelp;
   public
     { Public declarations }
      procedure RefreshView( strView : String );
      procedure RefreshConnUsers( poGrid : TStringGrid; strFileName : String;
         bMakeEmpty : Boolean );
      procedure RefreshConnUserTables( poGrid : TStringGrid;
         usConnectNum : UNSIGNED16; strUser : String );
      procedure RefreshConnUserIndexes( poGrid : TStringGrid;
         usConnectNum : UNSIGNED16; strTable, strUser : String );
      procedure RefreshConnUserLocks( poGrid : TStringGrid;
         usConnectNum : UNSIGNED16; strUser, strTable : String );
   end;

function MgtCheck( ulRetCode : UNSIGNED32 ): UNSIGNED32;

implementation

uses

   Math, UADVUTILS, UOptions;
   //main;

{$R *.dfm}

{**********************************************************
*  Module:  MgtCheck
*  Date Created:  11/25/97
*  Last Modified:
*  Input:  ulRetCode - error code
*  Output:
*  Return:
*  Description: This is a global error handler for
*  Advantage Client Engine calls that are called repeatedly
*  through the refresh event.
**********************************************************}
function MgtCheck( ulRetCode : UNSIGNED32 ): UNSIGNED32;
var
   acErrorString : array[0..ERROR_STRING_LEN] of Char;
   usErrStringSize : UNSIGNED16;
begin
   if ( ( ulRetCode = AE_SUCCESS ) Or ( ulRetCode = AE_FILE_NOT_FOUND ) Or
        ( ulRetCode = FILE_NOT_FOUND ) )then
   begin
      Result := ulRetCode;
      exit;
   end;

   //  If the error is an Advantage Client Engine error
   usErrStringSize := ERROR_STRING_LEN;
   ACE.AdsGetLastError( @ulRetCode, @acErrorString, @usErrStringSize );

   // unresolved jmu
   //MainForm.DoDisconnect;

   raise Exception.Create( acErrorString );
end;

{**********************************************************
*  Module:  TServerFilePath.Create
*  Date Created:  11/25/97
*  Last Modified:
*  Input:  strPath - Storage for the full path of the file
*  Output:
*  Return:
*  Description: There is a 50 character limitation as to what
*  the file path can be displayed.  We need therefore to
*  create an object and associate it to the string grid to
*  allow for the full path to be made availiable.
**********************************************************}
constructor TServerFilePath.Create( strPath : String );
begin
   inherited Create;
   mstrFullPath := strPath;
end;

{**********************************************************
*  Module:  TMainForm.Exit1Click
*  Date Created:  11/25/97
*  Last Modified:
*  Input:  Sender - The Object that called the event
*  Output:
*  Return:
*  Description: When the exit menu item is selected this fuction
*  will get fired.
**********************************************************}
procedure TMgtForm.Exit1Click(Sender: TObject);
begin
   Close;
end;



{**********************************************************
*  Module:  TMainForm.FormCreate
*  Date Created:  11/25/97
*  Last Modified:
*  Input:  Sender - The Object that called the event
*  Output:
*  Return:
*  Description: This method will be called when the form is
*  first created and will set up the grids with correct
*  captions and initialization.
**********************************************************}
procedure TMgtForm.FormCreate(Sender: TObject);
begin

   {*
    * Set the proper number of pixels per inch, this is different on Windows
    * and Linux.
    *}
   self.PixelsPerInch := Screen.PixelsPerInch;

{$IFDEF WIN32}
   self.BorderStyle := bsSingle;

{$ELSE}
   self.BorderStyle := fbsSingle;
   {* Set 2 radio item indexes that don't get set by default like they
    * do in windoze. *}
   poRgUserOpenType.ItemIndex := 0;
   poRgOpenFileType.ItemIndex := 0;
{$ENDIF}

   InitializeHelp;

   {*
    * We need to manually set the dimensions. Because we don't store the
    * borderstyle in the dfm, Delphi makes some assumptions about the
    * height and width of the form when it is streaming the properties in.
    * It ends up modifying the form to fit nicely in the main form. That's
    * not what we want (becuase it will usually end up too big). We want a
    * fixed size, so we need to set the dimensions back after
    * delphi/kylix has loaded the form from disk.
    *}
   height := 447;
   width := 538;

   // Save the Difference of the height and client height to get a
   // resolution difference.
   musDifference := Self.Height - Self.ClientHeight;

   // initialize the connection
   mhConnect := 0;
   meServerType := stNone;
   bServerBoxChanged := True;

   Top := 5;
   Left := 5;

   // setup status bar
   StatusBar1.Panels[0].Width := floor( StatusBar1.Width * 0.18 );
   StatusBar1.Panels[1].Width := floor( StatusBar1.Width * 0.46 );
   StatusBar1.Panels[2].Width := floor( StatusBar1.Width * 0.18 );
   StatusBar1.Panels[3].Width := floor( StatusBar1.Width * 0.11 );

   // setup info grid headings and sizes
   poDInfoGrid.ColWidths[0] := floor( poDInfoGrid.Width * 0.268 );
   poDInfoGrid.ColWidths[1] := floor( poDInfoGrid.Width * 0.18 );
   poDInfoGrid.ColWidths[2] := floor( poDInfoGrid.Width * 0.18 );
   poDInfoGrid.ColWidths[3] := floor( poDInfoGrid.Width * 0.18 );
   poDInfoGrid.ColWidths[4] := floor( poDInfoGrid.Width * 0.18 );
   poDInfoGrid.RowHeights[0] := floor( poDInfoGrid.Height * 0.12 );
   poDInfoGrid.RowHeights[1] := floor( poDInfoGrid.Height * 0.12 );
   poDInfoGrid.RowHeights[2] := floor( poDInfoGrid.Height * 0.12 );
   poDInfoGrid.RowHeights[3] := floor( poDInfoGrid.Height * 0.12 );
   poDInfoGrid.RowHeights[4] := floor( poDInfoGrid.Height * 0.12 );
   poDInfoGrid.RowHeights[5] := floor( poDInfoGrid.Height * 0.12 );
   poDInfoGrid.RowHeights[6] := floor( poDInfoGrid.Height * 0.12 );
   poDInfoGrid.RowHeights[7] := floor( poDInfoGrid.Height * 0.12 );
   poDInfoGrid.Cells[0,1] := 'Kullanýcýlar';
   poDInfoGrid.Cells[0,2] := 'Baðlantýlar';
   poDInfoGrid.Cells[0,3] := 'Çalýþma Alanlarý';
   poDInfoGrid.Cells[0,4] := 'Tablolar';
   poDInfoGrid.Cells[0,5] := 'Ýndeks Dosyalarý';
   poDInfoGrid.Cells[0,6] := 'Kilitler';
   poDInfoGrid.Cells[0,7] := 'Çalýþan Çoklu Ýþletimler';
   poDInfoGrid.Cells[1,0] := 'Aktif';
   poDInfoGrid.Cells[2,0] := 'Maks.Kullaným';
   poDInfoGrid.Cells[3,0] := 'Konfigüre Edilen';
   poDInfoGrid.Cells[4,0] := 'Geri Çevrilen';

   // setup the Connected user grids headings
   poStrGrdConUser.ColWidths[0] := floor( poStrGrdConUser.Width * 0.14 );
   poStrGrdConUser.ColWidths[1] := floor( poStrGrdConUser.Width * 0.25 );
   poStrGrdConUser.ColWidths[2] := floor( poStrGrdConUser.Width * 0.25 );
   poStrGrdConUser.ColWidths[3] := floor( poStrGrdConUser.Width * 0.36 );
   poStrGrdConUser.Cells[0,0] := 'Cnct #';
   poStrGrdConUser.Cells[1,0] := 'Baðlantý Adý';
   poStrGrdConUser.Cells[2,0] := 'Veritabaný Kullanýcýsý Adý';
   poStrGrdConUser.Cells[3,0] := 'Að Adresi';

   poStrGrdOpenData.ColWidths[0] := floor( poStrGrdOpenData.Width * 0.08 );
   poStrGrdOpenData.ColWidths[1] := floor( poStrGrdOpenData.Width * 0.91 );
   poStrGrdOpenData.Cells[0,0] := 'Kilit';
   poStrGrdOpenData.Cells[1,0] := 'Açýk Dosyalar';

   poStrGrdOpenLck.ColWidths[0] := poStrGrdOpenLck.Width - 4;
   poStrGrdOpenLck.Cells[0,0] := 'Açýk Tablo Kilitleri';

   // setup the Open files grids headings
   poStrGrdOpenFiles.ColWidths[0] := floor( poStrGrdOpenFiles.Width * 0.08 );
   poStrGrdOpenFiles.ColWidths[1] := floor( poStrGrdOpenFiles.Width * 0.91 );
   poStrGrdOpenFiles.Cells[0,0] := 'Kilit';
   poStrGrdOpenFiles.Cells[1,0] := 'Açýk Dosyalar';

   poStrGrdUserFile.ColWidths[0] := floor( poStrGrdUserFile.Width * 0.08 );
   poStrGrdUserFile.ColWidths[1] := floor( poStrGrdUserFile.Width * 0.91 );
   poStrGrdUserFile.Cells[0,0] := '#';
   poStrGrdUserFile.Cells[1,0] := 'Dosya Açan Kullanýcýlar';

   // Populate the server list
   PopulateServerList;

end;

{**********************************************************
*  Module:  TMainForm.DatabaseInformation2Click
*  Date Created:  11/25/97
*  Last Modified:
*  Input:  Sender - The Object that called the event
*  Output:
*  Return:
*  Description: This method will be called when the menu
*  item DatabaseInformation is selected.
**********************************************************}
procedure TMgtForm.DatabaseInformation2Click(Sender: TObject);
begin
      poMainPage.ActivePage :=  DataInfo;
end;

{**********************************************************
*  Module:  TMainForm.InstallationInformation1Click
*  Date Created:  11/25/97
*  Last Modified:
*  Input:  Sender - The Object that called the event
*  Output:
*  Return:
*  Description: This method will be called when the menu
*  item InstallationInformation is selected.
**********************************************************}
procedure TMgtForm.InstallationInformation1Click(Sender: TObject);
begin
      poMainPage.ActivePage :=  InstallInfo;
end;

{**********************************************************
*  Module:  TMainForm.ConnectedUsers1Click
*  Date Created:  11/25/97
*  Last Modified:
*  Input:  Sender - The Object that called the event
*  Output:
*  Return:
*  Description: This method will be called when the menu
*  item ConnectedUsers is selected.
**********************************************************}
procedure TMgtForm.ConnectedUsers1Click(Sender: TObject);
begin
      poMainPage.ActivePage :=  ConnUsers;
end;

{**********************************************************
*  Module:  TMainForm.OpenFiles1Click
*  Date Created:  11/25/97
*  Last Modified:
*  Input:  Sender - The Object that called the event
*  Output:
*  Return:
*  Description: This method will be called when the menu
*  item OpenFiles1Click is selected.
**********************************************************}
procedure TMgtForm.OpenFiles1Click(Sender: TObject);
begin
      poMainPage.ActivePage :=  OpenFiles;
end;

{**********************************************************
*  Module:  TMainForm.ConfigurationParameters1Click
*  Date Created:  11/25/97
*  Last Modified:
*  Input:  Sender - The Object that called the event
*  Output:
*  Return:
*  Description: This method will be called when the menu
*  item ConfigurationParameters is selected.
**********************************************************}
procedure TMgtForm.ConfigurationParameters1Click(Sender: TObject);
begin
      poMainPage.ActivePage :=  ConfigParam;
end;

{**********************************************************
*  Module:  TMainForm.CommStat1Click
*  Date Created:  11/25/97
*  Last Modified:
*  Input:  Sender - The Object that called the event
*  Output:
*  Return:
*  Description: This method will be called when the menu
*  item CommStat is selected.
**********************************************************}
procedure TMgtForm.CommStat1Click(Sender: TObject);
begin
      poMainPage.ActivePage :=  CommStat;
end;







{**********************************************************
*  Module:  TMainForm.FormDestroy
*  Date Created:  11/25/97
*  Last Modified:
*  Input:  Sender - The Object that called the event
*  Output:
*  Return:
*  Description: This method will be called when the form is
*  being destroyed and is an entry point for clean up.
**********************************************************}
procedure TMgtForm.FormDestroy(Sender: TObject);
var
   usCount : UNSIGNED16;
begin
   // for this file grid make sure all created objects associated to
   // the individual rows are deleted
   WriteRegKey('ManagedServers', cbServer.Items.Text);
   for usCount := 1 to poStrGrdOpenFiles.RowCount - 1 do
   begin
      if Assigned( poStrGrdOpenFiles.Objects[1,usCount] ) then
         ( poStrGrdOpenFiles.Objects[1,usCount] as TServerFilePath ).Free;
   end;

   // for this file grid make sure all created objects associated to
   // the individual rows are deleted
   for usCount := 1 to poStrGrdOpenData.RowCount - 1 do
   begin
      if Assigned( poStrGrdOpenData.Objects[1,usCount] ) then
         ( poStrGrdOpenData.Objects[1,usCount] as TServerFilePath ).Free;
   end;

   CloseAllDialogs;

   // close the connection
   if ( mhConnect <> 0 ) then
      ACE.AdsMgDisconnect( mhConnect );

end;

{**********************************************************
*  Module:  TMainForm.CloseAllDialogs
*  Date Created:  11/25/97
*  Last Modified:
*  Input:
*  Output:
*  Return:
*  Description: This method will loop through all of the
*  components associated to the application object and
*  destroy all dialog views
**********************************************************}
procedure TMgtForm.CloseAllDialogs;
begin
   // In the button view many modless dialogs can be open.
   // The following is a loop to clean each instance up.


end;

{**********************************************************
*  Module:  TMainForm.FormKeyDown
*  Date Created:  11/25/97
*  Last Modified:
*  Input:  Sender - The Object that called the event
*          Key - The key that was pressed that caused this
*          Shift - The optional other key that could be down while "key"
*                  was pressed
*  Output:
*  Return:
*  Description: This method will handle any keys pressed in application
**********************************************************}
procedure TMgtForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   // For Snap Dump
   if ( ssCtrl in Shift ) And ( Key = VK_F9 ) then
   begin
      if ( mhConnect <> 0 ) then
      begin
         ACE.AdsMgDumpInternalTables( mhConnect );
         ShowMessage( 'Snap dump complete' );
      end;
   end;

   // For manual refresh
   if ( Key = VK_F5 ) then
      RefreshView( poMainPage.ActivePage.Name );

end;



{**********************************************************
*  Module:  TMainForm.ValidateConnectionString
*  Date Created:  11/25/97
*  Last Modified:
*  Input: strConnect - Connection string to validate
*  Output:
*  Return: UNSIGNED16 as to the validity of the string.  0 means a bad
*  string and anything else is a good string value.
*  Description: This method will set up all of the initialization
*  that is needed for the initial connection to the remote
*  server.
**********************************************************}
function  TMgtForm.ValidateConnectionString( strConnect : String ) : UNSIGNED16;
var
   usPos : UNSIGNED16;
begin
   // Check for linux native path, if first char is slash but second isn't
   // then assume native linux path
   if ( Length( strConnect ) > 0 ) then
   begin
      // Check for just one slash, as in root of device
      if ( ( strConnect[1] = '/' ) and ( Length( strConnect ) < 2 ) ) then
      begin
         result := 1;
         exit;
      end;
      // Check for path other than linux-style UNC (like //serv/path), which
      // will be checked later.
      if ( ( strConnect[1] = '/' ) and ( strConnect[2] <> '/' ) ) then
      begin
         result := 1;
         exit;
      end;
   end;

   // make sure the connect string is at least 2 chars long
   if ( Length( strConnect ) < 2 ) then
   begin
      // Put up a message box and return error.
      ShowMessage( 'Baðlantý kelimesi en az 2 karakter uzunluðunda olmalýdýr.' );
      Result := 0;
      exit;
   end;

   // Check to see if the Connect string is a drive letter.
   if ( strConnect[2] = ':' ) then
   begin
      Result := 1;
      exit;
   end;

   // Check to see if the Connect string is a \\server\share or \\Server\volume.
   usPos := pos( '\\', strConnect );
   if ( usPos = 1 ) then
   begin
      Result := 1;
      exit;
   end;

   // Check to see if the Connect string is server\vol:
   usPos := pos( '\', strConnect );
   if ( ( usPos > 1 ) And ( Length( strConnect ) > usPos ) And
        ( strConnect[ Length( strConnect ) ] = ':' ) ) then
   begin
      Result := 1;
      exit;
   end;

   // Check to see if the Connect string is server/vol:
   usPos := pos( '/', strConnect );
   if ( ( usPos > 1 ) And ( Length( strConnect ) > usPos ) And
        ( strConnect[ Length( strConnect ) ] = ':' ) ) then
   begin
      Result := 1;
      exit;
   end;


   // Added this stuff for the foward slash linux stuff
      // Check to see if the Connect string is a \\server\share or \\Server\volume.
   usPos := pos( '//', strConnect );
   if ( usPos = 1 ) then
   begin
      Result := 1;
      exit;
   end;

   // Check to see if the Connect string is server\vol:
   usPos := pos( '/', strConnect );
   if ( ( usPos > 1 ) And ( Length( strConnect ) > usPos ) And
        ( strConnect[ Length( strConnect ) ] = ':' ) ) then
   begin
      Result := 1;
      exit;
   end;

   // Check to see if the Connect string is server/vol:
   usPos := pos( '/', strConnect );
   if ( ( usPos > 1 ) And ( Length( strConnect ) > usPos ) And
        ( strConnect[ Length( strConnect ) ] = ':' ) ) then
   begin
      Result := 1;
      exit;
   end;


   // If we get to this point then the string has not fit into one of the
   // previous categories.  Therefor put up a message box and return error.
   ShowMessage( 'Kabul edilebilir Sunucu Sürücüsü baðlantý kelimesi tipleri aþaðýdadýr : ' + #13 + #13 +
                '  H:' + #9 + #9 + #9 + '- Network Drive Letter' + #13 +
                '  \\Server\Share' + #9 + '- UNC server and share' + #13 +
                '  \\Server\Volume' + #9 + '- UNC server and volume' + #13 +
                '  Server\Volume:' + #9 + '- Netware path standard' + #13 +
                '  Server/Volume:' + #9 + '- Netware path standard' );
   Result := 0;
end;

{**********************************************************
*  Module:  TMainForm.DoDisconnect
*  Date Created:  11/25/97
*  Last Modified:
*  Input:
*  Output:
*  Return:
*  Description: This will disconnect from the server and
*  clear out the screens.
**********************************************************}
procedure TMgtForm.DoDisconnect;
begin
   ACE.AdsMgDisconnect( mhConnect );
   mhConnect := 0;
   // Make sure the graphics are hidden because of disconnection
   imgConnectedServer.Visible := False;
   lbConnectedServerType.Caption := '';
   StatusBar1.Panels[1].Text := '';
   StatusBar1.Panels[3].Text := '';

   // Always clear the tab view because it is always visible
   ClearAll( poMainPage );

end;

{**********************************************************
*  Module:  TMainForm.sbConnectServerClick
*  Date Created:  11/25/97
*  Last Modified: 10/27/99
*  Input: Sender - The object that called the event
*  Output:
*  Return:
*  Description: This method will set up all of the initialization
*  that is needed for the initial connection to the remote
*  server.
**********************************************************}
procedure TMgtForm.sbConnectServerClick(Sender: TObject);
var
   ulRetVal : UNSIGNED32;
   usServerType : UNSIGNED16;
   usValid : UNSIGNED16;
   sCount : SIGNED16;
   bFound : Boolean;
   acErrorString : array[0..ERROR_STRING_LEN] of Char;
   usErrStringSize : UNSIGNED16;
   usLen : UNSIGNED16;
   oSavedServerType: TAdsServerTypes;
   acConnPath : array[0..256] of char;
begin
   try
      // If no change happened in the server combo box no-op
      if Not( bServerBoxChanged ) then
         exit
      else
         bServerBoxChanged := False;

      // if a connection already exists close the connection
      if ( mhConnect <> 0 ) then
      begin
         DoDisconnect;
      end;

      // Begin a wait state appearance
      Screen.Cursor := crHourGlass;

      // Process the messages in the queue before the AdsMgConnect searches for
      // the server to connect to.  This is for the graphical display to actually
      // update.
      Application.ProcessMessages;

      // do some up-front validation for the passed in connection string
      usValid := ValidateConnectionString( cbServer.Text );
      if ( usValid = 0 ) then
      begin
         exit;
      end;

      {* Add this new server to the registry list, if necessary *}
      AddServerToReg( cbServer.Text );

      {*
       * Save the current server type, set the server type to
       * include everything but localserver
       *}
      oSavedServerType := FmOptions.AdsSettings.AdsServerTypes;

      FmOptions.AdsSettings.AdsServerTypes := [stADS_REMOTE, stADS_AIS];

      strpcopy( acConnPath, cbserver.text );
      ulRetVal := ACE.AdsMgConnect( acConnPath, nil, nil, @mhConnect );

      // If there was an error then show it and exit
      if ( ulRetVal <> AE_SUCCESS ) then
      begin
         // If the error is an ACE error
         usErrStringSize := ERROR_STRING_LEN;
         ACE.AdsGetLastError( @ulRetVal, @acErrorString, @usErrStringSize );
         ShowMessage( 'Baðlantý hatasý: ' + StrPas( @acErrorString ) );

         exit;
      end;

      {* Now that we have connected, restore the server type *}
      FmOptions.AdsSettings.AdsServerTypes := oSavedServerType;

   finally
      // Set the cursor back to normal after the wait
      Screen.Cursor := crDefault;
   end;

   // Insert the server connection string into the history string list in the
   // combo box drop down
   bFound := False;
   if cbServer.Items.Count = 0 then
      cbServer.Items.Insert( 0, cbServer.Text )
   else
   begin
      // if the string already existed in the list we have inserted it to the
      // beginning but do not want it to show up multiple times therefor remove
      // all other instances of it.  Start at 1 because it exists now at 0.
      for sCount := 0 to cbServer.Items.Count - 1 do
      begin
         if cbServer.Items[sCount] = cbServer.Text then
         begin
            cbServer.Items.Move( sCount, 0 );
            cbServer.ItemIndex := 0;
            bFound := True;
            break;
         end;
      end;
      if Not ( bFound ) then
         cbServer.Items.Insert( 0, cbServer.Text );
   end;

   // 5 is used as a constant here to only keep the last five most recently used
   // entries.  This can be whatever depth is needed.
   if cbServer.Items.Count > 10 then
      cbServer.Items.Delete( cbServer.Items.Count - 1 );

   // Only do the following if the ulRetVal returned from the connect call
   // was successful.
   if ulRetVal = AE_SUCCESS then
   begin
      // Find out what server we are connected to
      usLen := ADS_MAX_SERVER;
      ulRetVal := ACE.AdsGetServerName( mhConnect, @aucServerName, @usLen );
      if ( ulRetVal <> AE_SUCCESS ) then
      begin
         ShowMessage( 'Hatalý sunucu adý.Girilen sunucu bilgisine ulaþýlamadý.' );
         exit;
      end;

      // Get the type of server that we are connected to.  Set the server type
      // caption to reflect the server type and set a global enumeration as to
      // what type of a server we are connected to.  This is needed later for
      // distinctions between server types.
      ulRetVal := ACE.AdsMgGetServerType( mhConnect, @usServerType );
      if ulRetVal = AE_SUCCESS then
      begin
         imgConnectedServer.Visible := True;
         case ( usServerType ) of
            ADS_MGMT_NETWARE4_OR_OLDER_SERVER:
            begin
               lbConnectedServerType.Caption := 'NetWare 3/4';
               meServerType := stNetWare;
            end;

            ADS_MGMT_NT_SERVER:
            begin
               lbConnectedServerType.Caption := 'Win NT/2000';
               meServerType := stNT;
            end;

            ADS_MGMT_LOCAL_SERVER:
            begin
               lbConnectedServerType.Caption := 'Local';
               meServerType := stLocal;
            end;

            ADS_MGMT_WIN9X_SERVER:
            begin
               lbConnectedServerType.Caption := 'Win 95/98';
               meServerType := stWin9x;
            end;

            ADS_MGMT_NETWARE5_OR_NEWER_SERVER:
            begin
               lbConnectedServerType.Caption := 'NetWare 5';
               meServerType := stNetWare;
            end;

            ADS_MGMT_LINUX_SERVER:
            begin
               lbConnectedServerType.Caption := 'Linux';
               // Looks like the server type is mostly used for netware, so
               // just leave it as unknown for linux.
               meServerType := stUnknown;
            end;

            else
            begin
               lbConnectedServerType.Caption := '';
               meServerType := stUnknown;
            end;

         end;
         lbConnectedServerType.Visible := True;
      end;

      // Refresh all updateable views
      RefreshAllUpdateableViews;

      RefreshTabConfigView;
      RefreshTabInstallView;
      RefreshView( poMainPage.ActivePage.Name );

      // Modify the form caption
      Caption := 'Advantage Yönetim Aracý - ' + cbServer.Text;
   end;
end;

{**********************************************************
*  Module:  TMainForm.RefreshView
*  Date Created:  11/25/97
*  Last Modified:
*  Input:  strView - The page of the view that needs to be
*                    refreshed
*  Output:
*  Return:
*  Description: This method will update the view of the page
*  that was passed in.
**********************************************************}
procedure TMgtForm.RefreshView( strView : String );
var
   stActivityInfo : ADS_MGMT_ACTIVITY_INFO;
   usSize :         UNSIGNED16;
begin
   if ( mhConnect = 0 ) then
      exit;

   // Since the uptime and operations since loaded is always visible and
   // this is the only way to get it we must do this every time a refresh occurs
   usSize := sizeof( ADS_MGMT_ACTIVITY_INFO );
   MgtCheck( ACE.AdsMgGetActivityInfo( mhConnect, @stActivityInfo,
      @usSize ) );

   // if the structure returned is smaller than what we are expecting there will
   // be problems when we try to referrence the values past the end of what was
   // returned.  This is an error condition.  If it is bigger thats ok.
   if ( usSize < sizeof( ADS_MGMT_ACTIVITY_INFO ) ) then
      raise Exception.Create( 'Activity Information structure returned is too small' );

   StatusBar1.Panels[1].Text := IntToStr( stActivityInfo.stUpTime.usDays ) + ' Gün ' +
      IntToStr( stActivityInfo.stUpTime.usHours ) + ' Saat ' +
      IntToStr( stActivityInfo.stUpTime.usMinutes ) + ' Dakika ' +
      IntToStr( stActivityInfo.stUpTime.usSeconds ) + ' Saniye';
   StatusBar1.Panels[3].Text := IntToStr( stActivityInfo.ulOperations );

   // need to update log entries on retrieval of activity information
   poLogEntries.Caption := IntToStr( stActivityInfo.ulLoggedErrors );

   // make sure the display is updated
   Application.ProcessMessages;

   // If in tab view update the given view given the tab sheet name
      if ( strView = 'CommStat' ) then
         RefreshTabCommView;

      if ( strView = 'DataInfo' ) then
         RefreshTabDBView( @stActivityInfo );

      if ( strView = 'ConnUsers' ) then
         RefreshTabConnectView;

      if ( strView = 'OpenFiles' ) then
         RefreshTabOpenFilesView;

end;

{**********************************************************
*  Module:  TMainForm.RefreshCurrentViewClick
*  Date Created:  11/25/97
*  Last Modified:
*  Input: Sender - The object that called the event
*  Output:
*  Return:
*  Description: This method will cause a refresh of the data
*  for the current view
**********************************************************}
procedure TMgtForm.RefreshCurrentViewClick(Sender: TObject);
begin
   RefreshView( poMainPage.ActivePage.Name );
end;

{**********************************************************
*  Module:  TMainForm.cbServerKeyPress
*  Date Created:  11/25/97
*  Last Modified:
*  Input: Sender - The object that called the event
*         Key - Key that was pressed to cause event
*  Output:
*  Return:
*  Description: This method will connect to the specified server
**********************************************************}
procedure TMgtForm.cbServerKeyPress(Sender: TObject; var Key: Char);
begin
   if ( key = HIT_RETURN ) then
   begin
      // act as if the user just pressed the connect server button
      sbConnectServerClick(Sender);
      // the return key needs to be changed to a 0 or it will cause a
      // sound event for pressing return in a combo box
      key := #0;
      cbServer.SelectAll;

   end;
end;

{**********************************************************
*  Module:  TMainForm.Timer1Timer
*  Date Created:  11/25/97
*  Last Modified:
*  Input: Sender - The object that called the event
*  Output:
*  Return:
*  Description: This method will refresh the current view
*  on the timer event.
**********************************************************}
procedure TMgtForm.Timer1Timer(Sender: TObject);
begin
   RefreshView( poMainPage.ActivePage.Name );
end;

{**********************************************************
*  Module:  RefreshDBView
*  Date Created:  11/25/97
*  Last Modified:
*  Input: pstActiveInfo - pointer to the Activity Info structure
*  Output:
*  Return:
*  Description: This method will fill out all viewable fields
*  for the tab view Database Information
**********************************************************}
procedure TMgtForm.RefreshTabDBView( pstActiveInfo : pADS_MGMT_ACTIVITY_INFO );
begin
   // With the retrieved structure fill out the display grid
   poDInfoGrid.Cells[1,1] := IntToStr( pstActiveInfo.stUsers.ulInUse );
   poDInfoGrid.Cells[2,1] := IntToStr( pstActiveInfo.stUsers.ulMaxUsed );
   poDInfoGrid.Cells[3,1] := poUserOpt.Caption;
   poDInfoGrid.Cells[4,1] := IntToStr( pstActiveInfo.stUsers.ulRejected );

   poDInfoGrid.Cells[1,2] := IntToStr( pstActiveInfo.stConnections.ulInUse );
   poDInfoGrid.Cells[2,2] := IntToStr( pstActiveInfo.stConnections.ulMaxUsed );
   poDInfoGrid.Cells[3,2] := poNumConn.Caption;
   poDInfoGrid.Cells[4,2] := IntToStr( pstActiveInfo.stConnections.ulRejected );

   poDInfoGrid.Cells[1,3] := IntToStr( pstActiveInfo.stWorkAreas.ulInUse );
   poDInfoGrid.Cells[2,3] := IntToStr( pstActiveInfo.stWorkAreas.ulMaxUsed );
   poDInfoGrid.Cells[3,3] := poNumWork.Caption;
   poDInfoGrid.Cells[4,3] := IntToStr( pstActiveInfo.stWorkAreas.ulRejected );

   poDInfoGrid.Cells[1,4] := IntToStr( pstActiveInfo.stTables.ulInUse );
   poDInfoGrid.Cells[2,4] := IntToStr( pstActiveInfo.stTables.ulMaxUsed );
   poDInfoGrid.Cells[3,4] := poNumTables.Caption;
   poDInfoGrid.Cells[4,4] := IntToStr( pstActiveInfo.stTables.ulRejected );

   poDInfoGrid.Cells[1,5] := IntToStr( pstActiveInfo.stIndexes.ulInUse );
   poDInfoGrid.Cells[2,5] := IntToStr( pstActiveInfo.stIndexes.ulMaxUsed );
   poDInfoGrid.Cells[3,5] := poNumIndexes.Caption;
   poDInfoGrid.Cells[4,5] := IntToStr( pstActiveInfo.stIndexes.ulRejected );

   poDInfoGrid.Cells[1,6] := IntToStr( pstActiveInfo.stLocks.ulInUse );
   poDInfoGrid.Cells[2,6] := IntToStr( pstActiveInfo.stLocks.ulMaxUsed );
   poDInfoGrid.Cells[3,6] := poNumDataLocks.Caption;
   poDInfoGrid.Cells[4,6] := IntToStr( pstActiveInfo.stLocks.ulRejected );

   poDInfoGrid.Cells[1,7] := IntToStr( pstActiveInfo.stWorkerThreads.ulInUse );
   poDInfoGrid.Cells[2,7] := IntToStr( pstActiveInfo.stWorkerThreads.ulMaxUsed );
   poDInfoGrid.Cells[3,7] := poNumWorkThread.Caption;
   poDInfoGrid.Cells[4,7] := IntToStr( pstActiveInfo.stWorkerThreads.ulRejected );
end;

{**********************************************************
*  Module:  TMainForm.RefreshTabCommView
*  Date Created:  11/25/97
*  Last Modified:
*  Input:
*  Output:
*  Return:
*  Description: This method will fill out all viewable fields
*  for the tab view Communication Statistics
**********************************************************}
procedure TMgtForm.RefreshTabCommView;
var
   stCommStats : ADS_MGMT_COMM_STATS;
   usSize : UNSIGNED16;
begin
   usSize := sizeof( ADS_MGMT_COMM_STATS );
   MgtCheck( ACE.AdsMgGetCommStats( mhConnect, @stCommStats, @usSize ) );

   // if the structure returned is smaller than what we are expecting there will
   // be problems when we try to referrence the values past the end of what was
   // returned.  This is an error condition.  If it is bigger thats ok.
   if ( usSize < sizeof( ADS_MGMT_COMM_STATS ) ) then
      raise Exception.Create( 'Communication Statistics structure returned is too small' );

   // With the retrieved structure fill out the display panels
   poTotalPacketRcv.Caption  := IntToStr( stCommStats.ulTotalPackets );
   poCheckSum.Caption := IntToStr( stCommStats.ulCheckSumFailures );
   poPacketOutSeq.Caption := IntToStr( stCommStats.ulRcvPktOutOfSeq );
   poReqOutSeq.Caption := IntToStr( stCommStats.ulRcvReqOutOfSeq );
   poOwnerNotLog.Caption := IntToStr( stCommStats.ulNotLoggedIn );
   poServerInitDiscon.Caption := IntToStr( stCommStats.ulDisconnectedUsers );
   poRemovePartCon.Caption := IntToStr( stCommStats.ulPartialConnects );
   poInvalidPacket.Caption := IntToStr( stCommStats.ulInvalidPackets );
   poRecvError.Caption := IntToStr( stCommStats.ulRecvFromErrors );
   poSendError.Caption := IntToStr( stCommStats.ulSendToErrors );
   poPercentError.Caption := FloatToStrF(stCommStats.dPercentCheckSums, ffFixed, 15, 2 );
end;


{**********************************************************
*  Module:  TMainForm.RefreshTabConfigView
*  Date Created:  11/25/97
*  Last Modified:
*  Input:
*  Output:
*  Return:
*  Description: This method will fill out all viewable fields
*  for the tab view Configuration Information
**********************************************************}
procedure TMgtForm.RefreshTabConfigView;
var
   stConfigValues : ADS_MGMT_CONFIG_PARAMS;
   stConfigMemory : ADS_MGMT_CONFIG_MEMORY;
   usSize : UNSIGNED16;
   usSize2 : UNSIGNED16;
begin
   usSize := sizeof( ADS_MGMT_CONFIG_PARAMS );
   usSize2 := sizeof( ADS_MGMT_CONFIG_MEMORY );
   MgtCheck( ACE.AdsMgGetConfigInfo( mhConnect, @stConfigValues, @usSize,
      @stConfigMemory, @usSize2 ) );

   // if the structure returned is smaller than what we are expecting there will
   // be problems when we try to referrence the values past the end of what was
   // returned.  This is an error condition.  If it is bigger thats ok.
   if ( usSize < sizeof( ADS_MGMT_CONFIG_PARAMS ) ) then
      raise Exception.Create( 'Konfigürasyon parametreleri yapýsý çok küçük döndü.' );
   if ( usSize2 < sizeof( ADS_MGMT_CONFIG_MEMORY ) ) then
      raise Exception.Create( 'Konfigürasyon hafýza yapýsý çok küçük döndü.' );

   // With the retrieved structure fill out the display panels
   poNumWorkThread.Caption := IntToStr( stConfigValues.usNumWorkerThreads );
   poNumDataLocks.Caption := IntToStr( stConfigValues.ulNumLocks );
   poNumIndexes.Caption := IntToStr( stConfigValues.ulNumIndexes );
   poNumTables.Caption := IntToStr( stConfigValues.ulNumTables );
   poNumWork.Caption := IntToStr( stConfigValues.ulNumWorkAreas );
   poNumConn.Caption := IntToStr( stConfigValues.ulNumConnections );
   poMemNumConn.Caption := IntToStr( stConfigMemory.ulConnectionMem );
   poMemNumWork.Caption := IntToStr( stConfigMemory.ulWorkAreaMem );
   poMemNumTables.Caption := IntToStr( stConfigMemory.ulTableMem );
   poMemNumIndexes.Caption := IntToStr( stConfigMemory.ulIndexMem );
   poMemNumDataLocks.Caption := IntToStr( stConfigMemory.ulLockMem );
   poMemNumWorkThead.Caption := IntToStr( stConfigMemory.ulWorkerThreadMem );
   poTranLogFile.Caption := stConfigValues.aucTransaction;
   // If nothing was configured then the default for netware is SYS:\
   // NT even if not configured will return c:\
   if ( ( poTranLogFile.Caption = '' ) and ( meServerType = stNetWare ) ) then
      poTranLogFile.Caption := 'SYS:\';
   poSemFilePath.Caption := stConfigValues.aucSemaphore;
   poLogPath.Caption := stConfigValues.aucErrorLog;
   // If nothing was configured then the default for netware is SYS:\
   // NT even if not configured will return c:\
   if ( ( poLogPath.Caption = '' ) and ( meServerType = stNetWare ) ) then
      poLogPath.Caption := 'SYS:\';
   poSizeErrorLog.Caption := IntToStr( stConfigValues.ulErrorLogMax );
   poTotalMemUsed.Caption := IntToStr( stConfigMemory.ulTotalConfigMem );
   poIPRecv.Caption := IntToStr( stConfigValues.usReceiveIPPort );
   poInternetPort.Caption := IntToStr( stConfigValues.usInternetPort );
end;

{**********************************************************
*  Module:  TMainForm.RefreshTabInstallView
*  Date Created:  11/25/97
*  Last Modified:
*  Input: pstInstallInfo - pointer to the Installation Info structure
*  Output:
*  Return:
*  Description: This method will fill out all viewable fields
*  for the tab view Installation Information
**********************************************************}
procedure TMgtForm.RefreshTabInstallView;
var
   stInstallInfo : ADS_MGMT_INSTALL_INFO;
   usSize : UNSIGNED16;
begin
   usSize := sizeof( ADS_MGMT_INSTALL_INFO );
   MgtCheck( ACE.AdsMgGetInstallInfo( mhConnect, @stInstallInfo, @usSize ) );

   // if the structure returned is smaller than what we are expecting there will
   // be problems when we try to referrence the values past the end of what was
   // returned.  This is an error condition.  If it is bigger thats ok.
   if ( usSize < sizeof( ADS_MGMT_INSTALL_INFO ) ) then
      raise Exception.Create( 'Kurulum bilgisi yapýsý çok küçük döndü.' );


   // With the retrieved structure fill out the display grid
   poRegTo.Caption := stInstallInfo.aucRegisteredOwner;
   poSerialNum.Caption := stInstallInfo.aucSerialNumber;

   if ( stInstallInfo.ulUserOption = 10000 ) then
      poUserOpt.Caption := 'UNLIMITED'
   else if ( stInstallInfo.ulUserOption = 2 ) then
      poUserOpt.Caption := 'SDK'
   else
      poUserOpt.Caption := IntToStr( stInstallInfo.ulUserOption );

   poADSRev.Caption := Trim(StrPas( stInstallInfo.aucVersionStr ));
   poInitDate.Caption := stInstallInfo.aucInstallDate;
   poEvalDate.Caption := stInstallInfo.aucEvalExpireDate;
   poANSISet.Caption := stInstallInfo.aucAnsiCharName;
   poOEMSet.Caption := stInstallInfo.aucOemCharName;
end;

{**********************************************************
*  Module:  TMainForm.RefreshAllUpdateableViews
*  Date Created:  11/25/97
*  Last Modified:
*  Input:
*  Output:
*  Return:
*  Description: This method will cause only the views that
*  get updated repeatedly to get updated all at once.
**********************************************************}
procedure TMgtForm.RefreshAllUpdateableViews;
begin
      RefreshView( 'CommStat' );
      RefreshView( 'DataInfo' );
      RefreshView( 'ConnUsers' );
      RefreshView( 'OpenFiles' );

end;

{**********************************************************
*  Module:  TMainForm.ResetStatClick
*  Date Created:  11/25/97
*  Last Modified:
*  Input: Sender - The object that called the event
*  Output:
*  Return:
*  Description: This method will reset the communication statistics
**********************************************************}
procedure TMgtForm.ResetStatClick(Sender: TObject);
begin
   if ( mhConnect = 0 ) then
      exit;

   MgtCheck( ACE.AdsMgResetCommStats( mhConnect ) );

   // refresh data
   RefreshView( 'CommStat' );
end;

{**********************************************************
*  Module:  TMainForm.RefreshTabConnectView
*  Date Created:  11/25/97
*  Last Modified:
*  Input:
*  Output:
*  Return:
*  Description: This method will fill out all viewable fields
*  for the tab Connection View
**********************************************************}
procedure TMgtForm.RefreshTabConnectView;
begin
   // show all availiable users
   RefreshConnUsers( poStrGrdConUser, '', False );

   RefreshIndexAndLocks;
end;

{**********************************************************
*  Module:  TMainForm.MainPageChange
*  Date Created:  11/25/97
*  Last Modified:
*  Input:  Sender - Object that caused event
*  Output:
*  Return:
*  Description: When ever the tabs are being changed this
*  event fires to make sure that the latest information
*  is availiable.
**********************************************************}
procedure TMgtForm.MainPageChange(Sender: TObject);
begin
   // The help context needs to be switched before we get to the next page

   RefreshView( poMainPage.ActivePage.Name );
end;

{**********************************************************
*  Module:  TMainForm.RefreshTabOpenFilesView
*  Date Created:  11/25/97
*  Last Modified:
*  Input:
*  Output:
*  Return:
*  Description: This method will fill out all viewable fields
*  for the tab Open Files
**********************************************************}
procedure TMgtForm.RefreshTabOpenFilesView;
var
   poFilePath : TServerFilePath;
begin
   if ( poRgOpenFileType.ItemIndex = 1 ) then
      RefreshConnUserIndexes( poStrGrdOpenFiles, 0, '', '')
   else
      RefreshConnUserTables( poStrGrdOpenFiles, 0, '');

   // If a ServerFilePath object was associated to the cell for the file name,
   // then get the object and pull the full path in order to get the users.
   if Assigned( poStrGrdOpenFiles.Objects[1,poStrGrdOpenFiles.Row]  ) then
   begin
      poFilePath := poStrGrdOpenFiles.Objects[1,poStrGrdOpenFiles.Row] as TServerFilePath;
      RefreshConnUsers( poStrGrdUserFile, poFilePath.Path, False );
   end
   else
      // send down an empty string because no files are availiable but the function
      // will need to be called to blank everything out.
      RefreshConnUsers( poStrGrdUserFile, '', True );

end;


{**********************************************************
*  Module:  TMainForm.RefreshConnUsers
*  Date Created:  11/25/97
*  Last Modified:
*  Input: poGrid - grid to populate with users
*         strFileName - specific file name to find connected users
*         bMakeEmpty - the grid needs to be emptied because no file was found.
*         Usually when no file was found that would mean to get all users,
*         however in some instances no table means no users.
*  Output:
*  Return:
*  Description: For the given grid the connected users will
*  be retrieved and populated into the control.
**********************************************************}
procedure TMgtForm.RefreshConnUsers( poGrid : TStringGrid;
          strFileName : String; bMakeEmpty : Boolean );
var
   astUserInformation : ADSMgUserArray;
   usSize : UNSIGNED16;
   usArrayLen : UNSIGNED16;
   ulRetVal : UNSIGNED32;
   usCount : UNSIGNED16;
begin
   // If connected to a Netware server then the connection number will show
   if ( meServerType = stNetWare ) then
      poGrid.Cells[0,0] := 'Cnct #'
   else
      poGrid.Cells[0,0] := '';

   // If MakeEmpty then the grid must be emptied
   if ( bMakeEmpty ) then
   begin
      poGrid.Cells[0,1] := '';
      poGrid.Cells[1,1] := '';

      // Set RowCount to 2 which is 1 for the fixed row which contains the column
      // headers and one for a non fixed empty row.
      poGrid.RowCount := 2;
      exit;
   end;

   usSize := sizeof( ADS_MGMT_USER_INFO );
   usArrayLen := ADS_USER_ARRAY_SIZE;

   // If the filename is empty then pass to the management API a nil for file name.
   if ( strFileName = '' ) then
      ulRetVal := MgtCheck( ACE.AdsMgGetUserNames( mhConnect, nil, @astUserInformation,
         @usArrayLen, @usSize ) )
   else
   begin
      // If a filename exists tack on to the front of the name a server name so that
      // UNC resolution will take place.
      if ( meServerType = stNetWare ) then
         strFileName := StrPas( @aucServerName ) + '\' + strFileName;

      ulRetVal := MgtCheck( ACE.AdsMgGetUserNames( mhConnect, PChar(strFileName),
         @astUserInformation, @usArrayLen, @usSize ) );
   end;

   // if the structure returned is smaller than what we are expecting there will
   // be problems when we try to referrence the values past the end of what was
   // returned.  This is an error condition.  If it is bigger thats ok.
   if ( usSize < sizeof( ADS_MGMT_USER_INFO ) ) then
      raise Exception.Create( 'Kullanýcý bilgileri yapýlarý çok küçük döndü.' );


   // Enter code here to sort the array of structures as to whatever
   // criteria is desired.


   // If the file was not found treat this just like the operation had no users
   if ( ulRetVal = FILE_NOT_FOUND ) then
      usArrayLen := 0;

   // Empty the grid if the array len is empty
   if ( usArrayLen = 0 ) then
   begin
      poGrid.Cells[0,1] := '';
      poGrid.Cells[1,1] := '';

      // Set RowCount to 2 which is 1 for the fixed row which contains the column
      // headers and one for a non fixed empty row.
      poGrid.RowCount := 2;
      exit;
   end
   else
   begin
      // Set RowCount to the array length + 1 for the fixed row which contains the
      // column headers
      poGrid.RowCount := usArrayLen + 1;
   end;

   // If elements returned in the array then put them in the grid
   for usCount := 0 to usArrayLen - 1 do
   begin
      if ( meServerType = stNetWare ) then
         poGrid.Cells[0,usCount+1] := IntToStr( astUserInformation[usCount].usConnNumber )
      else
         poGrid.Cells[0,usCount+1] := '';

      poGrid.Cells[1,usCount+1] := StrPas( astUserInformation[usCount].aucUserName );
      poGrid.Cells[2,usCount+1] := StrPas( astUserInformation[usCount].aucDictionaryName );
      poGrid.Cells[3,usCount+1] := StrPas( astUserInformation[usCount].aucAddress );
   end;
end;


{**********************************************************
*  Module:  TMainForm.RefreshConnUserTables
*  Date Created:  11/25/97
*  Last Modified:
*  Input: poGrid - grid to populate with tables
*         usConnectNum - specific connect number to show open tables
*         strUser - specific user to show open tables
*  Output:
*  Return:
*  Description: For the given connect number or user the
*  tables open will be retrieved.  The given grid will be
*  populated with the result.
**********************************************************}
procedure TMgtForm.RefreshConnUserTables( poGrid : TStringGrid;
          usConnectNum : UNSIGNED16; strUser : String );
var
   astTableInfo : ADSMgTableArray;
   usSize : UNSIGNED16;
   usArrayLen : UNSIGNED16;
   usCount : UNSIGNED16;
   strTable, strTempTable : String;
begin
   // If refreshing the tables for a connected user then restore grid headings
   poGrid.Cells[0,0] := 'Kilit';
   poGrid.Cells[1,0] := 'Açýk Tablolar';

   // Make sure before the grids are filled that all associated file path objects
   // are removed.
   for usCount := 1 to poGrid.RowCount - 1 do
   begin
      if Assigned( poGrid.Objects[1,usCount] ) then
      begin
         ( poGrid.Objects[1,usCount] as TServerFilePath ).Free;
         poGrid.Objects[1,usCount] := nil;
      end;
   end;


   // Get the open tables
   usSize := sizeof( ADS_MGMT_TABLE_INFO );
   usArrayLen := ADS_TABLE_ARRAY_SIZE;
   if ( strUser <> '' ) then
      MgtCheck( ACE.AdsMgGetOpenTables( mhConnect, PChar( strUser ), usConnectNum,
         @astTableInfo, @usArrayLen, @usSize ) )
   else
      MgtCheck( ACE.AdsMgGetOpenTables( mhConnect, nil, 0,
         @astTableInfo, @usArrayLen, @usSize ) );

   // if the structure returned is smaller than what we are expecting there will
   // be problems when we try to referrence the values past the end of what was
   // returned.  This is an error condition.  If it is bigger thats ok.
   if ( usSize < sizeof( ADS_MGMT_TABLE_INFO ) ) then
      raise Exception.Create( 'Tablo bilgileri yapýlarý çok küçük döndü.' );



   // Enter code here to sort the array of structures as to whatever
   // criteria is desired.


   // If the array length of the returned array is 0 then empty grid and return
   if ( usArrayLen = 0 ) then
   begin
      poGrid.Cells[0,1] := '';
      poGrid.Cells[1,1] := '';

      // Set RowCount to 2 which is 1 for the fixed row which contains the column
      // headers and one for a non fixed empty row.
      poGrid.RowCount := 2;
      exit;
   end
   else
   begin
      // Set RowCount to the array length + 1 for the fixed row which contains the
      // column headers
      poGrid.RowCount := usArrayLen + 1;
   end;

   // Set the lock type of the file
   for usCount := 0 to usArrayLen - 1 do
   begin
      case ( astTableInfo[usCount].usLockType ) of
         ADS_MGMT_PROPRIETARY_LOCKING :
            poGrid.Cells[0,usCount+1] := 'ADS';
         ADS_MGMT_CDX_LOCKING :
            poGrid.Cells[0,usCount+1] := 'CDX';
         ADS_MGMT_NTX_LOCKING :
            poGrid.Cells[0,usCount+1] := 'NTX';
         ADS_MGMT_ADT_LOCKING :
            poGrid.Cells[0,usCount+1] := 'ADT';
      end;

      // Get the full name of the table
      strTempTable := StrPas( astTableInfo[usCount].aucTableName );

      // before we chop the middle out of some of the file descriptions
      // lets save the full path in an object attached to the grid row
      poGrid.Objects[1,usCount+1] := TServerFilePath.Create( strTempTable );

      // Chop the middle out of the path\filename if greater than 55 char long
      if ( Length( strTempTable ) > 55 ) then
      begin
         strTable := copy( strTempTable, 1, 25 );
         strTable := strTable + ' ... ';
         strTable := strTable + copy( strTempTable, Length( strTempTable ) - 25, 25);
      end
      else
         strTable := strTempTable;

      poGrid.Cells[1,usCount+1] := strTable;
   end;
end;

{**********************************************************
*  Module:  TMainForm.RefreshConnUserIndexes
*  Date Created:  11/25/97
*  Last Modified:
*  Input: poGrid - grid to populate with Indexes
*         usConnectNum - specific connect number to show open indexes
*         strTable - specific table to show open indexes
*         strUser - specific user to show open indexes
*  Output:
*  Return:
*  Description: For the given connect number or user the
*  indexes open will be retrieved.  The given grid will be
*  populated with the result.
**********************************************************}
procedure TMgtForm.RefreshConnUserIndexes( poGrid : TStringGrid;
          usConnectNum : UNSIGNED16; strTable, strUser : String );
var
   astIndexInfo : ADSMgIndexArray;
   usSize : UNSIGNED16;
   usArrayLen : UNSIGNED16;
   usCount : UNSIGNED16;
   strIndex, strTempIndex : String;
begin
   // If refreshing the indexes for a connected user then restore grid headings
   poGrid.Cells[0,0] := '';
   poGrid.Cells[1,0] := 'Açýk Ýndeksler';

   // Make sure before the grids are filled that all associated file path objects
   // are removed.
   for usCount := 1 to poGrid.RowCount - 1 do
   begin
      if Assigned(poGrid.Objects[1,usCount]) then
      begin
         ( poGrid.Objects[1,usCount] as TServerFilePath ).Free;
         poGrid.Objects[1,usCount] := nil;
      end;
   end;

   // Get the open Indexes for user/table combo, user, table, or all open indexes
   usSize := sizeof( ADS_MGMT_INDEX_INFO );
   usArrayLen := ADS_INDEX_ARRAY_SIZE;
   if ( strUser <> '' ) AND ( strTable <> '' ) then
      MgtCheck( ACE.AdsMgGetOpenIndexes( mhConnect, PChar( strTable ),
         PChar(strUser), usConnectNum, @astIndexInfo, @usArrayLen, @usSize ) )
   else if ( strUser <> '' ) then
      MgtCheck( ACE.AdsMgGetOpenIndexes( mhConnect, nil, PChar( strUser ), 0,
         @astIndexInfo, @usArrayLen, @usSize ) )
   else if ( strTable <> '' ) then
      MgtCheck( ACE.AdsMgGetOpenIndexes( mhConnect, PChar( strTable ), nil, 0,
         @astIndexInfo, @usArrayLen, @usSize ) )
   else
      MgtCheck( ACE.AdsMgGetOpenIndexes( mhConnect, nil, nil, 0,
         @astIndexInfo, @usArrayLen, @usSize ) );

   // if the structure returned is smaller than what we are expecting there will
   // be problems when we try to referrence the values past the end of what was
   // returned.  This is an error condition.  If it is bigger thats ok.
   if ( usSize < sizeof( ADS_MGMT_INDEX_INFO ) ) then
      raise Exception.Create( 'Ýndeks bilgileri yapýlarý çok küçük döndü.' );



   // Enter code here to sort the array of structures as to whatever
   // criteria is desired.


   // If no open indexes then empty the grid and exit
   if ( usArrayLen = 0 ) then
   begin
      poGrid.Cells[0,1] := '';
      poGrid.Cells[1,1] := '';

      // Set RowCount to 2 which is 1 for the fixed row which contains the column
      // headers and one for a non fixed empty row.
      poGrid.RowCount := 2;
      exit;
   end
   else
   begin
      // Set RowCount to the array length + 1 for the fixed row which contains the
      // column headers
      poGrid.RowCount := usArrayLen + 1;
   end;

   for usCount := 0 to usArrayLen - 1 do
   begin
      // Get the full name of the indexes
      strTempIndex := StrPas( astIndexInfo[usCount].aucIndexName );

      // before we chop the middle out of some of the file descriptions
      // lets save the full path in an object attached to the grid row
      poGrid.Objects[1,usCount+1] := TServerFilePath.Create( strTempIndex );

      // Chop the middle out of the path\filename if greater than 55 char long
      if ( Length( strTempIndex ) > 55 ) then
      begin
         strIndex := copy( strTempIndex, 1, 25 );
         strIndex := strIndex + ' ... ';
         strIndex := strIndex + copy( strTempIndex, Length(strTempIndex) - 25, 25);
      end
      else
         strIndex := strTempIndex;

      poGrid.Cells[0,usCount+1] := '';
      poGrid.Cells[1,usCount+1] := strIndex;
   end;
end;


{**********************************************************
*  Module:  TMainForm.RefreshConnUserLocks
*  Date Created:  11/25/97
*  Last Modified:
*  Input: poGrid - grid to populate with Locks
*         usConnectNum - specific connect number to show locks
*         strUser - specific user to show locks
*         strTable - specific table to show locks
*  Output:
*  Return:
*  Description: For the given connect number or user the
*  locks will be retrieved.
**********************************************************}
procedure TMgtForm.RefreshConnUserLocks( poGrid : TStringGrid;
                                          usConnectNum : UNSIGNED16;
                                          strUser, strTable : String );
var
   astRecordInfo : ADSMgLocksArray;
   usSize : UNSIGNED16;
   usArrayLen : UNSIGNED16;
   ulRetVal : UNSIGNED32;
   usCount : UNSIGNED16;
   strRecNum : String;
begin
   usSize := sizeof( ADS_MGMT_RECORD_INFO );
   usArrayLen := ADS_LOCK_ARRAY_SIZE;

   if ( strTable <> '' ) then
   begin
      // For Netware servers add the server name to the beginning for UNC resolution
      if ( meServerType = stNetWare ) then
         strTable := StrPas( @aucServerName ) + '\' + strTable;

      // Get the locks for the given table/user or just table
      if ( strUser <> '' ) then
         ulRetVal := MgtCheck( ACE.AdsMgGetLocks( mhConnect, PChar( strTable ),
            PChar(strUser), usConnectNum, @astRecordInfo, @usArrayLen, @usSize ) )
      else
         ulRetVal := MgtCheck( ACE.AdsMgGetLocks( mhConnect, PChar( strTable ), nil, usConnectNum,
            @astRecordInfo, @usArrayLen, @usSize ) );

   end
   else
      ulRetVal := FILE_NOT_FOUND;

   // if the structure returned is smaller than what we are expecting there will
   // be problems when we try to referrence the values past the end of what was
   // returned.  This is an error condition.  If it is bigger thats ok.
   if ( usSize < sizeof( ADS_MGMT_RECORD_INFO ) ) then
      raise Exception.Create( 'Kayýt bilgileri yapýlarý çok küçük döndü.' );

   // If the file was not found then just continue as if no elements are found
   if ( ulRetVal = FILE_NOT_FOUND ) then
      usArrayLen := 0;


   // Enter code here to sort the array of structures as to whatever
   // criteria is desired.


   // If no elements returned then empty grid and return
   if ( usArrayLen = 0 ) then
   begin
      poGrid.Cells[0,1] := '';

      // Set RowCount to 2 which is 1 for the fixed row which contains the column
      // headers and one for a non fixed empty row.
      poGrid.RowCount := 2;
      exit;
   end
   else
   begin
      // Set RowCount to the array length + 1 for the fixed row which contains the
      // column headers
      poGrid.RowCount := usArrayLen + 1;
   end;

   // If elements are returned then fill up the grid
   for usCount := 0 to usArrayLen - 1 do
   begin
      // If the record number is 0 that means that the file is locked
      if astRecordInfo[usCount].ulRecordNumber = 0 then
         poGrid.Cells[0,usCount+1] := 'File Locked'
      else
      begin
         // Fill the record number into the grid row
         strRecNum := 'Record ' + IntToStr( astRecordInfo[usCount].ulRecordNumber );
         poGrid.Cells[0,usCount+1] := strRecNum;
      end;
   end;
end;

{**********************************************************
*  Module:  TMainForm.RgUserOpenTypeClick
*  Date Created:  11/25/97
*  Last Modified:
*  Input: Sender - Object who called event
*  Output:
*  Return:
*  Description: This is an event when the radio group buttons
*  are switched.  If Indexes was selected, refresh files grid
*  with indexes.  If Tables was selected, refresh files grid
*  with tables.
**********************************************************}
procedure TMgtForm.RgUserOpenTypeClick(Sender: TObject);
begin
   if ( mhConnect = 0 ) then
      exit;

   RefreshIndexAndLocks;
end;

{**********************************************************
*  Module:  TMainForm.RgOpenFileTypeClick
*  Date Created:  11/25/97
*  Last Modified:
*  Input:  Sender - Object who called the event
*  Output:
*  Return:
*  Description: This is an event when the radio group buttons
*  are switched.  If Indexes was selected, refresh files grid
*  with indexes.  If Tables was selected, refresh files grid
*  with tables.
**********************************************************}
procedure TMgtForm.RgOpenFileTypeClick(Sender: TObject);
var
   poFilePath : TServerFilePath;
begin
   if ( mhConnect = 0 ) then
      exit;

   if ( poRgOpenFileType.ItemIndex = 1 ) then
      RefreshConnUserIndexes( poStrGrdOpenFiles, 0, '', '' )
   else
      RefreshConnUserTables( poStrGrdOpenFiles, 0, '' );

   if Assigned( poStrGrdOpenFiles.Objects[1,poStrGrdOpenFiles.Row] ) then
   begin
      poFilePath := poStrGrdOpenFiles.Objects[1,poStrGrdOpenFiles.Row] as TServerFilePath;
      RefreshConnUsers( poStrGrdUserFile, poFilePath.Path, False );
   end
   else
      RefreshConnUsers( poStrGrdUserFile, '', True );

end;

{**********************************************************
*  Module:  TMainForm.ClearAll
*  Date Created:  11/25/97
*  Last Modified:
*  Input: poCurControl - TWinControl that is the control or control
*         group to clear
*  Output:
*  Return:
*  Description:  This procedure will clear all grids and panels within
*  the control passed.  This is a recursive function that will go
*  through the entire set of controls underneath the passed in control
*  and blank them out.
**********************************************************}
procedure TMgtForm.ClearAll( poCurControl : TWinControl );
var
   usTabCount : UNSIGNED16;
   usPanelCount : UNSIGNED16;
   poCurSheet : TTabSheet;
   poPageCtl : TPageControl;
   poCurForm : TForm;
   sCount : SIGNED16;
   poStrGrid : TStringGrid;
   usRow : UNSIGNED16;
   usCol : UNSIGNED16;
begin
   // If the current control is a form control then loop through the controls
   if ( poCurControl is TForm ) then
   begin
      poCurForm := poCurControl as TForm;
      for sCount := 0 to poCurForm.ControlCount - 1 do
      begin
         // recurse the individual controls for clearing
         ClearAll( poCurForm.Controls[sCount] as TWinControl );
      end;
   end;
   // If the current control is a page control then loop through the pages
   if ( poCurControl is TPageControl ) then
   begin
      poPageCtl := poCurControl as TPageControl;
      for usTabCount := 0 to poPageCtl.PageCount - 1 do
      begin
         poCurSheet := poPageCtl.Pages[usTabCount];
         for usPanelCount := 0 to poCurSheet.ControlCount - 1 do
         begin
            // recurse the individual pages for clearing
            ClearAll( poCurSheet.Controls[usPanelCount] as TWinControl );
         end;
      end;
   end;

   // If there is a control that has no more controls below it then exit out and
   // pop back to the previous control
   if ( poCurControl.ControlCount = 0 ) then
      exit;

   // For the current control, clear if panel or grid
   for sCount := 0 to poCurControl.ControlCount - 1 do
   begin
      if ( poCurControl.Controls[sCount] is TPanel ) then
      begin
         ClearAll( poCurControl.Controls[sCount] as TWinControl );
         ( poCurControl.Controls[sCount] as TPanel ).Caption := '';
      end
      else if ( poCurControl.Controls[sCount] is TStringGrid ) then
      begin
         poStrGrid := poCurControl.Controls[sCount] as TStringGrid;
         for usRow := 0 to poStrGrid.RowCount do
         begin
            if ( ( poStrGrid.FixedRows = 1 ) And ( usRow < 1 ) ) then
               continue;
            for usCol := 0 to poStrGrid.ColCount do
            begin
               if ( ( poStrGrid.FixedCols = 1 ) And ( usCol < 1 ) ) then
                  continue;
               poStrGrid.Cells[ usCol, usRow ] := '';
            end;
         end;
      end;
   end;
end;


{**********************************************************
*  Module:  TMainForm.ServerBoxChange
*  Date Created:  11/25/97
*  Last Modified:
*  Input: Sender - object that called the method
*  Output:
*  Return:
*  Description: This will set a flag that will be tested in
*  the connect method as to whether or not the Server Drive has changed.
**********************************************************}
procedure TMgtForm.ServerBoxChange(Sender: TObject);
begin
   bServerBoxChanged := True;
end;

{**********************************************************
*  Module:  TMainForm.RefreshIndexAndLocks
*  Date Created:  11/25/97
*  Last Modified:
*  Input:
*  Output:
*  Return:
*  Description: This refreshes the files grid
*  with indexes or the files grid with tables.
**********************************************************}
procedure TMgtForm.RefreshIndexAndLocks;
begin
   if ( poRgUserOpenType.ItemIndex = 1 ) then
   begin
      poStrGrdOpenLck.Cells[0,0] := '';

      if ( meServerType = stNetWare ) then
         RefreshConnUserIndexes( poStrGrdOpenData,
                                 StrToInt(poStrGrdConUser.Cells[0,poStrGrdConUser.Row]),
                                 '', poStrGrdConUser.Cells[1,poStrGrdConUser.Row])
      else
         RefreshConnUserIndexes( poStrGrdOpenData,
                                 0, '', poStrGrdConUser.Cells[1,poStrGrdConUser.Row]);

      RefreshConnUserLocks( poStrGrdOpenLck, 0, '', '' );
   end
   else
   begin
      poStrGrdOpenLck.Cells[0,0] := 'Kilitli Tablolar';

      if ( meServerType = stNetWare ) then
      begin
         RefreshConnUserTables( poStrGrdOpenData,
                                StrToInt(poStrGrdConUser.Cells[0,poStrGrdConUser.Row]),
                                poStrGrdConUser.Cells[1,poStrGrdConUser.Row]);
         RefreshConnUserLocks(  poStrGrdOpenLck,
                                StrToInt(poStrGrdConUser.Cells[0,poStrGrdConUser.Row]),
                                poStrGrdConUser.Cells[1,poStrGrdConUser.Row],
                                poStrGrdOpenData.Cells[1,poStrGrdOpenData.Row]);
      end
      else
      begin
         RefreshConnUserTables( poStrGrdOpenData,
                                0, poStrGrdConUser.Cells[1,poStrGrdConUser.Row]);
         RefreshConnUserLocks(  poStrGrdOpenLck,
                                0, poStrGrdConUser.Cells[1,poStrGrdConUser.Row],
                                poStrGrdOpenData.Cells[1,poStrGrdOpenData.Row]);
      end;
   end;
end;

{**********************************************************
*  Module:  TMainForm.HelpClick
*  Date Created:  11/25/97
*  Last Modified:
*  Input: Sender - object that called the method
*  Output:
*  Return:
*  Description: This will bring up the help dialog
**********************************************************}
procedure TMgtForm.HelpClick(Sender: TObject);
begin
{$IFDEF WIN32}
   Application.HelpCommand( HELP_FINDER, 0 );
{$ENDIF}
end;

{**********************************************************
*  Module:  TMainForm.poConfigPareCtlChange
*  Date Created:  11/25/97
*  Last Modified:
*  Input:  Sender - Object that called
*  Output:
*  Return:
*  Description: This is the function that will do logic when
*  the tab pages switch.  Mainly used for setting HelpContext.
**********************************************************}
procedure TMgtForm.FormShow(Sender: TObject);
begin
   Timer1.Interval := 1000 * 5;//( MainForm.EnvSettingsReg.GetItem( 'Remote - Refresh', varInteger, 3 ) );
   cbServer.SetFocus;
   poMainPage.ActivePage := DataInfo;

end;

procedure TMgtForm.AddServerToReg(strServer: string);
var
   astrServers : TStringList;
   i           : integer;
begin
   {* get the current server list from the registry *}
   astrServers := TStringList.Create;
   if not assigned( astrServers ) then
      exit;

   try
      for i := 0 to 4 do
      begin
         //astrServers.Add( UpperCase( oMgtRegistry.GetItem( 'server' + IntToStr(i), varString, '' ) ) );
      end;

      {* remove all of the blank entries *}
      i := astrServers.IndexOf( '' );
      while ( i <> -1 ) do
      begin
         astrServers.Delete( i );
         i := astrServers.IndexOf( '' );
      end;

      {*
       * If the server is in the list delete, so it is added to the front of
       * the list.
       *}
      i := astrServers.IndexOf( UpperCase( strServer ) );
      if ( i <> -1 ) then
         astrServers.Delete( i );

      {*
       * Delete anything over 4 servers. The list is read in in reverse order, which
       * makes maintaining the order very easy.
       *}
      while ( astrServers.Count >= 5 ) do
      begin
         {* delete the last entry *}
         astrServers.Delete( 0 );
      end;

      {* add the new one *}
      astrServers.Add( strServer );

      {* now write the list to the registry *}
     // for i := 0 to astrServers.Count - 1  do
        // oMgtRegistry.PutItem( 'server' + IntToStr(i), astrServers.Strings[i] );

   finally
      astrServers.Free;
   end;

end;



procedure TMgtForm.PopulateServerList;
begin
  cbServer.Items.Text := ReadRegKey('ManagedServers');
end;

procedure TMgtForm.cbServerClick(Sender: TObject);
begin
   bServerBoxChanged := True;
   // fire the connect button click event
   //sbConnectServerClick(Sender);
end;


{**********************************************************
*  Module:  TMgtForm.DisconUserClick
*  Date Created:  2/1/2000
*  Last Modified:
*  Input:  Sender - Object that called
*  Output:
*  Return:
*  Description: This will disconnect the chosen user from
*               the connection list through the popup menu.
**********************************************************}
procedure TMgtForm.DisconUserClick(Sender: TObject);
var
     strConnection: string;
     strUser:       string;
begin
     strConnection := poStrGrdConUser.Rows[ poStrGrdConUser.Row ].Strings[ 0 ];
     strUser       := poStrGrdConUser.Rows[ poStrGrdConUser.Row ].Strings[ 1 ];

     if( ( strConnection <> '' ) and ( strConnection <> '0' ) ) then
         ACE.AdsMgKillUser( mhConnect, NIL, StrToInt( strConnection ) )
     else if( strUser <> '' ) then
         ACE.AdsMgKillUser( mhConnect, PChar( strUser ), 0 );
end;


{**********************************************************
*  Module:  TMgtForm.pmDisconUserPopup
*  Date Created:  2/1/2000
*  Last Modified:
*  Input:  Sender - Object that called
*  Output:
*  Return:
*  Description: Created to make the Disconnect User popup
*               menu look nicer and display the Username
*               and connection number (if applicable) to
*               reduce erronious disconnects.
**********************************************************}
procedure TMgtForm.pmDisconUserPopup(Sender: TObject);
var
     strConnection: string;
     strUser:       string;
begin
     strConnection := poStrGrdConUser.Rows[ poStrGrdConUser.Row ].Strings[ 0 ];
     strUser       := poStrGrdConUser.Rows[ poStrGrdConUser.Row ].Strings[ 1 ];

     pmDisconUser.Items[ 0 ].Caption := 'Kullanýcýnýn baðlantýsýný kes:';

     if( strUser <> '' ) then
     begin
         pmDisconUser.Items[ 0 ].Enabled := True;

         pmDisconUser.Items[ 0 ].Caption := pmDisconUser.Items[ 0 ].Caption +
                             ' ' + strUser;
         if( strConnection <> '' ) then
              pmDisconUser.Items[ 0 ].Caption :=
                                  pmDisconUser.Items[ 0 ].Caption + ' ( ' +
                                  strConnection + ' )';
     end
     else
     begin
         pmDisconUser.Items[ 0 ].Enabled := False;
     end;
end;


{**********************************************************
*  Module:  TMgtForm.poStrGrdConUserMouseDown
*  Date Created:  2/1/2000
*  Last Modified:
*  Input:  Sender - Object that called
*  Output:
*  Return:
*  Description: Adds the ability for the user to right
*               click on a user to select it before the
*               Disconnect User popup menu appears.
**********************************************************}
procedure TMgtForm.poStrGrdConUserMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   lTemp: LongInt;
   lHeight: Integer;
   lRow: LongInt;
   lCurrRow: LongInt;
begin
     lHeight  := 0;
     lRow     := 0;
     lCurrRow := poStrGrdConUser.TopRow;  { Top visible non-fixed row }

     { Calculate the height of the fixed rows, always add one for the
       border pixel }
     for lTemp := 0 to poStrGrdConUser.FixedRows - 1 do
         lHeight := lHeight + poStrGrdConUser.RowHeights[ lTemp ] + 1;

     { Loop through all visible rows comparing the position of the row to
       the height of our click to find the correct row. Start lCurrRow at
       the top of the visible rows. }
     while ( ( lRow = 0 ) and ( lHeight <= poStrGrdConUser.Height ) ) do
     begin
         { Determine if our click height is within the row }
         if ( ( ( Y - lHeight ) > 0 ) and ( ( Y - lHeight ) <
               poStrGrdConUser.RowHeights[ lCurrRow ] ) ) then
             lRow := lCurrRow;

         { Update our comparison height and row number for the next row }
         lHeight := lHeight +
                 poStrGrdConUser.RowHeights[ lCurrRow ] + 1;

         Inc( lCurrRow );
      end;

     { Select the clicked row if one was found at our height }
     if ( ( lRow > 0 ) and
        ( lRow < poStrGrdConUser.RowCount) ) then
          poStrGrdConUser.Row := lRow;
end;


{*******************************************************************************
*  Module: TMgtForm.InitializeHelp
*  Date:   24-Jul-2002
*  Input:  None
*  Output: None
*  Description: Intialize help file contexts.
*******************************************************************************}
procedure TMgtForm.InitializeHelp;
begin

{$IFDEF WIN32}

{$ENDIF}

end;

end.
