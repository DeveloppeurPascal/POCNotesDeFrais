object dmBaseNotesDeFrais: TdmBaseNotesDeFrais
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 371
  Width = 656
  object FDStanStorageJSONLink1: TFDStanStorageJSONLink
    Left = 416
    Top = 120
  end
  object tabUtilisateurs: TFDMemTable
    BeforePost = tabUtilisateursBeforePost
    BeforeDelete = tabUtilisateursBeforeDelete
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 168
    Top = 160
    object tabUtilisateurscode: TIntegerField
      FieldName = 'code'
      Visible = False
    end
    object tabUtilisateursnom: TWideMemoField
      DisplayLabel = 'Nom'
      FieldName = 'nom'
      BlobType = ftWideMemo
    end
    object tabUtilisateursprenom: TWideMemoField
      DisplayLabel = 'Pr'#233'nom'
      FieldName = 'prenom'
      BlobType = ftWideMemo
    end
    object tabUtilisateursemail: TWideMemoField
      DisplayLabel = 'Email'
      FieldName = 'email'
      Required = True
      BlobType = ftWideMemo
    end
    object tabUtilisateursmotdepasse: TWideMemoField
      DisplayLabel = 'Mot de passe'
      FieldName = 'motdepasse'
      Required = True
      BlobType = ftWideMemo
    end
  end
  object NetHTTPClient1: TNetHTTPClient
    Asynchronous = False
    ConnectionTimeout = 60000
    ResponseTimeout = 60000
    AllowCookies = True
    HandleRedirects = True
    UserAgent = 'POCNotesDeFraisUserAdmin'
    Left = 312
    Top = 168
  end
end
