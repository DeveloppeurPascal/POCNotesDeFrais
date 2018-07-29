unit fLogin;

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
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit, FMX.Objects;

type
  TfrmLogin = class(TForm)
    edtUser: TEdit;
    edtPassword: TEdit;
    btnLogin: TButton;
    AnimationAttente: TRectangle;
    AniIndicator1: TAniIndicator;
    procedure btnLoginClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Déclarations privées }
    procedure AjaxOn;
    procedure AjaxOff;
    procedure AfficherMenu;
    procedure AfficherMenuAvecSynchro;
  public
    { Déclarations publiques }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.fmx}

uses uAPI, System.JSON, uParam, fMenu;

procedure TfrmLogin.AfficherMenu;
begin
{$IFDEF ANDROID}
  tfrmmenu.Create(self).Show;
{$ELSE}
  tfrmmenu.Create(self).ShowModal;
{$ENDIF}
end;

procedure TfrmLogin.AfficherMenuAvecSynchro;
var
  menu: tfrmmenu;
begin
  menu := tfrmmenu.Create(self);
  menu.synchroniserbase := true;
{$IFDEF ANDROID}
  menu.Show;
{$ELSE}
  menu.ShowModal;
{$ENDIF}
end;

procedure TfrmLogin.AjaxOff;
begin
  AnimationAttente.Visible := false;
  AniIndicator1.Enabled := false;
end;

procedure TfrmLogin.AjaxOn;
begin
  AnimationAttente.Visible := true;
  AnimationAttente.BringToFront;
  AniIndicator1.Enabled := true;
end;

procedure TfrmLogin.btnLoginClick(Sender: TObject);
var
  user, pass: string;
begin
  user := edtUser.Text.Trim;
  if user.Length < 1 then
  begin
    showmessage('Saisissez votre email.');
    exit;
  end;
  pass := edtPassword.Text.Trim;
  if pass.Length < 1 then
  begin
    showmessage('Saisissez votre mot de passe.');
    exit;
  end;
  APILogin(user, pass,
    procedure
    begin
      AjaxOn;
    end,
    procedure(jso: TJSONObject)
    var
      erreur: integer;
    begin
      if assigned(jso) then
        try
          try
            erreur := TJSONString(jso.GetValue('erreur')).Value.ToInteger;
          except
            erreur := 0;
          end;
          if (erreur = 0) then
          begin
            try
              UserCode := TJSONString(jso.GetValue('code')).Value.ToInteger;
            except
              UserCode := 0;
            end;
            UserName := user;
            UserPassword := pass;
            param_save;
            if (UserCode > 0) then
              tthread.ForceQueue(nil, AfficherMenuAvecSynchro);
          end
          else
            showmessage('Connexion impossible (erreur : ' + erreur.tostring + ')');
        finally
          freeandnil(jso);
        end;
    end,
    procedure
    begin
      AjaxOff;
    end);
end;

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  AjaxOff;
end;

procedure TfrmLogin.FormShow(Sender: TObject);
begin
  if UserCode > 0 then
    AfficherMenu;
end;

end.
