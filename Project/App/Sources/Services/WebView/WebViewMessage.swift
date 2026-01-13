//
//  WebViewMessage.swift
//  Flifin
//
//  Created by 최혜린 on 1/11/26.
//

import Foundation

enum WebViewMessage: Equatable, Sendable {
  case close
  case goToMain
  case showToast(String)
  
  static func parse(name: String, body: Any?) -> WebViewMessage? {
    guard name == "DHCJavascriptInterface" else {
      return nil
    }
    
    if let dict = body as? [String: Any],
       let functionName = dict["name"] as? String {
      switch functionName {
      case "close":
        return .close
      case "goToMain":
        return .goToMain
      case "showToast":
        guard let message = dict["body"] as? String else { return nil }
        return .showToast(message)
      default:
        return nil
      }
    }
    
    if let stringBody = body as? String {
      switch stringBody {
      case "close":
        return .close
      case "goToMain":
        return .goToMain
      default:
        return nil
      }
    }
    
    return nil
  }
}

