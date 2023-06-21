# Zizou est le meilleur joueur de Sokoban du monde
# Il a besoin de vous pour résoudre les niveaux
# Vous devez écrire un programme qui résout les niveaux de Sokoban

from collections import namedtuple
from copy import deepcopy
from typing import Optional

# Partie 0 : Variables globales
possible_action = [
    "U",
    "D",
    "L",
    "R",
    # En minuscule pour les actions avec une caisse
    "u",
    "d",
    "l",
    "r"
]

BOXE = "C"
PLAYER = "J"
OBJECTIVE = "O"
EMPTY = " "
WALL = "#"
Node = namedtuple("Node", ["etat", "father", "action"])

test_map = """###########
#   ###   #
#   C  ## #
#      #  #
#    ######
#      #O #
#         #
# J  #    #
#####  C  #
# O       #
###########"""


# Mise en forme de la map en liste de liste
test_map = test_map.split("\n")
test_map = list(map(lambda x: list(x), test_map))


# Partie 1 : Fonctions de base

def verif_coord(x: int, y: int) -> bool:
    """
    Fonction qui vérifie si les coordonnées sont valides
    :param x: coordonnée x
    :param y: coordonnée y
    :param map: map
    :return: booléen
    """
    return 0 <= y < len(test_map) and 0 <= x < len(test_map[0])


def get_pos_player(map: list) -> tuple:
    """
    Fonction qui retourne les coordonnées du joueur
    :param map: map
    :return: tuple (x, y)
    """
    for y in range(len(map)):
        for x in range(len(map[0])):
            if map[y][x] == PLAYER:
                return x, y


def get_pos_boxes(map: list) -> set:
    """
    Fonction qui retourne les coordonnées des caisses
    :param map: map
    :return: liste de tuple (x, y)
    """
    boxes = set()
    for y in range(len(map)):
        for x in range(len(map[0])):
            if map[y][x] == BOXE:
                boxes.add((x, y))
    return boxes


def get_pos_objectives(map: list) -> set:
    """
    Fonction qui retourne les coordonnées des objectifs
    :param map: map
    :return: liste de tuple (x, y)
    """
    objectives = set()
    for y in range(len(map)):
        for x in range(len(map[0])):
            if map[y][x] == OBJECTIVE:
                objectives.add((x, y))
    return objectives


def get_pos_wall(map: list) -> set:
    """
    Fonction qui retourne les coordonnées des murs
    :param map: map
    :return: liste de tuple (x, y)
    """
    walls = set()
    for y in range(len(map)):
        for x in range(len(map[0])):
            if map[y][x] == WALL:
                walls.add((x, y))
    return walls


dict_non_fluents = {
    "WALLS": get_pos_wall(test_map),
    "OBJECTIVES": get_pos_objectives(test_map),
}

# -----------------------------------------------  Joueur + Boîte -----------------------------------------------


def push_box_up(etat: dict, x: int, y: int) -> dict:
    """
    Fonction qui pousse une caisse vers le haut
    :param etat: dictionnaire des fluents
    :param x: coordonnée x de la caisse [colonne]
    :param y: coordonnée y de la caisse [ligne]
    :return: etat résultant
    """
    if verif_coord(x, y-2) and \
            ((y-2, x) in dict_non_fluents["OBJECTIVES"] or ((y-2, x) not in dict_non_fluents.values() and (y-2, x) not in dict_fluents.values())) and \
            (y-1, x) in etat["BOXES"] and (y, x) in etat["PLAYER"]:

        etat["BOXES"].remove((y-1, x))
        etat["BOXES"].add((y-2, x))

        etat["PLAYER"].remove((y, x))
        etat["PLAYER"].add((y-1, x))

    return etat


def push_box_down(etat: dict, x: int, y: int) -> dict:
    """
    Fonction qui pousse une caisse vers le bas
    :param etat: dictionnaire des fluents
    :param x: coordonnée x de la caisse [colonne]
    :param y: coordonnée y de la caisse [ligne]
    :return: etat résultant
    """

    if verif_coord(x, y+2) and \
            ((y+2, x) in dict_non_fluents["OBJECTIVES"] or ((y+2, x) not in dict_non_fluents.values() and (y+2, x) not in dict_fluents.values())) and \
            (y+1, x) in etat["BOXES"] and (y, x) in etat["PLAYER"]:

        etat["BOXES"].remove((y+1, x))
        etat["BOXES"].add((y+2, x))

        etat["PLAYER"].remove((y, x))
        etat["PLAYER"].add((y+1, x))

    return etat

def push_box_left(etat: dict, x: int, y: int) -> dict:
    """
    Fonction qui pousse une caisse vers la gauche
    :param etat: dictionnaire des fluents
    :param x: coordonnée x de la caisse [colonne]
    :param y: coordonnée y de la caisse [ligne]
    :return: etat résultant
    """

    if verif_coord(x-2, y) and \
            ((y, x-2) in dict_non_fluents["OBJECTIVES"] or ((y, x-2) not in dict_non_fluents.values() and (y, x-2) not in dict_fluents.values())) and \
            (y, x-1) in etat["BOXES"] and (y, x) in etat["PLAYER"]:

        etat["BOXES"].remove((y, x-1))
        etat["BOXES"].add((y, x-2))

        etat["PLAYER"].remove((y, x))
        etat["PLAYER"].add((y, x-1))

    return etat

def push_box_right(etat: dict, x: int, y: int) -> dict:
    """
    Fonction qui pousse une caisse vers la droite
    :param etat: dictionnaire des fluents
    :param x: coordonnée x de la caisse [colonne]
    :param y: coordonnée y de la caisse [ligne]
    :return: etat résultant
    """

    if verif_coord(x+2, y) and \
            ((y, x+2) in dict_non_fluents["OBJECTIVES"] or ((y, x+2) not in dict_non_fluents.values() and (y, x+2) not in dict_fluents.values())) and \
            (y, x+1) in etat["BOXES"] and (y, x) in etat["PLAYER"]:

        etat["BOXES"].remove((y, x+1))
        etat["BOXES"].add((y, x+2))

        etat["PLAYER"].remove((y, x))
        etat["PLAYER"].add((y, x+1))

    return etat


# -----------------------------------------------  Joueur -----------------------------------------------


def move_player_up(etat: dict, x:int, y:int) -> dict:
    """
    Fonction qui déplace le joueur vers le haut
    :param etat: dictionnaire des fluents
    :param x: coordonnée x du joueur [colonne]
    :return: etat résultant
    """

    print("move_player_up")
    
    if verif_coord(x, y-1) and \
            ((y-1, x) in dict_non_fluents["OBJECTIVES"] or ((y-1, x) not in list(dict_non_fluents.values()) and (y-1, x) not in list(dict_fluents.values()))) and \
            (y, x) in etat["PLAYER"]:
        etat["PLAYER"] = (y-1, x)
        print('etat["PLAYER"] = (y-1, x)')

    return etat


def move_player_down(etat: dict, x:int, y:int) -> dict:
    """
    Fonction qui déplace le joueur vers le bas
    :param etat: dictionnaire des fluents
    :param x: coordonnée x du joueur [colonne]
    :return: etat résultant
    """

    if verif_coord(x, y+1) and \
            ((y+1, x) in dict_non_fluents["OBJECTIVES"] or ((y+1, x) not in dict_non_fluents.values() and (y+1, x) not in dict_fluents.values())) and \
            (y, x) in etat["PLAYER"]:

        etat["PLAYER"].remove((y, x))
        etat["PLAYER"].add((y+1, x))

    return etat


def move_player_left(etat: dict, x:int, y:int) -> dict:
    """
    Fonction qui déplace le joueur vers la gauche
    :param etat: dictionnaire des fluents
    :param x: coordonnée x du joueur [colonne]
    :return: etat résultant
    """

    if verif_coord(x-1, y) and \
            ((y, x-1) in dict_non_fluents["OBJECTIVES"] or ((y, x-1) not in dict_non_fluents.values() and (y, x-1) not in dict_fluents.values())) and \
            (y, x) in etat["PLAYER"]:

        etat["PLAYER"].remove((y, x))
        etat["PLAYER"].add((y, x-1))

    return etat

def move_player_right(etat: dict, x:int, y:int) -> dict:
    """
    Fonction qui déplace le joueur vers la droite
    :param etat: dictionnaire des fluents
    :param x: coordonnée x du joueur [colonne]
    :return: etat résultant
    """

    if verif_coord(x+1, y) and \
            ((y, x+1) in dict_non_fluents["OBJECTIVES"] or ((y, x+1) not in dict_non_fluents.values() and (y, x+1) not in dict_fluents.values())) and \
            (y, x) in etat["PLAYER"]:

        etat["PLAYER"].remove((y, x))
        etat["PLAYER"].add((y, x+1))

    return etat

# -----------------------------------------------  Vérification -----------------------------------------------


def verif_plan(plan:str, etat_actuel :dict) -> dict:
    """
    Fonction qui vérifie si le plan est correcte
    :param plan: plan à vérifier
    :param etat_actuel: etat actuel de la map
    :return: etat résultant ou None
    """

    # On récupère les coordonnées du joueur
    x_player, y_player = etat_actuel["PLAYER"]
    etat = etat_actuel

    # On parcourt le plan
    for action in plan:
        if action == "U":
            etat_res = move_player_up(etat, x_player, y_player)

        elif action == "D":
            etat_res = move_player_down(etat, x_player, y_player)
        
        elif action == "L":
            etat_res = move_player_left(etat, x_player, y_player)
        
        elif action == "R":
            etat_res = move_player_right(etat, x_player, y_player)
            
        elif action == "u":
            etat_res = push_box_up(etat, x_player, y_player)
        
        elif action == "d":
            etat_res = push_box_down(etat, x_player, y_player)
        
        elif action == "l":
            etat_res = push_box_left(etat, x_player, y_player)
            
        elif action == "r":
            etat_res = push_box_right(etat, x_player, y_player)
        
        else:
            return None
        
        print(etat_res)
        if etat_res == etat:
            # Il n'y a pas eu de changement d'état donc le plan est incorrect
            return None
        
        etat = etat_res
    
    return etat
        
        
        
        

def etat_final(set_boxes, set_objectives):
    """
    Fonction qui vérifie que toutes les boîtess sont sur des objectifs
    :param set_boxes: ensemble des coordonnées des boîtes
    :param set_objectives: ensemble des coordonnées des objectifs
    :return: True si toutes les boîtes sont sur des objectifs, False sinon
    """
    return set_boxes == set_objectives


def clone(map: list) -> list:
    """
    Fonction qui clone une map
    :param map: map à cloner
    :return: map clonée
    """

    return deepcopy(map)


def succ(etat):
    """
    Fonction qui retourne les successeurs d'un état
    """
    liste_etat_succ = []
    
    for action in possible_action:
        liste_etat_succ.append((verif_plan(action, etat), action))

    print(liste_etat_succ)
    liste_etat_succ = [etat for etat in liste_etat_succ if etat[0] is not None]
    
    print(liste_etat_succ)
    return liste_etat_succ


def search_with_parents(
    s0: dict,
    goals: list[dict],
) -> tuple[Optional[dict], dict[dict, Optional[dict]]]:
    l = [s0]
    save = [Node(s0, None, None)]
    s = s0

    while l:
        s = l.pop()
        print(s)

        if etat_final(s["BOXES"], goals["BOXES"]):
            return s, save
        else:
            for s2, act in succ(s):
                s2_temp = Node(s2, s, act)
                if not s2_temp in save:
                    l.append(s2)
                    save.append(s2_temp)

    return None, save


if __name__ == "__main__":
    dict_fluents = {
        "PLAYER": get_pos_player(test_map),
        "BOXES": get_pos_boxes(test_map),
    }
    print(dict_fluents)
    dict_target = {
        "PLAYER": get_pos_player(test_map),
        "BOXES": get_pos_objectives(test_map),
    }
    print(dict_target)

    res = search_with_parents(
        dict_fluents,
        dict_target)

    print(res)