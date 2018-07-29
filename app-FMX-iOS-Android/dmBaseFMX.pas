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
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Stan.StorageJSON,
  FireDAC.Comp.BatchMove.DataSet, FireDAC.Comp.BatchMove;

type
  Tdm = class(TDataModule)
    FDConnection1: TFDConnection;
    qryNotesDeFrais: TFDQuery;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    FDBatchMove1: TFDBatchMove;
    FDMemTable1: TFDMemTable;
    FDBatchMoveDataSetReader1: TFDBatchMoveDataSetReader;
    FDBatchMoveDataSetWriter1: TFDBatchMoveDataSetWriter;
    procedure DataModuleCreate(Sender: TObject);
    procedure FDConnection1BeforeConnect(Sender: TObject);
    procedure FDConnection1AfterConnect(Sender: TObject);
  private
    { Déclarations privées }
    FBaseACreer: boolean;
  public
    { Déclarations publiques }
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}
{$R *.dfm}

uses System.IOUtils, uNotesDeFrais;

procedure Tdm.DataModuleCreate(Sender: TObject);
begin
  FDConnection1.Connected := true;
end;

procedure Tdm.FDConnection1AfterConnect(Sender: TObject);
begin
  if FBaseACreer then
    NotesDeFrais_CreerBase_mobile(FDConnection1);
end;

procedure Tdm.FDConnection1BeforeConnect(Sender: TObject);
var
  DB: string;
begin
  DB := tpath.Combine(NotesDeFrais_BaseName, 'notesdefrais-mobile.db');
  FBaseACreer := not tfile.Exists(DB);
  FDConnection1.Params.Database := DB;
end;

end.
