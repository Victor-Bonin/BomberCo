:-begin_tests(plateau).
	test(initPlateau):-
		initPlateau(11),
		taillePlateau(11),
		plateauSav(B),
		length(B, 121),
		!.
	test(fill):-
		length(Plateau, 121),
		fill(Plateau, 11, 0),
		PlateauC = ([1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,0,1,0,1,0,1,0,1,0,1,1,0,0,0,0,0,0,0,0,0,1,1,0,1,0,1,0,1,0,1,0,1,1,0,0,0,0,0,0,0,0,0,1,1,0,1,0,1,0,1,0,1,0,1,1,0,0,0,0,0,0,0,0,0,1,1,0,1,0,1,0,1,0,1,0,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1]),
		comp(Plateau, PlateauC),
		!.
:-end_tests(plateau).

comp(L1, L1).


:-begin_tests(joueurs).
	test(initJoueurs):-
		(taillePlateau(_) -> retractall(taillePlateau(_)); true),
		assert(taillePlateau(11)),
		initJoueurs(2),
		nbJoueurs(2),
		joueursSav(_, 12, -1), 
		joueursSav(_, 108, -1),
		!.
	test(initJoueurs):-
		(taillePlateau(_) -> retractall(taillePlateau(_)); true),
		assert(taillePlateau(11)),
		initJoueurs(4),
		nbJoueurs(4),
		joueursSav(_,12,-1),
		joueursSav(_,20,-1),
		joueursSav(_,100,-1),
		joueursSav(_,108,-1),
		!.
	test(initJoueurs):-
		(taillePlateau(_) -> retractall(taillePlateau(_)); true),
		assert(taillePlateau(11)),
		initJoueurs(3),
		nbJoueurs(3),
		joueursSav(_, 12, -1),  
		joueursSav(_, 20, -1),  
		joueursSav(_, 108, -1),
		!.
	test(plusieursEnVie):-
		(taillePlateau(_) -> retractall(taillePlateau(_)); true),
		assert(taillePlateau(11)),
		initJoueurs(2),
		plusieursEnVie,
		retract(joueursSav(_, 108, _)),
		assert(joueursSav(_, 108, 0)),
		not(joueursSav(_, 108, -1)),
		not(plusieursEnVie),
		!.
	test(actualiserJoueur):-
		(taillePlateau(_) -> retractall(taillePlateau(_)); true),
		assert(taillePlateau(11)),
		initJoueurs(2),
		actualiserJoueur(1, 13),
		joueursSav(_, 13, -1),
		!.
	test(joueurSuivant):-
		(taillePlateau(_) -> retractall(taillePlateau(_)); true),
		assert(taillePlateau(11)),
		initJoueurs(2),
		joueurSuivant(0,1),
		joueurSuivant(1,0),
		!.
	test(joueurSuivant):-
		(taillePlateau(_) -> retractall(taillePlateau(_)); true),
		assert(taillePlateau(11)),
		initJoueurs(3),
		joueurSuivant(0,1),
		joueurSuivant(1,2),
		joueurSuivant(2,0),
		!.
	test(tuer):-
		(taillePlateau(_) -> retractall(taillePlateau(_)); true),
		assert(taillePlateau(11)),
		initJoueurs(2),
		tuer(0),
		joueursSav(0, _, 0),
		tuer(1),
		joueursSav(1, _, 0),
		!.
	test(exploserBombe):-
		(taillePlateau(_) -> retractall(taillePlateau(_)); true),
		assert(taillePlateau(11)),
		initJoueurs(4),
		initBombes,
		ajouterBombe(36),
		%20 decrementations pour BOUM
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		bombes(36,0),
		
		%+1 -1
		retract(joueursSav(0,_,_)),
		retract(joueursSav(1,_,_)),
		retract(joueursSav(2,_,_)),
		retract(joueursSav(3,_,_)),

		assert(joueursSav(0,35, -1)),
		assert(joueursSav(1,37, -1)),
		assert(joueursSav(2,25, -1)),
		assert(joueursSav(3,47, -1)),

		exploserBombes(),
		
		joueursSav(0,35, 0),
		joueursSav(1,37, 0),
		joueursSav(2,25, 0),
		joueursSav(3,47, 0),

		%+2 -2	
		retract(joueursSav(0,_,_)),
		retract(joueursSav(1,_,_)),
		retract(joueursSav(2,_,_)),
		retract(joueursSav(3,_,_)),

		assert(joueursSav(0,34, -1)),
		assert(joueursSav(1,38, -1)),
		assert(joueursSav(2,14, -1)),
		assert(joueursSav(3,58, -1)),

		bombes(36,0),
		exploserBombes(),
		joueursSav(0,34, 0),
		joueursSav(1,38, 0),
		joueursSav(2,14, 0),
		joueursSav(3,58, 0),

		%Autre bombe
		ajouterBombe(23),
		%20 decrementations pour BOUM
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		bombes(23,0),

		%Joueur safe sauf le j2, id 1
		retract(joueursSav(0,_,_)),
		retract(joueursSav(1,_,_)),
		retract(joueursSav(2,_,_)),
		retract(joueursSav(3,_,_)),

		assert(joueursSav(0,25, -1)),
		assert(joueursSav(1,12, -1)),
		assert(joueursSav(2,56, -1)),
		assert(joueursSav(3,108, -1)),

		bombes(23,0),
		exploserBombes(),
		joueursSav(0,25, -1),
		joueursSav(1,12, 0),
		joueursSav(2,56, -1),
		joueursSav(3,108, -1),

		!.
:-end_tests(joueurs).

:-begin_tests(ia).
	test(initIndex):-
		(taillePlateau(_) -> retractall(taillePlateau(_)); true),
		assert(taillePlateau(11)),
		initIndex,
		indexAction(1,-TaillePlateau,0),
		indexAction(2, TaillePlateau,0),
		indexAction(3,1,0),
		indexAction(4,-1,0),
		indexAction(5,0,0),
		indexAction(6,0,1),
		!.
	test(distance):-
		(taillePlateau(_) -> retractall(taillePlateau(_)); true),
		assert(taillePlateau(11)),
		initIndex,
		ia:distance(12, 12, 0),
		ia:distance(12, 13, 1),
		ia:distance(12, 14, 2),
		ia:distance(14, 12, 2),
		ia:distance(14, 13, 1),
		ia:distance(23, 25, 2), % Entre deux cases séparées par un mur
		ia:distance(12, 23, 1), % Entre deux cases l'une sur l'autre
		ia:distance(23, 12, 1), % Entre deux cases l'une sur l'autre
		ia:distance(12, 27, 5), % Entre deux cases en diagonale
		!.
	test(isPossible):-
		initBombes,
		(taillePlateau(_) -> retractall(taillePlateau(_)); true),
		assert(taillePlateau(11)),
		initIndex,
		assert(nbJoueurs(2)),
		assert(taillePlateau(11)),
		initJoueurs(2),
		joueursSav(0, 12, _),
		isPossible(12, 13),
		isPossible(12, 12),
		isPossible(12, 23),
		not(isPossible(12, 11)),
		not(isPossible(12, 1)),
		!.
	test(isSafeTest):-
		initGame(2,11),
		ajouterBombe(14),
		decrementerBombes,
		isSafe(28),
		not(isSafe(14)),
		initBombes,
		!.
	test(posAdjacentesTest):-
		(taillePlateau(_) -> retractall(taillePlateau(_)); true),
		assert(taillePlateau(11)),
		posAdjacentes(12, [1,11,13,23]),
		posAdjacentes(37, [26,36,38,48]),
		!.
	test(posSuivantesTest):-
		(taillePlateau(_) -> retractall(taillePlateau(_)); true),
		assert(taillePlateau(11)),
		posSuivantes(12, [12,1,11,13,23]),
		posSuivantes(37, [37,26,36,38,48]),
		!.
	test(posSuivantesPossiblesTest):-
		initPlateau(11),
		posSuivantesPossibles(12, [12,1,11,13,23], [12,13,23]),
		posSuivantesPossibles(25, [25,14,24,25,36], [25,14,36]),
		!.
	test(posSuivantesSafeTest):-
		initGame(2,11),
		initBombes,
		posSuivantesSafe([12,13,23], [12,13,23]),
		ajouterBombe(13),
		decrementerBombes,
		posSuivantesSafe([12,13,23],[]),
		!.
	/*test(adversairePlusProcheTest):-
		initGame(2,11),
		initBombes,
		plateauSav(_Board),
		adversairePlusProche(12,[20,108], 8, 20),
		adversairePlusProche(108,[12,20], 8, 20),
		!.*/
	test(posSuivantesPlusProchesTest):-
		initGame(2,11),
		initBombes,
		plateauSav(_Board),
		%TODO Appeller la methode et check les retours.
		!.
:-end_tests(ia).

:-begin_tests(bombes).
	test(initBombes):-
		initBombes,
		not(bombes(_,_)),
		(nbJoueurs(_) -> retractall(nbJoueurs(_)); true),
		assert(nbJoueurs(2)),
		ajouterBombe(12),
		initBombes,
		not(bombes(_,_)),
		!.
	test(ajouterBombe):-
		initBombes,
		(nbJoueurs(_) -> retractall(nbJoueurs(_)); true),
		assert(nbJoueurs(2)),
		ajouterBombe(14),
		nbJoueurs(NbJoueurs),
		Duree is NbJoueurs * 5,
		bombes(14, Duree),
		initBombes,
		!.
	test(decrementerBombes):-
		initBombes,
		(nbJoueurs(_) -> retractall(nbJoueurs(_)); true),
		assert(nbJoueurs(2)),
		ajouterBombe(14),
		ajouterBombe(23),
		decrementerBombes,
		bombes(14, 9),
		bombes(23, 9),
		decrementerBombes,
		bombes(14, 8),
		bombes(23, 8),
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes,
		decrementerBombes, % On décrémente 8 fois pour faire exploser la bombe et vérifier si elle est toujours en mémoire.
		not(bombes(14, _)),
		not(bombes(23, _)),
		initBombes,
		!.
:-end_tests(bombes).
