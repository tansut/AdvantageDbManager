unit UAutoInc;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UAdsTable, StdCtrls, AdsData;

type
  TFmAutoInc = class(TForm)
    BtnOK: TButton;
    BtnCancel: TButton;
    GroupBox1: TGroupBox;
    LblTable: TLabel;
    GroupBox2: TGroupBox;
    CmbField: TComboBox;
    Label4: TLabel;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    EdValue: TEdit;
    procedure BtnOKClick(Sender: TObject);
  private
    FAdsTable: TDBAdsTable;
    procedure Validate;
  public
    function Execute(AAdsTable: TDBAdsTable): Boolean;
  end;

var
  FmAutoInc: TFmAutoInc;

implementation



{$R *.dfm}

{ TFmAutoInc }

procedure ConvertIntToAutoInc( strFileName,
                               strField: string;
                               i64NextAutoIncValue: Int64 );

var
   ADTFile: TFileStream;
   wColType,
   wColCount: word;
   iColNum : integer;
   btOption: byte;
   aucColName: array [ 0..128 ] of char;
   bColFound: boolean;

begin
   ADTFile := nil;

   try
      //open file exclusively
      ADTFile := TFileStream.Create( strFileName,
                                     fmOpenReadWrite or fmShareExclusive );



      //Seek to last auto inc value position.
      ADTFile.Seek( 80, soFromBeginning );

      //write the next auto inc value
      ADTFile.Write(  i64NextAutoIncValue, SizeOf( i64NextAutoIncValue ) );


      //read the existing option
      ADTFile.Seek( 88, soFromBeginning );
      ADTFile.Read( btOption, SizeOf( btOption ) );

      //write the AI option
      ADTFile.Seek( 88, soFromBeginning );
      if( btOption = 0 ) or
        ( btOption = 1 ) or
        ( btOption = 4) or
        ( btOption = 5 ) then
      begin
         btOption := btOption + 2;
         ADTFile.Write(  btOption, SizeOf( btOption ) );
      end;

      //read in the number of columns
      ADTFile.Seek( 358, soFromBeginning );
      ADTFile.Read( wColCount, SizeOf( wColCount ) );


      //find the field and change the type to auto inc.
      bColFound := false;
      for iColNum := 0 to wColCount - 1 do
      begin
         ADTFile.Seek( 400 + ( iColNum * 200 ), soFromBeginning );
         ADTFile.Read( aucColName, 129 );
         if( UpperCase( aucColName ) = UpperCase( strField ) ) then
         begin

            //found the field, now change type to autoinc
            ADTFile.Read( wColType, SizeOf( wColType ) );
            if( wColType <> $B ) and (wColType <> 15) then
               raise Exception.Create( 'Alan: ' + strField + ' integer deðil.' )

            else
            begin
               ADTFile.Seek( -2, soFromCurrent );
               wColType := $F;
               ADTFile.Write( wColType, SizeOf( wColType ) );
               bColFound := true;
               break;
            end;
         end;
      end;

      if( not bColFound ) then
         raise Exception.Create( 'Alan: ' + strField + ' bulunamadý' );

   finally
      ADTFile.Free();
   end;

end;


function TFmAutoInc.Execute(AAdsTable: TDBAdsTable): Boolean;
var I: Integer;
    List: TStringList;
begin
  FAdsTable := AAdsTable;
  List := TStringList.Create;
  try
    FAdsTable.Dictionary.GetFieldNames(FAdsTable.Name, List);
    for I := 0 to List.Count - 1 do
      CmbField.Items.Add(List[i]);
  finally
    List.Free;
  end;
  LblTable.Caption := FAdsTable.Name;
  Result := ShowModal = mrOK;
end;

procedure TFmAutoInc.BtnOKClick(Sender: TObject);
var TablePath: string;
begin
  Validate;
  TablePath := FAdsTable.TablePath;
  try
   FAdsTable.Dictionary.RemoveTable(FAdsTable.Name, False);
  except
   on E: Exception do raise Exception.Create('Tablo sözlükten çýkartýlamadý. '#13#10 + E.Message);
  end;

  try
    ConvertIntToAutoInc(TablePath, CmbField.Items[CmbField.ItemIndex], StrToInt(EdValue.Text));
    try
      FAdsTable.Dictionary.AddTable(FAdsTable.Name, TablePath, '', '', ttAdsADT, ANSI );
    except
      on E: Exception do
      begin
        ShowMessage('Ýþlem baþarýlý ancak sözlükten çýkartýlan tablo tekrar sözlüðe eklenemedi. Lütfen manuel olarak ekleyiniz.'#13#10 + E.Message);
        Exit;
      end;
    end;
  except
    on E: Exception do
    begin
      ShowMessage('Ýþlem baþarýsýz.'#13#10 + E.Message);
      try
        FAdsTable.Dictionary.AddTable(FAdsTable.Name, TablePath, '', '', ttAdsADT, ANSI );
      except
        on E: Exception do
        begin
          ShowMessage('Sözlükten çýkartýlan tablo tekrar sözlüðe eklenemedi. '#13#10 + E.Message);
          Exit;
        end;
      end;
      Exit;
    end;
  end;
  ModalResult := mrOK;
end;

procedure TFmAutoInc.Validate;
begin
  if CmbField.ItemIndex = -1 then
   raise Exception.Create('Lütfen otomatik artan sayýya dönüþtürülecek alan seçiniz');
  try
    StrToInt(EdValue.Text);
  except
    raise Exception.Create('Lütfen geçerli bir sayý giriniz');
  end;


end;

end.
