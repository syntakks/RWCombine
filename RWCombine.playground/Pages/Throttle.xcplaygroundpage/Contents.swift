import Foundation
import Combine
import PlaygroundSupport
import SwiftUI

//MARK: - Throttle
/// Throttle is similar to debounce
/// Can emit either first or last value from the publisher.
/// You can delay for a certain amount of time, you can also emit values to a particular scheduler. You can decide to emit lastest value.

let throttleDelay = 1.0

let subject = PassthroughSubject<String, Never>()

let throttled = subject
  .throttle(for: .seconds(throttleDelay), scheduler: DispatchQueue.main, latest: true)
  .share() // Guarantees all subscribers see the same output at the same time from the throttled subject

let subjectTimeline = TimelineView(title: "Emitted values")
let throttledTimeline = TimelineView(title: "Throttled Values")

let view = VStack(spacing: 50) {
  subjectTimeline
  throttledTimeline
}

PlaygroundPage.current.liveView = UIHostingController(rootView: view)

subject.displayEvents(in: subjectTimeline)
throttled.displayEvents(in: throttledTimeline)

let subscription1 = subject
  .sink { string in
    print("+\(deltaTime)s: Subject emitted: \(string)")
  }

let subscription2 = throttled
  .sink { string in
    print("+\(deltaTime)s: Throttle emitted: \(string)")
  }

subject.feed(with: typingHelloWorld)

