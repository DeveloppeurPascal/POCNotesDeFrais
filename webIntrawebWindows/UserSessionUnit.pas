unit UserSessionUnit;

(*
	Projet : POC Notes de frais
	URL du projet : https://www.developpeur-pascal.fr/p/_6006-poc-notes-de-frais-une-application-multiplateforme-de-saisie-de-notes-de-frais-en-itinerance.html
	
	Auteur : Patrick Prémartin https://patrick.premartin.fr
	Editeur : Olf Software https://www.olfsoftware.fr

	Site web : https://www.developpeur-pascal.fr/
	
	Ce fichier et ceux qui l'accompagnent sont fournis en l'état, sans garantie, à titre d'exemple d'utilisation de fonctionnalités de Delphi dans sa version Tokyo 10.2
	Vous pouvez vous en inspirer dans vos projets mais n'êtes pas autorisé à rediffuser tout ou partie des fichiers de ce projet sans accord écrit préalable.
*)

interface

uses
  IWUserSessionBase, SysUtils, Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.Net.URLClient,
  System.Net.HttpClient, System.Net.HttpClientComponent, FireDAC.Stan.StorageJSON;

type
  TIWUserSession = class(TIWUserSessionBase)
    FDMemTable1: TFDMemTable;
    NetHTTPClient1: TNetHTTPClient;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    FDMemTable1nom2: TStringField;
    FDMemTable1prenom2: TStringField;
    FDMemTable1email2: TStringField;
    FDMemTable1lieu2: TStringField;
    FDMemTable1acceptee2: TStringField;
    FDMemTable1dateaccord2: TDateField;
    FDMemTable1nom: TWideMemoField;
    FDMemTable1prenom: TWideMemoField;
    FDMemTable1email: TWideMemoField;
    FDMemTable1datendf: TWideMemoField;
    FDMemTable1lieu: TWideMemoField;
    FDMemTable1acceptee: TWideMemoField;
    FDMemTable1dateaccord: TWideMemoField;
    FDMemTable1montant: TFloatField;
    FDMemTable1datendf2: TStringField;
    procedure IWUserSessionBaseCreate(Sender: TObject);
    procedure FDMemTable1CalcFields(DataSet: TDataSet);
  private
    { Private declarations }
    procedure ListeRecue(const Sender: TObject; const AResponse: IHTTPResponse);
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses System.json, uNotesDeFrais;

{ TIWUserSession }

procedure TIWUserSession.FDMemTable1CalcFields(DataSet: TDataSet);
begin
  DataSet.FieldByName('nom2').AsString := DataSet.FieldByName('nom').AsString;
  DataSet.FieldByName('prenom2').AsString := DataSet.FieldByName('prenom').AsString;
  DataSet.FieldByName('email2').AsString := DataSet.FieldByName('email').AsString;
  DataSet.FieldByName('datendf2').AsString := DataSet.FieldByName('datendf').AsString;
  DataSet.FieldByName('lieu2').AsString := DataSet.FieldByName('lieu').AsString;
  DataSet.FieldByName('acceptee2').AsString := DataSet.FieldByName('acceptee').AsString;
  DataSet.FieldByName('dateaccord2').AsString := DataSet.FieldByName('dateaccord').AsString;
end;

procedure TIWUserSession.IWUserSessionBaseCreate(Sender: TObject);
var
  Net: tnethttprequest;
begin
  Net := tnethttprequest.Create(self);
  try
    Net.Client := NetHTTPClient1;
    Net.OnRequestCompleted := ListeRecue;
    Net.Get('http://' + Serveur_IP + ':' + Serveur_Port + '/visundf');
  finally
    freeandnil(Net);
  end;
end;

procedure TIWUserSession.ListeRecue(const Sender: TObject; const AResponse: IHTTPResponse);
var
  s: tstringstream;
  jso: tjsonobject;
begin
  if FDMemTable1.Active then
  begin
    FDMemTable1.EmptyDataSet;
    FDMemTable1.Close;
  end;
  jso := tjsonobject.ParseJSONValue(AResponse.ContentAsString(tencoding.UTF8)) as tjsonobject;
  try
    if (jso.GetValue('erreur') as TJSONNumber).AsInt = 0 then
    begin
      s := tstringstream.Create((jso.GetValue('base') as TJSONString).Value, tencoding.ANSI);
      try
        FDMemTable1.LoadFromStream(s, tfdstorageformat.sfJSON);
      finally
        freeandnil(s);
      end;
    end
    else
      raise exception.Create('erreur chargement base (' + (jso.GetValue('erreur') as TJSONNumber).AsInt.ToString + ')');
  finally
    freeandnil(jso);
  end;
  FDMemTable1.Open;
end;

end.
