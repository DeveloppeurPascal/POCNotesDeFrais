unit uAPI;

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

uses System.SysUtils, System.JSON;

procedure APILogin(user, password: string; BeforeProc: TProc; ResultProc: TProc<TJSONObject>; AfterProc: TProc);

procedure APISynchronisation(BeforeProc, AfterProc: TProc);

implementation

uses System.Classes, System.Net.HttpClient, System.NetEncoding, System.Net.Mime, uNotesDeFrais, uParam, System.IOUtils, System.types, dmBaseFMX,
  FireDAC.Stan.Intf;

procedure APILogin(user, password: string; BeforeProc: TProc; ResultProc: TProc<TJSONObject>; AfterProc: TProc);
begin
  if assigned(BeforeProc) then
    BeforeProc;
  try
    tthread.createanonymousthread(
      procedure
      var
        serveur: THTTPClient;
        serveur_reponse: IHTTPResponse;
        response: TJSONObject;
        JSON: string;
      begin
        serveur := THTTPClient.Create;
        try
          serveur.UserAgent := 'NotesDeFraisMobile';
          serveur_reponse := serveur.get('http://' + Serveur_IP + ':' + Serveur_Port + '/login?' + TNetEncoding.url.Encode('user', [], []) + '=' +
            TNetEncoding.url.Encode(user, [], []) + '&' + TNetEncoding.url.Encode('pass', [], []) + '=' + TNetEncoding.url.Encode(password, [], []));
          if serveur_reponse.StatusCode = 200 then
          begin
            try
              JSON := serveur_reponse.ContentAsString(tencoding.UTF8);
              response := TJSONObject.ParseJSONValue(JSON) as TJSONObject;
            except
              response := nil;
            end;
          end
          else
            response := nil;
          if assigned(ResultProc) then
            tthread.Synchronize(nil,
              procedure
              begin
                ResultProc(response);
              end)
          else if assigned(response) then
            freeandnil(response);
        finally
          serveur.Free;
          if assigned(AfterProc) then
            tthread.Synchronize(nil,
              procedure
              begin
                AfterProc;
              end);
        end;
      end).start;
  except
    if assigned(AfterProc) then
      AfterProc;
  end;
end;

procedure envoyer_fichier(fichier_a_traiter: string);
var
  serveur: THTTPClient;
  serveur_reponse: IHTTPResponse;
  response: TJSONObject;
  JSON: string;
  post_param: tmultipartformdata;
  erreur: integer;
begin
  serveur := THTTPClient.Create;
  try
    serveur.UserAgent := 'NotesDeFraisMobile';
    serveur.ContentType := 'multipart/form-data';
    post_param := tmultipartformdata.Create;
    try
      post_param.AddField('code', usercode.ToString);
      post_param.AddFile(tpath.getfilename(fichier_a_traiter), fichier_a_traiter);
      serveur_reponse := serveur.post('http://' + Serveur_IP + ':' + Serveur_Port + '/ndf', post_param);
    finally
      freeandnil(post_param);
    end;
    if serveur_reponse.StatusCode = 200 then
    begin
      JSON := serveur_reponse.ContentAsString(tencoding.UTF8);
      response := TJSONObject.ParseJSONValue(JSON) as TJSONObject;
      try
        try
          erreur := response.GetValue('erreur').Value.ToInteger;
        except
          erreur := -1;
        end;
        if erreur = 0 then
          tfile.Delete(fichier_a_traiter);
      finally
        freeandnil(response);
      end;
    end;
  finally
    freeandnil(serveur);
  end;
end;

procedure APISynchronisation(BeforeProc, AfterProc: TProc);
begin
  if assigned(BeforeProc) then
    BeforeProc;
  try
    tthread.createanonymousthread(
      procedure
      var
        fichier: string;
        liste_fichiers: tstringdynarray;
      begin
        liste_fichiers := tdirectory.GetFiles(NotesDeFrais_PhotosPath_mobile);
        if (length(liste_fichiers) > 0) then
          for fichier in liste_fichiers do
            envoyer_fichier(fichier);
        if assigned(AfterProc) then
          AfterProc;
      end).start;
    tthread.createanonymousthread(
      procedure
      var
        serveur: THTTPClient;
        serveur_reponse: IHTTPResponse;
        response: TJSONObject;
        JSON: string;
        erreur: integer;
        base: tstringstream;
      begin
        serveur := THTTPClient.Create;
        try
          serveur.UserAgent := 'NotesDeFraisMobile';
          serveur_reponse := serveur.get('http://' + Serveur_IP + ':' + Serveur_Port + '/db?' + TNetEncoding.url.Encode('code', [], []) + '=' +
            TNetEncoding.url.Encode(usercode.ToString, [], []));
          if serveur_reponse.StatusCode = 200 then
          begin
            try
              JSON := serveur_reponse.ContentAsString(tencoding.UTF8);
              response := TJSONObject.ParseJSONValue(JSON) as TJSONObject;
              try
                try
                  erreur := TJSONString(response.GetValue('erreur')).Value.ToInteger;
                except
                  erreur := 0;
                end;
                if (erreur = 0) then
                begin
                  try
                    JSON := TJSONString(response.GetValue('base')).Value;
                  except
                    JSON := '';
                  end;
                  if JSON.length > 0 then
                  begin
                    base := tstringstream.Create(JSON, tencoding.ANSI);
                    try
                      dm.fdmemtable1.LoadFromStream(base, tfdstorageformat.sfjson);
                      if dm.fdmemtable1.RecordCount > 0 then
                      begin
                        dm.FDBatchMove1.Execute;
                        dm.fdmemtable1.EmptyDataSet;
                      end;
                    finally
                      freeandnil(base);
                    end;
                  end;
                end;
              finally
                freeandnil(response);
              end;
            except
            end;
          end;
        finally
          freeandnil(serveur);
          if assigned(AfterProc) then
            tthread.Synchronize(nil,
              procedure
              begin
                AfterProc;
              end);
        end;
      end).start;
  except
    if assigned(AfterProc) then
      AfterProc;
  end;
end;

end.
