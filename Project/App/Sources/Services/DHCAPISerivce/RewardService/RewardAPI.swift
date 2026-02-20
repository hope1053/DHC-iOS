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
}

extension RewardAPI: RequestTarget {
  var path: String {
    switch self {
    case .rewardProgress:
      "/view/users/{userID}/reward-progress"
    case .createYearlyFortune:
      "/api/users/{userID}/yearly-fortune"
    }
  }

  var method: HTTPMethod {
    switch self {
    case .rewardProgress:
      .get
    case .createYearlyFortune:
      .post
    }
  }

  var queryParameters: Parameters? {
    switch self {
    case .rewardProgress:
      nil
    case .createYearlyFortune:
      nil
    }
  }

  var bodyParameters: (any Encodable)? {
    switch self {
    case .rewardProgress:
      nil
    case .createYearlyFortune:
      nil
    }
  }
}
