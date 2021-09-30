import Foundation
import Combine
import PlaygroundSupport
import SwiftUI

//MARK: - Debounce
/// debounce() waits for a given amount of time and then emits the last value emitted by the publisher.
/// Useful to detect when a user pauses typing.

let subject = PassthroughSubject<String, Never>()

let debounced = subject
  .debounce(for: .seconds(1.0), scheduler: DispatchQueue.main)
  .share()
// Since you're going to subscribe multiple times to debounce, and you want it to be consistant. You share to create a single subscription point to debounce that will show the samre results at the same time to all subscribers.

let subjectTimeline = TimelineView(title: "Emitted values")
let debouncedTimeline = TimelineView(title: "Debounced values")

let view = VStack(spacing: 50) {
  subjectTimeline
  debouncedTimeline
}

PlaygroundPage.current.liveView = UIHostingController(rootView: view)

subject.displayEvents(in: subjectTimeline)
debounced.displayEvents(in: debouncedTimeline)

let subscription1 = subject
  .sink { string in
    print("+\(deltaTime)s: Subject emitted: \(string)")
  }

let subscription2 = debounced
  .sink { string in
    print("+\(deltaTime)s: Debounced emitted: \(string)")
  }

subject.feed(with: typingHelloWorld)



