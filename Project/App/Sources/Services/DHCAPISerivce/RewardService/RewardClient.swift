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
  var createYearlyFortune: @Sendable () async throws -> Void
  var fetchYearlyFortune: @Sendable () async throws -> YearlyFortune
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
      },
      createYearlyFortune: {
        _ = try await networkManager.request(RewardAPI.createYearlyFortune)
      },
      fetchYearlyFortune: {
        try await networkManager
          .request(RewardAPI.yearlyFortune)
          .map(to: YearlyFortuneDTO.self)
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
