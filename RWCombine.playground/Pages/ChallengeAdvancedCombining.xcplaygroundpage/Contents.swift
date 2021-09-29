import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "Making Phone Numbers Part 2") {

  let phoneNumbersPublisher = ["123-4567", "555-1212", "555-1111", "123-6789"].publisher
  let areaCodePublisher = ["410", "757", "800", "540"].publisher
  let phoneExtensionPublisher = ["EXT 901", "EXT 523", "EXT 137", "EXT 100"].publisher
  
  areaCodePublisher
    .zip(phoneNumbersPublisher)
    .map { areaCode, number in
      "\(areaCode)-\(number)"
    }
    .zip(phoneExtensionPublisher)
    .map { areaNumber, ext in
      "\(areaNumber) \(ext)"
    }
    .sink { completion in
      print("Completed with: \(completion)")
    } receiveValue: { value in
      print(value)
    }
    .store(in: &subscriptions)

  
}
