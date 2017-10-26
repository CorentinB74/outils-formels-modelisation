import PetriKit
import SmokersLib


// Instantiate the model.
let model = createModel()

// Retrieve places model.
guard let r  = model.places.first(where: { $0.name == "r" }),
      let p  = model.places.first(where: { $0.name == "p" }),
      let t  = model.places.first(where: { $0.name == "t" }),
      let m  = model.places.first(where: { $0.name == "m" }),
      let w1 = model.places.first(where: { $0.name == "w1" }),
      let s1 = model.places.first(where: { $0.name == "s1" }),
      let w2 = model.places.first(where: { $0.name == "w2" }),
      let s2 = model.places.first(where: { $0.name == "s2" }),
      let w3 = model.places.first(where: { $0.name == "w3" }),
      let s3 = model.places.first(where: { $0.name == "s3" })
else {
    fatalError("invalid model")
}



// Create the initial marking.
let initialMarking: PTMarking = [r: 1, p: 0, t: 0, m: 0, w1: 1, s1: 0, w2: 1, s2: 0, w3: 1, s3: 0]

// Fonctions Exercice 4
// Fonction permettant de compter les nodes
func cntNodes(markingGraph : MarkingGraph) -> Int {

  var seen = [markingGraph]
  var toVisit = [markingGraph]

  while let current = toVisit.popLast(){
    for (_, successor) in current.successors {
      if !seen.contains(where: { $0 === successor}){
        seen.append(successor)
        toVisit.append(successor)
      }
    }
  }
  return seen.count
}

// Fonction testant si il y a deux smokers en même temps et deux ingredient
// return true si oui
func testNodes(markingGraph : MarkingGraph) -> (Bool, Bool){
// PTMarking = [PTPlace: UInt]
  var seen = [markingGraph]
  var toVisit = [markingGraph]

  var flag_testSmokers = false
  var flag_testIngredients = false
  var res = (Smokers : false, Ingredients : false)

  while let current = toVisit.popLast() {
    for (_, successor) in current.successors {
      if !seen.contains(where: { $0 === successor }){
        seen.append(successor)
        toVisit.append(successor)
        var flag_s1 = false
        var flag_s2 = false
        var flag_s3 = false

        var flag_i1 = false
        var flag_i2 = false
        var flag_i3 = false
        for (Key, Value) in current.marking{
          if !flag_testSmokers{
            if(!flag_s1){
              flag_s1 = (Key == s1, Value == 1) == (true, true) ? true : false
            }
            if(!flag_s2){
              flag_s2 = (Key == s2, Value == 1) == (true, true) ? true : false
            }
            if(!flag_s3){
              flag_s3 = (Key == s3, Value == 1) == (true, true) ? true : false
            }
            if flag_s1 && flag_s2 || flag_s1 && flag_s3 || flag_s3 && flag_s2{
              res.Smokers = true
              flag_testSmokers = true
            }
          }

          if !flag_testIngredients{
            if(!flag_i1){
              flag_i1 = (Key == p, Value > 1) == (true, true) ? true : false
            }
            if(!flag_i2){
              flag_i2 = (Key == t, Value > 1) == (true, true) ? true : false
            }
            if(!flag_i3){
              flag_i3 = (Key == m, Value > 1) == (true, true) ? true : false
            }
            if flag_i1 && flag_i2 || flag_i1 && flag_i3 || flag_i3 && flag_i2{
              res.Ingredients = true
              flag_testIngredients = true
            }
          }

        }
      }
    }
  }

  return res
}

// Create the marking graph (if possible).
if let markingGraph = model.markingGraph(from: initialMarking) {

  // 1) Count Nodes
  print("Le graph contient :", cntNodes(markingGraph: markingGraph), "nodes")

  // 2)
  print(testNodes(markingGraph: markingGraph).0 ? "Le graph contient a un moment deux smokers en même temps" : "Le graph ne contient jamais deux smokers en meme temps")

  // 3)
  print(testNodes(markingGraph: markingGraph).1 ? "Le graph contient a un moment plus de 2 ingredients" : "Le graph ne contient jamais plus de 2 ingredients")

}
