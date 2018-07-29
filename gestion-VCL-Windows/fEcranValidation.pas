unit fEcranValidation;

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
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent;

type
  TfrmEcranValidation = class(TForm)
    Image1: TImage;
    Panel1: TPanel;
    edtNom: TLabeledEdit;
    edtLieu: TLabeledEdit;
    edtPrenom: TLabeledEdit;
    edtEmail: TLabeledEdit;
    edtMontant: TLabeledEdit;
    edtDate: TLabeledEdit;
    btnAccepter: TBitBtn;
    btnRejeter: TBitBtn;
    NetHTTPClient1: TNetHTTPClient;
    NetHTTPRequestNDFSuivante: TNetHTTPRequest;
    NetHTTPRequestAccordOuRejet: TNetHTTPRequest;
    lblCode: TLabel;
    procedure btnAccepterClick(Sender: TObject);
    procedure btnRejeterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure NetHTTPRequestNDFSuivanteRequestCompleted(const Sender: TObject; const AResponse: IHTTPResponse);
    procedure NetHTTPRequestAccordOuRejetRequestCompleted(const Sender: TObject; const AResponse: IHTTPResponse);
  private
    { Déclarations privées }
    procedure transmet_decision(accord: boolean);
    procedure photo_suivante;
  public
    { Déclarations publiques }
  end;

var
  frmEcranValidation: TfrmEcranValidation;

implementation

{$R *.dfm}

uses uNotesDeFrais, System.NetEncoding, System.JSON, System.IOUtils, Vcl.Imaging.pngimage;

procedure TfrmEcranValidation.btnAccepterClick(Sender: TObject);
begin
  transmet_decision(true);
end;

procedure TfrmEcranValidation.btnRejeterClick(Sender: TObject);
begin
  transmet_decision(false);
end;

procedure TfrmEcranValidation.FormCreate(Sender: TObject);
begin
  Panel1.Enabled := false;
  photo_suivante;
end;

procedure TfrmEcranValidation.NetHTTPRequestAccordOuRejetRequestCompleted(const Sender: TObject; const AResponse: IHTTPResponse);
begin
  if AResponse.StatusCode = 200 then
    photo_suivante
  else
  begin
    showmessage('Erreur HTTP ' + AResponse.StatusCode.ToString + ' lors de l''envoi de votre décision.');
    Panel1.Enabled := true;
  end;
end;

procedure TfrmEcranValidation.NetHTTPRequestNDFSuivanteRequestCompleted(const Sender: TObject; const AResponse: IHTTPResponse);
var
  jso: TJSONObject;
  s: TFileStream;
  b: tbytes;
  ImgFileName: string;
begin
  jso := TJSONObject.ParseJSONValue(AResponse.ContentAsString(tencoding.utf8)) as TJSONObject;
  try
    if (jso.GetValue('erreur') as tjsonnumber).AsInt64 = 0 then
    begin
      lblCode.Caption := (jso.GetValue('code') as tjsonstring).value;
      edtNom.Text := (jso.GetValue('nom') as tjsonstring).value;
      edtPrenom.Text := (jso.GetValue('prenom') as tjsonstring).value;
      edtEmail.Text := (jso.GetValue('email') as tjsonstring).value;
      edtLieu.Text := '';
      edtDate.Text := DateTostr(now);
      edtMontant.Text := '0';
      ImgFileName := tpath.GetTempFileName + '.PNG';
      s := TFileStream.Create(ImgFileName, fmCreate);
      try
        b := tnetencoding.base64.DecodeStringToBytes((jso.GetValue('image') as tjsonstring).value);
        s.write(b, length(b));
      finally
        freeandnil(s);
      end;
      Image1.Picture.LoadFromFile(ImgFileName);
      tfile.Delete(ImgFileName);
      Panel1.Enabled := true;
    end
    else
      showmessage('Pas de note de frais en attente de validation.');
  finally
    freeandnil(jso);
  end;
end;

procedure TfrmEcranValidation.photo_suivante;
begin
  NetHTTPRequestNDFSuivante.get('http://' + Serveur_IP + ':' + Serveur_Port + '/moderenext');
end;

procedure TfrmEcranValidation.transmet_decision(accord: boolean);
var
  s: tstringlist;
begin
  if accord and (edtLieu.Text = '') then
  begin
    showmessage('Veuillez indiquer le lieu.');
    edtLieu.SetFocus;
  end
  else if accord and (edtDate.Text = '') then
  begin
    showmessage('Veuillez indiquer la date.');
    edtDate.SetFocus;
  end
  else if accord and (edtMontant.Text = '') then
  begin
    showmessage('Veuillez indiquer le montant.');
    edtMontant.SetFocus;
  end
  else
  begin
    Panel1.Enabled := false;
    s := tstringlist.Create;
    try
      s.AddPair('code', lblCode.Caption);
      s.AddPair('lieu', edtLieu.Text);
      s.AddPair('date', edtDate.Text);
      s.AddPair('montant', edtMontant.Text);
      if accord then
        s.AddPair('decision', 'ok')
      else
        s.AddPair('decision', 'ko');
      NetHTTPRequestAccordOuRejet.post('http://' + Serveur_IP + ':' + Serveur_Port + '/moderechoix', s);
    finally
      freeandnil(s);
    end;
  end;
end;

end.
