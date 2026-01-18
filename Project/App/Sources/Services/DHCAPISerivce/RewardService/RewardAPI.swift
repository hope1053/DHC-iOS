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
}

extension RewardAPI: RequestTarget {
  var path: String {
    switch self {
    case .rewardProgress:
      "/view/users/{userId}/reward-progress"
    }
  }

  var method: HTTPMethod {
    switch self {
    case .rewardProgress:
      .get
    }
  }

  var queryParameters: Parameters? {
    switch self {
    case .rewardProgress:
      nil
    }
  }

  var bodyParameters: (any Encodable)? {
    switch self {
    case .rewardProgress:
      nil
    }
  }
}

