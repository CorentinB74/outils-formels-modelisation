import PetriKit

public class CoverabilityGraph {

    public init(
        marking: CoverabilityMarking, successors: [PTTransition: CoverabilityGraph] = [:])
    {
        self.marking    = marking
        self.successors = successors
    }

    public let marking   : CoverabilityMarking
    public var successors: [PTTransition: CoverabilityGraph]

    /// The number of nodes in the graph.
    public var count: Int {
        var seen    = [self]
        var toCheck = [self]

        while let node = toCheck.popLast() {
            for (_, successor) in node.successors {
                if !seen.contains(where: { $0 === successor }) {
                    seen.append(successor)
                    toCheck.append(successor)
                }
            }
        }

        return seen.count
    }
    // Fonction optionnel permettant de visualer le marquage d'un cover graph
    public func show(){
      for node in self{
        for place in node.marking{
          switch place.value {
            case .some(let a):
              print(place.key, ":", a, terminator:" ")
              break
            case .omega:
              print(place.key, ": w", terminator:" ")
              break
            }
        }
        print("")
      }
    }
}

extension CoverabilityGraph: Sequence {

    public func makeIterator() -> AnyIterator<CoverabilityGraph> {
        var seen    = [self]
        var toCheck = [self]

        return AnyIterator {
            guard let node = toCheck.popLast() else {
                return nil
            }

            let unvisited = node.successors.values.flatMap { successor in
                return seen.contains(where: { $0 === successor })
                    ? nil
                    : successor
            }

            seen.append(contentsOf: unvisited)
            toCheck.append(contentsOf: unvisited)

            return node
        }
    }

}

public extension PTTransition {

  // Equivalent de la fonction isFireable appliquée à un CoverabilityGraph
  public func isFireableCover(from marking: CoverabilityMarking) -> Bool{
    for arc in self.preconditions {
            switch marking[arc.place]! {
              // Cas ou la place contient un nombre entier de jetons
              case .some(let a):
              // si le nombre de jetons n'est pas suffisant alors pas franchissable
                if a < arc.tokens {
                    return false
                }
                break
              // Cas ou la place contient omega
              case .omega:
                // On ne fait rien
                break
              }
        }
        return true
  }

  // Equivalent de la fonction fire appliquée à un CoverabilityGraph
  public func fireCover(from marking: CoverabilityMarking) -> CoverabilityMarking? {
    guard self.isFireableCover(from: marking) else {
        return nil
    }

    var result = marking
        for arc in self.preconditions {
          switch result[arc.place]! {
            // Cas ou la place contient un nombre entier de jetons
            case .some(var a):
              // On décremente les tokens des preconditions
              a -= arc.tokens
              result[arc.place]! = .some(a)
              break
            // Cas ou la place contient omega
            case .omega:
              // On ne fait rien
              // En effet w - x = w pour x entier
              break
            }
        }
        for arc in self.postconditions {
          switch result[arc.place]! {
            case .some(var a):
              // On incrémente les tokens des postconditions
              a += arc.tokens
              result[arc.place]! = .some(a)
              break

            case .omega:
              // On ne fait rien
              // En effet w + x = w pour x entier
              break
            }
        }

    return result
  }
}
