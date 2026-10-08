{******************************************************************************
  Projeknaam : EduBoek Voorraad- en Verkoopsbestuurstelsel
  Leerder    : Andre du Preez
  Graad      : 11
  Vak        : Inligtingstegnologie
  Jaar       : 2026
  Eenheid    : uVerslae.pas
  Doel       : Lae voorraad-, verkoops- en kategorieverslae plus tekslêers.
  Weergawe   : 1.5.0

  Nota:
  Elke prosedure en funksie bevat kommentaar om die kode se doel en werking
  tydens die PAT-onderhoud duidelik te kan verduidelik.
******************************************************************************}

unit uVerslae;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TfrmVerslae = class(TForm)
    pnlKop: TPanel;
    lblTitel: TLabel;
    lblSubtitel: TLabel;
    btnLaeVoorraad: TButton;
    btnVerkoopsOpsomming: TButton;
    btnKategorieOpsomming: TButton;
    btnSkryfTeksleer: TButton;
    btnOpenGids: TButton;
    btnMaakSkoon: TButton;
    btnTerug: TButton;
    redVerslag: TRichEdit;
    pnlStatus: TPanel;
    lblStatus: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnLaeVoorraadClick(Sender: TObject);
    procedure btnVerkoopsOpsommingClick(Sender: TObject);
    procedure btnKategorieOpsommingClick(Sender: TObject);
    procedure btnSkryfTeksleerClick(Sender: TObject);
    procedure btnOpenGidsClick(Sender: TObject);
    procedure btnMaakSkoonClick(Sender: TObject);
    procedure btnTerugClick(Sender: TObject);
  private
    sLaasteVerslagTipe: string;
    procedure VoegVerslagKopBy(const sOpskrif: string);
    procedure GenereerLaeVoorraadVerslag;
    procedure GenereerVerkoopsOpsomming;
    procedure GenereerKategorieOpsomming;
    procedure SkryfGeskiedenis(const sLêernaam: string);
  public
  end;

implementation

{$R *.dfm}

uses
  Winapi.ShellAPI, Data.DB, Data.Win.ADODB, uData, uGemeenskaplik;

procedure TfrmVerslae.FormCreate(Sender: TObject);
begin
  WysFormKonteks(Self, lblSubtitel, 'EduBoek - Verslae');
  // Berei die uitvoerarea en verslaggids voor wanneer die form oopmaak.
  ForceDirectories(VerslagPad);
  redVerslag.Clear;
  sLaasteVerslagTipe := '';
  lblStatus.Caption := 'Status: Kies ’n verslag om te genereer.';
end;

procedure TfrmVerslae.VoegVerslagKopBy(const sOpskrif: string);
begin
  // Voeg 'n konsekwente opskrif, datum en skeidslyn by elke verslag.
  redVerslag.Clear;
  redVerslag.Lines.Add(UpperCase(sOpskrif));
  redVerslag.Lines.Add('EduBoek Skoolboekwinkel');
  redVerslag.Lines.Add('Datum: ' + FormatDateTime('dd mmmm yyyy', Date));
  redVerslag.Lines.Add(StringOfChar('-', 78));
  redVerslag.Lines.Add('');
end;

procedure TfrmVerslae.GenereerLaeVoorraadVerslag;
var
  qryVerslag: TADOQuery;
  iTelling: Integer;
begin
  // Lees boeke op of onder minimum voorraad en vertoon dit as 'n besluitnemingsverslag.
  VoegVerslagKopBy('Lae voorraadverslag');
  redVerslag.Lines.Add(Format('%-12s %-38s %10s %10s',
    ['Boekkode', 'Titel', 'Voorraad', 'Minimum']));
  redVerslag.Lines.Add(StringOfChar('-', 78));

  qryVerslag := TADOQuery.Create(nil);
  try
    qryVerslag.Connection := dmData.conBoekwinkel;
    qryVerslag.SQL.Text :=
      'SELECT BoekKode,Titel,VoorraadHoeveelheid,MinimumVoorraad ' +
      'FROM tblBoeke WHERE Aktief=True AND ' +
      'VoorraadHoeveelheid<=MinimumVoorraad ORDER BY Titel';
    qryVerslag.Open;

    iTelling := 0;
    while not qryVerslag.Eof do
    begin
      redVerslag.Lines.Add(Format('%-12s %-38s %10d %10d', [
        qryVerslag.FieldByName('BoekKode').AsString,
        Copy(qryVerslag.FieldByName('Titel').AsString, 1, 38),
        qryVerslag.FieldByName('VoorraadHoeveelheid').AsInteger,
        qryVerslag.FieldByName('MinimumVoorraad').AsInteger]));
      Inc(iTelling);
      qryVerslag.Next;
    end;

    redVerslag.Lines.Add('');
    redVerslag.Lines.Add('Totaal lae voorraad-items: ' + IntToStr(iTelling));
    if iTelling = 0 then
      redVerslag.Lines.Add('Geen items benodig tans herbestelling nie.');
  finally
    qryVerslag.Free;
  end;

  sLaasteVerslagTipe := 'LaeVoorraadVerslag';
  lblStatus.Caption := 'Status: Lae voorraadverslag is gereed.';
end;

procedure TfrmVerslae.GenereerVerkoopsOpsomming;
var
  qryVerslag: TADOQuery;
  cGrootTotaal: Currency;
  iAantal: Integer;
begin
  // Som verkope per boek op en bereken die totale inkomste uit databasisdata.
  VoegVerslagKopBy('Verkoopsopsomming');
  redVerslag.Lines.Add(Format('%-12s %-34s %10s %15s',
    ['Boekkode', 'Titel', 'Aantal', 'Totale waarde']));
  redVerslag.Lines.Add(StringOfChar('-', 78));

  qryVerslag := TADOQuery.Create(nil);
  try
    qryVerslag.Connection := dmData.conBoekwinkel;
    qryVerslag.SQL.Text :=
      'SELECT B.BoekKode, B.Titel, SUM(V.Hoeveelheid) AS Aantal, ' +
      'SUM(V.Hoeveelheid*V.EenheidsPrys) AS TotaleWaarde ' +
      'FROM tblBoeke B INNER JOIN tblVerkope V ON B.BoekID=V.BoekID ' +
      'GROUP BY B.BoekKode, B.Titel ORDER BY B.Titel';
    qryVerslag.Open;

    cGrootTotaal := 0;
    iAantal := 0;
    while not qryVerslag.Eof do
    begin
      redVerslag.Lines.Add(Format('%-12s %-34s %10d %15s', [
        qryVerslag.FieldByName('BoekKode').AsString,
        Copy(qryVerslag.FieldByName('Titel').AsString, 1, 34),
        qryVerslag.FieldByName('Aantal').AsInteger,
        FormateerGeldeenheid(qryVerslag.FieldByName('TotaleWaarde').AsCurrency)]));
      Inc(iAantal, qryVerslag.FieldByName('Aantal').AsInteger);
      cGrootTotaal := cGrootTotaal +
        qryVerslag.FieldByName('TotaleWaarde').AsCurrency;
      qryVerslag.Next;
    end;

    redVerslag.Lines.Add('');
    redVerslag.Lines.Add('Totale boeke verkoop: ' + IntToStr(iAantal));
    redVerslag.Lines.Add('Totale verkoopswaarde: ' +
      FormateerGeldeenheid(cGrootTotaal));

    if iAantal = 0 then
      redVerslag.Lines.Add('Geen verkope is nog vasgelê nie.');
  finally
    qryVerslag.Free;
  end;

  sLaasteVerslagTipe := 'VerkoopsOpsomming';
  lblStatus.Caption := 'Status: Verkoopsopsomming is gereed.';
end;

procedure TfrmVerslae.GenereerKategorieOpsomming;
var
  qryBoeke: TADOQuery;
  iKategorie: Integer;
  iAantalTitels: Integer;
  iVoorraad: Integer;
  cWaarde: Currency;
begin
  // Gebruik geneste lusse: elke kategorie word vergelyk met elke aktiewe boekrekord.
  VoegVerslagKopBy('Kategorie-opsomming');
  redVerslag.Lines.Add(Format('%-20s %12s %15s %18s',
    ['Kategorie', 'Titels', 'Voorraad', 'Voorraadwaarde']));
  redVerslag.Lines.Add(StringOfChar('-', 78));

  qryBoeke := TADOQuery.Create(nil);
  try
    qryBoeke.Connection := dmData.conBoekwinkel;
    qryBoeke.SQL.Text :=
      'SELECT Kategorie,Prys,VoorraadHoeveelheid FROM tblBoeke WHERE Aktief=True';
    qryBoeke.Open;

    for iKategorie := Low(arrKategoriee) to High(arrKategoriee) do
    begin
      iAantalTitels := 0;
      iVoorraad := 0;
      cWaarde := 0;

      qryBoeke.First;
      while not qryBoeke.Eof do
      begin
        if SameText(qryBoeke.FieldByName('Kategorie').AsString,
          arrKategoriee[iKategorie]) then
        begin
          Inc(iAantalTitels);
          Inc(iVoorraad,
            qryBoeke.FieldByName('VoorraadHoeveelheid').AsInteger);
          cWaarde := cWaarde +
            (qryBoeke.FieldByName('Prys').AsCurrency *
            qryBoeke.FieldByName('VoorraadHoeveelheid').AsInteger);
        end;
        qryBoeke.Next;
      end;

      redVerslag.Lines.Add(Format('%-20s %12d %15d %18s', [
        arrKategoriee[iKategorie], iAantalTitels, iVoorraad,
        FormateerGeldeenheid(cWaarde)]));
    end;
  finally
    qryBoeke.Free;
  end;

  sLaasteVerslagTipe := 'KategorieOpsomming';
  lblStatus.Caption := 'Status: Kategorie-opsomming is gereed.';
end;

procedure TfrmVerslae.SkryfGeskiedenis(const sLêernaam: string);
var
  fGeskiedenis: TextFile;
  sPad: string;
begin
  // Voeg 'n eenvoudige ouditlyn by 'n tekslêer sonder om vorige geskiedenis uit te vee.
  sPad := VerslagPad + 'VerslagGeskiedenis.txt';
  AssignFile(fGeskiedenis, sPad);
  try
    if FileExists(sPad) then
      Append(fGeskiedenis)
    else
      Rewrite(fGeskiedenis);
    Writeln(fGeskiedenis, FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) +
      ' | ' + sAktieweGebruiker + ' | ' + ExtractFileName(sLêernaam));
  finally
    CloseFile(fGeskiedenis);
  end;
end;

procedure TfrmVerslae.btnLaeVoorraadClick(Sender: TObject);
begin
  // Genereer die lae voorraadverslag uit die Access-databasis.
  GenereerLaeVoorraadVerslag;
end;

procedure TfrmVerslae.btnVerkoopsOpsommingClick(Sender: TObject);
begin
  // Genereer 'n verkoopsopsomming met totale hoeveelheid en waarde.
  GenereerVerkoopsOpsomming;
end;

procedure TfrmVerslae.btnKategorieOpsommingClick(Sender: TObject);
begin
  // Genereer die geneste-lus kategorie-opsomming.
  GenereerKategorieOpsomming;
end;

procedure TfrmVerslae.btnSkryfTeksleerClick(Sender: TObject);
var
  sLêernaam: string;
  lstVerslagTeks: TStringList;
begin
  // Skryf die huidige RichEdit-uitvoer na 'n unieke datum-/tydgestempelde tekslêer.
  if Trim(redVerslag.Text) = '' then
  begin
    WysBoodskap('Genereer eers ’n verslag voordat dit gestoor word.', mtWarning);
    Exit;
  end;

  if sLaasteVerslagTipe = '' then
    sLaasteVerslagTipe := 'Verslag';

  sLêernaam := VerslagPad + sLaasteVerslagTipe + '_' +
    FormatDateTime('yyyymmdd_hhnnss', Now) + '.txt';

  try
    // Kopieer die sigbare teks na TStringList sodat geen RTF-opmaakkodes
    // in die .txt-lêer beland nie; UTF-8 bewaar die Afrikaanse karakters.
    lstVerslagTeks := TStringList.Create;
    try
      lstVerslagTeks.Assign(redVerslag.Lines);
      lstVerslagTeks.SaveToFile(sLêernaam, TEncoding.UTF8);
    finally
      lstVerslagTeks.Free;
    end;
    SkryfGeskiedenis(sLêernaam);
    lblStatus.Caption := 'Status: Verslag gestoor as ' + ExtractFileName(sLêernaam);
    WysBoodskap('Die verslag is suksesvol gestoor:' + sLineBreak + sLêernaam);
  except
    on E: Exception do
      WysBoodskap('Die tekslêer kon nie geskryf word nie: ' + E.Message, mtError);
  end;
end;

procedure TfrmVerslae.btnOpenGidsClick(Sender: TObject);
begin
  // Maak die verslaggids in Windows Explorer oop vir maklike toegang tot uitvoerlêers.
  ForceDirectories(VerslagPad);
  ShellExecute(Handle, 'open', PChar(VerslagPad), nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmVerslae.btnMaakSkoonClick(Sender: TObject);
begin
  // Maak die uitvoerarea skoon sonder om enige gestoorde verslaglêers te verwyder.
  redVerslag.Clear;
  sLaasteVerslagTipe := '';
  lblStatus.Caption := 'Status: Verslagarea is skoongemaak.';
end;

procedure TfrmVerslae.btnTerugClick(Sender: TObject);
begin
  // Sluit die verslagform en keer terug na die hoofmenu.
  Close;
end;

end.
