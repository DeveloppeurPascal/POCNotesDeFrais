unit dmBaseFMX;

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
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Stan.StorageJSON, System.Net.URLClient,
  System.Net.HttpClient, System.Net.HttpClientComponent;

type
  TdmBaseNotesDeFrais = class(TDataModule)
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    tabUtilisateurs: TFDMemTable;
    NetHTTPClient1: TNetHTTPClient;
    tabUtilisateurscode: TIntegerField;
    tabUtilisateursnom: TWideMemoField;
    tabUtilisateursprenom: TWideMemoField;
    tabUtilisateursemail: TWideMemoField;
    tabUtilisateursmotdepasse: TWideMemoField;
    procedure DataModuleCreate(Sender: TObject);
    procedure tabUtilisateursBeforePost(DataSet: TDataSet);
    procedure tabUtilisateursBeforeDelete(DataSet: TDataSet);
  private
    { Déclarations privées }
    procedure ListeUtilisateursRecue(const Sender: TObject; const AResponse: IHTTPResponse);
  public
    { Déclarations publiques }
  end;

var
  dmBaseNotesDeFrais: TdmBaseNotesDeFrais;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses uNotesDeFrais, System.IOUtils, System.JSON, System.Net.MIME;

{$R *.dfm}

procedure TdmBaseNotesDeFrais.DataModuleCreate(Sender: TObject);
var
  Net: tnethttprequest;
begin
  Net := tnethttprequest.Create(self);
  try
    Net.Client := NetHTTPClient1;
    Net.OnRequestCompleted := ListeUtilisateursRecue;
    Net.Get('http://' + Serveur_IP + ':' + Serveur_Port + '/users');
  finally
    freeandnil(Net);
  end;
end;

procedure TdmBaseNotesDeFrais.ListeUtilisateursRecue(const Sender: TObject; const AResponse: IHTTPResponse);
var
  s: tstringstream;
  jso: tjsonobject;
begin
  if tabUtilisateurs.Active then
  begin
    tabUtilisateurs.EmptyDataSet;
    tabUtilisateurs.Close;
  end;
  jso := tjsonobject.ParseJSONValue(AResponse.ContentAsString(tencoding.UTF8)) as tjsonobject;
  try
    if (jso.GetValue('erreur') as TJSONNumber).AsInt = 0 then
    begin
      s := tstringstream.Create((jso.GetValue('base') as TJSONString).Value, tencoding.ANSI);
      try
        tabUtilisateurs.LoadFromStream(s, tfdstorageformat.sfJSON);
      finally
        freeandnil(s);
      end;
    end
    else
      raise exception.Create('erreur chargement base utilisateurs (' + (jso.GetValue('erreur') as TJSONNumber).AsInt.ToString + ')');
  finally
    freeandnil(jso);
  end;
  tabUtilisateurs.Open;
end;

procedure TdmBaseNotesDeFrais.tabUtilisateursBeforeDelete(DataSet: TDataSet);
var
  Net: tnethttprequest;
begin
  Net := tnethttprequest.Create(self);
  try
    Net.Client := NetHTTPClient1;
    Net.Get('http://' + Serveur_IP + ':' + Serveur_Port + '/userdel?code=' + DataSet.FieldByName('code').AsString);
  finally
    freeandnil(Net);
  end;
end;

procedure TdmBaseNotesDeFrais.tabUtilisateursBeforePost(DataSet: TDataSet);
var
  Net: tnethttprequest;
  s: tstringlist;
  reponse: tstringstream;
begin
  if DataSet.State in [TDataSetState.dsEdit, TDataSetState.dsInsert] then
  begin
    Net := tnethttprequest.Create(self);
    try
      s := tstringlist.Create;
      try
        s.AddPair('nom', DataSet.FieldByName('nom').AsString);
        s.AddPair('prenom', DataSet.FieldByName('prenom').AsString);
        s.AddPair('email', DataSet.FieldByName('email').AsString);
        s.AddPair('motdepasse', DataSet.FieldByName('motdepasse').AsString);
        Net.Client := NetHTTPClient1;
        if DataSet.State = TDataSetState.dsInsert then
        begin
          reponse := tstringstream.Create;
          try
            Net.post('http://' + Serveur_IP + ':' + Serveur_Port + '/useradd', s, reponse);
            DataSet.FieldByName('code').AsString := reponse.DataString;
          finally
            reponse.Free;
          end;
        end
        else
        begin
          s.AddPair('code', DataSet.FieldByName('code').AsString);
          Net.post('http://' + Serveur_IP + ':' + Serveur_Port + '/userchg', s);
        end;
      finally
        freeandnil(s);
      end;
    finally
      freeandnil(Net);
    end;
  end;
end;

end.
