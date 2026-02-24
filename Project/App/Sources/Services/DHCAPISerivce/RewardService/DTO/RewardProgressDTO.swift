//
//  RewardProgressDTO.swift
//  Flifin
//
//  Created by hyerin on 1/15/26.
//

import Foundation

// MARK: - RewardProgressDTO
struct RewardProgressDTO: Decodable {
    let userProgressInfo: UserProgressInfoDTO
    let rewardList: [RewardItemDTO]
    
    enum CodingKeys: String, CodingKey {
        case userProgressInfo = "user"
        case rewardList
    }
}

extension RewardProgressDTO {
  var toDomain: RewardInfo {
    let rewardStatus: RewardStatus = rewardList.first.map { firstItem in
      guard firstItem.isUnlocked else {
        return .notOpened
      }
      return firstItem.isUsed ? .opened : .openable
    } ?? .notOpened
    
    return .init(
      userProgressInfo: userProgressInfo.toDomain,
      totalLevel: 8, // TODO: 현재는 클라에서 총 레벨 관리하는걸로 유지, 추후 서버에서 총 레벨 내려줘야하는 경우 수정 필요,
      rewardStatus: rewardStatus,
      receivedRewards: rewardList.map { $0.toDomain }
    )
  }
}

// MARK: - User
struct UserProgressInfoDTO: Decodable {
    let rewardImageURL: String
    let rewardLevel: RewardLevelDTO
    let totalPoint: Int
    let currentLevelPoint: Int
    let nextLevelRequiredPoint: Int?

    enum CodingKeys: String, CodingKey {
        case rewardImageURL = "rewardImageUrl"
        case rewardLevel, totalPoint, currentLevelPoint, nextLevelRequiredPoint
    }
}

extension UserProgressInfoDTO {
  var toDomain: RewardInfo.UserProgressInfo {
    .init(
      currentPoints: totalPoint,
      currentLevel: .init(
        level: rewardLevel.level,
        name: rewardLevel.name,
        imageURL: URL(string: rewardImageURL)
      ),
      pointsToNextLevel: nextLevelRequiredPoint ?? 0
    )
  }
}

struct RewardLevelDTO: Decodable {
    let level: Int
    let name: String
    let requiredTotalPoint: Int
}

// MARK: - RewardList
struct RewardItemDTO: Decodable {
  let id: Int
  let title: String
  let isUnlocked: Bool
  let isUsed: Bool
  let iconURL: String?
  let message: String?
  let type: RewardItemType
}

extension RewardItemDTO {
  var toDomain: RewardItem {
    .init(
      id: id,
      title: title,
      type: type,
      iconURL: isUnlocked && isUsed ? URL(string: iconURL) : URL.urlForResource(.lock),
      message: message
    )
  }
}
