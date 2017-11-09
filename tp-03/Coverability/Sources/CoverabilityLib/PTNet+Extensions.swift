import PetriKit

public extension PTNet {

    public func coverabilityGraph(from marking: CoverabilityMarking) -> CoverabilityGraph {

      // Initialisation du graph de couverture
    let CurrMarkingGraph = CoverabilityGraph(marking : marking)

    // Initialisation de liste pour marquer les marquages
    var seen = [CurrMarkingGraph]
    var toVisit = [CurrMarkingGraph]

    // Initialisation d'une variable qui contiendra le marquage en corus
    var currMarking : CoverabilityMarking

    while let current = toVisit.popLast(){
      for elem in self.transitions{
        // On verifie si la transition est franchissable
        if(elem.isFireableCover(from: current.marking)){
          // Si oui, on recupère le marquage après le franchissement de celle-ci
          currMarking = elem.fireCover(from: current.marking)!
          // Boucle cherchant parmis tout les précedents marquage si le marquage actuel
          // est plus grand qu'un marquage précedent
          for AnteriorGraph in CurrMarkingGraph{
              if(currMarking > AnteriorGraph.marking){
                for place in self.places{
                  if currMarking[place]! > AnteriorGraph.marking[place]!{
                    currMarking[place]! = .omega
                  }
                }
              }
          }
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
          let newSuccessor = CoverabilityGraph(marking: currMarking)
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
