{******************************************************************************
  Projeknaam : EduBoek Voorraad- en Verkoopsbestuurstelsel
  Leerder    : Andre du Preez
  Graad      : 11
  Vak        : Inligtingstegnologie
  Jaar       : 2026
  Eenheid    : uVoorraad.pas
  Doel       : Voorraadbestuur en CRUD-bewerkings op tblBoeke.
  Weergawe   : 1.5.0

  Nota:
  Elke prosedure en funksie bevat kommentaar om die kode se doel en werking
  tydens die PAT-onderhoud duidelik te kan verduidelik.
******************************************************************************}

unit uVoorraad;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.UITypes, System.Variants,
  System.Classes, Data.DB, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.DBGrids, Vcl.Grids, Vcl.Samples.Spin;

type
  TfrmVoorraad = class(TForm)
    pnlKop: TPanel;
    lblTitel: TLabel;
    lblSubtitel: TLabel;
    lblSoek: TLabel;
    edtSoek: TEdit;
    btnSoek: TButton;
    btnWysAlles: TButton;
    lblBoekKode: TLabel;
    edtBoekKode: TEdit;
    lblBoekTitel: TLabel;
    edtTitel: TEdit;
    lblGraad: TLabel;
    cmbGraad: TComboBox;
    lblVak: TLabel;
    edtVak: TEdit;
    lblKategorie: TLabel;
    cmbKategorie: TComboBox;
    lblPrys: TLabel;
    edtPrys: TEdit;
    lblVoorraad: TLabel;
    spnVoorraad: TSpinEdit;
    lblMinimum: TLabel;
    spnMinimum: TSpinEdit;
    chkAktief: TCheckBox;
    dbgBoeke: TDBGrid;
    btnVoegBy: TButton;
    btnWysig: TButton;
    btnVerwyder: TButton;
    btnMaakSkoon: TButton;
    btnTerug: TButton;
    pnlStatus: TPanel;
    lblStatus: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSoekClick(Sender: TObject);
    procedure btnWysAllesClick(Sender: TObject);
    procedure btnVoegByClick(Sender: TObject);
    procedure btnWysigClick(Sender: TObject);
    procedure btnVerwyderClick(Sender: TObject);
    procedure btnMaakSkoonClick(Sender: TObject);
    procedure btnTerugClick(Sender: TObject);
    procedure dbgBoekeCellClick(Column: TColumn);
  private
    FBoekID: Integer;
    FOpgestel: Boolean;
    procedure dbgBoekeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure dbgBoekeKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure LaaiKeuses;
    procedure StelBoekKolommeOp;
    procedure MaakVeldeSkoon;
    procedure VulVeldeVanRekord;
    procedure VerfrisData(const sSoek: string = '');
    function ValideerBoekInvoer(out cPrys: Currency): Boolean;
  public
  end;

implementation

{$R *.dfm}

uses
  Data.Win.ADODB, uData, uGemeenskaplik;

procedure TfrmVoorraad.FormCreate(Sender: TObject);
begin
  // Die form is nog onsigbaar. Koppel OnShow hier sodat die bestaande
  // DFM behoue bly en die tabel eers opgestel word wanneer die form wys.
  FOpgestel := False;
  OnShow := FormShow;
  // Laai besonderhede ook nadat die gebruiker die rymerker of pyltjies gebruik.
  dbgBoeke.OnMouseUp := dbgBoekeMouseUp;
  dbgBoeke.OnKeyUp := dbgBoekeKeyUp;
end;

procedure TfrmVoorraad.FormShow(Sender: TObject);
begin
  WysFormKonteks(Self, lblSubtitel, 'EduBoek - Voorraadbestuur');
  // OnShow loop wanneer Visible reeds True is. Kolomveranderinge kan
  // die DBGrid se fokus verander en hoort daarom nie in OnCreate nie.
  // Stel elke nuwe form net een keer op; latere vertonings behou sy invoer.
  if FOpgestel then
    Exit;

  LaaiKeuses;
  MaakVeldeSkoon;
  edtSoek.Clear;
  edtSoek.TextHint := 'Tik boekkode of titel...';
  dbgBoeke.DataSource := dmData.dsBoeke;
  StelBoekKolommeOp;
  VerfrisData;
  // Begin by die boekkode sodat die leë soekveld se grys wenk sigbaar bly.
  if edtBoekKode.CanFocus then
    ActiveControl := edtBoekKode;
  FOpgestel := True;
end;

procedure TfrmVoorraad.LaaiKeuses;
var
  i: Integer;
begin
  // Laai vaste graadwaardes en die kategorie-skikking in ComboBoxes.
  cmbGraad.Items.Clear;
  for i := 8 to 12 do
    cmbGraad.Items.Add(IntToStr(i));

  cmbKategorie.Items.Clear;
  for i := Low(arrKategoriee) to High(arrKategoriee) do
    cmbKategorie.Items.Add(arrKategoriee[i]);
end;

procedure TfrmVoorraad.StelBoekKolommeOp;

  procedure VoegKolomBy(const sVeld, sOpskrif: string;
    iBreedte: Integer; Belyning: TAlignment);
  var
    Kolom: TColumn;
  begin
    // Hergebruik dieselfde opstelling en pas breedtes by die skermskaal aan.
    Kolom := dbgBoeke.Columns.Add;
    Kolom.FieldName := sVeld;
    Kolom.Title.Caption := sOpskrif;
    Kolom.Width := MulDiv(iBreedte, dbgBoeke.CurrentPPI, 96);
    Kolom.Alignment := Belyning;
    Kolom.Title.Alignment := Belyning;
    Kolom.ReadOnly := True;
  end;

begin
  // Wys ses nuttige velde binne die bestaande tabel; BoekID bly intern.
  // Die form is reeds sigbaar wanneer hierdie kolomme opgestel word.
  dbgBoeke.Columns.BeginUpdate;
  try
    dbgBoeke.Columns.Clear;
    VoegKolomBy('BoekKode', 'Boekkode', 74, taLeftJustify);
    VoegKolomBy('Titel', 'Titel', 176, taLeftJustify);
    VoegKolomBy('Graad', 'Graad', 46, taCenter);
    VoegKolomBy('Prys', 'Prys', 74, taRightJustify);
    VoegKolomBy('VoorraadHoeveelheid', 'Voorraad', 64, taRightJustify);
    VoegKolomBy('Aktief', 'Aktief', 50, taCenter);
  finally
    dbgBoeke.Columns.EndUpdate;
  end;
end;

procedure TfrmVoorraad.MaakVeldeSkoon;
begin
  // Maak die invoerarea skoon en herstel veilige verstekwaardes.
  FBoekID := 0;
  edtBoekKode.Clear;
  edtTitel.Clear;
  cmbGraad.ItemIndex := -1;
  edtVak.Clear;
  cmbKategorie.ItemIndex := -1;
  edtPrys.Clear;
  spnVoorraad.Value := 0;
  spnMinimum.Value := 5;
  chkAktief.Checked := True;
  lblStatus.Caption := 'Status: Gereed. Kies ’n rekord of voer nuwe data in.';
  // ActiveControl kies die invoerveld; die form bestuur die werklike fokus.
  // Kontroleer ook dat die veld en sy ouerkontroles fokus kan ontvang.
  if edtBoekKode.CanFocus then
    ActiveControl := edtBoekKode;
end;

procedure TfrmVoorraad.VulVeldeVanRekord;
var
  iKategorie: Integer;
begin
  // Vul die kontroles met die geselekteerde databasisrekord vir wysiging.
  if not dmData.qryBoeke.Active then
    Exit;
  if dmData.qryBoeke.IsEmpty then
    Exit;

  FBoekID := dmData.qryBoeke.FieldByName('BoekID').AsInteger;
  edtBoekKode.Text := dmData.qryBoeke.FieldByName('BoekKode').AsString;
  edtTitel.Text := dmData.qryBoeke.FieldByName('Titel').AsString;
  cmbGraad.ItemIndex := cmbGraad.Items.IndexOf(
    dmData.qryBoeke.FieldByName('Graad').AsString);
  edtVak.Text := dmData.qryBoeke.FieldByName('Vak').AsString;

  iKategorie := cmbKategorie.Items.IndexOf(
    dmData.qryBoeke.FieldByName('Kategorie').AsString);
  cmbKategorie.ItemIndex := iKategorie;

  edtPrys.Text := CurrToStr(dmData.qryBoeke.FieldByName('Prys').AsCurrency);
  spnVoorraad.Value := dmData.qryBoeke.FieldByName('VoorraadHoeveelheid').AsInteger;
  spnMinimum.Value := dmData.qryBoeke.FieldByName('MinimumVoorraad').AsInteger;
  chkAktief.Checked := dmData.qryBoeke.FieldByName('Aktief').AsBoolean;
  lblStatus.Caption := 'Status: Rekord gekies - ' + edtBoekKode.Text;
end;

procedure TfrmVoorraad.VerfrisData(const sSoek: string = '');
var
  Veld: TField;
begin
  // Herlaai die boeknavraag en herstel vertoonformate op die nuwe datasetvelde.
  dmData.VerfrisBoeke(sSoek);
  Veld := dmData.qryBoeke.FindField('Prys');
  if Veld is TNumericField then
    TNumericField(Veld).DisplayFormat := '"R "0.00';
  Veld := dmData.qryBoeke.FindField('Aktief');
  if Veld is TBooleanField then
    TBooleanField(Veld).DisplayValues := 'Ja;Nee';
  lblStatus.Caption := 'Status: ' + IntToStr(dmData.qryBoeke.RecordCount) +
    ' boekrekord(e) vertoon.';
end;

function TfrmVoorraad.ValideerBoekInvoer(out cPrys: Currency): Boolean;
var
  iGraad: Integer;
begin
  // Kontroleer verpligte velde, datatipes, reekse en unieke boekkode.
  Result := False;

  if Trim(edtBoekKode.Text) = '' then
  begin
    WysBoodskap('Voer asseblief ’n boekkode in.', mtWarning);
    edtBoekKode.SetFocus;
    Exit;
  end;

  if Length(Trim(edtBoekKode.Text)) > 10 then
  begin
    WysBoodskap('Die boekkode mag nie langer as 10 karakters wees nie.', mtWarning);
    edtBoekKode.SetFocus;
    Exit;
  end;

  if Trim(edtTitel.Text) = '' then
  begin
    WysBoodskap('Voer asseblief die boektitel in.', mtWarning);
    edtTitel.SetFocus;
    Exit;
  end;

  if (cmbGraad.ItemIndex < 0) or
    (not TryStrToInt(cmbGraad.Text, iGraad)) or
    (iGraad < 8) or (iGraad > 12) then
  begin
    WysBoodskap('Kies asseblief ’n geldige graad tussen 8 en 12.', mtWarning);
    cmbGraad.SetFocus;
    Exit;
  end;

  if Trim(edtVak.Text) = '' then
  begin
    WysBoodskap('Voer asseblief die vak in.', mtWarning);
    edtVak.SetFocus;
    Exit;
  end;

  if cmbKategorie.ItemIndex < 0 then
  begin
    WysBoodskap('Kies asseblief ’n boekkategorie.', mtWarning);
    cmbKategorie.SetFocus;
    Exit;
  end;

  if not ProbeerLeesGeldeenheid(edtPrys.Text, cPrys) or (cPrys <= 0) then
  begin
    WysBoodskap('Prys moet ’n geldige bedrag groter as R0.00 wees.', mtWarning);
    edtPrys.SetFocus;
    Exit;
  end;

  if spnVoorraad.Value < 0 then
  begin
    WysBoodskap('Voorraad mag nie negatief wees nie.', mtWarning);
    spnVoorraad.SetFocus;
    Exit;
  end;

  if spnMinimum.Value < 0 then
  begin
    WysBoodskap('Minimum voorraad mag nie negatief wees nie.', mtWarning);
    spnMinimum.SetFocus;
    Exit;
  end;

  if dmData.BoekKodeBestaan(edtBoekKode.Text, FBoekID) then
  begin
    WysBoodskap('Hierdie boekkode bestaan reeds. Gebruik ’n unieke kode.', mtWarning);
    edtBoekKode.SetFocus;
    Exit;
  end;

  Result := True;
end;

procedure TfrmVoorraad.btnSoekClick(Sender: TObject);
begin
  // Filter die voorraadlys volgens die gebruiker se boekkode- of titelsoektog.
  VerfrisData(edtSoek.Text);
end;

procedure TfrmVoorraad.btnWysAllesClick(Sender: TObject);
begin
  // Verwyder die filter en wys weer alle boekrekords.
  edtSoek.Clear;
  VerfrisData;
end;

procedure TfrmVoorraad.btnVoegByClick(Sender: TObject);
var
  cPrys: Currency;
begin
  // Valideer en voeg ’n nuwe boekrekord met ’n geparameteriseerde SQL-opdrag by.
  FBoekID := 0;
  if not ValideerBoekInvoer(cPrys) then
    Exit;

  try
    dmData.qryWerk.Close;
    dmData.qryWerk.SQL.Text :=
      'INSERT INTO tblBoeke ' +
      '(BoekKode,Titel,Graad,Vak,Kategorie,Prys,VoorraadHoeveelheid,MinimumVoorraad,Aktief) ' +
      'VALUES (:BoekKode,:Titel,:Graad,:Vak,:Kategorie,:Prys,:Voorraad,:Minimum,:Aktief)';
    dmData.qryWerk.Parameters.ParamByName('BoekKode').Value := UpperCase(Trim(edtBoekKode.Text));
    dmData.qryWerk.Parameters.ParamByName('Titel').Value := Trim(edtTitel.Text);
    dmData.qryWerk.Parameters.ParamByName('Graad').Value := StrToInt(cmbGraad.Text);
    dmData.qryWerk.Parameters.ParamByName('Vak').Value := Trim(edtVak.Text);
    dmData.qryWerk.Parameters.ParamByName('Kategorie').Value := cmbKategorie.Text;
    dmData.qryWerk.Parameters.ParamByName('Prys').Value := cPrys;
    dmData.qryWerk.Parameters.ParamByName('Voorraad').Value := spnVoorraad.Value;
    dmData.qryWerk.Parameters.ParamByName('Minimum').Value := spnMinimum.Value;
    dmData.qryWerk.Parameters.ParamByName('Aktief').Value := chkAktief.Checked;
    dmData.qryWerk.ExecSQL;

    VerfrisData;
    MaakVeldeSkoon;
    WysBoodskap('Die nuwe boek is suksesvol bygevoeg.');
  except
    on E: Exception do
      WysBoodskap('Die boek kon nie bygevoeg word nie: ' + E.Message, mtError);
  end;
end;

procedure TfrmVoorraad.btnWysigClick(Sender: TObject);
var
  cPrys: Currency;
  bLaeVoorraad: Boolean;
  sBoodskap: string;
begin
  // Dateer die geselekteerde boekrekord op nadat alle nuwe waardes gevalideer is.
  if FBoekID = 0 then
  begin
    WysBoodskap('Kies eers ’n boekrekord om te wysig.', mtWarning);
    Exit;
  end;

  if not ValideerBoekInvoer(cPrys) then
    Exit;

  try
    dmData.qryWerk.Close;
    dmData.qryWerk.SQL.Text :=
      'UPDATE tblBoeke SET BoekKode=:BoekKode,Titel=:Titel,Graad=:Graad,' +
      'Vak=:Vak,Kategorie=:Kategorie,Prys=:Prys,' +
      'VoorraadHoeveelheid=:Voorraad,MinimumVoorraad=:Minimum,Aktief=:Aktief ' +
      'WHERE BoekID=:BoekID';
    dmData.qryWerk.Parameters.ParamByName('BoekKode').Value := UpperCase(Trim(edtBoekKode.Text));
    dmData.qryWerk.Parameters.ParamByName('Titel').Value := Trim(edtTitel.Text);
    dmData.qryWerk.Parameters.ParamByName('Graad').Value := StrToInt(cmbGraad.Text);
    dmData.qryWerk.Parameters.ParamByName('Vak').Value := Trim(edtVak.Text);
    dmData.qryWerk.Parameters.ParamByName('Kategorie').Value := cmbKategorie.Text;
    dmData.qryWerk.Parameters.ParamByName('Prys').Value := cPrys;
    dmData.qryWerk.Parameters.ParamByName('Voorraad').Value := spnVoorraad.Value;
    dmData.qryWerk.Parameters.ParamByName('Minimum').Value := spnMinimum.Value;
    dmData.qryWerk.Parameters.ParamByName('Aktief').Value := chkAktief.Checked;
    dmData.qryWerk.Parameters.ParamByName('BoekID').Value := FBoekID;
    dmData.qryWerk.ExecSQL;

    // Minimumvoorraad is 'n herbestelvlak; lae voorraad bly geldige data.
    // Onthou die gestoorde waardes voordat die invoervelde skoongemaak word.
    bLaeVoorraad := chkAktief.Checked and
      (spnVoorraad.Value <= spnMinimum.Value);
    sBoodskap := 'Die boekrekord is suksesvol gewysig.';
    if bLaeVoorraad then
      sBoodskap := sBoodskap + sLineBreak + sLineBreak +
        Format('Let wel: voorraad (%d) is op of onder die minimum (%d).',
          [spnVoorraad.Value, spnMinimum.Value]) + sLineBreak +
        'Herbestel asseblief hierdie boek.';

    VerfrisData;
    MaakVeldeSkoon;
    if bLaeVoorraad then
      WysBoodskap(sBoodskap, mtWarning)
    else
      WysBoodskap(sBoodskap);
  except
    on E: Exception do
      WysBoodskap('Die boek kon nie gewysig word nie: ' + E.Message, mtError);
  end;
end;

procedure TfrmVoorraad.btnVerwyderClick(Sender: TObject);
var
  iVerkope, iKeuse: Integer;
  sBevestiging: string;
begin
  // Verduidelik die presiese aksie voordat die gebruiker dit bevestig.
  // Geen verkope: verwyder. Met verkope: behou die geskiedenis en deaktiveer.
  if FBoekID = 0 then
  begin
    WysBoodskap('Kies eers ’n boekrekord om te verwyder.', mtWarning);
    Exit;
  end;

  try
    iVerkope := dmData.TelVerkopeVirBoek(FBoekID);
    if iVerkope = 0 then
      sBevestiging :=
        'Hierdie boek het geen verkoopsrekords nie.' + sLineBreak +
        'Wil jy die boekrekord permanent verwyder?' + sLineBreak + sLineBreak +
        'Yes = verwyder. No = kanselleer.'
    else
      sBevestiging :=
        'Hierdie boek het verkoopsrekords en kan nie uitgevee word nie.' + sLineBreak +
        'Wil jy die boek as onaktief merk?' + sLineBreak + sLineBreak +
        'Yes = deaktiveer. No = kanselleer.';

    // No is die verstekkeuse. Slegs 'n uitdruklike Yes mag data verander.
    iKeuse := MessageDlg(sBevestiging, mtConfirmation, [mbYes, mbNo], 0, mbNo);
    if iKeuse <> mrYes then
    begin
      lblStatus.Caption := 'Status: Aksie gekanselleer; boekrekord behou.';
      Exit;
    end;

    dmData.qryWerk.Close;
    if iVerkope = 0 then
    begin
      dmData.qryWerk.SQL.Text := 'DELETE FROM tblBoeke WHERE BoekID=:BoekID';
      dmData.qryWerk.Parameters.ParamByName('BoekID').Value := FBoekID;
      dmData.qryWerk.ExecSQL;
      WysBoodskap('Die boekrekord is suksesvol uitgevee.');
    end
    else
    begin
      dmData.qryWerk.SQL.Text :=
        'UPDATE tblBoeke SET Aktief=False WHERE BoekID=:BoekID';
      dmData.qryWerk.Parameters.ParamByName('BoekID').Value := FBoekID;
      dmData.qryWerk.ExecSQL;
      WysBoodskap('Die boek het verkoopsrekords en is daarom veilig as onaktief gemerk.');
    end;

    VerfrisData;
    MaakVeldeSkoon;
  except
    on E: Exception do
      WysBoodskap('Die boek kon nie verwyder of gedeaktiveer word nie: ' +
        E.Message, mtError);
  end;
end;

procedure TfrmVoorraad.btnMaakSkoonClick(Sender: TObject);
begin
  // Maak die invoervelde skoon sonder om databasisdata te verander.
  MaakVeldeSkoon;
end;

procedure TfrmVoorraad.btnTerugClick(Sender: TObject);
begin
  // Sluit die modale voorraadform en keer terug na die hoofmenu.
  Close;
end;

procedure TfrmVoorraad.dbgBoekeCellClick(Column: TColumn);
begin
  // Kies die databasisrekord waarop die gebruiker in die DBGrid geklik het.
  VulVeldeVanRekord;
end;

procedure TfrmVoorraad.dbgBoekeMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Cel: TGridCoord;
begin
  // OnCellClick hanteer die datakolomme. Hanteer hier ook die rymerker links.
  // Wag tot die muisknoppie losgelaat is, nadat die tabel die rekord gekies het.
  if (Button <> mbLeft) or not (dgIndicator in dbgBoeke.Options) then
    Exit;
  Cel := dbgBoeke.MouseCoord(X, Y);
  if (Cel.X <> 0) or (Cel.Y < 0) then
    Exit;
  if (dgTitles in dbgBoeke.Options) and (Cel.Y = 0) then
    Exit;
  VulVeldeVanRekord;
end;

procedure TfrmVoorraad.dbgBoekeKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // Hou die invoervelde by die gekose rekord wanneer die gebruiker navigeer.
  if Key in [VK_UP, VK_DOWN, VK_PRIOR, VK_NEXT, VK_HOME, VK_END] then
    VulVeldeVanRekord;
end;

end.
