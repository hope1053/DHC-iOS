//
//  MissionTimerClient.swift
//  Flifin
//
//  Created by hyerin on 12/10/25.
//

import Foundation

import ComposableArchitecture

@DependencyClient
struct MissionTimerClient: Sendable {
  var timerStream: @Sendable () -> AsyncStream<Int> = { .finished }
}

extension MissionTimerClient: DependencyKey {
  static var liveValue: MissionTimerClient = {
    @Dependency(\.continuousClock) var clock
    
    return MissionTimerClient(
      timerStream: {
        AsyncStream { continuation in
          let task = Task {
            let now = Date()
            let calendar = Calendar.current
            guard let midnight = calendar.nextDate(
              after: now,
              matching: DateComponents(hour: 0, minute: 0, second: 0),
              matchingPolicy: .nextTime
            ) else {
              continuation.finish()
              return
            }
            
            var remaining = Int(midnight.timeIntervalSince(now))
            continuation.yield(remaining)
            
            for await _ in clock.timer(interval: .seconds(1)) {
              remaining -= 1
              if remaining <= 0 {
                continuation.yield(0)
                continuation.finish()
                break
              }
              continuation.yield(remaining)
            }
          }
          
          continuation.onTermination = { _ in
            task.cancel()
          }
        }
      }
    )
  }()
  
  static let previewValue = MissionTimerClient(
    timerStream: {
      AsyncStream { continuation in
        var remaining = 3600
        continuation.yield(remaining)
        
        Task {
          while remaining > 0 {
            try? await Task.sleep(for: .seconds(1))
            remaining -= 1
            continuation.yield(remaining)
          }
          continuation.finish()
        }
      }
    }
  )
  
  static let testValue = Self()
}

extension DependencyValues {
  var missionTimerClient: MissionTimerClient {
    get { self[MissionTimerClient.self] }
    set { self[MissionTimerClient.self] = newValue }
  }
}

