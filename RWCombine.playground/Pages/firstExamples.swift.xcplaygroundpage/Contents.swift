import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "Just") {
  let just = Just("Hello world!")
  
  just
    .sink(
      receiveCompletion: {
        print("Received completion", $0)
      },
      receiveValue: {
        print("Received value", $0)
      })
    .store(in: &subscriptions)
}

example(of: "assign(to:on:)") {
  class SomeObject {
    var value: String = "" {
      didSet {
        print(value)
      }
    }
  }
  
  let object = SomeObject()
  
  ["Hello", "world!"].publisher
    .assign(to: \.value, on: object)
    .store(in: &subscriptions)
}

example(of: "PassthroughSubject") {
  let subject = PassthroughSubject<String, Never>()
  
  subject
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
  
  subject.send("Hello")
  subject.send("World")
  
  subject.send(completion: .finished)
  subject.send("Still there?")
}

example(of: "CurrentValueSubject") {
  let subject = CurrentValueSubject<Int, Never>(0)
  
  subject
    .print()
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
  
  print(subject.value)
  
  subject.send(1)
  subject.send(2)
  
  print(subject.value)
  
  subject.send(completion: .finished)
}

example(of: "Type erasure") {
  let subject = PassthroughSubject<Int, Never>()
  
  let publisher = subject.eraseToAnyPublisher()
  
  //  publisher.send(0)
  
  publisher
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
  
  subject.send(1)
}
