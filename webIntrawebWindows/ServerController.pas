unit ServerController;

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
  SysUtils, Classes, IWServerControllerBase, IWBaseForm, HTTPApp,
  // For OnNewSession Event
  UserSessionUnit, IWApplication, IWAppForm, IW.Browser.Browser,
  IW.HTTP.Request, IW.HTTP.Reply, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteDef, FireDAC.Phys.SQLite,
  FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef;

type
  TIWServerController = class(TIWServerControllerBase)
    procedure IWServerControllerBaseNewSession(ASession: TIWApplication);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function UserSession: TIWUserSession;
function IWServerController: TIWServerController;

implementation

{$R *.dfm}

uses
  IWInit, IWGlobal, System.IOUTils, uNotesDeFrais;

function IWServerController: TIWServerController;
begin
  Result := TIWServerController(GServerController);
end;

function UserSession: TIWUserSession;
begin
  Result := TIWUserSession(WebApplication.Data);
end;

{ TIWServerController }

procedure TIWServerController.IWServerControllerBaseNewSession(ASession: TIWApplication);
begin
  ASession.Data := TIWUserSession.Create(nil, ASession);
end;

initialization

TIWServerController.SetServerControllerClass;

end.
