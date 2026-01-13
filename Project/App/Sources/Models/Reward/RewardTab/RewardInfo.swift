//
//  RewardInfo.swift
//  Flifin
//
//  Created by hyerin on 1/11/26.
//

import Foundation

struct RewardInfo: Equatable {
  let currentPoints: Int
  let currentLevel: LevelInfo
  let levelInfo: [LevelInfo]
  let receivedRewards: [RewardItem]
  
  init(
    currentPoints: Int,
    currentLevel: LevelInfo,
    levelInfo: [LevelInfo],
    receivedRewards: [RewardItem]
  ) {
    self.currentPoints = currentPoints
    self.currentLevel = currentLevel
    self.levelInfo = levelInfo
    self.receivedRewards = receivedRewards
  }
  
  // MARK: - Computed Properties
  
  var currentLevelInfo: LevelInfo {
    levelInfo.first(where: { $0.level == currentLevel.level }) ?? levelInfo[0]
  }
  
  var nextLevelInfo: LevelInfo? {
    guard let currentIndex = levelInfo.firstIndex(where: { $0.level == currentLevel.level }),
          currentIndex + 1 < levelInfo.count else {
      return nil
    }
    return levelInfo[currentIndex + 1]
  }
  
  var pointsToNextLevel: Int {
    guard let nextLevel = nextLevelInfo else { return 0 }
    return nextLevel.threshold - currentPoints
  }
  
  var progress: Double {
    guard let nextLevel = nextLevelInfo else { return 1.0 }
    let currentThreshold = currentLevelInfo.threshold
    let nextThreshold = nextLevel.threshold
    let range = Double(nextThreshold - currentThreshold)
    guard range > 0 else { return 1.0 }
    let currentProgress = Double(currentPoints - currentThreshold)
    return min(max(currentProgress / range, 0), 1.0)
  }
}

// MARK: - Default Data

extension RewardInfo {
  static let initial = RewardInfo(
    currentPoints: 100,
    currentLevel: .init(
      level: 1,
      name: "새싹 복주머니",
      threshold: 0
    ),
    levelInfo: [
      .init(level: 1, name: "새싹 복주머니", threshold: 0),
      .init(level: 2, name: "싹트는 복주머니", threshold: 100),
      .init(level: 3, name: "자라는 복주머니", threshold: 200),
      .init(level: 4, name: "성장 복주머니", threshold: 300),
      .init(level: 5, name: "무럭무럭 복주머니", threshold: 400),
      .init(level: 6, name: "튼튼한 복주머니", threshold: 500),
      .init(level: 7, name: "풍성한 복주머니", threshold: 600),
      .init(level: 8, name: "풍요 복주머니", threshold: 700),
    ],
    receivedRewards: [
      .init(
        title: "1년 운세",
        iconURL: URL(string: "https://www.freepnglogos.com/uploads/apple-logo-png/apple-logo-png-dallas-shootings-don-add-are-speech-zones-used-4.png"),
        message: "복주머니 lv. 10 달성시 열람 가능해요!"
      ),
      .init(
        title: "전반적 사주",
        iconURL: URL(string: "https://www.freepnglogos.com/uploads/apple-logo-png/apple-logo-png-dallas-shootings-don-add-are-speech-zones-used-4.png"),
        message: "복주머니 lv. 10 달성시 열람 가능해요!"
      ),
      .init(
        title: "복합 사주",
        iconURL: URL(string: "https://www.freepnglogos.com/uploads/apple-logo-png/apple-logo-png-dallas-shootings-don-add-are-speech-zones-used-4.png"),
        message: nil
      )
    ]
  )
}

