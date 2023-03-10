def decomp(n, nb_bits):
    """
    Fonction qui décompose un nombre en binaire
    :param n: nombre à décomposer
    :param nb_bits: nombre de bits
    :return: liste de booléens
    """

    if n > (2**nb_bits-1) and nb_bits <= 0:
        # Gestion d'erreur : le nombre de bits est trop petit
        return -1

    temp = n
    binary_conv = []
    while temp:
        # Boucle qui décompose le nombre en binaire
        binary_conv.append(temp%2==1)
        temp //= 2

    binary_conv.reverse() # On inverse la liste pour avoir le bon ordre


    while len(binary_conv) < nb_bits:
        # On ajoute des 0 à gauche pour avoir le bon nombre de bits et garder le bon ordre
        binary_conv.insert(0, False)

    return binary_conv


def interpretation(voc, vals):
    """
    Fonction qui crée une interprétation à partir d'une liste de variables et de valeurs
    :param voc: liste des variables
    :param vals: liste des valeurs
    :return: dictionnaire de l'interprétation [str:bool]
    """
    
    if len(voc) != len(vals):
        # Gestion d'erreur : le nombre de variables et de valeurs est différent
        return -1

    dico = {}
    for vo, val in zip(voc, vals):
        # On crée le dictionnaire
        dico[vo] = val

    return dico


def gen_interpretations(voc):
    """
    Fonction qui génère toutes les interprétations possibles
    :param voc: liste des variables
    :return: générateur d'interprétations
    """

    nb_bits = len(voc)
    for i in range(2**nb_bits):
        # On génère la prochaine interprétation à chaque itération
        yield interpretation(voc, decomp(i, nb_bits)) # On utilise un générateur pour ne pas stocker toutes les interprétations


def valuate(formula, interpretation):
    """
    Fonction qui évalue une formule selon une interprétation
    :param formula: formule à évaluer
    :param interpretation: interprétation à utiliser de type [str:bool]
    :return: booléen
    """

    return eval(formula, interpretation)


def table(formula, voc):
    """
    Fonction qui affiche la table de vérité d'une formule
    :param formula: formule à afficher
    :param voc: liste des variables
    :return: None
    """

    def my_line():
        # Fonction qui affiche une ligne de la table
        for _ in voc:
            print("+---", end="")
        print("+-------+")


    list_interpretation = gen_interpretations(voc)

    # --------------------- Affichage de la formule ---------------------

    print("formule : " + formula)

    # --------------------- Affichage de la table ---------------------
    my_line()

    for elt_voc in voc :
        print("| " + elt_voc + " ", end="")
    
    print("| eval. |")
    my_line()

    for interpretation in list_interpretation:
        # Boucle itérant sur les interprétations

        for val in interpretation.values():
            # Boucle itérant sur les valeurs de l'interprétation
            print("| "+str(val)[0]+" ", end="")

        print("|   " + str(valuate(formula, interpretation))[0] + "   |")

    my_line()


def valide(formula, voc):
    """
    Fonction qui vérifie si une formule est valide à savoir si elle est vraie pour toutes les interprétations
    :param formula: formule à vérifier
    :param voc: liste des variables
    :return: booléen
    """

    list_interpretation = gen_interpretations(voc)

    for interpretation in list_interpretation:
        if not valuate(formula, interpretation):
            # Si la formule est fausse pour une interprétation, on retourne False
            return False

    return True


def contradictoire(formula, voc):
    """
    Fonction qui vérifie si une formule est contradictoire à savoir si elle est fausse pour toutes les interprétations
    :param formula: formule à vérifier
    :param voc: liste des variables
    :return: booléen
    """

    list_interpretation = gen_interpretations(voc)

    for interpretation in list_interpretation:
        if valuate(formula, interpretation):
            # Si la formule est vraie pour une interprétation, on retourne False
            return False

    return True


def contingente(formula, voc):
    """
    Fonction qui vérifie si une formule est contingente à savoir si elle est ni valide ni contradictoire
    :param formula: formule à vérifier
    :param voc: liste des variables
    :return: booléen
    """

    return not (valide(formula, voc) or contradictoire(formula, voc))


def is_cons(f1, f2, voc):
    """
    Fonction qui vérifie si deux formules sont contradictoires à savoir si elles sont toutes les deux vraies ou toutes les deux fausses pour toutes les interprétations
    :param f1: première formule
    :param f2: seconde formule
    :param voc: liste des variables
    :return: booléen
    """

    liste_interpretation = gen_interpretations(voc)
    for inter in liste_interpretation:
        if valuate(f1, inter) and not valuate(f2, inter):
            # Si la première formule est vraie et la seconde fausse pour une interprétation, on retourne False
            return False

    return True


def main ():
    # --------------------- Tests ---------------------

    # Test de la fonction decomp
    print(decomp(5, 4))

    # Test de la fonction interpretation
    print(interpretation(["p", "q"], [True, False]))

    # Test de la fonction gen_interpretations
    for inter in gen_interpretations(["p", "q"]):
        print(inter)

    # Test de la fonction valuate
    print(valuate("p and q", {"p": True, "q": False}))

    # Test de la fonction table
    table("p and q", ["p", "q"])

    # Test de la fonction valide
    print(valide("p and q", ["p", "q"]))
    print(valide("p or q", ["p", "q"])) 

    # Test de la fonction contradictoire
    print(contradictoire("p and q", ["p", "q"]))
    print(contradictoire("p or q", ["p", "q"]))

    # Test de la fonction contingente
    print(contingente("p and q", ["p", "q"]))
    print(contingente("p or q", ["p", "q"]))

    # Test de la fonction is_cons
    print(is_cons("p and q", "p or q", ["p", "q"]))


if __name__ == "__main__":
    main()