import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

//MARK: - First
/// first() returns the first value form the publisher that causes the predicate to return true
/// first() is a lazy operator, it only takes as many values as needed before canceling the subscription and completing.

example(of: "first(where:)") {
  let numbers = (1...9).publisher
  
  numbers
    .print()
    .first(where: { $0 % 2 == 0} )
    .sink { completion in
      print("Completed with \(completion)")
    } receiveValue: { number in
      print("\(number)")
    }
    .store(in: &subscriptions)
}

// MARK: - Last
/// last() returns the last value from the publisher that cuases the prediate to return true.
/// last() is GREEDY, it has to take all of the values from the publisher before it can determine whether ithe last value has been found.

example(of: "last(where:)") {
  let numbers = (1...9).publisher
  
  numbers
    .last(where: { $0 % 2 == 0} )
    .sink { completion in
      print("Completed with \(completion)")
    } receiveValue: { number in
      print(number)
    }
    .store(in: &subscriptions)
}

example(of: "last(where:) PassthroughSubject") {
  let numbers = PassthroughSubject<Int, Never>()
  
  numbers
    .last(where: { $0 % 2 == 0} )
    .sink { completion in
      print("Completed with \(completion)")
    } receiveValue: { number in
      print(number)
    }
    .store(in: &subscriptions)
  
  numbers.send(1)
  numbers.send(2)
  numbers.send(3)
  numbers.send(4)
  numbers.send(5)
  numbers.send(completion: .finished)
}

// MARK: - Prefix
/// prefix() allows you to speciry a number of values to receive before cancelling the subscription and completing.
/// As with first(), prefix is also a lazy operator.
///  Other operators in this family: prefix(while:) and prefix(untilOutputFrom: isReady)

example(of: "prefix()") {
  let numbers = (1...10).publisher
  
  numbers
    .prefix(2)
    .sink { completion in
      print("Completed with: \(completion)")
    } receiveValue: { value in
      print(value)
    }
    .store(in: &subscriptions)

}

// MARK: - Drop
/// dro() allows you to ignore values from the publisher until a condition specified by a predicate is met
/// Other operators in this family: dropFirst() and drop(untilOutputFrom:isReady)
example(of: "Drop") {
  let numbers = (1...10).publisher
  
  numbers
    .drop(while: { $0 % 5 != 0 }) // Drops all values until we hit first value divisible by 5, so 1-4 are dropped.
    .sink { print($0) }
    .store(in: &subscriptions)
}
