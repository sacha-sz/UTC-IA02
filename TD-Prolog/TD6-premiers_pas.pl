% Le but est de représenter l'arbre généalogique de la famille d'Oedipe.
% Cet arbre est représenté dans le fichier labacides2.png

% 1. pere(X,Y)( X est le père de Y )
pere(X, Y) :- homme(X), parent(X, Y).

% 2. mere(X,Y)( X est la mère de Y )
mere(X, Y) :- femme(X), parent(X, Y).

% 3. epoux(X,Y)( X est l’époux de Y )
epoux(X, Y) :- homme(X), couple(Y, X).
epoux(X, Y) :- homme(X), couple(X, Y).
% VERSION CACA : epoux(X, Y) :- homme(X),( couple(Y, X) ; couple(X, Y) ). 

% 4. epouse(X,Y)( X est l’épouse de Y )
epouse(X, Y) :- femme(X), couple(Y, X).
epouse(X, Y) :- femme(X), couple(X, Y).

% 5. couple(X,Y)( X est le mari ou la femme de Y )
% Est une primitive donc pas de règle

% 6. fils(X,Y)( X est le fils de Y )
fils(X, Y) :- homme(X), parent(Y, X).

% 7. fille(X,Y)( X est la fille de Y )
fille(X, Y) :- femme(X), parent(Y, X).

% 8. enfant(X,Y)( X est l’enfant de Y )
enfant(X, Y) :- parent(Y, X).
% enfant(X, Y) :- fils(X, Y).
% enfant(X, Y) :- fille(X, Y).

% 9. parent(X,Y)( X est un parent de Y )
% Est une primitive donc pas de règle

% 10. grandPere(X,Y)( X est le grand-père de Y )
grandPere(X, Y) :- pere(X, Z), parent(Z, Y).

% 11. grandMere(X,Y)( X est la grand-mère de Y )
grandMere(X, Y) :- mere(X, Z), parent(Z, Y).

% 12. grandParent(X,Y)( X est un grand parent de Y )
grandParent(X, Y) :- parent(X, Z), parent(Z, Y).

% 13. petitFils(X,Y)( X est le petit-fils de Y )
petitFils(X, Y) :- fils(X, Z), parent(Y, Z).
% petitFils(X, Y) :- homme(X), grandParent(Y, X).

% 14. petiteFille(X,Y)( X est la petite-fille de Y )
petiteFille(X, Y) :- fille(X, Z), parent(Y, Z).
% petiteFille(X, Y) :- femme(X), grandParent(Y, X).

% 15. memePere(X,Y)( X a le même père que Y )
memePere(X, Y) :- pere(Z, X), pere(Z, Y), X \= Y.

% 16. memeMere(X,Y)( X a la même mère que Y )
memeMere(X, Y) :- mere(Z, X), mere(Z, Y), X \= Y.

% 17. memeParent(X,Y)( X a un parent en commun avec Y )
memeParent(X, Y) :- parent(Z, X), parent(Z, Y), X \= Y.

% 18. memeParents(X,Y)( X a les même parents que Y )
memeParents(X, Y) :- memeMere(X, Y), memePere(X, Y), X \= Y.

% 19. frere(X,Y)( X est le frère de Y )
frere(X, Y) :- homme(X), memeParents(X, Y).

% 20. soeur(X,Y)( X est la sœur de Y )
soeur(X, Y) :- femme(X), memeParents(X, Y).

% 21. demiFrere(X,Y)( X est le demi-frère de Y )
demiFrere(X, Y) :- homme(X), memeParent(X, Y), \+ memeParents(X, Y).

% 22. demiSoeur(X,Y)( X est la demi-sœur de Y )
demiSoeur(X, Y) :- femme(X), memeParent(X, Y), \+ memeParents(X, Y).  

% 23. oncle(X,Y)( X est l’oncle de Y )
oncle(X, Y) :- frere(X, Z), parent(Z, Y).
oncle(X, Y) :- demiFrere(X, Z), parent(Z, Y).
oncle(X, Y) :- epoux(X, Z), soeur(Z, W), parent(W, Y).
oncle(X, Y) :- epouse(X, Z), demiSoeur(Z, W), parent(W, Y).

% 24. tante(X,Y)( X est la tante de Y )
tante(X, Y) :- soeur(X, Z), parent(Z, Y).
tante(X, Y) :- demiSoeur(X, Z), parent(Z, Y).
tante(X, Y) :- epouse(X, Z), frere(Z, W), parent(W, Y).
tante(X, Y) :- epoux(X, Z), demiFrere(Z, W), parent(W, Y).

% 25. neveu(X,Y)( X est le neveu de Y )
neveu(X, Y) :- homme(X), oncle(Y, X).
neveu(X, Y) :- homme(X), tante(Y, X).

% 26. niece(X,Y)( X est la nièce de Y )
niece(X, Y) :- femme(X), oncle(Y, X).
niece(X, Y) :- femme(X), tante(Y, X).

% 27. cousin(X,Y)( X est le cousin de Y )
cousin(X, Y) :- homme(X), oncle(Z, X), parent(Z, Y).
cousin(X, Y) :- homme(X), tante(Z, X), parent(Z, Y).

% 28. cousine(X,Y)( X est la cousine de Y )
cousine(X, Y) :- femme(X), oncle(Z, X), parent(Z, Y).
cousine(X, Y) :- femme(X), tante(Z, X), parent(Z, Y).

% 29. gendre(X,Y)( X est le gendre de Y )
gendre(X, Y) :- epoux(X, Z), parent(Y, Z).

% 30. bru(X,Y)( X est la bru de Y )
bru(X, Y) :- epouse(X, Z), parent(Y, Z).

% 31. maratre(X,Y)( X est la marâtre de Y , au sens de « la reine est la marâtre de Blanche Neige »)
maratre(X, Y) :- epouse(X, Z), pere(Z, Y).

% 32. belleMere(X,Y)( X est la belle-mère de Y , dans l’acceptation la plus large)
% belleMere(X, Y) :- mere(X, Z), epoux(Z, Y)
% belleMere(X, Y) :- mere(X, Z), epouse(Z, Y)
% belleMere(X, Y) :- maratre(X, Y)
bellemere(X, Y) :- femme(X), (gendre(Y, X) ; bru(Y, X) ; (epouse(X, Z), parent(Z, Y)), \+ mere(X, Y)).

% 33. beauPere(X,Y)( X est le beau-père de Y )
beauPere(X, Y) :- homme(X), (gendre(Y, X) ; gendre(Y, X) ; (epoux(X, Z), parent(Z, Y)), \+ pere(X, Y)).

% 34. ascendant(X,Y)( X est un ascendant de Y )
ascendant(X, Y) :- parent(X, Y).
ascendant(X, Y) :- parent(X, Z), ascendant(Z, Y).

% 35. descendant(X,Y)( X est un descendant de Y )
descendant(X, Y) :- ascendant(Y, X).

% 36. lignee(X,Y)( X est sur la même lignée que Y )
lignee(X, Y) :- ascendant(X, Y).
lignee(X, Y) :- descendant(X, Y).

% 37. parente(X,Y)( X a un lien de parenté avec Y , c.-à.-d. ils sont dans la même partie de l’arbre généalogique)
parente(X, Y) :- ascendant(Z, X), ascendant(Z, Y), X \= Y.


% Faits
femme(harmonie).
femme(agave).
femme(semele).
femme(jocaste).
femme(eurydice).
femme(antigone).
femme(ismene).

homme(cadmos).
homme(polydore).
homme(echion).
homme(zeus).
homme(labdacos).
homme(penthee).
homme(dionysos).
homme(menecee).
homme(laios).
homme(creon).
homme(oedipe).
homme(hemon).
homme(eteocle).
homme(polynice).

couple(oedipe, jocaste).
couple(laios, jocaste).
couple(cadmos, harmonie).
couple(echion, agave).
couple(zeus, semele).
couple(creon, eurydice).

parent(oedipe, polynice).
parent(oedipe, eteocle).
parent(oedipe, ismene).
parent(oedipe, antigone).
parent(jocaste, polynice).
parent(jocaste, eteocle).
parent(jocaste, ismene).
parent(jocaste, antigone).
parent(laios, oedipe).
parent(jocaste, oedipe).
parent(creon, hemon).
parent(eurydice, hemon).
parent(menecee, jocaste).
parent(menecee, creon).
parent(penthee, menecee).
parent(labdacos, laios).
parent(polydore, labdacos).
parent(agave, penthee).
parent(echion, penthee).
parent(semele, dionysos).
parent(zeus, dionysos).
parent(cadmos, polydore).
parent(cadmos, echion).
parent(cadmos, semele).
parent(harmonie, polydore).
parent(harmonie, echion).
parent(harmonie, semele).