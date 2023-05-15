% Chiffre qui est vrai si X est un chiffre
chiffre(X) :-
    member(X, [0,1,2,3,4,5,6,7,8,9]).

generate(X1, X2) :-
    chiffre(X1),
    chiffre(X2).

test(X1, X2, X) :-
    dif(X1, X2),
    X is X1 + X2.

solve(X1, X2, X) :-
    generate(X1, X2),
    test(X1, X2, X).


% Maison d'Einstein simplifiée
% maison(Num, Nat, Coul)

nationalite(espagnol).
nationalite(norvegien).
nationalite(italien).

couleur(rouge).
couleur(verte).
couleur(bleue).

generate([maison(1, N1, C1), maison(2, N2, C2), maison(3, N3, C3)]) :-
    nationalite(N1),
    nationalite(N2),
    nationalite(N3),
    couleur(C1),
    couleur(C2),
    couleur(C3).

verif_i1(L) :-
    member(maison(N1, _, rouge), L),
    member(maison(N2, espagnol, _), L),
    N2 is N1 + 1.


verif_i2(L) :-
    member(maison(_, norvegien, bleue), L).

verif_i3(L) :-
    member(maison(2, italien, _), L).

regle_1([maison(_, _, C1 ), maison(_, _, C2), maison(_, _, C3)]) :-
    dif(C1, C2),
    dif(C1, C3),
    dif(C2, C3).

regle_2([maison(_, N1, _ ), maison(_, N2, _), maison(_, N3, _)]) :-
    dif(N1, N2),
    dif(N1, N3),
    dif(N2, N3).

test([maison(1, N1, C1), maison(2, N2, C2), maison(3, N3, C3)]) :-
    % Règle 1 : Chaque maison a une couleur différente.
    regle_1([maison(1, N1, C1), maison(2, N2, C2), maison(3, N3, C3)]),

    % Règle 2 : Chaque maison est habitée par une personne d’une nationalité différente.
    regle_2([maison(1, N1, C1), maison(2, N2, C2), maison(3, N3, C3)]),

    % Indice 1 : L’Espagnol habite la maison directement à droite de la maison rouge.
    verif_i1([maison(1, N1, C1), maison(2, N2, C2), maison(3, N3, C3)]),

    % Indice 2 : Indice 2 : Le Norvégien vit dans la maison bleue.
    verif_i2([maison(1, N1, C1), maison(2, N2, C2), maison(3, N3, C3)]),

    % Indice 3 : L’Italien habite dans la maison n°2.
    verif_i3([maison(1, N1, C1), maison(2, N2, C2), maison(3, N3, C3)]])

solve(L) :-
    generate(L),
    test(L).
