object frmVerkope: TfrmVerkope
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'EduBoek - Verkope'
  ClientHeight = 650
  ClientWidth = 1040
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
    Width = 1040
    Height = 62
    Align = alTop
    BevelOuter = bvNone
    Color = $00312DA7
    ParentBackground = False
    TabOrder = 0
    object lblTitel: TLabel
      Left = 24
      Top = 18
      Width = 638
      Height = 29
      Alignment = taLeftJustify
      AutoSize = False
      Caption = 'EduBoek - Verkope'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -20
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblSubtitel: TLabel
      Left = 686
      Top = 21
      Width = 330
      Height = 21
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Vaslegging van boekverkope'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
  end
  object lblInstruksie: TLabel
    Left = 36
    Top = 82
    Width = 776
    Height = 19
    Caption = 'Kies '#8217'n boek en voer die hoeveelheid in. Die program kontroleer voorraad voordat die verkoop gestoor word.'
  end
  object lblBoek: TLabel
    Left = 44
    Top = 144
    Width = 35
    Height = 19
    Caption = 'Boek:'
  end
  object cmbBoek: TComboBox
    Left = 190
    Top = 140
    Width = 420
    Height = 27
    Style = csDropDownList
    TabOrder = 1
    OnChange = cmbBoekChange
  end
  object lblEenheidsPrys: TLabel
    Left = 44
    Top = 194
    Width = 91
    Height = 19
    Caption = 'Eenheidsprys:'
  end
  object lblPrysWaarde: TLabel
    Left = 190
    Top = 194
    Width = 45
    Height = 19
    Caption = 'R 0.00'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = $00312DA7
    Font.Height = -14
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblBeskikbaar: TLabel
    Left = 44
    Top = 244
    Width = 135
    Height = 19
    Caption = 'Beskikbare voorraad:'
  end
  object lblBeskikbaarWaarde: TLabel
    Left = 190
    Top = 244
    Width = 9
    Height = 19
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = $00312DA7
    Font.Height = -14
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblHoeveelheid: TLabel
    Left = 44
    Top = 294
    Width = 83
    Height = 19
    Caption = 'Hoeveelheid:'
  end
  object edtHoeveelheid: TEdit
    Left = 190
    Top = 290
    Width = 130
    Height = 27
    NumbersOnly = True
    TabOrder = 2
  end
  object pnlTotaal: TPanel
    Left = 44
    Top = 350
    Width = 566
    Height = 102
    BevelKind = bkSoft
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 3
    object lblTotaalOpskrif: TLabel
      Left = 20
      Top = 18
      Width = 108
      Height = 23
      Caption = 'Verkoopstotaal'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblTotaal: TLabel
      Left = 386
      Top = 45
      Width = 150
      Height = 39
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'R 0.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = $00312DA7
      Font.Height = -28
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object btnBereken: TButton
    Left = 44
    Top = 490
    Width = 150
    Height = 44
    Caption = 'Bereken totaal'
    TabOrder = 4
    OnClick = btnBerekenClick
  end
  object btnStoorVerkoop: TButton
    Left = 210
    Top = 490
    Width = 165
    Height = 44
    Caption = 'Stoor verkoop'
    TabOrder = 5
    OnClick = btnStoorVerkoopClick
  end
  object btnMaakSkoon: TButton
    Left = 391
    Top = 490
    Width = 145
    Height = 44
    Caption = 'Maak skoon'
    TabOrder = 6
    OnClick = btnMaakSkoonClick
  end
  object btnTerug: TButton
    Left = 552
    Top = 490
    Width = 110
    Height = 44
    Caption = 'Terug'
    TabOrder = 7
    OnClick = btnTerugClick
  end
  object pnlBesonderhede: TPanel
    Left = 665
    Top = 132
    Width = 335
    Height = 400
    BevelKind = bkSoft
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 8
    object lblBesonderhede: TLabel
      Left = 18
      Top = 16
      Width = 174
      Height = 23
      Caption = 'Verkoopbesonderhede'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = $00312DA7
      Font.Height = -17
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object memBesonderhede: TMemo
      Left = 18
      Top = 54
      Width = 298
      Height = 325
      Color = clBtnFace
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object pnlStatus: TPanel
    Left = 44
    Top = 572
    Width = 956
    Height = 48
    BevelKind = bkSoft
    BevelOuter = bvNone
    Color = clBtnFace
    ParentBackground = False
    TabOrder = 9
    object lblStatus: TLabel
      Left = 14
      Top = 13
      Width = 323
      Height = 19
      Caption = 'Status: Kies '#8217'n boek en voer die hoeveelheid in.'
    end
  end
end
