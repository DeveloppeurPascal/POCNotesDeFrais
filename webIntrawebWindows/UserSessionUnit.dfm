object IWUserSession: TIWUserSession
  OldCreateOrder = False
  OnCreate = IWUserSessionBaseCreate
  Height = 369
  Width = 479
  object FDMemTable1: TFDMemTable
    OnCalcFields = FDMemTable1CalcFields
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate, uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 136
    Top = 152
    object FDMemTable1nom: TWideMemoField
      FieldName = 'nom'
      ReadOnly = True
      Visible = False
      BlobType = ftWideMemo
    end
    object FDMemTable1nom2: TStringField
      DisplayLabel = 'Nom'
      DisplayWidth = 100
      FieldKind = fkCalculated
      FieldName = 'nom2'
      ReadOnly = True
      Calculated = True
    end
    object FDMemTable1prenom: TWideMemoField
      FieldName = 'prenom'
      ReadOnly = True
      Visible = False
      BlobType = ftWideMemo
    end
    object FDMemTable1prenom2: TStringField
      DisplayLabel = 'Pr'#233'nom'
      DisplayWidth = 100
      FieldKind = fkCalculated
      FieldName = 'prenom2'
      ReadOnly = True
      Calculated = True
    end
    object FDMemTable1email: TWideMemoField
      FieldName = 'email'
      ReadOnly = True
      Visible = False
      BlobType = ftWideMemo
    end
    object FDMemTable1email2: TStringField
      DisplayLabel = 'Email'
      DisplayWidth = 100
      FieldKind = fkCalculated
      FieldName = 'email2'
      ReadOnly = True
      Calculated = True
    end
    object FDMemTable1datendf: TWideMemoField
      FieldName = 'datendf'
      ReadOnly = True
      Visible = False
      BlobType = ftWideMemo
    end
    object FDMemTable1datendf2: TStringField
      DisplayLabel = 'Date'
      DisplayWidth = 50
      FieldKind = fkCalculated
      FieldName = 'datendf2'
      Calculated = True
    end
    object FDMemTable1lieu: TWideMemoField
      FieldName = 'lieu'
      ReadOnly = True
      Visible = False
      BlobType = ftWideMemo
    end
    object FDMemTable1lieu2: TStringField
      DisplayLabel = 'Lieu'
      DisplayWidth = 100
      FieldKind = fkCalculated
      FieldName = 'lieu2'
      ReadOnly = True
      Calculated = True
    end
    object FDMemTable1montant: TFloatField
      FieldName = 'montant'
    end
    object FDMemTable1acceptee: TWideMemoField
      FieldName = 'acceptee'
      ReadOnly = True
      Visible = False
      BlobType = ftWideMemo
    end
    object FDMemTable1acceptee2: TStringField
      DisplayLabel = 'Accord ?'
      DisplayWidth = 10
      FieldKind = fkCalculated
      FieldName = 'acceptee2'
      ReadOnly = True
      Calculated = True
    end
    object FDMemTable1dateaccord: TWideMemoField
      FieldName = 'dateaccord'
      ReadOnly = True
      Visible = False
      BlobType = ftWideMemo
    end
    object FDMemTable1dateaccord2: TDateField
      DisplayLabel = 'Date accord'
      DisplayWidth = 50
      FieldKind = fkCalculated
      FieldName = 'dateaccord2'
      ReadOnly = True
      Calculated = True
    end
  end
  object NetHTTPClient1: TNetHTTPClient
    Asynchronous = False
    ConnectionTimeout = 60000
    ResponseTimeout = 60000
    AllowCookies = True
    HandleRedirects = True
    UserAgent = 'Embarcadero URI Client/1.0'
    Left = 264
    Top = 112
  end
  object FDStanStorageJSONLink1: TFDStanStorageJSONLink
    Left = 312
    Top = 168
  end
end
