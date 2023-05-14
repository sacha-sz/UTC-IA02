% Prédicat de base


% tete(+L, -H) qui unifie la variable H avec la tête de la liste L
tete([X|_], X).


% reste(+L, -R) qui unifie la variable R avec le reste de la liste L
reste([_|Q], Q).


% vide(+L) qui est vrai si la liste L est vide
vide([]).


% element(?X, ?L) qui est vrai si X est présent dans la liste L
element(X, [X|_]).
element(X, [Y|Q]) :-
    dif(X, Y),
    element(X, Q).


% dernier(+L, -X) qui unifie X avec le dernier élément de la liste L
dernier([X], X).
dernier([_|Q], X) :-
    dernier(Q, X).


% longueur(+L, -Lg) qui unifie Lg avec la longueur de la liste L
longueur([], 0).
longueur([_|Q], Lg) :-
    longueur(Q, Lg_temp),
    Lg is Lg_temp + 1.


% nombre(+L, +X, ?N) qui compte le nombre de fois où X apparaît dans L et unifie le résultat avec N
nombre([], _, 0).

nombre([X|Q], X, N) :-
    nombre(Q, X, N_temp),
    N is N_temp + 1.

nombre([Y|Q], X, N) :-
    dif(X, Y),
    nombre(Q, X, N).


% concat(+L1, +L2, -L3) qui effectue la concaténation de la liste L1 avec la liste L2 et l’unifie avec L3
concat([], L2, L2).

concat([T|Q], L2, [T|R]) :-
    concat(Q, L2, R).

% inverse(+L, -R) telle que la liste R soit l’inverse L
inverse([], []).

inverse([T|Q], L) :-
    inverse(Q, Ltemp),
    concat(Ltemp, [T], L).


% sous_liste(+L1, +L2) qui vérifie que L1 est une sous liste de L2
% Le prédicat sous_liste vérifie que le début de la sous liste est présent dans la liste
% puis on utilise le prédicat sous_liste_aux pour vérifier que la fin de la sous liste est présente dans la liste
sous_liste_aux([], _).

sous_liste_aux([X|Q], [X|Q2]) :-
    sous_liste_aux(Q, Q2).

sous_liste([X|Q], [X|Q2]) :-
    sous_liste_aux(Q, Q2).

sous_liste([X|Q], [Y|Q2]) :-
    dif(X, Y),
    sous_liste([X|Q], Q2).


% retire_element(+L, +X, -R) qui retire la première occurrence de l’élément X dans L et place le résultat dans R
retire_element([], _ , []).

retire_element([X|Q], X, Q).

retire_element([T|Q], X, [T|Q_temp]) :-
    dif(T, X),
    retire_element(Q, X, Q_temp).



% Tri en Prolog :
%   On veut implémenter un tri sous Prolog. On utilisera un algorithme de tri de type quicksort. On
%   suppose que L est une liste d’entiers à trier. Soit X un élément de L . On considère L1 = {
%   Y ∈ L∖X tel que Y ≤ X } et L2={ Y ∈ L∖X tel que Y > X } . Alors la liste L triée est égale
%   à : [ liste L1 triée..., X , liste L2 triée...] .

% Définir partition(+X, +L, -L1, -L2) qui place dans L1 les éléments de L qui sont
% inférieurs ou égaux à X , et dans L2 les éléments de L qui sont strictement supérieurs à X
partition(_, [], [], []).

partition(X, [Y|Q], L1, [Y|R]) :-
    X < Y,
    partition(X, Q, L1, R).

partition(X, [Y|Q], [Y|R], L2) :-
    X >= Y,
    partition(X, Q, R, L2).


% Définir tri(+L1, ?L2) qui trie la liste L1 et unifie le résultat avec L2
tri([], []).

tri([H|L1], L2) :-
    partition(H, L1, L3, L4),
    tri(L3, L3t),
    tri(L4, L4t),
    concat(L3t, [H|L4t], L2).



% Les ensembles
%   On souhaite représenter les ensembles en Prolog comme des listes sans doublons. Définir
%   l’ensemble des prédicats suivants.

% etire_elements(+X, +L, -R) qui retire toutes les occurrences de X dans L et place le
% résultat dans R

retire_elements(_, [], []).

retire_elements(X, [X|Q], R) :-
    retire_elements(X, Q, R).

retire_elements(X, [Y|Q], [Y|R]) :-
    dif(X, Y),
    retire_elements(X, Q, R).


% retire_doublons(+L, -E) qui transforme la liste L en un ensemble E (sans
% redondance).
retire_doublons([], []).

retire_doublons([X|Q], [X|R]) :-
    retire_elements(X, Q, Q_temp),
    retire_doublons(Q_temp, R).


% union(+E1, +E2, -E) qui effectue l’union de l’ensemble E1 avec l’ensemble E2 et place
% le résultat dans E .
union([], E2, E2_temp) :-
    retire_doublons(E2, E2_temp).

union([X|Q], E2, E) :-
    element(X, E2),
    union(Q, E2, E).

union([X|Q], E2, [X|E]) :-
    \+ element(X, E2),
    union(Q, E2, E).


% intersection(+E1, +E2, -E) qui effectue l’intersection de l’ensemble E1 avec
% l’ensemble E2 et place le résultat dans E
intersection([], _, []).

intersection([X|Q], E2, [X|E]) :-
    element(X, E2),
    intersection(Q, E2, E).