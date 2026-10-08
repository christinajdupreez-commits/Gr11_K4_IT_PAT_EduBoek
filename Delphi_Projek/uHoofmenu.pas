{******************************************************************************
  Projeknaam : EduBoek Voorraad- en Verkoopsbestuurstelsel
  Leerder    : Andre du Preez
  Graad      : 11
  Vak        : Inligtingstegnologie
  Jaar       : 2026
  Eenheid    : uHoofmenu.pas
  Doel       : Hoofmenu, maatskappy-identiteit, weergawe en navigasie.
  Weergawe   : 1.5.0

  Nota:
  Elke prosedure en funksie bevat kommentaar om die kode se doel en werking
  tydens die PAT-onderhoud duidelik te kan verduidelik.
******************************************************************************}

unit uHoofmenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.UITypes, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Imaging.pngimage;

type
  TfrmHoofmenu = class(TForm)
    pnlKop: TPanel;
    imgLogo: TImage;
    lblMaatskappy: TLabel;
    lblSpreuk: TLabel;
    lblWelkom: TLabel;
    lblKies: TLabel;
    btnVoorraad: TButton;
    btnVerkope: TButton;
    btnVerslae: TButton;
    btnHulp: TButton;
    btnVerlaat: TButton;
    lblRol: TLabel;
    cmbGebruikerRol: TComboBox;
    pnlStatus: TPanel;
    lblStatusDB: TLabel;
    lblStatusVoorraad: TLabel;
    lblStatusVerslag: TLabel;
    lblWeergawe: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnVoorraadClick(Sender: TObject);
    procedure btnVerkopeClick(Sender: TObject);
    procedure btnVerslaeClick(Sender: TObject);
    procedure btnHulpClick(Sender: TObject);
    procedure btnVerlaatClick(Sender: TObject);
    procedure cmbGebruikerRolChange(Sender: TObject);
  private
    procedure LaaiLogo;
    procedure VerfrisStatus;
  public
  end;

var
  frmHoofmenu: TfrmHoofmenu;

implementation

{$R *.dfm}

uses
  uGemeenskaplik, uData, uVoorraad, uVerkope, uVerslae;

procedure TfrmHoofmenu.FormCreate(Sender: TObject);
begin
  // Stel die maatskappy-identiteit, weergawe, logo en gebruikersrol op.
  Caption := C_PROGRAMNAAM;
  lblMaatskappy.Caption := C_MAATSKAPPYNAAM + ' - Hoofmenu';
  lblWeergawe.Caption := 'Weergawe ' + C_APP_VERSION + ' | ' + C_APP_DATE;

  cmbGebruikerRol.Items.Clear;
  cmbGebruikerRol.Items.Add('Bestuurder');
  cmbGebruikerRol.Items.Add('Werknemer');
  cmbGebruikerRol.Items.Add('Kassier');
  cmbGebruikerRol.ItemIndex := 0;
  sAktieweGebruiker := 'Bestuurder';

  LaaiLogo;
  VerfrisStatus;
end;

procedure TfrmHoofmenu.FormShow(Sender: TObject);
begin
  // Verfris die status elke keer wanneer die gebruiker na die hoofmenu terugkeer.
  VerfrisStatus;
end;

procedure TfrmHoofmenu.LaaiLogo;
var
  sLogoPad: string;
begin
  // Laai die eksterne PNG-logo; die program bly bruikbaar indien die lêer ontbreek.
  sLogoPad := AppBasisPad + 'EduBoek_Logo.png';
  if FileExists(sLogoPad) then
  begin
    try
      imgLogo.Picture.LoadFromFile(sLogoPad);
    except
      on E: Exception do
        imgLogo.Visible := False;
    end;
  end
  else
    imgLogo.Visible := False;
end;

procedure TfrmHoofmenu.VerfrisStatus;
begin
  // Wys die gekose rol en weergawe, plus databasis- en voorraadstatus.
  WysFormKonteks(Self, lblWeergawe, C_PROGRAMNAAM);
  if Assigned(dmData) and dmData.conBoekwinkel.Connected then
  begin
    lblStatusDB.Caption := 'Status: Databasis gekoppel';
    lblStatusVoorraad.Caption :=
      'Lae voorraad-items: ' + IntToStr(dmData.TelLaeVoorraad);
  end
  else
  begin
    lblStatusDB.Caption := 'Status: Databasis nie gekoppel nie';
    lblStatusVoorraad.Caption := 'Lae voorraad-items: onbekend';
  end;

  if DirectoryExists(VerslagPad) then
    lblStatusVerslag.Caption := 'Verslaggids gereed'
  else
    lblStatusVerslag.Caption := 'Verslaggids ontbreek';
end;

procedure TfrmHoofmenu.btnVoorraadClick(Sender: TObject);
begin
  // Maak die voorraadbestuursform modaal oop en verfris daarna die hoofstatus.
  with TfrmVoorraad.Create(Self) do
  try
    ShowModal;
  finally
    Free;
  end;
  VerfrisStatus;
end;

procedure TfrmHoofmenu.btnVerkopeClick(Sender: TObject);
begin
  // Maak die verkoopsform oop om 'n nuwe boekverkoop vas te lê.
  with TfrmVerkope.Create(Self) do
  try
    ShowModal;
  finally
    Free;
  end;
  VerfrisStatus;
end;

procedure TfrmHoofmenu.btnVerslaeClick(Sender: TObject);
begin
  // Maak die verslagform oop vir lae voorraad en verkoopsopsommings.
  with TfrmVerslae.Create(Self) do
  try
    ShowModal;
  finally
    Free;
  end;
  VerfrisStatus;
end;

procedure TfrmHoofmenu.btnHulpClick(Sender: TObject);
begin
  // Gee 'n kort gebruikersvriendelike oorsig van die hoofprogramvloei.
  WysBoodskap(
    'EduBoek - Vinnige hulp' + sLineBreak + sLineBreak +
    '1. Gebruik Voorraadbestuur om boeke by te voeg of te wysig.' + sLineBreak +
    '2. Gebruik Verkope vaslê om verkope te stoor en voorraad te verminder.' + sLineBreak +
    '3. Gebruik Verslae om lae voorraad of verkoopsopsommings te sien.' + sLineBreak +
    '4. Kies die korrekte gebruikersrol voordat jy werk.');
end;

procedure TfrmHoofmenu.btnVerlaatClick(Sender: TObject);
begin
  // Vra bevestiging sodat die gebruiker nie die program per ongeluk sluit nie.
  if MessageDlg('Wil jy EduBoek afsluit?', mtConfirmation,
    [mbYes, mbNo], 0) = mrYes then
    Close;
end;

procedure TfrmHoofmenu.cmbGebruikerRolChange(Sender: TObject);
begin
  // Bewaar die gekose rol vir elke form en nuwe verkope; dit is geen aanmelding nie.
  if cmbGebruikerRol.ItemIndex >= 0 then
    sAktieweGebruiker := cmbGebruikerRol.Items[cmbGebruikerRol.ItemIndex];
  VerfrisStatus;
end;

end.
