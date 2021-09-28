import Foundation
import Combine

// Receive a string of 10 telephone numbers or letters
// Lookup those numbers in a contacts data structure.
// Create a subscriber to the provided input publisher and use the functions and transforming operators to do the following:
  //  Convert the input to numbers, handle nil cases, replacing with zero
  //  collect 10 values at a time, 3 digit area code and 7 numbers as in US number < format the collected string
  //  dial the input received from the previous operator using the dial function.
  //  Dont Forget: Closures and functions can be passed in to operators as long as their function signatures line up.
var subscriptions = Set<AnyCancellable>()

example(of: "Create a phone number lookup") {
  let contacts = [
    "603-555-1234": "Florent",
    "408-555-4321": "Marin",
    "217-555-1212": "Scott",
    "212-555-3434": "Shai"
  ]

  func convert(phoneNumber: String) -> Int? {
    if let number = Int(phoneNumber),
      number < 10 {
      return number
    }

    let keyMap: [String: Int] = [
      "abc": 2, "def": 3, "ghi": 4,
      "jkl": 5, "mno": 6, "pqrs": 7,
      "tuv": 8, "wxyz": 9
    ]

    let converted = keyMap
      .filter { $0.key.contains(phoneNumber.lowercased()) }
      .map { $0.value }
      .first

    return converted
  }

  func format(digits: [Int]) -> String {
    var phone = digits.map(String.init)
                      .joined()

    phone.insert("-", at: phone.index(
      phone.startIndex,
      offsetBy: 3)
    )

    phone.insert("-", at: phone.index(
      phone.startIndex,
      offsetBy: 7)
    )

    return phone
  }
  
  func dial(phoneNumber: String) -> String {
    guard let contact = contacts[phoneNumber] else {
      return "Contact not found for \(phoneNumber)"
    }

    return "Dialing \(contact) (\(phoneNumber))..."
  }
  
  // Convert the input of the stream 1 character at a time, this can be done with Map Operator
  let input = PassthroughSubject<String, Never>()
  input
  // We have a string, now mapping to an optional int before we can replace nil on it.
    .map(convert)
    .replaceNil(with: 0)
  // Collect 10 of these numbers to make up the phone number
    .collect(10)
  // Now we can map over this non optional [Int] and format it to look like a phone number
    .map(format)
  // Finally... we can map over this string to the dial function (String -> String), this will try to call a contact
    .map(dial)
    .sink { print($0) }
  
  "1234567891".forEach {
    input.send(String($0))
  }
  
  "0!1234567".forEach {
    input.send(String($0))
  }
  
  "A1BJKLDGEH".forEach {
    input.send(String($0))
  }
  
}
