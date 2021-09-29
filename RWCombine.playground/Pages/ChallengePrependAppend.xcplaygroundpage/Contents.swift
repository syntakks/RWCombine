// Challenge: Prepend & Append

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

// Take the 7 digit phone number emitted by the publisher and turn it into a phone number of the form:
// 1-<areaCode>-<phoneNumber>-ext<phoneExtension>

example(of: "Making Phone Numbers") {
  
  let phoneNumbersPublisher = ["123-4567"].publisher
  let areaCode = "410"
  let phoneExtension = "901"
  
  phoneNumbersPublisher
    //.print()
    .prepend("1-\(areaCode)-")
    .append(" ext \(phoneExtension)")
    .collect()
    .sink { completion in
      //print("Completed with \(completion)")
    } receiveValue: { phoneNumber in
      print(phoneNumber.joined())
    }

  
}
