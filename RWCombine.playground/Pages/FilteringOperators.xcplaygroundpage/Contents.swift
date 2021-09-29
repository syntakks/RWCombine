import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

/// Filtering operators consume values from a publisher, and conditionally decide wheather to passs them downastream to the consumer.
/// (filter, removeDuplicates, compactMap, and ignoreOutput)

// MARK: - Filter
/// Filter takes in a predicate to determine which values to pass on to the consumer.
/// Has a corresponding function in the Swift Standard Library

example(of: "Filter") {
  let numbers = (1...10).publisher
  
  numbers
    .filter { $0.isMultiple(of: 3)}
    .sink { number in
      print("\(number) is a multiple of 3!")
    }
}

// MARK: Remove Duplicates
/// Removes all duplicates, only passing along the first instance of a value from the publisher. Value must conform to Equatable.

example(of: "Remove Duplicates") {
  let words = "hey hey there! want to listen to mister mister?"
    .components(separatedBy: " ")
    .publisher
  
  words
    .removeDuplicates()
    .collect()
    .sink { print($0.joined(separator: " ")) }
    .store(in: &subscriptions)
}

// MARK: - Compact Map
/// Some publishers can emit optional values or even just return nils as the result, but what if you don't want those values?
/// compactMap() lets you ingore nil results from a map operation.
/// Has a correspoinding funciton in the swift library.

example(of: "Compact Map") {
  let strings = ["a", "1.24", "3", "def", "45", "0.23"]
    .publisher
  
  strings
    .compactMap { Float($0) }
    .sink { print($0) }
    .store(in: &subscriptions)
}

// MARK: - Ignore Output
/// There may be cases when you want to ignore all the values from a publisher only being concerned when the completion even is sent.
/// ignoreOutput() allows you to ignore all the output from a publisher, only being concerned when the completion event is sent.

example(of: "Ignore Output") {
  let numbers = (1...10_000).publisher
  
  numbers
    .ignoreOutput()
    .sink { completion in
      print("Completed with \(completion)")
    } receiveValue: { number in
      print(number) // None of these will print...
    }
    .store(in: &subscriptions)

}
