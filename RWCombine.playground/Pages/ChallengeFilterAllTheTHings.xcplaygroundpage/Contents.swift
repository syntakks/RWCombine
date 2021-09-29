import Foundation
import Combine

let numbers = (1...100).publisher

// Skip the first 50 values
// take next 20 values
// only take even numbers

numbers
  .dropFirst(50)
  .prefix(20)
  .filter { $0 % 2 == 0 }
  .sink { completion in
    print("Completed with: \(completion)")
  } receiveValue: { number in
    print(number)
  }
