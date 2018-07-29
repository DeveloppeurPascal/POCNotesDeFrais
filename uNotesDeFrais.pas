unit uNotesDeFrais;

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

uses FireDAC.Comp.Client;

Const
  Serveur_IP = '192.168.1.15'; //'127.0.0.1';
  Serveur_Port = '8080';

function NotesDeFrais_DataPath: string;
function NotesDeFrais_BaseName: string;
function NotesDeFrais_PhotosPath: string;
function NotesDeFrais_PhotosPath_mobile: string;
procedure NotesDeFrais_CreerBase(Connection: TFDConnection);
procedure NotesDeFrais_CreerBase_mobile(Connection: TFDConnection);

implementation

uses System.SysUtils, System.IOUtils;

function NotesDeFrais_DataPath: string;
var
  path: string;
begin
{$IFDEF LINUX}
  path := '/home/POCNotesDeFrais';
{$ELSE}
  path := tpath.Combine(tpath.GetDocumentsPath, 'POCNotesDeFrais');
{$ENDIF}
  if (not tdirectory.Exists(path)) then
    tdirectory.CreateDirectory(path);
  result := path;
end;

function NotesDeFrais_BaseName: string;
var
  path: string;
begin
  path := tpath.Combine(NotesDeFrais_DataPath, 'Database');
  if (not tdirectory.Exists(path)) then
    tdirectory.CreateDirectory(path);
  result := path;
end;

function NotesDeFrais_PhotosPath: string;
var
  path: string;
begin
  path := tpath.Combine(NotesDeFrais_DataPath, 'Photos');
  if (not tdirectory.Exists(path)) then
    tdirectory.CreateDirectory(path);
  result := path;
end;

function NotesDeFrais_PhotosPath_mobile: string;
var
  path: string;
begin
  path := tpath.Combine(NotesDeFrais_DataPath, 'PhotosSurMobile');
  if (not tdirectory.Exists(path)) then
    tdirectory.CreateDirectory(path);
  result := path;
end;

procedure NotesDeFrais_CreerBase(Connection: TFDConnection);
begin
  Connection.execsql
    ('CREATE TABLE `notesdefrais` ( `code` INTEGER PRIMARY KEY AUTOINCREMENT, `utilisateur_code` INTEGER DEFAULT 0, `mobile_code` TEXT DEFAULT '''', `datendf` TEXT DEFAULT ''0000-00-00'', '
    + '`lieu` TEXT DEFAULT '''', `montant` REAL DEFAULT 0, `avalider` TEXT DEFAULT ''O'', `acceptee` TEXT DEFAULT ''N'', `dateaccord` TEXT DEFAULT ''0000-00-00'' )');
  Connection.execsql
    ('CREATE TABLE `utilisateurs` ( `code` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, `nom` TEXT NOT NULL DEFAULT '''', `prenom` TEXT NOT NULL DEFAULT '''', `email` TEXT NOT NULL DEFAULT '''', `motdepasse` TEXT NOT NULL DEFAULT '''' )');
  Connection.execsql('CREATE INDEX `par_avalider` ON `notesdefrais` ( `avalider`, `code` )');
  Connection.execsql('CREATE INDEX `par_email` ON `utilisateurs` ( `email`, `motdepasse`, `code` )');
  Connection.execsql('CREATE INDEX `par_nom` ON `utilisateurs` ( `nom`, `prenom`, `code` )');
  Connection.execsql('CREATE INDEX `par_utilisateur` ON `notesdefrais` ( `utilisateur_code`, `datendf`, `code` )');
end;

procedure NotesDeFrais_CreerBase_mobile(Connection: TFDConnection);
begin
  Connection.execsql
    ('CREATE TABLE `notesdefrais` ( `code` INTEGER PRIMARY KEY AUTOINCREMENT, `utilisateur_code` INTEGER DEFAULT 0, `mobile_code` TEXT DEFAULT '''', `datendf` TEXT DEFAULT ''0000-00-00'', '
    + '`lieu` TEXT DEFAULT '''', `montant` REAL DEFAULT 0, `avalider` TEXT DEFAULT ''O'', `acceptee` TEXT DEFAULT ''N'', `dateaccord` TEXT DEFAULT ''0000-00-00'' )');
  Connection.execsql('CREATE INDEX `par_avalider` ON `notesdefrais` ( `avalider`, `code` )');
  Connection.execsql('CREATE INDEX `par_utilisateur` ON `notesdefrais` ( `utilisateur_code`, `datendf`, `code` )');
end;

end.
