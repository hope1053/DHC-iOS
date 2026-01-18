//
//  RewardProgressDTO.swift
//  Flifin
//
//  Created by hyerin on 1/15/26.
//

import Foundation

// MARK: - RewardProgressDTO
struct RewardProgressDTO: Codable {
    let userProgressInfo: UserProgressInfoDTO
    let rewardList: [RewardItemDTO]
}

extension RewardProgressDTO {
  var toDomain: RewardInfo {
    .init(
      userProgressInfo: userProgressInfo.toDomain,
      totalLevel: 8, // TODO
      receivedRewards: rewardList.map { $0.toDomain }
    )
  }
}

// MARK: - RewardList
struct RewardItemDTO: Codable {
    let id: Int
    let title: String
}

extension RewardItemDTO {
  var toDomain: RewardItem {
    .init(
      id: id,
      title: title,
      iconURL: nil,
      message: nil
    )
  }
}

// MARK: - User
struct UserProgressInfoDTO: Codable {
    let rewardImageURL, rewardLevel: String
    let totalExp: Int

    enum CodingKeys: String, CodingKey {
        case rewardImageURL = "rewardImageUrl"
        case rewardLevel, totalExp
    }
}

extension UserProgressInfoDTO {
  var toDomain: RewardInfo.UserProgressInfo {
    .init(
      currentPoints: totalExp,
      currentLevel: .init(
        level: 1, // TODO
        name: rewardLevel,
        imageURL: URL(string: rewardImageURL)
      ),
      pointsToNextLevel: 100 // TODO
    )
  }
}
