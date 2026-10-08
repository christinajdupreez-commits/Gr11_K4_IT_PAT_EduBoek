object frmVerslae: TfrmVerslae
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'EduBoek - Verslae'
  ClientHeight = 680
  ClientWidth = 1180
  Color = $00F4F7FA
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 19
  object pnlKop: TPanel
    Left = 0
    Top = 0
    Width = 1180
    Height = 62
    Align = alTop
    BevelOuter = bvNone
    Color = $00312DA7
    ParentBackground = False
    TabOrder = 0
    object lblTitel: TLabel
      Left = 24
      Top = 18
      Width = 668
      Height = 29
      Alignment = taLeftJustify
      AutoSize = False
      Caption = 'EduBoek - Verslae'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -20
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblSubtitel: TLabel
      Left = 716
      Top = 21
      Width = 440
      Height = 21
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Lae voorraad, verkope en kategorie-opsommings'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
  end
  object btnLaeVoorraad: TButton
    Left = 28
    Top = 82
    Width = 170
    Height = 42
    Caption = 'Wys lae voorraad'
    TabOrder = 1
    OnClick = btnLaeVoorraadClick
  end
  object btnVerkoopsOpsomming: TButton
    Left = 210
    Top = 82
    Width = 208
    Height = 42
    Caption = 'Wys verkoopsopsomming'
    TabOrder = 2
    OnClick = btnVerkoopsOpsommingClick
  end
  object btnKategorieOpsomming: TButton
    Left = 430
    Top = 82
    Width = 215
    Height = 42
    Caption = 'Wys kategorie-opsomming'
    TabOrder = 3
    OnClick = btnKategorieOpsommingClick
  end
  object btnSkryfTeksleer: TButton
    Left = 657
    Top = 82
    Width = 205
    Height = 42
    Caption = 'Skryf verslag na teksl'#234'er'
    TabOrder = 4
    OnClick = btnSkryfTeksleerClick
  end
  object btnOpenGids: TButton
    Left = 874
    Top = 82
    Width = 130
    Height = 42
    Caption = 'Open gids'
    TabOrder = 5
    OnClick = btnOpenGidsClick
  end
  object btnMaakSkoon: TButton
    Left = 1016
    Top = 82
    Width = 130
    Height = 42
    Caption = 'Maak skoon'
    TabOrder = 6
    OnClick = btnMaakSkoonClick
  end
  object redVerslag: TRichEdit
    Left = 28
    Top = 148
    Width = 1118
    Height = 430
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 7
  end
  object btnTerug: TButton
    Left = 1016
    Top = 600
    Width = 130
    Height = 42
    Caption = 'Terug'
    TabOrder = 8
    OnClick = btnTerugClick
  end
  object pnlStatus: TPanel
    Left = 28
    Top = 600
    Width = 970
    Height = 42
    BevelKind = bkSoft
    BevelOuter = bvNone
    Color = clBtnFace
    ParentBackground = False
    TabOrder = 9
    object lblStatus: TLabel
      Left = 14
      Top = 10
      Width = 247
      Height = 19
      Caption = 'Status: Kies '#8217'n verslag om te genereer.'
    end
  end
end
