import Foundation
import Combine
import SwiftUI
import PlaygroundSupport

//MARK: - Collect (By Time)
/// There may be cases where you want to collect values of a period of time before you performing an operation
/// collect(byTime:) collects values emitted by the publishers at specified intervals.
/// Useful for operations like averages.

let valuesPerSecond = 1.0
let collectTimeStride = 4

let sourcePublisher = PassthroughSubject<Date, Never>()

let collectedPublisher = sourcePublisher
  .collect(.byTime(DispatchQueue.main, .seconds(collectTimeStride)))
  .flatMap { dates in dates.publisher }

let subscription = Timer
  .publish(every: 1.0 / valuesPerSecond, on: .main, in: .common)
  .autoconnect()
  .subscribe(sourcePublisher)

let sourceTimeline = TimelineView(title: "Emitted values:")
let collectedTimeline = TimelineView(title: "Collected values (every \(collectTimeStride)s):")

let view = VStack(spacing: 50) {
  sourceTimeline
  collectedTimeline
}
  .frame(height: 400)

PlaygroundPage.current.liveView = UIHostingController(rootView: view)

sourcePublisher.displayEvents(in: sourceTimeline)
collectedPublisher.displayEvents(in: collectedTimeline)
