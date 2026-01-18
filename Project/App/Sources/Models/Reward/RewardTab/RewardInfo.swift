//
//  RewardInfo.swift
//  Flifin
//
//  Created by hyerin on 1/11/26.
//

import Foundation

struct RewardInfo: Equatable {
  let userProgressInfo: UserProgressInfo
  let totalLevel: Int
  let receivedRewards: [RewardItem]
  
  init(
    userProgressInfo: UserProgressInfo,
    totalLevel: Int = 8,
    receivedRewards: [RewardItem]
  ) {
    self.userProgressInfo = userProgressInfo
    self.totalLevel = totalLevel
    self.receivedRewards = receivedRewards
  }
}

// MARK: - Default Data

extension RewardInfo {
  static let initial = RewardInfo(
    userProgressInfo: .init(
      currentPoints: 100,
      currentLevel: .init(
        level: 6,
        name: "새싹 복주머니",
        imageURL: nil
      ),
      pointsToNextLevel: 100
    ),
    receivedRewards: [
      .init(
        id: 1,
        title: "1년 운세",
        iconURL: URL(string: "https://www.freepnglogos.com/uploads/apple-logo-png/apple-logo-png-dallas-shootings-don-add-are-speech-zones-used-4.png"),
        message: "복주머니 lv. 10 달성시 열람 가능해요!"
      ),
      .init(
        id: 2,
        title: "전반적 사주",
        iconURL: URL(string: "https://www.freepnglogos.com/uploads/apple-logo-png/apple-logo-png-dallas-shootings-don-add-are-speech-zones-used-4.png"),
        message: "복주머니 lv. 10 달성시 열람 가능해요!"
      ),
      .init(
        id: 3,
        title: "복합 사주",
        iconURL: URL(string: "https://www.freepnglogos.com/uploads/apple-logo-png/apple-logo-png-dallas-shootings-don-add-are-speech-zones-used-4.png"),
        message: nil
      )
    ]
  )
}

extension RewardInfo {
  struct UserProgressInfo: Equatable {
    let currentPoints: Int
    let currentLevel: LevelInfo
    let pointsToNextLevel: Int
  }
}
