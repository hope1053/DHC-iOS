//
//  RewardAPI.swift
//  Flifin
//
//  Created by hyerin on 1/15/26.
//

import Foundation

import Alamofire

enum RewardAPI {
  case rewardProgress
  case createYearlyFortune
  case yearlyFortune
}

extension RewardAPI: RequestTarget {
  var path: String {
    switch self {
    case .rewardProgress:
      "/view/users/{userID}/reward-progress"
    case .createYearlyFortune:
      "/api/users/{userID}/yearly-fortune"
    case .yearlyFortune:
      "/view/users/{userID}/yearly-fortune"
    }
  }

  var method: HTTPMethod {
    switch self {
    case .rewardProgress:
      .get
    case .createYearlyFortune:
      .post
    case .yearlyFortune:
      .get
    }
  }

  var queryParameters: Parameters? {
    switch self {
    case .rewardProgress:
      nil
    case .createYearlyFortune:
      nil
    case .yearlyFortune:
      nil
    }
  }

  var bodyParameters: (any Encodable)? {
    switch self {
    case .rewardProgress:
      nil
    case .createYearlyFortune:
      nil
    case .yearlyFortune:
      nil
    }
  }
}
