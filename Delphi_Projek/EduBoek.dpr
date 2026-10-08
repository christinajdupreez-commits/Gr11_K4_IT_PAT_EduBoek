program EduBoek;

{******************************************************************************
  Projeknaam : EduBoek Voorraad- en Verkoopsbestuurstelsel
  Leerder    : Andre du Preez
  Graad      : 11
  Vak        : Inligtingstegnologie
  Jaar       : 2026
  PAT-tema   : Besigheidsbestuursprogram
  Weergawe   : 1.5.0

  Doel:
  Hierdie Delphi-program help 'n denkbeeldige skoolboekwinkel om boeke,
  voorraad en verkope met 'n Microsoft Access-databasis en ADO te bestuur.

  Hoofdele:
  - frmHoofmenu: maatskappy-identiteit, gebruikersrol en navigasie.
  - frmVoorraad: CRUD-bewerkings op tblBoeke.
  - frmVerkope: verkoopstransaksies en outomatiese voorraadvermindering.
  - frmVerslae: lae voorraad, verkoops- en kategorieverslae plus tekslêers.
  - dmData: sentrale ADO-verbinding, databasisopstelling en navrae.

  Belangrik:
  Elke prosedure en funksie bevat kommentaar sodat die werking tydens die
  PAT-onderhoud verduidelik kan word.
******************************************************************************}

uses
  Vcl.Forms,
  uHoofmenu in 'uHoofmenu.pas' {frmHoofmenu},
  uVoorraad in 'uVoorraad.pas' {frmVoorraad},
  uVerkope in 'uVerkope.pas' {frmVerkope},
  uVerslae in 'uVerslae.pas' {frmVerslae},
  uData in 'uData.pas' {dmData: TDataModule},
  uGemeenskaplik in 'uGemeenskaplik.pas';

// Sluit die projek se ikoon, weergawe-inligting en Windows-manifest in.
{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'EduBoek Voorraad- en Verkoopsbestuurstelsel';
  Application.CreateForm(TdmData, dmData);
  Application.CreateForm(TfrmHoofmenu, frmHoofmenu);
  Application.Run;
end.
