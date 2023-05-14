% 1.1
nBienPlace([], [], 0).

nBienPlace([T|Q1], [T|Q2], BP) :-
    nBienPlace(Q1, Q2, BP1),
    BP is BP1 + 1. % BP is BP1 + 1. % Fait l'évaluation : BP1 est évalué puis BP est unifié à BP1 + 1.
    % BP = BP1 + 1. % Ne fait pas l'évaluation : = unification entre termes

nBienPlace([T1|Q1], [T2|Q2], BP) :-
    dif(T1, T2),
    nBienPlace(Q1, Q2, BP).

% 1.2
longueur([], 0).

longueur([_|Q], L) :-
    longueur(Q, L1),
    L is L1 + 1.

gagne(C1, C2) :-    
    longueur(C1, L),
    longueur(C2, L),
    nBienPlace(C1, C2, Bp),
    L =:= Bp.


% 2.1
element(X, [X|_]).

element(X, [_|Q]) :-
    element(X, Q).

% 2.2 
enleve(_, [], []).
enleve(X, [X|Q], Q).

enleve(X, [T|Q], [T|Q_temp]) :-
    enleve(X, Q, Q_temp),
    dif(T, X).

% 2.3
enleveBP([], [], [], []).

enleveBP([T|Q0], [T|Q1], Q2, Q3) :-
    enleveBP(Q0, Q1, Q2, Q3).

enleveBP([T1|Q1], [T2|Q2], [T1|Q3], [T2|Q4]) :-
    dif(T1, T2),
    enleveBP(Q1, Q2, Q3, Q4).



% 2.4
% nMalPlaces : 
%   - enleveBP
%   - appelle NmalPlaceAux
nMalPlaces(L1, L2, N) :-
    enleveBP(L1, L2, L1_temp, L2_temp),
    nMalPlacesAux(L1_temp, L2_temp, N).


% nMalPlacesAux :
%   - itére liste 1
%   - si élément courant est dans liste 2 [element]
%       - enleve élément courant de liste 2 [enleve]
%   - appel récursif sur liste 1 (cdr) et 2 (ayant l'élément enlever) [NmalPlaceAux]

nMalPlacesAux([],_ , 0).

nMalPlacesAux([T|Q], L2, N) :-
    element(T, L2),
    enleve(T, L2, L2_temp),
    nMalPlacesAux(Q, L2_temp, N_temp),
    N is N_temp + 1.

nMalPlacesAux([T|Q], L2, N) :-
    \+ element(T, L2),
    nMalPlacesAux(Q, L2, N).

% 3 
codeur(_, 0, []).

codeur(M, N, [X|Code]) :-
    N > 0,
    N1 is N-1,
    Mtemp is M+1,
    codeur(M, N1, Code),
    random(1, Mtemp, X).

% 4
jouons(M, N, Max) :-
    codeur(M, N, Secret),
    write("\nC est parti !\n"),

    write("Il reste "),
    write(Max),
    write(" coup(s).\nDonner un code : "),
    read(Code),
    jouer(Max, Secret, Code, 0).

jouer(0, Secret, _, Nb_coups) :-
    write("Perdu !\nLe code etait : "),
    write(Secret),
    write("\nTu as joue "),
    write(Nb_coups),
    write(" coups.\nTu es vraiment une quiche et un naze !").

jouer(Essais, Secret, Code, Nb_coups) :-
    \+ gagne(Code, Secret),
    nBienPlace(Code, Secret, BienPlace),
    nMalPlaces(Code, Secret, MalPlace),
    write("BP : "),
    write(BienPlace),
    write(" / MP : "),
    write(MalPlace),
    write("\n"),
    Essais1 is Essais - 1,
    Nb_coups1 is Nb_coups + 1,
    Essais1 > 0,
    write("\n--------\nIl reste "),
    write(Essais1),
    write(" coup(s).\nDonner un code : "),
    read(Code1),
    jouer(Essais1, Secret, Code1, Nb_coups1).

jouer(Essais, Secret, Code, Nb_coups) :-
    \+ gagne(Code, Secret),
    nBienPlace(Code, Secret, BienPlace),
    nMalPlaces(Code, Secret, MalPlace),
    write("BP : "),
    write(BienPlace),
    write(" / MP : "),
    write(MalPlace),
    write("\n"),
    Essais1 is Essais - 1,
    Nb_coups1 is Nb_coups + 1,
    Essais1 = 0,
    jouer(0, Secret, Code, Nb_coups1).

jouer(_, Secret, Code, Nb_coups) :-
    gagne(Code, Secret),
    write("Gagne !\nTu as trouve en "),
    write(Nb_coups),
    write(" coups !\nTu es le plus beau et le plus fort !\n").


% TP4 - BONUS

liste_couleurs(Min, Max, []) :-
    Min > Max.

liste_couleurs(Min, Max, [Min|Q]) :-
    Min =< Max,
    Min1 is Min + 1,
    liste_couleurs(Min1, Max, Q).


gen(_, 0, []).

gen(M, N, [X|Code]) :-
    N > 0,
    N1 is N-1,
    liste_couleurs(1, M, LC),
    member(X, LC),
    gen(M, N1, Code).


get_code_historique([], []).

get_code_historique([[Code|_]|R], [Code|Q]) :-
    get_code_historique(R, Q).

get_bp_mp(Code, Code_secret, Bp, Mp) :-
    nBienPlace(Code, Code_secret, Bp),
    nMalPlaces(Code, Code_secret, Mp).

verif_bp_mp(_, []).

verif_bp_mp(Code, [[Code_liste|[Bp|[Mp|[]]]]|R]) :-
    get_bp_mp(Code, Code_liste, Bp, Mp),
    verif_bp_mp(Code, R).

test(Code, Historique) :-
    % Vérifie que le code n'est pas dans l'historique
    get_code_historique(Historique, Codes),
    \+ member(Code, Codes),

    % Vérifie que le code contiennent le bon nombre de BP et MP
    verif_bp_mp(Code, Historique),
    !.


decodeur(M, N, Hist, Code) :-
    gen(M, N, Code),
    test(Code, Hist),
    !.

afficher_ligne_separation(0) :- nl.

afficher_ligne_separation(N) :-
    N > 0,
    write("="),
    N1 is N - 1,
    afficher_ligne_separation(N1).


arbitre(M, N, Code_a_trouver, Hist) :-
    decodeur(M, N, Hist, C ),
    gagne(Code_a_trouver, C),
    longueur(Hist, LH),
    L is LH + 1,
    N_ligne is N * 3 + 30,
    afficher_ligne_separation(N_ligne),
    write("||"), nl, 
    write("||---------- CODE TROUVE ! : "), write(C), nl,
    write("||---------- En "), write(L), write(" coups !"), nl,
    write("||"), nl,
    afficher_ligne_separation(N_ligne),
    !.

arbitre(M, N, Code_a_trouver, Hist) :-
    longueur(Hist, LH),
    decodeur(M, N, Hist, C ),
    L is LH + 1,
    N_ligne is N * 3 + 30,
    afficher_ligne_separation(N_ligne),
    write("||"), nl,
    write("||---- Essai "), write(L), write(" : "), write(C), nl,
    get_bp_mp(C, Code_a_trouver, Bp, Mp),
    write("||---- BP : "), write(Bp), write(" / MP : "), write(Mp), nl,
    write("||"), nl,
    afficher_ligne_separation(N_ligne),
    arbitre(M, N, Code_a_trouver, [[C, Bp, Mp]|Hist]),
    !.


partie_humain_codeur() :-
    write("Nombre de couleurs : "),
    read(M),
    write("Longueur du code : "),
    read(N),
    write("Code a trouver : "),
    read(Code_a_trouver),
    N_ligne is N * 3 + 30,
    afficher_ligne_separation(N_ligne),
    write("C est parti !"), nl,
    afficher_ligne_separation(N_ligne),
    arbitre(M, N, Code_a_trouver, []),
    !.

partie_machine_codeur() :-
    write("Nombre de couleurs : "),
    read(M),
    write("Longueur du code : "),
    read(N),
    codeur(M, N, Code_a_trouver),
    write("Code a trouver : "),
    write(Code_a_trouver), nl,
    N_ligne is N * 3 + 30,
    afficher_ligne_separation(N_ligne),
    write("C est parti !"), nl,
    afficher_ligne_separation(N_ligne),
    arbitre(M, N, Code_a_trouver, []),
    !.

partie_full_machine() :-
    write("Cette partie est entierement automatique."), nl,
    write("Nombre de couleurs : "),
    random(5, 26, M),
    write(M), nl,
    write("Longueur du code : "),
    random(3, 6, N),
    write(N), nl,
    codeur(M, N, Code_a_trouver),
    write("Code a trouver : "),
    write(Code_a_trouver), nl,
    N_ligne is N * 3 + 30,
    afficher_ligne_separation(N_ligne),
    write("C est parti !"), nl,
    afficher_ligne_separation(N_ligne),
    arbitre(M, N, Code_a_trouver, []),
    !.
