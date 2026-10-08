object frmVoorraad: TfrmVoorraad
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'EduBoek - Voorraadbestuur'
  ClientHeight = 660
  ClientWidth = 1120
  Color = 16054266
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 19
  object lblSoek: TLabel
    Left = 28
    Top = 84
    Width = 32
    Height = 19
    Caption = 'Soek:'
  end
  object lblBoekKode: TLabel
    Left = 28
    Top = 138
    Width = 63
    Height = 19
    Caption = 'Boekkode:'
  end
  object lblBoekTitel: TLabel
    Left = 28
    Top = 178
    Width = 28
    Height = 19
    Caption = 'Titel:'
  end
  object lblGraad: TLabel
    Left = 28
    Top = 218
    Width = 40
    Height = 19
    Caption = 'Graad:'
  end
  object lblVak: TLabel
    Left = 28
    Top = 258
    Width = 25
    Height = 19
    Caption = 'Vak:'
  end
  object lblKategorie: TLabel
    Left = 28
    Top = 298
    Width = 61
    Height = 19
    Caption = 'Kategorie:'
  end
  object lblPrys: TLabel
    Left = 28
    Top = 338
    Width = 29
    Height = 19
    Caption = 'Prys:'
  end
  object lblVoorraad: TLabel
    Left = 28
    Top = 378
    Width = 59
    Height = 19
    Caption = 'Voorraad:'
  end
  object lblMinimum: TLabel
    Left = 28
    Top = 418
    Width = 121
    Height = 19
    Caption = 'Minimum voorraad:'
  end
  object pnlKop: TPanel
    Left = 0
    Top = 0
    Width = 1120
    Height = 62
    Align = alTop
    BevelOuter = bvNone
    Color = 3222951
    ParentBackground = False
    TabOrder = 0
    ExplicitWidth = 1118
    object lblTitel: TLabel
      Left = 24
      Top = 18
      Width = 683
      Height = 29
      AutoSize = False
      Caption = 'EduBoek - Voorraadbestuur'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -20
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblSubtitel: TLabel
      Left = 731
      Top = 21
      Width = 365
      Height = 21
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Bestuur boek- en voorraadrekords'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
  end
  object edtSoek: TEdit
    Left = 76
    Top = 80
    Width = 295
    Height = 27
    TabOrder = 1
    TextHint = 'Tik boekkode of titel...'
  end
  object btnSoek: TButton
    Left = 382
    Top = 78
    Width = 82
    Height = 31
    Caption = 'Soek'
    TabOrder = 2
    OnClick = btnSoekClick
  end
  object btnWysAlles: TButton
    Left = 474
    Top = 78
    Width = 102
    Height = 31
    Caption = 'Wys alles'
    TabOrder = 3
    OnClick = btnWysAllesClick
  end
  object edtBoekKode: TEdit
    Left = 162
    Top = 134
    Width = 230
    Height = 27
    MaxLength = 10
    TabOrder = 4
  end
  object edtTitel: TEdit
    Left = 162
    Top = 174
    Width = 360
    Height = 27
    MaxLength = 80
    TabOrder = 5
  end
  object cmbGraad: TComboBox
    Left = 162
    Top = 214
    Width = 145
    Height = 27
    Style = csDropDownList
    TabOrder = 6
  end
  object edtVak: TEdit
    Left = 162
    Top = 254
    Width = 260
    Height = 27
    MaxLength = 30
    TabOrder = 7
  end
  object cmbKategorie: TComboBox
    Left = 162
    Top = 294
    Width = 220
    Height = 27
    Style = csDropDownList
    TabOrder = 8
  end
  object edtPrys: TEdit
    Left = 162
    Top = 334
    Width = 145
    Height = 27
    TabOrder = 9
  end
  object spnVoorraad: TSpinEdit
    Left = 162
    Top = 374
    Width = 120
    Height = 29
    MaxValue = 10000
    MinValue = 0
    TabOrder = 10
    Value = 0
  end
  object spnMinimum: TSpinEdit
    Left = 162
    Top = 414
    Width = 120
    Height = 29
    MaxValue = 10000
    MinValue = 0
    TabOrder = 11
    Value = 5
  end
  object chkAktief: TCheckBox
    Left = 162
    Top = 456
    Width = 97
    Height = 24
    Caption = 'Aktief'
    Checked = True
    State = cbChecked
    TabOrder = 12
  end
  object dbgBoeke: TDBGrid
    Left = 548
    Top = 130
    Width = 540
    Height = 350
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ReadOnly = True
    TabOrder = 13
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -14
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnCellClick = dbgBoekeCellClick
  end
  object btnVoegBy: TButton
    Left = 28
    Top = 522
    Width = 120
    Height = 42
    Caption = 'Voeg by'
    TabOrder = 14
    OnClick = btnVoegByClick
  end
  object btnWysig: TButton
    Left = 164
    Top = 522
    Width = 110
    Height = 42
    Caption = 'Wysig'
    TabOrder = 15
    OnClick = btnWysigClick
  end
  object btnVerwyder: TButton
    Left = 290
    Top = 522
    Width = 125
    Height = 42
    Caption = 'Verwyder'
    TabOrder = 16
    OnClick = btnVerwyderClick
  end
  object btnMaakSkoon: TButton
    Left = 431
    Top = 522
    Width = 125
    Height = 42
    Caption = 'Maak skoon'
    TabOrder = 17
    OnClick = btnMaakSkoonClick
  end
  object btnTerug: TButton
    Left = 572
    Top = 522
    Width = 110
    Height = 42
    Caption = 'Terug'
    TabOrder = 18
    OnClick = btnTerugClick
  end
  object pnlStatus: TPanel
    Left = 28
    Top = 590
    Width = 1060
    Height = 45
    BevelKind = bkSoft
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 19
    object lblStatus: TLabel
      Left = 14
      Top = 12
      Width = 312
      Height = 19
      Caption = 'Status: Gereed. Kies '#8217'n rekord of voer nuwe data in.'
    end
  end
end
