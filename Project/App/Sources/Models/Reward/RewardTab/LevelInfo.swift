//
//  LevelInfo.swift
//  Flifin
//
//  Created by hyerin on 1/11/26.
//

import Foundation

struct LevelInfo: Equatable {
  let level: Int
  let name: String
  let imageURL: URL?
  
  init(
    level: Int,
    name: String,
    imageURL: URL?
  ) {
    self.level = level
    self.name = name
    self.imageURL = imageURL
  }
}

