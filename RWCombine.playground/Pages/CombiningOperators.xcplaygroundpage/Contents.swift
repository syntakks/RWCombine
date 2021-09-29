import Foundation
import Combine

// Combining Operators
// Prepending
// Appending
// Advanced Combining

var subscriptions = Set<AnyCancellable>()

//MARK: - Prepend
/// prepend(output) works on a variadic list of values and prepends that list onto the original publisher.
/// variadic meaning 3 periods in a row

example(of: "prepend(Output)") {
  let publisher = [3, 4].publisher
  
  publisher
    .prepend(1, 2)
    .prepend(-1, 0)
    .sink { print($0) }
    .store(in: &subscriptions)
}

example(of: "prepend(Sequence)") {
  let publisher = [5, 6, 7].publisher
  
  publisher
    .prepend([3, 4])
    .prepend(Set(1...2))
    .prepend(stride(from: 6, through: 11, by: 2))
    .sink { print($0) }
    .store(in: &subscriptions)
}

example(of: "prepend(Publisher)") {
  let publisher1 = [3, 4].publisher
  let publisher2 = [1, 2].publisher
  
  publisher1
    .prepend(publisher2)
    .sink { print($0) }
    .store(in: &subscriptions)
}

example(of: "prepend(Publisher) Passthrough Subject") {
  let publisher1 = [3, 4].publisher
  let publisher2 = PassthroughSubject<Int, Never>()
  
  publisher1
    .prepend(publisher2)
    .sink { print($0) }
    .store(in: &subscriptions)
  
  publisher2.send(1)
  publisher2.send(2)
  publisher2.send(completion: .finished) // Without this completion, the original publisher values won't be combined.
}

//MARK: - Append
/// This works oppposite of prepend, putting the values at the end of the original publisher
/// append(Output...) works on a variadc list of values and appends that list onto the "end" of the original publisher.
example(of: "append") {
  let publisher = [1].publisher
  
  publisher
    .append(2, 3)
    .append(4)
    .sink { print($0) }
    .store(in: &subscriptions)
}

example(of: "append(passthroughSubject)") {
  let publisher = PassthroughSubject<Int, Never>()
  
  publisher
    .append(3, 4)
    .append(5)
    .sink { print($0) }
    .store(in: &subscriptions)
  
  publisher.send(1)
  publisher.send(2)
  publisher.send(completion: .finished) // Without this finish the append does not complete.
}

example(of: "append(Sequence)") {
  let publisher = [1, 2, 3].publisher
  
  publisher
    .append([4, 5])
    .append(Set([6, 7]))
    .append(stride(from: 8, to: 11, by: 2))
    .sink { print($0) }
    .store(in: &subscriptions)
}

example(of: "append(Publisher)") {
  let publisher1 = [1, 2].publisher
  let publisher2 = [3, 4].publisher
  
  publisher1
    .append(publisher2)
    .sink { completion in
      print("Completed with \(completion)")
    } receiveValue: { value in
      print(value)
    }

}
