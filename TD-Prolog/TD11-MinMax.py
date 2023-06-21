from copy import deepcopy

class Etat:
    def __init__(self, type, map, martin: bool = False):
        self.type = type # 0: max, 1: min
        self.map = map
        self.succ = self.successeurs()
        self.valeur = self.evaluation(martin)

            
    def __str__(self):
        string = "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\n"
        string += "Evaluation: " + str(self.valeur) + "\n"
        if self.type == 0:
            string += "Je maximise pour le joueur X\n"
        else:
            string += "Je minimise pour le joueur O\n"
        string += "+---+---+---+\n"
        for line in self.map:
            string += "| "
            for case in line:
                string+=case
                string+=" | "
            string += "\n+---+---+---+\n" 
        return string
    
    def get_map(self):
        return deepcopy(self.map)
    
    def is_terminal_state(self):
        return self.eval_terminal() != 0
            
    def successeurs(self):
        """
        On regarde tous les états possibles à partir de l'état courant
        """
        
        if self.eval_terminal(self.map) != 0:
            return []
    
        successeur = []
        for i in range(3):
            for j in range(3):
                if self.map[i][j] == ' ':
                    temp = deepcopy(self.map)
                    if self.type == 0:
                        temp[i][j] = 'X'
                        etat_fils = Etat(1, temp)
                    else:
                        temp[i][j] = 'O'
                        etat_fils = Etat(0, temp)
                    successeur.append(etat_fils)
                
        return successeur
    
    def evaluation(self, martin: bool = False):
        """"
        On regarde tous ses successeurs et on prend le max ou le min de leurs valeurs
        """        
        
        if self.succ == []:
            return self.eval_terminal()  
        
            
        if martin:
            return sum([etat.evaluation() for etat in self.succ])

        else:
            if self.type == 0:
                return max([etat.evaluation() for etat in self.succ])
            else:
                return min([etat.evaluation() for etat in self.succ])
    
    def eval_terminal(self, map_test = None):
        """
        On regarde s'il y a un gagnant
        """
        # on regarde s'il y a une combinaison gagnante sur une ligne
        for i in range(3):
            if self.map[i][0] == self.map[i][1] == self.map[i][2]:
                if self.map[i][0] == 'X':
                    return 1
                elif self.map[i][0] == 'O':
                    return -1
                
        # on regarde s'il y a une combinaison gagnante sur une colonne
        for i in range(3):
            if self.map[0][i] == self.map[1][i] == self.map[2][i]:
                if self.map[0][i] == 'X':
                    return 1
                elif self.map[0][i] == 'O':
                    return -1
        
        # on regarde s'il y a une combinaison gagnante sur une diagonale
        if self.map[0][0] == self.map[1][1] == self.map[2][2]:
            if self.map[0][0] == 'X':
                return 1
            elif self.map[0][0] == 'O':
                return -1
            
        if self.map[0][2] == self.map[1][1] == self.map[2][0]:
            if self.map[0][2] == 'X':
                return 1
            elif self.map[0][2] == 'O':
                return -1
        return 0 # Match nul
    
    def jouer (self):
        """"
        On retourne l'état fils avec la meilleure valeur
        """
        if self.succ == []:
            return None
        return max(self.succ, key=lambda etat: etat.valeur) if self.type == 0 else min(self.succ, key=lambda etat: etat.valeur)
    

def main():
    player = 0
    etat_actuel = Etat(player, [[' ', ' ', ' '], [' ', ' ', ' '], [' ', ' ', ' ']], True)
    print(etat_actuel)
    while not etat_actuel.is_terminal_state():
        etat_actuel = etat_actuel.jouer()
        if etat_actuel == None:
            print("Match nul")
            return
        player = (player + 1) % 2
        etat_actuel = Etat(player, etat_actuel.get_map(), True)
        print(etat_actuel)
    
if __name__ == "__main__":
    main()