program AdminUsers;

(*
	Projet : POC Notes de frais
	URL du projet : https://www.developpeur-pascal.fr/p/_6006-poc-notes-de-frais-une-application-multiplateforme-de-saisie-de-notes-de-frais-en-itinerance.html
	
	Auteur : Patrick Prémartin https://patrick.premartin.fr
	Editeur : Olf Software https://www.olfsoftware.fr

	Site web : https://www.developpeur-pascal.fr/
	
	Ce fichier et ceux qui l'accompagnent sont fournis en l'état, sans garantie, à titre d'exemple d'utilisation de fonctionnalités de Delphi dans sa version Tokyo 10.2
	Vous pouvez vous en inspirer dans vos projets mais n'êtes pas autorisé à rediffuser tout ou partie des fichiers de ce projet sans accord écrit préalable.
*)

uses
  System.StartUpCopy,
  FMX.Forms,
  fAdminUsers in 'fAdminUsers.pas' {frmAdminUsers},
  uNotesDeFrais in '..\uNotesDeFrais.pas',
  dmBaseFMX in 'dmBaseFMX.pas' {dmBaseNotesDeFrais: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmBaseNotesDeFrais, dmBaseNotesDeFrais);
  Application.CreateForm(TfrmAdminUsers, frmAdminUsers);
  Application.Run;
end.
