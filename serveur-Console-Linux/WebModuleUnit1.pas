unit WebModuleUnit1;

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

uses System.SysUtils, System.Classes, Web.HTTPApp, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.ConsoleUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Stan.StorageJSON;

type
  TWebModule1 = class(TWebModule)
    FDConnection1: TFDConnection;
    qryNotesDeFrais: TFDQuery;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    qryUtilisateurs: TFDQuery;
    procedure WebModule1DefaultHandlerAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModuleCreate(Sender: TObject);
    procedure FDConnection1AfterConnect(Sender: TObject);
    procedure FDConnection1BeforeConnect(Sender: TObject);
    procedure WebModule1ActionLoginAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1ActionSynchroPhotoAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1ActionBaseVersMobileAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1UsersListAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1UsersDeleteAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1UserAddAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1UserChgAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1consultationNDFAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1ModerationNDFSuivanteAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1ModerationNDFDecisionAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
  private
    { Déclarations privées }
    FBaseACreer: Boolean;
  public
    { Déclarations publiques }
  end;

var
  WebModuleClass: TComponentClass = TWebModule1;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

uses uNotesDeFrais, System.IOUtils, System.JSON, System.SyncObjs, Web.ReqMulti, System.NetEncoding;

{$R *.dfm}
// var
// SectionProtegee: TCriticalSection;

procedure TWebModule1.FDConnection1AfterConnect(Sender: TObject);
begin
  if FBaseACreer then
    NotesDeFrais_CreerBase(FDConnection1);
end;

procedure TWebModule1.FDConnection1BeforeConnect(Sender: TObject);
var
  database: string;
begin
  database := tpath.Combine(NotesDeFrais_BaseName, 'notesdefrais-serveur.db');
  FBaseACreer := not tfile.exists(database);
  FDConnection1.Params.database := database;
end;

procedure TWebModule1.WebModule1ActionBaseVersMobileAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  code: integer;
  erreur: integer;
  jso: tjsonobject;
  base: TStringStream;
begin
  // writeln(Request.query);
  jso := tjsonobject.Create;
  try
    erreur := 0;
    try
      code := Request.QueryFields.Values['code'].trim.tointeger;
    except
      code := 0;
    end;
    if code > 0 then
    begin
      // SectionProtegee.Acquire;
      try
        if qryNotesDeFrais.active then
          qryNotesDeFrais.Close;
        qryNotesDeFrais.Open('select * from notesdefrais where utilisateur_code=:utilisateur', [code]);
        base := TStringStream.Create;
        try
          qryNotesDeFrais.SaveToStream(base, tfdstorageformat.sfJSON);
          jso.AddPair('base', base.datastring);
        finally
          freeandnil(base);
        end;
      finally
        // SectionProtegee.Release;
      end;
      if (code > 0) then
        jso.AddPair('code', code.ToString)
      else
        erreur := 4;
    end
    else
      erreur := 1;
    jso.AddPair('erreur', TJSONNumber.Create(erreur));
    Response.Content := jso.ToJSON;
  finally
    freeandnil(jso);
  end;
end;

procedure TWebModule1.WebModule1ActionLoginAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  user, pass: string;
  code: integer;
  erreur: integer;
  jso: tjsonobject;
begin
  // writeln(Request.query);
  jso := tjsonobject.Create;
  try
    erreur := 0;
    user := Request.QueryFields.Values['user'].trim.ToLower;
    if (user.Length < 1) then
      erreur := 1;
    pass := Request.QueryFields.Values['pass'].trim.ToLower;
    if (pass.Length < 1) then
      if erreur = 0 then
        erreur := 2
      else
        erreur := 3;
    if erreur = 0 then
    begin
      // SectionProtegee.Acquire;
      try
        try
          code := FDConnection1.ExecSQLScalar('select code from utilisateurs where email=:user and motdepasse=:pass', [user, pass]);
        except
          code := 0;
        end;
      finally
        // SectionProtegee.Release;
      end;
      if (code > 0) then
        jso.AddPair('code', code.ToString)
      else
        erreur := 4;
    end;
    jso.AddPair('erreur', TJSONNumber.Create(erreur));
    Response.Content := jso.ToJSON;
  finally
    freeandnil(jso);
  end;
end;

procedure TWebModule1.WebModule1ActionSynchroPhotoAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  code: integer;
  erreur: integer;
  jso: tjsonobject;
  nom_fichier: string;
  i: integer;
  multireq: tmultipartcontentparser;
begin
  if (tmultipartcontentparser.CanParse(Request)) then
    try
      multireq := tmultipartcontentparser.Create(Request);
    finally
      freeandnil(multireq);
    end;
  // writeln(Request.Content);
  jso := tjsonobject.Create;
  try
    erreur := 0;
    try
      code := Request.ContentFields.Values['code'].trim.tointeger;
    except
      code := 0;
    end;
    if (code > 0) then
    begin
      for i := 0 to Request.Files.Count - 1 do
        try
          nom_fichier := Request.Files[i].FileName;
          TMemoryStream(Request.Files[i].Stream).SaveToFile(tpath.Combine(NotesDeFrais_PhotosPath, nom_fichier));
          // SectionProtegee.Acquire;
          try
            if (not qryNotesDeFrais.active) then
              qryNotesDeFrais.Open('select * from notesdefrais');
            qryNotesDeFrais.Insert;
            try
              qryNotesDeFrais.fieldbyname('utilisateur_code').AsInteger := code;
              qryNotesDeFrais.fieldbyname('mobile_code').AsString := nom_fichier;
              qryNotesDeFrais.post;
            except
              qryNotesDeFrais.cancel;
              erreur := 3;
            end;
          finally
            // SectionProtegee.Release;
          end;
        except
          erreur := 2;
        end;
    end
    else // utilisateur inconnu
      erreur := 1;
    jso.AddPair('erreur', TJSONNumber.Create(erreur));
    Response.Content := jso.ToJSON;
  finally
    freeandnil(jso);
  end;
end;

procedure TWebModule1.WebModule1consultationNDFAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  erreur: integer;
  jso: tjsonobject;
  base: TStringStream;
begin
  jso := tjsonobject.Create;
  try
    erreur := 0;
    // SectionProtegee.Acquire;
    try
      if qryNotesDeFrais.active then
        qryNotesDeFrais.Close;
      qryNotesDeFrais.Open
        ('select nom, prenom, email, datendf, lieu, montant, acceptee, dateaccord from notesdefrais,utilisateurs where notesdefrais.utilisateur_code=utilisateurs.code and avalider=''N'' order by datendf, nom');
      base := TStringStream.Create;
      try
        qryNotesDeFrais.SaveToStream(base, tfdstorageformat.sfJSON);
        jso.AddPair('base', base.datastring);
      finally
        freeandnil(base);
      end;
    finally
      // SectionProtegee.Release;
    end;
    jso.AddPair('erreur', TJSONNumber.Create(erreur));
    Response.Content := jso.ToJSON;
  finally
    freeandnil(jso);
  end;
end;

procedure TWebModule1.WebModule1DefaultHandlerAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.Content := '<html>' + '<head><title>POC Notes de Frais</title></head>' + '<body>POC Notes de Frais</body>' + '</html>';
end;

procedure TWebModule1.WebModule1ModerationNDFDecisionAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  code: integer;
  lieu, datendf, dateaccord, montant, decision: string;
begin
  // writeln(Request.Content);
  code := Request.ContentFields.Values['code'].trim.tointeger;
  lieu := Request.ContentFields.Values['lieu'].trim;
  datendf := Request.ContentFields.Values['date'].trim;
  montant := Request.ContentFields.Values['montant'].trim.ToLower;
  decision := Request.ContentFields.Values['decision'].trim.ToLower;
  dateaccord := datetostr(now);
  // SectionProtegee.Acquire;
  if decision = 'ok' then
    FDConnection1.ExecSQL
      ('update notesdefrais set datendf=:datendf,lieu=:lieu,montant=:montant,avalider=''N'',acceptee=''O'',dateaccord=:date where code=:code',
      [date, lieu, montant, dateaccord, code])
  else if decision = 'ko' then
    FDConnection1.ExecSQL
      ('update notesdefrais set datendf=:datendf,lieu=:lieu,montant=:montant,avalider=''N'',acceptee=''N'',dateaccord=:date where code=:code',
      [date, lieu, montant, dateaccord, code]);
  // SectionProtegee.Release;
end;

procedure TWebModule1.WebModule1ModerationNDFSuivanteAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  erreur: integer;
  jso: tjsonobject;
begin
  jso := tjsonobject.Create;
  try
    erreur := 0;
    // SectionProtegee.Acquire;
    try
      if qryUtilisateurs.active then
        qryUtilisateurs.Close;
      qryUtilisateurs.Open
        ('select notesdefrais.code, nom, prenom, email, mobile_code from notesdefrais,utilisateurs where notesdefrais.utilisateur_code=utilisateurs.code and avalider=''O'' order by notesdefrais.code limit 0,1');
      if qryUtilisateurs.Eof then
        erreur := 1
      else
      begin
        jso.AddPair('code', qryUtilisateurs.fieldbyname('code').AsString);
        jso.AddPair('nom', qryUtilisateurs.fieldbyname('nom').AsString);
        jso.AddPair('prenom', qryUtilisateurs.fieldbyname('prenom').AsString);
        jso.AddPair('email', qryUtilisateurs.fieldbyname('email').AsString);
        jso.AddPair('image', tnetencoding.Base64.EncodeBytesToString(tfile.ReadAllBytes(tpath.Combine(NotesDeFrais_PhotosPath,
          qryUtilisateurs.fieldbyname('mobile_code').AsString))));
      end;
    finally
      // SectionProtegee.Release;
    end;
    jso.AddPair('erreur', TJSONNumber.Create(erreur));
    Response.Content := jso.ToJSON;
  finally
    freeandnil(jso);
  end;
end;

procedure TWebModule1.WebModule1UserAddAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  code: integer;
  nom, prenom, email, motdepasse: string;
begin
  // writeln(Request.Content);
  nom := Request.ContentFields.Values['nom'].trim;
  prenom := Request.ContentFields.Values['prenom'].trim;
  email := Request.ContentFields.Values['email'].trim.ToLower;
  motdepasse := Request.ContentFields.Values['motdepasse'].trim.ToLower;
  // SectionProtegee.Acquire;
  FDConnection1.ExecSQL('insert into utilisateurs (nom,prenom,email,motdepasse) values (:nom,:prenom,:email,:motdepasse)', [nom, prenom, email, motdepasse]);
  code := FDConnection1.ExecSQLScalar('select last_insert_rowid()');
  Response.Content := code.ToString;
  // SectionProtegee.Release;
end;

procedure TWebModule1.WebModule1UserChgAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  code: integer;
  nom, prenom, email, motdepasse: string;
begin
  // writeln(Request.Content);
  code := Request.ContentFields.Values['code'].trim.tointeger;
  nom := Request.ContentFields.Values['nom'].trim;
  prenom := Request.ContentFields.Values['prenom'].trim;
  email := Request.ContentFields.Values['email'].trim.ToLower;
  motdepasse := Request.ContentFields.Values['motdepasse'].trim.ToLower;
  // SectionProtegee.Acquire;
  FDConnection1.ExecSQL('update utilisateurs set nom=:nom,prenom=:prenom,email=:email,motdepasse=:motdepasse where code=:code',
    [nom, prenom, email, motdepasse, code]);
  // SectionProtegee.Release;
end;

procedure TWebModule1.WebModule1UsersDeleteAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  code: integer;
begin
  // writeln(Request.query);
  try
    code := Request.QueryFields.Values['code'].tointeger;
  except
    code := 0;
  end;
  if (code > 0) then
  begin
    // SectionProtegee.Acquire;
    FDConnection1.ExecSQL('delete from utilisateurs where code=' + code.ToString);
    // SectionProtegee.Release;
  end;
end;

procedure TWebModule1.WebModule1UsersListAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  erreur: integer;
  jso: tjsonobject;
  base: TStringStream;
begin
  jso := tjsonobject.Create;
  try
    erreur := 0;
    // SectionProtegee.Acquire;
    try
      if qryUtilisateurs.active then
        qryUtilisateurs.Close;
      qryUtilisateurs.Open('select code, nom, prenom, email, motdepasse from utilisateurs');
      base := TStringStream.Create;
      try
        qryUtilisateurs.SaveToStream(base, tfdstorageformat.sfJSON);
        jso.AddPair('base', base.datastring);
      finally
        freeandnil(base);
      end;
    finally
      // SectionProtegee.Release;
    end;
    jso.AddPair('erreur', TJSONNumber.Create(erreur));
    Response.Content := jso.ToJSON;
  finally
    freeandnil(jso);
  end;
end;

procedure TWebModule1.WebModuleCreate(Sender: TObject);
begin
  FDConnection1.Connected := true;
end;

initialization

// SectionProtegee := TCriticalSection.Create;

finalization

// freeandnil(SectionProtegee);

end.
