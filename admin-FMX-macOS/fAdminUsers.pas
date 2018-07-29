unit fAdminUsers;

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
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, dmBaseFMX, System.Rtti, FMX.Grid.Style, Data.Bind.Controls, Data.Bind.EngExt,
  FMX.Bind.DBEngExt,
  FMX.Bind.Grid, System.Bindings.Outputs, FMX.Bind.Editors, Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope, FMX.Layouts, FMX.Bind.Navigator,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Grid;

type
  TfrmAdminUsers = class(TForm)
    StringGrid1: TStringGrid;
    BindNavigator1: TBindNavigator;
    BindingsList1: TBindingsList;
    BindSourceDB1: TBindSourceDB;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmAdminUsers: TfrmAdminUsers;

implementation

{$R *.fmx}

end.
