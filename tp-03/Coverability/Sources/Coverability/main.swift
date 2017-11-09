import PetriKit
import CoverabilityLib

// This file contains the code that will be executed if you run your program from the terminal. You
// don't have to write anything in this file, but you may use it to debug your code. You can create
// instances of the provided models as the following:
//
let model          = createBoundedModel()
let unboundedModel = createUnboundedModel()

// UnboundedMoel
do{
  let s0 = unboundedModel.places.first{$0.name == "s0"}!
  let s1 = unboundedModel.places.first{$0.name == "s1"}!
  let s2 = unboundedModel.places.first{$0.name == "s2"}!
  let s3 = unboundedModel.places.first{$0.name == "s3"}!
  let s4 = unboundedModel.places.first{$0.name == "s4"}!
  let b = unboundedModel.places.first{$0.name == "b"}!

  let CoverUnboundedModel : CoverabilityGraph = unboundedModel.coverabilityGraph(from: [s0 : 1, s1 : 0, s2 : 1, s3 : 0, s4 : 1, b : 0])
  CoverUnboundedModel.show()
  print("Size unboundedModel:", CoverUnboundedModel.count)
}


// BoundedModel
do{
  let r  = model.places.first(where: { $0.name == "r" })!
  let p  = model.places.first(where: { $0.name == "p" })!
  let t  = model.places.first(where: { $0.name == "t" })!
  let m  = model.places.first(where: { $0.name == "m" })!
  let w1 = model.places.first(where: { $0.name == "w1" })!
  let s1 = model.places.first(where: { $0.name == "s1" })!
  let w2 = model.places.first(where: { $0.name == "w2" })!
  let s2 = model.places.first(where: { $0.name == "s2" })!
  let w3 = model.places.first(where: { $0.name == "w3" })!
  let s3 = model.places.first(where: { $0.name == "s3" })!

  let CoverBoundedModel : CoverabilityGraph = model.coverabilityGraph(from : [r: 1, p: 0, t: 0, m: 0, w1: 1, s1: 0, w2: 1, s2: 0, w3: 1, s3: 0])
  //CoverBoundedModel.show()
  print("Size BoundedModel:", CoverBoundedModel.count)

}



//
// You **are** encouraged to write tests of your own!
// You may write as many tests as you want here, or even better in `CoverabilityLibTests.swift`.
// Observe how the two existing tests are implemented to write your own.
