//
//  RewardClient.swift
//  Flifin
//
//  Created by hyerin on 1/15/26.
//

import Foundation

import ComposableArchitecture

@DependencyClient
struct RewardClient {
  var fetchRewardProcess: @Sendable () async throws -> RewardInfo
}

extension RewardClient: DependencyKey {
  static let liveValue: Self = {
    let networkManager = NetworkManager()
    
    return RewardClient(
      fetchRewardProcess: {
        try await networkManager
          .request(RewardAPI.rewardProgress)
          .map(to: RewardProgressDTO.self)
          .toDomain
      }
    )
  }()

  static let previewValue = Self()
  static let testValue = Self()
}

extension DependencyValues {
  var rewardClient: RewardClient {
    get { self[RewardClient.self] }
    set { self[RewardClient.self] = newValue }
  }
}

