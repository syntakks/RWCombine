import Foundation
import Combine
var subscriptions = Set<AnyCancellable>()

// MARK: - Scan
/// Scan allows you to build on previous results from the operator
/// Both incoming values from the publisher and the previous value from the operator (if it exists) get passed into the operator.
example(of: "Scan") {
  var dailyGainLoss: Int { .random(in: -10...10) }
  
  let august2019 = (0..<22)
    .map { _ in
      dailyGainLoss
    }
    .publisher
  
  august2019
    .scan(50) { latest, current in
      max(0, latest + current)
    }
    .sink(receiveValue: { _ in })
    .store(in: &subscriptions)
  
  let august2020 = (0..<22)
    .map { _ in
      dailyGainLoss
    }
    .publisher
  // I'm collecting the results and printing them here in the subscription.
  august2020
    .scan(50) { latest, current in
      max(0, latest + current)
    }
    .collect()
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
}
// MARK: - Flat Map
/// Flat map allows you to take output from more tha one publisher and combine them into a downstream publisher.
/// The incoming and outgoing value types are usually not the same.
/// Common case for flat map in combine is to subscribe to properties of values emitted by a publisher that are themselves publishers.
example(of: "Flat Map") {
  let charlotte = Chatter(name: "Charlott", message: "Hi, I'm Charlotte")
  let james = Chatter(name: "James", message: "Hi I'm James!")
  
  let chat = CurrentValueSubject<Chatter, Never>(charlotte)
  
  chat
    .flatMap { $0.message } // This flattens it down to the message publisher inside of the Chatter struct. Publishers are combined, into one!
    .sink { print($0) }
    .store(in: &subscriptions)
  
  charlotte.message.value = "Charlotte: How's it going?"
  chat.value = james
  
  james.message.value = "James: Doing great. You?"
  charlotte.message.value = "Charlotte: I'm doing fine, thanks"
  
}
