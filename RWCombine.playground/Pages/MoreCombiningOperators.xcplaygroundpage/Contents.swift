import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

//MARK: - Switch To Latest
/// Allows you to switch publishers
/// Switching cancels the previous publisher (any further attempts to send values to that publisher are ignored)
/// Can only be used on publisher that emit publishers

example(of: "switchToLatest") {
  let publisher1 = PassthroughSubject<Int, Never>()
  let publisher2 = PassthroughSubject<Int, Never>()
  let publisher3 = PassthroughSubject<Int, Never>()
  
  let publishers = PassthroughSubject<PassthroughSubject<Int, Never>, Never>()
  
  publishers
    .print()
    .switchToLatest()
    .sink { completion in
      print("completed with: \(completion)")
    } receiveValue: { value in
      print(value)
    }
    .store(in: &subscriptions)
  
  publishers.send(publisher1)
  publisher1.send(1)
  publisher1.send(2)
  // Switch publisher 2
  publishers.send(publisher2)
  publisher1.send(3) // Does publisher1 still emit? No
  publisher2.send(4)
  publisher2.send(5)
  // Switch to publisher 3
  publishers.send(publisher3)
  publisher2.send(6)
  publisher3.send(7)
  publisher3.send(8)
  publisher3.send(9)
  // Completions for remaining publishers
  publisher3.send(completion: .finished)
  publishers.send(completion: .finished)
}

//MARK: - Merge(with:)
/// Preserves published order
/// Interleaves emissions from different publishers of the same type
/// publisher 1 = [1,2,4] publisher2 = [3, 5].
/// result = [1,2,3,4,5]

example(of: "merge(with:)") {
  let publisher1 = PassthroughSubject<Int, Never>()
  let publisher2 = PassthroughSubject<Int, Never>()
  
  publisher1
    .print()
    .merge(with: publisher2)
    .sink { completion in
      print("completed with: \(completion)")
    } receiveValue: { value in
      print(value)
    }
    .store(in: &subscriptions)
  publisher1.send(1)
  publisher2.send(2)
  publisher1.send(3)
  publisher2.send(4)
  publisher1.send(5)
  publisher1.send(completion: .finished)
  publisher2.send(completion: .finished)
  
}

//MARK: - Combine Latest
/// Forms a tuple of the latest values from each publishers
/// Can be of different types
/// Each publisher must have emitted one value before tuples are made
/// The first publisher could have emitted several values before it starts combining with the next publishers. the values are not indexed start to end like zip()
example(of: "combineLatest()") {
  let publisher1 = PassthroughSubject<Int, Never>()
  let publisher2 = PassthroughSubject<String, Never>()
  
  publisher1
    .combineLatest(publisher2)
    .sink { completion in
      print("Completed with: \(completion)")
    } receiveValue: { a, b in
      print("a: \(a), b: \(b)")
    }
    .store(in: &subscriptions)

  publisher1.send(1)
  publisher1.send(2)
  publisher2.send("a")
  publisher2.send("b")
  publisher1.send(3)
  publisher2.send("c")
  publisher1.send(completion: .finished)
  publisher2.send(completion: .finished)
  // a: 2, b: a
  // a: 2, b: b
  // publisher1's latest value is 2 by the time publisher 2 emits "a". It's still 2 when publisher2 emits b, hence you get "a: 2" for both values.
}

// MARK: - Zip
/// Emits tuples like combine latest
/// Forms the tuples of the same index across all publishers
example(of: "zip()") {
  let publisher1 = PassthroughSubject<Int, Never>()
  let publisher2 = PassthroughSubject<String, Never>()
  
  publisher1
    .zip(publisher2)
    .sink { completion in
      print("Completed with: \(completion)")
    } receiveValue: { a, b in
      print("a: \(a), b: \(b)")
    }
    .store(in: &subscriptions)
  
  publisher1.send(1)
  publisher1.send(2)
  publisher2.send("a")
  publisher2.send("b")
  publisher1.send(3)
  publisher2.send("c")
  publisher2.send("d") // This value is not added to the zip as there is no corresponding index member for publisher1. Orphan values in tuples will be ommitted.
  publisher1.send(completion: .finished)
  publisher2.send(completion: .finished)
  
  // a: 1, b: a
  // a: 2, b: b
  // a: 3, b: c
  // has a "collection" effect where it breaks it down into indexed pairs from the publishers whereas combine latest will spit out a tuple for every publisher emit.
}
