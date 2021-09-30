import Foundation
import Combine
import SwiftUI
import PlaygroundSupport

// Timing Operators - Control when values are sent downstream
// Scheduling Operators - Schedule which thread or queue those values are delivered
// Sequence Operators - work on collections of values, much like their counterparts in the Swift Standard Library.

//MARK: - Delay
/// The delay operator delays the values emitted by the publisher for a given duration, and then sends them to the consumer as an array of values.
/// Can be run on a given Scheduler


let valuesPerSecond = 1.0
let delayInSeconds = 1.5

let sourcePubliser = PassthroughSubject<Date, Never>()

let delayedPubliser = sourcePubliser
  .delay(for: .seconds(delayInSeconds), scheduler: DispatchQueue.main)

let subscription = Timer
  .publish(every: 1.0 / valuesPerSecond, on: .main, in: .common)
  .autoconnect()
  .subscribe(sourcePubliser)

let sourceTimeline = TimelineView(title: "Emitted values \(valuesPerSecond) per sec:")

let delayedTimeline = TimelineView(title: "Delayed values (with a \(delayInSeconds)s delay):")

let view = VStack(spacing: 50) {
  sourceTimeline
  delayedTimeline
}

PlaygroundPage.current.liveView = UIHostingController(rootView: view)

sourcePubliser.displayEvents(in: sourceTimeline)
delayedPubliser.displayEvents(in: delayedTimeline)
