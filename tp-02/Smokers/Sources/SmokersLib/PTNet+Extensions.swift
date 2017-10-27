import PetriKit

public class MarkingGraph {

    public let marking   : PTMarking
    public var successors: [PTTransition: MarkingGraph]

    public init(marking: PTMarking, successors: [PTTransition: MarkingGraph] = [:]) {
        self.marking    = marking
        self.successors = successors
    }

}

public extension PTNet {
  // PTMarking = [PTPlace: UInt]
    public func markingGraph(from marking: PTMarking) -> MarkingGraph? {

      // Initialisation du graph du reseau de Petri
      let CurrMarkingGraph = MarkingGraph(marking : marking)

      // Initialisation de liste pour marquer les marquages
      var seen = [CurrMarkingGraph]
      var toVisit = [CurrMarkingGraph]

      // Initialisation d'une variable qui contiendra le marquage en corus
      var currMarking : PTMarking

      while let current = toVisit.popLast(){
        for elem in self.transitions{
          // On verifie si la transition est franchissable
          if(elem.isFireable(from: current.marking)){
            // Si oui, on recupère le marquage après le franchissement de celle-ci
            currMarking = elem.fire(from: current.marking)!
            // Afin d'éviter les doublons dans le graph on check si ce marquage n'est pas deja présent
            if(seen.contains(where: { $0.marking == currMarking })){
              current.successors[elem] = seen.first(where : { $0.marking == currMarking })
              continue // Permet de continuer directement a la prochaine itération
            }
            // Idem que ci-dessus
            if(toVisit.contains(where: { $0.marking == currMarking })){
              current.successors[elem] = toVisit.first(where : { $0.marking == currMarking })
              continue
            }
            // Si le marquage n'était présent nulle part alors on peut creer un nouveau noeud pour le graphe
            let newSuccessor = MarkingGraph(marking: currMarking)
            current.successors[elem] = newSuccessor
            // Sans oublier d'ajouter ce nouveau noeud aux elem a visiter
            toVisit.append(newSuccessor)
          }
        }
        // Une fois la transition visiter on la mets dans seen
        seen.append(current)
      }
      return CurrMarkingGraph
    }

}
