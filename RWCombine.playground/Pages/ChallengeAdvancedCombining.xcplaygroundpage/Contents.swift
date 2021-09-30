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

example(of: "1 map test") {

  let areaCodePublisher = ["410", "757", "800", "540"].publisher
  let phoneNumbersPublisher = ["123-4567", "555-1212", "555-1111", "123-6789"].publisher
  let phoneExtensionPublisher = ["EXT 901", "EXT 523", "EXT 137", "EXT 100"].publisher
  
  areaCodePublisher
    .zip(phoneNumbersPublisher)
    .zip(phoneExtensionPublisher)
    .map { areaNumber, ext in
      "1-\(areaNumber.0)-\(areaNumber.1) \(ext)"
    }
    .sink { completion in
      print("Completed with: \(completion)")
    } receiveValue: { value in
      print(value)
    }
    .store(in: &subscriptions)
}

example(of: "Zip3") {
  let areaCodePublisher = ["410", "757", "800", "540"].publisher
  let phoneNumbersPublisher = ["123-4567", "555-1212", "555-1111", "123-6789"].publisher
  let phoneExtensionPublisher = ["EXT 901", "EXT 523", "EXT 137", "EXT 100"].publisher
  
  Publishers.Zip3(areaCodePublisher, phoneNumbersPublisher, phoneExtensionPublisher)
    .sink { completion in
      print("Completed with: \(completion)")
    } receiveValue: { areaCode, phoneNumber, ext in
      print("1-\(areaCode)-\(phoneNumber) \(ext)")
    }
    .store(in: &subscriptions)

}
