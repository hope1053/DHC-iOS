//
//  RewardInfo.swift
//  Flifin
//
//  Created by hyerin on 1/11/26.
//

import Foundation

enum RewardStatus {
  case notOpened // 리워드 열 수 없는 상태, 버튼 비활성화
  case openable // 리워드 열 수 있지만 아직 열지 않아서 버튼 활성화된 상태
  case opened // 리워드 열고난 후
}

struct RewardInfo: Equatable {
  let userProgressInfo: UserProgressInfo
  let totalLevel: Int
  let rewardStatus: RewardStatus
  let receivedRewards: [RewardItem]
  
  init(
    userProgressInfo: UserProgressInfo,
    totalLevel: Int = 8,
    rewardStatus: RewardStatus,
    receivedRewards: [RewardItem]
  ) {
    self.userProgressInfo = userProgressInfo
    self.totalLevel = totalLevel
    self.rewardStatus = rewardStatus
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
