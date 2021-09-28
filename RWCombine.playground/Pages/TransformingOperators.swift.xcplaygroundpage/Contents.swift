import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

// Operator categories
// Transforming
// Filtering

// MARK: - Collect
/// This example creates an array publisher, and then subscrbes to it. You can see it prints the array elements one by one.
example(of: "Non-Collect") {
  ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K"].publisher
    .sink {
      print($0)
    } receiveValue: {
      print($0)
    }
    .store(in: &subscriptions)
}

/// Collect operator takes a stream of individual values from a publisher and turns them into an array of values.
/// There's nothing here limiting the number of items the collect operator can work on, so be careful working with large data sets as this could cause memory issues.
/// If you want to limit the number of items that get collected you use something like "collect(2)" (In this example this will create several arrays of 2 items.) See below
/*
 ——— Example of: Collect ———
 ["A", "B"]
 ["C", "D"]
 ["E", "F"]
 ["G", "H"]
 ["I", "J"]
 ["K"]
 finished
 */
example(of: "Collect") {
  ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K"].publisher
    .collect(2)
    .sink {
      print($0)
    } receiveValue: {
      print($0)
    }
    .store(in: &subscriptions)
}

// MARK: - Map
/// Sometimes you'll want to transform the data from a pulisher in some way before sending it downstream to another publisher/ subscriber. For this we use Map.
/// In this example we are transforming the Int's coming accross the publisher into strings.
example(of: "Map") {
  let formatter = NumberFormatter()
  formatter.numberStyle = .spellOut
  
  [123, 4, 56].publisher
    .map {
      formatter.string(for: NSNumber(integerLiteral: $0)) ?? ""
    }
    .sink{ print($0) }
    .store(in: &subscriptions)
}

// MARK: - Replace Nil
/// What happens when you encounter a nil in your upstream values?
/// replaceNil(value) allows you to specify a default value when you encounter a nil in the set

example(of: "Replace Nil") {
  let test = ["A", nil, "B"].publisher
  
  ["A", nil, "B"].publisher
    .replaceNil(with: "-")
    .map { $0! } // We know we are replacing any nil values so we can map this optional to string before the subscription.
    .sink { print($0) }
    .store(in: &subscriptions)
}

// MARK: - Replace Empty
/// Replace empty inserts a value if the publisher ends up completing without emitting any values.

example(of: "Replace Empty") {
  let empty = Empty<Int, Never>()
  
  empty
    .replaceEmpty(with: 1)
    .sink { print($0) }
    .store(in: &subscriptions)
}

