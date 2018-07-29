object WebModule1: TWebModule1
  OldCreateOrder = False
  OnCreate = WebModuleCreate
  Actions = <
    item
      Default = True
      Name = 'DefaultHandler'
      PathInfo = '/'
      OnAction = WebModule1DefaultHandlerAction
    end
    item
      MethodType = mtGet
      Name = 'ActionLogin'
      PathInfo = '/login'
      OnAction = WebModule1ActionLoginAction
    end
    item
      MethodType = mtPost
      Name = 'ActionSynchroPhoto'
      PathInfo = '/ndf'
      OnAction = WebModule1ActionSynchroPhotoAction
    end
    item
      MethodType = mtGet
      Name = 'ActionBaseVersMobile'
      PathInfo = '/db'
      OnAction = WebModule1ActionBaseVersMobileAction
    end
    item
      MethodType = mtGet
      Name = 'UsersList'
      PathInfo = '/users'
      OnAction = WebModule1UsersListAction
    end
    item
      MethodType = mtGet
      Name = 'UserDelete'
      PathInfo = '/userdel'
      OnAction = WebModule1UsersDeleteAction
    end
    item
      MethodType = mtPost
      Name = 'UserAdd'
      PathInfo = '/useradd'
      OnAction = WebModule1UserAddAction
    end
    item
      MethodType = mtPost
      Name = 'UserChg'
      PathInfo = '/userchg'
      OnAction = WebModule1UserChgAction
    end
    item
      MethodType = mtGet
      Name = 'consultationNDF'
      PathInfo = '/visundf'
      OnAction = WebModule1consultationNDFAction
    end
    item
      MethodType = mtGet
      Name = 'ModerationNDFSuivante'
      PathInfo = '/moderenext'
      OnAction = WebModule1ModerationNDFSuivanteAction
    end
    item
      MethodType = mtPost
      Name = 'ModerationNDFDecision'
      PathInfo = '/moderechoix'
      OnAction = WebModule1ModerationNDFDecisionAction
    end>
  Height = 509
  Width = 720
  object FDConnection1: TFDConnection
    Params.Strings = (
      'LockingMode=Normal'
      
        'Database=Z:\OlfSoftware\logiciels\NotesDeFraisMobiles\dev-delphi' +
        '\base-sqlite.db'
      'DriverID=SQLite')
    LoginPrompt = False
    AfterConnect = FDConnection1AfterConnect
    BeforeConnect = FDConnection1BeforeConnect
    Left = 104
    Top = 72
  end
  object qryNotesDeFrais: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'select * from notesdefrais')
    Left = 136
    Top = 208
  end
  object FDStanStorageJSONLink1: TFDStanStorageJSONLink
    Left = 344
    Top = 240
  end
  object qryUtilisateurs: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'select * from utilisateurs')
    Left = 120
    Top = 280
  end
end
