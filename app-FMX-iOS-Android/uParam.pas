unit uParam;

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

var
  UserName, UserPassword: string;
  UserCode: integer;

procedure Param_Save;
procedure Param_Load;

implementation

uses
  System.IOUtils, System.JSON, System.SysUtils;

procedure Param_Save;
var
  jso: TJSONObject;
begin
  jso := TJSONObject.Create;
  try
    jso.AddPair('code', UserCode.ToString);
    jso.AddPair('user', UserName);
    jso.AddPair('pass', UserPassword);
    tfile.WriteAllText(tpath.combine(tpath.GetDocumentsPath, 'params.dta'), jso.ToJSON, tencoding.UTF8);
  finally
    freeandnil(jso);
  end;
end;

procedure Param_Load;
var
  jso: TJSONObject;
  JSON: string;
begin
  try
    JSON := tfile.ReadAllText(tpath.combine(tpath.GetDocumentsPath, 'params.dta'), tencoding.UTF8);
  except
    JSON := '';
  end;
  if JSON.Length > 0 then
  begin
    jso := TJSONObject.ParseJSONValue(JSON) as TJSONObject;
    try
      try
        UserCode := TJSONString(jso.GetValue('code')).Value.ToInteger;
      except
        UserCode := 0;
      end;
      try
        UserName := TJSONString(jso.GetValue('user')).Value;
      except
        UserName := '';
      end;
      try
        UserPassword := TJSONString(jso.GetValue('pass')).Value;
      except
        UserPassword := '';
      end;
    finally
      freeandnil(jso);
    end;
  end
  else
  begin
    UserCode := 0;
    UserName := '';
    UserPassword := '';
  end;
end;

initialization

Param_Load;

end.
