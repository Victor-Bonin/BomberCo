:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).
:- use_module(library(http/http_files)).
:- use_module(library(http/html_write)).
:- use_module(library(http/html_head)).
:- use_module(library(http/http_json)).
:- use_module(bomberCo).

:- multifile http:location/3.
:- dynamic   http:location/3.
http:location(files, "/files", []).

:- http_handler(files(.), http_reply_from_files("assets", []), [prefix]).

:- http_handler(root(.), accueil, []).
:- http_handler(root(game), getInfoGame, []).
:- http_handler(root(starting), starting, []).

server(Port) :- http_server(http_dispatch, [port(Port)]).
stopServer(Port) :- http_stop_server(Port,[]).

accueil(_) :-
		reply_html_page(
	   [title("BomberCo"),
	   link([rel="icon", type="img/ico",href="files/favicon.ico"]),
	   link([rel="stylesheet", type="text/css", href="files/theme.css"])],
	   [h1("Just look"),
	   div(id="conteneur","Plateau"),
	   script(src="files/jquery.js",""),
	   script(src="files/ihm_action.js","")]).
	
starting(_) :-
	lancerPartie,
	reply_json_dict("{\"result\":1}").

getInfoGame(_):-
	taillePlateau(TP),
	nbJoueurs(NBJ),
	/*fin(Fin),*/
	nb_getval(tourActuel, TourActuel),
	findall(X,joueursSav(_,X,-1),JoueursVivants),
	findall(X,joueursSav(_,X,0),JoueursMorts),
	findall(X,bombes(X,_),Bombes),
	plateauSav(Plateau),
	getStringFromList(JoueursVivants,StrVivants),
	getStringFromList(JoueursMorts,StrMorts),
	getStringFromList(Bombes,StrBombes),
	getStringFromList(Plateau,StrPlateau),
	StringTab = [
	"{",
	"\"taillePlateau\":",TP,
	",\"nbJoueurs\":",NBJ,
	",\"plateau\" : [",StrPlateau,"]",
	",\"joueursVivants\" : [",StrVivants,"]",
	",\"joueursMorts\" : [",StrMorts,"]",
	",\"bombes\" : [",StrBombes,"]",
	/*",\"fin\":",Fin,*/
	",\"fin\":",TourActuel,
	"}"],
	getStringFromConcat(StringTab, S),
	reply_json_dict(S)
	.

	
getStringFromConcat([],""):-!.
getStringFromConcat([X|Liste], String):-getStringFromConcat(Liste,StringPrec),atom_concat(X,StringPrec,String).

getStringFromList([],"").
getStringFromList([X],S):-atom_concat(X,"",S).
getStringFromList([X|Liste],String):-getStringFromList(Liste,StringPrec),atom_concat(X,",",Virgule),atom_concat(Virgule,StringPrec,String).