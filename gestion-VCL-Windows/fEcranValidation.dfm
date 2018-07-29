object frmEcranValidation: TfrmEcranValidation
  Left = 0
  Top = 0
  Caption = 'Validation des notes de frais'
  ClientHeight = 497
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 185
    Top = 0
    Width = 450
    Height = 497
    Align = alClient
    Proportional = True
    Stretch = True
    ExplicitLeft = 272
    ExplicitTop = 120
    ExplicitWidth = 105
    ExplicitHeight = 105
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 497
    Align = alLeft
    TabOrder = 0
    object lblCode: TLabel
      Left = 24
      Top = 309
      Width = 35
      Height = 13
      Caption = 'lblCode'
      Visible = False
    end
    object edtNom: TLabeledEdit
      Left = 14
      Top = 24
      Width = 121
      Height = 21
      EditLabel.Width = 21
      EditLabel.Height = 13
      EditLabel.Caption = 'Nom'
      Enabled = False
      ReadOnly = True
      TabOrder = 0
    end
    object edtLieu: TLabeledEdit
      Left = 14
      Top = 149
      Width = 121
      Height = 21
      EditLabel.Width = 19
      EditLabel.Height = 13
      EditLabel.Caption = 'Lieu'
      TabOrder = 3
    end
    object edtPrenom: TLabeledEdit
      Left = 14
      Top = 64
      Width = 121
      Height = 21
      EditLabel.Width = 36
      EditLabel.Height = 13
      EditLabel.Caption = 'Pr'#233'nom'
      Enabled = False
      ReadOnly = True
      TabOrder = 1
    end
    object edtEmail: TLabeledEdit
      Left = 14
      Top = 104
      Width = 121
      Height = 21
      EditLabel.Width = 24
      EditLabel.Height = 13
      EditLabel.Caption = 'Email'
      Enabled = False
      ReadOnly = True
      TabOrder = 2
    end
    object edtMontant: TLabeledEdit
      Left = 14
      Top = 231
      Width = 121
      Height = 21
      EditLabel.Width = 40
      EditLabel.Height = 13
      EditLabel.Caption = 'Montant'
      TabOrder = 5
    end
    object edtDate: TLabeledEdit
      Left = 14
      Top = 189
      Width = 121
      Height = 21
      EditLabel.Width = 23
      EditLabel.Height = 13
      EditLabel.Caption = 'Date'
      TabOrder = 4
    end
    object btnRejeter: TBitBtn
      Left = 95
      Top = 272
      Width = 75
      Height = 25
      Caption = 'Rejeter'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 7
      OnClick = btnRejeterClick
    end
    object btnAccepter: TBitBtn
      Left = 14
      Top = 272
      Width = 75
      Height = 25
      Caption = 'Valider'
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 6
      OnClick = btnAccepterClick
    end
  end
  object NetHTTPClient1: TNetHTTPClient
    Asynchronous = False
    ConnectionTimeout = 60000
    ResponseTimeout = 60000
    AllowCookies = True
    HandleRedirects = True
    UserAgent = 'POCNotesDeFraisValidation'
    Left = 424
    Top = 208
  end
  object NetHTTPRequestNDFSuivante: TNetHTTPRequest
    Asynchronous = False
    ConnectionTimeout = 60000
    ResponseTimeout = 60000
    Client = NetHTTPClient1
    OnRequestCompleted = NetHTTPRequestNDFSuivanteRequestCompleted
    Left = 424
    Top = 264
  end
  object NetHTTPRequestAccordOuRejet: TNetHTTPRequest
    Asynchronous = False
    ConnectionTimeout = 60000
    ResponseTimeout = 60000
    Client = NetHTTPClient1
    OnRequestCompleted = NetHTTPRequestAccordOuRejetRequestCompleted
    Left = 424
    Top = 320
  end
end
