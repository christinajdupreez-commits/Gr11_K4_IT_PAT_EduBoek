object dmData: TdmData
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 280
  Width = 430
  object conBoekwinkel: TADOConnection
    LoginPrompt = False
    Left = 48
    Top = 32
  end
  object qryBoeke: TADOQuery
    Connection = conBoekwinkel
    CursorType = ctStatic
    Parameters = <>
    Left = 48
    Top = 96
  end
  object qryVerkope: TADOQuery
    Connection = conBoekwinkel
    CursorType = ctStatic
    Parameters = <>
    Left = 152
    Top = 96
  end
  object qryWerk: TADOQuery
    Connection = conBoekwinkel
    Parameters = <>
    Left = 256
    Top = 96
  end
  object dsBoeke: TDataSource
    DataSet = qryBoeke
    Left = 48
    Top = 168
  end
  object dsVerkope: TDataSource
    DataSet = qryVerkope
    Left = 152
    Top = 168
  end
end
