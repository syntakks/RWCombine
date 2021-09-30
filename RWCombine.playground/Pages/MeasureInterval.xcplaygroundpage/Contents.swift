import Foundation
import Combine
import PlaygroundSupport
import SwiftUI

//MARK: - Measure Interval
/// measureInterval measures the interval between emitted values for a give publisher.

let subject = PassthroughSubject<String, Never>()

let measureSubject = subject
  .measureInterval(using: DispatchQueue.main)

let subjectTimeline = TimelineView(title: "Emitted values:")
let measureTimeline = TimelineView(title: "Measured values")

let view = VStack(spacing: 50) {
  subjectTimeline
  measureTimeline
}//.frame(width: 300, height: 300)

PlaygroundPage.current.liveView = UIHostingController(rootView: view)

subject.displayEvents(in: subjectTimeline)
measureSubject.displayEvents(in: measureTimeline)

let subscription1 = subject
  .sink {
    print("+\(deltaTime)s: Subject emitted: \($0)")
  }

let subscription2 = measureSubject
  .sink {
    let time = Double($0.magnitude) / 1_000_000_000.0
    print("+\(deltaTime)s: Measure emitted: \(time)")
  }

subject.feed(with: typingHelloWorld)
