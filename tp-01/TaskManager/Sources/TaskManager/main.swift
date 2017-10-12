import TaskManagerLib

// Exercice 3
let taskManager = createTaskManager()

// Mise en variable des transitions
let fail = taskManager.transitions.first{$0.name == "fail"}!
let spawn = taskManager.transitions.first{$0.name == "spawn"}!
let create = taskManager.transitions.first{$0.name == "create"}!
let success = taskManager.transitions.first{$0.name == "success"}!
let exec = taskManager.transitions.first{$0.name == "exec"}!

// Mise en variable des places
let inProgress = taskManager.places.first{$0.name == "inProgress"}!
let processPool = taskManager.places.first{$0.name == "processPool"}!
let taskPool = taskManager.places.first{$0.name == "taskPool"}!

// Analyse du problème
// Faisont apparaître 2 processus
let m1 = spawn.fire(from: [taskPool: 0, processPool: 0, inProgress: 0])
let m2 = spawn.fire(from: m1!)
// Faisont apparaître 1 tache
let m3 = create.fire(from: m2!)
// Le problème survient au bout de 2 exec:
let m4 = exec.fire(from: m3!)
let m5 = exec.fire(from: m4!)
// m5 = [taskPool: 1, processPool: 0, inProgress: 2]
// Donc si l'on fire success il restera encore un jeton dans inProgress alors qu'aucune tâche n'est active d'où le probleme
let m6 = success.fire(from: m5!)
print("Voici le marquage problématique :")
print(m6!)
// m6 = [taskPool: 0, processPool: 0, inProgress: 1]

print() // Permet de mettre un espace
// Exercice 4
let correctTaskManager = createCorrectTaskManager()

// Le problème ici est que la place inProgress peut contenir plusieurs jetons
// Pour contrer ce problème l'astuce serait de rajouter une place "waitFlag" qui permet de controler
// la transition exec et faire en sorte qu'on ne peut executer exec seulement lorsque inProgress est vide

// Mise en variable des transitions
let fail0 = correctTaskManager.transitions.first{$0.name == "fail"}!
let spawn0 = correctTaskManager.transitions.first{$0.name == "spawn"}!
let create0 = correctTaskManager.transitions.first{$0.name == "create"}!
let success0 = correctTaskManager.transitions.first{$0.name == "success"}!
let exec0 = correctTaskManager.transitions.first{$0.name == "exec"}!

// Mise en variable des places
let inProgress0 = correctTaskManager.places.first{$0.name == "inProgress"}!
let processPool0 = correctTaskManager.places.first{$0.name == "processPool"}!
let taskPool0 = correctTaskManager.places.first{$0.name == "taskPool"}!
let waitFlag0 = correctTaskManager.places.first{$0.name == "waitFlag"}!

// Si l'on test la même séquence qui menait à une problématique
let P1 = spawn0.fire(from: [taskPool0: 0, processPool0: 0, inProgress0: 0, waitFlag0: 1])
let P2 = spawn0.fire(from: P1!)
let P3 = create0.fire(from: P2!)
let P4 = exec0.fire(from: P3!)
let P5 = exec0.fire(from: P4!)
if (P5 == nil)
{
  print("Transition non franchissable")
}
// Ainsi la transition exec n'est plus franchissable grace a cette nouvelle place ajoutée
let P6 = success0.fire(from: P4!)
print("Voici le marquage final lorsque, le processus a ete un succes :")
print(P6!)
// Le marquage P6 est donc bien le résultat souhaité
