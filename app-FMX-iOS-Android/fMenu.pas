unit fMenu;

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
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation, FMX.StdCtrls, System.Actions, FMX.ActnList, FMX.StdActns,
  FMX.MediaLibrary.Actions, FMX.Objects;

type
  TfrmMenu = class(TForm)
    btnCaptureNoteDeFrais: TButton;
    btnSynchroniserLaBase: TButton;
    btnConsulter: TButton;
    btnLogout: TButton;
    ActionList1: TActionList;
    TakePhotoFromCameraAction1: TTakePhotoFromCameraAction;
    AnimationAttente: TRectangle;
    AniIndicator1: TAniIndicator;
    procedure btnSynchroniserLaBaseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TakePhotoFromCameraAction1DidFinishTaking(Image: TBitmap);
    procedure btnConsulterClick(Sender: TObject);
    procedure btnLogoutClick(Sender: TObject);
    procedure btnCaptureNoteDeFraisClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    Fsynchroniserbase: boolean;
    procedure Setsynchroniserbase(const Value: boolean);
    function DateHeure: string;
    procedure AjaxOn;
    procedure AjaxOff;
  public
    { Déclarations publiques }
    property synchroniserbase: boolean read Fsynchroniserbase write Setsynchroniserbase;
  end;

var
  frmMenu: TfrmMenu;

implementation

{$R *.fmx}

uses fConsulter, dmBaseFMX, uNotesDeFrais, uParam, System.IOUtils, uAPI;
{ TfrmMenu }

procedure TfrmMenu.AjaxOff;
begin
  AnimationAttente.Visible := false;
  AniIndicator1.Enabled := false;
end;

procedure TfrmMenu.AjaxOn;
begin
  AnimationAttente.Visible := true;
  AnimationAttente.BringToFront;
  AniIndicator1.Enabled := true;
end;

procedure TfrmMenu.btnCaptureNoteDeFraisClick(Sender: TObject);
begin
  if (not TakePhotoFromCameraAction1.Execute) then
    showmessage('erreur');
end;

procedure TfrmMenu.btnConsulterClick(Sender: TObject);
begin
  if not assigned(frmConsulter) then
    frmConsulter := tfrmconsulter.Create(self);
  try
{$IFDEF ANDROID}
    frmConsulter.Show;
{$ELSE}
    frmConsulter.ShowModal;
{$ENDIF}
  finally
{$IFNDEF ANDROID}
    freeandnil(frmConsulter);
{$ENDIF}
  end;
end;

procedure TfrmMenu.btnLogoutClick(Sender: TObject);
begin
  usercode := 0;
  username := '';
  UserPassword := '';
  param_save;
  close;
end;

procedure TfrmMenu.btnSynchroniserLaBaseClick(Sender: TObject);
begin
  APISynchronisation(AjaxOn, AjaxOff);
end;

function TfrmMenu.DateHeure: string;
var
  i: integer;
  ch: string;
  c: char;
begin
  result := '';
  ch := DateTimeToStr(Now).ToLower;
  for i := 0 to ch.Length - 1 do
  begin
    c := ch.Chars[i];
    if ((c >= '0') and (c <= '9')) or ((c >= 'a') and (c <= 'z')) then
      result := result + c;
  end;
end;

procedure TfrmMenu.FormCreate(Sender: TObject);
begin
  randomize;
  AjaxOff;
end;

procedure TfrmMenu.FormShow(Sender: TObject);
begin
  if synchroniserbase then
    btnSynchroniserLaBaseClick(Sender);
end;

procedure TfrmMenu.Setsynchroniserbase(const Value: boolean);
begin
  Fsynchroniserbase := Value;
end;

procedure TfrmMenu.TakePhotoFromCameraAction1DidFinishTaking(Image: TBitmap);
var
  nom_photo: string;
begin
  nom_photo := 'ndf-' + usercode.ToString + '-' + DateHeure + '-' + random(MaxInt).ToString + '.png';
  if not dm.qryNotesDeFrais.active then
    dm.qryNotesDeFrais.open('select * from notesdefrais');
  dm.qryNotesDeFrais.Insert;
  try
    dm.qryNotesDeFrais.fieldbyname('utilisateur_code').AsInteger := usercode;
    dm.qryNotesDeFrais.fieldbyname('mobile_code').AsString := nom_photo;
    Image.SaveToFile(tpath.Combine(NotesDeFrais_PhotosPath_mobile, nom_photo));
    dm.qryNotesDeFrais.post;
  except
    dm.qryNotesDeFrais.cancel;
  end;
end;

end.
