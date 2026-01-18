//
//  RewardItem.swift
//  Flifin
//
//  Created by hyerin on 1/7/26.
//

import Foundation

struct RewardItem: Identifiable, Equatable {
  let id: Int
  let title: String
  let iconURL: URL?
  let message: String?
  
  init(
    id: Int,
    title: String,
    iconURL: URL?,
    message: String?
  ) {
    self.id = id
    self.title = title
    self.iconURL = iconURL
    self.message = message
  }
}

