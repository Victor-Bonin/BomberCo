%%%% Artificial intelligence: choose in a Plateau the Move to play for Player (_)
%%%% This AI plays more or less randomly according to the version and does not care who is playing:

initIndex :-
	taillePlateau(TaillePlateau),
	(indexAction(_,_,_) -> retractall(indexAction(_,_,_)); true),
    assert(indexAction(1,-TaillePlateau,0)), %Haut
    assert(indexAction(2, TaillePlateau,0)), %Bas
    assert(indexAction(3,1,0)),              %Droite
    assert(indexAction(4,-1,0)),             %Gauche
    assert(indexAction(5,0,0)),              %PasBouger
    assert(indexAction(6,0,1)).              %Bombe


distance(Pos1, Pos2, Distance) :-  taillePlateau(Taille), Pos1X = (Pos1 mod Taille), Pos2X = (Pos2 mod Taille), Pos1Y = (div(Pos1,Taille)), Pos2Y = (div(Pos2,Taille)), DiffX is abs(Pos1X-Pos2X), DiffY is abs(Pos1Y-Pos2Y), Distance is (DiffX+DiffY).

% Retourne la distance avec l'adversaire le + proche
adversairePlusProche(Pos,ListeJoueurs,Min,PosPlusProche):- adversairePlusProche(Pos,ListeJoueurs,Min,Min,PosPlusProche).
adversairePlusProche(_,[],Min,Min,PosPlusProche) :- write("Distance Finale : "),writeln(Min),!.
adversairePlusProche(Pos, [PosJoueur|L], DistancePP, MinFinal, PosPlusProche) :-
	write("Distance a battre : "),writeln(DistancePP), 
	write(" Position anays�e : "),writeln(PosJoueur),
	distance(Pos,PosJoueur,Distance),
	write(" distance detectee : "),writeln(Distance),
	(var(DistancePP) -> (DistancePP is Distance, PosPlusProche is PosJoueur) ; true),
	Min is min(Distance,DistancePP),
	write("Minimum courant : "),writeln(Min),
	adversairePlusProche(Pos,L,Min,MinFinal).
 adversairePlusProche(Pos, [_|L],Min, MinFinal, PosPlusProche) :- adversairePlusProche(Pos,L,Min, MinFinal).

isSafe(Pos, Plateau) :-  % la case a l'index Pos est elle safe ?
	taillePlateau(TaillePlateau),
	nbJoueurs(NbJoueurs),
	CaseDroite is Pos+1,
	CaseDroite2 is Pos+2,
	CaseGauche is Pos-1,
	CaseGauche2 is Pos-2,
	CaseDessous is Pos+TaillePlateau,
	CaseDessous2 is Pos+(2*TaillePlateau),
	CaseDessus is Pos-TaillePlateau,
	CaseDessus2 is Pos-(2*TaillePlateau),
	write("Je regarde si "), write(Pos), writeln(" est safe"),
    (bombes(Pos, _) -> (bombes(Pos,Temps), Temps >= (5*NbJoueurs)) ; true), % bombe sur le joueur
    (bombes(CaseDroite, _) -> (bombes(CaseDroite,Temps),Temps >= (4*NbJoueurs)) ; true), % bombe a droite
    (bombes(CaseGauche, _) -> (bombes(CaseGauche,Temps), Temps >= (4*NbJoueurs)) ; true), % bombe a gauche
    (bombes(CaseDessous, _) -> (bombes(CaseDessous,Temps), Temps >= (4*NbJoueurs)) ; true), % bombe en dessous
    (bombes(CaseDessus, _) -> (bombes(CaseDessus,Temps), Temps >= (4*NbJoueurs)) ; true), % bombe  dessus
    ((bombes(CaseDroite2, _), nth0(CaseDroite, Plateau, 0)) -> (bombes(CaseDroite2,Temps), Temps >= (3*NbJoueurs)); true), % bombe 2 case a droite sans mur entre
    ((bombes(CaseGauche2, _), nth0(CaseGauche, Plateau, 0)) -> (bombes(CaseGauche2,Temps), Temps >= (3*NbJoueurs)); true),
    ((bombes(CaseDessous2, _), nth0(CaseDessous, Plateau, 0)) -> (bombes(CaseDessous2,Temps), Temps >= (3*NbJoueurs)); true),
    ((bombes(CaseDessus2, _), nth0(CaseDessus, Plateau, 0)) -> (bombes(CaseDessus2,Temps), Temps >= (3*NbJoueurs)); true),
     write(Pos), writeln(" est safe").

isPossible(FormerPos,NewPos, Board) :-
	not(bombes(NewPos,_)),
	not((joueursSav(_,NewPos,-1),NewPos\==FormerPos)),
	nth0(NewPos, Board, 0).

% Liste des positions adjacentes a Pos
posAdjacentes(Pos, [Haut, Gauche, Droite, Bas]) :- taillePlateau(TaillePlateau), Haut is Pos-TaillePlateau, Gauche is Pos-1, Droite is Pos+1, Bas is Pos + TaillePlateau.

% Liste des positions accessibles depuis Pos
posSuivantes(Pos, [Pos|PosAdjacentes]) :- posAdjacentes(Pos,PosAdjacentes).

% Liste des positions realisables depuis FormerPos (pas d'obstacle)
posSuivantesPossibles(_,_,[],[]):-!.
posSuivantesPossibles(Board, FormerPos,[X|PosSuivantes], [X|PosSuivantesPossibles]) :-
	isPossible(FormerPos, X, Board),
	posSuivantesPossibles(Board, FormerPos, PosSuivantes, PosSuivantesPossibles).
posSuivantesPossibles(Board, FormerPos, [_|L], PAP) :-
	posSuivantesPossibles(Board, FormerPos, L, PAP).

% Liste des positions safe (Liste des positions a tester, Plateau, Liste des positions safe )
posSuivantesSafe([],_,[]) :- !.
posSuivantesSafe([X|ListeIndex],Plateau, [X|PosSafes]) :-
	isSafe(X,Plateau),
	posSuivantesSafe(ListeIndex,Plateau,PosSafes).
posSuivantesSafe([X|ListeIndex],Plateau, PosSafes) :- write("Je n'ajoute pas "),writeln(X),posSuivantesSafe(ListeIndex,Plateau, PosSafes).

% posSuivantesPlusProches(PosCible,PosSuivantesSafes,PosSuivantesPlusProc
% hes, MeileureDistance)
posSuivantesPlusProches(PosCible, PosSafes, PosPlusProches, DistanceMin) :- posSuivantesPlusProches(PosCible,PosSafes,PosPlusProches,DistanceMin,DistanceMin).

posSuivantesPlusProches(_,[],[],_,_):-!.
posSuivantesPlusProches(PosCible, [X|PosSuivantesSafes], [X|MeilleursMouvements], DistanceMinCourante, DistanceMin ) :-
	write("Position Cible : "), writeln(PosCible),
	distance(PosCible,X,Distance),
	Min is min(Distance,DistanceMinCourante),
	posSuivantesPlusProches(PosCible,PosSuivantesSafes,MeilleursMouvements, Min, DistanceMin).
posSuivantesPlusProches(Pos, [_|PPP], MM, Min, DistanceMin) :- posSuivantesPlusProches(Pos,PPP,MM,Min, DistanceMin).


% iav1 : fait tout de maniere random
ia(Plateau, PosIndex, NewPosIndex, BombePosee, iav1) :-
	 posSuivantes(PosIndex, PositionsSuivantes),
	 posSuivantesPossibles(Plateau, PosIndex, PositionsSuivantes, PosSuivantesPossibles),
	 (length(PosSuivantesPossibles,0) -> NewPosIndex is PosIndex, BombePosee is 0;
	 repeat, Move is random(7), indexAction(Move,I,BombePosee), NewPosIndex is PosIndex+I,isPossible(PosIndex, NewPosIndex, Plateau), !).

% iav2 : Detecte et evite les zones de danger des bombes et bouge de
% maniere random tant qu'elle n'est pas sortie
ia(Board, PosIndex, NewPosIndex, BombePosee, iav2) :-
	posSuivantes(PosIndex, PositionsSuivantes), posSuivantesPossibles(Board, PosIndex, PositionsSuivantes, PosSuivantesPossibles),
	 (length(PosSuivantesPossibles,0) ->
		NewPosIndex is PosIndex, BombePosee is 0
	 ;
		(isSafe(PosIndex, Board) ->
				(repeat, Move is random(7),indexAction(Move, MvmtRelatif, BombePosee), NewPosIndex is PosIndex+MvmtRelatif, isPossible(PosIndex,NewPosIndex,Board), isSafe(NewPosIndex, Board),!)
			;
				(repeat, Move is random(5),indexAction(Move, MvmtRelatif, BombePosee), NewPosIndex is PosIndex+MvmtRelatif, isPossible(PosIndex,NewPosIndex, Board), !)
		)
	).

% iav3 : detecte et evite les zones de danger
% et cherche si un deplacement peut la mettre en securite si pas safe
ia(Board, PosIndex, NewPosIndex,BombePosee, iav3) :-
		posSuivantes(PosIndex, PositionsSuivantes), posSuivantesPossibles(Board, PosIndex, PositionsSuivantes, PosSuivantesPossibles),
		(length(PosSuivantesPossibles,0) ->  NewPosIndex is PosIndex, BombePosee is 0;
		% Si position actuelle = safe : on prend un coup random mais safe
		(isSafe(PosIndex, Board) ->
		repeat, Move is random(7),indexAction(Move, MvmtRelatif, BombePosee), NewPosIndex is PosIndex+MvmtRelatif,
		isPossible(PosIndex, NewPosIndex, Board), isSafe(NewPosIndex, Board),!;

		% Si position actuelle = danger : on cherche les deplacements possibles et safe
		posAdjacentes(PosIndex, PosAdjacentes), posSuivantesPossibles(Board,PosIndex, PosAdjacentes, PosSuivantesPossibles),
		posSuivantesSafe(PosSuivantesPossibles, Board, PosSuivantesSafes),
		% si PosSuivantesSafes est vide : piocher dans PosSuivantesPossibles
		((length(PosSuivantesSafes,0)) ->
		random_member(NewPosIndex, PosSuivantesPossibles);
		random_member(NewPosIndex, PosSuivantesSafes))),
    !).

% iav3b : detecte et evite les zones de danger
% et cherche si un deplacement peut la mettre en securite si pas safe
%si elle est coincée elle pose pas de bombe
ia(Board, PosIndex, NewPosIndex,BombePosee, iav3b) :-
		posSuivantes(PosIndex, PositionsSuivantes), posSuivantesPossibles(Board, PosIndex, PositionsSuivantes, PosSuivantesPossibles),
		(length(PosSuivantesPossibles,0) ->  NewPosIndex is PosIndex, BombePosee is 0;
		% Si position actuelle = safe : on prend un coup random mais safe
		(isSafe(PosIndex, Board) ->
			posAdjacentes(PosIndex,PosAdjacentes), posSuivantesPossibles(Board, PosIndex, PosAdjacentes, PosAdjacentesPossibles), posSuivantesSafe(PosAdjacentesPossibles, Board, PosAdjacentesSafe),
			(length(PosAdjacentesSafe,0) ->  (NewPosIndex is PosIndex, BombePosee is 0);
			repeat, Move is random(7),indexAction(Move, MvmtRelatif, BombePosee), NewPosIndex is PosIndex+MvmtRelatif,
			isPossible(PosIndex, NewPosIndex, Board), isSafe(NewPosIndex, Board),!);

		% Si position actuelle = danger : on cherche les deplacements possibles et safe
		posAdjacentes(PosIndex, PosAdjacentes), posSuivantesPossibles(Board,PosIndex, PosAdjacentes, PosSuivantesPossibles),
		posSuivantesSafe(PosSuivantesPossibles, Board, PosSuivantesSafes),
	     % si PosSuivantesSafes est vide : piocher dans PosSuivantesPossibles
	     ((length(PosSuivantesSafes,0)) ->
	     random_member(NewPosIndex, PosSuivantesPossibles);
	     random_member(NewPosIndex, PosSuivantesSafes))),
    !).


% iav4 : se rapproche de l'adversaire pour poser des bombes avec les
% fonctionnalites precedentes
ia(Board, PosIndex, NewPosIndex,BombePosee, iav4) :-
	posSuivantes(PosIndex, PosSuivantes),
	posSuivantesPossibles(Board, PosIndex, PosSuivantes, PosSuivantesPossibles),
	(length(PosSuivantesPossibles,0) -> NewPosIndex is PosIndex, BombePosee is 0;
	writeln("Je peux bouger"),
	% Si position actuelle = safe : on regarde a quelle distance est le joueur le + proche
	(isSafe(PosIndex, Board) ->
	 writeln("Securite"),
	 findall(X,joueursSav(_,X,_),PosJoueurs),
	 delete(PosJoueurs,PosIndex,PosAdversaires),
	 write("Adversaires : "), writeln(PosAdversaires),
	 adversairePlusProche(PosIndex, PosAdversaires, DistanceVolOiseau, PosPlusProche),
	 write("Distance du plus proche: "), writeln(DistanceVolOiseau),
		 (   DistanceVolOiseau =< 3 ->
		% si proche de l'adversaire le + proche : random mais a plus de chances de bomber
		repeat,writeln("Je peux sentir son odeur"), Move is random(10*(4-DistanceVolOiseau)), (Move > 6 -> Move = 6; true), indexAction(Move,MvmtRelatif,BombePosee), NewPosIndex is PosIndex+MvmtRelatif, isPossible(PosIndex, NewPosIndex,Board), isSafe(NewPosIndex,Board),!;
		% si loin de l'adversaire le + proche : essaye de s'approcher
		writeln("Je me rapproche d'un ennemi !"),
		posAdjacentes(PosIndex, PosAdjacentes),
		posSuivantesPossibles(Board, PosIndex, PosAdjacentes, PosAdjacentesPossibles),
		posSuivantesSafe(PosAdjacentesPossibles, Board, PosAdjacentesSafes),
		writeln(PosAdjacentesSafes),
		posSuivantesPlusProches(PosIndex, PosAdjacentesSafes, MeilleursMouvements,_),
		% Si aucun meilleur mouvement => aucun deplacement Safe : on reste au meme endroit
		(length(MeilleursMouvements,0)) -> NewPosIndex is PosIndex;random_member(NewPosIndex, MeilleursMouvements)
		);
		writeln("Danger"),
	    % Si position actuelle = danger : on cherche les d�placements possibles et safe
            posAdjacentes(PosIndex, PosAdjacentes),
	    posSuivantesPossibles(Board, PosIndex, PosAdjacentes, PosAdjacentesPossibles),
	    posSuivantesSafe(PosAdjacentesPossibles, Board, PosAdjacentesSafes),
	     % Si aucune position adjacente n'est safe, on en choisit une au hasard
	     ((length(PosAdjacentesSafes,0)) ->
	     random_member(NewPosIndex, PosAdjacentesPossibles), writeln("Pas de case safe autour");
	     random_member(NewPosIndex, PosAdjacentesSafes), writeln("Choix parmi les cases safes"))),
	 !).



