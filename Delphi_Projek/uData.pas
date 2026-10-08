{******************************************************************************
  Projeknaam : EduBoek Voorraad- en Verkoopsbestuurstelsel
  Leerder    : Andre du Preez
  Graad      : 11
  Vak        : Inligtingstegnologie
  Jaar       : 2026
  Eenheid    : uData.pas
  Doel       : Sentrale Access/ADO-datamodule en databasisopstelling.
  Weergawe   : 1.5.0

  Nota:
  Elke prosedure en funksie bevat kommentaar om die kode se doel en werking
  tydens die PAT-onderhoud duidelik te kan verduidelik.
******************************************************************************}

unit uData;

interface

uses
  System.SysUtils, System.Classes, System.Variants, Data.DB,
  Data.Win.ADODB;

type
  TdmData = class(TDataModule)
    conBoekwinkel: TADOConnection;
    qryBoeke: TADOQuery;
    qryVerkope: TADOQuery;
    qryWerk: TADOQuery;
    dsBoeke: TDataSource;
    dsVerkope: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FDatabasisPad: string;
    procedure SkepDatabasisIndienNodig;
    procedure SkepTabelleEnVoorbeeldData;
    procedure KonfigureerNavrae;
  public
    procedure KoppelDatabasis;
    procedure VerfrisBoeke(const sSoek: string = '');
    function BoekKodeBestaan(const sBoekKode: string;
      const iIgnoreerBoekID: Integer = 0): Boolean;
    function TelVerkopeVirBoek(const iBoekID: Integer): Integer;
    function TelLaeVoorraad: Integer;
    function DatabasisPad: string;
  end;

var
  dmData: TdmData;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  System.Win.ComObj, Vcl.Forms, Vcl.Dialogs, uGemeenskaplik;

procedure TdmData.DataModuleCreate(Sender: TObject);
begin
  // Stel die databasisgids op, skep die Access-databasis indien nodig en koppel ADO.
  ForceDirectories(DataPad);
  ForceDirectories(VerslagPad);
  FDatabasisPad := DataPad + 'Boekwinkel.mdb';

  try
    SkepDatabasisIndienNodig;
    KoppelDatabasis;
    KonfigureerNavrae;
    VerfrisBoeke;
  except
    on E: Exception do
    begin
      WysBoodskap(
        'Die databasis kon nie voorberei of gekoppel word nie.' + sLineBreak +
        'Maak seker die program word as Win32 gebou en dat Microsoft Jet/Access beskikbaar is.' +
        sLineBreak + sLineBreak + 'Tegniese besonderhede: ' + E.Message,
        mtError);
      raise;
    end;
  end;
end;

procedure TdmData.DataModuleDestroy(Sender: TObject);
begin
  // Sluit alle aktiewe navrae en die verbinding veilig wanneer die program eindig.
  if qryBoeke.Active then
    qryBoeke.Close;
  if qryVerkope.Active then
    qryVerkope.Close;
  if qryWerk.Active then
    qryWerk.Close;
  if conBoekwinkel.Connected then
    conBoekwinkel.Close;
end;

procedure TdmData.SkepDatabasisIndienNodig;
begin
  // Skep 'n nuwe Access .mdb-lêer slegs wanneer dit nog nie bestaan nie.
  if not FileExists(FDatabasisPad) then
    SkepTabelleEnVoorbeeldData;
end;

procedure TdmData.SkepTabelleEnVoorbeeldData;
var
  vCatalog: OleVariant;
  vConnection: OleVariant;
  sVerbinder: string;
begin
  // Gebruik ADOX/ADO via COM om die Access-databasis, tabelle en voorbeelddata te skep.
  sVerbinder := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=' +
    FDatabasisPad + ';Jet OLEDB:Engine Type=5;';

  vCatalog := CreateOleObject('ADOX.Catalog');
  vCatalog.Create(sVerbinder);
  vCatalog := Unassigned;

  vConnection := CreateOleObject('ADODB.Connection');
  vConnection.Open(sVerbinder);
  try
    vConnection.Execute(
      'CREATE TABLE tblBoeke (' +
      'BoekID COUNTER CONSTRAINT pkBoeke PRIMARY KEY, ' +
      'BoekKode TEXT(10) NOT NULL, ' +
      'Titel TEXT(80) NOT NULL, ' +
      'Graad INTEGER NOT NULL, ' +
      'Vak TEXT(30) NOT NULL, ' +
      'Kategorie TEXT(30) NOT NULL, ' +
      'Prys CURRENCY NOT NULL, ' +
      'VoorraadHoeveelheid INTEGER NOT NULL, ' +
      'MinimumVoorraad INTEGER NOT NULL, ' +
      'Aktief YESNO NOT NULL)');

    vConnection.Execute(
      'CREATE UNIQUE INDEX idxBoekKode ON tblBoeke (BoekKode)');

    vConnection.Execute(
      'CREATE TABLE tblVerkope (' +
      'VerkoopID COUNTER CONSTRAINT pkVerkope PRIMARY KEY, ' +
      'BoekID LONG NOT NULL, ' +
      'VerkoopDatum DATETIME NOT NULL, ' +
      'Hoeveelheid INTEGER NOT NULL, ' +
      'EenheidsPrys CURRENCY NOT NULL, ' +
      'GebruikerRol TEXT(20) NOT NULL)');

    vConnection.Execute(
      'ALTER TABLE tblVerkope ADD CONSTRAINT fkVerkopeBoeke ' +
      'FOREIGN KEY (BoekID) REFERENCES tblBoeke (BoekID)');

    vConnection.Execute(
      'INSERT INTO tblBoeke ' +
      '(BoekKode,Titel,Graad,Vak,Kategorie,Prys,VoorraadHoeveelheid,MinimumVoorraad,Aktief) ' +
      'VALUES (''IT11'',''IT Delphi Gr 11'',11,''Inligtingstegnologie'',''Handboek'',340,12,5,True)');
    vConnection.Execute(
      'INSERT INTO tblBoeke ' +
      '(BoekKode,Titel,Graad,Vak,Kategorie,Prys,VoorraadHoeveelheid,MinimumVoorraad,Aktief) ' +
      'VALUES (''WIS10'',''Wiskunde Gr 10'',10,''Wiskunde'',''Werkboek'',285,2,5,True)');
    vConnection.Execute(
      'INSERT INTO tblBoeke ' +
      '(BoekKode,Titel,Graad,Vak,Kategorie,Prys,VoorraadHoeveelheid,MinimumVoorraad,Aktief) ' +
      'VALUES (''AFR11'',''Afrikaans Huistaal Gr 11'',11,''Afrikaans'',''Handboek'',210,18,4,True)');
    vConnection.Execute(
      'INSERT INTO tblBoeke ' +
      '(BoekKode,Titel,Graad,Vak,Kategorie,Prys,VoorraadHoeveelheid,MinimumVoorraad,Aktief) ' +
      'VALUES (''ENG08'',''English FAL Gr 8'',8,''Engels'',''Leesboek'',195,4,5,True)');
  finally
    vConnection.Close;
    vConnection := Unassigned;
  end;
end;

procedure TdmData.KoppelDatabasis;
begin
  // Koppel die sentrale ADOConnection aan die plaaslike Access-databasis.
  if conBoekwinkel.Connected then
    conBoekwinkel.Close;

  conBoekwinkel.LoginPrompt := False;
  conBoekwinkel.ConnectionString :=
    'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=' + FDatabasisPad +
    ';Persist Security Info=False;';
  conBoekwinkel.Open;
end;

procedure TdmData.KonfigureerNavrae;
begin
  // Koppel alle navrae aan dieselfde sentrale verbinding en databronne.
  qryBoeke.Connection := conBoekwinkel;
  qryVerkope.Connection := conBoekwinkel;
  qryWerk.Connection := conBoekwinkel;
  dsBoeke.DataSet := qryBoeke;
  dsVerkope.DataSet := qryVerkope;
end;

procedure TdmData.VerfrisBoeke(const sSoek: string = '');
var
  sSQL, sPatroon: string;
begin
  // Laai alle boeke of filter volgens boekkode/titel met twee invoerparameters.
  qryBoeke.Close;
  qryBoeke.ParamCheck := True;
  sSQL := 'SELECT * FROM tblBoeke';

  if Trim(sSoek) <> '' then
    sSQL := sSQL + ' WHERE BoekKode LIKE :SoekKode OR Titel LIKE :SoekTitel';

  sSQL := sSQL + ' ORDER BY Titel';
  // Voltooi die SQL voordat waardes ingevul word: SQL-veranderinge kan
  // ADO se parameterlys herskep. Elke plek kry ook sy eie parameternaam.
  qryBoeke.SQL.Text := sSQL;

  if Trim(sSoek) <> '' then
  begin
    sPatroon := '%' + Trim(sSoek) + '%';
    qryBoeke.Parameters.ParamByName('SoekKode').Direction := pdInput;
    qryBoeke.Parameters.ParamByName('SoekKode').DataType := ftWideString;
    qryBoeke.Parameters.ParamByName('SoekKode').Size := Length(sPatroon);
    qryBoeke.Parameters.ParamByName('SoekKode').Value := sPatroon;
    qryBoeke.Parameters.ParamByName('SoekTitel').Direction := pdInput;
    qryBoeke.Parameters.ParamByName('SoekTitel').DataType := ftWideString;
    qryBoeke.Parameters.ParamByName('SoekTitel').Size := Length(sPatroon);
    qryBoeke.Parameters.ParamByName('SoekTitel').Value := sPatroon;
  end;

  qryBoeke.Open;
end;

function TdmData.BoekKodeBestaan(const sBoekKode: string;
  const iIgnoreerBoekID: Integer = 0): Boolean;
begin
  // Toets of 'n boekkode reeds bestaan; die huidige rekord kan tydens wysiging geïgnoreer word.
  qryWerk.Close;
  qryWerk.SQL.Text :=
    'SELECT COUNT(*) AS Telling FROM tblBoeke ' +
    'WHERE UCASE(BoekKode)=UCASE(:BoekKode) AND BoekID<>:BoekID';
  qryWerk.Parameters.ParamByName('BoekKode').Value := Trim(sBoekKode);
  qryWerk.Parameters.ParamByName('BoekID').Value := iIgnoreerBoekID;
  qryWerk.Open;
  Result := qryWerk.FieldByName('Telling').AsInteger > 0;
  qryWerk.Close;
end;

function TdmData.TelVerkopeVirBoek(const iBoekID: Integer): Integer;
begin
  // Tel verwante verkope om te besluit of 'n boek veilig uitgevee kan word.
  qryWerk.Close;
  qryWerk.SQL.Text :=
    'SELECT COUNT(*) AS Telling FROM tblVerkope WHERE BoekID=:BoekID';
  qryWerk.Parameters.ParamByName('BoekID').Value := iBoekID;
  qryWerk.Open;
  Result := qryWerk.FieldByName('Telling').AsInteger;
  qryWerk.Close;
end;

function TdmData.TelLaeVoorraad: Integer;
begin
  // Gee die aantal aktiewe boeke op of onder minimum voorraad terug.
  qryWerk.Close;
  qryWerk.SQL.Text :=
    'SELECT COUNT(*) AS Telling FROM tblBoeke ' +
    'WHERE Aktief=True AND VoorraadHoeveelheid<=MinimumVoorraad';
  qryWerk.Open;
  Result := qryWerk.FieldByName('Telling').AsInteger;
  qryWerk.Close;
end;

function TdmData.DatabasisPad: string;
begin
  // Maak die databasisligging beskikbaar vir statusboodskappe en dokumentasie.
  Result := FDatabasisPad;
end;

end.
