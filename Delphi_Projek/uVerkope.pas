{******************************************************************************
  Projeknaam : EduBoek Voorraad- en Verkoopsbestuurstelsel
  Leerder    : Andre du Preez
  Graad      : 11
  Vak        : Inligtingstegnologie
  Jaar       : 2026
  Eenheid    : uVerkope.pas
  Doel       : Verkoopstransaksies, berekeninge en voorraadvermindering.
  Weergawe   : 1.5.0

  Nota:
  Elke prosedure en funksie bevat kommentaar om die kode se doel en werking
  tydens die PAT-onderhoud duidelik te kan verduidelik.
******************************************************************************}

unit uVerkope;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmVerkope = class(TForm)
    pnlKop: TPanel;
    lblTitel: TLabel;
    lblSubtitel: TLabel;
    lblInstruksie: TLabel;
    lblBoek: TLabel;
    cmbBoek: TComboBox;
    lblEenheidsPrys: TLabel;
    lblPrysWaarde: TLabel;
    lblBeskikbaar: TLabel;
    lblBeskikbaarWaarde: TLabel;
    lblHoeveelheid: TLabel;
    edtHoeveelheid: TEdit;
    pnlTotaal: TPanel;
    lblTotaalOpskrif: TLabel;
    lblTotaal: TLabel;
    btnBereken: TButton;
    btnStoorVerkoop: TButton;
    btnMaakSkoon: TButton;
    btnTerug: TButton;
    pnlBesonderhede: TPanel;
    lblBesonderhede: TLabel;
    memBesonderhede: TMemo;
    pnlStatus: TPanel;
    lblStatus: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure cmbBoekChange(Sender: TObject);
    procedure btnBerekenClick(Sender: TObject);
    procedure btnStoorVerkoopClick(Sender: TObject);
    procedure btnMaakSkoonClick(Sender: TObject);
    procedure btnTerugClick(Sender: TObject);
  private
    arrBoekID: array[0..499] of Integer;
    arrPrys: array[0..499] of Currency;
    arrVoorraad: array[0..499] of Integer;
    arrBoekKode: array[0..499] of string;
    arrTitel: array[0..499] of string;
    iBoekTelling: Integer;
    cHuidigeTotaal: Currency;
    procedure LaaiAktieweBoeke;
    procedure MaakVeldeSkoon;
    procedure WysBoekbesonderhede;
    function GeselekteerdeIndeks: Integer;
    function ValideerVerkoopInvoer(out iHoeveelheid: Integer): Boolean;
    function BerekenVerkoopTotaal(const iHoeveelheid: Integer;
      const cEenheidsPrys: Currency): Currency;
  public
  end;

implementation

{$R *.dfm}

uses
  Data.DB, Data.Win.ADODB, uData, uGemeenskaplik;

procedure TfrmVerkope.FormCreate(Sender: TObject);
begin
  WysFormKonteks(Self, lblSubtitel, 'EduBoek - Verkope');
  // Laai aktiewe boeke in parallelle skikkings en stel die verkoopsform op.
  LaaiAktieweBoeke;
  MaakVeldeSkoon;
end;

procedure TfrmVerkope.LaaiAktieweBoeke;
var
  qryLaai: TADOQuery;
begin
  // Lees aktiewe boeke een keer en koppel elke ComboBox-inskrywing aan parallelle skikkings.
  cmbBoek.Items.Clear;
  iBoekTelling := 0;

  qryLaai := TADOQuery.Create(nil);
  try
    qryLaai.Connection := dmData.conBoekwinkel;
    qryLaai.SQL.Text :=
      'SELECT BoekID,BoekKode,Titel,Prys,VoorraadHoeveelheid ' +
      'FROM tblBoeke WHERE Aktief=True ORDER BY Titel';
    qryLaai.Open;

    while not qryLaai.Eof do
    begin
      if iBoekTelling >= Length(arrBoekID) then
        Break;

      arrBoekID[iBoekTelling] := qryLaai.FieldByName('BoekID').AsInteger;
      arrPrys[iBoekTelling] := qryLaai.FieldByName('Prys').AsCurrency;
      arrVoorraad[iBoekTelling] :=
        qryLaai.FieldByName('VoorraadHoeveelheid').AsInteger;
      arrBoekKode[iBoekTelling] := qryLaai.FieldByName('BoekKode').AsString;
      arrTitel[iBoekTelling] := qryLaai.FieldByName('Titel').AsString;

      cmbBoek.Items.Add(arrBoekKode[iBoekTelling] + ' - ' +
        arrTitel[iBoekTelling]);
      Inc(iBoekTelling);
      qryLaai.Next;
    end;
  finally
    qryLaai.Free;
  end;
end;

procedure TfrmVerkope.MaakVeldeSkoon;
begin
  // Herstel die form vir 'n nuwe verkoop sonder om databasisdata te verander.
  cmbBoek.ItemIndex := -1;
  edtHoeveelheid.Clear;
  lblPrysWaarde.Caption := 'R 0.00';
  lblBeskikbaarWaarde.Caption := '0';
  lblTotaal.Caption := 'R 0.00';
  memBesonderhede.Clear;
  cHuidigeTotaal := 0;
  lblStatus.Caption := 'Status: Kies ’n boek en voer die hoeveelheid in.';
end;

function TfrmVerkope.GeselekteerdeIndeks: Integer;
begin
  // Gee die indeks van die gekose boek terug; -1 beteken geen geldige keuse nie.
  Result := cmbBoek.ItemIndex;
  if (Result < 0) or (Result >= iBoekTelling) then
    Result := -1;
end;

procedure TfrmVerkope.WysBoekbesonderhede;
var
  iIndeks: Integer;
begin
  // Wys prys, voorraad en 'n kort opsomming vir die geselekteerde boek.
  iIndeks := GeselekteerdeIndeks;
  if iIndeks = -1 then
    Exit;

  lblPrysWaarde.Caption := FormateerGeldeenheid(arrPrys[iIndeks]);
  lblBeskikbaarWaarde.Caption := IntToStr(arrVoorraad[iIndeks]);

  memBesonderhede.Lines.Clear;
  memBesonderhede.Lines.Add('Datum: ' + DateToStr(Date));
  memBesonderhede.Lines.Add('Gebruikersrol: ' + sAktieweGebruiker);
  memBesonderhede.Lines.Add('Boekkode: ' + arrBoekKode[iIndeks]);
  memBesonderhede.Lines.Add('Titel: ' + arrTitel[iIndeks]);
  memBesonderhede.Lines.Add('Eenheidsprys: ' +
    FormateerGeldeenheid(arrPrys[iIndeks]));
  memBesonderhede.Lines.Add('Beskikbare voorraad: ' +
    IntToStr(arrVoorraad[iIndeks]));
end;

function TfrmVerkope.ValideerVerkoopInvoer(
  out iHoeveelheid: Integer): Boolean;
var
  iIndeks: Integer;
begin
  // Kontroleer boekkeuse, heelgetalhoeveelheid, positiewe waarde en beskikbare voorraad.
  Result := False;
  iIndeks := GeselekteerdeIndeks;

  if iIndeks = -1 then
  begin
    WysBoodskap('Kies asseblief ’n boek voordat die verkoop verwerk word.', mtWarning);
    cmbBoek.SetFocus;
    Exit;
  end;

  if not TryStrToInt(Trim(edtHoeveelheid.Text), iHoeveelheid) then
  begin
    WysBoodskap('Hoeveelheid moet ’n geldige heelgetal wees.', mtWarning);
    edtHoeveelheid.SetFocus;
    Exit;
  end;

  if iHoeveelheid <= 0 then
  begin
    WysBoodskap('Hoeveelheid moet groter as 0 wees.', mtWarning);
    edtHoeveelheid.SetFocus;
    Exit;
  end;

  if iHoeveelheid > arrVoorraad[iIndeks] then
  begin
    WysBoodskap('Daar is nie genoeg voorraad vir hierdie verkoop nie.' +
      sLineBreak + 'Beskikbaar: ' + IntToStr(arrVoorraad[iIndeks]), mtWarning);
    edtHoeveelheid.SetFocus;
    Exit;
  end;

  Result := True;
end;

function TfrmVerkope.BerekenVerkoopTotaal(const iHoeveelheid: Integer;
  const cEenheidsPrys: Currency): Currency;
begin
  // Bereken die totaal in 'n herbruikbare funksie.
  Result := iHoeveelheid * cEenheidsPrys;
end;

procedure TfrmVerkope.cmbBoekChange(Sender: TObject);
begin
  // Wys onmiddellik die gekose boek se prys en beskikbare voorraad.
  WysBoekbesonderhede;
  lblTotaal.Caption := 'R 0.00';
  cHuidigeTotaal := 0;
end;

procedure TfrmVerkope.btnBerekenClick(Sender: TObject);
var
  iHoeveelheid: Integer;
  iIndeks: Integer;
begin
  // Valideer die invoer en bereken die verkoopstotaal voordat iets gestoor word.
  if not ValideerVerkoopInvoer(iHoeveelheid) then
    Exit;

  iIndeks := GeselekteerdeIndeks;
  cHuidigeTotaal := BerekenVerkoopTotaal(iHoeveelheid, arrPrys[iIndeks]);
  lblTotaal.Caption := FormateerGeldeenheid(cHuidigeTotaal);
  lblStatus.Caption := 'Status: Totaal bereken. Klik “Stoor verkoop”.';

  memBesonderhede.Lines.Add('Hoeveelheid: ' + IntToStr(iHoeveelheid));
  memBesonderhede.Lines.Add('Totaal: ' + FormateerGeldeenheid(cHuidigeTotaal));
end;

procedure TfrmVerkope.btnStoorVerkoopClick(Sender: TObject);
var
  iHoeveelheid: Integer;
  iIndeks: Integer;
  iTransaksieVlak: Integer;
  qryStoor: TADOQuery;
begin
  // Stoor die verkoop en verminder voorraad as een databasistransaksie.
  if not ValideerVerkoopInvoer(iHoeveelheid) then
    Exit;

  iIndeks := GeselekteerdeIndeks;
  cHuidigeTotaal := BerekenVerkoopTotaal(iHoeveelheid, arrPrys[iIndeks]);
  iTransaksieVlak := 0;
  qryStoor := TADOQuery.Create(nil);

  try
    qryStoor.Connection := dmData.conBoekwinkel;
    iTransaksieVlak := dmData.conBoekwinkel.BeginTrans;

    qryStoor.SQL.Text :=
      'INSERT INTO tblVerkope ' +
      '(BoekID,VerkoopDatum,Hoeveelheid,EenheidsPrys,GebruikerRol) ' +
      'VALUES (:BoekID,:Datum,:Hoeveelheid,:Prys,:Rol)';
    qryStoor.Parameters.ParamByName('BoekID').Value := arrBoekID[iIndeks];
    qryStoor.Parameters.ParamByName('Datum').Value := Now;
    qryStoor.Parameters.ParamByName('Hoeveelheid').Value := iHoeveelheid;
    qryStoor.Parameters.ParamByName('Prys').Value := arrPrys[iIndeks];
    qryStoor.Parameters.ParamByName('Rol').Value := sAktieweGebruiker;
    qryStoor.ExecSQL;

    qryStoor.Close;
    qryStoor.SQL.Text :=
      'UPDATE tblBoeke SET VoorraadHoeveelheid=VoorraadHoeveelheid-:Hoeveelheid1 ' +
      'WHERE BoekID=:BoekID AND VoorraadHoeveelheid>=:Hoeveelheid2';
    qryStoor.Parameters.ParamByName('Hoeveelheid1').Value := iHoeveelheid;
    qryStoor.Parameters.ParamByName('BoekID').Value := arrBoekID[iIndeks];
    qryStoor.Parameters.ParamByName('Hoeveelheid2').Value := iHoeveelheid;
    qryStoor.ExecSQL;

    if qryStoor.RowsAffected <> 1 then
      raise Exception.Create('Voorraad kon nie veilig verminder word nie.');

    dmData.conBoekwinkel.CommitTrans;
    iTransaksieVlak := 0;

    WysBoodskap('Die verkoop is suksesvol gestoor.' + sLineBreak +
      'Totaal: ' + FormateerGeldeenheid(cHuidigeTotaal));

    LaaiAktieweBoeke;
    MaakVeldeSkoon;
    dmData.VerfrisBoeke;
    // Begin na 'n suksesvolle verkoop weer by die boekkeuse.
    if cmbBoek.CanFocus then
      cmbBoek.SetFocus;
  except
    on E: Exception do
    begin
      if iTransaksieVlak > 0 then
        dmData.conBoekwinkel.RollbackTrans;
      WysBoodskap('Die verkoop kon nie gestoor word nie. Geen gedeeltelike verandering is behou nie.' +
        sLineBreak + E.Message, mtError);
    end;
  end;

  qryStoor.Free;
end;

procedure TfrmVerkope.btnMaakSkoonClick(Sender: TObject);
begin
  // Maak die verkoopsinvoer skoon en keer terug na die boekkeuse.
  MaakVeldeSkoon;
  if cmbBoek.CanFocus then
    cmbBoek.SetFocus;
end;

procedure TfrmVerkope.btnTerugClick(Sender: TObject);
begin
  // Sluit die verkoopsform en keer terug na die hoofmenu.
  Close;
end;

end.
