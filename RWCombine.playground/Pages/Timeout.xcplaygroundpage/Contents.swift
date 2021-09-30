import Foundation
import Combine
import SwiftUI
import PlaygroundSupport

// MARK: - Timeout
/// timeout causes a publisher to complete if values are not received within a specific interval
/// Can also emit an error upon timeout.

let subject = PassthroughSubject<Void, TimeoutError>()

let timedOutSubject = subject
  .timeout(
    .seconds(5),
    scheduler: DispatchQueue.main,
    customError: { .timedOut }
  )

let timeline = TimelineView(title: "Button taps")

let view = VStack(spacing: 50) {
  Button(action: { subject.send() }) {
    timeline
  }
}.frame(width: 300, height: 300 )

PlaygroundPage.current.liveView = UIHostingController(rootView: view)

timedOutSubject.displayEvents(in: timeline)

enum TimeoutError: Error {
  case timedOut
}
