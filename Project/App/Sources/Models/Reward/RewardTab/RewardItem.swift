//
//  RewardItem.swift
//  Flifin
//
//  Created by hyerin on 1/7/26.
//

import Foundation

enum RewardItemType: String, Decodable {
  case yearlyFortune = "YEARLY_FORTUNE"
}

struct RewardItem: Identifiable, Equatable {
  let id: Int
  let title: String
  let type: RewardItemType
  let iconURL: URL?
  let message: String?
  
  init(
    id: Int,
    title: String,
    type: RewardItemType,
    iconURL: URL?,
    message: String?
  ) {
    self.id = id
    self.title = title
    self.type = type
    self.iconURL = iconURL
    self.message = message
  }
}

