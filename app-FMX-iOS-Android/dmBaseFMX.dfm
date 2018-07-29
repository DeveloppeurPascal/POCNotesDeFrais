object dm: Tdm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 438
  Width = 611
  object FDConnection1: TFDConnection
    Params.Strings = (
      
        'Database=Z:\OlfSoftware\logiciels\NotesDeFraisMobiles\dev-delphi' +
        '\base-sqlite-mobile.db'
      'DriverID=SQLite')
    ResourceOptions.AssignedValues = [rvAutoReconnect]
    LoginPrompt = False
    AfterConnect = FDConnection1AfterConnect
    BeforeConnect = FDConnection1BeforeConnect
    Left = 64
    Top = 104
  end
  object qryNotesDeFrais: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'select * from notesdefrais order by datendf desc')
    Left = 112
    Top = 216
  end
  object FDStanStorageJSONLink1: TFDStanStorageJSONLink
    Left = 120
    Top = 312
  end
  object FDBatchMove1: TFDBatchMove
    Reader = FDBatchMoveDataSetReader1
    Writer = FDBatchMoveDataSetWriter1
    Options = [poClearDestNoUndo, poIdentityInsert, poCreateDest, poSkipUnmatchedDestFields]
    Mappings = <>
    LogFileName = 'Data.log'
    Left = 472
    Top = 264
  end
  object FDMemTable1: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 272
    Top = 320
  end
  object FDBatchMoveDataSetReader1: TFDBatchMoveDataSetReader
    DataSet = FDMemTable1
    Left = 376
    Top = 304
  end
  object FDBatchMoveDataSetWriter1: TFDBatchMoveDataSetWriter
    Direct = True
    DataSet = qryNotesDeFrais
    Optimise = False
    Left = 480
    Top = 360
  end
end
