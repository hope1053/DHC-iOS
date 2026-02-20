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

extension RewardInfo {
  struct UserProgressInfo: Equatable {
    let currentPoints: Int
    let currentLevel: LevelInfo
    let pointsToNextLevel: Int
  }
}
