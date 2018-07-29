unit ServerConst1;

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

resourcestring
  sPortInUse = '- Erreur : Le port %s est déjà utilisé';
  sPortSet = '- Port défini sur %s';
  sServerRunning = '- Le serveur est déjà exécuté';
  sStartingServer = '- Démarrage du serveur HTTP sur le port %d';
  sStoppingServer = '- Arrêt du serveur';
  sServerStopped = '- Serveur arrêté';
  sServerNotRunning = '- Le serveur n'#39'est pas exécuté';
  sInvalidCommand = '- Erreur : Commande non valide';
  sIndyVersion = '- Version Indy : ';
  sActive = '- Actif : ';
  sPort = '- Port : ';
  sSessionID = '- Nom de cookie de l'#39'ID de session : ';
  sCommands = 'Entrez une commande : '#13#10'   - "start" pour démarrer le serveur'#13#10'   - "stop" pour arrêter le serveur'#13#10'   - "set port" pour changer le port par défaut'#13#10'   - "status" pour obtenir l'#39'état du serveur'#13#10'   - "help" pour afficher les commandes'#13#10'   - "exit" pour fe'+
'rmer l'#39'application';

const
  cArrow = '->';
  cCommandStart = 'start';
  cCommandStop = 'stop';
  cCommandStatus = 'status';
  cCommandHelp = 'help';
  cCommandSetPort = 'set port';
  cCommandExit = 'exit';

implementation

end.
