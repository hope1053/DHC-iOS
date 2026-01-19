//
//  ShareAPI.swift
//  Flifin
//
//  Created by hyerin on 1/19/26.
//

import Foundation

import Alamofire

enum ShareAPI {
  case createShareCode(userId: String)
}

extension ShareAPI: RequestTarget {
  var path: String {
    switch self {
    case .createShareCode(let userId):
      "/api/users/\(userId)/share"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .createShareCode:
      .post
    }
  }
  
  var headers: HTTPHeaders? {
    switch self {
    case .createShareCode:
      [
        "Content-Type": "application/json"
      ]
    }
  }
  
  var queryParameters: Parameters? {
    switch self {
    case .createShareCode:
      nil
    }
  }
  
  var bodyParameters: (any Encodable)? {
    switch self {
    case .createShareCode:
      nil
    }
  }
}
