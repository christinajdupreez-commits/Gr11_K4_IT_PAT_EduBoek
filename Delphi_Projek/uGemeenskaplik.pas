{******************************************************************************
  Projeknaam : EduBoek Voorraad- en Verkoopsbestuurstelsel
  Leerder    : Andre du Preez
  Graad      : 11
  Vak        : Inligtingstegnologie
  Jaar       : 2026
  Eenheid    : uGemeenskaplik.pas
  Doel       : Gemeenskaplike konstantes, skikkings en herbruikbare hulpmiddels.
  Weergawe   : 1.5.0

  Nota:
  Elke prosedure en funksie bevat kommentaar om die kode se doel en werking
  tydens die PAT-onderhoud duidelik te kan verduidelik.
******************************************************************************}

unit uGemeenskaplik;

interface

uses
  Winapi.Windows, System.SysUtils, System.UITypes, System.Classes,
  Vcl.Dialogs, Vcl.Forms, Vcl.StdCtrls;

const
  C_MAATSKAPPYNAAM = 'EduBoek Skoolboekwinkel';
  C_PROGRAMNAAM = 'EduBoek Voorraad- en Verkoopsbestuurstelsel';
  C_APP_VERSION = '1.5.0';
  C_APP_DATE = '8 Oktober 2026';
  C_MAKS_BOEKE = 500;
  // Vaste projekgids: dieselfde pad op elke Windows-rekenaar.
  C_PROJEK_BASISPAD = 'C:\EduBoek\Delphi_Projek';

type
  TKategorieSkikking = array[1..6] of string;

var
  arrKategoriee: TKategorieSkikking;
  sAktieweGebruiker: string;

function AppBasisPad: string;
function DataPad: string;
function VerslagPad: string;
function ProbeerLeesGeldeenheid(const sText: string;
  out cWaarde: Currency): Boolean;
function FormateerGeldeenheid(const cWaarde: Currency): string;
procedure LaaiKategoriee;
procedure WysFormKonteks(AForm: TForm; AKonteks: TLabel;
  const sFormTitel: string);
procedure WysBoodskap(const sBoodskap: string;
  const dlgTipe: TMsgDlgType = mtInformation);

implementation

function AppBasisPad: string;
begin
  // Gebruik die vaste projekgids, ook wanneer die EXE in Win32\Debug is.
  // Kopieer bestaande Data en Verslae hierheen voordat die program begin.
  Result := IncludeTrailingPathDelimiter(C_PROJEK_BASISPAD);
end;

function DataPad: string;
begin
  // Hou alle databasislêers in 'n aparte Data-gids.
  Result := AppBasisPad + 'Data' + PathDelim;
end;

function VerslagPad: string;
begin
  // Hou alle tekslêerverslae in 'n aparte Verslae-gids.
  Result := AppBasisPad + 'Verslae' + PathDelim;
end;

function ProbeerLeesGeldeenheid(const sText: string;
  out cWaarde: Currency): Boolean;
var
  sSkoon: string;
begin
  // Verwyder 'n moontlike Rand-simbool en pas die desimale teken by Windows aan.
  sSkoon := Trim(StringReplace(sText, 'R', '', [rfReplaceAll, rfIgnoreCase]));

  if FormatSettings.DecimalSeparator = ',' then
    sSkoon := StringReplace(sSkoon, '.', ',', [rfReplaceAll])
  else
    sSkoon := StringReplace(sSkoon, ',', '.', [rfReplaceAll]);

  Result := TryStrToCurr(sSkoon, cWaarde);
end;

function FormateerGeldeenheid(const cWaarde: Currency): string;
begin
  // Formateer geld konsekwent vir vertoon op alle forms en verslae.
  Result := FormatCurr('R #,##0.00', cWaarde);
end;

procedure LaaiKategoriee;
var
  fKategoriee: TextFile;
  sLyn: string;
  i: Integer;
  sLêernaam: string;
begin
  // Verstekwaardes verseker dat die program steeds werk indien die tekslêer ontbreek.
  arrKategoriee[1] := 'Handboek';
  arrKategoriee[2] := 'Werkboek';
  arrKategoriee[3] := 'Leesboek';
  arrKategoriee[4] := 'Naslaanboek';
  arrKategoriee[5] := 'Skryfbehoeftes';
  arrKategoriee[6] := 'Ander';

  sLêernaam := AppBasisPad + 'KategorieLys.txt';
  if not FileExists(sLêernaam) then
    Exit;

  AssignFile(fKategoriee, sLêernaam);
  try
    Reset(fKategoriee);
    i := 1;
    while (not Eof(fKategoriee)) and (i <= Length(arrKategoriee)) do
    begin
      ReadLn(fKategoriee, sLyn);
      sLyn := Trim(sLyn);
      if sLyn <> '' then
      begin
        arrKategoriee[i] := sLyn;
        Inc(i);
      end;
    end;
  finally
    CloseFile(fKategoriee);
  end;
end;

procedure WysFormKonteks(AForm: TForm; AKonteks: TLabel;
  const sFormTitel: string);
begin
  // Hergebruik die bestaande regterkantse kop-etiket; geen DFM-wysiging nodig nie.
  // Die gedeelde waarde is 'n rol, nie 'n persoonlike aanmeldnaam nie.
  AForm.Caption := sFormTitel + ' | ' + sAktieweGebruiker;
  AKonteks.AutoSize := False;
  AKonteks.WordWrap := False;
  AKonteks.Alignment := taRightJustify;
  AKonteks.Top := MulDiv(10, AKonteks.CurrentPPI, 96);
  AKonteks.Height := MulDiv(42, AKonteks.CurrentPPI, 96);
  AKonteks.Font.Height := -MulDiv(13, AKonteks.CurrentPPI, 96);
  AKonteks.Caption := 'Gebruikersrol: ' + sAktieweGebruiker + sLineBreak +
    'Weergawe ' + C_APP_VERSION + ' | ' + C_APP_DATE;
end;

procedure WysBoodskap(const sBoodskap: string;
  const dlgTipe: TMsgDlgType = mtInformation);
begin
  // Sentrale boodskapprosedure hou dialoogteks en styl konsekwent.
  MessageDlg(sBoodskap, dlgTipe, [mbOK], 0);
end;

initialization
  sAktieweGebruiker := 'Bestuurder';
  LaaiKategoriee;

end.
