object frmHoofmenu: TfrmHoofmenu
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'EduBoek Voorraad- en Verkoopsbestuurstelsel'
  ClientHeight = 620
  ClientWidth = 1050
  Color = 16054266
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 20
  object imgLogo: TImage
    Left = 48
    Top = 75
    Width = 450
    Height = 150
    Proportional = True
    Stretch = True
  end
  object lblSpreuk: TLabel
    Left = 420
    Top = 148
    Width = 128
    Height = 23
    Caption = 'Leer. Lees. Groei.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGrayText
    Font.Height = -17
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object lblWelkom: TLabel
    Left = 50
    Top = 230
    Width = 561
    Height = 30
    Caption = 'Welkom by EduBoek se voorraad- en verkoopsbestuurstelsel.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 3682864
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object lblKies: TLabel
    Left = 50
    Top = 268
    Width = 295
    Height = 25
    Caption = 'Kies die afdeling waarmee jy wil werk:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGrayText
    Font.Height = -18
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object lblRol: TLabel
    Left = 800
    Top = 245
    Width = 99
    Height = 20
    Caption = 'Gebruikersrol:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 3682864
    Font.Height = -15
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object pnlKop: TPanel
    Left = 0
    Top = 0
    Width = 1050
    Height = 62
    Align = alTop
    BevelOuter = bvNone
    Color = 3222951
    ParentBackground = False
    TabOrder = 0
    ExplicitWidth = 1048
    object lblMaatskappy: TLabel
      Left = 24
      Top = 18
      Width = 700
      Height = 29
      AutoSize = False
      Caption = 'EduBoek Skoolboekwinkel - Hoofmenu'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -20
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblWeergawe: TLabel
      Left = 776
      Top = 20
      Width = 242
      Height = 21
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Weergawe 1.0.0 | 17 Julie 2026'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
  end
  object btnVoorraad: TButton
    Left = 55
    Top = 330
    Width = 235
    Height = 64
    Caption = 'Voorraadbestuur'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = btnVoorraadClick
  end
  object btnVerkope: TButton
    Left = 320
    Top = 330
    Width = 235
    Height = 64
    Caption = 'Verkope vasl'#234
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = btnVerkopeClick
  end
  object btnVerslae: TButton
    Left = 585
    Top = 330
    Width = 190
    Height = 64
    Caption = 'Verslae'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = btnVerslaeClick
  end
  object cmbGebruikerRol: TComboBox
    Left = 800
    Top = 275
    Width = 205
    Height = 28
    Style = csDropDownList
    TabOrder = 4
    OnChange = cmbGebruikerRolChange
  end
  object btnHulp: TButton
    Left = 210
    Top = 430
    Width = 235
    Height = 56
    Caption = 'Hulp / instruksies'
    TabOrder = 5
    OnClick = btnHulpClick
  end
  object btnVerlaat: TButton
    Left = 485
    Top = 430
    Width = 235
    Height = 56
    Caption = 'Verlaat program'
    TabOrder = 6
    OnClick = btnVerlaatClick
  end
  object pnlStatus: TPanel
    Left = 35
    Top = 530
    Width = 980
    Height = 62
    BevelKind = bkSoft
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 7
    object lblStatusDB: TLabel
      Left = 20
      Top = 20
      Width = 188
      Height = 20
      Caption = 'Status: Databasis gekoppel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblStatusVoorraad: TLabel
      Left = 390
      Top = 20
      Width = 144
      Height = 20
      Caption = 'Lae voorraad-items: 0'
    end
    object lblStatusVerslag: TLabel
      Left = 740
      Top = 20
      Width = 127
      Height = 20
      Caption = 'Verslaggids gereed'
    end
  end
end
